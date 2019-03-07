if (isServer) then {
	// Run the gamemode
	execVM "core\server\zone\zoneCreation.sqf";
	// Allow zeus to see spawned things
	if ("ZeusSeesAI" call BIS_fnc_getParamValue == 1) then { execVM "core\server\zeus\fn_addEditableZeus.sqf"; };
};

// If it's a client
if (hasInterface) then {
	// Disable annoying crap
	execVM "core\client\fn_setPlayerSettings.sqf";
	execVM "core\client\fn_displayStartingScreen.sqf";
};