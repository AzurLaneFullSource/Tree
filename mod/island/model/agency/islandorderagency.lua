local var0_0 = class("IslandOrderAgency", import(".IslandBaseAgency"))

var0_0.GEN_NEW_ORDER = "IslandOrderAgency:GEN_NEW_ORDER"
var0_0.UDPATE_ORDER = "IslandOrderAgency:UDPATE_ORDER"
var0_0.ORDER_FINISH_UPDATE = "IslandOrderAgency:ORDER_FINISH_UPDATE"
var0_0.COMMON_ORDER_TYPE = 1
var0_0.URGENCY_ORDER_TYPE = 2
var0_0.SHIP_ORDER_TYPE = 3

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.order_system or {}

	arg0_1.exp = var0_1.favor or 0
	arg0_1.tendency = var0_1.daily_select or IslandOrderSlot.TENDENCY_TYPE_COMMON
	arg0_1.finishCnt = var0_1.daily_slot_num or 0
	arg0_1.urgencyFinishCnt = var0_1.time_slot_num or 0
	arg0_1.awardIndexList = {}

	for iter0_1, iter1_1 in ipairs(var0_1.get_favor or {}) do
		table.insert(arg0_1.awardIndexList, iter1_1)
	end

	arg0_1.slotList = {}

	for iter2_1, iter3_1 in ipairs(var0_1.slot_list or {}) do
		local var1_1 = IslandOrderSlot.New(iter3_1)

		arg0_1.slotList[var1_1.id] = var1_1
	end

	arg0_1.shipSlotList = {}

	for iter4_1, iter5_1 in ipairs(pg.island_order_list.get_id_list_by_type[var0_0.SHIP_ORDER_TYPE]) do
		local var2_1 = IslandShipOrderSlot.New({
			id = iter5_1
		})

		arg0_1.shipSlotList[var2_1.id] = var2_1
	end

	for iter6_1, iter7_1 in ipairs(var0_1.ship_slot_list or {}) do
		local var3_1 = arg0_1.shipSlotList[iter7_1.id]

		if var3_1 then
			var3_1:Init(iter7_1, true)
		end
	end
end

function var0_0.GetShipSlotList(arg0_2)
	return arg0_2.shipSlotList
end

function var0_0.GetShipOrderSlot(arg0_3, arg1_3)
	return arg0_3.shipSlotList[arg1_3]
end

function var0_0.AddSlot(arg0_4, arg1_4)
	local var0_4 = IslandOrderSlot.New(arg1_4)

	arg0_4.slotList[var0_4.id] = var0_4

	arg0_4:DispatchEvent(var0_0.GEN_NEW_ORDER, {
		slotId = var0_4.id
	})
end

function var0_0.UpdateSlot(arg0_5, arg1_5)
	local var0_5 = arg0_5.slotList[arg1_5.id]

	var0_5:Flush(arg1_5)
	arg0_5:DispatchEvent(var0_0.UDPATE_ORDER, {
		slotId = var0_5.id
	})
end

function var0_0.RemoveSlot(arg0_6, arg1_6)
	arg0_6.slotList[arg1_6] = nil
end

function var0_0.UpdateOrAddOrder(arg0_7, arg1_7)
	if arg0_7.slotList[arg1_7.id] then
		arg0_7:AddSlot(arg1_7)
	else
		arg0_7:UpdateSlot(arg1_7)
	end
end

function var0_0.IncFinishCnt(arg0_8)
	arg0_8.finishCnt = arg0_8.finishCnt + 1
end

function var0_0.GetFinishCnt(arg0_9)
	return arg0_9.finishCnt
end

function var0_0.GetMaxFinishCount(arg0_10)
	return pg.island_set.order_daily_limit_num.key_value_int
end

function var0_0.IncUrgencyFinishCnt(arg0_11)
	arg0_11.urgencyFinishCnt = arg0_11.urgencyFinishCnt + 1
end

function var0_0.GetUrgentFinishCnt(arg0_12)
	return arg0_12.urgencyFinishCnt
end

function var0_0.GetMaxUrgentFinishCnt(arg0_13)
	return pg.island_set.order_special_limit_num.key_value_int
end

function var0_0.GetLeftUrgentCnt(arg0_14)
	return arg0_14:GetMaxUrgentFinishCnt() - arg0_14:GetUrgentFinishCnt()
end

function var0_0.GetTendency(arg0_15)
	return arg0_15.tendency
end

function var0_0.SetTendency(arg0_16, arg1_16)
	arg0_16.tendency = arg1_16
end

function var0_0.AddExp(arg0_17, arg1_17)
	if arg0_17:IsMaxLevel() then
		return
	end

	arg0_17.exp = arg0_17.exp + arg1_17
end

function var0_0.GetExp(arg0_18)
	return arg0_18.exp
end

function var0_0.GetTargetExp(arg0_19)
	local var0_19 = arg0_19:GetLevel()

	return arg0_19:StaticGetTargetExp(var0_19)
end

function var0_0.GetNextTargetExp(arg0_20)
	if arg0_20:IsMaxLevel() then
		return 0
	end

	local var0_20 = arg0_20:GetLevel()

	return arg0_20:StaticGetTargetExp(var0_20 + 1)
end

function var0_0.StaticGetTargetExp(arg0_21, arg1_21)
	return pg.island_order_favor[arg1_21].exp
end

function var0_0.GetLevel(arg0_22)
	local var0_22 = 0

	for iter0_22, iter1_22 in ipairs(pg.island_order_favor.all) do
		local var1_22 = pg.island_order_favor[iter1_22]

		if arg0_22.exp >= var1_22.exp then
			var0_22 = iter1_22
		end
	end

	return var0_22
end

function var0_0.IsMaxLevel(arg0_23)
	local var0_23 = arg0_23:GetLevel()

	return arg0_23:StaticIsMaxLevel(var0_23)
end

function var0_0.StaticIsMaxLevel(arg0_24, arg1_24)
	local var0_24 = pg.island_order_favor.all

	return arg1_24 >= var0_24[#var0_24]
end

function var0_0.GetSlots(arg0_25)
	return arg0_25.slotList
end

function var0_0.GetSlot(arg0_26, arg1_26)
	return arg0_26.slotList[arg1_26]
end

function var0_0.IsGotAward(arg0_27, arg1_27)
	return table.contains(arg0_27.awardIndexList, arg1_27)
end

function var0_0.UpdateGotAwardList(arg0_28, arg1_28)
	if not arg0_28:IsGotAward(arg1_28) then
		table.insert(arg0_28.awardIndexList, arg1_28)
	end
end

function var0_0.GetAllCanGetAwardList(arg0_29)
	local var0_29 = {}

	for iter0_29, iter1_29 in ipairs(pg.island_order_favor.all) do
		if arg0_29:CanGetAward(iter1_29) then
			table.insert(var0_29, iter1_29)
		end
	end

	return var0_29
end

function var0_0.CanGetAward(arg0_30, arg1_30)
	if arg0_30:IsGotAward(arg1_30) then
		return false
	end

	return arg0_30:StaticGetTargetExp(arg1_30) <= arg0_30.exp
end

local var1_0 = "island_next_submit_order_time"

function var0_0.RecordNextCanSubmitTime(arg0_31)
	local var0_31 = getProxy(PlayerProxy):getRawData().id
	local var1_31 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_31 = pg.island_set.order_complete_refresh_time.key_value_int

	PlayerPrefs.SetInt(var1_0 .. var0_31, var1_31 + var2_31)
	PlayerPrefs.Save()
end

function var0_0.CanSubmitOrder(arg0_32)
	local var0_32 = getProxy(PlayerProxy):getRawData().id
	local var1_32 = PlayerPrefs.GetInt(var1_0 .. var0_32, 0)
	local var2_32 = pg.TimeMgr.GetInstance():GetServerTime()

	return var1_32 <= 0 or var1_32 <= var2_32, var1_32
end

local var2_0 = "island_selected_order_id"

function var0_0.GetCacheSelectedId(arg0_33)
	local var0_33 = getProxy(PlayerProxy):getRawData().id

	return (PlayerPrefs.GetInt(var2_0 .. var0_33, 0))
end

function var0_0.SetCacheSelectedId(arg0_34, arg1_34)
	local var0_34 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var2_0 .. var0_34, arg1_34)
	PlayerPrefs.Save()
end

function var0_0.UpdatePerDay(arg0_35)
	arg0_35.finishCnt = 0

	if pg.TimeMgr.GetInstance():GetServerWeek() == 1 then
		arg0_35.urgencyFinishCnt = 0
		arg0_35.exp = 0
	end

	arg0_35:DispatchEvent(var0_0.ORDER_FINISH_UPDATE)
end

return var0_0
