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
	arg0_2.maxFinishCnt = pg.island_set.island_shiporder_limit.key_value_int
	arg0_2.finishCnt = arg1_2.finish_num or 0
	arg0_2.nextRefreshFinishCntTime = arg1_2.auto_time or 0
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

function var0_0.Reset(arg0_3)
	arg0_3.openTime = 0
end

function var0_0.FillDelegate(arg0_4, arg1_4)
	arg0_4.openTime = 0

	local var0_4 = arg1_4:GetRequestList()
	local var1_4 = arg1_4:GetAwardList()

	arg0_4.order:FillConsumeList(Clone(var0_4))
	arg0_4.order:FillAwardList(Clone(var1_4))
end

function var0_0.CanTransport(arg0_5)
	local var0_5 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_5.finishCnt < arg0_5.maxFinishCnt or var0_5 >= arg0_5.nextRefreshFinishCntTime
end

function var0_0.GetFinishCnt(arg0_6)
	return arg0_6.finishCnt
end

function var0_0.GetRealFinishCnt(arg0_7)
	if pg.TimeMgr.GetInstance():GetServerTime() >= arg0_7.nextRefreshFinishCntTime then
		return math.max(0, arg0_7.finishCnt - 1)
	end

	return arg0_7.finishCnt
end

function var0_0.GetMaxFinishCnt(arg0_8)
	return arg0_8.maxFinishCnt
end

function var0_0.GetWorldObjId(arg0_9)
	return pg.island_order_list[arg0_9.id].objId or 0
end

function var0_0.Submit(arg0_10, arg1_10)
	arg0_10.endTime = arg1_10
	arg0_10.state = var0_0.STATE_SUBMITED

	arg0_10:IncreaseFinishCnt()
end

function var0_0.IncreaseFinishCnt(arg0_11)
	arg0_11.finishCnt = math.min(arg0_11.finishCnt + 1, arg0_11.maxFinishCnt)
	arg0_11.nextRefreshFinishCntTime = arg0_11:GetNextRefreshFinishCntTime()
end

function var0_0.GetNextRefreshFinishCntTime(arg0_12)
	local var0_12 = GetZeroTime() - 86400
	local var1_12 = pg.island_set.island_shiporder_refresh.key_value_varchar
	local var2_12 = _.map(var1_12, function(arg0_13)
		return arg0_13 + var0_12
	end)
	local var3_12 = pg.TimeMgr.GetInstance():GetServerTime()

	return _.detect(var2_12, function(arg0_14)
		return arg0_14 > var3_12
	end) or GetZeroTime() + var1_12[1]
end

function var0_0.GetOrder(arg0_15)
	return arg0_15.order
end

function var0_0.GetEndTime(arg0_16)
	return arg0_16.endTime - arg0_16.reduceTime
end

function var0_0.GetNeedTime(arg0_17)
	return arg0_17.totalTime
end

function var0_0.GetShowTime(arg0_18)
	return arg0_18.openTime
end

function var0_0.IsEmpty(arg0_19)
	if arg0_19:IsWaiting() then
		return pg.TimeMgr.GetInstance():GetServerTime() < arg0_19:GetShowTime()
	else
		return false
	end
end

function var0_0.IsLock(arg0_20)
	return arg0_20.state == var0_0.STATE_LOCK
end

function var0_0.IsWaiting(arg0_21)
	return arg0_21.state == var0_0.STATE_WAITING
end

function var0_0.IsSubmited(arg0_22)
	return arg0_22.state == var0_0.STATE_SUBMITED
end

function var0_0.IsFinished(arg0_23)
	local function var0_23()
		return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_23:GetEndTime()
	end

	return arg0_23:IsSubmited() and var0_23()
end

function var0_0.CanSubmit(arg0_25)
	return arg0_25:IsWaiting()
end

function var0_0.GetUnlockLevel(arg0_26)
	return arg0_26.config.unlock_level
end

function var0_0.GetUnlockGold(arg0_27)
	local var0_27 = arg0_27.config.unlock_cost[1] or {}

	return {
		type = DROP_TYPE_ISLAND_ITEM,
		id = var0_27[1] or 1,
		count = var0_27[2] or 0
	}
end

function var0_0.CanUnlock(arg0_28)
	if not arg0_28:IsLock() then
		return false
	end

	if arg0_28.forceUnlock then
		return true
	end

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockShipOrder(arg0_28.id) then
		return false
	end

	return true
end

function var0_0.SetReduceTime(arg0_29, arg1_29)
	arg0_29.reduceTime = arg1_29
end

function var0_0.AddReduceTime(arg0_30, arg1_30)
	arg0_30.reduceTime = arg0_30.reduceTime + arg1_30
end

function var0_0.SetReloadingReduceTime(arg0_31, arg1_31)
	arg0_31.reloadingReduceTime = arg1_31
end

function var0_0.AddReduceReloadingTime(arg0_32, arg1_32)
	arg0_32.reloadingReduceTime = math.max(arg0_32.reloadingReduceTime + arg1_32, 0)
end

return var0_0
