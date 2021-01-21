using Toybox.Application as App;

class DeviceStorage {

    private var _devices;
    private var _current;

    function initialize() {
        self.load();
        self._current = 0;
    }

    function getCurrent() {
        return self.getByIndex(self._current);
    }

    function getNext() {
        return self.getByIndex(self._current + 1);
    }

    function getPrev() {
        return self.getByIndex(self._current - 1);
    }

    function next() {
        if(self._devices.size() > 0) {
            self._current ++;
            self._current %= self._devices.size();
        }
    }

    function prev() {
        if(self._devices.size() > 0) {
            self._current--;
            if(self._current < 0) {
                self._current = self._devices.size() - 1;
            }
        }
    }

    function exists(scanResult) {
        for(var i=0; i<self._devices.size(); i++) {
            if(self._devices[i].get("device").isSameDevice(scanResult)) {
                return true;
            }
        }
        return false;
    }

    function getCurrentId() {
        return self._current;
    }

    function getSize() {
        return (self._devices == null) ? 0 : self._devices.size();
    }

    function add(deviceWrapper) {
        self.getDeviceDictionaryByScanResult(deviceWrapper);
        self.store();
    }

    function addUpdate(deviceWrapper) {
        var dev = self.getDeviceDictionaryByScanResult(deviceWrapper);
        dev.updateUsage();
        self.store();
    }

    private function getDeviceDictionaryByScanResult(deviceWrapper) {
        for(var i=0; i < self._devices.size(); i++) {
            var devNext = new DeviceWrapper(self._devices[i]);
            if(devNext.isSameDevice(deviceWrapper.getScanResult())) {
                devNext.setScanResult(deviceWrapper.getScanResult());
                return devNext;
            }
        }
        self._devices.add(deviceWrapper.get());
        return deviceWrapper;
    }

    function removeCurrent() {
        if(!self.isEmpty()) {
            switch(self._current) {
            case 0:
                self._devices = self._devices.slice(1, null);
                break;
            case self._devices.size() - 1:
                self._devices = self._devices.slice(0, -1);
                self._current = self._devices.size() - 1;
                break;
            default:
                var left = self._devices.slice(0, self._current - 1);
                var right = self._devices.slice(self._current, null);
                self._devices = left.addAll(right);
            }
        }
        self.store();
    }

    function store() {
        if(!self.isEmpty()) {
            App.getApp().storeDeviceList(self._devices);
        } else {
            App.getApp().storeDeviceList([]);
        }
    }

    function load() {
        self._devices = App.getApp().loadDeviceList();
        if(null == self._devices) {
            self._devices = [];
        }
    }

    function isEmpty() {
        return self._devices.size() == 0;
    }

    private function getByIndex(index) {
        if((index >= 0) && (index < self._devices.size())) {
            return new DeviceWrapper(self._devices[index]);
        }
        return null;
    }
}

