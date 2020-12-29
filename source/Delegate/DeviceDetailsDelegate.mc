using Toybox.WatchUi as Ui;
using Toybox.Attention;

class DeviceDetailsDelegate extends Ui.BehaviorDelegate {

    private var _app;
    private var _deviceController;

    function initialize(app, deviceController) {
        BehaviorDelegate.initialize();
        self._app = app;
        self._deviceController = deviceController;
    }

    function onBack() {
        return false;
    }

    function onMenu() {
        self._app.getViewController().pushDeviceMenu(self._deviceController);
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
