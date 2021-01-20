using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DeviceDetailsView extends BaseView {

    private var _deviceDataController;
    private var _properties;

    function initialize(deviceDataController, props) {
        BaseView.initialize();
        self._deviceDataController = deviceDataController;
        self._properties = props;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.DeviceDetailsLayout(dc));
    }

    function onUpdate(dc) {
        var theme = self.getTheme();
        var colors = [
            theme.COLOR_ABOVE_NORMAL,
            theme.COLOR_WARNING,
            theme.COLOR_DANGER
        ];
        var doseValues = [
            Ui.View.findDrawableById("DeviceDetailL1Value"),
            Ui.View.findDrawableById("DeviceDetailL2Value"),
            Ui.View.findDrawableById("DeviceDetailL3Value"),
        ];
        var accDoseValues = [
            Ui.View.findDrawableById("DeviceDetailD1Value"),
            Ui.View.findDrawableById("DeviceDetailD2Value"),
            Ui.View.findDrawableById("DeviceDetailD3Value"),
        ];

        var detailsLabels = [
            [Ui.View.findDrawableById("DeviceDetailL1Label"), Ui.View.findDrawableById("DeviceDetailD1Label")],
            [Ui.View.findDrawableById("DeviceDetailL2Label"), Ui.View.findDrawableById("DeviceDetailD2Label")],
            [Ui.View.findDrawableById("DeviceDetailL3Label"), Ui.View.findDrawableById("DeviceDetailD3Label")]
        ];

        self.drawBg(dc);

        var labelL = Ui.View.findDrawableById("DeviceDetailDoseUnit");
        var labelD = Ui.View.findDrawableById("DeviceDetailDoseUnitD");

        labelL.setColor(theme.COLOR_NORMAL);
        labelD.setColor(theme.COLOR_NORMAL);

        labelL.setText(self._deviceDataController.getDoseHoursUnitString());
        labelD.setText(self._deviceDataController.getDoseUnitString());

        labelL.draw(dc);
        labelD.draw(dc);

        for(var i=0; i<3; i++) {
            detailsLabels[i][0].setColor(colors[i]);
            detailsLabels[i][1].setColor(colors[i]);
            detailsLabels[i][0].draw(dc);
            detailsLabels[i][1].draw(dc);

            doseValues[i].setColor(colors[i]);
            accDoseValues[i].setColor(colors[i]);

            if(self._deviceDataController.isThresholdUpdated(i)) {
                doseValues[i].setText(self._deviceDataController.getThreshold(i).format("%.2f"));
                accDoseValues[i].setText(self._deviceDataController.getThresholdAccumulated(i).format("%.2f"));
            } else {
                doseValues[i].setText("----.--");
                accDoseValues[i].setText("----.--");
            }
            doseValues[i].draw(dc);
            accDoseValues[i].draw(dc);
        }
    }

}
