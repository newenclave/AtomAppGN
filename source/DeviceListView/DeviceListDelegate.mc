using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DeviceListDelegate extends Ui.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    private function getDeviceStorage() {
        return App.getApp().getDeviceStorage();
    }

    function onMenu() {
        Ui.pushView(new DeviceListMenu(), new DeviceListMenuDelegate(), Ui.SLIDE_RIGHT);
        return true;
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
