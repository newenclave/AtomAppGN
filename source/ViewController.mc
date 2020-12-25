using Toybox.WatchUi as Ui;

class ViewController {
    private var _app;
    function initialize(app) {
        self._app = app;
    }

    private function createMainMenu() {
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
            new Ui.MenuItem(Application.loadResource(Rez.Strings.menu_use_first),
                "", "ItemUseFirst", {}
            )
        );
        menu.addItem(
            new Ui.MenuItem( Application.loadResource(Rez.Strings.menu_scan),
                "", "ItemScan", {}
            )
        );

        menu.addItem(
            new Ui.MenuItem(Application.loadResource(Rez.Strings.menu_reset),
                "", "ItemReset", {}
            )
        );

        menu.addItem(
            new Ui.MenuItem( Application.loadResource(Rez.Strings.menu_about),
                "", "ItemAbout", {}
            )
        );
        return menu;
    }

    function pushMainManu() {
        Ui.pushView(
                self.createMainMenu(),
                new MainMenuDelegate(self._app),
                Ui.SLIDE_UP);
    }

    function switchMainManu() {
        Ui.switchToView(
                self.createMainMenu(),
                new MainMenuDelegate(self._app),
                Ui.SLIDE_IMMEDIATE);
    }

    function createDeviceMenu() {

        var menu = new Ui.Menu2({
                :title=>Application.loadResource(Rez.Strings.menu_dev_config)
            });

        var useRoungen = self._app.getPropertiesProvider().getUseRoentgen();
        var useFahrenheit = self._app.getPropertiesProvider().getUseFahrenheit();
        var writeActivity = self._app.getPropertiesProvider().getWriteActivity();

        menu.addItem(new Ui.ToggleMenuItem(
            Application.loadResource(Rez.Strings.menu_dose_units),
            {
                :enabled=>Application.loadResource(Rez.Strings.menu_dose_use_roentgen),
                :disabled=>Application.loadResource(Rez.Strings.menu_dose_use_sieverts)
            }, "ItemUseRoentgen", useRoungen,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            Application.loadResource(Rez.Strings.menu_temperature),
            {
                :enabled=>Application.loadResource(Rez.Strings.menu_temp_use_fahrenheit),
                :disabled=>Application.loadResource(Rez.Strings.menu_temp_use_celsius)
            }, "ItemUseFahrenheit", useFahrenheit,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            Application.loadResource(Rez.Strings.menu_save_activity),
            {
                :enabled=>Application.loadResource(Rez.Strings.menu_activity_enabled),
                :disabled=>Application.loadResource(Rez.Strings.menu_activity_disabled)
            }, "ItemWriteActivity", writeActivity,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(
            new Ui.MenuItem( Application.loadResource(Rez.Strings.menu_dev_config_done),
                "", "ItemDone", {}
            )
        );

        return menu;
    }

    function pushDeviceMenu() {
        Ui.pushView(
            self.createDeviceMenu(),
            new DeviceMenuDelegate(self._app),
            Ui.SLIDE_UP);
    }

    function getMainView() {
         return [ new MainView(), new MainViewDelegate(self._app) ];
    }

    function switchScanView(useFirst) {
        var scanDataController = new ScanDataController(self._app);
        var opts = { :useFirst => useFirst };
        Ui.switchToView(
            new ScanDataView(scanDataController),
            new ScanDataDelegate(self._app, scanDataController, opts),
            Ui.SLIDE_DOWN);
    }

    function pushScanView(useFirst) {
        var scanDataController = new ScanDataController(self._app);
        var opts = { :useFirst => useFirst };
        Ui.pushView(
            new ScanDataView(scanDataController),
            new ScanDataDelegate(self._app, scanDataController, opts),
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
