local var0 = class("ActivityBossActivity", import("model.vo.Activity"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.bossHP = 0
	arg0.milestones = {}
	arg0.bossConfig = ActivityBossConfig.New({
		configId = arg0:getConfig("config_id")
	})
end

function var0.GetBossConfig(arg0)
	return arg0.bossConfig
end

function var0.UpdatePublicData(arg0, arg1)
	arg0.bossHP = arg1.boss_hp or 0
	arg0.milestones = arg1.milestones or {}
	arg0.data2 = 1
end

function var0.AddStage(arg0, arg1)
	if table.contains(arg0.data1_list, arg1) then
		return
	end

	table.insert(arg0.data1_list, arg1)
end

function var0.IsOilLimit(arg0, arg1)
	assert(arg1)

	return table.contains(arg0.data1_list, arg1)
end

function var0.GetBindPtActID(arg0)
	return (getProxy(ActivityProxy):GetActBossLinkPTActID(arg0.id))
end

function var0.GetBossHP(arg0)
	return arg0.bossHP
end

function var0.GetMileStones(arg0)
	return arg0.milestones
end

function var0.readyToAchieve(arg0)
	return arg0.data2 ~= 1
end

function var0.GetTickets(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data1KeyValueList) do
		for iter2, iter3 in pairs(iter1) do
			var0[iter2] = (var0[iter2] or 0) + iter3
		end
	end

	return var0
end

function var0.GetStageBonus(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data1KeyValueList) do
		for iter2, iter3 in pairs(iter1) do
			if iter2 == arg1 then
				var0 = var0 + iter3
			end
		end
	end

	return var0
end

function var0.checkBattleTimeInBossAct(arg0)
	assert(arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if arg0:isEnd() then
		return false
	end

	local var0 = arg0.bossConfig:GetBattleTime()

	return pg.TimeMgr.GetInstance():inTime(var0)
end

function var0.GetHighestScore(arg0)
	return arg0.data1
end

function var0.UpdateHighestScore(arg0, arg1)
	if arg1 <= arg0.data1 then
		return false
	end

	arg0.data1 = arg1

	return true
end

function var0.GetHistoryBuffs(arg0)
	return arg0.data2_list
end

function var0.UpdateHistoryBuffs(arg0, arg1)
	arg0.data2_list = arg1
end

return var0
