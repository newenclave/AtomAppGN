using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.Timer;

class DeviceDataView extends Ui.View {

    const THRESHOLDS_COLORS = [
        Gfx.COLOR_YELLOW,
        Gfx.COLOR_ORANGE,
        Gfx.COLOR_RED,
    ];

    private var _deviceDataController;

    function initialize(deviceDataController) {
        View.initialize();
        self._deviceDataController = deviceDataController;
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
        self.drawTemperature();
        View.onUpdate(dc);

        if(ready) {
            self.drawBattery(dc);
        }
    }

    function drawTemperature() {
        var value = self._deviceDataController.getTemperature();
        var txt = self._deviceDataController.getTemperatureUnitsString();
        Ui.View.findDrawableById("DeviceViewLabelTemperature").setText(value + txt);
    }

    private function drawConnecting() {
        var text = Application.loadResource(Rez.Strings.text_connecting);
        Ui.View.findDrawableById("DeviceViewLabelSessionTime").setText(text);
    }

    private function drawDoseRate(dc) {
        var dosePw = self._deviceDataController.getDoseRate();
        var labelPw = Ui.View.findDrawableById("DeviceViewLabelDoseRate");
        var color = Gfx.COLOR_GREEN;
        var th = self._deviceDataController.getDoseThreshold();
        if(th >= 0) {
            color = THRESHOLDS_COLORS[th];
        }
        labelPw.setColor(color);
        var doseRateText = dosePw.format("%.2f");
        labelPw.setText(doseRateText);
        Ui.View.findDrawableById("DeviceViewLabelDoseUnits").setText(self._deviceDataController.getDoseUnitString());
    }

    private function drawDoseAccumulated(dc) {
        var label = Ui.View.findDrawableById("DeviceViewLabelDoseAcc");
        var accDose = self._deviceDataController.getDoseAccumulated();
        var color = Gfx.COLOR_WHITE;
        var th = self._deviceDataController.getDoseAccumelatedThreshold();
        if(th >= 0) {
            color = THRESHOLDS_COLORS[th];
        }
        label.setColor(color);
        label.setText(accDose.format("%.4f"));
    }

    private function drawCPM(dc) {
        var text = Application.loadResource(Rez.Strings.text_CPM)
                 + " " + self._deviceDataController.getCPM().toString();
        Ui.View.findDrawableById("DeviceViewLabelCPM").setText(text);
    }

    private function drawWorkingTime(dc, connected) {
        var time = self._deviceDataController.getMeasuringTime() / 1000;
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
        var fillWidth = (width.toFloat() / 100.0 * self._deviceDataController.getCharge()).toNumber();
        var height = 10;
        var posX = (dc.getWidth() / 2) - (width / 2);
        var posY = self.getHeightPercents(dc, 4);
        var charging = self._deviceDataController.isCharging();
        var charge = self._deviceDataController.getCharge();

         if(charge < 15) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        } else if (charge < 30) {
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
