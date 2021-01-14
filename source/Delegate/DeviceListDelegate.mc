using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Application as App;

class DeviceListDelegate extends Ui.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
    }

    function onSelect() {
    }

    function onMenu() {
        return true;
    }

    function onNextMode() {
        return true;
    }

    function onNextPage() {
        return true;
    }

    function onPreviousMode() {
        return true;
    }

    function onPreviousPage() {
        return true;
    }
}

