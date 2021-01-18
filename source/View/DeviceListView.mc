using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DeviceListView extends BaseView {

    function initialize() {
        BaseView.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.DeviceListLayout(dc));
    }

    function onShow() {
    }

    function onHide() {
    }

    function getStateByController(controller) {
        if(null == controller) {
            return "disconnected";
        } else {
            if(controller.getReady()) {
                return controller.getDoseRate().toString();
            }
        }
        return "connecting...";
    }

    function onUpdate(dc) {
        //Ui.onUpdate(dc);

        var devcon = App.getApp().getDeviceStorage();
        var dev = App.getApp().getDevices();
        var top = devcon.getPrev();
        var center = devcon.getCurrent();
        var bottom = devcon.getNext();

        var total = devcon.getSize();
        var cur = (total > 0) ? devcon.getCurrentId() + 1 : 0;
        self.findDrawable("DeviceListCounter").setText(Lang.format("$1$/$2$", [cur, total]));

        self.findDrawable("DeviceListCenter").setText("");
        self.findDrawable("DeviceListTop").setText("");
        self.findDrawable("DeviceListBottom").setText("");
        if(null != center) {
            var scanRes = center.get("device");
            var controller = dev.getControllerByScanResult(scanRes);
            self.findDrawable("DeviceListCenter").setText(center.get("name") + " " + self.getStateByController(controller));
        }

        if(null != top) {
            var scanRes = top.get("device");
            var controller = dev.getControllerByScanResult(scanRes);
            self.findDrawable("DeviceListTop").setText(top.get("name") + " " + self.getStateByController(controller));
        }

        if(null != bottom) {
            var scanRes = bottom.get("device");
            var controller = dev.getControllerByScanResult(scanRes);
            self.findDrawable("DeviceListBottom").setText(bottom.get("name") + " " + self.getStateByController(controller));
        }
        View.onUpdate(dc);
    }
}
