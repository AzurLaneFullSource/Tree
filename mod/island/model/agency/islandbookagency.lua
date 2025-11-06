local var0_0 = class("IslandBookAgency", import(".IslandBaseAgency"))

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.view_book
	local var1_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1.book_list) do
		table.insert(var1_1, iter1_1)
	end

	local var2_1 = {}

	for iter2_1, iter3_1 in ipairs(var0_1.cond_list) do
		if not var2_1[iter3_1.type] then
			var2_1[iter3_1.type] = {}
		end

		for iter4_1, iter5_1 in ipairs(iter3_1.unlock_ids) do
			var2_1[iter3_1.type][iter5_1] = true
		end
	end

	arg0_1.dataMap = {}

	for iter6_1, iter7_1 in ipairs(pg.island_illustrated_guide.all) do
		local var3_1, var4_1 = IslandIllustration.GetTypeAndLinkId(iter7_1)

		if not arg0_1.dataMap[var3_1] then
			arg0_1.dataMap[var3_1] = {}
		end

		local var5_1 = arg0_1:CreateClass(var3_1, iter7_1)

		if table.contains(var1_1, iter7_1) then
			var5_1:SetStatus(IslandIllustration.STATUS.UNLOCK)
		elseif var2_1[var3_1] and var2_1[var3_1][var4_1] then
			var5_1:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
		end

		arg0_1.dataMap[var3_1][var4_1] = var5_1
	end

	arg0_1:SetPointDatas(var0_1.book_collects)
	arg0_1:SetRecordDatas(var0_1.item_list or {})

	arg0_1.pointAwardGotMaps = {}
	arg0_1.pointAwardIdsMaps = {}

	for iter8_1, iter9_1 in ipairs(pg.island_collection_reward.get_id_list_by_type) do
		arg0_1.pointAwardGotMaps[iter8_1] = {}
		arg0_1.pointAwardIdsMaps[iter8_1] = iter9_1

		table.sort(arg0_1.pointAwardIdsMaps[iter8_1], CompareFuncs({
			function(arg0_2)
				return pg.island_collection_reward[arg0_2].level
			end,
			function(arg0_3)
				return arg0_3
			end
		}))
	end

	local var6_1 = pg.island_collection_reward

	for iter10_1, iter11_1 in ipairs(var0_1.book_awards) do
		local var7_1 = var6_1[iter11_1].type

		table.insert(arg0_1.pointAwardGotMaps[var7_1], iter11_1)
	end
end

function var0_0.CreateClass(arg0_4, arg1_4, arg2_4)
	return switch(arg1_4, {
		[IslandIllustration.TYPES.CHAR] = function()
			return IslandCharIllustration.New(arg2_4)
		end,
		[IslandIllustration.TYPES.ITEM] = function()
			return IslandItemIllustration.New(arg2_4)
		end
	}, function()
		return IslandIllustration.New(arg2_4)
	end)
end

function var0_0.SetRecordDatas(arg0_8, arg1_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		var0_8[iter1_8.id] = iter1_8.num
	end

	for iter2_8, iter3_8 in pairs(arg0_8.dataMap[IslandIllustration.TYPES.ITEM] or {}) do
		iter3_8:SetHistoryCnt(var0_8[iter3_8:GetLinkConfigID()] or 0)
	end
end

function var0_0.SetPointDatas(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg1_9 or {}) do
		local var0_9, var1_9 = IslandIllustration.GetTypeAndLinkId(iter1_9.id)

		arg0_9.dataMap[var0_9][var1_9]:SetPointData(iter1_9)
	end
end

function var0_0.InitShipTypeData(arg0_10)
	local var0_10 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	for iter0_10, iter1_10 in pairs(arg0_10.dataMap[IslandIllustration.TYPES.CHAR] or {}) do
		if var0_10:GetShipById(iter1_10:GetLinkConfigID()) then
			local var1_10 = iter1_10:GetStatus()

			if var1_10 == IslandIllustration.STATUS.UNLOCK then
				iter1_10:CheckTip()
			elseif var1_10 == IslandIllustration.STATUS.LOCK then
				iter1_10:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
			end
		end
	end
end

function var0_0.GetListByType(arg0_11, arg1_11)
	return underscore.values(arg0_11.dataMap[arg1_11])
end

function var0_0.GetIllustration(arg0_12, arg1_12, arg2_12)
	return arg0_12.dataMap[arg1_12] and arg0_12.dataMap[arg1_12][arg2_12]
end

function var0_0.GetTotalPoints(arg0_13)
	local var0_13 = 0

	for iter0_13, iter1_13 in pairs(arg0_13.dataMap) do
		for iter2_13, iter3_13 in pairs(iter1_13) do
			var0_13 = var0_13 + iter3_13:GetPoints()
		end
	end

	return var0_13
end

function var0_0.GetAllPoints(arg0_14, arg1_14)
	local var0_14 = 0

	for iter0_14, iter1_14 in pairs(arg0_14.dataMap[arg1_14]) do
		var0_14 = var0_14 + iter1_14:GetPoints()
	end

	return var0_14
end

function var0_0.GetPoints(arg0_15, arg1_15, arg2_15)
	return arg0_15.dataMap[arg1_15][arg2_15]:GetPoints()
end

function var0_0.GetCurLevelPointAwardId(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.pointAwardIdsMaps[arg1_16]) do
		if not table.contains(arg0_16.pointAwardGotMaps[arg1_16], iter1_16) then
			return iter1_16
		end
	end

	return arg0_16.pointAwardIdsMaps[arg1_16][#arg0_16.pointAwardIdsMaps[arg1_16]]
end

function var0_0.GetPointAwardIds(arg0_17, arg1_17)
	return arg0_17.pointAwardIdsMaps[arg1_17]
end

function var0_0.GetPointAwardGotIds(arg0_18, arg1_18)
	return arg0_18.pointAwardGotMaps[arg1_18]
end

function var0_0.IsGotAllPointAward(arg0_19, arg1_19)
	return table.contains(arg0_19.pointAwardGotMaps[arg1_19], arg0_19.pointAwardIdsMaps[arg1_19][#arg0_19.pointAwardIdsMaps[arg1_19]])
end

function var0_0.GetCurPointInfos(arg0_20, arg1_20)
	local var0_20 = arg0_20:GetCurLevelPointAwardId(arg1_20)

	return arg0_20:GetAllPoints(arg1_20), pg.island_collection_reward[var0_20].need_exp
end

function var0_0.AddCanUnlock(arg0_21, arg1_21, arg2_21)
	arg0_21.dataMap[arg1_21][arg2_21]:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
end

function var0_0.HandlePushData(arg0_22, arg1_22)
	local var0_22 = IslandIllustration.TYPES.ITEM

	for iter0_22, iter1_22 in ipairs(arg1_22) do
		local var1_22 = arg0_22.dataMap[var0_22][iter1_22.id]

		if var1_22 then
			if var1_22:GetStatus() == IslandIllustration.STATUS.LOCK then
				arg0_22:AddCanUnlock(var0_22, iter1_22.id)
			end

			var1_22:AddHistoryCnt(iter1_22.num)
			var1_22:CheckTip()
		end
	end
end

function var0_0.AddUnlock(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg1_23) do
		local var0_23, var1_23 = IslandIllustration.GetTypeAndLinkId(iter1_23)

		arg0_23.dataMap[var0_23][var1_23]:SetStatus(IslandIllustration.STATUS.UNLOCK)
		arg0_23.dataMap[var0_23][var1_23]:CheckTip()
	end
end

function var0_0.AddPointAwardGotId(arg0_24, arg1_24)
	local var0_24 = pg.island_collection_reward[arg1_24].type

	table.insert(arg0_24.pointAwardGotMaps[var0_24], arg1_24)
end

function var0_0.OnGetPointDone(arg0_25, arg1_25)
	arg0_25:SetPointDatas(arg1_25)

	for iter0_25, iter1_25 in ipairs(arg1_25 or {}) do
		local var0_25, var1_25 = IslandIllustration.GetTypeAndLinkId(iter1_25.id)

		arg0_25.dataMap[var0_25][var1_25]:CheckTip()
	end
end

function var0_0.OnAddNewShip(arg0_26, arg1_26)
	local var0_26 = arg0_26.dataMap[IslandIllustration.TYPES.CHAR][arg1_26]

	if var0_26 then
		var0_26:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
	end
end

function var0_0.OnShipUpgradeOrBreakOut(arg0_27, arg1_27)
	local var0_27 = arg0_27.dataMap[IslandIllustration.TYPES.CHAR][arg1_27]

	if var0_27 then
		var0_27:CheckTip()
	end
end

function var0_0.IsTipFromTypes(arg0_28, arg1_28)
	for iter0_28, iter1_28 in ipairs(arg1_28) do
		local var0_28, var1_28 = arg0_28:GetCurPointInfos(iter1_28)

		if not arg0_28:IsGotAllPointAward(iter1_28) and var1_28 <= var0_28 then
			return true
		end

		for iter2_28, iter3_28 in pairs(arg0_28.dataMap[iter1_28] or {}) do
			if iter3_28:IsTip() then
				return true
			end
		end
	end

	return false
end

return var0_0
