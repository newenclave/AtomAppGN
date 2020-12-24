using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;

class ScanDataController {

    private var _app;
    private var _dataModel;

    function initialize(app) {
        self._app = app;
        self._dataModel = new ScanDataModel();
        self._app.getBleDelegate().setEventListener(self);
    }

    function getModel() {
        return self._dataModel;
    }

    function onScanResults(scanResults) {
        var added = 0;
        for( var result = scanResults.next(); result != null; result = scanResults.next() ) {
            if(self.contains(result.getServiceUuids(), self._app.getProfile().ATOM_FAST_SERVICE)) {
                self._dataModel.add(result);
                added++;
            }
        }
        if(added > 0) {
            Ui.requestUpdate();
        }
    }

    private function contains(iter, obj) {
        for(var uuid = iter.next(); uuid != null; uuid = iter.next()) {
            if(uuid.equals(obj)) {
                return true;
            }
        }
        return false;
    }

}
