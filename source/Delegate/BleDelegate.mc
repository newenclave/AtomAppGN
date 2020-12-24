 using Toybox.BluetoothLowEnergy as Ble;

class BleDelegate extends Ble.BleDelegate {

    private var _app;
    private var _eventListener;

    function initialize(app) {
        BleDelegate.initialize();
        self._app = app;
    }

    function setEventListener(iface) {
        self._eventListener = iface.weak();
    }

    private function isListenerAlive(symbol) {
        var res = (null != self._eventListener)
            && self._eventListener.stillAlive()
            && self._eventListener.get() has symbol;
        //System.println("Result for " + symbol.toString() + " " + res.toString());
        return res;
    }

    function onCharacteristicChanged(characteristic, value) {
        if(self.isListenerAlive(:onCharacteristicChanged)) {
            self._eventListener.get().onCharacteristicChanged(characteristic, value);
        }
    }

    function onCharacteristicRead(characteristic, status, value) {
        if(self.isListenerAlive(:onCharacteristicRead)) {
            self._eventListener.get().onCharacteristicRead(characteristic, status, value);
        }
    }

    function onCharacteristicWrite(characteristic, status) {
        if(self.isListenerAlive(:onCharacteristicWrite)) {
            self._eventListener.get().onCharacteristicWrite(characteristic, status);
        }
    }

    function onConnectedStateChanged(device, state) {
        if(self.isListenerAlive(:onConnectedStateChanged)) {
            self._eventListener.get().onConnectedStateChanged(device, state);
        }
    }

    function onDescriptorRead(descriptor, status, value) {
        if(self.isListenerAlive(:onDescriptorRead)) {
            self._eventListener.get().onDescriptorRead(descriptor, status, value);
        }
    }

    function onDescriptorWrite(descriptor, status) {
        if(self.isListenerAlive(:onDescriptorWrite)) {
            self._eventListener.get().onDescriptorWrite(descriptor, status);
        }
    }

    function onProfileRegister(uuid, status) {
        if(self.isListenerAlive(:onProfileRegister)) {
            self._eventListener.get().onProfileRegister(uuid, status);
        }
    }

    function onScanResults(scanResults) {
        if(self.isListenerAlive(:onScanResults)) {
            self._eventListener.get().onScanResults(scanResults);
        }
    }

    function onScanStateChange(scanState, status) {
        if(self.isListenerAlive(:onScanStateChange)) {
            self._eventListener.get().onScanStateChange(scanState, status);
        }
    }

}
