using Toybox.Application.Properties as Properties;

class PropertiesProvider {

    private const PROPERTY_USE_ROENTGEN = "use_roentgen";

    function initialize() {

    }

    function getDoseFactor() {
        if(self.getProperty(PROPERTY_USE_ROENTGEN, false)) {
            return 100;
        } else {
            return 1;
        }
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