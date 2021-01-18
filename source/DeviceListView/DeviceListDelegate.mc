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
        return false;
    }

    function onNextMode() {
        return false;
    }

    function onNextPage() {
        self.getDeviceStorage().next();
        return false;
    }

    function onPreviousMode() {
        return false;
    }

    function onPreviousPage() {
        self.getDeviceStorage().prev();
        return false;
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
