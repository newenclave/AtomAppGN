using Toybox.Application as App;

class ColorSelector {
    static const COLORS = Colors.COLORS_14;
    private var _current;
    function initialize() {
        var dev = App.getApp().getDeviceStorage().getCurrent();
        self._current = (COLORS.size() / 2).toNumber();
        if(null != dev) {
            for(var i=0; i<self.COLORS.size(); i++) {
                if(dev.getColor() == self.COLORS[i]) {
                    self._current = i;
                    break;
                }
            }
        }
    }

    function next() {
        self._current += 1;
        self._current %= self.COLORS.size();
    }

    function prev() {
        self._current -= 1;
        if(self._current < 0) {
            self._current = self.getSize() - 1;
        }
    }

    function getSize() {
        return self.COLORS.size();
    }

    function getCurrentId() {
        return self._current;
    }

    function getCurrentColor() {
        return self.COLORS[self._current];
    }
}
