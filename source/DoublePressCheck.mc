

class DoublePressCheck {

    private var _triggerTime = 0;
    private var _timeout = -1;

    function initialize(timeout) {
        self._timeout = timeout;
        self._triggerTime = System.getTimer();
    }

    function press() {
        var now = System.getTimer();
        if((now - self._triggerTime) < self._timeout) {
            self._triggerTime = (now - self._timeout - 1);
            return true;
        }
        self._triggerTime = now;
        return false;
    }
}