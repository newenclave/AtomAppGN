using Toybox.WatchUi;
using Toybox.System;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _app;

    function initialize(app) {
        Menu2InputDelegate.initialize();
        self._app = app;
    }

    function onSelect(item) {
        System.println(item.getId());
        if(item has :isEnabled) {
            System.println("Enabled: " + item.isEnabled().toString());
        }
        switch(item.getId()) {
        case "ItemUseLast":
            var lastDevice = self._app.getValue("LastConnectedDevice");
            self._app.getViewController().switchDeviceView(lastDevice);
            break;
        case "ItemUseFirst":
            self._app.scanStart();
            self._app.getViewController().switchScanView(true);
            break;
        case "ItemScan":
            self._app.scanStart();
            self._app.getViewController().switchScanView(false);
            break;
        case "ItemReset":
            Application.Storage.clearValues();
            self._app.getViewController().switchMainManu();
            break;
        }
    }
}
