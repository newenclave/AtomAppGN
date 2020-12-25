using Toybox.ActivityRecording;
using Toybox.FitContributor as Fit;

class FitDataProvider {

    private var _session;
    private var _dosePower;
    private var _temperature;

    const FIELD_DOSE_POWER = 0;
    const FIELD_TEMPERATURE = 1;

    function initialize() {
        self._session = ActivityRecording.createSession({
            :name=>Application.loadResource(Rez.Strings.fit_activity_name),
            :sport=>ActivityRecording.SPORT_GENERIC,
            :subSport=>ActivityRecording.SUB_SPORT_GENERIC
        });
        self._dosePower = self._session.createField("dosepower",
            FIELD_DOSE_POWER,
            Fit.DATA_TYPE_FLOAT, {
                :units => "sieverts"
            });
        self._temperature = self._session.createField("temperature",
            FIELD_TEMPERATURE,
            Fit.DATA_TYPE_SINT8, {
                :units => "celsius"
            });
        self._session.start();
    }

    function stopAndSave() {
        System.println("activity.stopAndSave");
        self._session.stop();
        self._session.save();
    }

    function update(dataDict) {
        self._dosePower.setData(dataDict.get(:dosePower));
        self._temperature.setData(dataDict.get(:temperature));
    }
}
