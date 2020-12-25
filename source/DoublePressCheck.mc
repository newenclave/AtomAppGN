

class DoublePressCheck {

    private var _triggerTime = 0;
    private var _timeout = -1;

    function initialize(timeout) {
        self._timeout = timeout;
    }

    function press() {
        var now = System.getTimer();
        if(now - self._triggerTime < self._timeout) {
            return true;
        }
        self._triggerTime = now;
        return false;
    }
}