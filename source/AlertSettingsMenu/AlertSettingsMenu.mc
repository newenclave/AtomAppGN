using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class AlertSettingsMenu extends Ui.Menu2 {

    function initialize() {
        Ui.Menu2.initialize({
            :title=>App.loadResource(Rez.Strings.menu_dev_alerts)
        });
        self.fillMenu();
    }

    private function fillMenu() {
        var sett = [
            App.getApp().getPropertiesProvider().getAlertVibroL(0),
            App.getApp().getPropertiesProvider().getAlertVibroL(1),
            App.getApp().getPropertiesProvider().getAlertVibroL(2)
        ];

        self.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_alerts_vibroL1),
            {
                :enabled => App.loadResource(Rez.Strings.menu_enabled),
                :disabled => App.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL1Vibro", sett[0],
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        self.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_alerts_vibroL2),
            {
                :enabled => App.loadResource(Rez.Strings.menu_enabled),
                :disabled => App.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL2Vibro", sett[1],
            {
                :alignment=>Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        self.addItem(new Ui.ToggleMenuItem(
            App.loadResource(Rez.Strings.menu_alerts_vibroL3),
            {
                :enabled => App.loadResource(Rez.Strings.menu_enabled),
                :disabled => App.loadResource(Rez.Strings.menu_disabled)
            }, "ItemDoseL3Vibro", sett[2],
            {
                :alignment => Ui.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            }));

        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_dev_config_done),
                "", "ItemDone", {}
            )
        );
    }
}
