using Toybox.BluetoothLowEnergy as Ble;
using Toybox.Application as App;

class BleDelegate extends Ble.BleDelegate {

    private var _eventListener;
    private var _scanListener;

    function initialize() {
        BleDelegate.initialize();
        self._eventListener = null;
        self._scanListener = null;
    }

    function setEventListener(iface) {
        self._eventListener = iface.weak();
        System.println("event for " + iface.toString());
    }

    function setScanListener(iface) {
        self._scanListener = iface.weak();
        System.println("scan for " + iface.toString());
    }

    function isListenerAlive(symbol) {
        return self._isListenerAlive(self._eventListener, symbol);
    }

    function isScanListenerAlive(symbol) {
        return self._isListenerAlive(self._scanListener, symbol);
    }

    private function _isListenerAlive(listener, symbol) {
        var res = (null != listener)
                && listener.stillAlive()
                && (listener.get() has symbol);
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
        System.println("Profile register: '" + uuid.toString() + "' " + status.toString());
        if(self.isListenerAlive(:onProfileRegister)) {
            self._eventListener.get().onProfileRegister(uuid, status);
        }
    }

    function onScanResults(scanResults) {
        if(self.isScanListenerAlive(:onScanResults)) {
            self._scanListener.get().onScanResults(scanResults);
        }
    }

    function onScanStateChange(scanState, status) {
        if(self.isScanListenerAlive(:onScanStateChange)) {
            self._scanListener.get().onScanStateChange(scanState, status);
        }
    }

}
