local var0_0 = class("UserChallengeInfo", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:UpdateChallengeInfo(arg1_1)
end

function var0_0.UpdateChallengeInfo(arg0_2, arg1_2)
	arg0_2._score = arg1_2.current_score
	arg0_2._level = arg1_2.level
	arg0_2._mode = arg1_2.mode
	arg0_2._resetflag = arg1_2.issl
	arg0_2._seasonIndex = arg1_2.season_id
	arg0_2._dungeonIDList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.dungeon_id_list) do
		table.insert(arg0_2._dungeonIDList, iter1_2)
	end

	arg0_2._activityIndex = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE):getConfig("config_id")

	if arg0_2._mode == ChallengeProxy.MODE_INFINITE then
		arg0_2:setInfiniteDungeonIDListByLevel()
	end

	arg0_2._fleetList = {}

	for iter2_2, iter3_2 in ipairs(arg1_2.groupinc_list) do
		arg0_2:updateChallengeFleet(iter3_2)
	end

	arg0_2._buffList = {}

	for iter4_2, iter5_2 in ipairs(arg1_2.buff_list) do
		table.insert(arg0_2._buffList, iter5_2)
	end

	arg0_2._lastScore = 0
end

function var0_0.updateChallengeFleet(arg0_3, arg1_3)
	local var0_3 = Challenge2Fleet.New(arg1_3)

	if var0_3:isSubmarineFleet() then
		arg0_3._submarineFleet = var0_3
	else
		arg0_3._fleet = var0_3
	end
end

function var0_0.updateCombatScore(arg0_4, arg1_4)
	arg0_4._lastScore = arg1_4
	arg0_4._score = arg0_4._score + arg1_4
end

function var0_0.updateLevelForward(arg0_5)
	arg0_5._level = arg0_5._level + 1
end

function var0_0.updateShipHP(arg0_6, arg1_6, arg2_6)
	if not (arg0_6._fleet:updateShipsHP(arg1_6, arg2_6) or arg0_6._submarineFleet:updateShipsHP(arg1_6, arg2_6)) then
		assert(false, "challenge unit not exist")
	end
end

function var0_0.getRegularFleet(arg0_7)
	return arg0_7._fleet
end

function var0_0.getSubmarineFleet(arg0_8)
	return arg0_8._submarineFleet
end

function var0_0.getShipUIDList(arg0_9)
	local var0_9 = {}
	local var1_9 = arg0_9._fleet:getShips(false)

	for iter0_9, iter1_9 in ipairs(var1_9) do
		table.insert(var0_9, iter1_9.id)
	end

	local var2_9 = arg0_9._submarineFleet:getShips(false)

	for iter2_9, iter3_9 in ipairs(var2_9) do
		table.insert(var0_9, iter3_9.id)
	end

	return var0_9
end

function var0_0.getLevel(arg0_10)
	return arg0_10._level
end

function var0_0.getRound(arg0_11)
	return math.ceil(arg0_11._level / #arg0_11._dungeonIDList)
end

function var0_0.getMode(arg0_12)
	return arg0_12._mode
end

function var0_0.getDungeonIDList(arg0_13)
	return Clone(arg0_13._dungeonIDList)
end

function var0_0.getSeasonID(arg0_14)
	return arg0_14._seasonIndex
end

function var0_0.getResetFlag(arg0_15)
	return arg0_15._resetflag
end

function var0_0.getScore(arg0_16)
	return arg0_16._score
end

function var0_0.getLastScore(arg0_17)
	return arg0_17._lastScore
end

function var0_0.getActivityIndex(arg0_18)
	return arg0_18._activityIndex
end

function var0_0.getNextExpedition(arg0_19)
	local var0_19 = arg0_19._level % ChallengeConst.BOSS_NUM

	if var0_19 == 0 then
		var0_19 = ChallengeConst.BOSS_NUM
	end

	local var1_19 = arg0_19._dungeonIDList[var0_19]

	return pg.expedition_challenge_template[var1_19]
end

function var0_0.setInfiniteDungeonIDListByLevel(arg0_20)
	local var0_20 = arg0_20._level - 1
	local var1_20 = math.modf(var0_20 / ChallengeConst.BOSS_NUM) + 1
	local var2_20 = #pg.activity_event_challenge[arg0_20._activityIndex].infinite_stage[arg0_20._seasonIndex]
	local var3_20 = var1_20 % var2_20

	if var3_20 == 0 then
		var3_20 = var2_20
	end

	arg0_20._dungeonIDList = pg.activity_event_challenge[arg0_20._activityIndex].infinite_stage[arg0_20._seasonIndex][var3_20]
end

function var0_0.getNextInfiniteDungeonIDList(arg0_21)
	local var0_21 = arg0_21._level - 1
	local var1_21 = (math.modf(var0_21 / ChallengeConst.BOSS_NUM) + 1) % #pg.activity_event_challenge[arg0_21._activityIndex].infinite_stage[arg0_21._seasonIndex] + 1

	return pg.activity_event_challenge[arg0_21._activityIndex].infinite_stage[arg0_21._seasonIndex][var1_21]
end

function var0_0.getNextStageID(arg0_22)
	return arg0_22:getNextExpedition().dungeon_id
end

function var0_0.IsFinish(arg0_23)
	if arg0_23._level % #arg0_23._dungeonIDList == 0 then
		return true
	else
		return false
	end
end

return var0_0
