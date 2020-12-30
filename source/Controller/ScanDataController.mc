using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ScanDataController {

    private var _dataModel;
    private var _updateListener;

    function initialize() {
        self._dataModel = new ScanDataModel();
        App.getApp().getBleDelegate().setEventListener(self);
    }

    function getModel() {
        return self._dataModel;
    }

    function setUpdateListener(iface) {
        _updateListener = iface.weak();
    }

    function callUpdate() {
        if(null != self._updateListener
            && self._updateListener.stillAlive()
            && self._updateListener.get() has :onNewDataUpdate) {
            self._updateListener.get().onNewDataUpdate();
        }
    }

    function onScanResults(scanResults) {
        var added = 0;
        for( var result = scanResults.next(); result != null; result = scanResults.next() ) {
            if(self.contains(result.getServiceUuids(), App.getApp().getProfile().ATOM_FAST_SERVICE)) {
                self._dataModel.add(result);
                added++;
            }
        }
        if(added > 0) {
            self.callUpdate();
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
