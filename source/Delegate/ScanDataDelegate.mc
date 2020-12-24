using Toybox.WatchUi as Ui;

class ScanDataDelegate extends Ui.BehaviorDelegate {

    private var _app;
    private var _scanDataController;
    private var _useFirst = false;

    function initialize(app, scanDataController, options) {
        BehaviorDelegate.initialize();
        self._app = app;
        self._scanDataController = scanDataController;
        self._scanDataController.setUpdateListener(self);
        if(options.hasKey(:useFirst)) {
            self._useFirst = options.get(:useFirst);
        }
    }

    function onNewDataUpdate() {
        if(self._useFirst) {
            var cur = self._scanDataController.getModel().getCur();
            if(null != cur) {
                self._app.getViewController().switchDeviceView(cur);
            }
        } else {
            Ui.requestUpdate();
        }
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