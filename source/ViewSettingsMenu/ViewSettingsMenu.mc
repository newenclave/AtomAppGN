using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ViewSettingsMenu extends Ui.Menu2 {

    function initialize(deviceController) {
        Ui.Menu2.initialize({
            :title=>App.loadResource(Rez.Strings.menu_dev_config)
        });
        self.fillMenu(deviceController);
    }

    private function fillMenu(deviceController) {
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

        self.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_dose_units),
            {
                :enabled => App.loadResource(Rez.Strings.menu_dose_use_roentgen),
                :disabled => App.loadResource(Rez.Strings.menu_dose_use_sieverts)
            }, "ItemUseRoentgen", useRoungen,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        self.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_temperature),
            {
                :enabled => App.loadResource(Rez.Strings.menu_temp_use_fahrenheit),
                :disabled => App.loadResource(Rez.Strings.menu_temp_use_celsius)
            }, "ItemUseFahrenheit", useFahrenheit,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        self.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_impulses),
            {
                :enabled => App.loadResource(Rez.Strings.menu_imp_use_CPS),
                :disabled => App.loadResource(Rez.Strings.menu_imp_use_CPM)
            }, "ItemUseCPS", useCPS,
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        self.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_save_activity),
            {
                :enabled => App.loadResource(Rez.Strings.menu_enabled),
                :disabled => App.loadResource(Rez.Strings.menu_disabled)
            }, "ItemWriteActivity", writeActivity,
            {
                :alignment => Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        self.addItem(
            new Ui.MenuItem(
                App.loadResource(Rez.Strings.menu_dev_alerts),
                "", "ItemAlertSettings", {}
            )
        );

        self.addItem(
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

            self.addItem(
                new Ui.MenuItem(
                    App.loadResource(Rez.Strings.menu_search_speed),
                    searchSpeedValues[currentSearchSpeed],
                    "ItemSearchSpeed", {}
                )
            );
        }

        self.addItem(
            new Ui.MenuItem(
                App.loadResource(Rez.Strings.menu_use_theme),
                themeUsed,
                "ItemUseTheme", {}
            )
        );

        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_dev_config_done),
                "", "ItemDone", {}
            )
        );
    }

    public static function create(deviceController) {
        return new ViewSettingsMenu(deviceController);
    }
}
