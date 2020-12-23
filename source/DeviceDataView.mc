using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Ble;

class DeviceDataView extends Ui.View {

    private var _deviceDataController;
    private var _deviceData;

    function initialize(deviceDataController) {
        View.initialize();
        self._deviceDataController = deviceDataController;
        self._deviceData = self._deviceDataController.getModel();
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    private function getWidthPercents(dc, value) {
        return (dc.getWidth().toFloat() * (value.toFloat() / 100.0)).toNumber();
    }

    private function getHeightPercents(dc, value) {
        return (dc.getHeight().toFloat() * (value.toFloat() / 100.0)).toNumber();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        if(!self._deviceDataController.ready()) {
            self.drawConnecting(dc);
        } else {
            self.drawBattery(dc);
        }
        self.drawDoseRate(dc);
        self.drawCPM(dc);
        self.drawDoseAccumulated(dc);
    }

    private function drawConnecting(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2,  20,
                    Graphics.FONT_GLANCE,
                    Application.loadResource(Rez.Strings.text_connecting),
                    Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawDoseRate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        var dosePowerText = self._deviceData.dosePower.format("%.2f");

        var txtDim = dc.getTextDimensions(dosePowerText, Graphics.FONT_NUMBER_MEDIUM);
        var textY = (dc.getHeight() / 2) - (txtDim[1]/2);

        dc.drawText(15, textY,
                    Graphics.FONT_NUMBER_MEDIUM,
                    dosePowerText,
                    Graphics.TEXT_JUSTIFY_LEFT);

        var labelTxt = Application.loadResource(Rez.Strings.text_milli_sieverts);
        var labelDim = dc.getTextDimensions(labelTxt, Graphics.FONT_SMALL);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(15 + txtDim[0] + 5, textY + txtDim[1] - labelDim[1],
                    Graphics.FONT_SMALL,
                    labelTxt,
                    Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function drawDoseAccumulated(dc) {
        var yPos = (dc.getHeight().toFloat() * 0.80).toNumber();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, yPos,
                    Graphics.FONT_LARGE,
                    self._deviceData.doseAccumulated.format("%.4f"),
                    Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawImpulses(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(self.getWidthPercents(dc, 10), self.getHeightPercents(dc, 65),
                    Graphics.FONT_SMALL,
                    self._deviceData.impulses,
                    Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function drawCPM(dc) {
        var text = Application.loadResource(Rez.Strings.text_CPM)
                 + " " + self._deviceData.getCPM().toString();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(self.getWidthPercents(dc, 10), self.getHeightPercents(dc, 65),
                    Graphics.FONT_SMALL,
                    text,
                    Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function drawBattery(dc) {
        var width = 40;
        var fillWidth = (width.toFloat() / 100.0 * self._deviceData.charge).toNumber();
        var height = 10;
        var posX = (dc.getWidth() / 2) - (width / 2);
        var posY = 15;
        var charging = self._deviceData.isCharging();

         if(self._deviceData.charge < 15) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        } else if (self._deviceData.charge < 30) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        }

        dc.drawRectangle(posX, posY, width, height);
        dc.fillRectangle(posX, posY, fillWidth, height);
        if(charging) {
            dc.drawText(posX + width + 5, posY, Graphics.FONT_SMALL, "⚡", Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

}
