/*

class CharacteristicAddition extends CharacteristicBase {
    private var _uuid;

    private var _values;
    private var _errors;

    function initialize(queue, controller, uuid) {
        CharacteristicBase.initialize(queue, controller);
        self._uuid = uuid;

        self._values = [0.0, 0.0, 0.0];
        self._errors = [0.0, 0.0, 0.0];
    }

    function getErrorValue(id) {
        return self._errors[id];
    }

    function getValue(id) {
        return self._values[id];
    }

    function update() {
        self.read([], []);
    }

    function readImpl(param) {
        return self.readData(self._uuid);
    }

    function onReadImpl(param, bleParams) {
        var value = bleParams[2];
        if(value.size() >= 20) {

            self._values = [
                value.decodeNumber(Lang.NUMBER_FORMAT_UINT16,
                    { :offset => 0, :endianness => Lang.ENDIAN_LITTLE }),
                value.decodeNumber(Lang.NUMBER_FORMAT_UINT16,
                    { :offset => 2, :endianness => Lang.ENDIAN_LITTLE }),
                value.decodeNumber(Lang.NUMBER_FORMAT_UINT16,
                    { :offset => 4, :endianness => Lang.ENDIAN_LITTLE })
            ];

            for(var i = 0; i < 3; i++) {
                self._errors[i] = (self._values[i] > 0)
                                ? (Math.sqrt(10000.0 / self._values[i].toFloat()))
                                : 0.0;
            }
        }
        return true;
    }
}

*/
