using Toybox.Application;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class AtomAppGNApp extends Application.AppBase {

    private var _devices;
    private var _deviceStorage;
    private var _propertiesProvider;
    private var _atomFastProfile;
    private var _bleDelegate;
    private var _viewController;
    private var _theme;
    private var _version32plus;

    function initialize() {
        AppBase.initialize();

        System.println("++++++++++++++++");
        var ver = System.getDeviceSettings().monkeyVersion;
        self._version32plus = (ver[0] > 3) || ((ver[0] == 3) && (ver[1] >= 2));
        System.println("System 32+: " + self._version32plus.toString());

        self._devices = new DevicesCollector();
        self._deviceStorage = new DeviceStorage();

        self._propertiesProvider = new PropertiesProvider();

        self._atomFastProfile = new AtomFastProfile();
        self._viewController = new ViewController();
        self._theme = new ThemeController();

        self._bleDelegate = new BleDelegate();
        self._bleDelegate.setEventListener(self._devices);
    }

    function onStart(state) {
        Ble.setDelegate(self._bleDelegate);
        self._atomFastProfile.register();
    }

    function onStop(state) {
        self._propertiesProvider = null;
        self._atomFastProfile = null;
        self._bleDelegate = null;
        self._viewController = null;

        System.println("----------------");
    }

    function getDeviceStorage() {
        return self._deviceStorage;
    }

    function getDeviceController() {
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

    public function getValue(key) {
        return Application.Storage.getValue(key);
    }

    public function setValue(key, value) {
        Application.Storage.setValue(key, value);
    }

    public function getLastSavedDevice() {
        if(self._version32plus) {
            var arr = self.getValue("LastConnectedDevice");
            if(null != arr && arr.size() > 0) {
                return arr[arr.size() - 1].get("device");
            }
        }
        return null;
    }

    public function storeDeviceList(value) {
        if(self._version32plus) {
            self.setValue("LastConnectedDevice", value);
        }
    }

    public function loadDeviceList() {
        if(self._version32plus) {
            return self.getValue("LastConnectedDevice");
        }
        return [];
    }

    public function getProfile() {
        return self._atomFastProfile;
    }

    public function getBleDelegate() {
        return self._bleDelegate;
    }

}
