local var0_0 = class("IslandOrderAgency", import(".IslandBaseAgency"))

var0_0.GEN_NEW_ORDER = "IslandOrderAgency:GEN_NEW_ORDER"
var0_0.UDPATE_ORDER = "IslandOrderAgency:UDPATE_ORDER"
var0_0.ORDER_FINISH_UPDATE = "IslandOrderAgency:ORDER_FINISH_UPDATE"
var0_0.COMMON_ORDER_TYPE = 1
var0_0.URGENCY_ORDER_TYPE = 2
var0_0.SHIP_ORDER_TYPE = 3

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1:InitData(arg1_1.order_system or {})
end

function var0_0.InitData(arg0_2, arg1_2)
	arg0_2.exp = arg1_2.favor or 0
	arg0_2.tendency = arg1_2.daily_select or IslandOrderSlot.TENDENCY_TYPE_COMMON
	arg0_2.finishCnt = arg1_2.daily_slot_num or 0
	arg0_2.urgencyFinishCnt = arg1_2.time_slot_num or 0
	arg0_2.nextManualReloadDelegateTime = arg1_2.ship_refresh or 0
	arg0_2.awardIndexList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.get_favor or {}) do
		table.insert(arg0_2.awardIndexList, iter1_2)
	end

	arg0_2.actFinishedGroupsMap = {}

	for iter2_2, iter3_2 in ipairs(arg1_2.act_group or {}) do
		local var0_2 = {}

		for iter4_2, iter5_2 in ipairs(iter3_2.groups) do
			table.insert(var0_2, iter5_2)
		end

		arg0_2.actFinishedGroupsMap[iter3_2.act_id] = var0_2
	end

	arg0_2.slotList = {}

	for iter6_2, iter7_2 in ipairs(arg1_2.slot_list or {}) do
		local var1_2 = IslandOrderSlot.New(iter7_2)

		arg0_2.slotList[var1_2.id] = var1_2
	end

	arg0_2.shipSlotList = {}

	for iter8_2, iter9_2 in ipairs(pg.island_order_list.get_id_list_by_type[var0_0.SHIP_ORDER_TYPE]) do
		local var2_2 = IslandShipOrderSlot.New({
			id = iter9_2
		})

		arg0_2.shipSlotList[var2_2.id] = var2_2
	end

	for iter10_2, iter11_2 in ipairs(arg1_2.ship_slot_list or {}) do
		local var3_2 = arg0_2.shipSlotList[iter11_2.id]

		if var3_2 then
			var3_2:Init(iter11_2, true)
		end
	end

	arg0_2.shipOrderDelegateSlots = {}

	for iter12_2, iter13_2 in ipairs(arg1_2.appoint_list or {}) do
		local var4_2 = IslandShipOrderDelegateSlot.New(iter13_2)

		arg0_2.shipOrderDelegateSlots[var4_2.id] = var4_2
	end

	for iter14_2, iter15_2 in ipairs(arg1_2.speed_list or {}) do
		local var5_2 = iter15_2.slot_id
		local var6_2 = iter15_2.speed_time
		local var7_2 = pg.island_order_list[var5_2].type

		if var7_2 == var0_0.COMMON_ORDER_TYPE then
			arg0_2.slotList[var5_2]:SetReduceTime(var6_2)
		elseif var7_2 == var0_0.SHIP_ORDER_TYPE then
			local var8_2 = arg0_2.shipSlotList[var5_2]

			if var8_2 and var8_2:IsWaiting() then
				var8_2:SetReloadingReduceTime(var6_2)
			elseif var8_2 and var8_2:IsSubmited() then
				var8_2:SetReduceTime(var6_2)
			end
		end
	end
end

function var0_0.GetShipSlotList(arg0_3)
	return arg0_3.shipSlotList
end

function var0_0.GetShipOrderSlot(arg0_4, arg1_4)
	return arg0_4.shipSlotList[arg1_4]
end

function var0_0.UpdateShipSlot(arg0_5, arg1_5)
	arg0_5.shipSlotList[arg1_5.id] = arg1_5
end

function var0_0.CanRefreshShipOrderDelegate(arg0_6)
	local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_6 = arg0_6:GetNextManualReloadDelegateTime()

	return var1_6 <= var0_6, var1_6
end

function var0_0.GetDelegateList(arg0_7)
	return arg0_7.shipOrderDelegateSlots
end

function var0_0.RemoveDelegateSlot(arg0_8, arg1_8)
	if arg0_8.shipOrderDelegateSlots[arg1_8] then
		arg0_8.shipOrderDelegateSlots[arg1_8] = nil
	end
end

function var0_0.GetDelegateSlot(arg0_9, arg1_9)
	return arg0_9.shipOrderDelegateSlots[arg1_9]
end

function var0_0.AddDelegateSlot(arg0_10, arg1_10)
	arg0_10.shipOrderDelegateSlots[arg1_10.id] = arg1_10
end

function var0_0.AddDelegateSlotList(arg0_11, arg1_11)
	arg0_11.shipOrderDelegateSlots = arg1_11
end

function var0_0.GetNextAutoReloadDelegateTime(arg0_12)
	local var0_12 = pg.TimeMgr.GetInstance():GetServerTime() + 86400

	for iter0_12, iter1_12 in ipairs(arg0_12.shipOrderDelegateSlots) do
		local var1_12 = iter1_12:GetShowTime()

		if not iter1_12:CanShow() and var1_12 < var0_12 then
			var0_12 = var1_12
		end
	end

	return var0_12
end

function var0_0.GetNextManualReloadDelegateTime(arg0_13)
	return arg0_13.nextManualReloadDelegateTime
end

function var0_0.UpdateNextManualReloadDelegateTime(arg0_14, arg1_14)
	arg0_14.nextManualReloadDelegateTime = arg1_14
end

function var0_0.ReduceNextManualReloadDelegateTime(arg0_15, arg1_15)
	arg0_15.nextManualReloadDelegateTime = arg0_15.nextManualReloadDelegateTime - arg1_15
end

function var0_0.AddSlot(arg0_16, arg1_16)
	local var0_16 = IslandOrderSlot.New(arg1_16)

	arg0_16.slotList[var0_16.id] = var0_16

	arg0_16:DispatchEvent(var0_0.GEN_NEW_ORDER, {
		slotId = var0_16.id
	})
end

function var0_0.UpdateSlot(arg0_17, arg1_17)
	local var0_17 = arg0_17.slotList[arg1_17.id]

	var0_17:Flush(arg1_17)
	arg0_17:DispatchEvent(var0_0.UDPATE_ORDER, {
		slotId = var0_17.id
	})
end

function var0_0.RemoveSlot(arg0_18, arg1_18)
	arg0_18.slotList[arg1_18] = nil
end

function var0_0.UpdateOrAddOrder(arg0_19, arg1_19)
	if not arg0_19.slotList[arg1_19.id] then
		arg0_19:AddSlot(arg1_19)
	else
		arg0_19:UpdateSlot(arg1_19)
	end
end

function var0_0.IncFinishCnt(arg0_20)
	arg0_20.finishCnt = arg0_20.finishCnt + 1
end

function var0_0.GetFinishCnt(arg0_21)
	return arg0_21.finishCnt
end

function var0_0.GetMaxFinishCount(arg0_22)
	local var0_22 = arg0_22:GetHost():GetAblityAgency():GetOrderDailyCntAddition()

	return pg.island_set.order_daily_limit_num.key_value_int + var0_22
end

function var0_0.IncUrgencyFinishCnt(arg0_23)
	arg0_23.urgencyFinishCnt = arg0_23.urgencyFinishCnt + 1
end

function var0_0.GetUrgentFinishCnt(arg0_24)
	return arg0_24.urgencyFinishCnt
end

function var0_0.GetMaxUrgentFinishCnt(arg0_25)
	return pg.island_set.order_special_limit_num.key_value_int
end

function var0_0.GetLeftUrgentCnt(arg0_26)
	return arg0_26:GetMaxUrgentFinishCnt() - arg0_26:GetUrgentFinishCnt()
end

function var0_0.GetTendency(arg0_27)
	return arg0_27.tendency
end

function var0_0.SetTendency(arg0_28, arg1_28)
	arg0_28.tendency = arg1_28
end

function var0_0.ExpSystemIsOpen(arg0_29)
	return arg0_29:GetHost():GetAblityAgency():IsUnlockOrderExp()
end

function var0_0.AddExp(arg0_30, arg1_30)
	if not arg0_30:ExpSystemIsOpen() then
		return
	end

	if arg0_30:IsMaxLevel() then
		return
	end

	arg0_30.exp = arg0_30.exp + arg1_30
end

function var0_0.GetExp(arg0_31)
	return arg0_31.exp
end

function var0_0.GetTargetExp(arg0_32)
	local var0_32 = arg0_32:GetLevel()

	return arg0_32:StaticGetTargetExp(var0_32)
end

function var0_0.GetNextTargetExp(arg0_33)
	if arg0_33:IsMaxLevel() then
		return 0
	end

	local var0_33 = arg0_33:GetLevel()

	return arg0_33:StaticGetTargetExp(var0_33)
end

function var0_0.StaticGetTargetExp(arg0_34, arg1_34)
	local var0_34 = 0

	for iter0_34 = 1, arg1_34 do
		local var1_34 = pg.island_order_favor[iter0_34]

		var0_34 = var0_34 + (var1_34 and var1_34.exp or 0)
	end

	return var0_34
end

function var0_0.GetLevel(arg0_35)
	for iter0_35, iter1_35 in ipairs(pg.island_order_favor.all) do
		if arg0_35:StaticGetTargetExp(iter1_35 + 1) > arg0_35.exp then
			return iter1_35
		end
	end

	if arg0_35:IsMaxLevel() then
		local var0_35 = pg.island_order_favor.all

		return var0_35[#var0_35]
	else
		return 0
	end
end

function var0_0.IsMaxLevel(arg0_36)
	local var0_36 = pg.island_order_favor.all
	local var1_36 = var0_36[#var0_36]

	return arg0_36:StaticGetTargetExp(var1_36) <= arg0_36.exp
end

function var0_0.GetSlots(arg0_37)
	return arg0_37.slotList
end

function var0_0.GetSlot(arg0_38, arg1_38)
	return arg0_38.slotList[arg1_38]
end

function var0_0.IsGotAward(arg0_39, arg1_39)
	return table.contains(arg0_39.awardIndexList, arg1_39)
end

function var0_0.UpdateGotAwardList(arg0_40, arg1_40)
	if not arg0_40:IsGotAward(arg1_40) then
		table.insert(arg0_40.awardIndexList, arg1_40)
	end
end

function var0_0.GetAllCanGetAwardList(arg0_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(pg.island_order_favor.all) do
		if arg0_41:CanGetAward(iter1_41) then
			table.insert(var0_41, iter1_41)
		end
	end

	return var0_41
end

function var0_0.CanGetAward(arg0_42, arg1_42)
	if arg0_42:IsGotAward(arg1_42) then
		return false
	end

	return arg0_42:StaticGetTargetExp(arg1_42) <= arg0_42.exp
end

local var1_0 = "island_next_submit_order_time"

function var0_0.RecordNextCanSubmitTime(arg0_43)
	local var0_43 = getProxy(PlayerProxy):getRawData().id
	local var1_43 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_43 = pg.island_set.order_complete_refresh_time.key_value_int

	PlayerPrefs.SetInt(var1_0 .. var0_43, var1_43 + var2_43)
	PlayerPrefs.Save()
end

function var0_0.CanSubmitOrder(arg0_44)
	local var0_44 = getProxy(PlayerProxy):getRawData().id
	local var1_44 = PlayerPrefs.GetInt(var1_0 .. var0_44, 0)
	local var2_44 = pg.TimeMgr.GetInstance():GetServerTime()

	return var1_44 <= 0 or var1_44 <= var2_44, var1_44
end

local var2_0 = "island_selected_order_id"

function var0_0.GetCacheSelectedId(arg0_45)
	local var0_45 = getProxy(PlayerProxy):getRawData().id

	return (PlayerPrefs.GetInt(var2_0 .. var0_45, 0))
end

function var0_0.SetCacheSelectedId(arg0_46, arg1_46)
	local var0_46 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var2_0 .. var0_46, arg1_46)
	PlayerPrefs.Save()
end

function var0_0.AddFinishedActGroupId(arg0_47, arg1_47, arg2_47)
	if not arg0_47.actFinishedGroupsMap[arg1_47] then
		arg0_47.actFinishedGroupsMap[arg1_47] = {}
	end

	if not table.contains(arg0_47.actFinishedGroupsMap[arg1_47], arg2_47) then
		table.insert(arg0_47.actFinishedGroupsMap[arg1_47], arg2_47)
	end
end

function var0_0.GetFinishedCntByActId(arg0_48, arg1_48)
	local var0_48 = pg.island_order
	local var1_48 = var0_48.get_id_list_by_activity_id[arg1_48]
	local var2_48 = {}

	for iter0_48, iter1_48 in ipairs(var1_48) do
		local var3_48 = var0_48[iter1_48].group_id

		if not var2_48[var3_48] then
			var2_48[var3_48] = {}
		end

		table.insert(var2_48[var3_48], iter1_48)
	end

	local var4_48 = 0

	for iter2_48, iter3_48 in ipairs(arg0_48.actFinishedGroupsMap[arg1_48] or {}) do
		var4_48 = var4_48 + #var2_48[iter3_48]
	end

	for iter4_48, iter5_48 in pairs(arg0_48.slotList) do
		local var5_48 = iter5_48:GetOrder()

		if isa(var5_48, IslandFirmActivityOrder) and var5_48:GetActivityId() == arg1_48 then
			local var6_48 = var2_48[var5_48:GetGroupId()]

			table.sort(var6_48)

			var4_48 = var4_48 + table.indexof(var6_48, var5_48.id) - 1
		end
	end

	return var4_48
end

function var0_0.UpdatePerDay(arg0_49)
	arg0_49.finishCnt = 0

	if pg.TimeMgr.GetInstance():GetServerWeek() == 1 then
		arg0_49.urgencyFinishCnt = 0
		arg0_49.exp = 0
	end

	arg0_49:DispatchEvent(var0_0.ORDER_FINISH_UPDATE)
end

function var0_0.OnSeasonReset(arg0_50, arg1_50)
	arg0_50:InitData(arg1_50)
end

return var0_0
