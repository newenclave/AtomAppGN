using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Application as App;

class ViewSettingsMenuDelegate extends Ui.Menu2InputDelegate {

    private var _deviceController;
    private var _initSearchSpeed;
    private var _currentSearchSpeed;
    private var _currentSigma;

    function initialize(deviceController) {
        Menu2InputDelegate.initialize();
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

        var useSigmasValues = [
            App.loadResource(Rez.Strings.menu_sigma_1),
            App.loadResource(Rez.Strings.menu_sigma_2),
            App.loadResource(Rez.Strings.menu_sigma_3)
        ];

        var sigma = 0;
        if(null != self._deviceController) {
            sigma = self._deviceController.getUsedSigma();
        } else {
            sigma = App.getApp().getPropertiesProvider().getUsedSigma();
        }
        var themes = App.getApp().getAllThemes();
        var themeIdName = App.getApp().getThemeId();
        var themeId = 0;
        for(var i = 0; i<themes.size(); i++) {
            if(themes[i].get(:name).equals(themeIdName)) {
                themeId = i;
                break;
            }
        }

        switch(item.getId()) {
        case "ItemUseRoentgen":
            if(item has :isEnabled) {
                App.getApp().getPropertiesProvider().setUseRoentgen(item.isEnabled());
            }
            break;
        case "ItemUseFahrenheit":
            if(item has :isEnabled) {
                App.getApp().getPropertiesProvider().setUseFahrenheit(item.isEnabled());
            }
            break;
        case "ItemUseCPS":
            if(item has :isEnabled) {
                App.getApp().getPropertiesProvider().setUseCPS(item.isEnabled());
            }
            break;
        case "ItemWriteActivity":
            if(item has :isEnabled) {
                App.getApp().getPropertiesProvider().setWriteActivity(item.isEnabled());
            }
            break;
        case "ItemShowSystemBatteryArc":
            if(item has :isEnabled) {
                App.getApp().getPropertiesProvider().setShowSystemBattery(item.isEnabled());
            }
            break;
        case "ItemShowSplash":
            if(item has :isEnabled) {
                App.getApp().getPropertiesProvider().setShowSplash(item.isEnabled());
            }
            break;
        case "ItemAlertSettings":
            App.getApp().getViewController().pushAlertSettingsMenu();
            break;
        case "ItemUseSigma":
            sigma++;
            sigma %= useSigmasValues.size();
            item.setSubLabel(useSigmasValues[sigma]);
            if(null != self._deviceController) {
                self._deviceController.setUsedSigma(sigma);
            } else {
                App.getApp().getPropertiesProvider().setUsedSigma(sigma % useSigmasValues.size());
            }
            break;
        case "ItemUseTheme":
            themeId++;
            item.setSubLabel(themes[themeId % themes.size()].get(:description));
            App.getApp().getPropertiesProvider().setThemeUsed(themes[themeId % themes.size()].get(:name));
            App.getApp().reloadTheme();
            break;
        case "ItemSearchSpeed":
            if(self._deviceController) {
                self._currentSearchSpeed++;
                self._currentSearchSpeed %= searchSpeedValues.size();
                item.setSubLabel(searchSpeedValues[self._currentSearchSpeed]);
            }
            break;
        case "ItemDone":
            self.onDone(true);
            break;
        }
    }
}
