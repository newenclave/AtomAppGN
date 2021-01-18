using Toybox.Cryptography as Crypt;
using Toybox.Lang;

module Tools {
    function convertDegreeValue(value) {
        return ((360 - (value.toNumber() % 360)) + 90) % 360;
    }

    function celsiusToFahrenheit(value) {
        return value * 1.8 + 32;
    }

    function getRandomUint32(min, max) {
        var arr = Crypt.randomBytes(4);
        var diff = (max + 1) - min;
        return arr.decodeNumber(Lang.NUMBER_FORMAT_UINT32, {}) % diff + min;
    }

    function getRandomUint8(min, max) {
        var arr = Crypt.randomBytes(1);
        var diff = (max + 1) - min;
        return arr[0] % diff + min;
    }

    // min ans max stay for minimal and maximum R, G and B
    function getRandomColor(min, max) {

        var mul = [getRandomUint8(0, 1), getRandomUint8(0, 1), getRandomUint8(0, 1)];
        if(mul[0] + mul[1] + mul[2] == 3) {
            mul[getRandomUint8(0, 2)] = 0;
        } else if (mul[0] + mul[1] + mul[2] == 0) {
            mul[getRandomUint8(0, 2)] = 1;
        }

        var R = getRandomUint8(min, max) * mul[0];
        var G = getRandomUint8(min, max) * mul[1];
        var B = getRandomUint8(min, max) * mul[2];

        return (R << 16) | (G << 8) | B;
    }
}

