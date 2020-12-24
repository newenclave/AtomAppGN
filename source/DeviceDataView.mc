using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.Timer;

class DeviceDataView extends Ui.View {

    private var _deviceDataController;
    private var _deviceData;

    function initialize(deviceDataController) {
        View.initialize();
        self._deviceDataController = deviceDataController;
        self._deviceData = self._deviceDataController.getModel();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.DeviceLayout(dc));
        self.drawConnecting();
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
        dc.clear();
        var ready = self._deviceDataController.ready();
        self.drawWorkingTime(dc, ready);
        self.drawDoseRate(dc);
        self.drawCPM(dc);
        self.drawDoseAccumulated(dc);
        View.onUpdate(dc);

        if(ready) {
            self.drawBattery(dc);
        }
    }

    private function drawConnecting() {
        var text = Application.loadResource(Rez.Strings.text_connecting);
        Ui.View.findDrawableById("DeviceViewLabelSessionTime").setText(text);
    }

    private function drawDoseRate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        var dosePowerText = (self._deviceData.dosePower * 1).format("%.2f");
        Ui.View.findDrawableById("DeviceViewLabelDoseRate").setText(dosePowerText);
        Ui.View.findDrawableById("DeviceViewLabelDoseUnits").setText(Application.loadResource(Rez.Strings.text_milli_sieverts));
    }

    private function drawDoseAccumulated(dc) {
        var label = Ui.View.findDrawableById("DeviceViewLabelDoseAcc");
        label.setText(self._deviceData.doseAccumulated.format("%.4f"));
    }

    private function drawCPM(dc) {
        var text = Application.loadResource(Rez.Strings.text_CPM)
                 + " " + self._deviceData.getCPM().toString();
        Ui.View.findDrawableById("DeviceViewLabelCPM").setText(text);
    }

    private function drawWorkingTime(dc, connected) {
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        var time = self._deviceData.getMeasuringTime() / 1000;
        var seconds = time % 60;
        var minutes = (time / 60) % 60;
        var hours = (time / 60) / 60;
        var text = Application.loadResource(Rez.Strings.text_session_time)
                + " " + hours.format("%02d")
                + ":" + minutes.format("%02d")
                + ":" + seconds.format("%02d");

        var today = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = today.hour.format("%02d")
                    + ":" + today.min.format("%02d");

        Ui.View.findDrawableById("DeviceViewLabelTime").setText(dateString);
        if(connected) {
            Ui.View.findDrawableById("DeviceViewLabelSessionTime").setText(text);
        }
    }

    private function drawBattery(dc) {
        var width = 40;
        var fillWidth = (width.toFloat() / 100.0 * self._deviceData.charge).toNumber();
        var height = 10;
        var posX = (dc.getWidth() / 2) - (width / 2);
        var posY = self.getHeightPercents(dc, 4);
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
