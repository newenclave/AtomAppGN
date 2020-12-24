using Toybox.Application.Properties as Properties;

class PropertiesProvider {

    private const PROPERTY_USE_ROENTGEN = "use_roentgen";
    private const PROPERTY_USE_FAHRENHEIT = "use_fahrenheit";

    function initialize() {

    }

    function getDoseFactor() {
        if(self.getProperty(PROPERTY_USE_ROENTGEN, false)) {
            return 100;
        } else {
            return 1;
        }
    }

    function getTempUnitsString() {
        if(self.getProperty(PROPERTY_USE_FAHRENHEIT, false)) {
            return Application.loadResource(Rez.Strings.text_micro_fahrenheit);
        } else {
            return Application.loadResource(Rez.Strings.text_temp_celsius);
        }
    }

    function convertTemp(value) {
        if(self.getProperty(PROPERTY_USE_FAHRENHEIT, false)) {
            return (value * 1.8 + 32).toNumber();
        } else {
            return value;
        }
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

    function getDoseUnitString() {
        if(self.getProperty(PROPERTY_USE_ROENTGEN, false)) {
            return Application.loadResource(Rez.Strings.text_micro_roentgen);
        } else {
            return Application.loadResource(Rez.Strings.text_micro_sieverts);
        }
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