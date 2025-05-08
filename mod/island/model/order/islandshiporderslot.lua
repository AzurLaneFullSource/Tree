local var0_0 = class("IslandShipOrderSlot")

var0_0.STATE_LOCK = 0
var0_0.STATE_WAITING = 1
var0_0.STATE_SUBMITED = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:Init(arg1_1)
end

function var0_0.Init(arg0_2, arg1_2, arg2_2)
	arg0_2.forceUnlock = arg2_2
	arg0_2.id = arg1_2.id
	arg0_2.state = arg1_2.state or var0_0.STATE_LOCK
	arg0_2.totalTime = arg1_2.load_time or 0
	arg0_2.endTime = arg1_2.get_time or 0
	arg0_2.order = IslandShipOrder.New(arg1_2)
	arg0_2.config = pg.island_order_list[arg0_2.id]
end

function var0_0.GetWorldObjId(arg0_3)
	return pg.island_order_list[arg0_3.id].objId or 0
end

function var0_0.Submit(arg0_4, arg1_4)
	arg0_4.endTime = arg1_4
	arg0_4.state = var0_0.STATE_SUBMITED
end

function var0_0.GetOrder(arg0_5)
	return arg0_5.order
end

function var0_0.GetEndTime(arg0_6)
	return arg0_6.endTime
end

function var0_0.GetNeedTime(arg0_7)
	return arg0_7.totalTime
end

function var0_0.IsLock(arg0_8)
	return arg0_8.state == var0_0.STATE_LOCK
end

function var0_0.IsWaiting(arg0_9)
	return arg0_9.state == var0_0.STATE_WAITING
end

function var0_0.IsSubmited(arg0_10)
	return arg0_10.state == var0_0.STATE_SUBMITED
end

function var0_0.IsFinished(arg0_11)
	local function var0_11()
		return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_11.endTime
	end

	return arg0_11:IsSubmited() and var0_11()
end

function var0_0.CanSubmit(arg0_13)
	return arg0_13:IsWaiting()
end

function var0_0.GetUnlockLevel(arg0_14)
	return arg0_14.config.unlock_level
end

function var0_0.GetUnlockGold(arg0_15)
	local var0_15 = arg0_15.config.unlock_cost[1] or {}

	return {
		type = DROP_TYPE_ISLAND_ITEM,
		id = var0_15[1] or 1,
		count = var0_15[2] or 0
	}
end

function var0_0.CanUnlock(arg0_16)
	if not arg0_16:IsLock() then
		return false
	end

	if arg0_16.forceUnlock then
		return true
	end

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockShipOrder(arg0_16.id) then
		return false
	end

	return true
end

return var0_0
