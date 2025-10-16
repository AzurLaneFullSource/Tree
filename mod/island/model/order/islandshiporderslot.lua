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
	arg0_2.endTime = 0

	if arg0_2:IsSubmited() then
		arg0_2.endTime = arg1_2.get_time or 0
	end

	arg0_2.openTime = 0

	if arg0_2:IsWaiting() then
		arg0_2.openTime = arg1_2.get_time or 0
	end

	arg0_2.reduceTime = 0
	arg0_2.reloadingReduceTime = 0
	arg0_2.order = IslandShipOrder.New(arg1_2)
	arg0_2.config = pg.island_order_list[arg0_2.id]
end

function var0_0.CanRefresh(arg0_3)
	if arg0_3:GetOrder():IsAnyLoadUp() then
		return false
	end

	if arg0_3:IsReloading() then
		return false
	end

	return true
end

function var0_0.GetWorldObjId(arg0_4)
	return pg.island_order_list[arg0_4.id].objId or 0
end

function var0_0.Submit(arg0_5, arg1_5)
	arg0_5.endTime = arg1_5
	arg0_5.state = var0_0.STATE_SUBMITED
end

function var0_0.GetOrder(arg0_6)
	return arg0_6.order
end

function var0_0.GetEndTime(arg0_7)
	return arg0_7.endTime - arg0_7.reduceTime
end

function var0_0.GetNeedTime(arg0_8)
	return arg0_8.totalTime
end

function var0_0.GetReloadingEndTime(arg0_9)
	return arg0_9.openTime - arg0_9.reloadingReduceTime
end

function var0_0.IsReloading(arg0_10)
	if arg0_10:IsWaiting() then
		return pg.TimeMgr.GetInstance():GetServerTime() < arg0_10:GetReloadingEndTime()
	else
		return false
	end
end

function var0_0.IsLock(arg0_11)
	return arg0_11.state == var0_0.STATE_LOCK
end

function var0_0.IsWaiting(arg0_12)
	return arg0_12.state == var0_0.STATE_WAITING
end

function var0_0.IsSubmited(arg0_13)
	return arg0_13.state == var0_0.STATE_SUBMITED
end

function var0_0.IsFinished(arg0_14)
	local function var0_14()
		return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_14:GetEndTime()
	end

	return arg0_14:IsSubmited() and var0_14()
end

function var0_0.CanSubmit(arg0_16)
	return arg0_16:IsWaiting()
end

function var0_0.GetUnlockLevel(arg0_17)
	return arg0_17.config.unlock_level
end

function var0_0.GetUnlockGold(arg0_18)
	local var0_18 = arg0_18.config.unlock_cost[1] or {}

	return {
		type = DROP_TYPE_ISLAND_ITEM,
		id = var0_18[1] or 1,
		count = var0_18[2] or 0
	}
end

function var0_0.CanUnlock(arg0_19)
	if not arg0_19:IsLock() then
		return false
	end

	if arg0_19.forceUnlock then
		return true
	end

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockShipOrder(arg0_19.id) then
		return false
	end

	return true
end

function var0_0.SetReduceTime(arg0_20, arg1_20)
	arg0_20.reduceTime = arg1_20
end

function var0_0.AddReduceTime(arg0_21, arg1_21)
	arg0_21.reduceTime = arg0_21.reduceTime + arg1_21
end

function var0_0.SetReloadingReduceTime(arg0_22, arg1_22)
	arg0_22.reloadingReduceTime = arg1_22
end

function var0_0.AddReduceReloadingTime(arg0_23, arg1_23)
	arg0_23.reloadingReduceTime = math.max(arg0_23.reloadingReduceTime + arg1_23, 0)
end

return var0_0
