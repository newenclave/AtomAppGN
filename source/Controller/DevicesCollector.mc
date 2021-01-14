using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DevicesCollector {

    private var _devices;
//    private var _operations;

    function initialize() {
        self._devices = [];
//        self._operations = new OperationsQueue();
    }

    function pairNew(scanResult) {
        try {
            var device = Ble.pairDevice(scanResult);
            if(null != device) {
                var controller = new DeviceDataController({
                    :device => device,
                    //:operations => self._operations,
                    :unregisterCallback => method(:stopUpregister),
                    :scanResult => scanResult
                });
                self._devices.add({:device => device, :controller => controller});
                System.println("Added new device. Total: " + self._devices.size().toString());
                return controller;
            }
        } catch(e) {
            System.println("Pair device error: " + e.getErrorMessage());
        }
        return null;
    }

    function stopUpregister(device) {
        Ble.unpairDevice(device);
        self._devices.remove(self.getDeviceDictionary(device));
        System.println("A device removed. Total: " + self._devices.size().toString());
    }

    /// ===================== Callbacks ======================
    function onConnectedStateChanged(device, state) {
        System.println("On Connect " + state.toString());
        var controller = self.getControllerByDevice(device);
        if(null != controller) {
            controller.onConnectedStateChanged(device, state);
        }
    }

    /// Descriptop Write request
    function onDescriptorWrite(descriptor, status) {
        System.println("onDescriptorWrite ");
        var controller = self.getControllerByDevice(descriptor.getCharacteristic().getService().getDevice());
        if(null != controller) {
            controller.onDescriptorWrite(descriptor, status);
        }
    }

    // Write request
    function onCharacteristicWrite(characteristic, status) {
        System.println("onCharacteristicWrite ");
        var controller = self.getControllerByDevice(characteristic.getService().getDevice());
        if(null != controller) {
            controller.onCharacteristicWrite(characteristic, status);
        }
    }

    // read request
    function onCharacteristicRead(characteristic, status, value) {
        var controller = self.getControllerByDevice(characteristic.getService().getDevice());
        if(null != controller) {
            controller.onCharacteristicRead(characteristic, status, value);
        }
    }

    function onCharacteristicChanged(characteristic, value) {
        var controller = self.getControllerByDevice(characteristic.getService().getDevice());
        if(null != controller) {
            controller.onCharacteristicChanged(characteristic, value);
        }
    }
    /// ===================== End Callbacks ======================

    private function getDeviceDictionary(device) {
        for(var i=0; i<self._devices.size(); i++) {
            if(self._devices[i].get(:device) == device) {
                return self._devices[i];
            }
        }
        return null;
    }

    private function getControllerByDevice(device) {
        var dict = self.getDeviceDictionary(device);
        if(null != dict) {
            return dict.get(:controller);
        }
        return null;
    }
}
