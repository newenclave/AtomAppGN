using Toybox.BluetoothLowEnergy as Ble;

class CharacteristicThresholds extends CharacteristicBase {

    private var _values;
    private var _writeSpeedRequest;
    private var _uuids;

    function initialize(queue, controller, uuids) {
        CharacteristicBase.initialize(queue, controller);
        self._values = [
            new ThresholdModel(0),
            new ThresholdModel(1),
            new ThresholdModel(2)
        ];
        self._uuids = uuids;
    }

    function update() {
        self.read([0], [0]);
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
        if(id < 2) {
            self.pushRead([id+1], [id+1]);
        }
        return true;
    }
}
