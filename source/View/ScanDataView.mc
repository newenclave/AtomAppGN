using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Ble;

class ScanDataView extends Ui.View {

    private var _scanDataController;

    function initialize(scanDataController) {
        View.initialize();
        self._scanDataController = scanDataController;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.ScanLayout(dc));
        return true;
    }

    function onShow() {
    }

    function onHide() {
    }

    function onUpdate(dc) {
        self.drawCount(dc);
        self.drawCurrent(dc);
        View.onUpdate(dc);
    }

    function drawCurrent(dc) {
        var model = self._scanDataController.getModel();
        var size = model.getSize();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

        if(size > 0) {
            var name = model.getCur().getDeviceName();
            var rssi = model.getCur().getRssi();

            Ui.View.findDrawableById("ScanViewLabelDeviceName").setText((name ? name : "Atom Fast"));
            Ui.View.findDrawableById("ScanViewLabelDeviceDetail1").setText("rssi: " + rssi.toString());
        } else {
            Ui.View.findDrawableById("ScanViewLabelDeviceName").setText(Application.loadResource(Rez.Strings.text_scanning));
        }
    }

    function drawCount(dc) {
        var size = self._scanDataController.getModel().getSize();
        var count = (size > 0) ? (self._scanDataController.getModel().getIndex() + 1) : 0;
        var text = count.toString() + "/" + size.toString();
        Ui.View.findDrawableById("ScanViewLabelCounter").setText(text);
    }
}
