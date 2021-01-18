using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ViewController {

    function initialize() {
    }

    private function createMainMenu() {
        return MainViewMenu.create();
    }

    function pushMainManu() {
        Ui.pushView(
                self.createMainMenu(),
                new MainMenuDelegate(),
                Ui.SLIDE_UP);
    }

    function switchMainManu() {
        Ui.switchToView(
                self.createMainMenu(),
                new MainMenuDelegate(),
                Ui.SLIDE_IMMEDIATE);
    }

    function createConfirmationMenu() {
        return ConfirmationMenu.create();
    }

    function pushConfirmationMenu(delegate) {
        Ui.pushView(self.createConfirmationMenu(),
                new ConfirmationMenuDelegate(delegate),
                Ui.SLIDE_UP);
    }

    function createViewSettingsMenu(deviceController) {
        return ViewSettingsMenu.create(deviceController);
    }

    function createAlertSettingsMenu() {
        return AlertSettingsMenu.create();
    }

    function pushAlertSettingsMenu() {
        Ui.pushView(
            self.createAlertSettingsMenu(),
            new AlertSettingsMenuDelegate(App.getApp().getPropertiesProvider()),
            Ui.SLIDE_LEFT);
    }

    function pushDeviceMenu(deviceController) {
        Ui.pushView(
            self.createViewSettingsMenu(deviceController),
            new ViewSettingsMenuDelegate(deviceController),
            Ui.SLIDE_UP);
    }

    function getMainView() {
         return MainView.getView();
    }

    function switchScanView(useFirst) {
        var scanDataController = new ScanDataController();
        var opts = { :useFirst => useFirst };
        Ui.switchToView(
            new ScanDataView(scanDataController),
            new ScanDataDelegate(scanDataController, opts),
            Ui.SLIDE_DOWN);
    }

    function pushScanView(useFirst) {
        var scanDataController = new ScanDataController();
        var opts = { :useFirst => useFirst };
        Ui.pushView(
            new ScanDataView(scanDataController),
            new ScanDataDelegate(scanDataController, opts),
            Ui.SLIDE_DOWN);
    }

    function switchDeviceView(scanResult) {
        var deviceDataController = App.getApp().getDeviceController().pairNew(scanResult);
        if(null != deviceDataController)  {
            Ui.switchToView(
                new SearchModeView(deviceDataController),
                new SearchModeDelegate(deviceDataController),
                Ui.SLIDE_DOWN);
        } else {
            // TODO:  Show error
        }
    }

    function pushDeviceView(scanResult) {
        var deviceDataController = App.getApp().getDeviceController().pairNew(scanResult);
        if(null != deviceDataController)  {
            Ui.pushView(
                new SearchModeView(deviceDataController),
                new SearchModeDelegate(deviceDataController),
                Ui.SLIDE_DOWN);
        } else {
            // TODO:  Show error
        }
    }
}
