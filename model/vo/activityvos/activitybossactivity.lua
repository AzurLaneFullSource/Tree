local var0_0 = class("ActivityBossActivity", import("model.vo.Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.bossHP = 0
	arg0_1.milestones = {}
	arg0_1.bossConfig = ActivityBossConfig.New({
		configId = arg0_1:getConfig("config_id")
	})
end

function var0_0.GetBossConfig(arg0_2)
	return arg0_2.bossConfig
end

function var0_0.UpdatePublicData(arg0_3, arg1_3)
	arg0_3.bossHP = arg1_3.boss_hp or 0
	arg0_3.milestones = arg1_3.milestones or {}
	arg0_3.data2 = 1
end

function var0_0.AddStage(arg0_4, arg1_4)
	if table.contains(arg0_4.data1_list, arg1_4) then
		return
	end

	table.insert(arg0_4.data1_list, arg1_4)
end

function var0_0.IsOilLimit(arg0_5, arg1_5)
	assert(arg1_5)

	return table.contains(arg0_5.data1_list, arg1_5)
end

function var0_0.GetBindPtActID(arg0_6)
	return (getProxy(ActivityProxy):GetActBossLinkPTActID(arg0_6.id))
end

function var0_0.GetBossHP(arg0_7)
	return arg0_7.bossHP
end

function var0_0.GetMileStones(arg0_8)
	return arg0_8.milestones
end

function var0_0.readyToAchieve(arg0_9)
	return arg0_9.data2 ~= 1
end

function var0_0.GetTickets(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.data1KeyValueList) do
		for iter2_10, iter3_10 in pairs(iter1_10) do
			var0_10[iter2_10] = (var0_10[iter2_10] or 0) + iter3_10
		end
	end

	return var0_10
end

function var0_0.GetStageBonus(arg0_11, arg1_11)
	local var0_11 = 0

	for iter0_11, iter1_11 in pairs(arg0_11.data1KeyValueList) do
		for iter2_11, iter3_11 in pairs(iter1_11) do
			if iter2_11 == arg1_11 then
				var0_11 = var0_11 + iter3_11
			end
		end
	end

	return var0_11
end

function var0_0.checkBattleTimeInBossAct(arg0_12)
	assert(arg0_12:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if arg0_12:isEnd() then
		return false
	end

	local var0_12 = arg0_12.bossConfig:GetBattleTime()

	return pg.TimeMgr.GetInstance():inTime(var0_12)
end

function var0_0.GetHighestScore(arg0_13)
	return arg0_13.data1
end

function var0_0.UpdateHighestScore(arg0_14, arg1_14)
	if arg1_14 <= arg0_14.data1 then
		return false
	end

	arg0_14.data1 = arg1_14

	return true
end

function var0_0.GetHistoryBuffs(arg0_15)
	return arg0_15.data2_list
end

function var0_0.UpdateHistoryBuffs(arg0_16, arg1_16)
	arg0_16.data2_list = arg1_16
end

return var0_0
