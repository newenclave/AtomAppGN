using Toybox.WatchUi as Ui;

class DeviceDetailsView extends Ui.View {

    private var _deviceData;
    private var _properties;

    function initialize(deviceData, props) {
        View.initialize();
        self._deviceData = deviceData;
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

        var ths = self._deviceData.thresholds;
        var doseFactor = self._properties.getDoseFactor();
        var doseUnits = self._properties.getDoseUnitString();
        Ui.View.findDrawableById("DeviceDetailDoseUnit").setText(doseUnits);

        for(var i = 0; i < ths.size(); i++) {
            if(ths[i].updated) {
                doseValues[i].setText((ths[i].threshold * doseFactor).format("%.2f"));
                accDoseValues[i].setText((ths[i].thresholdAccumulated * doseFactor).format("%.2f"));
            }
        }
        View.onUpdate(dc);
    }

    function onHide() {
    }

}
