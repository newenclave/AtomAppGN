using Toybox.BluetoothLowEnergy as Ble;

class AtomFastProfile {

    public static const ATOM_FAST_SERVICE          = Ble.stringToUuid("63462A4A-C28C-4FFD-87A4-2D23A1C72581");
    public static const ATOM_FAST_CHAR             = Ble.stringToUuid("70BC767E-7A1A-4304-81ED-14B9AF54F7BD");
    public static const ATOM_FAST_THRESHOSD1       = Ble.stringToUuid("3F71E820-1D98-46D4-8ED6-324C8428868C");
    public static const ATOM_FAST_THRESHOSD2       = Ble.stringToUuid("2E95D467-4DB7-4D7F-9D82-4CD5C102FA05");
    public static const ATOM_FAST_THRESHOSD3       = Ble.stringToUuid("F8DE242F-8D84-4C12-9A2F-9C64A31CA7CA");

    public static const ATOM_FAST_CHAR2            = Ble.stringToUuid("8E26EDC8-A1E9-4C06-9BD0-97B97E7B3FB9");
    public static const ATOM_FAST_CONFIG_CHAR      = Ble.stringToUuid("EA50CFCD-AC4A-4A48-BF0E-879E548AE157");
    public static const ATOM_FAST_CALIBRATION_CHAR = Ble.stringToUuid("57F7031F-03C1-4016-8749-BAABAA58612D");

    private static const _profileDef = {
        :uuid => ATOM_FAST_SERVICE,
        :characteristics => [{
                :uuid => ATOM_FAST_CHAR,
                :descriptors => [ Ble.cccdUuid() ]
            }, {
                :uuid => ATOM_FAST_THRESHOSD1,
                :descriptors => [ Ble.cccdUuid() ]
            }, {
                :uuid => ATOM_FAST_THRESHOSD2,
                :descriptors => [ Ble.cccdUuid() ]
            }, {
                :uuid => ATOM_FAST_THRESHOSD3,
                :descriptors => [ Ble.cccdUuid() ]
            }, {
                :uuid => ATOM_FAST_CALIBRATION_CHAR,
                :descriptors => [ Ble.cccdUuid() ]
            }, {
                :uuid => ATOM_FAST_CONFIG_CHAR,
                :descriptors => [ Ble.cccdUuid() ]
//            }, {
//                :uuid => ATOM_FAST_CHAR2,
//                :descriptors => [ Ble.cccdUuid() ]
            }
        ]
    };

    public static function register() {
        Ble.registerProfile(AtomFastProfile._profileDef);
    }

//    private const UuidNameLookup = {
//        ATOM_FAST_SERVICE => "Atom Fast Service"
//    };


//    public function getDescription(uuid) {
//        if(UuidNameLookup.hasKey(uuid)) {
//            return UuidNameLookup[uuid];
//        }
//        return null;
//    }
}
