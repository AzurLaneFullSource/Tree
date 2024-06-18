local var0_0 = class("ChallengeInfo", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:UpdateChallengeInfo(arg1_1)
end

function var0_0.UpdateChallengeInfo(arg0_2, arg1_2)
	arg0_2._activityMaxScore = arg1_2.activity_max_score
	arg0_2._activityMaxLevel = arg1_2.activity_max_level
	arg0_2._seasonMaxScore = arg1_2.season_max_score
	arg0_2._seasonMaxLevel = arg1_2.season_max_level
	arg0_2._seasonID = arg1_2.season_id
	arg0_2._dungeonList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.dungeon_id_list) do
		table.insert(arg0_2._dungeonList, iter1_2)
	end

	arg0_2._buffList = arg1_2.buff_list
	arg0_2._activityIndex = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE):getConfig("config_id")
end

function var0_0.checkRecord(arg0_3, arg1_3)
	local var0_3 = arg1_3:getMode()
	local var1_3 = arg1_3:getScore()

	if var0_3 == ChallengeProxy.MODE_CASUAL then
		arg0_3._activityMaxScore = math.max(var1_3, arg0_3._activityMaxScore)
		arg0_3._seasonMaxScore = math.max(var1_3, arg0_3._seasonMaxScore)
	end

	local var2_3 = arg1_3:getLevel() - 1

	arg0_3._activityMaxLevel = math.max(var2_3, arg0_3._activityMaxLevel)
	arg0_3._seasonMaxLevel = math.max(var2_3, arg0_3._seasonMaxLevel)
end

function var0_0.getGradeList(arg0_4)
	return {
		activityMaxScore = arg0_4._activityMaxScore,
		activityMaxLevel = arg0_4._activityMaxLevel,
		seasonMaxScore = arg0_4._seasonMaxScore,
		seasonMaxLevel = arg0_4._seasonMaxLevel
	}
end

function var0_0.getSeasonID(arg0_5)
	return arg0_5._seasonID
end

function var0_0.getDungeonIDList(arg0_6)
	return Clone(arg0_6._dungeonList)
end

function var0_0.getActivityIndex(arg0_7)
	return arg0_7._activityIndex
end

return var0_0
