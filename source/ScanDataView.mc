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
    }

    function onShow() {
    }

    function onHide() {
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
        var cur = self._scanDataController.getModel().getCur();
        if(null != cur) {
            var name = cur.getDeviceName();
            System.println("Current " + (name ? name : "Atom Fast")
                + " rssi: " + cur.getRssi().toString());
        }
        self.drawCount(dc);
        self.drawCurrent(dc);
    }

    function drawCurrent(dc) {
        var model = self._scanDataController.getModel();
        var size = model.getSize();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

        if(size > 0) {
            var name = model.getCur().getDeviceName();
            var rssi = model.getCur().getRssi();
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - dc.getFontHeight(Gfx.FONT_MEDIUM),
                Gfx.FONT_MEDIUM,
                (name ? name : "Atom Fast"),
                Gfx.TEXT_JUSTIFY_CENTER);

            dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + dc.getFontHeight(Gfx.FONT_SMALL),
                Gfx.FONT_SMALL,
                "rssi: " + rssi.toString(),
                Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2,
                Gfx.FONT_MEDIUM,
                Application.loadResource(Rez.Strings.text_scanning),
                Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

    function drawCount(dc) {

        var size = self._scanDataController.getModel().getSize();
        var count = (size > 0) ? (self._scanDataController.getModel().getIndex() + 1) : 0;
        var text = count.toString() + "/" + size.toString();

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, 15, Gfx.FONT_SMALL,
            text, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
