using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ScanDataDelegate extends Ui.BehaviorDelegate {

    private var _scanDataController;
    private var _useFirst = false;

    function initialize(scanDataController, options) {
        BehaviorDelegate.initialize();
        self._scanDataController = scanDataController;
        self._scanDataController.setUpdateListener(self);
        if(options.hasKey(:useFirst)) {
            self._useFirst = options.get(:useFirst);
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

    function onMenu() {
        return true;
    }

    function onNextMode() {
        return true;
    }

    function onNextPage() {
        self._scanDataController.getModel().next();
        Ui.requestUpdate();
        return true;
    }

    function onPreviousMode() {
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
            App.getApp().getViewController().switchDeviceView(cur);
        }
        return true;
    }
}