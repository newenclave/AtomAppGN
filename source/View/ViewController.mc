using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ViewController {

    function pushMainManu() {
        Ui.pushView(
                new MainViewMenu(),
                new MainMenuDelegate(),
                Ui.SLIDE_UP);
    }

    function switchMainManu() {
        Ui.switchToView(
                new MainViewMenu(),
                new MainMenuDelegate(),
                Ui.SLIDE_IMMEDIATE);
    }

    function pushConfirmationMenu(delegate) {
        Ui.pushView(
                new ConfirmationMenu(),
                new ConfirmationMenuDelegate(delegate),
                Ui.SLIDE_UP);
    }

    function pushAlertSettingsMenu() {
        Ui.pushView(
            new AlertSettingsMenu(),
            new AlertSettingsMenuDelegate(App.getApp().getPropertiesProvider()),
            Ui.SLIDE_LEFT);
    }

    function pushDeviceMenu(deviceController) {
        Ui.pushView(
            new ViewSettingsMenu(deviceController),
            new ViewSettingsMenuDelegate(deviceController),
            Ui.SLIDE_UP);
    }

    function getMainView() {
         return MainView.getView();
    }

    function switchScanView(useFirst, addDevice) {
        var scanDataController = new ScanDataController();
        var opts = {
            :useFirst => useFirst,
            :addDevice => addDevice
        };
        Ui.switchToView(
            new ScanDataView(scanDataController),
            new ScanDataDelegate(scanDataController, opts),
            Ui.SLIDE_DOWN);
    }

    function pushScanView(useFirst, addDevice) {
        var scanDataController = new ScanDataController();
        var opts = {
            :useFirst => useFirst,
            :addDevice => addDevice
        };
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

    function switchDeviceList(selector) {
        Ui.switchToView(
            new DeviceListView(selector),
            new DeviceListDelegate(selector),
            Ui.SLIDE_DOWN);
    }

    function switchDeviceList2(selector) {
        Ui.switchToView(
            new DeviceListView(selector),
            new DeviceListDelegate(selector),
            Ui.SLIDE_IMMEDIATE);
    }
}
