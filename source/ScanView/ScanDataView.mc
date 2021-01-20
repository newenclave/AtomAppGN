using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.Application as App;

class ScanDataView extends BaseView {

    private var _scanDataController;

    function initialize(scanDataController) {
        BaseView.initialize();
        self._scanDataController = scanDataController;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.ScanLayout(dc));
        return true;
    }

    function onUpdate(dc) {
        var theme = self.getTheme();
        self.drawBg(dc);
        self.drawCount(dc, theme);
        self.drawCurrent(dc, theme);
        //View.onUpdate(dc);
    }

    function drawCurrent(dc, theme) {
        var model = self._scanDataController.getModel();
        var size = model.getSize();

        if(size > 0) {
            var name = model.getCur().getDeviceName();
            var rssi = model.getCur().getRssi();

            var devNameLabel = Ui.View.findDrawableById("ScanViewLabelDeviceName");
            var devdetailLabel = Ui.View.findDrawableById("ScanViewLabelDeviceDetail1");

            devNameLabel.setColor(theme.COLOR_LIGHT);
            devdetailLabel.setColor(theme.COLOR_DARK);
            devNameLabel.setText((name ? name : "Atom Fast"));
            devdetailLabel.setText("rssi: " + rssi.toString());
            devNameLabel.draw(dc);
            devdetailLabel.draw(dc);

        } else {
            var label = Ui.View.findDrawableById("ScanViewLabelDeviceName");
            label.setColor(theme.COLOR_LIGHT);
            label.setText(Application.loadResource(Rez.Strings.text_scanning));
            label.draw(dc);
        }
    }

    function drawCount(dc, theme) {
        var size = self._scanDataController.getModel().getSize();
        var count = (size > 0) ? (self._scanDataController.getModel().getIndex() + 1) : 0;
        var text = count.toString() + "/" + size.toString();
        var label = Ui.View.findDrawableById("ScanViewLabelCounter");
        label.setText(text);
        label.setColor(theme.COLOR_LIGHT);
        label.draw(dc);
    }

}
