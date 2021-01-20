using Toybox.WatchUi as Ui;
using Toybox.Attention;
using Toybox.Application;

class DeviceDetailsDelegate extends Ui.BehaviorDelegate {

    private var _deviceController;

    function initialize(deviceController) {
        BehaviorDelegate.initialize();
        self._deviceController = deviceController;
    }

    private function getApp() {
        return Application.getApp();
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_RIGHT);
        return true;
    }

    function onSelect() {
        Ui.popView(Ui.SLIDE_RIGHT);
        return true;
    }

    function onMenu() {
        self.getApp().getViewController().pushDeviceMenu(self._deviceController);
        return true;
    }
}
