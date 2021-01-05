using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class MeasuringView extends BaseView {

    private var _deviceDataController;
    private var _theme;
    private var _isTouch;

    const THRESHOLDS_COLORS = [
        Gfx.COLOR_YELLOW,
        Gfx.COLOR_ORANGE,
        Gfx.COLOR_RED,
    ];

    function initialize(dataController) {
        BaseView.initialize();
        self._deviceDataController = dataController;
        self._isTouch = System.getDeviceSettings().isTouchScreen;
    }

    function getMeasuringData() {
        return self._deviceDataController.getMeasuringData();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MeasuringLayout(dc));
        return true;
    }

    function onShow() {
        self._deviceDataController.getMeasuringData().onShow();
    }

    function onHide() {
        self._deviceDataController.getMeasuringData().onHide();
    }

    function onUpdate(dc) {
        self._theme = self.getTheme();
        THRESHOLDS_COLORS[0] = self._theme.COLOR_ABOVE_NORMAL;
        THRESHOLDS_COLORS[1] = self._theme.COLOR_WARNING;
        THRESHOLDS_COLORS[2] = self._theme.COLOR_DANGER;

        self.drawBg(dc);
        self.drawHeader(dc);
        self.drawDoseRate(dc);
        self.drawUnits(dc);
        self.drawMeasureError(dc);
        self.drawCPM(dc);
        self.drawWorkingTime(dc, self._deviceDataController.getMeasuringData().enabled);
        self.drawSessionPulses(dc);
    }

    function drawHeader(dc) {
        var label = self.findDrawable("MeasuringLabelName");
        label.setText(Rez.Strings.text_measuring_header);
        label.draw(dc);
    }

    function drawSessionPulses(dc) {
        var label = self.findDrawable("MeasuringLabelPulses");
        var pulses = self._deviceDataController.getMeasuringData().pulsesMeasure.toNumber();
        label.setText(pulses.toString());
        label.draw(dc);
    }

    private function drawWorkingTime(dc, working) {
        var sessionLabel = self.findDrawable("MeasuringLabelSessionTime");
        if(!self._deviceDataController.getReady()) {
            sessionLabel.setText(Application.loadResource(Rez.Strings.text_connecting));
            sessionLabel.draw(dc);
            return;
        }
        var time = self._deviceDataController.getMeasureSessionTime() / 1000;
        var seconds = time % 60;
        var minutes = (time / 60) % 60;
        var hours = (time / 60) / 60;
        var text = Application.loadResource(Rez.Strings.text_measuring_time)
                + "\n" + hours.format("%02d")
                + ":" + minutes.format("%02d")
                + ":" + seconds.format("%02d");

        if(working) {
            sessionLabel.setText(text);
        } else {
            if(self._isTouch) {
                sessionLabel.setText(Application.loadResource(Rez.Strings.text_measuring_wait_to_tap));
            } else {
                sessionLabel.setText(Application.loadResource(Rez.Strings.text_measuring_wait_to_start));
            }
        }
        sessionLabel.setColor(self._theme.COLOR_DARK);
        sessionLabel.draw(dc);
    }

    private function drawCPM(dc) {
        var useCPS = Application.getApp().getPropertiesProvider().getUseCPS();
        var label = self.findDrawable("MeasuringLabelCPM");
        var text = "";
        if(useCPS) {
            text = Application.loadResource(Rez.Strings.text_CPS)
                     + " " + self._deviceDataController.getMeasuringData().getCPS().toString();
        } else {
            text = Application.loadResource(Rez.Strings.text_CPM)
                     + " " + self._deviceDataController.getMeasuringData().getCPM().toString();
        }
        label.setText(text);
        label.draw(dc);
    }

    function drawMeasureError(dc) {
        var label = self.findDrawable("MeasuringLabelError");
        var error = self._deviceDataController.getMeasuringData().errorMeasure;
        var sigma = self._deviceDataController.getUsedSigma() + 1;
        //label.setText(error.format("%.1f") + "%");
        label.setText(Math.round(error * sigma).toNumber().toString() + "%");
        label.draw(dc);
    }

    function drawUnits(dc) {
        var label = self.findDrawable("MeasuringLabelDoseUnits");
        label.setColor(self._theme.COLOR_DARK);
        label.setText(self._deviceDataController.getDoseHoursUnitString());
        label.draw(dc);
    }

    function drawDoseRate(dc) {
        var dosePw = self._deviceDataController.getMeasuringDose();
        var labelPw = self.findDrawable("MeasuringLabelDoseRate");
        var color = self._theme.COLOR_NORMAL;
        var th = self._deviceDataController.getDoseThreshold();
        if(th >= 0) {
            color = THRESHOLDS_COLORS[th];
        }
        labelPw.setColor(color);
        labelPw.setText(dosePw.format("%.2f"));
        labelPw.draw(dc);
    }
}
