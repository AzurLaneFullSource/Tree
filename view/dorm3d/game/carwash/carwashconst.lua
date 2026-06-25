local var0_0 = class("CarWashConst")

var0_0.DEFAULT_RAY_DISTANCE = 3
var0_0.DEFAULT_DECAL_RENDER_QUEUE = 2600
var0_0.CAR_LAYER = 26
var0_0.CAR_LAYER_MASK = bit.lshift(1, var0_0.CAR_LAYER)
var0_0.LADY_LAYER = LayerMask.NameToLayer("Character3D")
var0_0.LADY_LAYER_MASK = bit.lshift(1, var0_0.LADY_LAYER)
var0_0.PLAYER_LAYER = LayerMask.NameToLayer("Player")
var0_0.PLAYER_LAYER_MASK = bit.lshift(1, var0_0.PLAYER_LAYER)
var0_0.DEFAULT_LADY_DECAL_SIZE = 0.1
var0_0.LAYER_MASK = bit.bor(var0_0.CAR_LAYER_MASK, var0_0.LADY_LAYER_MASK)
var0_0.DECAL_LAYER = LayerMask.NameToLayer("CameraRT")
var0_0.DECAL_LAYER_MASK = bit.lshift(1, var0_0.DECAL_LAYER)
var0_0.EFFECT_LAYER_MASK = bit.bnot(bit.bor(var0_0.DECAL_LAYER_MASK, var0_0.PLAYER_LAYER_MASK))
var0_0.HIDDEN_REACTION_TRIGGER_TIME = 2
var0_0.GAME_DURATION = 300
var0_0.ORTHOGRAPHIC_SIZE_RANGE = {
	0.3,
	0.4
}
var0_0.ROTATE_RANGE = {
	0,
	360
}
var0_0.GUN_TYPE = {
	FOAM_SPRAYER = 2,
	WASHER = 1,
	HIGH_PRESSURE_WASHER = 3
}
var0_0.GUN_CONFIG = setmetatable({}, {
	__index = function(arg0_1, arg1_1)
		var0_0.InitGunConfig(arg0_1)

		return rawget(arg0_1, arg1_1)
	end
})
var0_0.GAME_STATE = {
	PHASE_2 = 2,
	END = 4,
	PHASE_1 = 1,
	NONE = 0
}
var0_0.SCORE_RANK = {
	S = 90,
	A = 56,
	C = 0,
	B = 31
}
var0_0.SCORE_RANK_ORDER = {
	"S",
	"A",
	"B",
	"C"
}

function var0_0.GetScoreRank(arg0_2)
	arg0_2 = arg0_2 or 0

	for iter0_2, iter1_2 in ipairs(var0_0.SCORE_RANK_ORDER) do
		if arg0_2 >= var0_0.SCORE_RANK[iter1_2] then
			return iter1_2
		end
	end

	return "C"
end

var0_0.DECAL_CONFIG = setmetatable({}, {
	__index = function(arg0_3, arg1_3)
		var0_0.InitDecalConfig(arg0_3)

		return rawget(arg0_3, arg1_3)
	end
})
var0_0.STAINS_CONFIG = setmetatable({}, {
	__index = function(arg0_4, arg1_4)
		var0_0.InitStainsConfig(arg0_4)

		return rawget(arg0_4, arg1_4)
	end
})

function var0_0.GetDefaultSystemClasses()
	return table.mergeArray({
		CarWashGameFlowSystem
	}, var0_0.GetGameplaySystemClasses())
end

function var0_0.GetGameplaySystemClasses()
	return {
		CarWashTimelineSystem,
		CarWashPovControlSystem,
		CarWashRaycastSystem,
		CarWashMuzzleEffect,
		CarWashDecalSystem,
		CarWashGlassMaterialFix,
		CarWashLadySystem
	}
end

function var0_0.GetDecalConfig(arg0_7)
	return var0_0.DECAL_CONFIG[arg0_7]
end

function var0_0.GetStainsConfig(arg0_8)
	return var0_0.STAINS_CONFIG[arg0_8]
end

function var0_0.GetGunConfig(arg0_9)
	return var0_0.GUN_CONFIG[arg0_9]
end

function var0_0.InitGunConfig(arg0_10)
	arg0_10 = arg0_10 or var0_0.GUN_CONFIG

	if rawget(arg0_10, var0_0.GUN_TYPE.WASHER) then
		return
	end

	arg0_10[var0_0.GUN_TYPE.WASHER] = {
		force = 1,
		name = "pre_db_nozzle_01_group02",
		decalType = {
			onCar = DecalType.WATER,
			onLady = DecalType.WATER_ON_LADY
		}
	}
	arg0_10[var0_0.GUN_TYPE.FOAM_SPRAYER] = {
		force = 0.5,
		name = "pre_db_nozzle_01_group01",
		decalType = {
			onCar = DecalType.BUBBLE,
			onLady = DecalType.BUBBLE_ON_LADY
		}
	}
	arg0_10[var0_0.GUN_TYPE.HIGH_PRESSURE_WASHER] = {
		force = 2,
		name = "pre_db_nozzle_01a_group01",
		decalType = {
			onCar = DecalType.WATER,
			onLady = DecalType.WATER_ON_LADY
		}
	}
end

function var0_0.InitDecalConfig(arg0_11)
	arg0_11 = arg0_11 or var0_0.DECAL_CONFIG

	if rawget(arg0_11, DecalType.BUBBLE) then
		return
	end

	arg0_11[DecalType.BUBBLE] = {
		useAutoFade = true,
		autoFadeStartTime = 10,
		aspectRatio = 1,
		autoFadeTime = 2,
		sourceMaterial = {
			0
		},
		renderQueue = var0_0.DEFAULT_DECAL_RENDER_QUEUE + 10,
		decalType = DecalType.BUBBLE
	}
	arg0_11[DecalType.WATER] = {
		useAutoFade = true,
		autoFadeStartTime = 8,
		aspectRatio = 1,
		autoFadeTime = 3,
		sourceMaterial = {
			1
		},
		renderQueue = var0_0.DEFAULT_DECAL_RENDER_QUEUE + 11,
		decalType = DecalType.WATER
	}
	arg0_11[DecalType.WATER_ON_LADY] = {
		useAutoFade = true,
		autoFadeStartTime = 5,
		aspectRatio = 1,
		autoFadeTime = 1,
		sourceMaterial = {
			2,
			3,
			4,
			5
		},
		renderQueue = var0_0.DEFAULT_DECAL_RENDER_QUEUE + 11,
		decalType = DecalType.WATER_ON_LADY
	}
	arg0_11[DecalType.BUBBLE_ON_LADY] = {
		useAutoFade = true,
		autoFadeStartTime = 5,
		aspectRatio = 1,
		autoFadeTime = 1,
		sourceMaterial = {
			6,
			7,
			8,
			9
		},
		renderQueue = var0_0.DEFAULT_DECAL_RENDER_QUEUE + 10,
		decalType = DecalType.BUBBLE_ON_LADY
	}
end

function var0_0.InitStainsConfig(arg0_12)
	arg0_12 = arg0_12 or var0_0.STAINS_CONFIG

	if rawget(arg0_12, DecalType.DIRT) then
		return
	end

	arg0_12[DecalType.DUST] = {
		fadePerSec = 0.5,
		targetGunType = var0_0.GUN_TYPE.WASHER
	}
	arg0_12[DecalType.GRAFFITI] = {
		fadePerSec = 0,
		coverBuff = 0.5,
		targetGunType = var0_0.GUN_TYPE.HIGH_PRESSURE_WASHER,
		coverDecal = DecalType.BUBBLE
	}
	arg0_12[DecalType.DIRT] = {
		fadePerSec = 0.5,
		targetGunType = var0_0.GUN_TYPE.HIGH_PRESSURE_WASHER
	}
end

return var0_0
