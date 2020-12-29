using Toybox.WatchUi as Ui;
using Toybox.System;

class DeviceMenuDelegate extends Ui.Menu2InputDelegate {

    private var _app;
    private var _deviceController;
    private var _initSearchSpeed;
    private var _currentSearchSpeed;

    function initialize(app, deviceController) {
        Menu2InputDelegate.initialize();
        self._app = app;
        self._deviceController = deviceController;
        if(deviceController) {
            self._currentSearchSpeed = self._deviceController.getSearchSpeed();
            self._initSearchSpeed = self._currentSearchSpeed;
        }
    }

    function onDone(store) {
        if(store && null != self._deviceController && self._initSearchSpeed != self._currentSearchSpeed) {
            self._deviceController.setSearchSpeed(self._currentSearchSpeed);
        }
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

    function onBack() {
        return onDone(false);
    }

    function onSelect(item) {

        var searchSpeedValues = [
            Application.loadResource(Rez.Strings.text_search_speed_fast),
            Application.loadResource(Rez.Strings.text_search_speed_medium),
            Application.loadResource(Rez.Strings.text_search_speed_slow),
        ];

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
        case "ItemWriteActivity":
            if(item has :isEnabled) {
                self._app.getPropertiesProvider().setWriteActivity(item.isEnabled());
            }
            break;
        case "ItemAlertSettings":
            self._app.getViewController().pushAlertSettingsMenu();
            break;
        case "ItemSearchSpeed":
            if(self._deviceController) {
                self._currentSearchSpeed++;
                self._currentSearchSpeed %= 3;
                item.setSubLabel(searchSpeedValues[self._currentSearchSpeed]);
            }
            break;
        case "ItemDone":
            self.onDone(true);
            break;
        }
    }
}
