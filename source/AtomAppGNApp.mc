using Toybox.Application;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class AtomAppGNApp extends Application.AppBase {

    private var _propertiesProvider;
    private var _position;
    private var _atomFastProfile;
    private var _bleDelegate;
    private var _viewController;

    function initialize() {
        AppBase.initialize();
        self._propertiesProvider = new PropertiesProvider();
        self._position = new PositionProvider();

        self._atomFastProfile = new AtomFastProfile();
        self._viewController = new ViewController();
        self._bleDelegate = new BleDelegate();

        Ble.registerProfile(self._atomFastProfile.getProfile());
        Ble.setDelegate(self._bleDelegate);
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

    public function getProfile() {
        return self._atomFastProfile;
    }

    public function getBleDelegate() {
        return self._bleDelegate;
    }

}
