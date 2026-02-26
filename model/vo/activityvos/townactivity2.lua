local var0_0 = class("TownActivity2", import("model.vo.Activity"))

var0_0.Thousand = 1000
var0_0.Million = 1000000
var0_0.Billion = 1000000000
var0_0.MaxGold = 99999999999
var0_0.OPERATION = {
	UPGRADE_PLACE = 2,
	SETTLE_GOLD = 5,
	CLICK_BUBBLE = 4,
	CHANGE_SHIPS = 3,
	UPGRADE_TOWN = 1,
	ALL_GOLD = 6
}

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.listLVList = pg.activity_town_2[arg0_1.id].level_up_gold
	arg0_1.listLVList2 = {}

	for iter0_1 = 1, #arg0_1.listLVList do
		local var0_1 = arg0_1:OnSettleGold2(iter0_1)

		table.insert(arg0_1.listLVList2, var0_1)
	end

	arg0_1.bubbleTipTag = false
	arg0_1.placeData, arg0_1.slotData = {}, {}
	arg0_1.nextplaceData = {}
	arg0_1.settleGold, arg0_1.totalGold = 0, 0
	arg0_1.totalGold2 = 0
	arg0_1.AllGold = 0

	for iter1_1, iter2_1 in ipairs(arg1_1.date1_key_value_list) do
		if iter2_1.key == 1 then
			for iter3_1, iter4_1 in ipairs(iter2_1.value_list) do
				local var1_1 = TownWorkplace2.New(iter4_1.key, iter4_1.value)

				if var1_1:GetGroup() ~= -1 then
					arg0_1.placeData[var1_1:GetGroup()] = var1_1
				end
			end
		end

		if iter2_1.key == 2 then
			for iter5_1, iter6_1 in ipairs(iter2_1.value_list) do
				arg0_1.slotData[iter5_1] = TownBubbleSlot2.New(iter5_1, iter6_1.key, iter6_1.value)
			end
		end

		if iter2_1.key == 3 then
			for iter7_1, iter8_1 in ipairs(iter2_1.value_list) do
				if iter8_1.key == 1 then
					arg0_1.settleGold = arg0_1.settleGold + iter8_1.value
				end

				if iter8_1.key == 2 then
					arg0_1.settleGold = arg0_1.settleGold + iter8_1.value * var0_0.Million
				end

				if iter8_1.key == 3 then
					arg0_1.settleGold = arg0_1.settleGold + iter8_1.value * var0_0.Billion
				end
			end
		end

		if iter2_1.key == 4 then
			for iter9_1, iter10_1 in ipairs(iter2_1.value_list) do
				if iter9_1 == 1 then
					arg0_1.totalGold2 = arg0_1.totalGold2 + iter10_1.value

					break
				end
			end
		end

		if iter2_1.key == 5 then
			for iter11_1, iter12_1 in ipairs(iter2_1.value_list) do
				if iter12_1.key == 1 then
					arg0_1.AllGold = arg0_1.AllGold + iter12_1.value
				end

				if iter12_1.key == 2 then
					arg0_1.AllGold = arg0_1.AllGold + iter12_1.value * var0_0.Million
				end

				if iter12_1.key == 3 then
					arg0_1.AllGold = arg0_1.AllGold + iter12_1.value * var0_0.Billion
				end
			end
		end
	end

	arg0_1:UpdateTotalGold()
	arg0_1:UpdateEmptySlots()
end

function var0_0.GetPtAllGold(arg0_2)
	return arg0_2.AllGold or 0
end

function var0_0.AddAllGold(arg0_3, arg1_3)
	arg0_3.AllGold = arg0_3.AllGold + arg1_3
end

function var0_0.GetTownLevel(arg0_4)
	return arg0_4:TownLevel()
end

function var0_0.GetGold(arg0_5)
	return arg0_5.totalGold
end

function var0_0.GetGold2(arg0_6)
	return arg0_6.totalGold2
end

function var0_0.AddGold(arg0_7, arg1_7)
	arg0_7.settleGold = arg0_7.settleGold + arg1_7

	arg0_7:UpdateTotalGold()
end

function var0_0.AddGold2(arg0_8, arg1_8)
	arg0_8.totalGold2 = arg0_8.totalGold2 + arg1_8
end

function var0_0.GoldFull(arg0_9)
	local var0_9 = arg0_9:GetLimitGold()

	if var0_9 <= arg0_9.settleGold then
		return false
	elseif var0_9 > arg0_9.settleGold then
		return true
	end

	return false
end

function var0_0.UpgradeGold(arg0_10, arg1_10)
	for iter0_10, iter1_10 in pairs(arg0_10.placeData) do
		if iter1_10:GetId() == arg1_10 then
			if #iter1_10:GetUpgrade() == 1 then
				if arg0_10:GetGold() >= iter1_10:GetUpgrade()[1][3] then
					return true
				end
			elseif #iter1_10:GetUpgrade() == 2 and arg0_10:GetGold() >= iter1_10:GetUpgrade()[1][3] and arg0_10:GetGold2() >= iter1_10:GetUpgrade()[2][3] then
				return true
			end
		end
	end

	return false
end

function var0_0.GetplaceUpgrade(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg0_11.placeData) do
		if iter1_11:GetId() == arg1_11 and iter1_11:GetType() == 1 then
			if iter1_11:GetTypeParam() == 0 then
				return false
			elseif iter1_11:GetTypeParam() > 0 and iter1_11:GetType() == 1 then
				return true
			end
		end
	end
end

function var0_0.GetUpgradeGold(arg0_12, arg1_12)
	for iter0_12, iter1_12 in pairs(arg0_12.placeData) do
		if iter1_12:GetId() == arg1_12 then
			return iter1_12:GetUpgrade()
		end
	end
end

function var0_0.GetLimitGold(arg0_13)
	local var0_13

	for iter0_13 = 1, #arg0_13.placeData do
		if arg0_13.placeData[iter0_13]:GetType() == TownWorkplace2.TYPE.RATIO then
			var0_13 = arg0_13.placeData[iter0_13]
		end
	end

	return var0_13:GetTypeParam() or 0
end

function var0_0.TownLevel(arg0_14)
	local var0_14 = arg0_14:GetPtAllGold()
	local var1_14 = 0
	local var2_14 = 1

	while true do
		if var0_14 < arg0_14.listLVList2[var2_14] then
			var1_14 = var2_14

			break
		elseif arg0_14.listLVList2[var2_14 + 1] then
			var2_14 = var2_14 + 1
		else
			break
		end
	end

	if var0_14 > arg0_14.listLVList2[#arg0_14.listLVList2] then
		var1_14 = #arg0_14.listLVList2 + 1
	end

	return var1_14
end

function var0_0.OnSettleGold2(arg0_15, arg1_15)
	local var0_15 = 0

	for iter0_15 = arg1_15, 1, -1 do
		var0_15 = var0_15 + arg0_15:OnlistLVList(iter0_15)
	end

	return var0_15
end

function var0_0.OnlistLVList(arg0_16, arg1_16)
	return arg0_16.listLVList[arg1_16]
end

function var0_0.GetTotalGold(arg0_17)
	return math.min(arg0_17.totalGold, arg0_17:GetLimitGold())
end

function var0_0.GetUnlockSlotCnt(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.placeData) do
		if iter1_18:GetType() == TownWorkplace2.TYPE.ROLE then
			return iter1_18:GetTypeParam()
		end
	end
end

function var0_0.GetGoldOutput(arg0_19)
	local var0_19 = 0

	for iter0_19, iter1_19 in pairs(arg0_19.placeData) do
		var0_19 = var0_19 + math.floor(iter1_19:GetGoldUnit())
	end

	return var0_19
end

function var0_0.UpdateGoldBuff(arg0_20)
	arg0_20.buffFactor = 0

	for iter0_20, iter1_20 in pairs(arg0_20.placeData) do
		arg0_20.buffFactor = arg0_20.buffFactor + iter1_20:GetGoldRatio()
	end

	arg0_20.buffFactor = arg0_20.buffFactor / 10000
end

function var0_0.UpdateTime(arg0_21)
	local var0_21 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_21, iter1_21 in pairs(arg0_21.slotData) do
		iter1_21:OnUpdateTime(var0_21)
	end

	if arg0_21.totalGold >= arg0_21:GetLimitGold() or arg0_21.totalGold >= var0_0.MaxGold then
		arg0_21.totalGold = arg0_21:GetLimitGold()

		return
	end

	arg0_21:UpdateTotalGold()
end

function var0_0.UpdateTotalGold(arg0_22)
	arg0_22.totalGold = math.min(arg0_22.settleGold, arg0_22:GetLimitGold())
end

function var0_0.GetPlaceList(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in pairs(arg0_23.placeData) do
		table.insert(var0_23, iter1_23)
	end

	return var0_23
end

function var0_0.CanUpgradePlace(arg0_24, arg1_24)
	return
end

function var0_0.ResetIdPlace(arg0_25, arg1_25, arg2_25)
	local var0_25 = 0

	for iter0_25, iter1_25 in pairs(arg0_25.placeData) do
		if iter1_25:GetId() == arg2_25 then
			local var1_25 = iter1_25:ResetStartTime(arg1_25)
		end
	end
end

function var0_0.OnUpgradePlace(arg0_26, arg1_26, arg2_26)
	local var0_26 = pg.activity_town_work_level_2[arg1_26].group
	local var1_26 = arg0_26.placeData[var0_26]
	local var2_26 = var1_26:GetUpgrade()

	arg0_26:ResetIdPlace(arg2_26, arg1_26)

	for iter0_26, iter1_26 in ipairs({
		"settleGold",
		"totalGold2"
	}) do
		if var2_26[iter0_26] then
			arg0_26[iter1_26] = arg0_26[iter1_26] - var2_26[iter0_26][3]
		end
	end

	arg0_26.placeData[var0_26] = TownWorkplace2.New(var1_26:GetNextId(), arg2_26)

	arg0_26:UpdateTotalGold(arg2_26)
	arg0_26:UpdateEmptySlots()
end

function var0_0.OnResetIdPlace(arg0_27, arg1_27, arg2_27)
	local var0_27 = 0

	for iter0_27, iter1_27 in pairs(arg0_27.placeData) do
		if iter1_27:GetId() == arg2_27 then
			local var1_27 = iter1_27:ResetStartTime(arg1_27)

			var0_27 = var0_27 + math.floor(var1_27)
		end
	end
end

function var0_0.OnGatherPlaceGold(arg0_28, arg1_28, arg2_28)
	local var0_28 = pg.activity_town_work_level_2[arg1_28].group
	local var1_28 = arg0_28.placeData[var0_28]

	arg0_28:OnResetIdPlace(arg2_28, arg1_28)

	arg0_28.placeData[var0_28] = TownWorkplace2.New(var1_28:GetId(), arg2_28)

	arg0_28:UpdateTotalGold(arg2_28)
end

function var0_0.OnAllGatherPlaceGold(arg0_29, arg1_29)
	local var0_29 = {}
	local var1_29 = {}

	for iter0_29, iter1_29 in ipairs(arg1_29) do
		if iter0_29 % 2 == 0 then
			table.insert(var1_29, iter1_29)
		elseif iter0_29 % 2 ~= 0 then
			table.insert(var0_29, iter1_29)
		end
	end

	for iter2_29 = 1, #var0_29 do
		local var2_29 = pg.activity_town_work_level_2[var0_29[iter2_29]].group
		local var3_29 = arg0_29.placeData[var2_29]

		arg0_29:OnResetIdPlace(var1_29[iter2_29], var0_29)

		arg0_29.placeData[var2_29] = TownWorkplace2.New(var3_29:GetId(), var1_29[iter2_29])

		arg0_29:UpdateTotalGold(var1_29[iter2_29])
	end
end

function var0_0.UpdateEmptySlots(arg0_30)
	for iter0_30 = 1, arg0_30:GetUnlockSlotCnt() do
		if not arg0_30.slotData[iter0_30] then
			arg0_30.slotData[iter0_30] = TownBubbleSlot2.New(iter0_30)
		end
	end
end

function var0_0.GetShipIds(arg0_31)
	local var0_31 = {}

	for iter0_31, iter1_31 in pairs(arg0_31.slotData) do
		table.insert(var0_31, iter1_31:GetShipId())
	end

	return var0_31
end

function var0_0.GetBubbleCntByPos(arg0_32, arg1_32)
	return arg0_32.slotData[arg1_32]:GetPassCnt()
end

function var0_0.OnChangeShips(arg0_33, arg1_33)
	arg0_33:UpdateEmptySlots()

	for iter0_33, iter1_33 in ipairs(arg1_33) do
		arg0_33.slotData[iter1_33.key]:ChangeShip(iter1_33.value)
	end
end

function var0_0.OnGetBubbleAward(arg0_34, arg1_34, arg2_34)
	for iter0_34, iter1_34 in ipairs(arg1_34) do
		arg0_34.slotData[iter1_34]:ResetStartTime(arg2_34[iter0_34])
	end
end

function var0_0.SetBubbleTipTag(arg0_35, arg1_35)
	arg0_35.bubbleTipTag = arg1_35
end

function var0_0.HasEmptySlot(arg0_36)
	for iter0_36, iter1_36 in pairs(arg0_36.slotData) do
		if iter1_36:IsNewEmpty() then
			return true
		end
	end

	return false
end

function var0_0.HasMaxGold(arg0_37)
	return arg0_37.totalGold >= arg0_37:GetLimitGold()
end

function var0_0.CanCostGold(arg0_38)
	if arg0_38:CanUpgradeTown() then
		return true
	end

	for iter0_38, iter1_38 in pairs(arg0_38.placeData) do
		if arg0_38:CanUpgradePlace(iter1_38.id) then
			return true
		end
	end

	return false
end

function var0_0.getVitemNumber(arg0_39, arg1_39)
	assert(pg.item_virtual_data_statistics[arg1_39].link_id == arg0_39.id)

	return arg0_39:GetTotalGold()
end

function var0_0.subVitemNumber(arg0_40, arg1_40, arg2_40)
	assert(pg.item_virtual_data_statistics[arg1_40].link_id == arg0_40.id)

	arg0_40.settleGold = math.max(0, arg0_40.settleGold - arg2_40)
	arg0_40.totalGold = arg0_40.settleGold
end

function var0_0.addVitemNumber(arg0_41, arg1_41, arg2_41)
	return
end

function var0_0.KeepDecimal(arg0_42, arg1_42)
	return math.floor(10^arg1_42 * arg0_42) / 10^arg1_42
end

var0_0.SHOW_NUM_CNT = 1

function var0_0.GoldToShow(arg0_43)
	if arg0_43 >= var0_0.MaxGold then
		return 99.99 .. "M"
	end

	if arg0_43 >= var0_0.Billion then
		if arg0_43 % var0_0.Billion == 0 then
			return arg0_43 / var0_0.Billion .. "B"
		end

		local var0_43 = arg0_43 / var0_0.Billion

		return var0_0.KeepDecimal(var0_43, 1) .. "B"
	elseif arg0_43 >= var0_0.Million then
		if arg0_43 % var0_0.Million == 0 then
			return arg0_43 / var0_0.Million .. "M"
		end

		local var1_43 = arg0_43 / var0_0.Million

		return var0_0.KeepDecimal(var1_43, 1) .. "M"
	elseif arg0_43 >= var0_0.Thousand then
		if arg0_43 % var0_0.Thousand == 0 then
			return arg0_43 / var0_0.Thousand .. "K"
		end

		local var2_43 = arg0_43 / var0_0.Thousand

		return var0_0.KeepDecimal(var2_43, 1) .. "K"
	end

	return arg0_43
end

return var0_0
