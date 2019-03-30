// Number of AI to spawn each side
br_friendly_mark_enemy = if ("FriendlyMarkEnemy" call BIS_fnc_getParamValue == 1) then { TRUE } else { FALSE }; // If friendly units mark enemies on map
br_enable_friendly_ai = if ("FriendlyAIEnabled" call BIS_fnc_getParamValue == 1) then { TRUE } else { FALSE }; // If firendly units are enabled
br_hq_enabled = if ("HQEnabled" call BIS_fnc_getParamValue == 1) then { TRUE } else { FALSE };
br_max_ai_distance_before_delete = "MinAIDistanceForDeleteion" call BIS_fnc_getParamValue;
br_min_enemy_groups_for_capture = "MinEnemyGroupsForCapture" call BIS_fnc_getParamValue; // Groups left for zone capture
br_min_special_groups = "NumberEnemySpecialGroups" call BIS_fnc_getParamValue;
br_min_friendly_ai_groups = "NumberFriendlyGroups" call BIS_fnc_getParamValue;
br_min_ai_groups = "NumberEnemyGroups" call BIS_fnc_getParamValue; // Number of groups
br_enabled_side_objectives = "SideObjectives" call BIS_fnc_getParamValue;
br_max_checks = 500; //"Checks" call BIS_fnc_getParamValue; // Max checks on finding markers for the gamemode
br_zone_radius = "ZoneRadius" call BIS_fnc_getParamValue;
br_mines_enabled = if ("RandomMines" call BIS_fnc_getParamValue == 1) then { TRUE } else { FALSE };
br_randomly_find_zone = if ("PlaceZoneRandomly" call BIS_fnc_getParamValue == 1) then { TRUE } else { FALSE }; // Finds a random position on the map intead of using markers
br_zone_side_enabled = if ("ZoneSideEnabled" call BIS_fnc_getParamValue == 1) then { TRUE } else { FALSE };
br_max_current_sides = "NSides" call BIS_fnc_getParamValue;
br_max_garrisons = "NGarrisons" call BIS_fnc_getParamValue;
br_ai_skill = [0.1, 0.5, 1] select (parseNumber "AISkill" call BIS_fnc_getParamValue);
br_side_types = ["OPF_F","BLU_F"];
br_empty_vehicles_in_garbage_collection = [];
br_friendly_groups_wating_for_evac = []; // Waiting at zone after capture
br_friendly_objective_groups = []; // The objective groups which complete objectives
br_friendly_groups_waiting = []; // Waiting at base for pickup
br_friendly_ground_groups = []; // Friendly ground units
br_enemy_vehicle_objects = [];
br_friendly_ai_groups = []; // All Firendly AI
br_special_ai_groups = []; // Enemy special groups
br_groups_in_transit = []; // Groups in transit to the zone via helicopters
br_friendly_vehicles = []; // Friendly armor
br_groups_marked = []; // Enemy groups marked on map
br_base_defences = [];
br_sides = [EAST, WEST];
br_heliGroups = []; // Helicopters
br_objectives = []; // Objectives at the zone
br_ai_groups = []; // All spawned groups
br_zones = []; // Zone Locations
br_spawn_enemy_to_player_dis = 300; // Won't let AI in the zone spawn within this distance to a player
br_min_radius_distance = 180; // Limit to spawm from center
br_max_radius_distance = 360; // Outter limit
br_objective_max_angle = 0.30;
br_heli_land_max_angle = 0.25;
br_command_delay = 10; // Command delay for both enemy and friendly zone AI
br_radio_tower_destoryed = FALSE; // If the radio tower is destroyed
br_blow_up_radio_tower = FALSE; // Use for AI who blow up Radio Tower
br_radio_tower_enabled = TRUE;
br_zone_taken = TRUE; // If the zone is taken.. start off at true
br_first_Zone = TRUE; // If it's the first zone
br_HQ_taken = FALSE; // If the HQ is taken
br_current_zone = nil; // Current selected zone
br_current_sides = [];
br_next_zone_start_delay = 35; // Delay between zones
br_queue_squads_distance = 2000; // When new zone is over this amount queue group in evacs
br_groups_in_buildings = [];
br_groupsStuckTeleportDelay = 60; // Time before units are teleported into the cargo

// Creates the zone
br_fnc_createZone = {
	if (br_randomly_find_zone) then {
		br_current_zone = [[], 0, -1, 0, 0, 25, 0] call BIS_fnc_findSafePos;
	} else {
		br_current_zone = selectRandom br_zones;
	};
	// Creates the radius
	["ZONE_RADIUS", br_current_zone, br_zone_radius, br_max_radius_distance, "colorOPFOR", "Enemy Zone", 0.4, "Grid", "ELLIPSE"] call (compile preProcessFile "core\server\markers\fn_createRadiusMarker.sqf");
	// Create text icon
	["ZONE_ICON", br_current_zone, "Enemy Zone", "ColorBlue", 1] call (compile preProcessFile "core\server\markers\fn_createTextMarker.sqf");
};

// Delete groups in AIGroups
br_fnc_deleteGroups = {
	private _group = _this select 0;
	{ deleteVehicle _x } forEach (units _group);
	deleteGroup _group;
};

// Delete all enemy AI
br_fnc_deleteAllAI = {
	// Delete existing units 
	{ [_x] call br_fnc_deleteGroups; } forEach br_ai_groups;
	{ [_x] call br_fnc_deleteGroups; } forEach br_special_ai_groups;
	{ [_x] call br_fnc_deleteGroups; } forEach br_groups_in_buildings;
	br_ai_groups = [];
	br_special_ai_groups = [];
	br_enemy_vehicle_objects = [];
	br_groups_in_buildings = [];
};

// Find all markers
// Runs once per mission
br_fnc_doChecks = {
	for "_i" from 0 to br_max_checks do {
		// Get marker prefixs
		private _endString = Format ["zone_spawn_%1", _i];
		private _endStringVeh = Format ["vehicle_spawn_%1", _i];
		private _endStringHeli = Format ["helicopter_transport_%1", _i];
		private _endStringHeliEvac = Format ["helicopter_evac_%1", _i];
		private _endStringBombSquad = Format ["objective_squad_%1", _i];
		private _endStringRecruit = Format ["recruit_%1", _i];
		private _endStringJetSpawn = Format ["jet_spawn_%1", _i];
		private _endStringVehicleTransport = Format ["vehicle_transport_spawn_%1", _i];
		private _endStringVehicleEvac = Format ["vehicle_evac_spawn_%1", _i];
		private _endStringBaseDefence = Format ["defence_spawn_%1", _i];
		// Check if markers exist
		if (getMarkerColor _endString != "") 
		then { br_zones append [getMarkerPos _endString]; };
		if ((getMarkerColor _endStringVeh != "") && {(br_enable_friendly_ai)}) 
		then { [_endStringVeh, (call compile preprocessFileLineNumbers "core\spawnlists\friendly_vehicles.sqf")] execVM "core\server\base\fn_createVehicle.sqf"; };
		if ((getMarkerColor _endStringJetSpawn != "") && {(br_enable_friendly_ai)}) 
		then { [_endStringJetSpawn, (call compile preprocessFileLineNumbers "core\spawnlists\friendly_jets.sqf")] execVM "core\server\base\fn_createVehicle.sqf"; };
		if ((getMarkerColor _endStringHeli != "") && {(br_enable_friendly_ai)})
		then { [_endStringHeli, _i, FALSE] execVM "core\server\base\fn_createHelis.sqf"; };
		if ((getMarkerColor _endStringHeliEvac != "") && {(br_enable_friendly_ai)})
		then { [_endStringHeliEvac, _i, TRUE] execVM "core\server\base\fn_createHelis.sqf"; };
		if ((getMarkerColor _endStringBombSquad != "") && {(br_enable_friendly_ai)})
		then { [_endStringBombSquad, _i] execVM "core\server\base\fn_createObjectiveUnits.sqf"; };
		if ((getMarkerColor _endStringRecruit != "") && {(br_enable_friendly_ai)})
		then { [_endStringRecruit, _i, (call compile preprocessFileLineNumbers "core\spawnlists\friendly_recruit.sqf")] execVM "core\server\recruit\fn_createRecruitAI.sqf"; };
		if ((getMarkerColor _endStringVehicleTransport != "") && {(br_enable_friendly_ai)})
		then { [_endStringVehicleTransport, _i, (call compile preprocessFileLineNumbers "core\spawnlists\friendly_vehicle_transport.sqf"), FALSE] execVM "core\server\base\fn_createTransportVehicle.sqf"; };
		if ((getMarkerColor _endStringVehicleEvac != "") && {(br_enable_friendly_ai)})
		then { [_endStringVehicleEvac, _i, (call compile preprocessFileLineNumbers "core\spawnlists\friendly_vehicle_transport.sqf"), TRUE] execVM "core\server\base\fn_createTransportVehicle.sqf"; };
		if ((getMarkerColor _endStringBaseDefence != "") && {(br_enable_friendly_ai)})
		then { [_endStringBaseDefence, (call compile preprocessFileLineNumbers "core\spawnlists\friendly_base_defence.sqf")] execVM "core\server\base\fn_createBaseDefence.sqf"; };
		[_i] call br_fnc_doChecksDebug;
	};
};

br_fnc_doChecksDebug = {
	private _index = _this select 0;

	private _endStringUnitNeedingEvac = Format ["debug_unit_to_evac_%1", _i];

	if ((getMarkerColor _endStringUnitNeedingEvac != "") && {(br_enable_friendly_ai)})
	then { [_endStringUnitNeedingEvac, _i] execVM "core\server\debug\fnc_unitToEvac.sqf"; };
};

// Called when zone is taken
br_fnc_onZoneTaken = {
	br_zone_taken = TRUE;
	[[["Zone Taken!"],"core\client\task\fn_completeObjective.sqf"],"BIS_fnc_execVM",true,true] call BIS_fnc_MP;
	[[[],"core\client\task\fn_completeZoneTask.sqf"],"BIS_fnc_execVM",true,true] call BIS_fnc_MP;
	// Delete all markers
	deleteMarker "ZONE_RADIUS";
	deleteMarker "ZONE_ICON";
	// Delete all AI left at zone
	[] call br_fnc_deleteAllAI;
	[] call br_fnc_deleteNonSideObjectives;
	//br_objectives = [];
};

// Remove objectives which belong to the zone
br_fnc_deleteNonSideObjectives = {
	{
		private _removeOnZoneCompleted = _x select 7;
		if (_removeOnZoneCompleted) then {
			// Set objective as completed
			missionNamespace setVariable [_x select 5, TRUE]; 
			br_objectives deleteAt (br_objectives find _x);
		}
	} foreach br_objectives;
};

// On first zone creation after AI and everything has been placed do the following...
br_fnc_onFirstZoneCreation = {
	if (br_enable_friendly_ai) then {
		execVM "core\server\base\fn_friendlySpawnAI.sqf";
		execVM "core\server\zone\fn_commandFriendlyGroups.sqf";
		execVM "core\server\garbage_collector\fn_checkFriendyAIPositions.sqf";
		if (br_friendly_mark_enemy) then { execVM "core\server\zone\fn_checkFriendlyFindEnemy.sqf"; };
	};
	if (br_enabled_side_objectives == 1) then { execVM "core\server\side_objective\fn_runObjectives.sqf"; };
	execVM "core\server\zone\fn_commandEnemyGroups.sqf";
	execVM "core\server\garbage_collector\fn_garbageCollector.sqf";
	br_first_Zone = FALSE;
};

// Set fuel for all vehicles in a group to a given amount
br_fnc_setGroupFuelFull = {
	private _group = _this select 0; // The given group
	private _fuelAmount = _this select 1; // 0 - 1

	{  
		_vehicle = (vehicle _x);
		// Check if vehicle is null
		if (!(isNull _vehicle)) then {
			_vehicle setfuel _fuelAmount;
		};
	} forEach (units _group);
};

// On new zone creation after AI and everything has been placed do the following...
br_fnc_onNewZoneCreation = {
	// Delete all waypoints for vehicles
	{  
		while {(count (waypoints _x)) > 0} do {
			deleteWaypoint ((waypoints _x) select 0);
		};
		[_x, 1] call br_fnc_setGroupFuelFull;
	} forEach br_friendly_vehicles;
	// Place all the friendly ground units at the zone into a waiting evac queue
	{
		if (_x in br_friendly_ai_groups) then {
			// Delete waypoints
			while {(count (waypoints _x)) > 0} do {
				deleteWaypoint ((waypoints _x) select 0);
			};
			_x setBehaviour "SAFE";	
			// Add the group to the evac queue and delete from roaming if too far away from new zone
			if ((getpos (leader _x)) distance br_current_zone > br_queue_squads_distance) then { br_friendly_ai_groups deleteAt (br_friendly_ai_groups find _x); br_friendly_groups_wating_for_evac append [_x]; };
		}
	} forEach br_friendly_ground_groups;
	{
		deleteVehicle _x;
	} forEach br_enemy_vehicle_objects;
};

br_random_objectives = {
	// Create HQ
	if (br_hq_enabled) then {["HQ", "HQ", 10, selectrandom (call compile preprocessFileLineNumbers "core\savedassets\bases.sqf"), "Kill", TRUE, "HQ Taken!", ["O_officer_F", "O_Soldier_F", "O_Soldier_AT_F", "O_Soldier_AA_F", "O_medic_F", "O_Soldier_GL_F"], TRUE, TRUE, "Border", "ELLIPSE", getMarkerPos "ZONE_RADIUS", TRUE, [["PATH", FALSE]], TRUE] execVM "core\server\zone_objective\fn_createObjective.sqf";};
	// Create radio tower
	if (br_radio_tower_enabled) then {["Radio_Tower", "Radio Tower", 8, selectrandom (call compile preprocessFileLineNumbers "core\savedassets\radio_towers.sqf"), "Destory", TRUE, "Radio Tower Destroyed!", [], TRUE, TRUE, "Border", "ELLIPSE", getMarkerPos "ZONE_RADIUS", TRUE, [], FALSE] execVM "core\server\zone_objective\fn_createObjective.sqf";};
	// Create a random objective
	if (br_zone_side_enabled) then {
		private _zoneSideObjective = selectrandom (call compile preprocessFileLineNumbers "core\savedassets\zone_objectives.sqf");
		[
			_zoneSideObjective select 0, 
			_zoneSideObjective select 1,
			_zoneSideObjective select 2,
			_zoneSideObjective select 3,
			_zoneSideObjective select 4,
			_zoneSideObjective select 5,
			_zoneSideObjective select 6,
			_zoneSideObjective select 7,
			_zoneSideObjective select 8,
			_zoneSideObjective select 9,
			_zoneSideObjective select 10,
			_zoneSideObjective select 11,
			_zoneSideObjective select 12,
			_zoneSideObjective select 13,
			_zoneSideObjective select 14,
			_zoneSideObjective select 15
		] execVM "core\server\zone_objective\fn_createObjective.sqf";
	}
};

// Waits for objectives within the zone to be completed
br_fnc_waitForCompletedObjects = {
	private _objective = _this select 0;
	 if (_objective select 6) then { waitUntil { sleep 5; (missionNamespace getVariable (_objective select 5) && getMarkerColor (_objective select 10) != "ColorRed")  }; };
};

// Main function
br_fnc_main = {
	// Check for markers and do things
	[] call br_fnc_doChecks;
	while {TRUE} do {
		// Everything relies on the zone so we create it first, and not using execVM since it has a queue.
		[] call br_fnc_createZone;
		execVM "core\server\task\fn_playerZoneTasking.sqf";
		[] call br_random_objectives;
		// Check if it's the first zone
		if (br_first_Zone) then { call br_fnc_onFirstZoneCreation } else { [] call br_fnc_onNewZoneCreation; };
		// Set taken as false
		br_zone_taken = FALSE;
		["ZONE_Radio_Tower_RADIUS", (call compile preprocessFileLineNumbers "core\spawnlists\enemy_speicals.sqf")] execVM "core\server\zone\fn_zoneSpawnAI.sqf";
		if (br_mines_enabled) then { execVM "core\server\zone\fn_placeMines.sqf"; };
		// Wait for a time for the zone to populate
		sleep 60;
		// Wait untill zone is taken and objectives are completed
		{ [_x] call br_fnc_waitForCompletedObjects; } forEach br_objectives;
		// Wait untill enemy units drop below a threshold
		waitUntil { sleep 5; ((count br_ai_groups - (count br_groups_in_buildings / 2)) <= br_min_enemy_groups_for_capture) };
		[] call br_fnc_onZoneTaken;
		sleep br_next_zone_start_delay;
	}
};

[] call br_fnc_main;