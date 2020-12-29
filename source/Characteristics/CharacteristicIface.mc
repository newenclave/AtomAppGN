
class CharacteristicIface {

    enum {
        STATE_UNKNOWN,
        STATE_COLD,
        STATE_READING,
        STATE_WRITING,
    }

    protected var _queue;
    protected var _state;

    function initialize(queue) {
        self._queue = queue;
        self._state = STATE_UNKNOWN;
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
