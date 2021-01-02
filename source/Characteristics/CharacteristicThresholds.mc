using Toybox.BluetoothLowEnergy as Ble;

class CharacteristicThresholds extends CharacteristicIface {

    private var _values;
    private var _writeSpeedRequest;
    private var _uuids;

    function initialize(queue, controller, uuids) {
        CharacteristicIface.initialize(queue, controller);
        self._values = [
            new ThresholdModel(0),
            new ThresholdModel(1),
            new ThresholdModel(2)
        ];
        self._uuids = uuids;
    }

    function update() {
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

    function readImpl(param) {
        var id = param[0];
        return self.readData(self._uuids[id]);
    }

    function onReadImpl(param, bleParams) {
        var id = param[0];
        self._values[id].update(bleParams[2]);
        return true;
    }
}
