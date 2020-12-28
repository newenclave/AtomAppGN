using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;

class DeviceDataController {

    private var _app;
    private var _dataModel;
    private var _activityTrack;
    private var _device;
    private var _scanResult;
    private var _service;
    private var _ready;
    private var _posProvider;
    private var _alerts;
    private var _searchSpeed;
    private var _operations;
    private var _writeSpeedRequested;

    enum {
        SEARCH_UNKNOWN = -1,
        SEARCH_FAST = 0,
        SEARCH_MEDIUM = 1,
        SEARCH_SLOW = 2,
    }

    function initialize(app, scanResult) {
        self._app = app;
        self._dataModel = new DeviceDataModel();
        self._scanResult = scanResult;
        self._posProvider = new PositionProvider();
        self._alerts = new AlertsProvider();
        self._searchSpeed = SEARCH_MEDIUM;
        self._operations = new OperationsQueue();
        self._writeSpeedRequested = SEARCH_UNKNOWN;
        self.start();
    }

    /// Get data values
    function getSearchSpeed() {
        return self._searchSpeed;
    }

    function setSearchSpeed(val) {
        System.println("Set Speed " + val.toString());
        var oldVar = self._writeSpeedRequested;
        self._writeSpeedRequested = val;
        if(oldVar == SEARCH_UNKNOWN && self._ready) {
            System.println(self._operations.size());
            if(0 == self._operations.push(method(:writeSpeed), [], method(:onWriteSpeed), [])) {
                self._operations.callTop([]);
            }
        }
    }

    function getDoseAccumulated() {
        return self._dataModel.doseAccumulated * self.getDoseFactor();
    }

    function getDoseRate() {
        return self._dataModel.doseRate * self.getDoseFactor();
    }

    function getImpulses() {
        return self._dataModel.impulses;
    }

    function getCharge() {
        return self._dataModel.charge;
    }

    function getTemperature() {
        return self.convertTemp(self._dataModel.temperature);
    }

    function getThreshold(id) {
        return self._dataModel.thresholds[id].threshold * self.getDoseFactor();
    }

    function isThresholdUpdated(id) {
        return self._dataModel.thresholds[id].updated;
    }

    function getThresholdAccumulated(id) {
        return self._dataModel.thresholds[id].thresholdAccumulated * self.getDoseFactor();
    }

    ///////////////////
    function getProperty(name, defaultValue) {
        return self.getProperties().getProperty(name, defaultValue);
    }

    function setProperty(name, value) {
        self.getProperties().setProperty(name, value);
    }

    private function getDoseFactor() {
        if(self.getProperties().getUseRoentgen()) {
            return 100;
        } else {
            return 1;
        }
    }

    function getTemperatureUnitsString() {
        if(self.getProperties().getUseFahrenheit()) {
            return Application.loadResource(Rez.Strings.text_micro_fahrenheit);
        } else {
            return Application.loadResource(Rez.Strings.text_temp_celsius);
        }
    }

    function convertTemp(value) {
        if(self.getProperties().getUseFahrenheit()) {
            return (value * 1.8 + 32).toNumber();
        } else {
            return value;
        }
    }

    function getDoseUnitString() {
        if(self.getProperties().getUseRoentgen()) {
            return Application.loadResource(Rez.Strings.text_micro_roentgen);
        } else {
            return Application.loadResource(Rez.Strings.text_micro_sieverts);
        }
    }

    function getDoseHoursUnitString() {
        if(self.getProperties().getUseRoentgen()) {
            return Application.loadResource(Rez.Strings.text_micro_roentgen_hours);
        } else {
            return Application.loadResource(Rez.Strings.text_micro_sieverts_hours);
        }
    }

    function checkAlerts() {
        var ths = self._dataModel.thresholds;
        for(var i=2; i >= 0; i--) {
            if(ths[i].updated
                && self.getProperties().getAlertVibroL(i)
                && (self._dataModel.doseRate > ths[i].threshold)) {
                self._alerts.alertVibroL(i);
                break;
            }
        }
    }

    function getDoseAccumelatedThreshold() {
        var ths = self._dataModel.thresholds;
        for(var i=2; i >= 0; i--) {
            if(ths[i].updated && (self._dataModel.doseAccumulated > ths[i].thresholdAccumulated)) {
                return i;
            }
        }
        return -1;
    }

    function getDoseThreshold() {
        var ths = self._dataModel.thresholds;
        for(var i=2; i >= 0; i--) {
            if(ths[i].updated && (self._dataModel.doseRate > ths[i].threshold)) {
                return i;
            }
        }
        return -1;
    }

    function getMeasuringTime() {
        return self._dataModel.getMeasuringTime();
    }

    function getCPM() {
        return self._dataModel.getCPM();
    }

    function isCharging() {
        return self._dataModel.isCharging();
    }

    function getSessionDoze() {
        return self._dataModel.getSessionDoze();
    }

    private function getProperties() {
        return self._app.getPropertiesProvider();
    }

    /////////
    function getService(device) {
        self._service = device.getService(self._app.getProfile().ATOM_FAST_SERVICE);
        if(null == self._service) {
            System.println("Unable to get service");
            return false;
        }
        return true;
    }

    function activityUpdateState() {
        var props = self.getProperties();
        if(props.getWriteActivity()) {
            self.startActivityWrite();
        } else {
            self.stopActivityWrite();
        }
    }

    function startActivityWrite() {
        var props = self.getProperties();
        if(self._activityTrack == null) {
            self._activityTrack = new FitDataProvider();
            if(props.getUseActivityLocation()) {
                self._posProvider.enable();
            }
        }
    }

    function stopActivityWrite() {
        if(self._activityTrack != null) {
            self._activityTrack.closeSession({
                :sessionDose => self._dataModel.getSessionDoze()
            });
            self._activityTrack.stopAndSave();
            self._posProvider.disable();
            self._activityTrack = null;
        }
    }

    function updateFitData() {
        self.activityUpdateState();
        if(self._activityTrack != null) {
            self._activityTrack.update({
                :doseRate => self._dataModel.doseRate,
                :temperature => self._dataModel.temperature,
            });
        }
    }

    function activateNextNotification() {
        System.println("Notifications activate");
        if(null == self._service) {
            System.println("NULL service!");
        }
        var char = self._service.getCharacteristic(self._app.getProfile().ATOM_FAST_CHAR);
        if(null != char) {
            var cccd = char.getDescriptor(Ble.cccdUuid());
            cccd.requestWrite([0x01, 0x00]b);
        } else {
            System.println("Bad character");
        }
    }

    function notificationsReady(descriptor, status) {
        System.println("Notifications ready");
        self._ready = true;
        self._dataModel.resetTimer();
        self.storeLastDevice();
        return true;
    }

    function start() {
        try {
            self._device = Ble.pairDevice(self._scanResult);
            self._app.getBleDelegate().setEventListener(self);
        } catch(ex) {
            self._device = null;
        }
        self._ready = false;
    }

    private function reinit() {
        self._operations.clear();
        if(self.getService(self._device)) {
            self._operations.push(method(:activateNextNotification), [], method(:notificationsReady), []);
            self._operations.push(method(:readThreashold), [0], method(:threasholdReady), [0]);
            self._operations.push(method(:readThreashold), [1], method(:threasholdReady), [1]);
            self._operations.push(method(:readThreashold), [2], method(:threasholdReady), [2]);
            if(self._writeSpeedRequested != SEARCH_UNKNOWN) {
                self._operations.push(method(:writeSpeed), [], method(:onWriteSpeed), []);
            } else {
                self._operations.push(method(:readSpeed), [], method(:onReadSpeed), []);
            }
            self._operations.callTop([]);
        }
        Ui.requestUpdate();
    }

    function stop() {
        if(null != self._device) {
            Ble.unpairDevice(self._device);
            self._device = null;
            self.stopActivityWrite();
        }
    }

    function readSpeed() {
        if(self._writeSpeedRequested == SEARCH_UNKNOWN) {
            var char = self._service.getCharacteristic(self._app.getProfile().ATOM_FAST_CONFIG_CHAR);
            if(char) {
                char.requestRead();
            }
        } else {
            System.println("Not needed. Speed is about to change");
            self._operations.pop();
            self._operations.callTop([]);
        }
    }

    function onReadSpeed(characteristic, status, value) {
        if(value.size() >=4) {
            self._searchSpeed = (value[3] >> 5) & 3;
            System.println(self._searchSpeed.toString());
        }
        return true;
    }

    function writeSpeed() {
        var val = self._writeSpeedRequested;
        var char = self._service.getCharacteristic(self._app.getProfile().ATOM_FAST_CONFIG_CHAR);
        if(char) {
            var data = [0xE0, val, 0, 0, 0, 0, 0, 0]b;
            char.requestWrite(data, {:writeType => Ble.WRITE_TYPE_WITH_RESPONSE});
        }
    }

    function onWriteSpeed(characteristic, status) {
        self._searchSpeed = self._writeSpeedRequested;
        self._writeSpeedRequested = SEARCH_UNKNOWN;
        System.println("Speed saved. " + status.toString());
        return true;
    }

    function readThreashold(id) {
        var uuid = self._app.getProfile().THRESHOLDS[id];
        var char = self._service.getCharacteristic(uuid);
        if(char) {
            char.requestRead();
        } else {
            System.println("Bad chararteristic. " + uuid.toString());
        }
    }

    function threasholdReady(characteristic, status, value, id) {
        self._dataModel.updateThreashold(id, value);
        return true;
    }

    function getReady() {
        return self._ready;
    }

    private function storeLastDevice() {
        try {
            self._app.setValue("LastConnectedDevice", self._scanResult);
        } catch(ex) {
            System.println("Unable to save last device. " + ex.getErrorMessage());
        }
    }

    /// On Connect
    function onConnectedStateChanged(device, state) {
        System.println("On Connect " + state.toString());
        if(device != self._device) {

        } else if (!self._device.isConnected()) {
            self._ready = false;
        } else {
            self.reinit();
        }
    }

    /// Descriptop Write request
    function onDescriptorWrite(descriptor, status) {
        System.println("onDescriptorWrite " + self._operations.size());
        if(Ble.cccdUuid().equals(descriptor.getUuid())) {
            if(self._operations.callbackTop([descriptor, status])) {
                self._operations.pop();
                self._operations.callTop([]);
            }
        }
    }

    // Write request
    function onCharacteristicWrite(characteristic, status) {
        System.println("onCharacteristicWrite " + self._operations.size());
        if(self._operations.callbackTop([characteristic, status])) {
            self._operations.pop();
            self._operations.callTop([]);
        }
    }

    // read request
    function onCharacteristicRead(characteristic, status, value) {
        System.println("onCharacteristicRead " + characteristic.toString());
        if(status != Ble.STATUS_SUCCESS || null == value) {
            System.println("Failed to read " + characteristic.toString());
            return;
        }
        if(self._operations.callbackTop([characteristic, status, value])) {
            self._operations.pop();
            self._operations.callTop([]);
        }
    }

    function onCharacteristicChanged(char, value) {
        switch(char.getUuid()) {
            case self._app.getProfile().ATOM_FAST_CHAR:
                self._dataModel.update(value);
                self.updateFitData();
                self.checkAlerts();
                Ui.requestUpdate();
                break;
        }
    }
}

