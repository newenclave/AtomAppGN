

class DeviceDataModel {

    (:property) var flags = 0;
    (:property) var doseAccumulated = 0;
    (:property) var dosePower = 0;
    (:property) var impulses = 0;
    (:property) var charge = 0;
    (:property) var temperature = 0;

    function initialize() {
    }

    public function update(value) {
        if(value.size() >= 13) {
            self.flags = value[0];
            self.doseAccumulated = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                                { :offset => 1, :endianness => Lang.ENDIAN_LITTLE });
            self.dosePower = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                                { :offset => 5, :endianness => Lang.ENDIAN_LITTLE });
            self.impulses = value.decodeNumber(Lang.NUMBER_FORMAT_UINT16,
                                { :offset => 9, :endianness => Lang.ENDIAN_LITTLE });
            self.charge = value[11];
            self.temperature = value[12];
        }
    }

    public function isCharging() {
        return self.getFlag(6);
    }

    private function getFlag(pos) {
        return (self.flags & (1 << pos)) != 0;
    }
}