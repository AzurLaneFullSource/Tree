local var0 = {
	TIME_INTERVAL = 0.0166666666666667,
	GRASS_CHAGNE_RATE = 0.2,
	ALL_GAME_TIME = 120,
	MIN_MAP_SIZE = {
		20,
		20
	},
	SOIL_RANDOM_CONFIG = {
		spacer_rate = 0.25,
		size_rate = {
			0.5,
			0.7
		},
		cancel_rate = {
			0.2,
			0.3
		}
	},
	SOIL_SPRITES_DIC = {
		[119] = "Soil_4",
		[38] = "Soil_1",
		[254] = "Soil_2",
		[205] = "Soil_6",
		[238] = "Soil_2",
		[204] = "Soil_3",
		[239] = "Soil_11",
		[179] = "Soil_7",
		[236] = "Soil_3",
		[102] = "Soil_1",
		[237] = "Soil_6",
		[147] = "Soil_7",
		[118] = "Soil_1",
		[51] = "Soil_7",
		[137] = "Soil_9",
		[153] = "Soil_9",
		[251] = "Soil_8",
		[219] = "Soil_8",
		[187] = "Soil_8",
		[155] = "Soil_8",
		[217] = "Soil_9",
		[255] = "Soil_5",
		[223] = "Soil_13",
		[191] = "Soil_12",
		[54] = "Soil_1",
		[253] = "Soil_6",
		[221] = "Soil_6",
		[127] = "Soil_10",
		[110] = "Soil_2",
		[76] = "Soil_3",
		[126] = "Soil_2",
		[55] = "Soil_4",
		[108] = "Soil_3",
		[247] = "Soil_4",
		[19] = "Soil_7",
		[183] = "Soil_4",
		[201] = "Soil_9"
	},
	ENEMY_TYPE_LIST = {
		"Scavenger",
		"Chaser",
		"Smasher",
		"Conductor",
		"Navigator",
		"BOSS_Scavenger",
		"BOSS_Conductor",
		"BOSS_Chaser",
		"BOSS_Navigator",
		"BOSS_Smasher"
	},
	FREE_MAP_BOSS_LIMIT = {
		2,
		2,
		3,
		3,
		3,
		4,
		4
	},
	CreateInfo = function(arg0)
		local var0 = {}

		switch(arg0, {
			Item = function()
				var0.targetClass = TargetItem
				var0.path = "object/Item"
				var0.parent = "object"
			end,
			Bomb = function()
				var0.targetClass = ObjectBomb
				var0.path = "object/Bomb"
				var0.parent = "object"
			end,
			Bush = function()
				var0.targetClass = ObjectBush
				var0.path = "object/Bush"
				var0.parent = "object"
			end,
			Box = function()
				var0.targetClass = ObjectBreakable
				var0.path = "object/Box"
				var0.parent = "object"
			end,
			Grass = function()
				var0.targetClass = ObjectBreakable
				var0.path = "object/Grass"
				var0.parent = "object"
			end,
			Taru = function()
				var0.targetClass = ObjectBreakable
				var0.path = "object/Taru"
				var0.parent = "object"
			end,
			Rock_A = function()
				var0.targetClass = TargetObject
				var0.path = "object/Rock_A"
				var0.parent = "object"
			end,
			Rock_B = function()
				var0.targetClass = ObjectRockB
				var0.path = "object/Rock_B"
				var0.parent = "object"
			end,
			Tree_L = function()
				var0.targetClass = TargetObject
				var0.path = "object/Tree_L"
				var0.parent = "object"
			end,
			Tree_S = function()
				var0.targetClass = TargetObject
				var0.path = "object/Tree_S"
				var0.parent = "object"
			end,
			Treasure_N = function()
				var0.targetClass = ObjectTreasureN
				var0.path = "object/Treasure_N"
				var0.parent = "object"
			end,
			Treasure_R = function()
				var0.targetClass = ObjectTreasureR
				var0.path = "object/Treasure_R"
				var0.parent = "object"
			end,
			Fire = function()
				var0.targetClass = EffectFire
				var0.path = "effect/Fire"
				var0.parent = "effect"
				var0.order = "low"
			end,
			Impack = function()
				var0.targetClass = EffectImpack
				var0.path = "effect/Impack"
				var0.parent = "effect"
			end,
			Bullet = function()
				var0.targetClass = EffectBullet
				var0.path = "effect/Bullet"
				var0.parent = "effect"
			end,
			Laser = function()
				var0.targetClass = EffectLaser
				var0.path = "effect/Laser"
				var0.parent = "effect"
			end,
			Ryza = function()
				var0.targetClass = MoveRyza
				var0.path = "character/Ryza"
				var0.parent = "character"
			end,
			Scavenger = function()
				var0.targetClass = EnemyScavenger
				var0.path = "character/Scavenger"
				var0.parent = "character"
			end,
			BOSS_Scavenger = function()
				var0.targetClass = EnemyBossScavenger
				var0.path = "character/BOSS_Scavenger"
				var0.parent = "character"
			end,
			Chaser = function()
				var0.targetClass = EnemyChaser
				var0.path = "character/Chaser"
				var0.parent = "character"
			end,
			BOSS_Chaser = function()
				var0.targetClass = EnemyBossChaser
				var0.path = "character/BOSS_Chaser"
				var0.parent = "character"
			end,
			Smasher = function()
				var0.targetClass = EnemySmasher
				var0.path = "character/Smasher"
				var0.parent = "character"
			end,
			BOSS_Smasher = function()
				var0.targetClass = EnemyBossSmasher
				var0.path = "character/BOSS_Smasher"
				var0.parent = "character"
			end,
			Conductor = function()
				var0.targetClass = EnemyConductor
				var0.path = "character/Conductor"
				var0.parent = "character"
			end,
			BOSS_Conductor = function()
				var0.targetClass = EnemyBossConductor
				var0.path = "character/BOSS_Conductor"
				var0.parent = "character"
			end,
			Navigator = function()
				var0.targetClass = EnemyNavigator
				var0.path = "character/Navigator"
				var0.parent = "character"
			end,
			BOSS_Navigator = function()
				var0.targetClass = EnemyBossNavigator
				var0.path = "character/BOSS_Navigator"
				var0.parent = "character"
			end
		})

		return var0.targetClass, var0.path, var0.parent
	end
}
local var1 = {
	{
		"S",
		"N"
	},
	{
		"E",
		"W"
	}
}
local var2 = math.sin(math.pi / 8)

function var0.GetEightDirMark(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs({
		arg0.y,
		arg0.x
	}) do
		if iter1 * iter1 < var2 * var2 then
			iter1 = 0
		end

		if iter1 > 0 then
			var0[iter0] = var1[iter0][1]
		elseif iter1 < 0 then
			var0[iter0] = var1[iter0][2]
		else
			var0[iter0] = ""
		end
	end

	return var0[1] .. var0[2]
end

function var0.GetFourDirMark(arg0)
	local var0 = {}
	local var1 = arg0.y * arg0.y < arg0.x * arg0.x and {
		0,
		arg0.x
	} or {
		arg0.y,
		0
	}

	for iter0, iter1 in ipairs(var1) do
		if iter1 > 0 then
			var0[iter0] = var1[iter0][1]
		elseif iter1 < 0 then
			var0[iter0] = var1[iter0][2]
		else
			var0[iter0] = ""
		end
	end

	return var0[1] .. var0[2]
end

function var0.GetDestroyPoint(arg0)
	local var0 = 0

	if arg0.class == TargetItem then
		switch(arg0.type, {
			bomb = function()
				var0 = 50
			end,
			power = function()
				var0 = 50
			end,
			speed = function()
				var0 = 50
			end,
			hp1 = function()
				var0 = 100
			end,
			hp2 = function()
				var0 = 200
			end,
			spirit = function()
				var0 = 300
			end
		})
	elseif isa(arg0, TargetObject) then
		switch(arg0.class, {
			[ObjectBreakable] = function()
				var0 = 20
			end,
			[ObjectRockB] = function()
				var0 = 50
			end,
			[ObjectTreasureN] = function()
				var0 = 200
			end,
			[ObjectTreasureR] = function()
				var0 = 500
			end
		})
	elseif isa(arg0, MoveEnemy) then
		switch(arg0.class, {
			[EnemyScavenger] = function()
				var0 = 100
			end,
			[EnemyBossScavenger] = function()
				var0 = 300
			end,
			[EnemyChaser] = function()
				var0 = 100
			end,
			[EnemyBossChaser] = function()
				var0 = 500
			end,
			[EnemyNavigator] = function()
				var0 = 150
			end,
			[EnemyBossNavigator] = function()
				var0 = 600
			end,
			[EnemySmasher] = function()
				var0 = 150
			end,
			[EnemyBossSmasher] = function()
				var0 = 500
			end,
			[EnemyConductor] = function()
				var0 = 200
			end,
			[EnemyBossConductor] = function()
				var0 = 600
			end
		})
	end

	return var0
end

function var0.GetPassGamePoint(arg0)
	return math.floor(10000 / math.log(arg0))
end

return var0
