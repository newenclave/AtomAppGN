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

    function getCurrentId() {
        return self._current;
    }

    function getSize() {
        return (self._devices == null) ? 0 : self._devices.size();
    }

    function add(scanResult) {
        var found = false;
        for(var i=0; i < self._devices.size(); i++) {
            if(self._devices[i].get("device").isSameDevice(scanResult)) {
                found = true;
                self._devices[i].put("device", scanResult);
                break;
            }
        }
        if(!found) {
            self._devices.add({
                "device" => scanResult,
                "name" => "Atom",
                "state" => 0 });
        }
        self.store();
    }

    function removeCurrent() {
        if(!self.empty()) {
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
        if(!self.empty()) {
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

    function empty() {
        return self._devices.size() == 0;
    }

    private function getByIndex(index) {
        if((index >= 0) && (index < self._devices.size())) {
            return self._devices[index];
        }
        return null;
    }
}
