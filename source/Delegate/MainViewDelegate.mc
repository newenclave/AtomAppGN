using Toybox.WatchUi as Ui;

class MainViewDelegate extends Ui.BehaviorDelegate {

    private var _app;

    function initialize(app) {
        BehaviorDelegate.initialize();
        self._app = app;
    }

    function onMenu() {
        self._app.getViewController().pushMainManu();
        return true;
    }
}
