using Toybox.Cryptography as Crypt;
using Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.System;

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

    function drawScrollBarArc(dc, options) {
        var max = options.get(:max);
        var current = options.get(:current);
        var from = options.get(:from);
        var to = options.get(:to);
        var bgColor = options.get(:bgColor);
        var fgColor = options.get(:fgColor);
        var color = options.get(:color);
        var width = options.get(:width);

        if(null == fgColor) {
            fgColor = color;
        }
        var radius = (dc.getWidth() / 2) - (width / 2) - 2;
        var center = [dc.getWidth() / 2, dc.getHeight() / 2];

        var partLenght = (to - from - 2).abs();
        var posLen = (partLenght.toFloat() / max.toFloat()).toNumber();
        if(posLen == 0) {
            posLen += 1;
        }

        dc.setColor(fgColor, bgColor);
        dc.setPenWidth(width);
        dc.drawArc(center[0], center[1],
            radius, Gfx.ARC_CLOCKWISE,
            convertDegreeValue(from), convertDegreeValue(to));

        dc.setColor(bgColor, bgColor);
        dc.setPenWidth(width - 2);
        dc.drawArc(center[0], center[1],
            radius, Gfx.ARC_CLOCKWISE,
            convertDegreeValue(from + 1), convertDegreeValue(to - 1));

        dc.setColor(color, bgColor);
        dc.setPenWidth(width - 4);
        dc.drawArc(center[0], center[1],
            radius, Gfx.ARC_CLOCKWISE,
            convertDegreeValue(from + 2 + (posLen * current)),
            (current == max - 1) ?
            convertDegreeValue(to - 2) :
            convertDegreeValue(from + 2 + (posLen * current + posLen)));
    }
}


