using Toybox.Attention;

class AlertsProvider {

    function alertVibroL(id) {
        self._alertVibroL(id + 1);
    }

    function alertVibroL1() {
        self._alertVibroL(1);
    }

    function alertVibroL2() {
        self._alertVibroL(2);
    }

    function alertVibroL3() {
        self._alertVibroL(3);
    }

    private function _alertVibroL(id) {
        if(Attention has :vibrate) {
            var alertCon = 300 * id;
            var vibeData = [
                new Attention.VibeProfile(50, alertCon),
                new Attention.VibeProfile(0, 300),
                new Attention.VibeProfile(50, alertCon),
                new Attention.VibeProfile(0, 300),
                new Attention.VibeProfile(50, alertCon),
            ];
            Attention.vibrate(vibeData);
        }
    }
}