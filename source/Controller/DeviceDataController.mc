using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;

class DeviceDataController {

    private var _app;
    private var _dataModel;
    private var _activityTrack;
    private var _device;
    private var _scanResult;
    private var _service;
    private var _pendingNotifies;
    private var _ready;
    private var _updateThresholds = true;
    private var _posProvider;
    private var _alerts;

    function initialize(app, scanResult) {
        self._app = app;
        self._dataModel = new DeviceDataModel();
        self._scanResult = scanResult;
        self._posProvider = new PositionProvider();
        self._alerts = new AlertsProvider();
        self.start();
    }

    /// Get data values
    function getDoseAccumulated() {
        return self._dataModel.doseAccumulated * self.getDoseFactor();
    }

    function getDosePower() {
        return self._dataModel.dosePower * self.getDoseFactor();
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

    function checkAlerts() {
        var ths = self._dataModel.thresholds;
        for(var i=2; i >= 0; i--) {
            if(ths[i].updated
                && self.getProperties().getAlertVibroL(i)
                && (self._dataModel.dosePower > ths[i].threshold)) {
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
            if(ths[i].updated && (self._dataModel.dosePower > ths[i].threshold)) {
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

    function onConnectedStateChanged(device, state) {
        if(self._device != device) {
            return;
        }
        if(!self._device.isConnected()) {
            return;
        }

        self._pendingNotifies = [];
        if(null != self._device) {
            self.getService(self._device);
            self.activateNextNotification();
        }
        Ui.requestUpdate();
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
            System.println("Session summary: "
                + self._dataModel.doseAccumulated.toString()
                + " " + self._dataModel.sessionDoseInit.toString());
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
                :dosePower => self._dataModel.dosePower,
                :temperature => self._dataModel.temperature,
            });
        }
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

    function stop() {
        if(null != self._device) {
            Ble.unpairDevice(self._device);
            self._device = null;
            System.println("STOP!!");
            self.stopActivityWrite();
        }
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

    function ready() {
        return self._ready;
    }

    function getService(device) {
        self._service = device.getService(self._app.getProfile().ATOM_FAST_SERVICE);
        if(null != self._service) {
            var char = self._service.getCharacteristic(self._app.getProfile().ATOM_FAST_CHAR);
            if(char) {
                self._pendingNotifies = self._pendingNotifies.add(char);
                self._ready = true;
                self._dataModel.resetTimer();
                self.storeLastDevice();
            }
        }
    }

    private function storeLastDevice() {
        try {
            self._app.setValue("LastConnectedDevice", self._scanResult);
        } catch(ex) {
            System.println("Unable to save last device. " + ex.getErrorMessage());
        }
    }

    private function activateNextNotification() {
        if( self._pendingNotifies.size() == 0 ) {
            return;
        }
        var char = _pendingNotifies[0];
        var cccd = char.getDescriptor(Ble.cccdUuid());
        cccd.requestWrite([0x01, 0x00]b);
    }

    function onCharacteristicWrite(characteristic, status) {
    }

    function onCharacteristicRead(characteristic, status, value) {
        if(status != Ble.STATUS_SUCCESS || null == value) {
            System.println("Failed to read " + characteristic.toString());
            return;
        }
        var th = self._app.getProfile().THRESHOLDS;
        switch(characteristic.getUuid()) {
        case th[0]:
            self._dataModel.updateThreashold(0, value);
            self.readThreashold(1);
            break;
        case th[1]:
            self._dataModel.updateThreashold(1, value);
            self.readThreashold(2);
            break;
        case th[2]:
            self._dataModel.updateThreashold(2, value);
            self.activateNextNotification();
            break;
        }
    }

    function onCharacteristicChanged(char, value) {
        if(self._updateThresholds) {
            self.readThreashold(0);
            self._updateThresholds = false;
        }
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

