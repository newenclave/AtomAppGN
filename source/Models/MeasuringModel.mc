
class MeasuringModel {

    (:property) var enabled;
    (:property) var dosePower;
    (:property) var initDoseAcc;
    (:property) var sessionImpulses;
    (:property) var pulsesMeasure;
    (:property) var errorMeasure;
    (:property) var valCPM;
    (:property) var valCPS;

    private var _hidden;
    private var _initTime;
    private var _lastCurrent;

    function initialize(devController) {
        self.reset(devController, false);
        self._hidden = false;
    }

    function onHide() {
        self._hidden = true;
    }

    function onShow() {
        self._hidden = false;
    }

    function getAccumulatedDose(devController) {
        return devController.getDataModel().doseAccumulated * 1000;
    }

    function reset(devController, enable) {
        self._initTime = System.getTimer();
        self.enabled = enable;
        self.dosePower = 0.0;
        self.sessionImpulses = 0;
        self.errorMeasure = 0.0;
        self.pulsesMeasure = 0;
        self.valCPM = 0;
        self.valCPS = 0;
        self.initDoseAcc = self.getAccumulatedDose(devController);
        self._lastCurrent = self.initDoseAcc;
    }

    function getElapsedTime() {
        return System.getTimer() - self._initTime;
    }

    function getCPM() {
        return self.valCPM;
    }

    function getCPS() {
        return self.valCPS;
    }

    private function getImpusesAvarage(millisec) {
        var period = self.getElapsedTime().toFloat() / millisec.toFloat();
        if(period > 0) {
            return (self.sessionImpulses / period).toNumber();
        } else {
            return self.sessionImpulses;
        }
    }

    function update(devController) {
        if(self.enabled) {
            if(self.initDoseAcc == 0) {
                self.initDoseAcc = self.getAccumulatedDose(devController);
                self._lastCurrent = self.initDoseAcc;
            }
            self.sessionImpulses += devController.getDataModel().impulses;
            self.valCPS = self.getImpusesAvarage(1000);
            self.valCPM = self.getImpusesAvarage(60000);
            if(!self._hidden) {
                var elapsedTime = System.getTimer() - self._initTime;
                var conf = 100.0;
                if (elapsedTime > 1000) {
                    var curDose = self.getAccumulatedDose(devController);
                    if(curDose < self._lastCurrent) {
                        curDose = self._lastCurrent;
                    } else {
                        self._lastCurrent = curDose;
                    }
                    var deltaDose = ((curDose - self.initDoseAcc)).toFloat();
                    self.dosePower = (deltaDose / (elapsedTime / 3600000.0));
                    if(self.dosePower > 1000000) {
                        return;
                    }
                    var N = (deltaDose * 100.0 * devController.getDeviceSens());
                    if(N > 0) {
                        conf = 100.0 / Math.sqrt(N.toFloat());
                        self.pulsesMeasure = N;
                    }
                    self.errorMeasure = conf;
                }
            }
        }
    }
}