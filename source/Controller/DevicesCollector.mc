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
        var dict = self.getByScanResult(scanResult);
        if(null != dict) {
            return dict.get(:controller);
        }
        try {
            var device = Ble.pairDevice(scanResult);
            if(null != device) {
                var controller = new DeviceDataController({
                    :device => device,
                    //:operations => self._operations,
                    :unregisterCallback => method(:stopUpregister),
                    :scanResult => scanResult
                });
                self._devices.add({
                    :device => device,
                    :controller => controller,
                    :scanResult => scanResult
                });
                System.println("Added new device. " + device.toString());
                System.println("Total: " + self._devices.size().toString());
                return controller;
            } else {
                System.println("pairDevice returned null");
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
        System.println("On Connect " + device.toString() + " " + state.toString());
        var controller = self.getControllerByDevice(device);
        if(null != controller) {
            controller.onConnectedStateChanged(device, state);
        }
    }

    /// Descriptop Write request
    function onDescriptorWrite(descriptor, status) {
        var dev = descriptor.getCharacteristic().getService().getDevice();
        System.println("onDescriptorWrite " + dev.toString());
        var controller = self.getControllerByDevice(dev);
        if(null != controller) {
            controller.onDescriptorWrite(descriptor, status);
        }
    }

    // Write request
    function onCharacteristicWrite(characteristic, status) {
        var dev = characteristic.getService().getDevice();
        System.println("onCharacteristicWrite " + dev.toString());
        var controller = self.getControllerByDevice(dev);
        if(null != controller) {
            controller.onCharacteristicWrite(characteristic, status);
        }
    }

    // read request
    function onCharacteristicRead(characteristic, status, value) {
        var dev = characteristic.getService().getDevice();
        System.println("onCharacteristicRead " + dev.toString());
        var controller = self.getControllerByDevice(dev);
        if(null != controller) {
            controller.onCharacteristicRead(characteristic, status, value);
        }
    }

    function onCharacteristicChanged(characteristic, value) {
        var dev = characteristic.getService().getDevice();
        //System.println("onCharacteristicChanged " + dev.toString());
        var controller = self.getControllerByDevice(dev);
        if(null != controller) {
            controller.onCharacteristicChanged(characteristic, value);
        }
    }
    /// ===================== End Callbacks ======================

    private function getByScanResult(scanResult) {
        for(var i=0; i<self._devices.size(); i++) {
            if(self._devices[i].get(:scanResult) == scanResult) {
                return self._devices[i];
            }
        }
        return null;
    }

    function getControllerByScanResult(scanResult) {
        var dict = self.getByScanResult(scanResult);
        return (dict == null) ? null : dict.get(:controller);
    }

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
