using Toybox.WatchUi as Ui;
using Toybox.System;

class AlertSettingsMenuDelegate extends Ui.Menu2InputDelegate {

    private var _propertyProvider;
    private var _alerts;

    function initialize(propertyProvider) {
        Menu2InputDelegate.initialize();
        self._propertyProvider = propertyProvider;
        self._alerts = new AlertsProvider();
    }

    function onSelect(item) {
        switch(item.getId()) {
        case "ItemDoseL1Vibro":
            if(item has :isEnabled) {
                self._propertyProvider.setAlertVibroL(0, item.isEnabled());
                if(item.isEnabled()) {
                    self._alerts.alertVibroL1();
                }
            }
            break;
        case "ItemDoseL2Vibro":
            if(item has :isEnabled) {
                self._propertyProvider.setAlertVibroL(1, item.isEnabled());
                if(item.isEnabled()) {
                    self._alerts.alertVibroL2();
                }
            }
            break;
        case "ItemDoseL3Vibro":
            if(item has :isEnabled) {
                self._propertyProvider.setAlertVibroL(2, item.isEnabled());
                if(item.isEnabled()) {
                    self._alerts.alertVibroL3();
                }
            }
            break;
        case "ItemDone":
            Ui.popView(Ui.SLIDE_RIGHT);
            break;
        }
    }
}
