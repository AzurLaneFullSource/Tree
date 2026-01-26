local var0_0 = class("BossRushSeriesData", import("model.vo.baseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_series_enemy
end

var0_0.ENERGY_WARN = 30
var0_0.TYPE = {
	EXTRA = 3,
	NORMAL = 1,
	SP = 2
}
var0_0.MODE = {
	SINGLE = 1,
	MULTIPLE = 2
}

function var0_0.Ctor(arg0_2, arg1_2)
	var0_0.super.Ctor(arg0_2, arg1_2)

	arg0_2.configId = arg0_2.id
	arg0_2.stageLevel = 0
	arg0_2.battleStatistics = {}
end

function var0_0.PassStage(arg0_3, arg1_3)
	table.insert(arg0_3.battleStatistics, arg1_3)

	arg0_3.stageLevel = arg0_3.stageLevel + 1
end

function var0_0.GetBattleStatistics(arg0_4)
	return arg0_4.battleStatistics
end

function var0_0.GetStaegLevel(arg0_5)
	return arg0_5.stageLevel
end

function var0_0.GetNextStage(arg0_6)
	return {
		stageId = 1
	}
end

function var0_0.GetMode(arg0_7)
	assert(arg0_7.mode)

	return arg0_7.mode
end

function var0_0.AddFinalResults(arg0_8, arg1_8)
	arg0_8.battleResults = arg1_8
end

function var0_0.GetFinalResults(arg0_9)
	return arg0_9.battleResults
end

function var0_0.AddEXScore(arg0_10, arg1_10)
	arg0_10.exScores = arg0_10.exScores or {}

	table.insert(arg0_10.exScores, arg1_10.score)
end

function var0_0.GetEXScores(arg0_11)
	return arg0_11.exScores or {}
end

function var0_0.GetFleets(arg0_12, arg1_12)
	return getProxy(FleetProxy):GetBossRushFleets(arg0_12.actId, arg1_12 or arg0_12:GetFleetIds())
end

function var0_0.CopyFleetsByOther(arg0_13, arg1_13)
	local var0_13 = arg1_13:GetFleets()
	local var1_13 = arg0_13:GetFleetIds()

	for iter0_13 = 1, #var0_13 - 1 do
		assert(var1_13[iter0_13])

		local var2_13 = TypedFleet.New(setmetatable({
			id = var1_13[iter0_13]
		}, {
			__index = var0_13[iter0_13]:SeparateOut()
		}))

		if iter0_13 == 1 and not arg0_13:IsSingleFight() then
			var2_13:allClear()
		end

		getProxy(FleetProxy):updateActivityFleet(arg0_13.actId, var1_13[iter0_13], var2_13)
	end

	getProxy(FleetProxy):updateActivityFleet(arg0_13.actId, var1_13[#var1_13], TypedFleet.New(setmetatable({
		id = var1_13[#var1_13]
	}, {
		__index = var0_13[#var0_13]:SeparateOut()
	})))
	getProxy(FleetProxy):commitActivityFleet(arg0_13.actId)
end

function var0_0.IsFleetsEmpty(arg0_14)
	return getProxy(FleetProxy):IsBossRushFleetsEmpty(arg0_14.actId, arg0_14:GetFleetIds())
end

function var0_0.GetExpeditionIds(arg0_15)
	return arg0_15:getConfig("expedition_id")
end

function var0_0.GetFleetIds(arg0_16)
	if arg0_16.fleetIds then
		return arg0_16.fleetIds
	end

	local var0_16 = arg0_16:GetExpeditionIds()

	arg0_16.fleetIds = arg0_16.StaticCalculateFleetIds(arg0_16.id, #var0_16)

	return arg0_16.fleetIds
end

function var0_0.GetModeFleetIDs(arg0_17, arg1_17)
	local var0_17 = arg0_17:GetFleetIds()
	local var1_17
	local var2_17

	if arg1_17 == var0_0.MODE.SINGLE then
		var1_17 = {
			var0_17[1]
		}
		var2_17 = {
			var0_17[#var0_17]
		}
	elseif arg1_17 == var0_0.MODE.MULTIPLE then
		var1_17 = underscore.rest(var0_17)
		var2_17 = {
			table.remove(var1_17)
		}
	else
		assert(false)
	end

	return var1_17, var2_17
end

function var0_0.GetStageFleets(arg0_18, arg1_18, arg2_18)
	local var0_18, var1_18 = arg0_18:GetModeFleetIDs(arg1_18)

	return var0_18[arg2_18] or var0_18[1], var1_18[1]
end

function var0_0.GetType(arg0_19)
	return arg0_19:getConfig("type")
end

function var0_0.GetPreSeriesId(arg0_20)
	return arg0_20:getConfig("pre_chapter")
end

function var0_0.IsUnlock(arg0_21, arg1_21)
	local var0_21 = arg0_21:GetPreSeriesId()

	return var0_21 == 0 or arg1_21:HasPassSeries(var0_21)
end

function var0_0.GetSeriesCode(arg0_22)
	return arg0_22:getConfig("chapter_name")
end

function var0_0.GetName(arg0_23)
	return arg0_23:getConfig("name")
end

function var0_0.GetLimitations(arg0_24)
	return arg0_24:getConfig("limitation")
end

function var0_0.GetOilCost(arg0_25)
	return arg0_25:getConfig("oil")
end

function var0_0.GetDescription(arg0_26)
	return arg0_26:getConfig("profiles")
end

function var0_0.IsSingleFight(arg0_27)
	return arg0_27:getConfig("whether_singlefight") == 1
end

function var0_0.GetBossIcons(arg0_28)
	return arg0_28:getConfig("boss_icon")
end

function var0_0.GetPassAwards(arg0_29)
	return arg0_29:getConfig("pass_awards_display")
end

function var0_0.GetAdditionalAwards(arg0_30)
	return arg0_30:getConfig("additional_awards_display")
end

function var0_0.GetDefeatStories(arg0_31)
	return arg0_31:getConfig("defeat_story")
end

function var0_0.GetDefeatStoriesCount(arg0_32)
	return arg0_32:getConfig("defeat_story_count")
end

function var0_0.GetMaxBonusCount(arg0_33)
	return arg0_33:getConfig("count")
end

function var0_0.GetOilLimit(arg0_34)
	return arg0_34:getConfig("use_oil_limit")
end

function var0_0.GetEXParamater(arg0_35)
	return arg0_35:getConfig("ex_count")
end

function var0_0.StaticCalculateFleetIds(arg0_36, arg1_36)
	assert(arg1_36 <= 10, "expedition List Too long")

	return underscore.map(_.range(0, arg1_36 + 1), function(arg0_37)
		return arg0_36 * 10 + arg0_37
	end)
end

return var0_0
