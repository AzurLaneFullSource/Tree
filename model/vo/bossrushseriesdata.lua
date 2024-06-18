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

function var0_0.GetFleets(arg0_12)
	return (getProxy(FleetProxy):GetBossRushFleets(arg0_12.actId, arg0_12:GetFleetIds()))
end

function var0_0.GetExpeditionIds(arg0_13)
	return arg0_13:getConfig("expedition_id")
end

function var0_0.GetFleetIds(arg0_14)
	if arg0_14.fleetIds then
		return arg0_14.fleetIds
	end

	local var0_14 = arg0_14:GetExpeditionIds()

	arg0_14.fleetIds = arg0_14.StaticCalculateFleetIds(arg0_14.id, #var0_14)

	return arg0_14.fleetIds
end

function var0_0.GetType(arg0_15)
	return arg0_15:getConfig("type")
end

function var0_0.GetPreSeriesId(arg0_16)
	return arg0_16:getConfig("pre_chapter")
end

function var0_0.IsUnlock(arg0_17, arg1_17)
	local var0_17 = arg0_17:GetPreSeriesId()

	return var0_17 == 0 or arg1_17:HasPassSeries(var0_17)
end

function var0_0.GetSeriesCode(arg0_18)
	return arg0_18:getConfig("chapter_name")
end

function var0_0.GetName(arg0_19)
	return arg0_19:getConfig("name")
end

function var0_0.GetLimitations(arg0_20)
	return arg0_20:getConfig("limitation")
end

function var0_0.GetOilCost(arg0_21)
	return arg0_21:getConfig("oil")
end

function var0_0.GetDescription(arg0_22)
	return arg0_22:getConfig("profiles")
end

function var0_0.IsSingleFight(arg0_23)
	return arg0_23:getConfig("whether_singlefight") == 1
end

function var0_0.GetBossIcons(arg0_24)
	return arg0_24:getConfig("boss_icon")
end

function var0_0.GetPassAwards(arg0_25)
	return arg0_25:getConfig("pass_awards_display")
end

function var0_0.GetAdditionalAwards(arg0_26)
	return arg0_26:getConfig("additional_awards_display")
end

function var0_0.GetDefeatStories(arg0_27)
	return arg0_27:getConfig("defeat_story")
end

function var0_0.GetDefeatStoriesCount(arg0_28)
	return arg0_28:getConfig("defeat_story_count")
end

function var0_0.GetMaxBonusCount(arg0_29)
	return arg0_29:getConfig("count")
end

function var0_0.GetOilLimit(arg0_30)
	return arg0_30:getConfig("use_oil_limit")
end

function var0_0.GetEXParamater(arg0_31)
	return arg0_31:getConfig("ex_count")
end

function var0_0.StaticCalculateFleetIds(arg0_32, arg1_32)
	assert(arg1_32 <= 10, "expedition List Too long")

	return _.map(_.range(arg1_32 + 1), function(arg0_33)
		return arg0_32 * 10 + arg0_33 - 1
	end)
end

return var0_0
