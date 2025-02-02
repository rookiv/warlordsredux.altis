#include "constants.inc"

params ["_flag"];

if (!WLC_ENABLED) exitWith {};

private _index = _flag addAction [
	"Customize Player",
	{
        0 spawn WLC_fnc_buildMenu;
	},
	[],
	5,
	true,
	false,
	"",
	"",
	WL_MAINTENANCE_RADIUS,
	false
];

_flag setUserActionText [_index, "<t color = '#4bff58'>Customize Player</t>", "<img size='1.5' image='a3\ui_f\data\igui\cfg\simpletasks\types\backpack_ca.paa'/>"];

if (WLC_DEBUG) then {
	_flag addAction ["<t color = '#ffff00'>(Debug) Reset Score/Level to 0</t>", {
		[getPlayerUID player, 0] remoteExec ["WLC_fnc_setScore", 2];
	}, [], 5, true, true];
	_flag addAction ["<t color = '#ffff00'>(Debug) Add Score +1,000</t>", {
		private _score = ["getScore", player] call WLC_fnc_getLevelInfo;
		[getPlayerUID player, _score + 1000] remoteExec ["WLC_fnc_setScore", 2];
	}, [], 5, true, false];
	_flag addAction ["<t color = '#ffff00'>(Debug) Add Score +10,000</t>", {
		private _score = ["getScore", player] call WLC_fnc_getLevelInfo;
		[getPlayerUID player, _score + 10000] remoteExec ["WLC_fnc_setScore", 2];
	}, [], 5, true, false];
	_flag addAction ["<t color = '#ffff00'>(Debug) Add Score +100,000</t>", {
		private _score = ["getScore", player] call WLC_fnc_getLevelInfo;
		[getPlayerUID player, _score + 100000] remoteExec ["WLC_fnc_setScore", 2];
	}, [], 5, true, false];
	_flag addAction ["<t color = '#ffff00'>(Debug) Set Instant Respawn</t>", {
		setPlayerRespawnTime 1;
	}, [], 5];
	_flag addAction ["<t color = '#ffff00'>(Debug) Set Normal Respawn</t>", {
		setPlayerRespawnTime (getMissionConfigValue ["respawnDelay", 30]);
	}, [], 5];

	_flag addAction ["<t color = '#ffff00'>(Debug) Reset Tasks</t>", {
		profileNamespace setVariable ["WLT_TaskCompletionStatuses", createHashMap];
		{
			player removeSimpleTask _x;
		} forEach (simpleTasks player);
		[] call WLT_fnc_init;
	}, [], 5];
};