

class DeviceDataModel {

    (:property) var flags = 0;
    (:property) var doseAccumulated = 0;
    (:property) var dosePower = 0;
    (:property) var impulses = 0;
    (:property) var charge = 0;
    (:property) var temperature = 0;
    (:property) var thresholds = [];

    private var _startTime;
    private var _impulsesTotal;

    function initialize() {
        self._startTime = System.getTimer();
        self._impulsesTotal = 0;
        self.thresholds = [
            new ThresholdModel(0),
            new ThresholdModel(1),
            new ThresholdModel(2),
        ];
    }

    public function updateThreashold(index, value) {
        if(index >= 0 && index < 3) {
            self.thresholds[index].update(value);
        } else {
            System.println("Got invalid index value "
                + index.toString()
                + " while updating thresholds");
        }
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
            self._impulsesTotal += self.impulses;
        }
    }

    public function getMeasuringTime() {
        return System.getTimer() - self._startTime;
    }

    public function resetTimer() {
        self._startTime = System.getTimer();
    }

    public function isCharging() {
        return self.getFlag(6);
    }

    public function getCPS() {
        return self.getImpusesAvarage(1000);
    }

    public function getCPM() {
        return self.getImpusesAvarage(60 * 1000);
    }

    private function getImpusesAvarage(millisec) {
        var period = (System.getTimer() - self._startTime) / millisec;
        if(period > 0) {
            return (self._impulsesTotal / period);
        } else {
            return self._impulsesTotal;
        }
    }

    private function getFlag(pos) {
        return (self.flags & (1 << pos)) != 0;
    }
}