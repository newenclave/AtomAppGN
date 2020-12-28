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

    function createDeviceMenu(deviceController) {

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
                :enabled=>Application.loadResource(Rez.Strings.menu_enabled),
                :disabled=>Application.loadResource(Rez.Strings.menu_disabled)
            }, "ItemWriteActivity", writeActivity,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(
            new Ui.MenuItem(
                Application.loadResource(Rez.Strings.menu_dev_alerts),
                "", "ItemAlertSettings", {}
            )
        );

        if(null != deviceController) {
            var searchSpeedValues = [
                Application.loadResource(Rez.Strings.text_search_speed_fast),
                Application.loadResource(Rez.Strings.text_search_speed_medium),
                Application.loadResource(Rez.Strings.text_search_speed_slow)
            ];
            var currentSearchSpeed = deviceController.getSearchSpeed();

            menu.addItem(
                new Ui.MenuItem(
                    Application.loadResource(Rez.Strings.menu_search_speed),
                    searchSpeedValues[currentSearchSpeed],
                    "ItemSearchSpeed", {}
                )
            );
        }

        menu.addItem(
            new Ui.MenuItem( Application.loadResource(Rez.Strings.menu_dev_config_done),
                "", "ItemDone", {}
            )
        );

        return menu;
    }

    function createAlertSettingsMenu() {
        var menu = new Ui.Menu2({
                :title=>Application.loadResource(Rez.Strings.menu_dev_alerts)
            });

        var sett = [
            self._app.getPropertiesProvider().getAlertVibroL(0),
            self._app.getPropertiesProvider().getAlertVibroL(1),
            self._app.getPropertiesProvider().getAlertVibroL(2)
        ];

        menu.addItem(new Ui.ToggleMenuItem(
            Application.loadResource(Rez.Strings.menu_alerts_vibroL1),
            {
                :enabled=>Application.loadResource(Rez.Strings.menu_enabled),
                :disabled=>Application.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL1Vibro", sett[0],
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            Application.loadResource(Rez.Strings.menu_alerts_vibroL2),
            {
                :enabled=>Application.loadResource(Rez.Strings.menu_enabled),
                :disabled=>Application.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL2Vibro", sett[1],
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            Application.loadResource(Rez.Strings.menu_alerts_vibroL3),
            {
                :enabled=>Application.loadResource(Rez.Strings.menu_enabled),
                :disabled=>Application.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL3Vibro", sett[2],
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

    function pushAlertSettingsMenu() {
        Ui.pushView(
            self.createAlertSettingsMenu(),
            new AlertSettingsMenuDelegate(self._app.getPropertiesProvider()),
            Ui.SLIDE_LEFT);
    }

    function pushDeviceMenu(deviceController) {
        Ui.pushView(
            self.createDeviceMenu(deviceController),
            new DeviceMenuDelegate(self._app, deviceController),
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
