using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class DevicesCollector {

    private var _devices;
    private var _operations;

    function initialize() {
        self._devices = [];
        self._operations = new OperationsQueue();
    }

    function pairNew(scanResult) {
        try {
            var device = Ble.pairDevice(scanResult);
            if(null != device) {
                var controller = new DeviceDataController({
                    :device => device,
                    :operations => self._operations,
                    :unregisterCallback => method(:stopUpregister)
                });
                self._devices.add({:device => device, :controller => controller});
                return controller;
            }
        } catch(e) {
            System.println("Pair device error: " + e.getErrorMessage());
        }
        return null;
    }

    function stopUpregister(device) {
        Ble.unpairDevice(device);
        self._devices.remove(device);
    }

    /// On Connect
    function onConnectedStateChanged(device, state) {
        System.println("On Connect " + state.toString());
        var controller = self.getConnectionByDevice(device);
        if(null != controller) {
            controller.onConnectedStateChanged(device, state);
        }
    }

    /// Descriptop Write request
    function onDescriptorWrite(descriptor, status) {
        System.println("onDescriptorWrite ");
        var controller = self.getConnectionByDevice(descriptor.getCharacteristic().getService().getDevice());
        if(null != controller) {
            controller.onDescriptorWrite(descriptor, status);
        }
    }

    // Write request
    function onCharacteristicWrite(characteristic, status) {
        System.println("onCharacteristicWrite ");
        var controller = self.getConnectionByDevice(characteristic.getService().getDevice());
        if(null != controller) {
            controller.onCharacteristicWrite(characteristic, status);
        }
    }

    // read request
    function onCharacteristicRead(characteristic, status, value) {
        var controller = self.getConnectionByDevice(characteristic.getService().getDevice());
        if(null != controller) {
            controller.onCharacteristicRead(characteristic, status, value);
        }
    }

    function onCharacteristicChanged(characteristic, value) {
        var controller = self.getConnectionByDevice(characteristic.getService().getDevice());
        if(null != controller) {
            controller.onCharacteristicChanged(characteristic, value);
        }
    }

    private function getConnectionByDevice(device) {
        for(var i=0; i<self._devices.size(); i++) {
            if(self._devices[i].get(:device) == device) {
                return self._devices[i].get(:controller);
            }
        }
        return null;
    }
}
