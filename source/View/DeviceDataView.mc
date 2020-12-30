using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.Timer;

class DeviceDataView extends BaseView {

    const THRESHOLDS_COLORS = [
        Gfx.COLOR_YELLOW,
        Gfx.COLOR_ORANGE,
        Gfx.COLOR_RED,
    ];

    private var _deviceDataController;
    private var _theme;

    function initialize(deviceDataController) {
        BaseView.initialize();
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
        self._theme = self.getTheme();
        THRESHOLDS_COLORS[0] = self._theme.COLOR_ABOVE_NORMAL;
        THRESHOLDS_COLORS[1] = self._theme.COLOR_WARNING;
        THRESHOLDS_COLORS[2] = self._theme.COLOR_DANGER;
        dc.clear();
        var ready = self._deviceDataController.getReady();
        self.drawBg(dc);
        self.drawWorkingTime(dc, ready);
        self.drawDoseRate(dc);
        self.drawCPM(dc);
        self.drawDoseAccumulated(dc);
        self.drawTemperature(dc);
        //View.onUpdate(dc);
//
        if(ready) {
            self.drawBattery(dc);
        }
    }

    function drawTemperature(dc) {
        var value = self._deviceDataController.getTemperature();
        var txt = self._deviceDataController.getTemperatureUnitsString();
        var label = self.findDrawable("DeviceViewLabelTemperature");
        label.setText(value + txt);
        label.setColor(_theme.COLOR_DARK);
        label.draw(dc);
    }

    private function drawConnecting() {
        var text = Application.loadResource(Rez.Strings.text_connecting);
        Ui.View.findDrawableById("DeviceViewLabelSessionTime").setText(text);
    }

    private function drawDoseRate(dc) {
        var dosePw = self._deviceDataController.getDoseRate();
        var labelPw = self.findDrawable("DeviceViewLabelDoseRate");

        var color = _theme.COLOR_NORMAL;
        var th = self._deviceDataController.getDoseThreshold();
        if(th >= 0) {
            color = THRESHOLDS_COLORS[th];
        }
        labelPw.setColor(color);
        var doseRateText = dosePw.format("%.2f");
        labelPw.setText(doseRateText);
        var du = self.findDrawable("DeviceViewLabelDoseUnits");
        du.setText(self._deviceDataController.getDoseHoursUnitString());
        du.setColor(_theme.COLOR_DARK);
        du.draw(dc);
        labelPw.draw(dc);
    }

    private function drawDoseAccumulated(dc) {
        var label = Ui.View.findDrawableById("DeviceViewLabelDoseAcc");
        var accDose = self._deviceDataController.getDoseAccumulated();
        var color = _theme.COLOR_FOREGROUND;
        var th = self._deviceDataController.getDoseAccumelatedThreshold();
        if(th >= 0) {
            color = THRESHOLDS_COLORS[th];
        }
        label.setColor(color);
        label.setText(accDose.format("%.4f"));
        label.draw(dc);
    }

    private function drawCPM(dc) {
        var useCPS = Application.getApp().getPropertiesProvider().getUseCPS();
        var label = self.findDrawable("DeviceViewLabelCPM");
        var text = "";
        if(useCPS) {
            text = Application.loadResource(Rez.Strings.text_CPS)
                     + " " + self._deviceDataController.getCPS().toString();
        } else {
            text = Application.loadResource(Rez.Strings.text_CPM)
                     + " " + self._deviceDataController.getCPM().toString();
        }
        label.setText(text);
        label.draw(dc);
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

        var label = self.findDrawable("DeviceViewLabelTime");
        var sessionLabel = self.findDrawable("DeviceViewLabelSessionTime");
        label.setText(dateString);
        label.draw(dc);
        if(connected) {
            sessionLabel.setText(text);
        }
        sessionLabel.setColor(_theme.COLOR_DARK);
        sessionLabel.draw(dc);
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
            dc.setColor(_theme.COLOR_DANGER, _theme.COLOR_BACKGROUND);
        } else if (charge < 30) {
            dc.setColor(_theme.COLOR_ABOVE_NORMAL, _theme.COLOR_BACKGROUND);
        } else {
            dc.setColor(Graphics.COLOR_NORMAL, _theme.COLOR_BACKGROUND);
        }

        dc.drawRectangle(posX, posY, width, height);
        dc.fillRectangle(posX, posY, fillWidth, height);
        if(charging) {
            dc.drawText(posX + width + 5, posY, Graphics.FONT_SMALL, "⚡", Graphics.TEXT_JUSTIFY_LEFT);
        }
    }
}
