using Toybox.BluetoothLowEnergy as Ble;

class AtomFastProfile {
    public const ATOM_FAST_SERVICE  = Ble.stringToUuid("63462a4a-c28c-4ffd-87a4-2d23a1c72581");
    public const ATOM_FAST_CHAR     = Ble.stringToUuid("70bc767e-7a1a-4304-81ed-14b9af54f7bd");

    private const _profileDef = {
        :uuid => ATOM_FAST_SERVICE,
        :characteristics => [{
            :uuid => ATOM_FAST_CHAR,
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
