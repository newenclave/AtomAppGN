using Toybox.Application.Properties as Properties;

class PropertiesProvider {

    private const PROPERTY_USE_ROENTGEN = "use_roentgen";
    private const PROPERTY_USE_FAHRENHEIT = "use_fahrenheit";
    private const WRITE_ACTIVITY = "write_activity";
    private const USE_ACTIVITY_LOCATION = "use_activity_location";
    private const ALERT_VIBRO_L = [
        "alert_vibro_L1",
        "alert_vibro_L2",
        "alert_vibro_L3"
    ];

    function initialize() {

    }

    function getAlertVibroL(id) {
        return self.getProperty(ALERT_VIBRO_L[id], false);
    }

    function setAlertVibroL(id, value) {
        self.setProperty(ALERT_VIBRO_L[id], value);
    }

    function getWriteActivity() {
        return self.getProperty(WRITE_ACTIVITY, false);
    }

    function setWriteActivity(value) {
        self.setProperty(WRITE_ACTIVITY, value);
    }

    function getUseActivityLocation() {
        return self.getProperty(USE_ACTIVITY_LOCATION, false);
    }

    function setUseActivityLocation(value) {
        self.setProperty(USE_ACTIVITY_LOCATION, value);
    }

    function getUseFahrenheit() {
        return self.getProperty(PROPERTY_USE_FAHRENHEIT, false);
    }

    function setUseFahrenheit(value) {
        self.setProperty(PROPERTY_USE_FAHRENHEIT, value);
    }

    function getUseRoentgen() {
        return self.getProperty(PROPERTY_USE_ROENTGEN, false);
    }

    function setUseRoentgen(value) {
        return self.setProperty(PROPERTY_USE_ROENTGEN, value);
    }

    function setProperty(name, value) {
        Properties.setValue(name, value);
    }

    function getProperty(name, defaultValue) {
        try {
            return Properties.getValue(name);
        } catch(ex) {
            System.println("Bad property " + name + " Err: " + ex.getErrorMessage());
        }
        return defaultValue;
    }
}