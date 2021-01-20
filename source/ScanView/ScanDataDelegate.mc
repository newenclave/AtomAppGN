using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ScanDataDelegate extends Ui.BehaviorDelegate {

    private var _scanDataController;
    private var _useFirst = false;
    private var _addDevice = false;

    function initialize(scanDataController, options) {
        BehaviorDelegate.initialize();
        self._scanDataController = scanDataController;
        self._scanDataController.setUpdateListener(self);
        if(options.hasKey(:useFirst)) {
            self._useFirst = options.get(:useFirst);
        }
        if(options.hasKey(:addDevice)) {
            self._addDevice = options.get(:addDevice);
        }
    }

    function onNewDataUpdate() {
        if(self._useFirst) {
            self.onSelect();
        } else {
            Ui.requestUpdate();
        }
    }

    function onBack() {
        App.getApp().scanStop();
        return false;
    }

    function onNextPage() {
        self._scanDataController.getModel().next();
        Ui.requestUpdate();
        return true;
    }

    function onPreviousPage() {
        self._scanDataController.getModel().prev();
        Ui.requestUpdate();
        return true;
    }

    function onSelect() {
        var cur = self._scanDataController.getModel().getCur();
        if(null != cur) {
            App.getApp().scanStop();
            if(self._addDevice) {
                App.getApp().getDeviceStorage().add(new DeviceWrapper(cur));
                Ui.popView(Ui.SLIDE_UP);
            } else {
                App.getApp().getViewController().switchDeviceView(cur);
            }
        }
        return true;
    }
}