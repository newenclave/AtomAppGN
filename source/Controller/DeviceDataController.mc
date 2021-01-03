using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DeviceDataController {

    private var _dataModel;
    private var _activityTrack;
    private var _device;
    private var _scanResult;
    private var _service;
    private var _ready;
    private var _posProvider;
    private var _alerts;
    private var _operations;
    private var _charSearchSpeed;
    private var _charThreasholds;
    private var _charCalibration;
    private var _charAddition;
    private var _useSigma;
    private var _measuring;

    function initialize(scanResult) {
        self._dataModel = new DeviceDataModel();
        self._scanResult = scanResult;
        self._posProvider = new PositionProvider();
        self._alerts = new AlertsProvider();
        self._operations = new OperationsQueue();
        self._measuring = new MeasuringModel(self);
        self._useSigma = App.getApp().getPropertiesProvider().getUsedSigma();

        var pm = App.getApp().getProfile();
        self._charSearchSpeed = new CharacteristicSearchSpeed(
                                        self._operations, self,
                                        pm.ATOM_FAST_CONFIG_CHAR);
        self._charThreasholds = new CharacteristicThresholds(self._operations, self, [
                                        pm.ATOM_FAST_THRESHOSD1,
                                        pm.ATOM_FAST_THRESHOSD2,
                                        pm.ATOM_FAST_THRESHOSD3
                                    ]);
        self._charCalibration = new CharacteristicCalibration(
                                        self._operations, self,
                                        pm.ATOM_FAST_CALIBRATION_CHAR);
        self._charAddition = new CharacteristicAddition(self._operations, self,
                                        pm.ATOM_FAST_CHAR2);
        self.start();
    }

    private function getApp() {
        return App.getApp();
    }

    /// Get data values

    function getDeviceSens() {
        return self._charCalibration.getDevSens();
    }

    function getMeasuringDose() {
        return self._measuring.dosePower * self.getDoseFactor();
    }

    function getMeasuringData() {
        return self._measuring;
    }

    function getUsedSigma() {
        return self._useSigma;
    }

    function setUsedSigma(val) {
        self._useSigma = val;
        App.getApp().getPropertiesProvider().setUsedSigma(val);
    }

    function getSearchSpeed() {
        return self._charSearchSpeed.getValue();
    }

    function setSearchSpeed(val) {
        self._charSearchSpeed.writeSpeed(val);
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
        return self._charThreasholds.getValue(id).threshold * self.getDoseFactor();
    }

    function isThresholdUpdated(id) {
        return self._charThreasholds.getValue(id).updated;
    }

    function getThresholdAccumulated(id) {
        return self._charThreasholds.getValue(id).thresholdAccumulated * self.getDoseFactor();
    }

    ///////////////////

    function getSearchError() {
        var sId = self.getSearchSpeed();
        var fsmConst = self._charAddition.getValue(sId);
        var sError = self._charAddition.getErrorValue(sId);
        if(self.getImpulses() > fsmConst && self.getImpulses() > 0) {
            sError = 100.0 / Math.sqrt(self.getImpulses().toFloat());
        }
        return Math.round(sError * (self._useSigma + 1)); // parameter _useSigma is 0-based
    }

    function getProperty(name, defaultValue) {
        return self.getProperties().getProperty(name, defaultValue);
    }

    function getBleService() {
        return self._service;
    }

    function getQueue() {
        return self._operations;
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
        var ths = self._charThreasholds.getValues();
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
        var ths = self._charThreasholds.getValues();
        for(var i=2; i >= 0; i--) {
            if(ths[i].updated && (self._dataModel.doseAccumulated > ths[i].thresholdAccumulated)) {
                return i;
            }
        }
        return -1;
    }

    function getDoseThreshold() {
        var ths = self._charThreasholds.getValues();
        for(var i=2; i >= 0; i--) {
            if(ths[i].updated && (self._dataModel.doseRate > ths[i].threshold)) {
                return i;
            }
        }
        return -1;
    }

    function getDataModel() {
        return self._dataModel;
    }

    function getMeasuringTime() {
        return self._dataModel.getMeasuringTime();
    }

    function getMeasureSessionTime() {
        return self._measuring.getElapsedTime();
    }

    function getCPM() {
        return self._dataModel.getCPM();
    }

    function getCPS() {
        return self._dataModel.getCPS();
    }

    function isCharging() {
        return self._dataModel.isCharging();
    }

    function getSessionDoze() {
        return self._dataModel.getSessionDoze();
    }

    private function getProperties() {
        return self.getApp().getPropertiesProvider();
    }

    /////////
    function getService(device) {
        self._service = device.getService(self.getApp().getProfile().ATOM_FAST_SERVICE);
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

    function activateNextNotification(param) {
        //System.println("Notifications activate");
        if(null == self._service) {
            System.println("NULL service!");
        }
        var char = self._service.getCharacteristic(self.getApp().getProfile().ATOM_FAST_CHAR);
        if(null != char) {
            var cccd = char.getDescriptor(Ble.cccdUuid());
            cccd.requestWrite([0x01, 0x00]b);
        } else {
            System.println("Bad character");
        }
    }

    function notificationsReady(passed, callbackParams) {
        //System.println("Notifications ready");
        self._ready = true;
        self._dataModel.resetTimer();
        self.storeLastDevice();
        return true;
    }

    function start() {
        try {
            self._device = Ble.pairDevice(self._scanResult);
            self.getApp().getBleDelegate().setEventListener(self);
        } catch(ex) {
            self._device = null;
        }
        self._ready = false;
    }

    private function reinit() {
        self._operations.clear();
        if(self.getService(self._device)) {
            self._operations.push(method(:activateNextNotification), [], method(:notificationsReady), []);
            self._operations.callTop();
            self._charSearchSpeed.update();
            self._charAddition.update();
            self._charCalibration.update();
            self._charThreasholds.update();
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

    function getReady() {
        return self._ready;
    }

    private function storeLastDevice() {
        try {
            self.getApp().setValue("LastConnectedDevice", self._scanResult);
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
                self._operations.callTop();
            }
        }
    }

    // Write request
    function onCharacteristicWrite(characteristic, status) {
        System.println("onCharacteristicWrite " + self._operations.size());
        if(self._operations.callbackTop([characteristic, status])) {
            self._operations.pop();
            self._operations.callTop();
        }
    }

    // read request
    function onCharacteristicRead(characteristic, status, value) {
        if(status != Ble.STATUS_SUCCESS || null == value) {
            System.println("Failed to read " + characteristic.toString());
            return;
        }
        if(self._operations.callbackTop([characteristic, status, value])) {
            self._operations.pop();
            self._operations.callTop();
        }
    }

    function onCharacteristicChanged(char, value) {
        switch(char.getUuid()) {
            case self.getApp().getProfile().ATOM_FAST_CHAR:
                self._dataModel.update(value);
                self.checkAlerts();
                self.updateFitData();
                self.getMeasuringData().update(self);
                Ui.requestUpdate();
                break;
        }
    }
}

