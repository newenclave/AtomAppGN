using Toybox.WatchUi as Ui;

class DeviceDataDelegate extends Ui.BehaviorDelegate {

    private var _app;
    private var _deviceDataController;

    function initialize(app, deviceDataController) {
        BehaviorDelegate.initialize();
        self._app = app;
        self._deviceDataController = deviceDataController;
    }

    function onBack() {
        self._deviceDataController.unpair();
        return false;
    }

    function onMenu() {
        return true;
    }

    function onNextMode() {
        return true;
    }

    function onNextPage() {
        return true;
    }

    function onPreviousMode() {
        return true;
    }

    function onPreviousPage() {
        return true;
    }

    function onSelect() {
        return true;
    }
}