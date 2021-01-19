using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DeviceListDelegate extends Ui.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    private function getDeviceStorage() {
        return App.getApp().getDeviceStorage();
    }

    function onBack() {
        return false;
    }

    function onMenu() {
        Ui.pushView(new DeviceListMenu(), new DeviceListMenuDelegate(), Ui.SLIDE_RIGHT);
        return true;
    }

    function onNextMode() {
        return false;
    }

    function onPreviousMode() {
        return false;
    }

    function onNextPage() {
        self.getDeviceStorage().next();
        Ui.requestUpdate();
        return true;
    }

    function onPreviousPage() {
        self.getDeviceStorage().prev();
        Ui.requestUpdate();
        return true;
    }

    function onSelect() {
        var device = self.getDeviceStorage().getCurrent();
        if(null != device) {
            App.getApp().getViewController().pushDeviceView(device.getScanResult());
            return true;
        }
        return false;
    }
}
