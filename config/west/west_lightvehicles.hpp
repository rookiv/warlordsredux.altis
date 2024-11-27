class LightVehicles {
    class B_Quadbike_01_F {
        cost = 20;
        requirements[] = {};
        killReward = 20;
        capValue = 1;
    }; // "Quad Bike"

    class B_G_Offroad_01_armed_F {
        cost = 150;
        requirements[] = {};
        rearm = 120;
        killReward = 150;
        capValue = 1;

        class Gunner: WLTurretDefaults {
            turret[] = { 0 };
            removeMagazines[] = {};
            removeWeapons[] = {
                "HMG_M2_Mounted"
            };
            addMagazines[] = {
                "100Rnd_127x99_mag_Tracer_Yellow",
                "100Rnd_127x99_mag_Tracer_Yellow",
                "100Rnd_127x99_mag_Tracer_Yellow",
                "100Rnd_127x99_mag_Tracer_Yellow"
            };
            addWeapons[] = {
                "HMG_M2_Mounted"
            };
        };
    }; // "Offroad (HMG)"

    class B_Truck_01_transport_F {
        cost = 200;
        requirements[] = {};
        killReward = 80;
        capValue = 1;
    }; // "HEMTT Transport"

    class B_LSV_01_armed_F {
        cost = 200;
        requirements[] = {};
        rearm = 120;
        killReward = 150;
        capValue = 1;

        class Gunner: WLTurretDefaults {
            turret[] = { 0 };
            removeMagazines[] = {};
            removeWeapons[] = {
                "HMG_127_LSV_01"
            };
            addMagazines[] = {
                "100Rnd_127x99_mag_Tracer_Red",
                "100Rnd_127x99_mag_Tracer_Red",
                "100Rnd_127x99_mag_Tracer_Red"
            };
            addWeapons[] = {
                "HMG_127_LSV_01"
            };
        };
    }; // "Prowler (HMG)"

    class B_MRAP_01_F {
        cost = 300;
        requirements[] = {};
        killReward = 70;
        capValue = 1;
    }; // "Hunter"

    class B_Truck_01_flatbed_F {
        cost = 500;
        requirements[] = {};
        killReward = 80;
        capValue = 1;
    }; // "HEMTT Flatbed"

    class B_G_Offroad_01_AT_F {
        cost = 500;
        requirements[] = {};
        rearm = 180;
        killReward = 180;
        capValue = 1;

        class Gunner: WLTurretDefaults {
            turret[] = { 0 };
            removeMagazines[] = {};
            removeWeapons[] = {
                "launcher_SPG9"
            };
            addMagazines[] = {
                "12Rnd_SPG9_HEAT"
            };
            addWeapons[] = {
                "launcher_SPG9"
            };
        };
    }; // "Offroad (AT)"

    class B_LSV_01_AT_F {
        cost = 750;
        requirements[] = {};
        rearm = 200;
        killReward = 200;
        capValue = 1;

        class Gunner: WLTurretDefaults {
            turret[] = { 0 };
            removeMagazines[] = {};
            removeWeapons[] = {
                "missiles_titan_static"
            };
            addMagazines[] = {
                "1Rnd_GAT_missiles",
                "1Rnd_GAT_missiles",
                "1Rnd_GAT_missiles",
                "1Rnd_GAT_missiles"
            };
            addWeapons[] = {
                "missiles_titan_static"
            };
        };
    }; // "Prowler (AT)"

    class B_MRAP_01_hmg_F {
        cost = 900;
        requirements[] = {};
        rearm = 300;
        killReward = 250;
        capValue = 2;
        aps = 1;
    }; // "Hunter HMG"

    class B_Truck_01_ammo_F {
        cost = 1000;
        requirements[] = {};
        killReward = 80;
        capValue = 1;
    }; // "HEMTT Ammo"

    class B_Truck_01_fuel_F {
        cost = 1000;
        requirements[] = {};
        killReward = 80;
        capValue = 1;
    }; // "HEMTT Fuel"

    class B_Truck_01_Repair_F {
        cost = 1000;
        requirements[] = {};
        killReward = 80;
        capValue = 1;
    }; // "HEMTT Repair"

    class B_LSV_01_AT_UP_F {
        name = "Prowler (AT UP)";
        description = "Prowler (AT UP) is a variant of the Prowler armed with a 5-mag Titan AT launcher.<br/>Armament: 5Rnd Titan AT x2";
        spawn = "B_LSV_01_AT_F";
        cost = 1200;
        requirements[] = {};
        rearm = 200;
        killReward = 250;
        capValue = 1;

        class Gunner: WLTurretDefaults {
            turret[] = { 0 };
            removeMagazines[] = {
                "1Rnd_GAT_missiles"
            };
            removeWeapons[] = {
                "missiles_titan_static"
            };
            addMagazines[] = {
                "5Rnd_GAT_missiles",
                "5Rnd_GAT_missiles"
            };
            addWeapons[] = {
                "missiles_titan"
            };
        };
    }; // "Prowler (AT UP)"

    class B_MRAP_01_gmg_F {
        cost = 1250;
        requirements[] = {};
        rearm = 300;
        killReward = 250;
        capValue = 2;
        aps = 1;
    }; // "Hunter GMG"

    class B_MRAP_01_gmg_up_F {
        name = "Hunter UP Autocannon";
        description = "Hunter UP is a variant of the Hunter armed with a 20mm autocannon.<br/>Armament: 60Rnd 20mm HE x6, 60Rnd 20mm AP x3, 200Rnd 127mm x3";
        spawn = "B_MRAP_01_gmg_F";
        cost = 1500;
        requirements[] = {};
        rearm = 300;
        killReward = 300;
        capValue = 2;
        aps = 2;

        class Gunner: WLTurretDefaults {
            turret[] = { 0 };
            removeMagazines[] = {
                "96Rnd_40mm_G_belt"
            };
            removeWeapons[] = {
                "GMG_40mm"
            };
            addMagazines[] = {
                "60Rnd_20mm_HE_shells",
                "60Rnd_20mm_HE_shells",
                "60Rnd_20mm_HE_shells",
                "60Rnd_20mm_HE_shells",
                "60Rnd_20mm_HE_shells",
                "60Rnd_20mm_HE_shells",
                "60Rnd_20mm_AP_shells",
                "60Rnd_20mm_AP_shells",
                "60Rnd_20mm_AP_shells",
                "200Rnd_127x99_mag_Tracer_Red",
                "200Rnd_127x99_mag_Tracer_Red",
                "200Rnd_127x99_mag_Tracer_Red"
            };
            addWeapons[] = {
                "cannon_20mm",
                "HMG_127"
            };
        };
    };

    class O_T_Truck_03_device_ghex_F {
        cost = 1500;
        requirements[] = {};
        killReward = 200;
        capValue = 1;
        aps = 4;
    }; // "Tempest Device"
};