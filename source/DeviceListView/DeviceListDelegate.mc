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
        return false;
    }

    function onPreviousMode() {
        return false;
    }

    function onPreviousPage() {
        return false;
    }

    function onSelect() {
        var device = self.getDeviceStorage();
        if(null != device) {
            App.getApp().getViewController().pushDeviceView(device.get("device"));
            return true;
        }
        return false;
    }
}
