local var0 = class("ChallengeInfo", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0:UpdateChallengeInfo(arg1)
end

function var0.UpdateChallengeInfo(arg0, arg1)
	arg0._activityMaxScore = arg1.activity_max_score
	arg0._activityMaxLevel = arg1.activity_max_level
	arg0._seasonMaxScore = arg1.season_max_score
	arg0._seasonMaxLevel = arg1.season_max_level
	arg0._seasonID = arg1.season_id
	arg0._dungeonList = {}

	for iter0, iter1 in ipairs(arg1.dungeon_id_list) do
		table.insert(arg0._dungeonList, iter1)
	end

	arg0._buffList = arg1.buff_list
	arg0._activityIndex = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE):getConfig("config_id")
end

function var0.checkRecord(arg0, arg1)
	local var0 = arg1:getMode()
	local var1 = arg1:getScore()

	if var0 == ChallengeProxy.MODE_CASUAL then
		arg0._activityMaxScore = math.max(var1, arg0._activityMaxScore)
		arg0._seasonMaxScore = math.max(var1, arg0._seasonMaxScore)
	end

	local var2 = arg1:getLevel() - 1

	arg0._activityMaxLevel = math.max(var2, arg0._activityMaxLevel)
	arg0._seasonMaxLevel = math.max(var2, arg0._seasonMaxLevel)
end

function var0.getGradeList(arg0)
	return {
		activityMaxScore = arg0._activityMaxScore,
		activityMaxLevel = arg0._activityMaxLevel,
		seasonMaxScore = arg0._seasonMaxScore,
		seasonMaxLevel = arg0._seasonMaxLevel
	}
end

function var0.getSeasonID(arg0)
	return arg0._seasonID
end

function var0.getDungeonIDList(arg0)
	return Clone(arg0._dungeonList)
end

function var0.getActivityIndex(arg0)
	return arg0._activityIndex
end

return var0
