local var0_0 = class("CollabrateBossRushSeriesData", import("model.vo.baseVO"))
local var1_0 = pg.activity_series_enemy
local var2_0 = pg.extraenemy_template

function var0_0.bindConfigTable(arg0_1)
	return pg.extraenemy_series_template
end

var0_0.DIFF = {
	NORMAL = 1,
	HARD = 2
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
	arg0_2.deathTimeStamp = 0
	arg0_2.bossHpRate = 0
	arg0_2.trafficPerHour = 0
	arg0_2.damagePerHour = 0
	arg0_2.actId = arg1_2.actId
	arg0_2.diff = 1
end

function var0_0.UpdateCollabBossData(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.bossHpRate = arg1_3 / 10000
	arg0_3.deathTimeStamp = arg2_3
	arg0_3.trafficPerHour = arg3_3
	arg0_3.damagePerHour = arg4_3 / 10000
end

function var0_0.GetBossHpRate(arg0_4)
	return arg0_4.bossHpRate
end

function var0_0.GetDefeated(arg0_5, arg1_5)
	return arg1_5:HasPlayerDefeatSeries(arg0_5.configId)
end

function var0_0.GetBossTimeStamp(arg0_6)
	return arg0_6.deathTimeStamp
end

function var0_0.GetTrafficPerH(arg0_7)
	return arg0_7.trafficPerHour
end

function var0_0.GetDamagePerH(arg0_8)
	return arg0_8.damagePerHour
end

function var0_0.PassStage(arg0_9, arg1_9)
	table.insert(arg0_9.battleStatistics, arg1_9)

	arg0_9.stageLevel = arg0_9.stageLevel + 1
end

function var0_0.GetBattleStatistics(arg0_10)
	return arg0_10.battleStatistics
end

function var0_0.GetStaegLevel(arg0_11)
	return arg0_11.stageLevel
end

function var0_0.GetNextStage(arg0_12)
	return {
		stageId = 1
	}
end

function var0_0.GetMode(arg0_13)
	assert(arg0_13.mode)

	return arg0_13.mode
end

function var0_0.AddFinalResults(arg0_14, arg1_14)
	arg0_14.battleResults = arg1_14
end

function var0_0.GetFinalResults(arg0_15)
	return arg0_15.battleResults
end

function var0_0.AddEXScore(arg0_16, arg1_16)
	arg0_16.exScores = arg0_16.exScores or {}

	table.insert(arg0_16.exScores, arg1_16.score)
end

function var0_0.GetEXScores(arg0_17)
	return arg0_17.exScores or {}
end

function var0_0.GetFleets(arg0_18)
	return (getProxy(FleetProxy):GetBossRushFleets(arg0_18.actId, arg0_18:GetFleetIds()))
end

function var0_0.GetExpeditionIds(arg0_19)
	local var0_19 = arg0_19:getConfig("activity_series_enemy_id")[arg0_19.diff]

	return var1_0[var0_19].expedition_id
end

function var0_0.GetFleetIds(arg0_20)
	if arg0_20.fleetIds then
		return arg0_20.fleetIds
	end

	local var0_20 = arg0_20:GetExpeditionIds()

	arg0_20.fleetIds = arg0_20.StaticCalculateFleetIds(arg0_20.id, #var0_20)

	return arg0_20.fleetIds
end

function var0_0.GetStorys(arg0_21)
	local var0_21 = {}
	local var1_21 = arg0_21.bossHpRate * 100

	for iter0_21, iter1_21 in ipairs(arg0_21:getConfig("story_worldboss")) do
		if iter1_21[2] ~= 100 and var1_21 <= iter1_21[2] then
			table.insert(var0_21, iter1_21[1])
		end
	end

	return var0_21
end

function var0_0.GetInitStory(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22:getConfig("story_worldboss")) do
		if iter1_22[2] == 100 then
			return iter1_22[1]
		end
	end
end

function var0_0.GetType(arg0_23)
	return 1
end

function var0_0.GetPreSeriesId(arg0_24)
	return arg0_24:getConfig("pre_chapter")
end

function var0_0.IsPlayerUnlock(arg0_25, arg1_25)
	local var0_25 = arg0_25:GetPreSeriesId()

	if #var0_25 == 0 or var0_25[1] == 0 then
		return true
	else
		local var1_25 = true

		for iter0_25, iter1_25 in ipairs(var0_25) do
			var1_25 = var1_25 and arg1_25:HasPassSeries(iter1_25) and arg1_25:HasPlayerDefeatSeries(iter1_25)
		end

		return var1_25
	end

	return unlock
end

function var0_0.IsUnlock(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetPreSeriesId()

	if #var0_26 == 0 or var0_26[1] == 0 then
		return true
	else
		local var1_26 = true

		for iter0_26, iter1_26 in ipairs(var0_26) do
			var1_26 = var1_26 and arg1_26:HasPassSeries(iter1_26)
		end

		return var1_26
	end

	return unlock
end

function var0_0.IsPass(arg0_27)
	return arg0_27.deathTimeStamp ~= 0
end

function var0_0.GetCurrentProfile(arg0_28)
	local var0_28 = arg0_28:getConfig("profile_pre")
	local var1_28 = arg0_28.bossHpRate * 100
	local var2_28 = 1
	local var3_28 = #var0_28 - 1

	while var2_28 <= var3_28 do
		local var4_28 = var0_28[var2_28]
		local var5_28 = var0_28[var2_28 + 1]
		local var6_28 = var4_28[2]
		local var7_28 = var5_28[2]

		if var1_28 <= var6_28 and var7_28 < var1_28 then
			break
		end

		var2_28 = var2_28 + 1
	end

	return var0_28[var2_28][1], var0_28[var2_28][3]
end

function var0_0.SetDifficulty(arg0_29, arg1_29)
	arg0_29.diff = arg1_29
end

function var0_0.GetDifficulty(arg0_30)
	return arg0_30.diff
end

function var0_0.GetSeriesCode(arg0_31)
	return arg0_31:getConfig("chapter_name")
end

function var0_0.GetSeriesName(arg0_32)
	return arg0_32:getConfig("chapter_name2")
end

function var0_0.GetCollabBossID(arg0_33)
	return arg0_33:getConfig("boss_id")[1]
end

function var0_0.GetActivitySeriesID(arg0_34, arg1_34)
	local var0_34 = arg1_34 or arg0_34.diff

	return arg0_34:getConfig("activity_series_enemy_id")[var0_34]
end

function var0_0.GetName(arg0_35, arg1_35)
	local var0_35 = arg0_35:GetActivitySeriesID(arg1_35)

	return var1_0[var0_35].name
end

function var0_0.GetReplaceTaskIDList(arg0_36)
	local var0_36 = arg0_36:getConfig("boss_id")[1]

	return var2_0[var0_36].replace_task
end

function var0_0.GetRewardDisplay(arg0_37)
	local var0_37 = arg0_37:getConfig("boss_id")[1]

	return var2_0[var0_37].reward_display
end

function var0_0.GetLimitations(arg0_38, arg1_38)
	local var0_38 = arg0_38:GetActivitySeriesID(arg1_38)

	return var1_0[var0_38].limitation
end

function var0_0.GetOilCost(arg0_39, arg1_39)
	local var0_39 = arg0_39:GetActivitySeriesID(arg1_39)

	return var1_0[var0_39].oil
end

function var0_0.GetDescription(arg0_40, arg1_40)
	local var0_40 = arg0_40:GetActivitySeriesID(arg1_40)

	return var1_0[var0_40].profiles
end

function var0_0.IsSingleFight(arg0_41, arg1_41)
	local var0_41 = arg0_41:GetActivitySeriesID(arg1_41)

	return var1_0[var0_41].whether_singlefight == 1
end

function var0_0.GetBossIcons(arg0_42, arg1_42)
	local var0_42 = arg0_42:GetActivitySeriesID(arg1_42)

	return var1_0[var0_42].boss_icon
end

function var0_0.GetPassAwards(arg0_43, arg1_43)
	local var0_43 = arg0_43:GetActivitySeriesID(arg1_43)

	return var1_0[var0_43].pass_awards_display
end

function var0_0.GetAdditionalAwards(arg0_44, arg1_44)
	local var0_44 = arg0_44:GetActivitySeriesID(arg1_44)

	return var1_0[var0_44].additional_awards_display
end

function var0_0.GetDefeatStories(arg0_45, arg1_45)
	local var0_45 = arg0_45:GetActivitySeriesID(arg1_45)

	return var1_0[var0_45].defeat_story
end

function var0_0.GetDefeatStoriesCount(arg0_46, arg1_46)
	local var0_46 = arg0_46:GetActivitySeriesID(arg1_46)

	return var1_0[var0_46].defeat_story_count
end

function var0_0.GetMaxBonusCount(arg0_47, arg1_47)
	local var0_47 = arg0_47:GetActivitySeriesID(arg1_47)

	return var1_0[var0_47].count
end

function var0_0.GetOilLimit(arg0_48, arg1_48)
	local var0_48 = arg0_48:GetActivitySeriesID(arg1_48)

	return var1_0[var0_48].use_oil_limit
end

function var0_0.GetEXParamater(arg0_49, arg1_49)
	local var0_49 = arg0_49:GetActivitySeriesID(arg1_49)

	return var1_0[var0_49].ex_count
end

function var0_0.StaticCalculateFleetIds(arg0_50, arg1_50)
	assert(arg1_50 <= 10, "expedition List Too long")

	return _.map(_.range(arg1_50 + 1), function(arg0_51)
		return arg0_50 * 10 + arg0_51 - 1
	end)
end

return var0_0
