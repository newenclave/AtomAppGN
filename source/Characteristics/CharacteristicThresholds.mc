using Toybox.BluetoothLowEnergy as Ble;

class CharacteristicThresholds extends CharacteristicIface {

    private var _controller;
    private var _values;
    private var _writeSpeedRequest;
    private var _uuids;

    function initialize(queue, controller, uuids) {
        CharacteristicIface.initialize(queue);
        self._controller = controller.weak();
        self._values = [
            new ThresholdModel(0),
            new ThresholdModel(1),
            new ThresholdModel(2)
        ];
        self._uuids = uuids;
    }

    function updateAll() {
        self.read([0], [0]);
        self.pushRead([1], [1]);
        self.pushRead([2], [2]);
    }

    function getValue(id) {
        return self._values[id];
    }

    function getValues() {
        return self._values;
    }

    private function getServie() {
        if(self._controller.stillAlive()) {
            return self._controller.get().getBleService();
        } else {
            return null;
        }
    }

    function readImpl(param) {
        var id = param[0];
        var service = getServie();
        if(null != service) {
            var uuid = self._uuids[id];
            var char = service.getCharacteristic(uuid);
            if(char) {
                char.requestRead();
                return true;
            }
        }
        return false;
    }

    function onReadImpl(param, bleParams) {
        var id = param[0];
        self._values[id].update(bleParams[2]);
        return true;
    }
}
