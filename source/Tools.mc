module Tools {
    function convertDegreeValue(value) {
        return ((360 - (value.toNumber() % 360)) + 90) % 360;
    }

    function celsiusToFahrenheit(value) {
        return value * 1.8 + 32;
    }
}

