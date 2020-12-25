using Toybox.Position;

class PositionProvider {

    private var _lastKnownPosition = null;

    function initialize() {
    }

    public function enable() {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, self.method(:onPosition));
    }

    public function disable() {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    public function onPosition(info) {
        self._lastKnownPosition = info;
    }
}

