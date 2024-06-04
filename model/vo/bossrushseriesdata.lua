local var0 = class("BossRushSeriesData", import("model.vo.baseVO"))

function var0.bindConfigTable(arg0)
	return pg.activity_series_enemy
end

var0.ENERGY_WARN = 30
var0.TYPE = {
	EXTRA = 3,
	NORMAL = 1,
	SP = 2
}
var0.MODE = {
	SINGLE = 1,
	MULTIPLE = 2
}

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.configId = arg0.id
	arg0.stageLevel = 0
	arg0.battleStatistics = {}
end

function var0.PassStage(arg0, arg1)
	table.insert(arg0.battleStatistics, arg1)

	arg0.stageLevel = arg0.stageLevel + 1
end

function var0.GetBattleStatistics(arg0)
	return arg0.battleStatistics
end

function var0.GetStaegLevel(arg0)
	return arg0.stageLevel
end

function var0.GetNextStage(arg0)
	return {
		stageId = 1
	}
end

function var0.GetMode(arg0)
	assert(arg0.mode)

	return arg0.mode
end

function var0.AddFinalResults(arg0, arg1)
	arg0.battleResults = arg1
end

function var0.GetFinalResults(arg0)
	return arg0.battleResults
end

function var0.AddEXScore(arg0, arg1)
	arg0.exScores = arg0.exScores or {}

	table.insert(arg0.exScores, arg1.score)
end

function var0.GetEXScores(arg0)
	return arg0.exScores or {}
end

function var0.GetFleets(arg0)
	return (getProxy(FleetProxy):GetBossRushFleets(arg0.actId, arg0:GetFleetIds()))
end

function var0.GetExpeditionIds(arg0)
	return arg0:getConfig("expedition_id")
end

function var0.GetFleetIds(arg0)
	if arg0.fleetIds then
		return arg0.fleetIds
	end

	local var0 = arg0:GetExpeditionIds()

	arg0.fleetIds = arg0.StaticCalculateFleetIds(arg0.id, #var0)

	return arg0.fleetIds
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetPreSeriesId(arg0)
	return arg0:getConfig("pre_chapter")
end

function var0.IsUnlock(arg0, arg1)
	local var0 = arg0:GetPreSeriesId()

	return var0 == 0 or arg1:HasPassSeries(var0)
end

function var0.GetSeriesCode(arg0)
	return arg0:getConfig("chapter_name")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetLimitations(arg0)
	return arg0:getConfig("limitation")
end

function var0.GetOilCost(arg0)
	return arg0:getConfig("oil")
end

function var0.GetDescription(arg0)
	return arg0:getConfig("profiles")
end

function var0.IsSingleFight(arg0)
	return arg0:getConfig("whether_singlefight") == 1
end

function var0.GetBossIcons(arg0)
	return arg0:getConfig("boss_icon")
end

function var0.GetPassAwards(arg0)
	return arg0:getConfig("pass_awards_display")
end

function var0.GetAdditionalAwards(arg0)
	return arg0:getConfig("additional_awards_display")
end

function var0.GetDefeatStories(arg0)
	return arg0:getConfig("defeat_story")
end

function var0.GetDefeatStoriesCount(arg0)
	return arg0:getConfig("defeat_story_count")
end

function var0.GetMaxBonusCount(arg0)
	return arg0:getConfig("count")
end

function var0.GetOilLimit(arg0)
	return arg0:getConfig("use_oil_limit")
end

function var0.GetEXParamater(arg0)
	return arg0:getConfig("ex_count")
end

function var0.StaticCalculateFleetIds(arg0, arg1)
	assert(arg1 <= 10, "expedition List Too long")

	return _.map(_.range(arg1 + 1), function(arg0)
		return arg0 * 10 + arg0 - 1
	end)
end

return var0
