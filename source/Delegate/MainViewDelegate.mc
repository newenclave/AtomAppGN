using Toybox.WatchUi as Ui;

class MainViewDelegate extends Ui.BehaviorDelegate {

    private var _app;
    private var _selectDoublePress;

    function initialize(app) {
        BehaviorDelegate.initialize();
        self._app = app;
        self._selectDoublePress = new DoublePressCheck(500);
    }

    function onSelect() {
        if(self._selectDoublePress.press()) {
            self._app.scanStart();
            self._app.getViewController().pushScanView(true);
            return true;
        }
        return false;
    }

    function onMenu() {
        self._app.getViewController().pushMainManu();
        return true;
    }
}
