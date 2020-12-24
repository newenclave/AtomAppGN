using Toybox.WatchUi as Ui;

class ViewController {
    private var _app;
    function initialize(app) {
        self._app = app;
    }

    private function createMenu() {
        var menuName = Application.loadResource(Rez.Strings.menu_name);
        var menu = new Ui.Menu2({:title=>menuName});
        var lastDevice = self._app.getValue("LastConnectedDevice");

        if(null != lastDevice) {
            var deviceName = lastDevice.getDeviceName();
            menu.addItem(
                new Ui.MenuItem(
                    Application.loadResource(Rez.Strings.menu_use_last),
                    deviceName ? deviceName : "Atom Fast",
                    "ItemUseLast",
                    {}
                )
            );
        }
        menu.addItem(
            new Ui.MenuItem(
                Application.loadResource(Rez.Strings.menu_scan),
                "", "ItemScan",
                {}
            )
        );

        menu.addItem(
            new Ui.MenuItem(
                Application.loadResource(Rez.Strings.menu_reset),
                "", "ItemReset",
                {}
            )
        );

        menu.addItem(
            new Ui.MenuItem(
                Application.loadResource(Rez.Strings.menu_about),
                "", "ItemAbout",
                {}
            )
        );
        return menu;
    }

    function pushMainManu() {
        WatchUi.pushView(
                self.createMenu(),
                new MainMenuDelegate(self._app),
                WatchUi.SLIDE_UP);
    }

    function switchMainManu() {
        WatchUi.switchToView(
                self.createMenu(),
                new MainMenuDelegate(self._app),
                WatchUi.SLIDE_IMMEDIATE);
    }

    function getMainView() {
         return [ new MainView(), new MainViewDelegate(self._app) ];
    }

    function switchScanView() {
        var scanDataController = new ScanDataController(self._app);
        Ui.switchToView(
            new ScanDataView(scanDataController),
            new ScanDataDelegate(self._app, scanDataController),
            Ui.SLIDE_DOWN);
    }

    function switchDeviceView(scanResult) {
        var deviceDataController = new DeviceDataController(self._app, scanResult);
        Ui.switchToView(
            new DeviceDataView(deviceDataController),
            new DeviceDataDelegate(self._app, deviceDataController),
            Ui.SLIDE_DOWN);
    }
}
