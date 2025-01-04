#include "..\..\warlords_constants.inc"

addMissionEventHandler ["Map", {
	params ["_mapIsOpened", "_mapIsForced"];

	private _userMarkerAlpha = if (profileNamespace getVariable ["MRTM_showMarkers", true]) then {
		1;
	} else {
		0;
	};
	{
		if ("_USER_DEFINED #" in _x) then {
			_x setMarkerAlphaLocal _userMarkerAlpha;
		};
	} forEach allMapMarkers;

	if (_mapIsOpened) then {
		MAP_CONTROL = addMissionEventHandler ["EachFrame", {
			private _map = (uiNamespace getVariable ["BIS_WL_mapControl", controlNull]);

			if (visibleMap) then {
				private _ctrlMap = ctrlParent _map;
				private _ctrlSectorInfoBox = _ctrlMap getVariable "BIS_sectorInfoBox";

				private _radius = (((ctrlMapScale _map) * 500) min 30) max 3;
				private _pos = _map ctrlMapScreenToWorld getMousePosition;
				private _nearbyAssets = (_pos nearObjects _radius) select {
					(getPlayerUID player) == (_x getVariable ["BIS_WL_ownerAsset", "123"]) && _x != player && alive _x
				};

				if (count _nearbyAssets > 0) then {
					BIS_WL_mapAssetTarget = _nearbyAssets # 0;
					_ctrlSectorInfoBox ctrlSetPosition [(getMousePosition # 0) + safeZoneW / 100, (getMousePosition # 1) + safeZoneH / 50, safeZoneW, safeZoneH];
					_ctrlSectorInfoBox ctrlCommit 0;
					_ctrlSectorInfoBox ctrlSetStructuredText parseText format [
						"<t shadow = '2' size = '%1'>%2</t>",
						(1 call WL2_fnc_purchaseMenuGetUIScale),
						format [
							"Click for options:<br/><t color='#ff4b4b'>%1</t>",
							[BIS_WL_mapAssetTarget] call WL2_fnc_getAssetTypeName
						]
					];
					_ctrlSectorInfoBox ctrlShow true;
					_ctrlSectorInfoBox ctrlEnable true;
				} else {
					BIS_WL_mapAssetTarget = objNull;
					_ctrlSectorInfoBox ctrlShow false;
					_ctrlSectorInfoBox ctrlEnable false;
				};

				if (isNull (findDisplay 160 displayCtrl 51)) then {
					_mapScale = ctrlMapScale WL_CONTROL_MAP;
					_timer = (serverTime % WL_MAP_PULSE_FREQ);
					_timer = if (_timer <= (WL_MAP_PULSE_FREQ / 2)) then {_timer} else {WL_MAP_PULSE_FREQ - _timer};
					_markerSize = linearConversion [0, WL_MAP_PULSE_FREQ / 2, _timer, 1, WL_MAP_PULSE_ICON_SIZE];
					_markerSizeArr = [_markerSize, _markerSize];

					{
						_x setMarkerSizeLocal [WL_CONNECTING_LINE_AXIS * _mapScale * BIS_WL_mapSizeIndex, (markerSize _x) # 1];
					} forEach BIS_WL_sectorLinks;

					{
						if !(_x in BIS_WL_selection_availableSectors) then {
							((_x getVariable "BIS_WL_markers") # 0) setMarkerSizeLocal [1, 1];
						} else {
							if (_x == BIS_WL_targetVote) then {
								((_x getVariable "BIS_WL_markers") # 0) setMarkerSizeLocal [WL_MAP_PULSE_ICON_SIZE, WL_MAP_PULSE_ICON_SIZE];
							} else {
								((_x getVariable "BIS_WL_markers") # 0) setMarkerSizeLocal _markerSizeArr;
							};
						};
					} forEach BIS_WL_allSectors;
				};
			};
		}];

		MAP_CONTROL_CLICK = addMissionEventHandler ["MapSingleClick", {
			params ["_units", "_pos", "_alt", "_shift"];
			private _asset = BIS_WL_mapAssetTarget;

			if (isNull _asset) exitWith {};
			WL_MapActionTarget = _asset;

			private _dialog = findDisplay 46 createDisplay "RscDisplayEmpty";

			getMousePosition params ["_mouseX", "_mouseY"];

			private _offsetX = _mouseX + 0.03;
			private _offsetY = _mouseY + 0.04;

			private _deleteButton = _dialog ctrlCreate ["RscButtonMenu", -1];
			_deleteButton ctrlSetPosition [_offsetX, _offsetY, 0.35, 0.05];
			_deleteButton ctrlSetStructuredText parseText "<t align='center'>DELETE</t>";
			_deleteButton ctrlCommit 0;

			private _lockButton = _dialog ctrlCreate ["RscButtonMenu", -1];
			_lockButton ctrlSetPosition [_offsetX, _offsetY + 0.05, 0.35, 0.05];
			private _accessControl = _asset getVariable ["WL2_accessControl", 0];
			private _lockStatus = ["ALL", "ALL (PASSENGER)", "SQUAD", "SQUAD (PASSENGER)", "PERSONAL", "LOCKED"] select _accessControl;
			private _lockColor = ["#4bff58", "#4bff58", "#00ffff", "#00ffff", "#ff4b4b", "#ff4b4b"] select _accessControl;
			_lockButton ctrlSetStructuredText parseText format ["<t align='center'>LOCK: <t color='%1'>%2</t></t>", _lockColor, _lockStatus];
			_lockButton ctrlCommit 0;

			private _kickButton = _dialog ctrlCreate ["RscButtonMenu", -1];
			_kickButton ctrlSetPosition [_offsetX, _offsetY + 0.1, 0.35, 0.05];
			_kickButton ctrlSetStructuredText parseText "<t align='center'>KICK</t>";
			_kickButton ctrlCommit 0;

			_deleteButton ctrlAddEventHandler ["ButtonClick", {
				params ["_control"];
				private _asset = WL_MapActionTarget;
				if !(isNull _asset) then {
					_asset spawn WL2_fnc_deleteAssetFromMap;
				};
				WL_MapActionTarget = objNull;

				private _dialog = ctrlParent _control;
				_dialog closeDisplay 1;
			}];

			_lockButton ctrlAddEventHandler ["ButtonClick", {
				params ["_control"];
				private _asset = WL_MapActionTarget;
				if !(isNull _asset) then {
					private _accessControl = _asset getVariable ["WL2_accessControl", 0];
					private _newAccess = (_accessControl + 1) % 6;
					_asset setVariable ["WL2_accessControl", _newAccess, true];
					playSound3D ["a3\sounds_f\sfx\objects\upload_terminal\terminal_lock_close.wss", _asset, false, getPosASL _asset, 1, 1, 0, 0];

					private _lockStatus = ["ALL", "ALL (PASSENGER)", "SQUAD", "SQUAD (PASSENGER)", "PERSONAL", "LOCKED"] select _newAccess;
					private _lockColor = ["#4bff58", "#4bff58", "#00ffff", "#00ffff", "#ff4b4b", "#ff4b4b"] select _newAccess;
					_control ctrlSetStructuredText parseText format ["<t align='center'>LOCK: <t color='%1'>%2</t></t>", _lockColor, _lockStatus];
				};
			}];

			_kickButton ctrlAddEventHandler ["ButtonClick", {
				params ["_control"];
				private _asset = WL_MapActionTarget;
				if !(isNull _asset) then {
					private _unwantedPassengers = (crew _asset) select {
						(_x != player) && getPlayerUID player != (_x getVariable ["BIS_WL_ownerAsset", "123"])
					};
					{
						moveOut _x;
					} forEach _unwantedPassengers;
				};
				WL_MapActionTarget = objNull;

				private _dialog = ctrlParent _control;
				_dialog closeDisplay 1;
			}];

			[_dialog, _offsetX, _offsetY] spawn {
				params ["_dialog", "_originalMouseX", "_originalMouseY"];
				private _keepDialog = true;
				while { visibleMap && _keepDialog} do {
					getMousePosition params ["_mouseX", "_mouseY"];

					private _deltaX = _mouseX - _originalMouseX;
					private _deltaY = _mouseY - _originalMouseY;

					if (_deltaX < 0 || _deltaX > 0.35 || _deltaY < 0 || _deltaY > 0.15) then {
						_keepDialog = inputMouse 0 == 0 && inputMouse 1 == 0;
					};
				};

				WL_MapActionTarget = objNull;
				_dialog closeDisplay 1;
			};
		}];
	} else {
		removeMissionEventHandler ["EachFrame", MAP_CONTROL];
		removeMissionEventHandler ["MapSingleClick", MAP_CONTROL_CLICK];
	};
}];