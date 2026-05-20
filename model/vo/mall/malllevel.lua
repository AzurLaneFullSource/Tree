local var0_0 = class("MallLevel", import("model.vo.BaseVO"))

var0_0.CONDITION_TYPE = {
	ROUND = 1,
	ROUND_INCOME = 2,
	FLOOR_INCOME = 4,
	ORDER = 3
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.level = arg1_1

	arg0_1:InitLevelConfig()

	arg0_1.level = math.min(arg0_1.level, arg0_1.maxLevel)
	arg0_1.id = arg0_1.level2Id[arg0_1.level]
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_mall_level
end

function var0_0.InitLevelConfig(arg0_3)
	arg0_3.level2Id = {}
	arg0_3.maxLevel = 0

	for iter0_3, iter1_3 in ipairs(pg.activity_mall_level.all) do
		local var0_3 = pg.activity_mall_level[iter1_3]

		arg0_3.level2Id[var0_3.lv] = iter1_3
		arg0_3.maxLevel = math.max(arg0_3.maxLevel, var0_3.lv)
	end
end

function var0_0.IsMaxLevel(arg0_4)
	return arg0_4.level == arg0_4.maxLevel
end

function var0_0.OnUpgradeDone(arg0_5, arg1_5)
	arg0_5.level = math.min(arg1_5, arg0_5.maxLevel)
	arg0_5.id = arg0_5.level2Id[arg0_5.level]
	arg0_5.configId = arg0_5.id
end

function var0_0.GetReachLevelIds(arg0_6, arg1_6)
	local var0_6 = {}

	for iter0_6 = 1, arg0_6.level do
		table.insert(var0_6, arg0_6.level2Id[iter0_6])
	end

	return var0_6
end

function var0_0.GetUnlockStoryIds(arg0_7)
	local var0_7 = {}
	local var1_7 = arg0_7:bindConfigTable()

	for iter0_7, iter1_7 in ipairs(arg0_7:GetReachLevelIds()) do
		local var2_7 = var1_7[iter1_7].unlock_param

		var0_7 = table.mergeArray(var0_7, var2_7.story_id, true)
	end

	return var0_7
end

function var0_0.GetUnlockStoryIdsByType(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8:GetUnlockStoryIds()) do
		local var1_8 = pg.activity_mall_story[iter1_8]

		if var1_8 then
			local var2_8 = var1_8.type

			var0_8[var2_8] = var0_8[var2_8] or {}

			table.insert(var0_8[var2_8], iter1_8)
		end
	end

	for iter2_8, iter3_8 in pairs(var0_8) do
		table.sort(iter3_8, function(arg0_9, arg1_9)
			return arg0_9 < arg1_9
		end)
	end

	return var0_8
end

function var0_0.GetIdByLevel(arg0_10)
	return underscore.detect(pg.activity_mall_level.all, function(arg0_11)
		return pg.activity_mall_level[arg0_11].lv == arg0_10
	end)
end

function var0_0.GetShowInfos(arg0_12)
	local var0_12 = pg.activity_mall_level[arg0_12].round_show
	local var1_12 = {}

	for iter0_12, iter1_12 in ipairs(var0_12) do
		table.insert(var1_12, iter1_12[2])
	end

	local var2_12 = var0_12[getRandomIdxByWeights(var1_12)]

	return {
		skinId = var2_12[1],
		wordList = var2_12[3]
	}
end

return var0_0
