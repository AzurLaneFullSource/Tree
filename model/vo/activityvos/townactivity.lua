local var0_0 = class("TownActivity", import("model.vo.Activity"))

var0_0.Thousand = 1000
var0_0.Million = 1000000
var0_0.Billion = 1000000000
var0_0.MaxGold = 99999999999
var0_0.OPERATION = {
	UPGRADE_PLACE = 2,
	SETTLE_GOLD = 5,
	CLICK_BUBBLE = 4,
	CHANGE_SHIPS = 3,
	UPGRADE_TOWN = 1
}

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = arg0_1:getConfig("config_client").storyActID

	arg0_1.storyList = pg.activity_template[var0_1].config_client.story
	arg0_1.levelCfg = pg.activity_town_level
	arg0_1.bubbleTipTag = false
	arg0_1.placeData, arg0_1.slotData = {}, {}
	arg0_1.settleGold, arg0_1.totalGold = 0, 0

	for iter0_1, iter1_1 in ipairs(arg1_1.date1_key_value_list) do
		if iter1_1.key == 1 then
			for iter2_1, iter3_1 in ipairs(iter1_1.value_list) do
				local var1_1 = TownWorkplace.New(iter3_1.key, iter3_1.value)

				if var1_1:GetLevel() ~= 0 or arg0_1.data2 >= var1_1:GetNeedTownLv() then
					arg0_1.placeData[var1_1:GetGroup()] = var1_1
				end
			end
		end

		if iter1_1.key == 2 then
			for iter4_1, iter5_1 in ipairs(iter1_1.value_list) do
				arg0_1.slotData[iter4_1] = TownBubbleSlot.New(iter4_1, iter5_1.key, iter5_1.value)
			end
		end

		if iter1_1.key == 3 then
			for iter6_1, iter7_1 in ipairs(iter1_1.value_list) do
				if iter7_1.key == 1 then
					arg0_1.settleGold = arg0_1.settleGold + iter7_1.value
				end

				if iter7_1.key == 2 then
					arg0_1.settleGold = arg0_1.settleGold + iter7_1.value * var0_0.Million
				end

				if iter7_1.key == 3 then
					arg0_1.settleGold = arg0_1.settleGold + iter7_1.value * var0_0.Billion
				end
			end
		end
	end

	arg0_1:UpdateEmptySlots()
	arg0_1:UpdateGoldBuff()
end

function var0_0.GetExp(arg0_2)
	return arg0_2.data1
end

function var0_0.AddExp(arg0_3, arg1_3)
	arg0_3.data1 = arg0_3.data1 + arg1_3
end

function var0_0.AddGold(arg0_4, arg1_4)
	arg0_4.settleGold = math.min(arg0_4.settleGold + arg1_4, arg0_4:GetLimitGold())
end

function var0_0.GetTownLevel(arg0_5)
	return arg0_5.data2
end

function var0_0.IsMaxTownLevel(arg0_6)
	return not arg0_6.levelCfg[arg0_6:GetTownLevel() + 1]
end

function var0_0.UpgradeTownLevel(arg0_7)
	arg0_7.data2 = arg0_7.data2 + 1
end

function var0_0.GetUnlockSlotCnt(arg0_8)
	return arg0_8.levelCfg[arg0_8.data2].unlock_chara
end

function var0_0.GetGoldOutput(arg0_9)
	local var0_9 = 0

	for iter0_9, iter1_9 in pairs(arg0_9.placeData) do
		var0_9 = var0_9 + math.floor(iter1_9:GetGoldUnit() * 3600 * (1 + arg0_9.buffFactor))
	end

	return var0_9
end

function var0_0.GetLimitGold(arg0_10)
	return arg0_10.levelCfg[arg0_10.data2].gold_max
end

function var0_0.GetTotalGold(arg0_11)
	return math.min(arg0_11.totalGold, arg0_11:GetLimitGold())
end

function var0_0.UpdateGoldBuff(arg0_12)
	arg0_12.buffFactor = 0

	for iter0_12, iter1_12 in pairs(arg0_12.placeData) do
		arg0_12.buffFactor = arg0_12.buffFactor + iter1_12:GetGoldRatio()
	end

	arg0_12.buffFactor = arg0_12.buffFactor / 10000
end

function var0_0.UpdateTime(arg0_13)
	local var0_13 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_13, iter1_13 in pairs(arg0_13.slotData) do
		iter1_13:OnUpdateTime(var0_13)
	end

	if arg0_13.totalGold >= arg0_13:GetLimitGold() or arg0_13.totalGold >= var0_0.MaxGold then
		arg0_13.totalGold = arg0_13:GetLimitGold()

		return
	end

	arg0_13:UpdateTotalGold(var0_13)
end

function var0_0.UpdateTotalGold(arg0_14, arg1_14)
	local var0_14 = 0

	for iter0_14, iter1_14 in pairs(arg0_14.placeData) do
		iter1_14:OnUpdateTime(arg1_14)

		var0_14 = var0_14 + math.floor(iter1_14:GetStoredGold() * (1 + arg0_14.buffFactor))
	end

	arg0_14.totalGold = math.min(arg0_14.settleGold + var0_14, arg0_14:GetLimitGold())
end

function var0_0.GetUnlockStoryCnt(arg0_15)
	return underscore.reduce(underscore.flatten(arg0_15.storyList), 0, function(arg0_16, arg1_16)
		return arg0_16 + (pg.NewStoryMgr.GetInstance():IsPlayed(arg1_16) and 1 or 0)
	end)
end

function var0_0.CanUpgradeTown(arg0_17)
	if arg0_17:IsMaxTownLevel() then
		return false, "max"
	end

	if arg0_17.totalGold < arg0_17.levelCfg[arg0_17:GetTownLevel()].gold then
		return false, "no_exp_or_gold", "no_gold"
	end

	if arg0_17:GetExp() < arg0_17.levelCfg[arg0_17:GetTownLevel()].exp then
		return false, "no_exp_or_gold", "no_exp"
	end

	local var0_17 = arg0_17:GetUnlockStoryCnt()
	local var1_17 = arg0_17.levelCfg[arg0_17:GetTownLevel()].story

	if var0_17 < var1_17 then
		return false, "no_story", {
			var0_17,
			var1_17
		}
	end

	return true, "normal"
end

function var0_0.GetPlaceList(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in pairs(arg0_18.placeData) do
		table.insert(var0_18, iter1_18)
	end

	return var0_18
end

function var0_0.OnUpgradeTown(arg0_19, arg1_19)
	local var0_19 = arg0_19.levelCfg[arg0_19:GetTownLevel()].gold

	arg0_19:ResetAllPlace(arg1_19)
	arg0_19:UpgradeTownLevel()

	arg0_19.settleGold = arg0_19.settleGold - var0_19

	for iter0_19, iter1_19 in ipairs(arg0_19.levelCfg[arg0_19:GetTownLevel()].unlock_work[1]) do
		local var1_19 = TownWorkplace.New(iter1_19, arg1_19)

		arg0_19.placeData[var1_19:GetGroup()] = var1_19
	end

	arg0_19:UpdateTotalGold(arg1_19)
	arg0_19:UpdateEmptySlots()
end

function var0_0.ResetAllPlace(arg0_20, arg1_20)
	local var0_20 = 0

	for iter0_20, iter1_20 in pairs(arg0_20.placeData) do
		local var1_20 = iter1_20:ResetStartTime(arg1_20)

		var0_20 = var0_20 + math.floor(var1_20 * (1 + arg0_20.buffFactor))
	end

	arg0_20:AddGold(var0_20)
end

function var0_0.CanUpgradePlace(arg0_21, arg1_21)
	local var0_21 = pg.activity_town_work_level[arg1_21].group
	local var1_21 = arg0_21.placeData[var0_21]

	if not var1_21:GetNextId() then
		return false, "max"
	end

	if arg0_21:GetTownLevel() < var1_21:GetNeedTownLv() then
		return false, "no_level"
	end

	if arg0_21.totalGold < var1_21:GetCostGold() then
		return false, "no_gold"
	end

	return true, "normal"
end

function var0_0.OnUpgradePlace(arg0_22, arg1_22, arg2_22)
	local var0_22 = pg.activity_town_work_level[arg1_22].group
	local var1_22 = arg0_22.placeData[var0_22]
	local var2_22 = var1_22:GetCostGold()

	arg0_22:ResetAllPlace(arg2_22)

	arg0_22.settleGold = arg0_22.settleGold - var2_22
	arg0_22.placeData[var0_22] = TownWorkplace.New(var1_22:GetNextId(), arg2_22)

	arg0_22:UpdateTotalGold(arg2_22)

	if var1_22:GetType() == TownWorkplace.TYPE.RATIO then
		arg0_22:UpdateGoldBuff()
	end
end

function var0_0.UpdateEmptySlots(arg0_23)
	for iter0_23 = 1, arg0_23:GetUnlockSlotCnt() do
		if not arg0_23.slotData[iter0_23] then
			arg0_23.slotData[iter0_23] = TownBubbleSlot.New(iter0_23)
		end
	end
end

function var0_0.GetShipIds(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.slotData) do
		table.insert(var0_24, iter1_24:GetShipId())
	end

	return var0_24
end

function var0_0.GetBubbleCntByPos(arg0_25, arg1_25)
	return arg0_25.slotData[arg1_25]:GetPassCnt()
end

function var0_0.OnChangeShips(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg1_26) do
		arg0_26.slotData[iter1_26.key]:ChangeShip(iter1_26.value)
	end
end

function var0_0.OnGetBubbleAward(arg0_27, arg1_27, arg2_27)
	for iter0_27, iter1_27 in ipairs(arg1_27) do
		arg0_27.slotData[iter1_27]:ResetStartTime(arg2_27[iter0_27])
	end
end

function var0_0.OnSettleGold(arg0_28, arg1_28)
	arg0_28:ResetAllPlace(arg1_28)
	arg0_28:UpdateTotalGold(arg1_28)
end

function var0_0.SetBubbleTipTag(arg0_29, arg1_29)
	arg0_29.bubbleTipTag = arg1_29
end

function var0_0.HasEmptySlot(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.slotData) do
		if iter1_30:IsNewEmpty() then
			return true
		end
	end

	return false
end

function var0_0.HasMaxGold(arg0_31)
	return arg0_31.totalGold >= arg0_31:GetLimitGold()
end

function var0_0.IsOverGold(arg0_32, arg1_32)
	local var0_32 = arg1_32 * 1000

	if arg0_32.totalGold + var0_32 <= arg0_32:GetLimitGold() then
		return false
	else
		local var1_32 = arg0_32:GetLimitGold() - (arg0_32.totalGold + var0_32)

		return true, math.floor(var1_32 / 1000)
	end
end

function var0_0.CanCostGold(arg0_33)
	if arg0_33:CanUpgradeTown() then
		return true
	end

	for iter0_33, iter1_33 in pairs(arg0_33.placeData) do
		if arg0_33:CanUpgradePlace(iter1_33.id) then
			return true
		end
	end

	return false
end

function var0_0.ShowBubbleTip(arg0_34)
	if arg0_34.bubbleTipTag then
		return false
	end

	for iter0_34, iter1_34 in pairs(arg0_34.slotData) do
		if iter1_34:GetPassCnt() > 0 then
			return true
		end
	end

	return false
end

function var0_0.GetAllVitems(arg0_35)
	return {}
end

function var0_0.getVitemNumber(arg0_36, arg1_36)
	assert(pg.item_virtual_data_statistics[arg1_36].link_id == arg0_36.id)

	return arg0_36:GetTotalGold()
end

function var0_0.subVitemNumber(arg0_37, arg1_37, arg2_37)
	assert(pg.item_virtual_data_statistics[arg1_37].link_id == arg0_37.id)

	arg0_37.settleGold = math.max(0, arg0_37.settleGold - arg2_37)
	arg0_37.totalGold = arg0_37.settleGold
end

function var0_0.addVitemNumber(arg0_38, arg1_38, arg2_38)
	return
end

function var0_0.KeepDecimal(arg0_39, arg1_39)
	return math.floor(10^arg1_39 * arg0_39) / 10^arg1_39
end

var0_0.SHOW_NUM_CNT = 4

function var0_0.GoldToShow(arg0_40)
	if arg0_40 >= var0_0.MaxGold then
		return 99.99 .. "M"
	end

	arg0_40 = arg0_40 / 1000

	if arg0_40 >= var0_0.Billion then
		if arg0_40 % var0_0.Billion == 0 then
			return arg0_40 / var0_0.Billion .. "B"
		end

		local var0_40 = arg0_40 / var0_0.Billion
		local var1_40 = var0_0.SHOW_NUM_CNT - #tostring(math.floor(var0_40))

		return var0_0.KeepDecimal(var0_40, var1_40) .. "B"
	elseif arg0_40 >= var0_0.Million then
		if arg0_40 % var0_0.Million == 0 then
			return arg0_40 / var0_0.Million .. "M"
		end

		local var2_40 = arg0_40 / var0_0.Million
		local var3_40 = var0_0.SHOW_NUM_CNT - #tostring(math.floor(var2_40))

		return var0_0.KeepDecimal(var2_40, var3_40) .. "M"
	elseif arg0_40 >= var0_0.Thousand then
		if arg0_40 % var0_0.Thousand == 0 then
			return arg0_40 / var0_0.Thousand .. "K"
		end

		local var4_40 = arg0_40 / var0_0.Thousand
		local var5_40 = var0_0.SHOW_NUM_CNT - #tostring(math.floor(var4_40))

		return var0_0.KeepDecimal(var4_40, var5_40) .. "K"
	end

	return arg0_40
end

return var0_0
