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
        var width = self.getWidthPercents(dc, 20);
        var height = 12; //self.getHeightPercents(dc, 4);

        var posX = self.getWidthPercents(dc, 40);
        var posX2 = self.getWidthPercents(dc, 53);
        var posY = self.getHeightPercents(dc, 2); // 4;

//        self.drawBatteryBase(dc,
//            System.getSystemStats().battery.toNumber(),
//            posX, posY, width, height);

        self.drawBatteryBase(dc,
//            System.getSystemStats().battery.toNumber(),
            self._deviceDataController.getCharge(),
            posX, posY, width, height);

//        self.drawVerticalBatteryBase(dc,
//            System.getSystemStats().battery.toNumber(),
////            self._deviceDataController.getCharge(),
//            posX, posY, width, 20);

//        posX = self.getWidthPercents(dc, 10);
//        posY = self.getHeightPercents(dc, 20);
//        self.drawVerticalBatteryBase(dc, System.getSystemStats().battery.toNumber(),
//            posX, posY, 15, 20);
//        self.drawVerticalBatteryBase(dc, System.getSystemStats().battery.toNumber(),
//            posX + 20, posY, 15, 20);
    }

    static private function drawBatteryBase(dc, charge, x, y, width, height) {
        var factor = 100.0 / (width - 4);
        var fillWidth = ((charge / factor) + ((charge.toNumber() % factor.toNumber()) > 0 ? 1 : 0)).toNumber();
        if(fillWidth > (width - 4)) {
            fillWidth = (width - 4);
        }

        if(charge < 15) {
            dc.setColor(self._theme.COLOR_DANGER, self._theme.COLOR_BACKGROUND);
        } else if (charge < 30) {
            dc.setColor(self._theme.COLOR_ABOVE_NORMAL, self._theme.COLOR_BACKGROUND);
        } else {
            dc.setColor(self._theme.COLOR_NORMAL, self._theme.COLOR_BACKGROUND);
        }

        dc.fillRectangle(x + 2, y + 2, fillWidth, height - 4);

        dc.setColor(self._theme.COLOR_DARK, self._theme.COLOR_BACKGROUND);
        dc.drawRoundedRectangle(x, y, width, height, 2);
    }

    static private function drawVerticalBatteryBase(dc, charge, x, y, width, height) {
        var factor = 100.0 / (height - 4);
        var fillHeight = ((charge / factor) + ((charge.toNumber() % factor.toNumber()) > 0 ? 1 : 0)).toNumber();
        if(fillHeight > (height - 4)) {
            fillHeight = (height - 4);
        }

        if(charge < 15) {
            dc.setColor(self._theme.COLOR_DANGER, self._theme.COLOR_BACKGROUND);
        } else if (charge < 30) {
            dc.setColor(self._theme.COLOR_ABOVE_NORMAL, self._theme.COLOR_BACKGROUND);
        } else {
            dc.setColor(self._theme.COLOR_NORMAL, self._theme.COLOR_BACKGROUND);
        }

        dc.fillRectangle(x + 2, y + height - 2 - fillHeight, width - 4, fillHeight);

        dc.setColor(self._theme.COLOR_DARK, self._theme.COLOR_BACKGROUND);
        dc.drawRoundedRectangle(x, y, width, height, 2);
    }
}
