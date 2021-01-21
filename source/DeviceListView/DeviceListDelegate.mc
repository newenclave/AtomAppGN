using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DeviceListDelegate extends Ui.BehaviorDelegate {

    private var _colorSelector;

    function initialize(selector) {
        BehaviorDelegate.initialize();
        self._colorSelector = selector;
    }

    private function getDeviceStorage() {
        return App.getApp().getDeviceStorage();
    }

    function onMenu() {
        if(null == self._colorSelector) {
            Ui.pushView(new DeviceListMenu(), new DeviceListMenuDelegate(), Ui.SLIDE_RIGHT);
        }
        return true;
    }

    function onBack() {
        if(null != self._colorSelector) {
            Ui.popView(Ui.SLIDE_IMMEDIATE);
            return true;
        }
        return false;
    }

    function onNextPage() {
        if(null != self._colorSelector) {
            self._colorSelector.prev();
        } else {
            self.getDeviceStorage().next();
        }
        Ui.requestUpdate();
        return true;
    }

    function onPreviousPage() {
        if(null != self._colorSelector) {
            self._colorSelector.next();
        } else {
            self.getDeviceStorage().prev();
        }
        Ui.requestUpdate();
        return true;
    }

    function onSelect() {
        var device = self.getDeviceStorage().getCurrent();
        if(null != device) {
            if(self._colorSelector) {
                device.setColor(self._colorSelector.getCurrentColor());
                App.getApp().getDeviceStorage().store();
                Ui.popView(Ui.SLIDE_IMMEDIATE);
            } else {
                App.getApp().getViewController().pushDeviceView(device.getScanResult());
            }
            return true;
        }
        return false;
    }
}
