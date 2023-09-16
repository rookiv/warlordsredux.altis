params ["_pos", "_class", "_side"];

if !(isServer) exitWith {};

_asset = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];

private _vehCfg = configFile >> "CfgVehicles" >> _class; 
private _crewCount = { 
	round getNumber (_x >> "dontCreateAI") < 1 && 
	((_x == _vehCfg && { round getNumber (_x >> "hasDriver") > 0 }) || 
	(_x != _vehCfg && { round getNumber (_x >> "hasGunner") > 0 })) 
} count ([_class, configNull] call BIS_fnc_getTurrets);
private _myArray = [0];
_myArray resize _crewCount;

[_side, _myArray, _asset, _pos] spawn {
	params ["_side", "_myArray", "_asset", "_pos"];
	if (_side == west) then {
		private _grp = createGroup _side;
		{
			private _unit = _grp createUnit ["B_UAV_AI", _pos, [], 1, "NONE"];
			_unit moveInAny _asset;
		} forEach _myArray;
	} else {
		private _grp = createGroup _side;
		{
			private _unit = _grp createUnit ["O_UAV_AI", _pos, [], 1, "NONE"];
			_unit moveInAny _asset;
		} forEach _myArray;
	};
};

_asset;