using Toybox.Application.Properties as Properties;

class PropertiesProvider {

    private const PROPERTY_USE_ROENTGEN = "use_roentgen";
    private const PROPERTY_USE_FAHRENHEIT = "use_fahrenheit";
    private const WRITE_ACTIVITY = "write_activity";
    private const USE_ACTIVITY_LOCATION = "use_activity_location";

    function initialize() {

    }

    // TODO: Remove it here
    //    DataController must do it.
    function getDoseFactor() {
        if(self.getProperty(PROPERTY_USE_ROENTGEN, false)) {
            return 100;
        } else {
            return 1;
        }
    }

    // TODO: Remove it here
    //    DataController must do it.
    function getTempUnitsString() {
        if(self.getProperty(PROPERTY_USE_FAHRENHEIT, false)) {
            return Application.loadResource(Rez.Strings.text_micro_fahrenheit);
        } else {
            return Application.loadResource(Rez.Strings.text_temp_celsius);
        }
    }

    // TODO: Remove it here
    //    DataController must do it.
    function convertTemp(value) {
        if(self.getProperty(PROPERTY_USE_FAHRENHEIT, false)) {
            return (value * 1.8 + 32).toNumber();
        } else {
            return value;
        }
    }

    // TODO: Remove it here
    //    DataController must do it.
    function getDoseUnitString() {
        if(self.getProperty(PROPERTY_USE_ROENTGEN, false)) {
            return Application.loadResource(Rez.Strings.text_micro_roentgen);
        } else {
            return Application.loadResource(Rez.Strings.text_micro_sieverts);
        }
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
//            var val = Properties.getValue(name);
//            System.println(name + " = " + val.toString());
            return Properties.getValue(name);
        } catch(ex) {
            System.println("Bad property " + name + " Err: " + ex.getErrorMessage());
        }
        return defaultValue;
    }
}