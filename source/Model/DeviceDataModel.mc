

class DeviceDataModel {

    (:property) var flags = 0;
    (:property) var doseAccumulated = 0;
    (:property) var sessionDoseInit = 0;
    (:property) var doseRate = 0;
    (:property) var impulses = 0;
    (:property) var charge = 0;
    (:property) var temperature = 0;

    private var _startTime;
    private var _sessionTime;
    private var _impulsesTotal;

    function initialize() {
        self._startTime = System.getTimer();
        self._sessionTime = System.getTimer();
        self._impulsesTotal = 0;
    }

    public function update(value) {
        if(value.size() >= 13) {
            self.flags = value[0];
            self.doseAccumulated = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                                { :offset => 1, :endianness => Lang.ENDIAN_LITTLE });
            self.doseRate = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                                { :offset => 5, :endianness => Lang.ENDIAN_LITTLE });
            self.impulses = value.decodeNumber(Lang.NUMBER_FORMAT_UINT16,
                                { :offset => 9, :endianness => Lang.ENDIAN_LITTLE });
            //self.doseRate;
            self.charge = value[11];
            self.temperature = value[12];
            self._impulsesTotal += self.impulses;
            if(self.sessionDoseInit == 0) {
                self.sessionDoseInit = self.doseAccumulated;
            }
        }
    }

    public function getMeasuringTime() {
        return System.getTimer() - self._sessionTime;
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

    public function getSessionDoze() {
        return self.doseAccumulated - self.sessionDoseInit;
    }

    public function getCPM() {
        return self.getImpusesAvarage(60 * 1000);
    }

    public function getImpulsesTotal() {
        return self._impulsesTotal;
    }

    private function getImpusesAvarage(millisec) {
        var period = (System.getTimer() - self._startTime).toFloat() / millisec.toFloat();
        if(period > 0) {
            return (self._impulsesTotal / period).toNumber();
        } else {
            return self._impulsesTotal;
        }
    }

    private function getFlag(pos) {
        return (self.flags & (1 << pos)) != 0;
    }
}