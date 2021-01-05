using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ViewController {

    function initialize() {
    }

    private function createMainMenu() {
        var menuName = Application.loadResource(Rez.Strings.menu_name);
        var menu = new Ui.Menu2({:title=>menuName});
        var lastDevice = App.getApp().getLastSavedDevice();

        if(null != lastDevice) {
            var deviceName = lastDevice.getDeviceName();
            menu.addItem(
                new Ui.MenuItem(
                    App.loadResource(Rez.Strings.menu_use_last),
                    deviceName ? deviceName : "Atom Fast",
                    "ItemUseLast",
                    {}
                )
            );
        }

        menu.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_use_first),
                "", "ItemUseFirst", {}
            )
        );

        menu.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_scan),
                "", "ItemScan", {}
            )
        );

        menu.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_vew_settings),
                "", "ItemViewSettings", {}
            )
        );


//        menu.addItem(
//            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_reset),
//                "", "ItemReset", {}
//            )
//        );

        menu.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_about),
                "", "ItemAbout", {}
            )
        );
        return menu;
    }

    function pushMainManu() {
        Ui.pushView(
                self.createMainMenu(),
                new MainMenuDelegate(),
                Ui.SLIDE_UP);
    }

    function switchMainManu() {
        Ui.switchToView(
                self.createMainMenu(),
                new MainMenuDelegate(),
                Ui.SLIDE_IMMEDIATE);
    }

    function createConfirmationMenu() {
        var menu = new Ui.Menu2({
                :title => App.loadResource(Rez.Strings.menu_confirm_exit)
            });

        menu.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_confirm_no),
                "", "ItemNo", {}
            )
        );

        menu.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_confirm_yes),
                "", "ItemYes", {}
            )
        );
        return menu;
    }

    function pushConfirmationMenu(delegate) {
        Ui.pushView(self.createConfirmationMenu(),
                new ConfirmationMenuDelegate(delegate),
                Ui.SLIDE_UP);
    }

    function createDeviceMenu(deviceController) {

        var menu = new Ui.Menu2({
                :title=>App.loadResource(Rez.Strings.menu_dev_config)
            });

        var useRoungen = App.getApp().getPropertiesProvider().getUseRoentgen();
        var useFahrenheit = App.getApp().getPropertiesProvider().getUseFahrenheit();
        var useCPS = App.getApp().getPropertiesProvider().getUseCPS();
        var writeActivity = App.getApp().getPropertiesProvider().getWriteActivity();
        var themeUsed = App.getApp().getThemeName();
        var sigmaUsed = App.getApp().getPropertiesProvider().getUsedSigma();

        var useSigmasValues = [
            App.loadResource(Rez.Strings.menu_sigma_1),
            App.loadResource(Rez.Strings.menu_sigma_2),
            App.loadResource(Rez.Strings.menu_sigma_3)
        ];

        menu.addItem(new Ui.ToggleMenuItem(
            Application.loadResource(Rez.Strings.menu_dose_units),
            {
                :enabled => App.loadResource(Rez.Strings.menu_dose_use_roentgen),
                :disabled => App.loadResource(Rez.Strings.menu_dose_use_sieverts)
            }, "ItemUseRoentgen", useRoungen,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_temperature),
            {
                :enabled => App.loadResource(Rez.Strings.menu_temp_use_fahrenheit),
                :disabled => App.loadResource(Rez.Strings.menu_temp_use_celsius)
            }, "ItemUseFahrenheit", useFahrenheit,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_impulses),
            {
                :enabled => App.loadResource(Rez.Strings.menu_imp_use_CPS),
                :disabled => App.loadResource(Rez.Strings.menu_imp_use_CPM)
            }, "ItemUseCPS", useCPS,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_save_activity),
            {
                :enabled => App.loadResource(Rez.Strings.menu_enabled),
                :disabled => App.loadResource(Rez.Strings.menu_disabled)
            }, "ItemWriteActivity", writeActivity,
            {
                :alignment => Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(
            new Ui.MenuItem(
                App.loadResource(Rez.Strings.menu_dev_alerts),
                "", "ItemAlertSettings", {}
            )
        );

        menu.addItem(
            new Ui.MenuItem(
                App.loadResource(Rez.Strings.menu_use_sigma),
                useSigmasValues[sigmaUsed],
                "ItemUseSigma", {}
            )
        );

        if(null != deviceController) {
            var searchSpeedValues = [
                App.loadResource(Rez.Strings.text_search_speed_fast),
                App.loadResource(Rez.Strings.text_search_speed_medium),
                App.loadResource(Rez.Strings.text_search_speed_slow)
            ];
            var currentSearchSpeed = deviceController.getSearchSpeed();

            menu.addItem(
                new Ui.MenuItem(
                    App.loadResource(Rez.Strings.menu_search_speed),
                    searchSpeedValues[currentSearchSpeed],
                    "ItemSearchSpeed", {}
                )
            );
        }

        menu.addItem(
            new Ui.MenuItem(
                App.loadResource(Rez.Strings.menu_use_theme),
                themeUsed,
                "ItemUseTheme", {}
            )
        );

        menu.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_dev_config_done),
                "", "ItemDone", {}
            )
        );

        return menu;
    }

    function createAlertSettingsMenu() {
        var menu = new Ui.Menu2({
                :title=>App.loadResource(Rez.Strings.menu_dev_alerts)
            });

        var sett = [
            App.getApp().getPropertiesProvider().getAlertVibroL(0),
            App.getApp().getPropertiesProvider().getAlertVibroL(1),
            App.getApp().getPropertiesProvider().getAlertVibroL(2)
        ];

        menu.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_alerts_vibroL1),
            {
                :enabled => App.loadResource(Rez.Strings.menu_enabled),
                :disabled => App.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL1Vibro", sett[0],
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_alerts_vibroL2),
            {
                :enabled => App.loadResource(Rez.Strings.menu_enabled),
                :disabled => App.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL2Vibro", sett[1],
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_alerts_vibroL3),
            {
                :enabled => App.loadResource(Rez.Strings.menu_enabled),
                :disabled => App.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL3Vibro", sett[2],
            {
                :alignment => Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        menu.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_dev_config_done),
                "", "ItemDone", {}
            )
        );
        return menu;
    }

    function pushAlertSettingsMenu() {
        Ui.pushView(
            self.createAlertSettingsMenu(),
            new AlertSettingsMenuDelegate(App.getApp().getPropertiesProvider()),
            Ui.SLIDE_LEFT);
    }

    function pushDeviceMenu(deviceController) {
        Ui.pushView(
            self.createDeviceMenu(deviceController),
            new DeviceMenuDelegate(deviceController),
            Ui.SLIDE_UP);
    }

    function getMainView() {
         return [ new MainView(), new MainViewDelegate() ];
    }

    function switchScanView(useFirst) {
        var scanDataController = new ScanDataController();
        var opts = { :useFirst => useFirst };
        Ui.switchToView(
            new ScanDataView(scanDataController),
            new ScanDataDelegate(scanDataController, opts),
            Ui.SLIDE_DOWN);
    }

    function pushScanView(useFirst) {
        var scanDataController = new ScanDataController();
        var opts = { :useFirst => useFirst };
        Ui.pushView(
            new ScanDataView(scanDataController),
            new ScanDataDelegate(scanDataController, opts),
            Ui.SLIDE_DOWN);
    }

    function switchDeviceView(scanResult) {
        var deviceDataController = App.getApp().getDevices().pairNew(scanResult);
        if(null != deviceDataController)  {
            Ui.switchToView(
                new DeviceDataView(deviceDataController),
                new DeviceDataDelegate(deviceDataController),
                Ui.SLIDE_DOWN);
        } else {
            // TODO:  Show error
        }
    }

    function pushDeviceView(scanResult) {
        var deviceDataController = App.getApp().getDevices().pairNew(scanResult);
        if(null != deviceDataController)  {
            Ui.pushView(
                new DeviceDataView(deviceDataController),
                new DeviceDataDelegate(deviceDataController),
                Ui.SLIDE_DOWN);
        } else {
            // TODO:  Show error
        }
    }
}
