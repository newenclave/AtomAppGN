using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class MainViewDelegate extends Ui.BehaviorDelegate {

    private var _selectDoublePress;

    function initialize() {
        BehaviorDelegate.initialize();
        self._selectDoublePress = new DoublePressCheck(500);
    }

    function onSelect() {
        return true;
        if(self._selectDoublePress.press()) {
            var storedDev = App.getApp().getLastSavedDevice();
            if(null != storedDev) {
                App.getApp().getViewController().pushDeviceView(storedDev);
            } else {
                App.getApp().scanStart();
                App.getApp().getViewController().pushScanView(true, true);
            }
            return true;
        }
        Ui.requestUpdate();
        return false;
    }

    function onMenu() {
        App.getApp().getViewController().pushMainManu();
        return true;
    }
}
