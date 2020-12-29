using Toybox.BluetoothLowEnergy as Ble;

class CharacteristicSearchSpeed extends CharacteristicIface {

    private var _currentValue;
    private var _writeSpeedRequest;
    private var _uuid;

    function initialize(queue, controller, uuid) {
        CharacteristicIface.initialize(queue, controller);
        self._currentValue = 1;
        self._writeSpeedRequest = -1;
        self._uuid = uuid;
    }

    function getValue() {
        return self._currentValue;
    }

    function writeSpeed(val) {
        self._writeSpeedRequest = val;
        self.write([], []);
    }

    function readSpeed() {
        switch(self.getState()) {
        case STATE_UNKNOWN:
        case STATE_COLD:
            if(self._writeSpeedRequest == -1) {
                self.read([], []);
            } else {
                self.write([], []);
            }
            break;
        case STATE_WRITING:
            break;
        case STATE_READING:
            break;
        }
    }

    private function getServie() {
        if(self._controller.stillAlive()) {
            return self._controller.get().getBleService();
        } else {
            return null;
        }
    }

    function writeImpl(param) {
        var val = self._writeSpeedRequest;
        var data = [0xE0, val, 0, 0, 0, 0, 0, 0]b;
        return self.writeData(self._uuid, data);
    }

    function onWriteImpl(param, bleParams) {
        self._currentValue = self._writeSpeedRequest;
        self._writeSpeedRequest = -1;
        System.println("Speed saved. " + bleParams[1].toString());
        return true;
    }

    function readImpl(param) {
        return self.readData(self._uuid);
    }

    function onReadImpl(param, bleParams) {
        if(bleParams[2].size() >=4) {
            self._currentValue = (bleParams[2][3] >> 5) & 3;
            System.println("Got speed value: " + self._currentValue.toString());
        }
        return true;
    }
}
