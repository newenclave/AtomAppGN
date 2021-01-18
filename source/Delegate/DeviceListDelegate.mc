using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Application as App;

class DeviceListDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
    }

    function onSelect() {
        var cur = App.getApp().getDeviceStorage().getCurrent();
        if(null != cur) {
            App.getApp().getViewController().pushDeviceView(cur.get("device"));
        }
    }

    function onMenu() {
        App.getApp().getViewController().pushDeviceListMenu();
        return true;
    }

    function onNextMode() {
        return false;
    }

    function onNextPage() {
        App.getApp().getDeviceStorage().next();
        Ui.requestUpdate();
        return false;
    }

    function onPreviousMode() {
        return false;
    }

    function onPreviousPage() {
        App.getApp().getDeviceStorage().prev();
        Ui.requestUpdate();
        return false;
    }
}

