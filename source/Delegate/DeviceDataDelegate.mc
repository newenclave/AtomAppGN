using Toybox.WatchUi as Ui;
using Toybox.Attention;

class DeviceDataDelegate extends Ui.BehaviorDelegate {

    private var _app;
    private var _deviceDataController;

    function initialize(app, deviceDataController) {
        BehaviorDelegate.initialize();
        self._app = app;
        self._deviceDataController = deviceDataController;
    }

    function onConfirmExit(opts) {
        self._deviceDataController.stop();
        Ui.popView(Ui.SLIDE_DOWN);
    }

    function onBack() {
        self._app.getViewController().pushConfirmationMenu(self);
        return true;
    }

    function onMenu() {
        self._app.getViewController().pushDeviceMenu(self._deviceDataController);
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
        var detailsView = new DeviceDetailsView(
                self._deviceDataController,
                self._app.getPropertiesProvider());
        Ui.pushView(detailsView, new DeviceDetailsDelegate(self._app, self._deviceDataController), Ui.SLIDE_UP);
        return true;
    }
}
