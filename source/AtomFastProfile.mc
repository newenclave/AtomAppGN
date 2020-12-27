using Toybox.BluetoothLowEnergy as Ble;

class AtomFastProfile {

    public const ATOM_FAST_SERVICE      = Ble.stringToUuid("63462a4a-c28c-4ffd-87a4-2d23a1c72581");
    public const ATOM_FAST_CHAR         = Ble.stringToUuid("70BC767E-7A1A-4304-81ED-14B9AF54F7BD");
    public const ATOM_FAST_THRESHOSD1   = Ble.stringToUuid("3F71E820-1D98-46D4-8ED6-324C8428868C");
    public const ATOM_FAST_THRESHOSD2   = Ble.stringToUuid("2E95D467-4DB7-4D7F-9D82-4CD5C102FA05");
    public const ATOM_FAST_THRESHOSD3   = Ble.stringToUuid("F8DE242F-8D84-4C12-9A2F-9C64A31CA7CA");
    public const ATOM_FAST_CONFIG_CHAR  = Ble.stringToUuid("EA50CFCD-AC4A-4A48-BF0E-879E548AE157");

    (:property) public const THRESHOLDS = [
        ATOM_FAST_THRESHOSD1,
        ATOM_FAST_THRESHOSD2,
        ATOM_FAST_THRESHOSD3,
    ];

    private const _profileDef = {
        :uuid => ATOM_FAST_SERVICE,
        :characteristics => [{
            :uuid => ATOM_FAST_CHAR,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }, {
            :uuid => ATOM_FAST_THRESHOSD1,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }, {
            :uuid => ATOM_FAST_THRESHOSD2,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }, {
            :uuid => ATOM_FAST_THRESHOSD3,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }, {
            :uuid => ATOM_FAST_CONFIG_CHAR,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }]
    };

    private const UuidNameLookup = {
        ATOM_FAST_SERVICE => "Atom Fast Service"
    };

    public function getProfile() {
        return _profileDef;
    }

    public function getDescription(uuid) {
        if(UuidNameLookup.hasKey(uuid)) {
            return UuidNameLookup[uuid];
        }
        return null;
    }
}
