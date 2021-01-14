using Toybox.Application;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class AtomAppGNApp extends Application.AppBase {

    private var _devices;
    private var _propertiesProvider;
    private var _position;
    private var _atomFastProfile;
    private var _bleDelegate;
    private var _viewController;
    private var _theme;
    private var _version32plus;

    function initialize() {
        AppBase.initialize();

        var ver = System.getDeviceSettings().monkeyVersion;
        self._version32plus = (ver[0] > 3) || ((ver[0] == 3) && (ver[1] >= 2));
        System.println("System 32+: " + self._version32plus.toString());

        self._devices = new DevicesCollector();
        self._propertiesProvider = new PropertiesProvider();
        self._position = new PositionProvider();

        self._atomFastProfile = new AtomFastProfile();
        self._viewController = new ViewController();
        self._theme = new ThemeController();

        self._bleDelegate = new BleDelegate();
        self._bleDelegate.setEventListener(self._devices);
    }

    function onStart(state) {
        Ble.setDelegate(self._bleDelegate);
        Ble.registerProfile(self._atomFastProfile.getProfile());
    }

    function onStop(state) {
        self._position.disable();
        self._propertiesProvider = null;
        self._position = null;
        self._atomFastProfile = null;
        self._bleDelegate = null;
        self._viewController = null;
    }

    function getDevices() {
        return self._devices;
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

    function getPropertiesProvider() {
        return self._propertiesProvider;
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
        self.storeLastSagedDevice([{"device" => value}]);
    }

    public function loadLastSavedDevice() {
        if(self._version32plus) {
            return self.getValue("LastConnectedDevice");
        }
        return null;
    }

    public function storeLastSagedDevice(value) {
        if(self._version32plus) {
            self.setValue("LastConnectedDevice", value);
        }
    }

    public function getProfile() {
        return self._atomFastProfile;
    }

    public function getBleDelegate() {
        return self._bleDelegate;
    }

}
