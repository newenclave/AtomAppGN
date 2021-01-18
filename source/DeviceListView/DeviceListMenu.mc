using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DeviceListMenu extends Ui.Menu2 {
    function initialize() {
        Ui.Menu2.initialize({
            :title=>App.loadResource(Rez.Strings.menu_name)
        });
        self.fillMenu();
    }

    private function fillMenu() {

    }

    public static function create() {
        return new DeviceListMenu();
    }
}
