using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ConfirmationMenu extends Ui.Menu2 {

    function initialize() {
        Ui.Menu2.initialize({
            :title => App.loadResource(Rez.Strings.menu_confirm_exit)
        });
        self.fillMenu();
    }

    private function fillMenu() {
        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_confirm_no),
                "", "ItemNo", {}
            )
        );
        self.addItem(
            new Ui.MenuItem(App.loadResource(Rez.Strings.menu_confirm_yes),
                "", "ItemYes", {}
            )
        );
    }
}
