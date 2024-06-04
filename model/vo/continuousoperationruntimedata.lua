local var0 = class("ContinuousOperationRuntimeData")

function var0.Ctor(arg0, arg1)
	for iter0, iter1 in pairs(arg1) do
		arg0[iter0] = iter1
	end

	arg0.system = arg1.system
	arg0.totalBattleTime = arg1.battleTime
	arg0.battleTime = arg1.battleTime
	arg0.drops = {}
	arg0.settlementDrops = {}
	arg0.events = {
		{},
		{},
		{}
	}
	arg0.active = nil
end

function var0.GetSystem(arg0)
	return arg0.system
end

function var0.GetTotalBattleTime(arg0)
	return arg0.totalBattleTime
end

function var0.GetRestBattleTime(arg0)
	return arg0.battleTime
end

function var0.ConsumeBattleTime(arg0)
	arg0.battleTime = arg0.battleTime - 1
end

function var0.IsFirstBattle(arg0)
	return arg0:GetTotalBattleTime() == arg0:GetRestBattleTime()
end

function var0.GetDrops(arg0)
	return arg0.drops
end

function var0.GetSettlementDrops(arg0)
	return arg0.settlementDrops
end

function var0.MergeDrops(arg0, arg1, arg2)
	arg0.drops = table.mergeArray(arg0.drops, arg1)
	arg0.settlementDrops = table.mergeArray(arg0.settlementDrops, arg2)
end

function var0.MergeEvents(arg0, arg1, arg2, arg3)
	arg0.events[1] = table.merge(arg0.events[1], arg1 or {})
	arg0.events[2] = table.merge(arg0.events[2], arg2 or {})
	arg0.events[3] = table.merge(arg0.events[3], arg3 or {})
end

function var0.GetEvents(arg0, arg1)
	return arg0.events[arg1]
end

function var0.TryActivate(arg0)
	if arg0.active ~= nil then
		return
	end

	arg0.active = true
end

function var0.Stop(arg0, arg1)
	arg0.active = false
	arg0.stopReason = arg1 or ChapterConst.AUTOFIGHT_STOP_REASON.UNKNOWN
end

function var0.IsActive(arg0)
	return tobool(arg0.active)
end

return var0
