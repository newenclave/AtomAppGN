using Toybox.WatchUi as Ui;
using Toybox.Attention;
using Toybox.Application;

class DeviceDataDelegate extends Ui.BehaviorDelegate {

    private var _deviceDataController;

    function initialize(deviceDataController) {
        BehaviorDelegate.initialize();
        self._deviceDataController = deviceDataController;
    }

    private function getApp() {
        return Application.getApp();
    }

    function onConfirmExit(opts) {
        self._deviceDataController.stop();
        Ui.popView(Ui.SLIDE_DOWN);
    }

    function onBack() {
        self.getApp().getViewController().pushConfirmationMenu(self);
        return true;
    }

    function onMenu() {
        self.getApp().getViewController().pushDeviceMenu(self._deviceDataController);
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
                self.getApp().getPropertiesProvider());
        Ui.pushView(detailsView, new DeviceDetailsDelegate(self._deviceDataController), Ui.SLIDE_UP);
        return true;
    }
}
