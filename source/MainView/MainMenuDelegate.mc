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
        case "ItemUseExtendedMode":
            App.getApp().getPropertiesProvider().setUseExtendedMode(item.isEnabled());
            App.getApp().getViewController().switchMainManu();
            break;
        case "ItemUseLast":
            var lastDevice = App.getApp().getLastSavedDevice();
            App.getApp().getViewController().switchDeviceView(lastDevice);
            break;
        case "ItemUseFirst":
            App.getApp().scanStart();
            App.getApp().getViewController().switchScanView(true, false);
            break;
        case "ItemScan":
            App.getApp().scanStart();
            App.getApp().getViewController().switchScanView(false, false);
            break;
        case "ItemDeviceList":
            App.getApp().getViewController().switchDeviceList();
            break;
        case "ItemViewSettings":
            App.getApp().getViewController().pushDeviceMenu(null);
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
