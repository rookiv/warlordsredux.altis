// Read mission config file for requisition costs
// Hierarchy: CfgWLRequisitionPresets >> preset >> side >> category >> class
private _nameHashMap = createHashMap;
private _descriptionHashMap = createHashMap;
private _spawnHashMap = createHashMap;
private _costHashMap = createHashMap;
private _rearmTimerHashMap = createHashMap;
private _killRewardHashMap = createHashMap;

private _structureHashMap = createHashMap;
private _capValueHashMap = createHashMap;
private _apsHashMap = createHashMap;
private _garbageCollectHashMap = createHashMap;
private _demolishableHashMap = createHashMap;
private _loadableHashMap = createHashMap;
private _flagOffsetHashMap = createHashMap;

private _populateUnitPoolList = [];
private _populateVehiclePoolList = [];
private _populateAircraftPoolList = [];

private _disallowMagazinesForVehicle = createHashMap;
private _allowPylonMagazines = createHashMap;

private _turretOverridesHashMap = createHashMap;

private _requisitionPresets = BIS_WL_purchaseListTemplate;
{
	private _requisitionPreset = missionConfigFile >> "CfgWLRequisitionPresets" >>_x;
	private _requisitionSides = configProperties [_requisitionPreset];
	{
		private _requisitionCategories = configProperties [_x];
		{
			private _requisitionClasses = configProperties [_x];
			{
				private _requistitonName = configName _x;
				private _requisitionNameOverride = getText (_x >> "name");
				private _requisitionDescription = getText (_x >> "description");
				private _requisitionSpawn = getText (_x >> "spawn");
				private _requisitionCost = getNumber (_x >> "cost");
				private _requisitionRearmTime = getNumber (_x >> "rearm");
				private _requisitionKillReward = getNumber (_x >> "killReward");
				private _requisitionStructure = getNumber (_x >> "killReward");
				private _requisitionCapValue = getNumber (_x >> "capValue");
				private _requisitionAps = getNumber (_x >> "aps");

				private _requisitionGarbageCollect = getNumber (_x >> "garbageCollect");
				private _requisitionDemolishable = getNumber (_x >> "demolishable");
				private _requisitionLoadable = getNumber (_x >> "loadable");

				private _requisitionFlagOffset = getArray (_x >> "flagOffset");

				private _requisitionDisallowMagazines = getArray (_x >> "disallowMagazines");
				private _requisitionAllowPylonMagazines = getArray (_x >> "allowPylonMagazines");

				private _requisitionUnitSpawn = getNumber (_x >> "unitSpawn");
				private _requisitionVehicleSpawn = getNumber (_x >> "vehicleSpawn");
				private _requisitionAircraftSpawn = getNumber (_x >> "aircraftSpawn");

				private _requisitionTurretOverrides = "inheritsFrom _x == (missionConfigFile >> 'WLTurretDefaults')" configClasses _x;

				if (_requisitionNameOverride != "") then {
					_nameHashMap set [_requistitonName, _requisitionNameOverride];
				};

				if (_requisitionDescription != "") then {
					_descriptionHashMap set [_requistitonName, _requisitionDescription];
				};

				if (_requisitionSpawn != "") then {
					_spawnHashMap set [_requistitonName, _requisitionSpawn];
				};

				if (_requisitionCost != 0) then {
					_costHashMap set [_requistitonName, _requisitionCost];
				};

				if (_requisitionRearmTime != 0) then {
					_rearmTimerHashMap set [_requistitonName, _requisitionRearmTime];
				};

				if (_requisitionKillReward != 0) then {
					_killRewardHashMap set [_requistitonName, _requisitionKillReward];
				};

				if (_requisitionStructure != 0) then {
					_structureHashMap set [_requistitonName, true];
				};

				if (_requisitionCapValue != 0) then {
					_capValueHashMap set [_requistitonName, _requisitionCapValue];
				};

				if (_requisitionAps != 0) then {
					_apsHashMap set [_requistitonName, _requisitionAps - 1]; // 0-indexed
				};

				if (_requisitionGarbageCollect != 0) then {
					_garbageCollectHashMap set [_requistitonName, true];
				};

				if (_requisitionDemolishable != 0) then {
					_demolishableHashMap set [_requistitonName, true];
				};

				if (_requisitionLoadable != 0) then {
					_loadableHashMap set [_requistitonName, true];
				};

				if (count _requisitionFlagOffset > 0) then {
					_flagOffsetHashMap set [_requistitonName, _requisitionFlagOffset];
				};

				if (_requisitionUnitSpawn != 0) then {
					_populateUnitPoolList pushBack _requistitonName;
				};

				if (_requisitionVehicleSpawn != 0) then {
					_populateVehiclePoolList pushBack _requistitonName;
				};

				if (_requisitionAircraftSpawn != 0) then {
					_populateAircraftPoolList pushBack _requistitonName;
				};

				if (count _requisitionDisallowMagazines > 0) then {
					private _disallowListForVehicle = [];
					{
						_disallowListForVehicle pushBack _x;
					} forEach _requisitionDisallowMagazines;
					_disallowMagazinesForVehicle set [_requistitonName, _disallowListForVehicle];
				};

				if (count _requisitionAllowPylonMagazines > 0) then {
					private _allowListForAircraft = [];
					{
						_allowListForAircraft pushBack _x;
					} forEach _requisitionAllowPylonMagazines;
					_allowPylonMagazines set [_requistitonName, _allowListForAircraft];
				};

				if (count _requisitionTurretOverrides > 0) then {
					_turretOverridesHashMap set [_requistitonName, _requisitionTurretOverrides];
				};
			} forEach _requisitionClasses;
		} forEach _requisitionCategories;
	} forEach _requisitionSides;
} forEach _requisitionPresets;


if (isServer) then {
	serverNamespace setVariable ["fundsDatabase", createHashMap];
	serverNamespace setVariable ["playerList", createHashMap];

	serverNamespace setVariable ["WL2_costs", _costHashMap];
	serverNamespace setVariable ["WL2_killRewards", _killRewardHashMap];
	serverNamespace setVariable ["WL2_cappingValues", _capValueHashMap];

	serverNamespace setVariable ["WL2_populateUnitPoolList", _populateUnitPoolList];
	serverNamespace setVariable ["WL2_populateVehiclePoolList", _populateVehiclePoolList];
	serverNamespace setVariable ["WL2_populateAircraftPoolList", _populateAircraftPoolList];

	serverNamespace setVariable ["WL2_staticsGarbageCollector", _garbageCollectHashMap];
	serverNamespace setVariable ["garbageCollector",
		createHashMapFromArray [
			["Steerable_Parachute_F", true],
			["B_Ejection_Seat_Plane_Fighter_01_F", true],
			["O_Ejection_Seat_Plane_Fighter_02_F", true],
			["I_Ejection_Seat_Plane_Fighter_03_F", true],
			["B_Ejection_Seat_Plane_CAS_01_F", true],
			["O_Ejection_Seat_Plane_CAS_02_F", true],
			["Plane_Fighter_03_Canopy_F", true],
			["Plane_CAS_02_Canopy_F", true],
			["Plane_CAS_01_Canopy_F", true],
			["Plane_Fighter_01_Canopy_F", true],
			["Plane_Fighter_02_Canopy_F", true],
			["Plane_Fighter_04_Canopy_F", true] //<--no comma on last item
		]
	];
};

missionNamespace setVariable ["WL2_nameOverrides", _nameHashMap];
missionNamespace setVariable ["WL2_descriptions", _descriptionHashMap];
missionNamespace setVariable ["WL2_spawnClass", _spawnHashMap];
missionNamespace setVariable ["WL2_aps", _apsHashMap];

missionNamespace setVariable ["WL2_demolishable", _demolishableHashMap];
missionNamespace setVariable ["WL2_structure", _structureHashMap];

missionNamespace setVariable ["WL2_loadable", _loadableHashMap];
missionNamespace setVariable ["WL2_flagOffsets", _flagOffsetHashMap];

missionNamespace setVariable ["WL2_disallowMagazinesForVehicle", _disallowMagazinesForVehicle];
missionNamespace setVariable ["WL2_allowPylonMagazines", _allowPylonMagazines];
missionNamespace setVariable ["WL2_rearmTimers", _rearmTimerHashMap];
missionNamespace setVariable ["WL2_turretOverrides", _turretOverridesHashMap];