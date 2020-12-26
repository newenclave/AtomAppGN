using Toybox.ActivityRecording;
using Toybox.FitContributor as Fit;

class FitDataProvider {

    private var _session;
    private var _doseRate;
    private var _temperature;
    private var _sessionDoze;

    const FIELD_DOSE_POWER = 0;
    const FIELD_TEMPERATURE = 1;
    const FIELD_SESSION_DOSE = 2;

    function initialize() {
        self._session = ActivityRecording.createSession({
            :name=>Application.loadResource(Rez.Strings.fit_activity_name),
            :sport=>ActivityRecording.SPORT_GENERIC,
            :subSport=>ActivityRecording.SUB_SPORT_GENERIC
        });

        self._doseRate = self._session.createField("dose_rate",
            FIELD_DOSE_POWER,
            Fit.DATA_TYPE_FLOAT, {
                :units => "microsieverts"
            });

        self._temperature = self._session.createField("temperature",
            FIELD_TEMPERATURE,
            Fit.DATA_TYPE_SINT8, {
                :units => "celsius"
            });

        self._sessionDoze = self._session.createField("session_dose",
            FIELD_SESSION_DOSE,
            Fit.DATA_TYPE_FLOAT, {
                :units => "millisieverts",
                :mesgType => Fit.MESG_TYPE_SESSION,
            });

        self._session.start();
    }

    function stopAndSave() {
        System.println("activity.stopAndSave");
        self._session.stop();
        self._session.save();
    }

    function closeSession(dataDict) {
        self._sessionDoze.setData(dataDict.get(:sessionDose));
    }

    function update(dataDict) {
        self._doseRate.setData(dataDict.get(:doseRate));
        self._temperature.setData(dataDict.get(:temperature));
    }
}
