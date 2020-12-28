using Toybox.WatchUi as Ui;
using Toybox.Attention;

class DeviceDataDelegate extends Ui.BehaviorDelegate {

    private var _app;
    private var _deviceDataController;
    private var _backDoublePress;

    function initialize(app, deviceDataController) {
        BehaviorDelegate.initialize();
        self._app = app;
        self._deviceDataController = deviceDataController;
        self._backDoublePress = new DoublePressCheck(1000);
    }

    function onBack() {
        if(self._backDoublePress.press()) {
            self.onPreviousPage();
            self._deviceDataController.stop();
            return false;
        }
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
        Ui.pushView(detailsView, new DeviceDetailsDelegate(self._app), Ui.SLIDE_UP);
        return true;
    }
}
