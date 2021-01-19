using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Application as App;

class DeviceListMenuDelegate extends Ui.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        switch(item.getId()) {
        case "ItemConnect":
            var device = App.getApp().getDeviceStorage().getCurrent();
            if(null != device) {
                App.getApp().getViewController().switchDeviceView(device.getScanResult());
            }
            break;
        case "ItemAdd":
            App.getApp().scanStart();
            App.getApp().getViewController().switchScanView(false, true);
            break;
        case "ItemRemove":
            App.getApp().getDeviceStorage().removeCurrent();
            Ui.popView(Ui.SLIDE_LEFT);
            break;
        }
    }
}
