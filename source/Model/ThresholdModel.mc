

 class ThresholdModel {

    (:property) var priorty = 0;
    (:property) var threshold = 9999999.0;
    (:property) var thresholdAccumulated = 9999999.0;
    (:property) var detectTime = 34;
    (:property) var flags = 0;
    (:property) var updated = false;

    function initialize(priorityValue) {
        self.priorty = priorityValue;
    }

    public function update(value, factor) {
        if(value.size() >= 10) {
            self.thresholdAccumulated = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                { :offset => 0, :endianness => Lang.ENDIAN_LITTLE })
                * factor;
            self.threshold = value.decodeNumber(Lang.NUMBER_FORMAT_FLOAT,
                { :offset => 4, :endianness => Lang.ENDIAN_LITTLE })
                * factor;
            self.detectTime = value[8];
            self.flags = value[9];
            self.updated = true;
            System.println("Th " + self.priorty + " = " + self.threshold.toString());
        }
    }
}
