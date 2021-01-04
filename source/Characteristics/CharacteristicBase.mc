using Toybox.BluetoothLowEnergy as Ble;

class CharacteristicBase {

    enum {
        STATE_UNKNOWN,
        STATE_COLD,
        STATE_READING,
        STATE_WRITING,
    }

    protected var _queue;
    protected var _controller;
    protected var _state;

    function initialize(queue, controller) {
        self._queue = queue;
        self._controller = controller.weak();
        self._state = STATE_UNKNOWN;
    }

    protected function getServie() {
        if(self._controller.stillAlive()) {
            return self._controller.get().getBleService();
        } else {
            return null;
        }
    }

    protected function readData(uuid) {
        var service = self.getServie();
        if(null != service) {
            var char = service.getCharacteristic(uuid);
            if(char) {
                char.requestRead();
                return true;
            }
        }
        return false;
    }

    protected function writeData(uuid, data) {
        var service = self.getServie();
        if(null != service) {
            var char = service.getCharacteristic(uuid);
            if(char) {
                char.requestWrite(data, {:writeType => Ble.WRITE_TYPE_DEFAULT});
                return true;
            }
        }
        return false;
    }

    function writeImpl(param) {
        return false;
    }
    function onWriteImpl(param, bleParams) {
        return true;
    }

    function readImpl(param) {
        return false;
    }
    function onReadImpl(param, bleParams) {
        return true;
    }

    function getState() {
        return self._state;
    }

    function isCold() {
        return self._state == STATE_COLD;
    }

    function write(param, cbParams) {
        if(self._state != STATE_WRITING) {
            self._state = STATE_WRITING;
            self._queue.pushAndStart(method(:writeImplCall), param, method(:onWrite), cbParams);
        }
    }

    function read(param, cbParams) {
        if(self._state <= STATE_COLD) {
            self._state = STATE_READING;
            self._queue.pushAndStart(method(:readImplCall), param, method(:onRead), cbParams);
        }
    }

    protected function pushRead(param, cbParams) {
        self._queue.push(method(:readImplCall), param, method(:onRead), cbParams);
    }

    protected function pushWrite(param, cbParams) {
        self._queue.pushAndStart(method(:writeImplCall), param, method(:onWrite), cbParams);
    }

    function readImplCall(cbParams) {
        if(self.readImpl(cbParams)) {
            self._state = STATE_COLD;
        } else {
            self._state = STATE_UNKNOWN;
            self._queue.pop();
        }
    }

    function writeImplCall(cbParams) {
        if(self.writeImpl(cbParams)) {
            self._state = STATE_COLD;
        } else {
            self._state = STATE_UNKNOWN;
            self._queue.pop();
        }
    }

    function onWrite(cbParams, bleParams) {
        self._state = STATE_COLD;
        return onWriteImpl(cbParams, bleParams);
    }

    function onRead(cbParams, bleParams) {
        self._state = STATE_COLD;
        return onReadImpl(cbParams, bleParams);
    }
}
