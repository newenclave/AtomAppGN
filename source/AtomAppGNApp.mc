using Toybox.Application;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class AtomAppGNApp extends Application.AppBase {

    private var _viewController;
    private var _atomFastProfile;
    private var _bleDelegate;

    function initialize() {
        AppBase.initialize();

        self._atomFastProfile = new AtomFastProfile();
        self._viewController = new ViewController(self);
        self._bleDelegate = new BleDelegate(self);

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

    public function getProfile() {
        return self._atomFastProfile;
    }

    public function getBleDelegate() {
        return self._bleDelegate;
    }

}
