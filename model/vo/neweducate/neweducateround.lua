local var0_0 = class("NewEducateRound", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.child2_round
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2:InitConfig(arg1_2)

	arg0_2.round = arg2_2.round
	arg0_2.id = arg0_2.round2Id[arg0_2.round]
	arg0_2.configId = arg0_2.id
end

function var0_0.InitConfig(arg0_3, arg1_3)
	arg0_3.round2Id = {}
	arg0_3.assessRoundIds = {}
	arg0_3.talentRoundIds = {}

	for iter0_3, iter1_3 in ipairs(pg.child2_round.get_id_list_by_character[arg1_3]) do
		local var0_3 = pg.child2_round[iter1_3]

		arg0_3.round2Id[var0_3.round] = iter1_3

		if var0_3.target_id ~= 0 then
			table.insert(arg0_3.assessRoundIds, var0_3.round)
		end

		if var0_3.benefit_select ~= "" and #var0_3.benefit_select ~= 0 then
			table.insert(arg0_3.talentRoundIds, var0_3.round)
		end
	end

	table.sort(arg0_3.assessRoundIds)
	table.sort(arg0_3.talentRoundIds)
end

function var0_0.GetTalentRoundIds(arg0_4)
	return arg0_4.talentRoundIds
end

function var0_0.IsTalentRound(arg0_5)
	return table.contains(arg0_5.talentRoundIds, arg0_5.round)
end

function var0_0.IsShowAssessTip(arg0_6)
	if arg0_6.round == 1 then
		return true
	end

	for iter0_6, iter1_6 in ipairs(arg0_6.assessRoundIds) do
		if arg0_6.round == iter1_6 + 1 then
			return true
		end
	end

	return false
end

function var0_0.GetProgressInfo(arg0_7)
	local var0_7 = underscore.detect(arg0_7.assessRoundIds, function(arg0_8)
		return arg0_8 >= arg0_7.round
	end)
	local var1_7 = pg.child2_round[arg0_7.round2Id[var0_7]].target_id

	return arg0_7.round, var0_7 - arg0_7.round, pg.child2_target[var1_7].attr_sum
end

function var0_0.IsEndRound(arg0_9)
	return not arg0_9.round2Id[arg0_9.round + 1]
end

function var0_0.OnNextRound(arg0_10)
	arg0_10.round = arg0_10.round + 1
	arg0_10.id = arg0_10.round2Id[arg0_10.round]
	arg0_10.configId = arg0_10.id
	arg0_10.chatIds = nil
end

return var0_0
