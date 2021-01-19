using Toybox.ActivityRecording;
using Toybox.FitContributor as Fit;
using Toybox.Application as App;

class FitDataProvider {

    private var _session;
    private var _doseRate;
    private var _temperature;
    private var _sessionDoze;

    private var _useRoentgen;
    private var _useFahrenheit;

    const FIELD_DOSE_POWER = 0;
    const FIELD_TEMPERATURE = 1;
    const FIELD_SESSION_DOSE = 2;

    const FIELD_DOSE_POWER_R = 3;
    const FIELD_TEMPERATURE_F = 4;
    const FIELD_SESSION_DOSE_R = 5;

    function initialize() {

        self._useFahrenheit = App.getApp().getPropertiesProvider().getUseFahrenheit();
        self._useRoentgen = App.getApp().getPropertiesProvider().getUseRoentgen();

        System.println("Use F " + self._useFahrenheit.toString());
        System.println("Use R " + self._useRoentgen.toString());

        self._session = ActivityRecording.createSession({
            :name=>Application.loadResource(Rez.Strings.fit_activity_name),
            :sport=>ActivityRecording.SPORT_GENERIC,
            :subSport=>ActivityRecording.SUB_SPORT_GENERIC
        });

        if(self._useRoentgen) {
            self._doseRate = self._session.createField("dose_rate",
                FIELD_DOSE_POWER_R,
                Fit.DATA_TYPE_FLOAT, {
                    :units => "microroentgen"
                });
            self._sessionDoze = self._session.createField("session_dose",
                FIELD_SESSION_DOSE_R,
                Fit.DATA_TYPE_FLOAT, {
                    :units => "milliroentgen",
                    :mesgType => Fit.MESG_TYPE_SESSION,
                });
        } else {
            self._doseRate = self._session.createField("dose_rate",
                FIELD_DOSE_POWER,
                Fit.DATA_TYPE_FLOAT, {
                    :units => "microsieverts"
                });
            self._sessionDoze = self._session.createField("session_dose",
                FIELD_SESSION_DOSE,
                Fit.DATA_TYPE_FLOAT, {
                    :units => "millisieverts",
                    :mesgType => Fit.MESG_TYPE_SESSION,
                });
        }

        if(self._useFahrenheit) {
            self._temperature = self._session.createField("temperature",
                FIELD_TEMPERATURE_F,
                Fit.DATA_TYPE_SINT8, {
                    :units => "fahrenheit"
                });
        } else {
            self._temperature = self._session.createField("temperature",
                FIELD_TEMPERATURE,
                Fit.DATA_TYPE_SINT8, {
                    :units => "celsius"
                });
        }

        self._session.start();
    }

    function stopAndSave() {
        System.println("activity.stopAndSave");
        self._session.stop();
        self._session.save();
    }

    function closeSession(dataDict) {
        if(self._useRoentgen) {
            self._sessionDoze.setData(dataDict.get(:sessionDose) * 100.0);
        } else {
            self._sessionDoze.setData(dataDict.get(:sessionDose));
        }
    }

    function update(dataDict) {
        if(self._useRoentgen) {
            self._doseRate.setData(dataDict.get(:doseRate) * 100.0);
        } else {
            self._doseRate.setData(dataDict.get(:doseRate));
        }
        if(self._useFahrenheit) {
            self._temperature.setData(Tools.celsiusToFahrenheit(dataDict.get(:temperature)));
        } else {
            self._temperature.setData(dataDict.get(:temperature));
        }
    }
}
