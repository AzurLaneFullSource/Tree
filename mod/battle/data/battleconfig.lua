ys.Battle.BattleConfig = ys.Battle.BattleConfig or {}

local var0 = ys.Battle.BattleConfig

var0.calcFPS = 30
var0.viewFPS = 30
var0.AIFPS = 10
var0.calcInterval = 1 / var0.calcFPS
var0.viewInterval = 1 / var0.viewFPS
var0.AIInterval = 1 / var0.AIFPS
var0.FRIENDLY_CODE = 1
var0.FOE_CODE = -1
var0.SHIELD_CENTER_CONST = 3.14
var0.SHIELD_CENTER_CONST_2 = 2.09333333333333
var0.SHIELD_CENTER_CONST_4 = 4.18666666666667
var0.SHIELD_ROTATE_CONST = 30 / math.pi * 18
var0.K1 = 6
var0.K2 = 100
var0.K3 = 3.14
var0.AIR_ASSIST_RELOAD_RATIO = 220
var0.RANDOM_DAMAGE_MIN = 0
var0.RANDOM_DAMAGE_MAX = 2
var0.BASIC_TIME_SCALE = 1
var0.SPINE_SCALE = 2
var0.BULLET_UPPER_BOUND_VISION_OFFSET = 30
var0.BULLET_LEFT_BOUND_SPLIT_OFFSET = 8
var0.BULLET_LOWER_BOUND_SPLIT_OFFSET = 8
var0.CAMERA_INIT_POS = Vector3(0, 62, -10)
var0.CAMERA_SIZE = 20
var0.CAMERA_BASE_HEIGH = 8
var0.CAMERA_GOLDEN_RATE = 0.618
var0.AntiAirConfig = {}
var0.AntiAirConfig.const_n = 10
var0.AntiAirConfig.const_K = 1000
var0.AntiAirConfig.const_N = 5
var0.AntiAirConfig.const_A = 20
var0.AntiAirConfig.const_B = 40
var0.AntiAirConfig.Restore_Interval = 1
var0.AntiAirConfig.Precast_duration = 0.25
var0.AntiAirConfig.RangeBulletID = 2001
var0.AntiAirConfig.RangeBarrageID = 1
var0.AntiAirConfig.RangeAntiAirBone = "rangeantiaircraft"
var0.AirSupportUnitPos = Vector3(-105, 0, 58)
var0.AnitAirRepeaterConfig = {}
var0.AnitAirRepeaterConfig.const_A = 32
var0.AnitAirRepeaterConfig.const_B = 12
var0.AnitAirRepeaterConfig.const_C = 220
var0.AnitAirRepeaterConfig.upper_range = 35
var0.AnitAirRepeaterConfig.lower_range = 15
var0.ChargeWeaponConfig = {}
var0.ChargeWeaponConfig.a1 = 0
var0.ChargeWeaponConfig.K1 = 0
var0.ChargeWeaponConfig.K2 = 1000
var0.ChargeWeaponConfig.FIX_CD = 7
var0.ChargeWeaponConfig.MEGA_FIX_CD = 3
var0.ChargeWeaponConfig.GCD = 1
var0.ChargeWeaponConfig.Enhance = 1.2
var0.ChargeWeaponConfig.SIGHT_A = 0.35
var0.ChargeWeaponConfig.SIGHT_B = -40
var0.ChargeWeaponConfig.SIGHT_C = 38
var0.TorpedoCFG = {}
var0.TorpedoCFG.T = 10
var0.TorpedoCFG.N = 1000
var0.TorpedoCFG.GCD = 0.5
var0.AirAssistCFG = {}
var0.AirAssistCFG.GCD = 0.5
var0.HammerCFG = {}
var0.HammerCFG.PreventUpperBound = 0.8
var0.BulletHeight = 1
var0.HeightOffsetRate = 1.5
var0.CharacterFeetHight = -0.5
var0.BombDetonateHeight = 1.2
var0.CameraSizeChangeSpeed = 0.04
var0.AircraftHeight = 10
var0.AirFighterOffsetZ = 3
var0.AirFighterHeight = 10
var0.CommonBone = {
	rangeantiaircraft = {
		{
			1.5,
			1.1,
			0
		}
	}
}
var0.MaxLeft = -10000
var0.MaxRight = 10000
var0.BornOffset = Vector3(0, 0, 0.1)
var0.FORMATION_ID = 10001
var0.CelebrateDuration = 3
var0.EscapeDuration = 5
var0.BulletMotionRate = 0.4
var0.BulletSpeedConvertConst = 0.1
var0.ShipSpeedConvertConst = 0.01
var0.AircraftSpeedConvertConst = 0.01
var0.PLAYER_WEAPON_GLOBAL_COOL_DOWN_DURATION = 0.5
var0.PLAYER_DEFAULT = 0
var0.SPECTRE_UNIT_TYPE = -99
var0.VISIBLE_SPECTRE_UNIT_TYPE = -100
var0.FUSION_ELEMENT_UNIT_TYPE = -10000
var0.COUNT_DOWN_ESCAPE_AI_ID = 80006
var0.ESCAPE_EXPLO_TAG = {
	"unexit"
}
var0.RESOURCE_STEP = 10
var0.RESOURCE_STAY_DURATION = 2
var0.CAST_CAM_ZOOM_SIZE = 14
var0.CAST_CAM_ZOOM_IN_DURATION = 0.1
var0.CAST_CAM_ZOOM_IN_DURATION_SKILL = 0.04
var0.CAST_CAM_ZOOM_OUT_DURATION_CANNON = 0.1
var0.CAST_CAM_ZOOM_OUT_EXTRA_DELAY_CANNON = 0.04
var0.CAST_CAM_ZOOM_OUT_DELAY_CANNON = 0
var0.CAST_CAM_ZOOM_OUT_DURATION_AIR = 0.1
var0.CAST_CAM_ZOOM_OUT_EXTRA_DELAY_AIR = 0.03
var0.CAST_CAM_ZOOM_OUT_DELAY_AIR = 0.05
var0.AIR_ASSIST_SPEED_RATE = 2.8
var0.CAST_CAM_ZOOM_OUT_DURATION_SKILL = 0.04
var0.CAST_CAM_ZOOM_OUT_EXTRA_DELAY_SKILL = 0
var0.CAST_CAM_ZOOM_OUT_DELAY_SKILL = 0
var0.CALIBRATE_ACCELERATION = 1.2
var0.CAST_CAM_OVERLOOK_SIZE = 24
var0.CAST_CAM_OVERLOOK_REVERT_DURATION = 1.5
var0.CAM_RESET_DURATION = 0.7
var0.SPEED_FACTOR_FOCUS_CHARACTER = "focusCharacter"
var0.FOCUS_MAP_RATE = 0.1
var0.MAIN_UNIT_POS = {
	[var0.FRIENDLY_CODE] = {
		Vector3(-105, 0, 58),
		Vector3(-105, 0, 78),
		Vector3(-105, 0, 38)
	},
	[var0.FOE_CODE] = {
		Vector3(15, 0, 58),
		Vector3(15, 0, 78),
		Vector3(15, 0, 38)
	}
}
var0.FIELD_RIGHT_BOUND_BIAS = 0
var0.SUB_UNIT_POS_Z = {
	58,
	78,
	38
}
var0.SUB_UNIT_OFFSET_X = -5
var0.SUB_BENCH_POS = {
	Vector3(-325, 0, 228),
	Vector3(-325, 0, 128)
}
var0.SHIP_CLD_INTERVAL = 1
var0.SHIP_CLD_BUFF = 8010
var0.START_SPEED_CONST_A = 2.5
var0.START_SPEED_CONST_B = 0.25
var0.START_SPEED_CONST_C = 0.3
var0.START_SPEED_CONST_D = 2.5
var0.GRAVITY = -0.05
var0.DUEL_MAIN_RAGE_BUFF = 6
var0.DULE_BALANCE_BUFF = 19
var0.SIMULATION_BALANCE_BUFF = 49
var0.ARENA_LIST = {
	80000,
	80001,
	80002,
	80003
}
var0.SIMULATION_FREE_BUFF = 41
var0.SIMULATION_ADVANTAGE_BUFF = 42
var0.SIMULATION_ADVANTAGE_CANCEL_LIST = {
	42,
	44,
	45
}
var0.SIMULATION_DISADVANTAGE_BUFF = 43
var0.SIMULATION_RIVAL_RAGE_TOTAL_COUNT = 30
var0.CHALLENGE_INVINCIBLE_BUFF = 50
var0.WARNING_HP_RATE = 0.7
var0.WARNING_HP_RATE_MAIN = 0.3
var0.SKILL_BUTTON_DEFAULT_PREFERENCE = {}
var0.SKILL_BUTTON_DEFAULT_PREFERENCE[1] = {
	x = 0.924,
	scale = 1,
	y = 0.135
}
var0.SKILL_BUTTON_DEFAULT_PREFERENCE[2] = {
	x = 0.81,
	scale = 1,
	y = 0.135
}
var0.SKILL_BUTTON_DEFAULT_PREFERENCE[3] = {
	x = 0.696,
	scale = 1,
	y = 0.135
}
var0.SKILL_BUTTON_DEFAULT_PREFERENCE[4] = {
	x = 0.58,
	scale = 1,
	y = 0.135
}
var0.JOY_STICK_DEFAULT_PREFERENCE = {
	x = 0.12,
	scale = 1,
	y = 0.183
}
var0.AUTO_DEFAULT_PREFERENCE = {
	x = 0.0625,
	scale = 1,
	y = 0.925
}
var0.DOT_CONFIG = {}
var0.DOT_CONFIG[1] = {
	reduce = "igniteReduce",
	shorten = "igniteShorten",
	prolong = "igniteProlong",
	resist = "igniteResist",
	enhance = "igniteEnhance",
	hit = "ignite_accuracy"
}
var0.DOT_CONFIG[2] = {
	reduce = "floodingReduce",
	shorten = "floodingShorten",
	prolong = "floodingProlong",
	resist = "floodingResist",
	enhance = "floodingEnhance",
	hit = "flooding_accuracy"
}
var0.DOT_CONFIG[10] = {}
var0.DOT_CONFIG_DEFAULT = {
	reduce = 0,
	shorten = 0,
	prolong = 0,
	resist = 0,
	enhance = 0,
	hit = 0
}
var0.AMMO_DAMAGE_ENHANCE = {
	"damageRatioByAmmoType_1",
	"damageRatioByAmmoType_2",
	"damageRatioByAmmoType_3",
	nil,
	nil,
	nil,
	"damageRatioByAmmoType_7"
}
var0.AMMO_DAMAGE_REDUCE = {
	"damageReduceFromAmmoType_1",
	"damageReduceFromAmmoType_2",
	"damageReduceFromAmmoType_3",
	"damageReduceFromAmmoType_4",
	nil,
	nil,
	"damageReduceFromAmmoType_7"
}
var0.DAMAGE_AMMO_TO_ARMOR_RATE_ENHANCE = {
	"damageAmmoToArmorRateEnhance_1",
	"damageAmmoToArmorRateEnhance_2",
	"damageAmmoToArmorRateEnhance_3"
}
var0.DAMAGE_TO_ARMOR_RATE_ENHANCE = {
	"damageToArmorRateEnhance_1",
	"damageToArmorRateEnhance_2",
	"damageToArmorRateEnhance_3"
}
var0.SHIP_TYPE_ACCURACY_ENHANCE = {
	[ShipType.QuZhu] = "accuracyToShipType_1",
	[ShipType.QingXun] = "accuracyToShipType_2",
	[ShipType.ZhongXun] = "accuracyToShipType_3",
	[ShipType.ZhanXun] = "accuracyToShipType_4",
	[ShipType.ZhanLie] = "accuracyToShipType_5",
	[ShipType.QingHang] = "accuracyToShipType_6",
	[ShipType.ZhengHang] = "accuracyToShipType_7",
	[ShipType.QianTing] = "accuracyToShipType_8",
	[ShipType.HangXun] = "accuracyToShipType_9",
	[ShipType.HangZhan] = "accuracyToShipType_10",
	[ShipType.LeiXun] = "accuracyToShipType_11",
	[ShipType.WeiXiu] = "accuracyToShipType_12",
	[ShipType.ZhongPao] = "accuracyToShipType_13",
	[ShipType.YuLeiTing] = "accuracyToShipType_14",
	[ShipType.JinBi] = "accuracyToShipType_15",
	[ShipType.ZiBao] = "accuracyToShipType_16",
	[ShipType.QianMu] = "accuracyToShipType_17",
	[ShipType.ChaoXun] = "accuracyToShipType_18",
	[ShipType.Yunshu] = "accuracyToShipType_19",
	[ShipType.DaoQuV] = "accuracyToShipType_20",
	[ShipType.DaoQuM] = "accuracyToShipType_21",
	[ShipType.FengFanS] = "accuracyToShipType_22",
	[ShipType.FengFanV] = "accuracyToShipType_23",
	[ShipType.FengFanM] = "accuracyToShipType_24"
}
var0.OXY_RAID_BASE_LINE_PVE = -20
var0.OXY_RAID_BASE_LINE_PVP = -20
var0.SUB_DEFAULT_STAY_AI = 10006
var0.SUB_DEFAULT_ENGAGE_AI = 90001
var0.SUB_DEFAULT_RETREAT_AI = 90002
var0.SONAR_DURATION_K = 0.1
var0.SONAR_INTERVAL_K = 0.1
var0.VAN_SONAR_PROPERTY = {
	[ShipType.QuZhu] = {
		maxRange = 100,
		a = 2,
		minRange = 45,
		b = 32
	},
	[ShipType.QingXun] = {
		maxRange = 80,
		a = 2.86,
		minRange = 30,
		b = 0
	},
	[ShipType.DaoQuV] = {
		maxRange = 100,
		a = 2,
		minRange = 45,
		b = 32
	}
}
var0.MAIN_SONAR_PROPERTY = {
	maxRange = 15,
	a = 24,
	minRange = 0
}
var0.SUB_EXPOSE_LASTING_DURATION = 0.5
var0.SUB_FADE_IN_DURATION = 0.5
var0.SUB_FADE_OUT_DURATION = 0.5
var0.SUB_DIVE_IMMUNE_IGNITE_BUFF = 314
var0.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF = 315
var0.PLAYER_SUB_BUBBLE_FX = "bubble"
var0.PLAYER_SUB_BUBBLE_INIT = 200
var0.PLAYER_SUB_BUBBLE_INTERVAL = 3
var0.MONSTER_SUB_KAMIKAZE_DUAL_K = 50
var0.MONSTER_SUB_KAMIKAZE_DUAL_P = 0.15
var0.BATTLE_SHADER = {}
var0.BATTLE_SHADER.SEMI_TRANSPARENT = "M02/Unlit_Colored_Semitransparent"
var0.BATTLE_SHADER.GRID_TRANSPARENT = "M02/Skeleton Colored_Additive"
var0.BATTLE_SHADER.COLORED_ALPHA = "M02/Unlit Colored_Alpha"
var0.BATTLE_DODGEM_STAGES = {
	1140101,
	1140102,
	1140103
}
var0.BATTLE_DODGEM_PASS_SCORE = 10
var0.SR_CONFIG = {}
var0.SR_CONFIG.FLOAT_CD = 2
var0.SR_CONFIG.DIVE_CD = 2
var0.SR_CONFIG.BOOST_CD = 10
var0.SR_CONFIG.SHIFT_CD = 5
var0.SR_CONFIG.BOOST_SPEED = 2
var0.SR_CONFIG.BOOST_DECAY = 0.2
var0.SR_CONFIG.BOOST_DURATION = 12
var0.SR_CONFIG.BOOST_DECAY_STAMP = 9
var0.SR_CONFIG.BASE_POINT = 100
var0.SR_CONFIG.POINT = 10
var0.SR_CONFIG.DEAD_POINT = 15
var0.SR_CONFIG.M = 2
var0.CHALLENGE_ENHANCE = {}
var0.CHALLENGE_ENHANCE.K = 1
var0.CHALLENGE_ENHANCE.X = 3
var0.CHALLENGE_ENHANCE.A = 2
var0.CHALLENGE_ENHANCE.X1 = 5
var0.CHALLENGE_ENHANCE.X2 = 5
var0.CHALLENGE_ENHANCE.Y1 = 10
var0.CHALLENGE_ENHANCE.Y2 = 5
var0.LOADING_TIPS_LIMITED_SYSTEM = {
	SYSTEM_WORLD
}
var0.WORLD_ENEMY_ENHANCEMENT_CONST_B = 80
var0.WORLD_ENEMY_ENHANCEMENT_CONST_C = 1.1
var0.BULLET_DECREASE_DMG_FONT = {
	4,
	0.9
}
var0.CLOAK_EXPOSE_CONST = 50
var0.CLOAK_EXPOSE_BASE_MIN = 100
var0.CLOAK_EXPOSE_SKILL_MIN = 60
var0.CLOAK_BASE_RESTORE_DELTA = -60
var0.CLOAK_RECOVERY = 5
var0.BASE_ARP = 0.1
var0.CLOAK_STRIKE_ADDITIVE = 6
var0.CLOAK_STRIKE_ADDITIVE_LIMIT = 60
var0.CLOAK_BOMBARD_BASE_EXPOSE = 10
var0.AIM_BIAS_FLEET_RANGE_MOD = 0.18
var0.AIM_BIAS_SUB_RANGE_MOD = 0.18
var0.AIM_BIAS_MONSTER_RANGE_MOD = 0.4
var0.AIM_BIAS_DECAY_MOD = 0.01
var0.AIM_BIAS_DECAY_MOD_MONSTER = 0.01
var0.AIM_BIAS_DECAY_BASE = 0
var0.AIM_BIAS_DECAY_SUB_CONST = 50
var0.AIM_BIAS_DECAY_SMOKE = 1
var0.AIM_BIAS_DECAY_SMOKE_NIGHT = 0.8
var0.AIM_BIAS_SMOKE_RESTORE_DURATION = 3
var0.AIM_BIAS_SMOKE_RECOVERY_RATE = 0.6
var0.AIM_BIAS_DECAY_SPEED_MAX_SCOUT = 3
var0.AIM_BIAS_DECAY_SPEED_MAX_MONSTER = 3
var0.AIM_BIAS_DECAY_SPEED_MAX_SUB = 100
var0.AIM_BIAS_MIN_RANGE_SCOUT = {
	3,
	4,
	5,
	5
}
var0.AIM_BIAS_MIN_RANGE_MONSTER = 4
var0.AIM_BIAS_MIN_RANGE_SUB = 4
var0.AIM_BIAS_MAX_RANGE_SCOUT = 25
var0.AIM_BIAS_MAX_RANGE_MONSTER = 60
var0.AIM_BIAS_MAX_RANGE_SUB = 25
var0.AIM_BIAS_ENEMY_INIT_TIME = 1.5
var0.FLEET_ATTR_CAP = {
	shenpanzhijian = 6,
	yuanchou = 9,
	ReisalinAP = 99,
	Judgement = 12,
	huohun = 5
}
var0.TARGET_SELECT_PRIORITY = {
	C14_1 = 10,
	leastHP = 998,
	QEM_highlight = 99,
	C14_highlight = 11,
	farthest = 999,
	highlight = 99,
	xuzhang_hude = 1
}
var0.EQUIPMENT_ACTIVE_LIMITED_BY_TYPE = {
	[31] = {
		21
	},
	[32] = {
		20
	}
}
var0.SWEET_DEATH_NATIONALITY = {
	107
}
var0.ALCHEMIST_AP_UI = {
	109
}
var0.ALCHEMIST_AP_NAME = "ReisalinAP"
