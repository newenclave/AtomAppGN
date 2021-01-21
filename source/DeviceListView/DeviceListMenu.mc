using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DeviceListMenu extends Ui.Menu2 {
    function initialize() {
        Ui.Menu2.initialize({
            :title=>App.loadResource(Rez.Strings.device_list_menu)
        });
        self.fillMenu();
    }

    private function fillMenu() {
        var empty = App.getApp().getDeviceStorage().isEmpty();
        if(!empty) {
            self.addItem(
                new Ui.MenuItem(App.loadResource(Rez.Strings.menu_text_connect),
                    "", "ItemConnect", {}
                )
            );
        }
        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_text_add),
                "", "ItemAdd", {}
            )
        );
        if(!empty) {
            self.addItem(
                new Ui.MenuItem(App.loadResource(Rez.Strings.menu_text_change_color),
                    "", "ItemChangeColor", {}
                )
            );
            self.addItem(
                new Ui.MenuItem(App.loadResource(Rez.Strings.menu_text_remove),
                    "", "ItemRemove", {}
                )
            );
        }
    }
}
