using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;

class DeviceDataController {

    private var _app;
    private var _dataModel;
    private var _device;
    private var _scanResult;
    private var _service;
    private var _pendingNotifies;
    private var _ready;
    private var _updateThresholds = true;

    function initialize(app, scanResult) {
        self._app = app;
        self._dataModel = new DeviceDataModel();
        self._scanResult = scanResult;
        self.pair();
    }

    function getModel() {
        return self._dataModel;
    }

    function getDoseFactor() {
        return self._app.getPropertiesProvider().getDoseFactor();
    }

    function getDoseUnitString() {
        return self._app.getPropertiesProvider().getDoseUnitString();
    }

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

    function pair() {
        try {
            self._device = Ble.pairDevice(self._scanResult);
            self._app.getBleDelegate().setEventListener(self);
        } catch(ex) {
            self._device = null;
        }
        self._ready = false;
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

    function unpair() {
        if(null != self._device) {
            Ble.unpairDevice(self._device);
            self._device = null;
        }
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
                Ui.requestUpdate();
                break;
        }
    }
}

