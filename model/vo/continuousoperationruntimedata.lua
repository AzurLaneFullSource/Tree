local var0_0 = class("ContinuousOperationRuntimeData")

function var0_0.Ctor(arg0_1, arg1_1)
	for iter0_1, iter1_1 in pairs(arg1_1) do
		arg0_1[iter0_1] = iter1_1
	end

	arg0_1.system = arg1_1.system
	arg0_1.totalBattleTime = arg1_1.battleTime
	arg0_1.battleTime = arg1_1.battleTime
	arg0_1.drops = {}
	arg0_1.settlementDrops = {}
	arg0_1.events = {
		{},
		{},
		{}
	}
	arg0_1.active = nil
end

function var0_0.GetSystem(arg0_2)
	return arg0_2.system
end

function var0_0.GetTotalBattleTime(arg0_3)
	return arg0_3.totalBattleTime
end

function var0_0.GetRestBattleTime(arg0_4)
	return arg0_4.battleTime
end

function var0_0.ConsumeBattleTime(arg0_5)
	arg0_5.battleTime = arg0_5.battleTime - 1
end

function var0_0.IsFirstBattle(arg0_6)
	return arg0_6:GetTotalBattleTime() == arg0_6:GetRestBattleTime()
end

function var0_0.GetDrops(arg0_7)
	return arg0_7.drops
end

function var0_0.GetSettlementDrops(arg0_8)
	return arg0_8.settlementDrops
end

function var0_0.MergeDrops(arg0_9, arg1_9, arg2_9)
	arg0_9.drops = table.mergeArray(arg0_9.drops, arg1_9)
	arg0_9.settlementDrops = table.mergeArray(arg0_9.settlementDrops, arg2_9)
end

function var0_0.MergeEvents(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10.events[1] = table.merge(arg0_10.events[1], arg1_10 or {})
	arg0_10.events[2] = table.merge(arg0_10.events[2], arg2_10 or {})
	arg0_10.events[3] = table.merge(arg0_10.events[3], arg3_10 or {})
end

function var0_0.GetEvents(arg0_11, arg1_11)
	return arg0_11.events[arg1_11]
end

function var0_0.TryActivate(arg0_12)
	if arg0_12.active ~= nil then
		return
	end

	arg0_12.active = true
end

function var0_0.Stop(arg0_13, arg1_13)
	arg0_13.active = false
	arg0_13.stopReason = arg1_13 or ChapterConst.AUTOFIGHT_STOP_REASON.UNKNOWN
end

function var0_0.IsActive(arg0_14)
	return tobool(arg0_14.active)
end

return var0_0
