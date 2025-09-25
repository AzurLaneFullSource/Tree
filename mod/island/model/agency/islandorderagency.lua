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
	arg0_2.awardIndexList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.get_favor or {}) do
		table.insert(arg0_2.awardIndexList, iter1_2)
	end

	arg0_2.slotList = {}

	for iter2_2, iter3_2 in ipairs(arg1_2.slot_list or {}) do
		local var0_2 = IslandOrderSlot.New(iter3_2)

		arg0_2.slotList[var0_2.id] = var0_2
	end

	arg0_2.shipSlotList = {}

	for iter4_2, iter5_2 in ipairs(pg.island_order_list.get_id_list_by_type[var0_0.SHIP_ORDER_TYPE]) do
		local var1_2 = IslandShipOrderSlot.New({
			id = iter5_2
		})

		arg0_2.shipSlotList[var1_2.id] = var1_2
	end

	for iter6_2, iter7_2 in ipairs(arg1_2.ship_slot_list or {}) do
		local var2_2 = arg0_2.shipSlotList[iter7_2.id]

		if var2_2 then
			var2_2:Init(iter7_2, true)
		end
	end

	for iter8_2, iter9_2 in ipairs(arg1_2.speed_list or {}) do
		local var3_2 = iter9_2.slot_id
		local var4_2 = iter9_2.speed_time
		local var5_2 = pg.island_order_list[var3_2].type

		if var5_2 == var0_0.COMMON_ORDER_TYPE then
			arg0_2.slotList[var3_2]:SetReduceTime(var4_2)
		elseif var5_2 == var0_0.SHIP_ORDER_TYPE then
			arg0_2.shipSlotList[var3_2]:SetReduceTime(var4_2)
		end
	end
end

function var0_0.GetShipSlotList(arg0_3)
	return arg0_3.shipSlotList
end

function var0_0.GetShipOrderSlot(arg0_4, arg1_4)
	return arg0_4.shipSlotList[arg1_4]
end

function var0_0.AddSlot(arg0_5, arg1_5)
	local var0_5 = IslandOrderSlot.New(arg1_5)

	arg0_5.slotList[var0_5.id] = var0_5

	arg0_5:DispatchEvent(var0_0.GEN_NEW_ORDER, {
		slotId = var0_5.id
	})
end

function var0_0.UpdateSlot(arg0_6, arg1_6)
	local var0_6 = arg0_6.slotList[arg1_6.id]

	var0_6:Flush(arg1_6)
	arg0_6:DispatchEvent(var0_0.UDPATE_ORDER, {
		slotId = var0_6.id
	})
end

function var0_0.RemoveSlot(arg0_7, arg1_7)
	arg0_7.slotList[arg1_7] = nil
end

function var0_0.UpdateOrAddOrder(arg0_8, arg1_8)
	if not arg0_8.slotList[arg1_8.id] then
		arg0_8:AddSlot(arg1_8)
	else
		arg0_8:UpdateSlot(arg1_8)
	end
end

function var0_0.IncFinishCnt(arg0_9)
	arg0_9.finishCnt = arg0_9.finishCnt + 1
end

function var0_0.GetFinishCnt(arg0_10)
	return arg0_10.finishCnt
end

function var0_0.GetMaxFinishCount(arg0_11)
	local var0_11 = arg0_11:GetHost():GetAblityAgency():GetOrderDailyCntAddition()

	return pg.island_set.order_daily_limit_num.key_value_int + var0_11
end

function var0_0.IncUrgencyFinishCnt(arg0_12)
	arg0_12.urgencyFinishCnt = arg0_12.urgencyFinishCnt + 1
end

function var0_0.GetUrgentFinishCnt(arg0_13)
	return arg0_13.urgencyFinishCnt
end

function var0_0.GetMaxUrgentFinishCnt(arg0_14)
	return pg.island_set.order_special_limit_num.key_value_int
end

function var0_0.GetLeftUrgentCnt(arg0_15)
	return arg0_15:GetMaxUrgentFinishCnt() - arg0_15:GetUrgentFinishCnt()
end

function var0_0.GetTendency(arg0_16)
	return arg0_16.tendency
end

function var0_0.SetTendency(arg0_17, arg1_17)
	arg0_17.tendency = arg1_17
end

function var0_0.ExpSystemIsOpen(arg0_18)
	return arg0_18:GetHost():GetAblityAgency():HasAbility(IslandAblityAgency.ORDER_EXP_ID)
end

function var0_0.AddExp(arg0_19, arg1_19)
	if not arg0_19:ExpSystemIsOpen() then
		return
	end

	if arg0_19:IsMaxLevel() then
		return
	end

	arg0_19.exp = arg0_19.exp + arg1_19
end

function var0_0.GetExp(arg0_20)
	return arg0_20.exp
end

function var0_0.GetTargetExp(arg0_21)
	local var0_21 = arg0_21:GetLevel()

	return arg0_21:StaticGetTargetExp(var0_21)
end

function var0_0.GetNextTargetExp(arg0_22)
	if arg0_22:IsMaxLevel() then
		return 0
	end

	local var0_22 = arg0_22:GetLevel()

	return arg0_22:StaticGetTargetExp(var0_22 + 1)
end

function var0_0.StaticGetTargetExp(arg0_23, arg1_23)
	local var0_23 = 0

	for iter0_23 = 1, arg1_23 do
		var0_23 = var0_23 + pg.island_order_favor[iter0_23].exp
	end

	return var0_23
end

function var0_0.GetLevel(arg0_24)
	for iter0_24, iter1_24 in ipairs(pg.island_order_favor.all) do
		if arg0_24:StaticGetTargetExp(iter1_24) >= arg0_24.exp then
			return iter1_24
		end
	end
end

function var0_0.IsMaxLevel(arg0_25)
	local var0_25 = arg0_25:GetLevel()

	return arg0_25:StaticIsMaxLevel(var0_25)
end

function var0_0.StaticIsMaxLevel(arg0_26, arg1_26)
	local var0_26 = pg.island_order_favor.all

	return arg1_26 >= var0_26[#var0_26]
end

function var0_0.GetSlots(arg0_27)
	return arg0_27.slotList
end

function var0_0.GetSlot(arg0_28, arg1_28)
	return arg0_28.slotList[arg1_28]
end

function var0_0.IsGotAward(arg0_29, arg1_29)
	return table.contains(arg0_29.awardIndexList, arg1_29)
end

function var0_0.UpdateGotAwardList(arg0_30, arg1_30)
	if not arg0_30:IsGotAward(arg1_30) then
		table.insert(arg0_30.awardIndexList, arg1_30)
	end
end

function var0_0.GetAllCanGetAwardList(arg0_31)
	local var0_31 = {}

	for iter0_31, iter1_31 in ipairs(pg.island_order_favor.all) do
		if arg0_31:CanGetAward(iter1_31) then
			table.insert(var0_31, iter1_31)
		end
	end

	return var0_31
end

function var0_0.CanGetAward(arg0_32, arg1_32)
	if arg0_32:IsGotAward(arg1_32) then
		return false
	end

	return arg0_32:StaticGetTargetExp(arg1_32) <= arg0_32.exp
end

local var1_0 = "island_next_submit_order_time"

function var0_0.RecordNextCanSubmitTime(arg0_33)
	local var0_33 = getProxy(PlayerProxy):getRawData().id
	local var1_33 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_33 = pg.island_set.order_complete_refresh_time.key_value_int

	PlayerPrefs.SetInt(var1_0 .. var0_33, var1_33 + var2_33)
	PlayerPrefs.Save()
end

function var0_0.CanSubmitOrder(arg0_34)
	local var0_34 = getProxy(PlayerProxy):getRawData().id
	local var1_34 = PlayerPrefs.GetInt(var1_0 .. var0_34, 0)
	local var2_34 = pg.TimeMgr.GetInstance():GetServerTime()

	return var1_34 <= 0 or var1_34 <= var2_34, var1_34
end

local var2_0 = "island_selected_order_id"

function var0_0.GetCacheSelectedId(arg0_35)
	local var0_35 = getProxy(PlayerProxy):getRawData().id

	return (PlayerPrefs.GetInt(var2_0 .. var0_35, 0))
end

function var0_0.SetCacheSelectedId(arg0_36, arg1_36)
	local var0_36 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var2_0 .. var0_36, arg1_36)
	PlayerPrefs.Save()
end

function var0_0.UpdatePerDay(arg0_37)
	arg0_37.finishCnt = 0

	if pg.TimeMgr.GetInstance():GetServerWeek() == 1 then
		arg0_37.urgencyFinishCnt = 0
		arg0_37.exp = 0
	end

	arg0_37:DispatchEvent(var0_0.ORDER_FINISH_UPDATE)
end

function var0_0.OnSeasonReset(arg0_38, arg1_38)
	arg0_38:InitData(arg1_38)
end

return var0_0
