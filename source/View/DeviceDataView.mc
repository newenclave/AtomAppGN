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
        self.drawSearchError(dc);
        //self.drawSystemBattery(dc);
        //View.onUpdate(dc);
        self.drawBattery(dc);

//        if(ready) {
//            self.drawBattery(dc, textLeft);
//        }
    }

    function drawTemperature(dc) {
        var value = self._deviceDataController.getTemperature();
        var txt = self._deviceDataController.getTemperatureUnitsString();
        var label = self.findDrawable("DeviceViewLabelTemperature");
        label.setText(value + txt);
        label.setColor(self._theme.COLOR_DARK);
        label.draw(dc);
    }

    private function drawConnecting() {
        var text = Application.loadResource(Rez.Strings.text_connecting);
        Ui.View.findDrawableById("DeviceViewLabelSessionTime").setText(text);
    }

    private function drawDoseRate(dc) {
        var dosePw = self._deviceDataController.getDoseRate();
        var labelPw = self.findDrawable("DeviceViewLabelDoseRate");

        var color = self._theme.COLOR_NORMAL;
        var th = self._deviceDataController.getDoseThreshold();
        if(th >= 0) {
            color = THRESHOLDS_COLORS[th];
        }
        labelPw.setColor(color);
        var doseRateText = dosePw.format("%.2f");
        labelPw.setText(doseRateText);
        var du = self.findDrawable("DeviceViewLabelDoseUnits");
        du.setText(self._deviceDataController.getDoseHoursUnitString());
        du.setColor(self._theme.COLOR_DARK);
        du.draw(dc);
        labelPw.draw(dc);
    }

    private function drawDoseAccumulated(dc) {
        var label = Ui.View.findDrawableById("DeviceViewLabelDoseAcc");
        var accDose = self._deviceDataController.getDoseAccumulated();
        var color = self._theme.COLOR_FOREGROUND;
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
        var value = 0;
        if(useCPS) {
            value = (self._deviceDataController.getCPS());
            text = Application.loadResource(Rez.Strings.text_CPS)
                     + " " + value.toString();
        } else {
            value = self._deviceDataController.getCPM();
            text = Application.loadResource(Rez.Strings.text_CPM)
                     + " " + value.toString();
        }
        label.setText(text);
        label.draw(dc);
    }

    private function drawSearchError(dc) {
        var label = self.findDrawable("DeviceViewLabelSearchError");
        label.setText(self._deviceDataController.getSearchError().toNumber().toString() + "%");
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
        sessionLabel.setColor(self._theme.COLOR_DARK);
        sessionLabel.draw(dc);
    }

    private function drawBattery(dc) {
        var percentsLabel = self.findDrawable("DeviceViewAtomBatteryPercens");
        percentsLabel.setText(self._deviceDataController.getCharge().toString() + "%");
        percentsLabel.setColor(self._theme.COLOR_DARK);
        percentsLabel.draw(dc);

        var width = self.getWidthPercents(dc, 14);
        var height = self.getHeightPercents(dc, 6);

        var posX = self.getWidthPercents(dc, 35);
        var posY = self.getHeightPercents(dc, 4); // 4;

        self.drawBatteryBase(dc,
//            System.getSystemStats().battery.toNumber(),
            self._deviceDataController.getCharge(),
            posX, posY, width, height);

//        self.drawBatteryLeftArc(dc, System.getSystemStats().battery.toNumber());
//        self.drawBatteryRightArc(dc, self._deviceDataController.getCharge());
    }

    private function drawBatteryLeftArc(dc, chargeVal) {
        dc.setPenWidth(1);
        var charge = (chargeVal * (90.0 / 100.0)).toNumber();
        var arkRadius = self.getWidthPercents(dc, 46);
        var center = [self.getWidthPercents(dc, 50), self.getHeightPercents(dc, 50)];

        dc.setPenWidth(10);
        dc.setColor(self._theme.COLOR_DARK, self._theme.COLOR_BACKGROUND);
        dc.drawArc(center[0], center[1],
            arkRadius, Graphics.ARC_COUNTER_CLOCKWISE, 90 + 45 - 1, 180 + 45 + 1);

        dc.setPenWidth(8);
        dc.setColor(self._theme.COLOR_BACKGROUND, self._theme.COLOR_BACKGROUND);
        dc.drawArc(center[0], center[1],
            arkRadius, Gfx.ARC_COUNTER_CLOCKWISE, 90 + 45, 180 + 45);

        if(charge > 0) {
            dc.setPenWidth(6);
            dc.setColor(self.getBatteryColor(chargeVal), self._theme.COLOR_BACKGROUND);
            dc.drawArc(center[0], center[1],
                arkRadius, Gfx.ARC_CLOCKWISE, 180 + 45, 180 + 45 - charge);
        }

//        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
//        dc.drawArc(center[0], center[1],
//            arkRadius, Gfx.ARC_COUNTER_CLOCKWISE, 270 + 45, (270 + 45 + charge) % 360);

//        dc.setColor(self._theme.COLOR_NORMAL, self._theme.COLOR_BACKGROUND);
//        dc.drawArc(self.getWidthPercents(dc, 50), self.getHeightPercents(dc, 50),
//            self.getWidthPercents(dc, 48), Graphics.ARC_CLOCKWISE, 90, 270 + 45);

        dc.setPenWidth(1);

    }

    private function drawBatteryRightArc(dc, chargeVal) {
        dc.setPenWidth(1);
        var charge = (chargeVal * (44.0 / 100.0)).toNumber();
        var arkRadius = self.getWidthPercents(dc, 46);
        var center = [self.getWidthPercents(dc, 50), self.getHeightPercents(dc, 50)];

        dc.setPenWidth(10);
        dc.setColor(self._theme.COLOR_DARK, self._theme.COLOR_BACKGROUND);
        dc.drawArc(center[0], center[1],
            arkRadius, Graphics.ARC_CLOCKWISE, 46, 0);

        dc.setPenWidth(8);
        dc.setColor(self._theme.COLOR_BACKGROUND, self._theme.COLOR_BACKGROUND);
        dc.drawArc(center[0], center[1],
            arkRadius, Gfx.ARC_CLOCKWISE, 45, 1);

        if(charge > 0) {
            dc.setPenWidth(6);
            dc.setColor(self.getBatteryColor(charge), self._theme.COLOR_BACKGROUND);
            dc.drawArc(center[0], center[1],
                arkRadius, Gfx.ARC_COUNTER_CLOCKWISE, 1, (1 + charge) % 360);
        }

//        dc.setColor(self._theme.COLOR_NORMAL, self._theme.COLOR_BACKGROUND);
//        dc.drawArc(self.getWidthPercents(dc, 50), self.getHeightPercents(dc, 50),
//            self.getWidthPercents(dc, 48), Graphics.ARC_CLOCKWISE, 90, 270 + 45);

        dc.setPenWidth(1);

    }

    static private function drawBatteryBase(dc, charge, x, y, width, height) {
        var fillWidth = self.getBatteryFill(charge, width - 4);

        dc.setColor(self.getBatteryColor(charge), self._theme.COLOR_BACKGROUND);
        dc.fillRectangle(x + 2, y + 2, fillWidth, height - 4);

        dc.setColor(self._theme.COLOR_DARK, self._theme.COLOR_BACKGROUND);
        dc.drawRoundedRectangle(x, y, width, height, 2);

        var h30 = height / 3;
        dc.fillRoundedRectangle(x + width - 1, y + (height / 2) - (h30 / 2), 3, h30, 2);
    }

    static private function drawVerticalBatteryBase(dc, charge, x, y, width, height) {
        var fillHeight = self.getBatteryFill(charge, height - 4);
        dc.setColor(self.getBatteryColor(charge), self._theme.COLOR_BACKGROUND);

        dc.fillRectangle(x + 2, y + height - 2 - fillHeight, width - 4, fillHeight);

        dc.setColor(self._theme.COLOR_DARK, self._theme.COLOR_BACKGROUND);
        dc.drawRoundedRectangle(x, y, width, height, 2);
    }

    static private function getBatteryFill(charge, value) {
        var factor = 100.0 / value;
        var result = ((charge / factor) + ((charge.toNumber() % factor.toNumber()) > 0 ? 1 : 0)).toNumber();
        if(result > value) {
            result = value;
        }
        return result;
    }

    static private function getBatteryColor(charge) {
        if(charge < 15) {
            return self._theme.COLOR_DANGER;
        } else if (charge < 30) {
            return self._theme.COLOR_ABOVE_NORMAL;
        } else {
            return self._theme.COLOR_NORMAL;
        }
    }
}
