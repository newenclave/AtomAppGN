using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Application as App;

class DeviceListMenuDelegate extends Ui.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        System.println(item.getId());
        if(item has :isEnabled) {
            System.println("Enabled: " + item.isEnabled().toString());
        }
        switch(item.getId()) {
        case "ItemAdd":
            App.getApp().scanStart();
            App.getApp().getViewController().switchScanView(false, true);
            break;
        case "ItemRemove":
            App.getApp().getDeviceStorage().removeCurrent();
            Ui.popView(Ui.SLIDE_UP);
            break;
        case "ItemConnect":
            var cur = App.getApp().getDeviceStorage().getCurrent();
            if(null != cur) {
                App.getApp().getViewController().pushDeviceView(cur.get("device"));
            }
            break;
        }
    }
}
