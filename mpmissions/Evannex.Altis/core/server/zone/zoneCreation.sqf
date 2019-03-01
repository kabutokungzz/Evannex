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
br_max_checks = 1000; //"Checks" call BIS_fnc_getParamValue; // Max checks on finding markers for the gamemode
br_zone_radius = "ZoneRadius" call BIS_fnc_getParamValue;
br_side_radius = 15;
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
br_command_delay = 5; // Command delay for both enemy and friendly zone AI
br_ai_skill = 1;
br_radio_tower_destoryed = FALSE; // If the radio tower is destroyed
br_blow_up_radio_tower = FALSE; // Use for AI who blow up Radio Tower
br_randomly_find_zone = FALSE; // Finds a random position on the map intead of using markers
br_radio_tower_enabled = TRUE;
br_zone_taken = TRUE; // If the zone is taken.. start off at true
br_first_Zone = TRUE; // If it's the first zone
br_HQ_taken = FALSE; // If the HQ is taken
br_current_zone = nil; // Current selected zone
br_current_sides = [];
br_max_current_sides = 1;
br_global_timer = 0;  // Seconds since mission started
br_next_zone_start_delay = 20; // Delay between zones
br_queue_squads_distance = 2000; // When new zone is over this amount queue group in evacs
br_max_garrisons = 5;

// Below units are in-order below given the _sides and _unitTypes positions 
br_units = [[[ // EAST
	"OI_reconPatrol",
	"OI_reconSentry",
	"OI_reconTeam",
	"OI_SniperTeam",
	"OIA_InfAssault",
	"OIA_InfSentry",
	"OIA_InfSquad",
	"OIA_InfSquad_Weapons",
	"OIA_InfTeam",
	"OIA_InfTeam_AA",
	"OIA_InfTeam_AT",
	"OIA_ReconSquad"
],[
	"OIA_SPGPlatoon_Scorcher",
	"OIA_SPGSection_Scorcher",
	"OIA_TankPlatoon",
	"OIA_TankPlatoon_AA",
	"OIA_TankSection"
],[
	"OIA_MotInf_AA",
	"OIA_MotInf_AT",
	"OIA_MotInf_GMGTeam",
	"OIA_MotInf_MGTeam",
	"OIA_MotInf_MortTeam",
	"OIA_MotInf_Team"
], [
	"OIA_MechInf_AA",
	"OIA_MechInf_AT",
	"OIA_MechInf_Support",
	"OIA_MechInfSquad"
], [
	"OI_AttackTeam_UAV",
	"OI_AttackTeam_UGV",
	"OI_diverTeam",
	"OI_diverTeam_Boat",
	"OI_diverTeam_SDV",
	"OI_ReconTeam_UAV",
	"OI_ReconTeam_UGV",
	"OI_SmallTeam_UAV"
]], 
[[ // WEST
	"BUS_InfSentry",
	"BUS_InfSquad",
	"BUS_InfAssault",
	"BUS_InfSquad_Weapons",
	"BUS_InfTeam",
	"BUS_InfTeam_AA",
	"BUS_InfTeam_AT",
	"BUS_ReconPatrol",
	"BUS_ReconSentry",
	"BUS_ReconTeam",
	"BUS_ReconSquad",
	"BUS_SniperTeam"
],[
	"BUS_SPGPlatoon_Scorcher",
	"BUS_SPGSection_MLRS",
	"BUS_SPGSection_Scorcher",
	"BUS_TankPlatoon",
	"BUS_TankPlatoon_AA",
	"BUS_TankSection"
],[
	"BUS_MotInf_AA",
	"BUS_MotInf_AT",
	"BUS_MotInf_GMGTeam",
	"BUS_MotInf_MGTeam",
	"BUS_MotInf_MortTeam",
	"BUS_MotInf_Team"
], [
	"BUS_MechInf_AA",
	"BUS_MechInf_AT",
	"BUS_MechInf_Support",
	"BUS_MechInfSquad"
], [
	"BUS_AttackTeam_UAV",
	"BUS_AttackTeam_UGV",
	"BUS_diverTeam",
	"BUS_diverTeam_Boat",
	"BUS_diverTeam_SDV",
	"BUS_ReconTeam_UAV",
	"BUS_ReconTeam_UGV",
	"BUS_SmallTeam_UAV"
]]];

// The type of speical units that can spawn
br_enemy_speical_list = [
	"O_Heli_Light_02_dynamicLoadout_F",
	"I_LT_01_AT_F",
	"O_Plane_CAS_02_dynamicLoadout_F",
	"O_Truck_02_box_F",
	"O_APC_Tracked_02_AA_F",
	"O_MBT_02_cannon_F",
	"O_Heli_Attack_02_F",
	"O_G_Offroad_01_armed_F",
	"O_MRAP_02_gmg_F",
	"O_Truck_02_medical_F",
	"O_Truck_02_fuel_F",
	"O_static_AT_F",
	"O_static_AA_F",
	"O_T_LSV_02_armed_F",
	"I_GMG_01_high_F",
	"I_HMG_01_A_F",
	"I_HMG_01_high_F",
	"I_HMG_01_F",
	"I_G_Offroad_01_repair_F",
	"I_MRAP_03_F",
	"I_Heli_light_03_F",
	"O_Quadbike_01_F",
	"O_G_Van_01_transport_F",
	"O_APC_Wheeled_02_rcws_F",
	"O_UAV_01_F",
	"O_UGV_01_rcws_F",
	"O_Heli_Transport_04_box_F",
	"O_Mortar_01_F",
	"O_G_Mortar_01_F",
	"O_UAV_02_F",
	"O_UAV_02_CAS_F",
	"O_UGV_01_F",
	"O_Truck_03_transport_F",
	"O_Truck_03_ammo_F",
	"O_Truck_03_device_F",
	"O_Static_Designator_02_F",
	"O_T_UAV_04_CAS_F",
	"O_Plane_Fighter_02_F",
	"O_Plane_CAS_02_Cluster_F",
	"O_Plane_Fighter_02_Cluster_F",
	"O_MBT_04_cannon_F",
	"O_T_MBT_04_cannon_F",
	"O_MBT_04_command_F",
	"O_T_MBT_04_command_F",
	"O_Radar_System_02_F",
	"O_SAM_System_04_F",
	"O_Plane_Fighter_02_Stealth_F",
	"I_MRAP_03_gmg_F",
	"I_MRAP_03_hmg_F",
	"C_Kart_01_yellow_F",
	"O_T_VTOL_02_infantry_F"
];

// The list of things that have a chance to spawn
br_friendly_vehicles_list = [
	"B_MRAP_01_gmg_F",
	"B_MRAP_01_hmg_F",
	"B_G_Offroad_01_armed_F",
	"B_MBT_01_cannon_F",
	"B_APC_Tracked_01_AA_F",
	"B_UGV_01_rcws_F",
	"B_APC_Tracked_01_CRV_F",
	"B_Truck_01_medical_F",
	"B_Truck_01_fuel_F",
	"B_Truck_01_ammo_F",
	"B_Truck_01_Repair_F",
	"B_APC_Wheeled_01_cannon_F",
	"B_MBT_01_TUSK_F",
	"B_APC_Wheeled_03_cannon_F",
	"B_T_LSV_01_armed_F",
	"B_T_LSV_01_armed_CTRG_F",
	"B_LSV_01_armed_F",
	"B_LSV_01_AT_F",
	"B_LSV_01_armed_black_F",
	"B_T_LSV_01_armed_black_F",
	"B_T_MRAP_01_gmg_F",
	"B_T_MRAP_01_hmg_F",
	"B_T_UAV_03_F",
	"B_G_Quadbike_01_F",
	"B_Heli_Light_01_armed_F",
	"I_APC_tracked_03_cannon_F",
	"I_LT_01_cannon_F",
	"I_LT_01_AA_F",
	"I_LT_01_scout_F",
	"I_LT_01_AT_F",
	"C_Kart_01_Red_F",
	"B_AFV_Wheeled_01_cannon_F",
	"B_T_AFV_Wheeled_01_cannon_F",
	"B_AFV_Wheeled_01_up_cannon_F",
	"B_T_AFV_Wheeled_01_up_cannon_F",
	"B_APC_Tracked_01_AA_F",
	"B_APC_Tracked_01_rcws_F",
	"B_Heli_Attack_01_F",
	"B_UGV_01_F"
];

// Types of jeys that can spawn
br_friendly_jets_list = [
	"B_Plane_CAS_01_F",
	"B_UAV_02_F",
	"B_UAV_02_CAS_F",
	"B_T_VTOL_01_armed_F",
	"B_Plane_Fighter_01_F",
	"B_UAV_05_F",
	"B_Plane_Fighter_01_Stealth_F",
	"B_Plane_CAS_01_Cluster_F",
	"I_Plane_Fighter_04_F",
	"O_Plane_CAS_02_F",
	"O_T_UAV_04_CAS_F",
	"O_T_VTOL_02_infantry_F",
	"O_Plane_Fighter_02_F"
];

// Type of transport helicopters that can spawn
br_heli_units = [
	"B_Heli_Transport_03_F",
	"B_Heli_Transport_03_unarmed_F",
	"B_Heli_Transport_03_black_F",
	"B_Heli_Transport_03_unarmed_green_F",
	"B_CTRG_Heli_Transport_01_sand_F",
	"B_CTRG_Heli_Transport_01_tropic_F",
	"B_Heli_Light_01_F",
	"B_Heli_Transport_01_F",
	"B_Heli_Transport_01_camo_F",
	"I_Heli_Transport_02_F",
	"I_Heli_light_03_unarmed_F",
	"O_Heli_Light_02_v2_F",
	"O_Heli_Transport_04_bench_F",
	"O_Heli_Transport_04_covered_F"
];

br_compositions_bases = [
	// Base_01
	[["Land_PaperBox_open_empty_F",[-3.54883,-1.07813,0.00102806],0],["CamoNet_BLUFOR_open_F",[-3.44531,-2.00391,-0.0343361],270.131],["Land_PaperBox_open_full_F",[-3.54883,-3.08789,0.00146484],0],["Land_Pallet_MilBoxes_F",[-2.90918,-5.08203,-0.00928497],0],["Land_PaperBox_closed_F",[-5.53516,-2.06641,-0.000469208],0],["Land_Cargo_House_V1_F",[0.5,11.9277,-0.00151062],0],["Land_Cargo_House_V1_F",[-6.5,11.9277,-0.00151062],0],["Land_Cargo_HQ_V1_F",[11.6982,-5.40234,0.00348854],0],["Land_Medevac_house_V1_F",[-13.6914,9.14063,-0.00151062],315],["Land_HBarrier_Big_F",[2.90723,-15.8984,0.0026474],0],["Land_HBarrier_Big_F",[-1.99219,17.834,0.000629425],0],["Land_Cargo_Patrol_V1_F",[-17.2471,-7.54883,-0.00151062],90],["Land_HBarrier_Big_F",[-8.16797,-16.5,-0.00100136],225.003],["Land_HBarrier_Big_F",[6.93262,18.0859,0.00233269],0],["Land_HBarrier_Big_F",[11.9346,-15.6582,0.00165939],0],["Land_HBarrier_Big_F",[-16.2871,-13.3887,-0.00100708],0],["Land_HBarrier_Big_F",[-11.084,17.8242,0.00461006],0],["Land_HBarrier_Big_F",[17.1006,14.5059,0.000671387],225.01],["Land_HBarrier_Big_F",[-21.5693,5.97852,-0.0024929],89.9967],["Land_HBarrier_Big_F",[-21.1738,-8.02148,0.00804138],90.0232],["Land_HBarrier_Big_F",[22.3535,3.52734,0.00663757],89.89],["Land_HBarrier_Big_F",[-18.5869,13.9844,-0.00123978],135.055],["Land_HBarrier_Big_F",[22.8516,-5.5293,0.00448227],90.0334],["Land_HBarrier_Big_F",[19.9912,-13.6348,-0.00193977],315.017],["",[-15.917,-31.4043,2.3593],245.983],["",[-11.7168,-42.5605,2.79577],126.083],["",[-11.4941,-45.7695,2.83932],116.986],["",[-9.34668,-46.4648,2.48515],193.149],["",[-69.0127,-24.1426,2.62043],349.115],["",[72.7109,20.6543,2.45148],119.947],["",[-54.0752,53.2266,2.86946],243.014],["",[74.2412,18.75,2.89328],178.103],["",[63.416,43.3281,2.52508],163.998],["",[62.5381,45.5098,2.61116],123.016],["",[73.9102,25.3145,-0.415133],243.877],["",[70.9707,32.9902,0.329839],63.7402],["",[67.0674,40.6035,-0.424313],59.4398],["",[60.333,51.4805,2.30022],269.001],["",[78.8633,10.3867,2.42844],169.418],["",[62.9453,49.0645,2.54101],344.984],["",[80.6865,7.1543,2.75874],41.8453],["",[81.7549,4.38672,2.64272],120.122],["",[83.252,2.45117,2.89287],13],["",[86.1016,-0.265625,2.49191],7.12479],["",[88.6875,-9.32227,2.47489],247.028],["",[-81.2256,-40.9414,1.77391],294.035],["",[47.5449,77.9121,2.57366],230.056],["",[46.918,78.9961,2.75755],106.021],["",[-19.6553,-92.7109,1.95472],177.157],["",[46.4102,82.7559,2.701],35.0111],["",[-21.415,-92.8848,2.37008],25.0698],["",[-90.0615,-38.668,1.8935],234.147],["",[46.1982,86.5645,2.75042],351.969],["",[-91.1377,-37.5,1.80324],263.009],["",[41.5127,90.7363,2.61086],118.015]],
	// Base_02
	[["Land_Wreck_BRDM2_F",[-3.04199,-0.162109,-0.0366125],135.067],["Land_Cargo_HQ_V1_F",[9.77344,-3.8457,-0.00167942],90],["Land_Cargo_House_V1_F",[-2,11.9277,0.0203733],0],["Land_Cargo_House_V1_F",[5,11.9277,-0.00167942],0],["Land_Bulldozer_01_wreck_F",[-12.0293,-1.07813,-0.0011282],45.0099],["Land_HBarrier_Big_F",[3.90723,-14.1387,0.00186062],0],["Land_HBarrier_Big_F",[-4.03711,-14.1113,-0.00287914],0],["Land_Cargo_House_V1_F",[12,11.9277,-0.00167942],0],["Land_Cargo_Patrol_V1_F",[-12.8799,11.832,-0.00167942],135],["Land_HBarrier_Big_F",[17.0615,-2.08789,-0.00287724],270.001],["Land_HBarrier_Big_F",[2.50781,16.834,0.000460625],0],["Land_Cargo_Patrol_V1_F",[-13.8838,-10.9297,-0.00167942],45],["Land_HBarrier_Big_F",[-16.0693,6.95313,-0.00299549],89.9845],["Land_HBarrier_Big_F",[11.6807,-13.9277,0.00369549],0],["Land_HBarrier_Big_F",[-6.58398,16.8242,0.00444126],0],["Land_HBarrier_Big_F",[-11.7871,-14.3887,-0.00117588],0],["Land_HBarrier_Big_F",[-13.0273,14.043,-0.00101185],135.001],["Land_HBarrier_Big_F",[17.0771,-10.0703,-0.00236034],269.997],["Land_HBarrier_Big_F",[-17.1738,-11.0215,0.00787449],90.0232],["Land_HBarrier_Big_F",[11.4326,17.0859,0.00216389],0],["Land_HBarrier_Big_F",[17.1006,13.9355,-0.000788689],270.016],["",[-11.417,-32.4043,2.35913],245.983],["",[-7.2168,-43.5605,2.7956],126.083],["",[-6.99414,-46.7695,2.83915],116.986],["",[-4.84668,-47.4648,2.48498],193.149],["",[-64.5127,-25.1426,2.62027],349.115],["",[-49.5752,52.2266,2.86929],243.014],["",[77.2109,19.6543,2.45131],119.947],["",[67.916,42.3281,2.52491],163.998],["",[67.0381,44.5098,2.61099],123.016],["",[78.7412,17.75,2.89311],178.103],["",[71.5674,39.6035,-0.424481],59.4398],["",[75.4707,31.9902,0.32967],63.7402],["",[78.4102,24.3145,-0.415302],243.877],["",[64.833,50.4805,2.30005],269.001],["",[67.4453,48.0645,2.54084],344.984],["",[83.3633,9.38672,2.42827],169.418],["",[85.1865,6.1543,2.75857],41.8453],["",[86.2549,3.38672,2.64255],120.122],["",[-76.7256,-41.9414,1.77374],294.035],["",[87.752,1.45117,2.8927],13],["",[90.6016,-1.26563,2.49174],7.12479],["",[52.0449,76.9121,2.57349],230.056],["",[51.418,77.9961,2.75738],106.021],["",[93.1875,-10.3223,2.47472],247.028],["",[-85.5615,-39.668,1.89333],234.147],["",[-86.6377,-38.5,1.80307],263.009],["",[-15.1553,-93.7109,1.95455],177.157],["",[-16.915,-93.8848,2.36992],25.0698],["",[50.9102,81.7559,2.70083],35.0111],["",[50.6982,85.5645,2.75025],351.969]],
	// Base 03
	[["Land_ScrapHeap_2_F",[-0.551758,-2.11914,0.00587463],310.547],["Land_HBarrier_5_F",[-2.45801,2.52344,-0.131306],134.863],["Land_Garbage_square5_F",[-1.08008,-4.82813,0.00265503],160.013],["Land_GarbageBarrel_01_F",[2.13184,-4.36719,-0.00654411],335.473],["Land_ScrapHeap_1_F",[-4.91797,-6.38086,-0.00376892],130.652],["Land_HBarrier_5_F",[-6.32031,-1.40039,0.0020752],134.807],["Land_Loudspeakers_F",[-6.83887,5.10156,-0.00486755],136.827],["Land_HBarrier_5_F",[5.24316,10.2832,-0.112869],135.163],["Land_CratesShabby_F",[8.37402,-5.11523,-0.00529289],26.8406],["Land_Pallets_stack_F",[9.27539,-3.85742,-0.00653458],269.485],["Land_GarbageBags_F",[2.0918,12.5645,-0.0400238],166.6],["Land_JunkPile_F",[11.3789,-3.96094,-0.0098772],135.794],["MetalBarrel_burning_F",[-4.54004,12.0996,-0.00577927],154.21],["Land_Garbage_square5_F",[-4.79004,12.5645,-0.00670815],84.5348],["Land_HBarrier_5_F",[6.38965,11.1152,-0.0281086],227.123],["Land_HBarrier_5_F",[-10.2119,-5.33203,0.0645638],134.809],["Land_Cargo_HQ_V2_F",[-13.1377,2.82422,-0.0057354],135.541],["Land_HBarrier_5_F",[16.8906,0.265625,0.006567],227.054],["Land_HBarrier_5_F",[16.0693,7.35938,0.00713348],135.668],["Land_Garbage_square5_F",[8.69531,13.248,-0.0128937],136.806],["Land_HBarrier_5_F",[-11.209,-12.4609,0.000621796],225.024],["Land_HBarrier_3_F",[16.876,-2.09961,0.00662804],271.487],["Land_HBarrier_5_F",[5.63867,18.2266,0.0797901],135.648],["Land_HBarrier_5_F",[-7.24707,-16.4688,0.0135269],225.024],["Land_HBarrier_5_F",[12.998,-11.5098,-0.103704],134.817],["Land_HBarrier_5_F",[16.8447,-3.01367,-0.00771332],88.7651],["Land_HBarrier_5_F",[1.66113,16.1816,-0.00832939],227.077],["Land_HBarrier_5_F",[16.9131,-7.63086,0.0516663],134.81],["Land_HBarrier_5_F",[-18.3135,-5.29688,0.0772877],45.6531],["Land_HBarrier_5_F",[9.03418,-15.4238,-0.0925503],134.843],["Land_Cargo_Patrol_V2_F",[7.77246,17.8379,-0.0057373],226.92],["Land_HBarrier_5_F",[8.32813,-16.2363,-0.0998363],134.843],["Land_Cargo_Patrol_V2_F",[1.2666,-19.8164,-0.0057354],351.833],["Land_HBarrier_5_F",[-3.30957,-20.4004,-0.031023],225.028],["Land_HBarrier_3_F",[-4.00293,19.4355,0.0320492],355.001],["Land_HBarrier_3_F",[10.793,15.5234,0.035759],317.504],["Land_HBarrier_3_F",[2.42285,-19.877,0.0158653],353.418],["Land_HBarrier_5_F",[-13.8096,14.459,-0.0753403],134.778],["Land_HBarrier_5_F",[1.47559,-19.9238,-0.00323296],170.71],["Land_HBarrier_5_F",[-4.89746,19.3711,-0.0340176],172.289],["Land_HBarrier_5_F",[-9.8252,18.5059,-0.0333271],134.786],["Land_HBarrier_5_F",[-22.1719,-1.28125,0.0772877],45.6531],["Land_HBarrier_5_F",[20.0957,11.3438,0.0303345],135.669],["Land_HBarrier_5_F",[-17.6787,10.6309,0.0641289],134.781],["Land_HBarrier_5_F",[9.6582,22.1641,0.0154819],135.651],["Land_HBarrier_5_F",[13.5527,17.8438,0.009058],227.067],["Land_Sign_WarningMilitaryArea_F",[13.7666,19.4063,-0.00517845],227.32],["Land_HBarrier_5_F",[-21.6904,6.64453,-0.137802],134.838],["Land_HBarrier_5_F",[-25.8486,2.66016,-0.0166302],45.6821],["",[-11.417,-32.4043,2.35508],245.983],["",[-7.2168,-43.5605,2.79154],126.083],["",[-6.99414,-46.7695,2.8351],116.986],["",[-4.84668,-47.4648,2.48093],193.149],["",[-64.5127,-25.1426,2.61621],349.115],["",[-49.5752,52.2266,2.86524],243.014],["",[77.2109,19.6543,2.44725],119.947],["",[67.916,42.3281,2.52085],163.998],["",[67.0381,44.5098,2.60693],123.016],["",[78.7412,17.75,2.88906],178.103],["",[71.5674,39.6035,-0.428537],59.4398],["",[75.4707,31.9902,0.325614],63.7402],["",[78.4102,24.3145,-0.419358],243.877],["",[64.833,50.4805,2.296],269.001],["",[67.4453,48.0645,2.53679],344.984],["",[83.3633,9.38672,2.42421],169.418],["",[85.1865,6.1543,2.75452],41.8453],["",[86.2549,3.38672,2.6385],120.122],["",[-76.7256,-41.9414,1.76968],294.035],["",[87.752,1.45117,2.88864],13],["",[90.6016,-1.26563,2.48768],7.12479],["",[52.0449,76.9121,2.56943],230.056],["",[51.418,77.9961,2.75333],106.021],["",[93.1875,-10.3223,2.47066],247.028],["",[-85.5615,-39.668,1.88928],234.147],["",[-86.6377,-38.5,1.79902],263.009],["",[-15.1553,-93.7109,1.9505],177.157],["",[-16.915,-93.8848,2.36586],25.0698],["",[50.9102,81.7559,2.69677],35.0111],["",[50.6982,85.5645,2.74619],351.969]],
	// Base 04
	[["Land_ToiletBox_F",[-3.92676,2.37305,0.00161362],268.572],["Land_PortableLight_double_F",[-1.14844,4.17773,-0.0924358],271.052],["Land_HBarrierBig_F",[7.2959,-4.08203,0.0143719],91.0157],["Land_HBarrierBig_F",[7.20313,4.47656,0.0142212],91.0346],["Land_HBarrierBig_F",[-7.95215,-4.35156,0.0162029],89.2291],["Land_HBarrierBig_F",[-8.32715,3.94336,0.0153427],90.023],["Land_HBarrier_5_F",[7.97266,-9.12109,0.0421352],178.314],["Land_PortableLight_double_F",[-3.60156,-4.09961,-0.261477],88.9744],["Land_HBarrier_5_F",[7.49805,9.68555,0.0763283],179.126],["Land_WaterTank_F",[11.0605,1.54492,-0.000587463],359.445],["Land_HBarrier_5_F",[-4.27832,9.12109,0.00864029],178.493],["Land_HBarrier_5_F",[-3.44336,-9.59375,0.0788002],178.861],["Land_WaterTank_F",[11.1895,-1.28711,0.00101089],359.424],["Land_Cargo_Tower_V1_F",[-1.61133,0.236328,-0.00147438],268.844],["Land_Pallets_stack_F",[-16.4326,1.87109,-0.000646591],263.829],["Land_Pallets_stack_F",[-16.4521,4.26172,-0.00127602],225.142],["Land_PaperBox_closed_F",[-7.67285,-15.8477,0.0141735],270.027],["Land_HBarrier_3_F",[15.9932,7.25195,0.0548115],244.721],["Land_HBarrier_3_F",[14.4365,-13.1582,0.0680962],129.291],["Land_PaperBox_closed_F",[-8.8584,-17.6309,0.0134602],300.469],["Land_HBarrier_3_F",[-2.31543,20.252,-0.0132465],357.596],["Land_HBarrier_3_F",[-20.0244,5.83203,0.0384693],298.347],["Land_HBarrier_3_F",[-14.3877,-16.2344,0.0368099],230.164],["Land_HBarrierBig_F",[25.4775,-5.54688,0.0122032],274.343],["Land_HBarrierBig_F",[27.2383,2.83203,0.0130329],292.294],["Land_HBarrierBig_F",[10.8164,-27.0371,0.0119648],178.689],["Land_HBarrierBig_F",[17.6045,23.4727,0.0151997],209.017],["Land_HBarrierBig_F",[-9.62988,-28.1836,0.0105667],181.952],["Land_HBarrierBig_F",[10.6729,28.5664,0.0142174],226.952],["Land_HBarrier_3_F",[27.1445,13.7129,-0.0267658],244.546],["Land_HBarrier_3_F",[22.792,-20.2891,0.0170746],129.254],["Land_HBarrierBig_F",[-14.3936,27.2969,0.012991],135.98],["Land_HBarrierBig_F",[-21.5137,22.3242,0.0103493],158.782],["Land_HBarrierBig_F",[-29.9932,-9.92383,0.0118065],260.948],["Land_HBarrierBig_F",[-32.7012,-1.74023,0.0121059],246.765],["Land_HBarrier_3_F",[-2.62109,33.1094,-0.0215597],357.597],["Land_HBarrier_3_F",[-22.9082,-24.4043,0.0279102],230.159],["Land_Razorwire_F",[33.5869,-3.75391,-0.270882],279.57],["Land_HBarrier_3_F",[-32.6025,11.0137,0.0304337],298.372],["Land_Razorwire_F",[28.1221,-23.4453,0.0726814],130.773],["Land_Razorwire_F",[20.0879,31.1348,0.316656],214.373],["Land_Razorwire_F",[12.5742,-35.7734,-0.067831],175.732],["Land_Razorwire_F",[32.2715,19.4375,0.104],63.322],["Land_Razorwire_F",[-7.66797,-37.4277,-0.123928],177.922],["Land_Razorwire_F",[-21.4102,32.7012,0.0681944],142.911],["Land_Razorwire_F",[-4.37793,39.9375,-0.183687],353.964],["Land_Razorwire_F",[-24.1865,-32.6484,-0.153818],212.611],["Land_Razorwire_F",[-39.9189,-10.543,0.270908],251.497],["Land_Razorwire_F",[-40.7246,13.3887,0.162291],298.818],["",[-56.5752,21.2266,2.8695],243.014],["",[57.833,19.4805,2.30026],269.001],["",[60.0381,13.5098,2.61119],123.016],["",[60.916,11.3281,2.52511],163.998],["",[60.4453,17.0645,2.54105],344.984],["",[45.0449,45.9121,2.57369],230.056],["",[44.418,46.9961,2.75759],106.021],["",[64.5674,8.60352,-0.424276],59.4398],["",[-18.417,-63.4043,2.35934],245.983],["",[43.9102,50.7559,2.70103],35.0111],["",[68.4707,0.990234,0.329875],63.7402],["",[43.6982,54.5645,2.75046],351.969],["",[39.0127,58.7363,2.6109],118.015],["",[70.2109,-11.3457,2.45152],119.947],["",[41.4004,57.9375,2.88793],315.934],["",[71.4102,-6.68555,-0.415097],243.877],["",[71.7412,-13.25,2.89332],178.103],["",[35.6475,66.9844,2.5379],149.096],["",[-14.2168,-74.5605,2.7958],126.083],["",[34.7656,70.9414,-0.419265],240.738],["",[-13.9941,-77.7695,2.83936],116.986],["",[-11.8467,-78.4648,2.48519],193.149],["",[76.3633,-21.6133,2.42847],169.418],["",[78.1865,-24.8457,2.75878],41.8453],["",[79.2549,-27.6133,2.64276],120.122],["",[31.4844,78.5645,0.247616],62.9452],["",[80.752,-29.5488,2.8929],13],["",[83.6016,-32.2656,2.49194],7.12479],["",[27.8604,85.7031,-0.414474],62.4049],["",[-71.5127,-56.1426,2.62047],349.115],["",[86.1875,-41.3223,2.47493],247.028]],
	// Base 05
	[["Land_HBarrier_5_F",[5.22559,-10.9766,-0.140451],224.2],["Land_WaterBarrel_F",[-7.91602,-6.47461,-2.67029e-005],189.665],["Land_MetalBarrel_F",[-7.77148,-7.54492,-0.00041008],297.432],["Land_HBarrier_5_F",[-1.94238,8.65039,-0.0261307],228.78],["Land_HBarrier_5_F",[-12.3545,-4.96094,0.0232162],0.823456],["Land_BarrelTrash_grey_F",[-8.20508,-8.14844,-0.000423431],6.95267],["Land_BarrelEmpty_grey_F",[-8.93555,-7.97852,-0.00043869],0.839752],["Land_HBarrier_5_F",[8.7002,6.50977,0.117586],0.564545],["Land_Cargo20_military_green_F",[13.6016,3.09375,0.00745964],180.634],["Land_Cargo20_military_green_F",[14.166,-5.55664,0.00149155],133.007],["Land_HBarrier_5_F",[5.06641,-16.6758,-0.170187],272.084],["Land_HBarrier_5_F",[-4.84082,13.3164,-0.164545],270.207],["Land_Pallets_F",[14.4248,8.19336,-0.00226688],354.878],["Land_HBarrierBig_F",[-17.3564,-4.92773,0.00527382],0.822693],["Land_WaterTank_F",[-17.3135,-8.34961,0.00030899],358.843],["Land_HBarrierBig_F",[18.2178,6.77539,0.00637245],178.681],["Land_WaterTank_F",[-17.3867,-11.6133,-0.000541687],358.841],["Land_PaperBox_closed_F",[-21.0977,0.0625,0.000276566],126.382],["Land_ToiletBox_F",[18.9521,10.4414,0.00335503],90.3875],["Land_Cargo20_military_green_F",[18.1182,-12.4355,0.0390606],20.6411],["Land_Pallets_stack_F",[-22.1309,1.96289,0.00456429],0.820618],["Land_PaperBox_closed_F",[-22.1729,-2.6875,0.000688553],274.657],["Land_PortableLight_double_F",[-14.5713,-17.2637,0.00505066],241.444],["Land_HBarrier_5_F",[-4.17871,-24.5137,0.0261841],272.07],["Land_ToiletBox_F",[18.9287,12.6523,0.00879478],90.3398],["Land_BagBunker_Large_F",[9.02051,-22.0391,0.00726128],0.821899],["Land_Cargo_Patrol_V1_F",[-9.65918,-22.7266,-0.00812721],0.104889],["Land_BagBunker_Large_F",[-8.77832,22.8945,-0.00780296],178.683],["Land_HBarrier_5_F",[4.30371,25.8477,-0.120178],90.1511],["Land_HBarrierBig_F",[-22.6064,-8.06836,-0.00182915],272.355],["Land_HBarrierBig_F",[-19.1572,-15.3242,-0.000331879],217.583],["Land_HBarrierBig_F",[23.3369,10.1133,0.000427246],90.245],["Land_Cargo_Patrol_V1_F",[9.94824,24.248,0.0186253],178.764],["Land_HBarrierBig_F",[17.8604,-18.5391,0.0038681],0.822876],["Land_HBarrierBig_F",[-17.4951,19.0664,0.00564003],178.683],["Land_Cargo20_military_green_F",[25.6719,-3.86133,0.0409832],89.5551],["Land_HBarrierBig_F",[19.6162,17.2285,-0.00188637],35.4757],["Land_PortableLight_double_F",[-9.32129,-24.3242,0.00250244],0.822998],["Land_HBarrier_5_F",[-8.4873,-25.7813,-0.0514412],0.822876],["Land_HBarrierBig_F",[-15.5596,-22.3164,0.00411797],272.569],["Land_PortableLight_double_F",[9.46777,25.709,-0.00536346],178.683],["Land_PortableLight_double_F",[-23.8018,14.1602,0.00551224],314.869],["Land_HBarrier_5_F",[8.56934,27.3066,-0.00629807],178.683],["Land_HBarrier_5_F",[-14.0303,-25.7168,0.182226],0.820984],["Land_HBarrier_5_F",[-28.5137,-0.847656,0.0954304],272.941],["Land_HBarrier_5_F",[-24.3672,-11.4824,-0.0928059],183.776],["Land_HBarrierBig_F",[15.7744,24.0977,0.00742722],90.3444],["Land_HBarrier_5_F",[-28.6572,-6.49219,-0.0225201],271.387],["Land_HBarrier_5_F",[29.0576,1.65625,0.0503702],90.8217],["Land_HBarrierBig_F",[-28.1611,8.49805,-0.00207901],90.6102],["Land_HBarrierBig_F",[-25.1494,15.7129,0.00137329],136.36],["Land_HBarrier_5_F",[29.1807,7.27344,-0.0120487],90.797],["Land_HBarrier_5_F",[14.1553,27.4785,0.00863075],178.684],["Land_HBarrierBig_F",[25.6455,-15.4668,-0.00260162],318.467],["Land_HBarrierBig_F",[29.1025,-7.88867,-0.000631332],272.81],["Land_HBarrier_5_F",[25.0127,13.2305,0.217297],1.63885],["",[47.916,26.3281,2.52523],163.998],["",[47.0381,28.5098,2.61131],123.016],["",[44.833,34.4805,2.30037],269.001],["",[51.5674,23.6035,-0.424164],59.4398],["",[47.4453,32.0645,2.54116],344.984],["",[57.2109,3.6543,2.45163],119.947],["",[-31.417,-48.4043,2.35945],245.983],["",[55.4707,15.9902,0.329988],63.7402],["",[58.7412,1.75,2.89343],178.103],["",[58.4102,8.31445,-0.414985],243.877],["",[63.3633,-6.61328,2.42858],169.418],["",[-27.2168,-59.5605,2.79592],126.083],["",[65.1865,-9.8457,2.75889],41.8453],["",[66.2549,-12.6133,2.64287],120.122],["",[-24.8467,-63.4648,2.4853],193.149],["",[-26.9941,-62.7695,2.83947],116.986],["",[32.0449,60.9121,2.57381],230.056],["",[67.752,-14.5488,2.89302],13],["",[31.418,61.9961,2.7577],106.021],["",[30.9102,65.7559,2.70115],35.0111],["",[70.6016,-17.2656,2.49206],7.12479],["",[30.6982,69.5645,2.75057],351.969],["",[73.1875,-26.3223,2.47504],247.028],["",[26.0127,73.7363,2.61101],118.015],["",[28.4004,72.9375,2.88805],315.934],["",[-69.5752,36.2266,2.86961],243.014],["",[22.6475,81.9844,2.53802],149.096],["",[21.7656,85.9414,-0.419152],240.738],["",[-84.5127,-41.1426,2.62058],349.115],["",[18.4844,93.5645,0.247728],62.9452],["",[74.4512,-60.9902,2.01409],211.062]],
	// Base 06
	[["Land_Cargo_House_V1_F",[-7.39844,-2.14063,-0.041584],267.76],["Land_Cargo_House_V1_F",[6.27539,5.20703,0.0154552],87.6723],["Land_ToiletBox_F",[8.6875,0.349609,0.00214005],88.4595],["Land_GarbageBarrel_01_F",[8.26172,-3.54102,-0.00686455],164.087],["Land_ToiletBox_F",[8.78906,-2.20898,0.00855637],88.4094],["Land_PaperBox_closed_F",[-7.98242,5.22461,-0.000961304],69.6534],["Land_WaterTank_F",[-6.8457,-7.33398,0.000228882],358.428],["Land_PortableLight_double_F",[-4.33691,-8.92969,0.00204849],340.729],["Land_TTowerSmall_2_F",[5.52539,2.30273,-0.0273952],358.802],["Land_HBarrier_5_F",[10.7813,3.57813,0.117632],87.6331],["Land_PortableLight_double_F",[8.5791,-7.42969,-0.00489235],136.662],["Land_HBarrier_5_F",[7.20898,-10.1172,-0.10253],178.557],["Land_PaperBox_closed_F",[-9.91992,5.90039,-0.000875473],312.004],["Land_HBarrier_5_F",[11.2441,-6.51758,-0.0603428],267.491],["Land_HBarrier_5_F",[-3.78418,-10.4375,0.0731983],178.557],["Land_HBarrier_5_F",[-12.2051,3.53906,0.0660686],87.9712],["Land_HBarrier_5_F",[11.0811,-6.76953,0.0473347],135.876],["Land_Cargo_Patrol_V1_F",[-0.724609,12.8809,-0.0195713],178.651],["Land_HBarrier_5_F",[-11.8711,-6.56445,-0.0331516],268.18],["Land_HBarrier_5_F",[10.5254,9.1543,-0.114149],88.1381],["Land_HBarrier_5_F",[1.45996,13.1035,0.108351],178.556],["Land_HBarrier_5_F",[-8.5625,-10.4688,-0.0192261],227.108],["Land_HBarrier_5_F",[6.95703,13.2773,-0.0734062],178.556],["Land_HBarrier_5_F",[-12.4941,9.07422,-0.0630779],87.3079],["Land_HBarrier_5_F",[-8.59961,12.6973,-0.0211639],356.643],["Land_HBarrier_5_F",[7.21484,13.0664,-0.0502892],46.9642],["Land_HBarrier_1_F",[-9.36523,12.5098,0.00015831],48.1699],["Land_HBarrier_1_F",[-12.3477,9.73242,-0.000488281],42.7654],["Land_HBarrier_3_F",[2.83008,-16.9102,-0.0179882],358.802],["Land_HBarrier_3_F",[-5.84375,-17.2051,0.0816154],358.802],["Land_Razorwire_F",[17.9551,0.259766,-0.186394],265.378],["Land_HBarrier_1_F",[18.4512,-2.94141,0.00143623],173.375],["Land_Razorwire_F",[12.5645,-13.9746,0.414766],314.606],["Land_HBarrier_1_F",[-18.5898,-3.23438,-0.000867844],355.469],["Land_HBarrier_1_F",[17.6758,6.84766,-0.000944138],173.383],["Land_Razorwire_F",[-19.0098,-0.197266,-0.127333],265.389],["Land_HBarrier_1_F",[10.3965,-16.3086,0.000324249],224.658],["Land_HBarrier_1_F",[17.166,-9.41602,0.00131607],224.539],["Land_Razorwire_F",[-13.3145,-14.7129,-0.0266418],226.576],["Land_HBarrier_1_F",[-17.627,-9.76367,-0.000732422],318.374],["Land_HBarrier_1_F",[-10.8633,-17.043,0.000484467],318.35],["Land_HBarrier_3_F",[-17.0293,10.9688,0.026001],305.422],["Land_HBarrier_1_F",[-19.4668,6.18945,-0.00028038],355.467],["Land_HBarrier_3_F",[-12.5293,16.2051,0.0167198],324.758],["Land_Razorwire_F",[0.458984,20.8301,0.0660839],177.219],["Land_Razorwire_F",[14.4668,15.293,0.0855465],226.448],["Land_HBarrier_1_F",[16.8789,13.2188,-0.000432968],137.684],["Land_HBarrier_1_F",[-5.97461,20.6172,0.000370026],86.8875],["Land_HBarrier_1_F",[3.66406,21.1641,-0.000595093],86.9325],["Land_HBarrier_1_F",[10.1289,20.0547,-0.000684738],137.674],["",[50.833,18.4805,2.3005],269.001],["",[53.0381,12.5098,2.61143],123.016],["",[53.916,10.3281,2.52535],163.998],["",[53.4453,16.0645,2.54128],344.984],["",[57.5674,7.60352,-0.42404],59.4398],["",[38.0449,44.9121,2.57393],230.056],["",[37.418,45.9961,2.75783],106.021],["",[61.4707,-0.00976563,0.330112],63.7402],["",[36.9102,49.7559,2.70127],35.0111],["",[63.2109,-12.3457,2.45175],119.947],["",[64.4102,-7.68555,-0.414861],243.877],["",[36.6982,53.5645,2.75069],351.969],["",[32.0127,57.7363,2.61113],118.015],["",[64.7412,-14.25,2.89355],178.103],["",[34.4004,56.9375,2.88817],315.934],["",[-63.5752,20.2266,2.86973],243.014],["",[-25.417,-64.4043,2.35957],245.983],["",[28.6475,65.9844,2.53814],149.096],["",[69.3633,-22.6133,2.42871],169.418],["",[27.7656,69.9414,-0.419028],240.738],["",[71.1865,-25.8457,2.75901],41.8453],["",[72.2549,-28.6133,2.64299],120.122],["",[-21.2168,-75.5605,2.79604],126.083],["",[73.752,-30.5488,2.89314],13],["",[24.4844,77.5645,0.247852],62.9452],["",[-20.9941,-78.7695,2.8396],116.986],["",[-18.8467,-79.4648,2.48543],193.149],["",[76.6016,-33.2656,2.49218],7.12479],["",[20.8604,84.7031,-0.414237],62.4049],["",[79.1875,-42.3223,2.47516],247.028],["",[-78.5127,-57.1426,2.62071],349.115]]
];

br_composition_radio_towers = [
	[["Land_TTowerBig_1_F",[-2.07031,-0.623047,0.0295334],0],["",[-11.417,-32.4043,2.35913],245.983],["",[-7.2168,-43.5605,2.7956],126.083],["",[-6.99414,-46.7695,2.83916],116.986],["",[-4.84668,-47.4648,2.48499],193.149],["",[-64.5127,-25.1426,2.62027],349.115],["",[-49.5752,52.2266,2.86929],243.014],["",[77.2109,19.6543,2.45131],119.947],["",[67.916,42.3281,2.52491],163.998],["",[67.0381,44.5098,2.61099],123.016],["",[78.7412,17.75,2.89311],178.103],["",[71.5674,39.6035,-0.42448],59.4398],["",[75.4707,31.9902,0.329671],63.7402],["",[78.4102,24.3145,-0.415301],243.877],["",[64.833,50.4805,2.30005],269.001],["",[67.4453,48.0645,2.54084],344.984],["",[83.3633,9.38672,2.42827],169.418],["",[85.1865,6.1543,2.75857],41.8453],["",[86.2549,3.38672,2.64255],120.122],["",[-76.7256,-41.9414,1.77374],294.035],["",[87.752,1.45117,2.8927],13],["",[90.6016,-1.26563,2.49174],7.12479],["",[52.0449,76.9121,2.57349],230.056],["",[51.418,77.9961,2.75739],106.021],["",[93.1875,-10.3223,2.47472],247.028],["",[-85.5615,-39.668,1.89334],234.147],["",[-86.6377,-38.5,1.80307],263.009],["",[-15.1553,-93.7109,1.95455],177.157],["",[-16.915,-93.8848,2.36992],25.0698],["",[50.9102,81.7559,2.70083],35.0111],["",[50.6982,85.5645,2.75025],351.969]],
	[["Land_TTowerBig_2_F",[-2.07031,-0.623047,0.0295334],0],["",[-11.417,-32.4043,2.35913],245.983],["",[-7.2168,-43.5605,2.7956],126.083],["",[-6.99414,-46.7695,2.83916],116.986],["",[-4.84668,-47.4648,2.48499],193.149],["",[-64.5127,-25.1426,2.62027],349.115],["",[-49.5752,52.2266,2.86929],243.014],["",[77.2109,19.6543,2.45131],119.947],["",[67.916,42.3281,2.52491],163.998],["",[67.0381,44.5098,2.61099],123.016],["",[78.7412,17.75,2.89311],178.103],["",[71.5674,39.6035,-0.42448],59.4398],["",[75.4707,31.9902,0.329671],63.7402],["",[78.4102,24.3145,-0.415301],243.877],["",[64.833,50.4805,2.30005],269.001],["",[67.4453,48.0645,2.54084],344.984],["",[83.3633,9.38672,2.42827],169.418],["",[85.1865,6.1543,2.75857],41.8453],["",[86.2549,3.38672,2.64255],120.122],["",[-76.7256,-41.9414,1.77374],294.035],["",[87.752,1.45117,2.8927],13],["",[90.6016,-1.26563,2.49174],7.12479],["",[52.0449,76.9121,2.57349],230.056],["",[51.418,77.9961,2.75739],106.021],["",[93.1875,-10.3223,2.47472],247.028],["",[-85.5615,-39.668,1.89334],234.147],["",[-86.6377,-38.5,1.80307],263.009],["",[-15.1553,-93.7109,1.95455],177.157],["",[-16.915,-93.8848,2.36992],25.0698],["",[50.9102,81.7559,2.70083],35.0111],["",[50.6982,85.5645,2.75025],351.969]],
	[["Land_Communication_F",[-2.07031,-0.623047,0.0295334],0],["",[-11.417,-32.4043,2.35913],245.983],["",[-7.2168,-43.5605,2.7956],126.083],["",[-6.99414,-46.7695,2.83916],116.986],["",[-4.84668,-47.4648,2.48499],193.149],["",[-64.5127,-25.1426,2.62027],349.115],["",[-49.5752,52.2266,2.86929],243.014],["",[77.2109,19.6543,2.45131],119.947],["",[67.916,42.3281,2.52491],163.998],["",[67.0381,44.5098,2.61099],123.016],["",[78.7412,17.75,2.89311],178.103],["",[71.5674,39.6035,-0.42448],59.4398],["",[75.4707,31.9902,0.329671],63.7402],["",[78.4102,24.3145,-0.415301],243.877],["",[64.833,50.4805,2.30005],269.001],["",[67.4453,48.0645,2.54084],344.984],["",[83.3633,9.38672,2.42827],169.418],["",[85.1865,6.1543,2.75857],41.8453],["",[86.2549,3.38672,2.64255],120.122],["",[-76.7256,-41.9414,1.77374],294.035],["",[87.752,1.45117,2.8927],13],["",[90.6016,-1.26563,2.49174],7.12479],["",[52.0449,76.9121,2.57349],230.056],["",[51.418,77.9961,2.75739],106.021],["",[93.1875,-10.3223,2.47472],247.028],["",[-85.5615,-39.668,1.89334],234.147],["",[-86.6377,-38.5,1.80307],263.009],["",[-15.1553,-93.7109,1.95455],177.157],["",[-16.915,-93.8848,2.36992],25.0698],["",[50.9102,81.7559,2.70083],35.0111],["",[50.6982,85.5645,2.75025],351.969]]
];

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
	_group = _this select 0;
	{ deleteVehicle _x } forEach (units _group);
	deleteGroup _group;
};

// Delete all enemy AI
br_fnc_deleteAllAI = {
	// Delete existing units 
	{ [_x] call br_fnc_deleteGroups; } forEach br_ai_groups;
	{ [_x] call br_fnc_deleteGroups; } forEach br_special_ai_groups;
	br_ai_groups = [];
	br_special_ai_groups = [];
	br_enemy_vehicle_objects = [];
};

// Find all markers
// Runs once per mission
br_fnc_doChecks = {
	for "_i" from 0 to br_max_checks do {
		// Get marker prefixs
		_endString = Format ["zone_spawn_%1", _i];
		_endStringVeh = Format ["vehicle_spawn_%1", _i];
		_endStringHeli = Format ["helicopter_transport_%1", _i];
		_endStringHeliEvac = Format ["helicopter_evac_%1", _i];
		_endStringBombSquad = Format ["objective_squad_%1", _i];
		_endStringRecruit = Format ["recruit_%1", _i];
		_endStringJetSpawn = Format ["jet_spawn_%1", _i];
		// Check if markers exist
		if (getMarkerColor _endString != "") 
		then { br_zones append [getMarkerPos _endString]; };
		if ((getMarkerColor _endStringVeh != "") && {(br_enable_friendly_ai)}) 
		then { [_endStringVeh, br_friendly_vehicles_list] execVM "core\server\base\fn_createVehicle.sqf"; };
		if ((getMarkerColor _endStringJetSpawn != "") && {(br_enable_friendly_ai)}) 
		then { [_endStringJetSpawn, br_friendly_jets_list] execVM "core\server\base\fn_createVehicle.sqf"; };
		if ((getMarkerColor _endStringHeli != "") && {(br_enable_friendly_ai)})
		then { [_endStringHeli, _i, FALSE] execVM "core\server\base\fn_createHelis.sqf"; };
		if ((getMarkerColor _endStringHeliEvac != "") && {(br_enable_friendly_ai)})
		then { [_endStringHeliEvac, _i, TRUE] execVM "core\server\base\fn_createHelis.sqf"; };
		if ((getMarkerColor _endStringBombSquad != "") && {(br_enable_friendly_ai)})
		then { [_endStringBombSquad, _i] execVM "core\server\base\fn_createObjectiveUnits.sqf"; };
		if ((getMarkerColor _endStringRecruit != "") && {(br_enable_friendly_ai)})
		then { [_endStringRecruit, _i] execVM "core\server\recruit\fn_createRecruitAI.sqf"; };
	};
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
	sleep 5;
};

// Remove objectives which belong to the zone
br_fnc_deleteNonSideObjectives = {
	{
		_removeOnZoneCompleted = _x select 7;
		if (_removeOnZoneCompleted) then {
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
	_group = _this select 0; // The given group
	_fuelAmount = _this select 1; // 0 - 1

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
	if (br_hq_enabled) then {["HQ", "HQ", 10, selectrandom br_compositions_bases, "Kill", FALSE, "HQ Taken!", ["O_officer_F", "O_Soldier_F", "O_Soldier_AT_F", "O_Soldier_AA_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_medic_F", "O_Soldier_GL_F"], TRUE, TRUE, "Border", "ELLIPSE", getMarkerPos "ZONE_RADIUS", TRUE, [["MOVE", False]], TRUE] execVM "core\server\zone_objective\fn_createObjective.sqf";};
	// Create radio tower
	if (br_radio_tower_enabled) then {["Radio_Tower", "Radio Tower", 8, selectrandom br_composition_radio_towers, "Destory", TRUE, "Radio Tower Destroyed!", [], TRUE, TRUE, "Border", "ELLIPSE", getMarkerPos "ZONE_RADIUS", TRUE, [], FALSE] execVM "core\server\zone_objective\fn_createObjective.sqf";};
	// Create a random objective
	switch (round(random 2)) do {
		case 0: { ["EMP", "EMP", 6, [], "Kill", TRUE, "EMP Destroyed!", ["O_Truck_03_device_F"], TRUE, TRUE, "Border", "ELLIPSE", getMarkerPos "ZONE_RADIUS", TRUE, [], FALSE] execVM "core\server\zone_objective\fn_createObjective.sqf"; };
		case 1: { ["Helicopter", "Helicopter", 6, [], "Kill", TRUE, "Attack Helicopter Destroyed!", ["O_Heli_Attack_02_F"], TRUE, TRUE, "Border", "ELLIPSE", getMarkerPos "ZONE_RADIUS", TRUE, [], FALSE] execVM "core\server\zone_objective\fn_createObjective.sqf"; };
		case 2: { ["AA", "AA", 4, [], "Kill", TRUE, "AA Destroyed!", ["O_APC_Tracked_02_AA_F"], TRUE, TRUE, "Border", "ELLIPSE", getMarkerPos "ZONE_RADIUS", TRUE, [], FALSE] execVM "core\server\zone_objective\fn_createObjective.sqf"; };
		default {};
	};
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
		["ZONE_Radio_Tower_RADIUS", br_enemy_speical_list] execVM "core\server\zone\fn_zoneSpawnAI.sqf";
		// Wait for a time for the zone to populate
		sleep 60;
		// Wait untill zone is taken and objectives are completed
		{ if (_x select 6) then { waitUntil { missionNamespace getVariable (_x select 5) }; }; } forEach br_objectives;
		waitUntil { (count br_ai_groups <= br_min_enemy_groups_for_capture) };
		[] call br_fnc_onZoneTaken;
		sleep br_next_zone_start_delay;
	}
};

[] call br_fnc_main;