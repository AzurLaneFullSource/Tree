local var0_0 = class("NewEducateRound", import("model.vo.BaseVO"))

var0_0.TYPE = {
	NORMAL = 1,
	ENDLESS = 2
}

function var0_0.bindConfigTable(arg0_1)
	return pg.child2_round
end

function var0_0.Ctor(arg0_2, arg1_2)
	local var0_2 = arg1_2.id

	arg0_2.difficulty = arg1_2.difficulty

	arg0_2:InitConfig(var0_2)
	arg0_2:InitEndlessConfig(var0_2)

	local var1_2 = arg1_2.round

	arg0_2.round = var1_2.round
	arg0_2.isTemp = var1_2.in_temp == 1
	arg0_2.tempCnt = var1_2.temp_round

	arg0_2:InitRoundId()

	arg0_2.isEndlessFail = arg1_2.eval_fail == 1
end

function var0_0.InitConfig(arg0_3, arg1_3)
	arg0_3.round2Id = {}
	arg0_3.assessRoundIds = {}
	arg0_3.talentRoundIds = {}

	for iter0_3, iter1_3 in ipairs(pg.child2_round.get_id_list_by_character[arg1_3]) do
		local var0_3 = pg.child2_round[iter1_3]

		if var0_3.round_type == var0_0.TYPE.NORMAL and arg0_3.difficulty == var0_3.is_hard_mode then
			arg0_3.round2Id[var0_3.round] = iter1_3

			if var0_3.target_id ~= 0 then
				table.insert(arg0_3.assessRoundIds, var0_3.round)
			end

			if var0_3.benefit_select ~= "" and #var0_3.benefit_select ~= 0 then
				table.insert(arg0_3.talentRoundIds, var0_3.round)
			end
		end
	end

	table.sort(arg0_3.assessRoundIds)
	table.sort(arg0_3.talentRoundIds)

	arg0_3.gameRoundCnt = #underscore.keys(arg0_3.round2Id)
end

function var0_0.InitRoundId(arg0_4)
	if arg0_4:IsEndless() then
		arg0_4:InitEndlessRoundId()
	else
		arg0_4.id = arg0_4.round2Id[arg0_4.round]
		arg0_4.configId = arg0_4.id
	end
end

function var0_0.GetTalentRoundIds(arg0_5)
	return arg0_5.talentRoundIds
end

function var0_0.IsTalentRound(arg0_6)
	return not arg0_6:IsTemp() and table.contains(arg0_6.talentRoundIds, arg0_6.round)
end

function var0_0.IsShowAssessTip(arg0_7)
	if arg0_7.round == 1 then
		return true
	end

	for iter0_7, iter1_7 in ipairs(arg0_7.assessRoundIds) do
		if arg0_7.round == iter1_7 + 1 then
			return true
		end
	end

	return false
end

function var0_0.GetProgressInfo(arg0_8)
	local var0_8 = underscore.detect(arg0_8.assessRoundIds, function(arg0_9)
		return arg0_9 >= arg0_8.round
	end)
	local var1_8 = pg.child2_round[arg0_8.round2Id[var0_8]].target_id

	return arg0_8.round, var0_8 - arg0_8.round, pg.child2_target[var1_8].attr_sum
end

function var0_0.GetGameRoundCnt(arg0_10)
	return arg0_10.gameRoundCnt
end

function var0_0.IsEndRound(arg0_11)
	return not arg0_11.round2Id[arg0_11.round + 1]
end

function var0_0.OnNextRound(arg0_12)
	if arg0_12.tempCnt > 0 then
		arg0_12.tempCnt = arg0_12.tempCnt - 1
		arg0_12.isTemp = true
	else
		arg0_12.isTemp = false
		arg0_12.round = arg0_12.round + 1
	end

	arg0_12:InitRoundId()
end

function var0_0.IsTemp(arg0_13)
	return arg0_13.isTemp
end

function var0_0.NextIsTemp(arg0_14)
	return arg0_14.tempCnt > 0
end

function var0_0.AddTempCnt(arg0_15, arg1_15)
	arg0_15.tempCnt = arg0_15.tempCnt + arg1_15
end

function var0_0.ExistEndless(arg0_16)
	return #arg0_16.cycleIds > 0
end

function var0_0.InitEndlessConfig(arg0_17, arg1_17)
	arg0_17.cycleIds = {}

	for iter0_17, iter1_17 in ipairs(pg.child2_round.get_id_list_by_character[arg1_17]) do
		local var0_17 = pg.child2_round[iter1_17]

		if var0_17.round_type == var0_0.TYPE.ENDLESS and arg0_17.difficulty == var0_17.is_hard_mode then
			table.insert(arg0_17.cycleIds, iter1_17)
		end
	end

	table.sort(arg0_17.cycleIds)

	arg0_17.endlessRoundCnt = #arg0_17.cycleIds
end

function var0_0.InitEndlessRoundId(arg0_18)
	local var0_18 = arg0_18.round - arg0_18.gameRoundCnt

	arg0_18.cycleCnt = 1 + math.floor(var0_18 / arg0_18.endlessRoundCnt)
	arg0_18.cycleIdx = var0_18 % arg0_18.endlessRoundCnt

	if arg0_18.cycleIdx == 0 then
		arg0_18.cycleIdx = #arg0_18.cycleIds
	end

	arg0_18.id = arg0_18.cycleIds[arg0_18.cycleIdx]
	arg0_18.configId = arg0_18.id
end

function var0_0.IsEndless(arg0_19)
	return arg0_19.round > arg0_19.gameRoundCnt
end

function var0_0.GetWave(arg0_20)
	return arg0_20.round - arg0_20.gameRoundCnt
end

function var0_0.IsEndlessFail(arg0_21)
	return arg0_21:IsEndless() and arg0_21.isEndlessFail
end

function var0_0.SetEndlessFail(arg0_22)
	arg0_22.isEndlessFail = true
end

function var0_0.GetHeighestWave(arg0_23)
	return getProxy(NewEducateProxy):GetCurChar():GetPermanentData():GetMaxRound() - arg0_23.gameRoundCnt
end

function var0_0.GetExtraFactor(arg0_24)
	if not arg0_24:IsEndless() then
		return 1
	end

	local var0_24 = arg0_24:getConfig("endless_factor")
	local var1_24 = arg0_24.difficulty == NewEducateChar.DIFFICULTY.EASY and "child2_endless_loop_extra_factor" or "child2_endless_loop_extra_factor_hard"
	local var2_24 = pg.gameset[var1_24].description

	for iter0_24, iter1_24 in ipairs(var2_24) do
		if arg0_24.round >= iter1_24[1] and arg0_24.round <= iter1_24[2] then
			return iter1_24[3] * (tonumber(var0_24) or 1)
		end
	end

	return var2_24[#var2_24][3] * (tonumber(var0_24) or 1)
end

function var0_0.GetEndlessProgressInfos(arg0_25)
	local var0_25 = pg.child2_target[arg0_25:getConfig("target_id")].attr_sum * arg0_25:GetExtraFactor()
	local var1_25 = arg0_25:GetWave()

	return var1_25, var1_25 > arg0_25:GetHeighestWave(), var0_25
end

return var0_0
