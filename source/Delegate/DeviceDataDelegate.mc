using Toybox.WatchUi as Ui;

class DeviceDataDelegate extends Ui.BehaviorDelegate {

    private var _app;
    private var _deviceDataController;
    private var _backDoublePress;
    private var _detailsView;

    function initialize(app, deviceDataController) {
        BehaviorDelegate.initialize();
        self._app = app;
        self._deviceDataController = deviceDataController;
        self._backDoublePress = new DoublePressCheck(1000);
        self._detailsView = null;
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
        self._app.getViewController().pushDeviceMenu();
        return true;
    }

    function onNextMode() {
        return true;
    }

    function onNextPage() {
        if(null == self._detailsView) {
            self._detailsView = new DeviceDetailsView(
                    self._deviceDataController.getModel(),
                    self._app.getPropertiesProvider());
            Ui.pushView(self._detailsView, self, Ui.SLIDE_UP);
        }
        return true;
    }

    function onPreviousMode() {
        return true;
    }

    function onPreviousPage() {
        if(null != self._detailsView) {
            Ui.popView(Ui.SLIDE_DOWN);
            self._detailsView = null;
        }
        return true;
    }

    function onSelect() {
        return true;
    }
}