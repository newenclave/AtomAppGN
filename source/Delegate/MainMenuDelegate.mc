using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application as App;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        System.println(item.getId());
        if(item has :isEnabled) {
            System.println("Enabled: " + item.isEnabled().toString());
        }
        switch(item.getId()) {
        case "ItemUseLast":
            var lastDevice = App.getApp().getValue("LastConnectedDevice");
            App.getApp().getViewController().switchDeviceView(lastDevice);
            break;
        case "ItemUseFirst":
            App.getApp().scanStart();
            App.getApp().getViewController().switchScanView(true);
            break;
        case "ItemScan":
            App.getApp().scanStart();
            App.getApp().getViewController().switchScanView(false);
            break;
        case "ItemReset":
            Application.Storage.clearValues();
            App.getApp().getViewController().switchMainManu();
            break;
        case "ItemAbout":
            break;
        }
    }
}
