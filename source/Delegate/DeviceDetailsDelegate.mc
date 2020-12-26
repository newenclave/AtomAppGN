using Toybox.WatchUi as Ui;
using Toybox.Attention;

class DeviceDetailsDelegate extends Ui.BehaviorDelegate {

    private var _app;

    function initialize(app) {
        BehaviorDelegate.initialize();
        self._app = app;
    }

    function onBack() {
        return false;
    }

    function onMenu() {
        self._app.getViewController().pushDeviceMenu();
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
