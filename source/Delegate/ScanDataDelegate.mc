using Toybox.WatchUi as Ui;

class ScanDataDelegate extends Ui.BehaviorDelegate {

    private var _app;
    private var _scanDataController;

    function initialize(app, scanDataController) {
        BehaviorDelegate.initialize();
        self._app = app;
        self._scanDataController = scanDataController;
    }

    function onBack() {
        self._app.scanStop();
        return false;
    }

    function onMenu() {
        return true;
    }

    function onNextMode() {
        return true;
    }

    function onNextPage() {
        self._scanDataController.getModel().next();
        Ui.requestUpdate();
        return true;
    }

    function onPreviousMode() {
        return true;
    }

    function onPreviousPage() {
        self._scanDataController.getModel().prev();
        Ui.requestUpdate();
        return true;
    }

    function onSelect() {
        var cur = self._scanDataController.getModel().getCur();
        if(null != cur) {
            self._app.scanStop();
            self._app.getViewController().switchDeviceView(cur);
        }
        return true;
    }
}