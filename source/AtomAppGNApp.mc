using Toybox.Application;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class AtomAppGNApp extends Application.AppBase {

    private var _propertiesProvider;
    private var _position;
    private var _atomFastProfile;
    private var _bleDelegate;
    private var _viewController;
    private var _theme;
    private var _version32plus;

    function initialize() {

        var ver = System.getDeviceSettings().monkeyVersion;
        self._version32plus = (ver[0] > 3) || ((ver[0] == 3) && (ver[1] >= 2));
        System.println("System 32+: " + self._version32plus.toString());

        AppBase.initialize();
        self._propertiesProvider = new PropertiesProvider();
        self._position = new PositionProvider();

        self._atomFastProfile = new AtomFastProfile();
        self._viewController = new ViewController();
        self._bleDelegate = new BleDelegate();
        self._theme = new ThemeController();

        Ble.registerProfile(self._atomFastProfile.getProfile());
        Ble.setDelegate(self._bleDelegate);
    }

    function getTheme() {
        return self._theme.getCurrent();
    }

    function reloadTheme() {
        return self._theme.reload();
    }

    function getAllThemes() {
        return self._theme.getThemes();
    }

    function getThemeName() {
        return self._theme.getCurrentName();
    }

    function getThemeId() {
        return self._theme.getCurrentIdName();
    }

    function getInitialView() {
        return self._viewController.getMainView();
    }

    function scanStart() {
        Ble.setScanState(Ble.SCAN_STATE_SCANNING);
    }

    function scanStop() {
        Ble.setScanState(Ble.SCAN_STATE_OFF);
    }

    function onStart(state) {
    }

    function onStop(state) {
        self._position.disable();
        self._propertiesProvider = null;
        self._position = null;
        self._atomFastProfile = null;
        self._bleDelegate = null;
        self._viewController = null;
    }

    function getPropertiesProvider() {
        return _propertiesProvider;
    }

    function getViewController() {
        return self._viewController;
    }

    function getPositionProvider() {
        return self._position;
    }

    public function getValue(key) {
        return Application.Storage.getValue(key);
    }

    public function setValue(key, value) {
        Application.Storage.setValue(key, value);
    }

    public function getLastSavedDevice() {
        if(self._version32plus) {
            var arr = self.getValue("LastConnectedDevice");
            if(null != arr) {
                if(arr instanceof Lang.Array) {
                    return arr[0].get("device");
                } else {
                    return arr;
                }
            }
        }
        return null;
    }

    public function setLastSavedDevice(value) {
        if(self._version32plus) {
            self.setValue("LastConnectedDevice", [{"device" => value}]);
        }
    }

    public function getProfile() {
        return self._atomFastProfile;
    }

    public function getBleDelegate() {
        return self._bleDelegate;
    }

}
