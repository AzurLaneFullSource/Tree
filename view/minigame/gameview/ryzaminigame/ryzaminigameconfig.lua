local var0_0 = {
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
	CreateInfo = function(arg0_1)
		local var0_1 = {}

		switch(arg0_1, {
			Item = function()
				var0_1.targetClass = TargetItem
				var0_1.path = "object/Item"
				var0_1.parent = "object"
			end,
			Bomb = function()
				var0_1.targetClass = ObjectBomb
				var0_1.path = "object/Bomb"
				var0_1.parent = "object"
			end,
			Bush = function()
				var0_1.targetClass = ObjectBush
				var0_1.path = "object/Bush"
				var0_1.parent = "object"
			end,
			Box = function()
				var0_1.targetClass = ObjectBreakable
				var0_1.path = "object/Box"
				var0_1.parent = "object"
			end,
			Grass = function()
				var0_1.targetClass = ObjectBreakable
				var0_1.path = "object/Grass"
				var0_1.parent = "object"
			end,
			Taru = function()
				var0_1.targetClass = ObjectBreakable
				var0_1.path = "object/Taru"
				var0_1.parent = "object"
			end,
			Rock_A = function()
				var0_1.targetClass = TargetObject
				var0_1.path = "object/Rock_A"
				var0_1.parent = "object"
			end,
			Rock_B = function()
				var0_1.targetClass = ObjectRockB
				var0_1.path = "object/Rock_B"
				var0_1.parent = "object"
			end,
			Tree_L = function()
				var0_1.targetClass = TargetObject
				var0_1.path = "object/Tree_L"
				var0_1.parent = "object"
			end,
			Tree_S = function()
				var0_1.targetClass = TargetObject
				var0_1.path = "object/Tree_S"
				var0_1.parent = "object"
			end,
			Treasure_N = function()
				var0_1.targetClass = ObjectTreasureN
				var0_1.path = "object/Treasure_N"
				var0_1.parent = "object"
			end,
			Treasure_R = function()
				var0_1.targetClass = ObjectTreasureR
				var0_1.path = "object/Treasure_R"
				var0_1.parent = "object"
			end,
			Fire = function()
				var0_1.targetClass = EffectFire
				var0_1.path = "effect/Fire"
				var0_1.parent = "effect"
				var0_1.order = "low"
			end,
			Impack = function()
				var0_1.targetClass = EffectImpack
				var0_1.path = "effect/Impack"
				var0_1.parent = "effect"
			end,
			Bullet = function()
				var0_1.targetClass = EffectBullet
				var0_1.path = "effect/Bullet"
				var0_1.parent = "effect"
			end,
			Laser = function()
				var0_1.targetClass = EffectLaser
				var0_1.path = "effect/Laser"
				var0_1.parent = "effect"
			end,
			Ryza = function()
				var0_1.targetClass = MoveRyza
				var0_1.path = "character/Ryza"
				var0_1.parent = "character"
			end,
			Scavenger = function()
				var0_1.targetClass = EnemyScavenger
				var0_1.path = "character/Scavenger"
				var0_1.parent = "character"
			end,
			BOSS_Scavenger = function()
				var0_1.targetClass = EnemyBossScavenger
				var0_1.path = "character/BOSS_Scavenger"
				var0_1.parent = "character"
			end,
			Chaser = function()
				var0_1.targetClass = EnemyChaser
				var0_1.path = "character/Chaser"
				var0_1.parent = "character"
			end,
			BOSS_Chaser = function()
				var0_1.targetClass = EnemyBossChaser
				var0_1.path = "character/BOSS_Chaser"
				var0_1.parent = "character"
			end,
			Smasher = function()
				var0_1.targetClass = EnemySmasher
				var0_1.path = "character/Smasher"
				var0_1.parent = "character"
			end,
			BOSS_Smasher = function()
				var0_1.targetClass = EnemyBossSmasher
				var0_1.path = "character/BOSS_Smasher"
				var0_1.parent = "character"
			end,
			Conductor = function()
				var0_1.targetClass = EnemyConductor
				var0_1.path = "character/Conductor"
				var0_1.parent = "character"
			end,
			BOSS_Conductor = function()
				var0_1.targetClass = EnemyBossConductor
				var0_1.path = "character/BOSS_Conductor"
				var0_1.parent = "character"
			end,
			Navigator = function()
				var0_1.targetClass = EnemyNavigator
				var0_1.path = "character/Navigator"
				var0_1.parent = "character"
			end,
			BOSS_Navigator = function()
				var0_1.targetClass = EnemyBossNavigator
				var0_1.path = "character/BOSS_Navigator"
				var0_1.parent = "character"
			end
		})

		return var0_1.targetClass, var0_1.path, var0_1.parent
	end
}
local var1_0 = {
	{
		"S",
		"N"
	},
	{
		"E",
		"W"
	}
}
local var2_0 = math.sin(math.pi / 8)

function var0_0.GetEightDirMark(arg0_29)
	local var0_29 = {}

	for iter0_29, iter1_29 in ipairs({
		arg0_29.y,
		arg0_29.x
	}) do
		if iter1_29 * iter1_29 < var2_0 * var2_0 then
			iter1_29 = 0
		end

		if iter1_29 > 0 then
			var0_29[iter0_29] = var1_0[iter0_29][1]
		elseif iter1_29 < 0 then
			var0_29[iter0_29] = var1_0[iter0_29][2]
		else
			var0_29[iter0_29] = ""
		end
	end

	return var0_29[1] .. var0_29[2]
end

function var0_0.GetFourDirMark(arg0_30)
	local var0_30 = {}
	local var1_30 = arg0_30.y * arg0_30.y < arg0_30.x * arg0_30.x and {
		0,
		arg0_30.x
	} or {
		arg0_30.y,
		0
	}

	for iter0_30, iter1_30 in ipairs(var1_30) do
		if iter1_30 > 0 then
			var0_30[iter0_30] = var1_0[iter0_30][1]
		elseif iter1_30 < 0 then
			var0_30[iter0_30] = var1_0[iter0_30][2]
		else
			var0_30[iter0_30] = ""
		end
	end

	return var0_30[1] .. var0_30[2]
end

function var0_0.GetDestroyPoint(arg0_31)
	local var0_31 = 0

	if arg0_31.class == TargetItem then
		switch(arg0_31.type, {
			bomb = function()
				var0_31 = 50
			end,
			power = function()
				var0_31 = 50
			end,
			speed = function()
				var0_31 = 50
			end,
			hp1 = function()
				var0_31 = 100
			end,
			hp2 = function()
				var0_31 = 200
			end,
			spirit = function()
				var0_31 = 300
			end
		})
	elseif isa(arg0_31, TargetObject) then
		switch(arg0_31.class, {
			[ObjectBreakable] = function()
				var0_31 = 20
			end,
			[ObjectRockB] = function()
				var0_31 = 50
			end,
			[ObjectTreasureN] = function()
				var0_31 = 200
			end,
			[ObjectTreasureR] = function()
				var0_31 = 500
			end
		})
	elseif isa(arg0_31, MoveEnemy) then
		switch(arg0_31.class, {
			[EnemyScavenger] = function()
				var0_31 = 100
			end,
			[EnemyBossScavenger] = function()
				var0_31 = 300
			end,
			[EnemyChaser] = function()
				var0_31 = 100
			end,
			[EnemyBossChaser] = function()
				var0_31 = 500
			end,
			[EnemyNavigator] = function()
				var0_31 = 150
			end,
			[EnemyBossNavigator] = function()
				var0_31 = 600
			end,
			[EnemySmasher] = function()
				var0_31 = 150
			end,
			[EnemyBossSmasher] = function()
				var0_31 = 500
			end,
			[EnemyConductor] = function()
				var0_31 = 200
			end,
			[EnemyBossConductor] = function()
				var0_31 = 600
			end
		})
	end

	return var0_31
end

function var0_0.GetPassGamePoint(arg0_52)
	return math.floor(10000 / math.log(arg0_52))
end

return var0_0
