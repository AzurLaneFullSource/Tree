local var0 = class("UserChallengeInfo", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0:UpdateChallengeInfo(arg1)
end

function var0.UpdateChallengeInfo(arg0, arg1)
	arg0._score = arg1.current_score
	arg0._level = arg1.level
	arg0._mode = arg1.mode
	arg0._resetflag = arg1.issl
	arg0._seasonIndex = arg1.season_id
	arg0._dungeonIDList = {}

	for iter0, iter1 in ipairs(arg1.dungeon_id_list) do
		table.insert(arg0._dungeonIDList, iter1)
	end

	arg0._activityIndex = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE):getConfig("config_id")

	if arg0._mode == ChallengeProxy.MODE_INFINITE then
		arg0:setInfiniteDungeonIDListByLevel()
	end

	arg0._fleetList = {}

	for iter2, iter3 in ipairs(arg1.groupinc_list) do
		arg0:updateChallengeFleet(iter3)
	end

	arg0._buffList = {}

	for iter4, iter5 in ipairs(arg1.buff_list) do
		table.insert(arg0._buffList, iter5)
	end

	arg0._lastScore = 0
end

function var0.updateChallengeFleet(arg0, arg1)
	local var0 = Challenge2Fleet.New(arg1)

	if var0:isSubmarineFleet() then
		arg0._submarineFleet = var0
	else
		arg0._fleet = var0
	end
end

function var0.updateCombatScore(arg0, arg1)
	arg0._lastScore = arg1
	arg0._score = arg0._score + arg1
end

function var0.updateLevelForward(arg0)
	arg0._level = arg0._level + 1
end

function var0.updateShipHP(arg0, arg1, arg2)
	if not (arg0._fleet:updateShipsHP(arg1, arg2) or arg0._submarineFleet:updateShipsHP(arg1, arg2)) then
		assert(false, "challenge unit not exist")
	end
end

function var0.getRegularFleet(arg0)
	return arg0._fleet
end

function var0.getSubmarineFleet(arg0)
	return arg0._submarineFleet
end

function var0.getShipUIDList(arg0)
	local var0 = {}
	local var1 = arg0._fleet:getShips(false)

	for iter0, iter1 in ipairs(var1) do
		table.insert(var0, iter1.id)
	end

	local var2 = arg0._submarineFleet:getShips(false)

	for iter2, iter3 in ipairs(var2) do
		table.insert(var0, iter3.id)
	end

	return var0
end

function var0.getLevel(arg0)
	return arg0._level
end

function var0.getRound(arg0)
	return math.ceil(arg0._level / #arg0._dungeonIDList)
end

function var0.getMode(arg0)
	return arg0._mode
end

function var0.getDungeonIDList(arg0)
	return Clone(arg0._dungeonIDList)
end

function var0.getSeasonID(arg0)
	return arg0._seasonIndex
end

function var0.getResetFlag(arg0)
	return arg0._resetflag
end

function var0.getScore(arg0)
	return arg0._score
end

function var0.getLastScore(arg0)
	return arg0._lastScore
end

function var0.getActivityIndex(arg0)
	return arg0._activityIndex
end

function var0.getNextExpedition(arg0)
	local var0 = arg0._level % ChallengeConst.BOSS_NUM

	if var0 == 0 then
		var0 = ChallengeConst.BOSS_NUM
	end

	local var1 = arg0._dungeonIDList[var0]

	return pg.expedition_challenge_template[var1]
end

function var0.setInfiniteDungeonIDListByLevel(arg0)
	local var0 = arg0._level - 1
	local var1 = math.modf(var0 / ChallengeConst.BOSS_NUM) + 1
	local var2 = #pg.activity_event_challenge[arg0._activityIndex].infinite_stage[arg0._seasonIndex]
	local var3 = var1 % var2

	if var3 == 0 then
		var3 = var2
	end

	arg0._dungeonIDList = pg.activity_event_challenge[arg0._activityIndex].infinite_stage[arg0._seasonIndex][var3]
end

function var0.getNextInfiniteDungeonIDList(arg0)
	local var0 = arg0._level - 1
	local var1 = (math.modf(var0 / ChallengeConst.BOSS_NUM) + 1) % #pg.activity_event_challenge[arg0._activityIndex].infinite_stage[arg0._seasonIndex] + 1

	return pg.activity_event_challenge[arg0._activityIndex].infinite_stage[arg0._seasonIndex][var1]
end

function var0.getNextStageID(arg0)
	return arg0:getNextExpedition().dungeon_id
end

function var0.IsFinish(arg0)
	if arg0._level % #arg0._dungeonIDList == 0 then
		return true
	else
		return false
	end
end

return var0
