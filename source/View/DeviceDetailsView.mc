using Toybox.WatchUi as Ui;

class DeviceDetailsView extends Ui.View {

    private var _deviceDataController;
    private var _properties;

    function initialize(deviceDataController, props) {
        View.initialize();
        self._deviceDataController = deviceDataController;
        self._properties = props;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.DeviceDetailsLayout(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {
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

        Ui.View.findDrawableById("DeviceDetailDoseUnit").setText(self._deviceDataController.getDoseUnitString());
        for(var i=0; i<3; i++) {
            if(self._deviceDataController.isThresholdUpdated(i)) {
                doseValues[i].setText(self._deviceDataController.getThreshold(i).format("%.2f"));
                accDoseValues[i].setText(self._deviceDataController.getThresholdAccumulated(i).format("%.2f"));
            }
        }
        View.onUpdate(dc);
    }

    function onHide() {
    }

}
