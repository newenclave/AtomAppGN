
class CharacteristicCalibration extends CharacteristicIface {

    private var _uuid;
    private var _deviceSens;
    private var _backgroundCount;
    private var _deadTime;
    private var _measureTime;

    function initialize(queue, controller, uuid) {
        CharacteristicIface.initialize(queue, controller);
        self._uuid = uuid;
        self._deviceSens = 0.0;
        self._backgroundCount = 0.0;
        self._deadTime = 0.0;
        self._measureTime = 0;
    }

    function getDevSens() {
        return self._deviceSens;
    }

    function getBgCount() {
        return self._backgroundCount;
    }

    function getDeadTime() {
        return self._deadTime;
    }

    function getMeasureTime() {
        return self._measureTime;
    }

    function update() {
        self.read([], []);
    }

    function readImpl(param) {
        return self.readData(self._uuid);
    }

    function onReadImpl(param, bleParams) {
        var value = bleParams[2];
        if(value.size() >= 18) {
            self._deviceSens = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                                { :offset => 0, :endianness => Lang.ENDIAN_LITTLE });
            self._backgroundCount = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                                { :offset => 4, :endianness => Lang.ENDIAN_LITTLE });
            self._deadTime = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                                { :offset => 8, :endianness => Lang.ENDIAN_LITTLE });
            self._measureTime = value.decodeNumber(Lang.NUMBER_FORMAT_UINT16,
                                { :offset => 12, :endianness => Lang.ENDIAN_LITTLE });
            System.println(value.toString());
        }
        return true;
    }
}
