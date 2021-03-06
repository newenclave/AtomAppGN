using Toybox.BluetoothLowEnergy as Ble;

class DeviceWrapper {
    private var _deviceDictionary;

    function initialize(deviceDictionary) {
        if(deviceDictionary instanceof Ble.ScanResult) {
            self._deviceDictionary = {};
            self.setScanResult(deviceDictionary);
            self.setColor(Tools.getRandomColor(0x80, 0xA0));
            self.setName("Atom device");
        } else if(deviceDictionary instanceof Lang.Dictionary) {
            self._deviceDictionary = deviceDictionary;
        } else {
            System.print("Invalid data for device. ");
            System.println(deviceDictionary);
        }
    }

    function getScanResult() {
        return self._deviceDictionary.get("device");
    }

    function setScanResult(scanResult) {
        return self._deviceDictionary.put("device", scanResult);
    }

    function getColor() {
        return self.getValue("color", 0x55AA55);
    }

    function setColor(color) {
        return self._deviceDictionary.put("color", color);
    }

    function getName() {
        return self.getValue("name", "Atom device");
    }

    function setName(color) {
        return self._deviceDictionary.put("name", color);
    }

    function isSameDevice(other) {
        return self.getScanResult().isSameDevice(other);
    }

    function getLastUse() {
        if(self._deviceDictionary.hasKey("last_use")) {
            return self._deviceDictionary.get("last_use");
        }
        return 0;
    }

    private function getValue(name, def) {
        var val = self._deviceDictionary.get(name);
        return (null == val) ? def : val;
    }

    function updateUsage() {
        self._deviceDictionary.put("last_use", Time.now().value());
    }

    function get() {
        return self._deviceDictionary;
    }

}
