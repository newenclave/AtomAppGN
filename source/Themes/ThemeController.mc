
using Toybox.WatchUi as Ui;

class ThemeController {

    private var _current;
    private var _name;
    private var _id;

    function initialize() {
        self.reload();
    }

    function getCurrent() {
        return self._current;
    }

    function getCurrentName() {
        return self._name;
    }

    function getCurrentIdName() {
        return self._id;
    }

    function getThemes() {
        return [{
            :name=>"dark",
            :description => Application.loadResource(Rez.Strings.theme_name_dark)
        }, {
            :name => "light",
            :description => Application.loadResource(Rez.Strings.theme_name_light)
        }];
    }

    function reload() {
        var theme = Application.getApp().getPropertiesProvider().getThemeUsed();
        switch(theme) {
        case "dark":
            self._current = new ThemeDark();
            self._name = Application.loadResource(Rez.Strings.theme_name_dark);
            self._id = theme;
            break;
        case "light":
            self._current = new ThemeLight();
            self._name = Application.loadResource(Rez.Strings.theme_name_light);
            self._id = theme;
            break;
        default:
            self._current = new ThemeDark();
            self._name = Application.loadResource(Rez.Strings.theme_name_dark);
            self._id = "dark";
        }
    }
}
