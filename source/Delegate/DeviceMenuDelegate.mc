using Toybox.WatchUi as Ui;
using Toybox.System;

class DeviceMenuDelegate extends Ui.Menu2InputDelegate {

    private var _app;

    function initialize(app) {
        Menu2InputDelegate.initialize();
        self._app = app;
    }

    function onSelect(item) {
        switch(item.getId()) {
        case "ItemUseRoentgen":
            if(item has :isEnabled) {
                self._app.getPropertiesProvider().setUseRoentgen(item.isEnabled());
            }
            break;
        case "ItemUseFahrenheit":
            if(item has :isEnabled) {
                self._app.getPropertiesProvider().setUseFahrenheit(item.isEnabled());
            }
            break;
        case "ItemDone":
            Ui.popView(Ui.SLIDE_DOWN);
            break;
        }
    }
}
