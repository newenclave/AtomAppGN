using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class MainViewMenu extends Ui.Menu2 {

    function initialize() {
        Ui.Menu2.initialize({
            :title=>App.loadResource(Rez.Strings.menu_name)
        });
        self.fillMenu();
    }

    private function fillMenu() {
        var lastDevice = App.getApp().getLastSavedDevice();
        if(null != lastDevice) {
            var deviceName = lastDevice.getDeviceName();
            self.addItem(
                new Ui.MenuItem(
                    App.loadResource(Rez.Strings.menu_use_last),
                    null != deviceName ? deviceName : "Atom device",
                    "ItemUseLast",
                    {}
                )
            );
        }

        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_use_first),
                "", "ItemUseFirst", {}
            )
        );

        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_scan),
                "", "ItemScan", {}
            )
        );

        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_view_settings),
                "", "ItemViewSettings", {}
            )
        );

        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_device_list),
                "", "ItemDeviceList", {}
            )
        );

//        menu.addItem(
//            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_reset),
//                "", "ItemReset", {}
//            )
//        );

        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_about),
                "", "ItemAbout", {}
            )
        );
    }
}
