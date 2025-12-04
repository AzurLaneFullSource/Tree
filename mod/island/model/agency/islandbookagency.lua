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
		end,
		[IslandIllustration.TYPES.FISH] = function()
			return IslandFishIllustration.New(arg2_4)
		end
	}, function()
		return IslandIllustration.New(arg2_4)
	end)
end

function var0_0.SetRecordDatas(arg0_9, arg1_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		var0_9[iter1_9.id] = iter1_9.num
	end

	for iter2_9, iter3_9 in pairs(arg0_9.dataMap[IslandIllustration.TYPES.ITEM] or {}) do
		iter3_9:SetHistoryCnt(var0_9[iter3_9:GetLinkConfigID()] or 0)
	end
end

function var0_0.SetPointDatas(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg1_10 or {}) do
		local var0_10, var1_10 = IslandIllustration.GetTypeAndLinkId(iter1_10.id)

		arg0_10.dataMap[var0_10][var1_10]:SetPointData(iter1_10)
	end
end

function var0_0.InitRuntimeTypesData(arg0_11)
	arg0_11:InitShipTypeData()
	arg0_11:InitFishTypeData()
end

function var0_0.InitShipTypeData(arg0_12)
	local var0_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	for iter0_12, iter1_12 in pairs(arg0_12.dataMap[IslandIllustration.TYPES.CHAR] or {}) do
		if var0_12:GetShipById(iter1_12:GetLinkConfigID()) then
			local var1_12 = iter1_12:GetStatus()

			if var1_12 == IslandIllustration.STATUS.UNLOCK then
				iter1_12:CheckTip()
			elseif var1_12 == IslandIllustration.STATUS.LOCK then
				iter1_12:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
			end
		end
	end
end

function var0_0.InitFishTypeData(arg0_13)
	local var0_13 = getProxy(IslandProxy):GetIsland():GetFishingAgency()

	for iter0_13, iter1_13 in pairs(arg0_13.dataMap[IslandIllustration.TYPES.FISH] or {}) do
		if var0_13:GetFish(iter1_13:GetLinkConfigID()) then
			local var1_13 = iter1_13:GetStatus()

			if var1_13 == IslandIllustration.STATUS.UNLOCK then
				iter1_13:CheckTip()
			elseif var1_13 == IslandIllustration.STATUS.LOCK then
				iter1_13:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
			end
		end
	end
end

function var0_0.GetListByType(arg0_14, arg1_14)
	return underscore.values(arg0_14.dataMap[arg1_14])
end

function var0_0.GetIllustration(arg0_15, arg1_15, arg2_15)
	return arg0_15.dataMap[arg1_15] and arg0_15.dataMap[arg1_15][arg2_15]
end

function var0_0.GetTotalPoints(arg0_16)
	local var0_16 = 0

	for iter0_16, iter1_16 in pairs(arg0_16.dataMap) do
		for iter2_16, iter3_16 in pairs(iter1_16) do
			var0_16 = var0_16 + iter3_16:GetPoints()
		end
	end

	return var0_16
end

function var0_0.GetAllPoints(arg0_17, arg1_17)
	local var0_17 = 0

	for iter0_17, iter1_17 in pairs(arg0_17.dataMap[arg1_17]) do
		var0_17 = var0_17 + iter1_17:GetPoints()
	end

	return var0_17
end

function var0_0.GetPoints(arg0_18, arg1_18, arg2_18)
	return arg0_18.dataMap[arg1_18][arg2_18]:GetPoints()
end

function var0_0.GetCurLevelPointAwardId(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.pointAwardIdsMaps[arg1_19]) do
		if not table.contains(arg0_19.pointAwardGotMaps[arg1_19], iter1_19) then
			return iter1_19
		end
	end

	return arg0_19.pointAwardIdsMaps[arg1_19][#arg0_19.pointAwardIdsMaps[arg1_19]]
end

function var0_0.GetPointAwardIds(arg0_20, arg1_20)
	return arg0_20.pointAwardIdsMaps[arg1_20]
end

function var0_0.GetPointAwardGotIds(arg0_21, arg1_21)
	return arg0_21.pointAwardGotMaps[arg1_21]
end

function var0_0.IsGotAllPointAward(arg0_22, arg1_22)
	return table.contains(arg0_22.pointAwardGotMaps[arg1_22], arg0_22.pointAwardIdsMaps[arg1_22][#arg0_22.pointAwardIdsMaps[arg1_22]])
end

function var0_0.GetCurPointInfos(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetCurLevelPointAwardId(arg1_23)

	return arg0_23:GetAllPoints(arg1_23), pg.island_collection_reward[var0_23].need_exp
end

function var0_0.AddCanUnlock(arg0_24, arg1_24, arg2_24)
	arg0_24.dataMap[arg1_24][arg2_24]:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
end

function var0_0.HandlePushData(arg0_25, arg1_25)
	local var0_25 = IslandIllustration.TYPES.ITEM

	for iter0_25, iter1_25 in ipairs(arg1_25) do
		local var1_25 = arg0_25.dataMap[var0_25][iter1_25.id]

		if var1_25 then
			if var1_25:GetStatus() == IslandIllustration.STATUS.LOCK then
				arg0_25:AddCanUnlock(var0_25, iter1_25.id)
			end

			var1_25:AddHistoryCnt(iter1_25.num)
			var1_25:CheckTip()
		end
	end
end

function var0_0.AddUnlock(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg1_26) do
		local var0_26, var1_26 = IslandIllustration.GetTypeAndLinkId(iter1_26)

		arg0_26.dataMap[var0_26][var1_26]:SetStatus(IslandIllustration.STATUS.UNLOCK)
		arg0_26.dataMap[var0_26][var1_26]:CheckTip()
	end
end

function var0_0.AddPointAwardGotId(arg0_27, arg1_27)
	local var0_27 = pg.island_collection_reward[arg1_27].type

	table.insert(arg0_27.pointAwardGotMaps[var0_27], arg1_27)
end

function var0_0.OnGetPointDone(arg0_28, arg1_28)
	arg0_28:SetPointDatas(arg1_28)

	for iter0_28, iter1_28 in ipairs(arg1_28 or {}) do
		local var0_28, var1_28 = IslandIllustration.GetTypeAndLinkId(iter1_28.id)

		arg0_28.dataMap[var0_28][var1_28]:CheckTip()
	end
end

function var0_0.OnAddNewShip(arg0_29, arg1_29)
	local var0_29 = arg0_29.dataMap[IslandIllustration.TYPES.CHAR][arg1_29]

	if var0_29 then
		var0_29:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
	end
end

function var0_0.OnShipUpgradeOrBreakOut(arg0_30, arg1_30)
	local var0_30 = arg0_30.dataMap[IslandIllustration.TYPES.CHAR][arg1_30]

	if var0_30 then
		var0_30:CheckTip()
	end
end

function var0_0.OnFishingEnd(arg0_31, arg1_31)
	if not arg0_31.dataMap[IslandIllustration.TYPES.FISH] then
		arg0_31.dataMap[IslandIllustration.TYPES.FISH] = {}
	end

	local var0_31 = arg0_31.dataMap[IslandIllustration.TYPES.FISH][arg1_31]

	if var0_31 then
		if var0_31:GetStatus() == IslandIllustration.STATUS.LOCK then
			arg0_31:AddCanUnlock(IslandIllustration.TYPES.FISH, arg1_31)
		end

		var0_31:CheckTip()
	end
end

function var0_0.IsTipFromTypes(arg0_32, arg1_32)
	for iter0_32, iter1_32 in ipairs(arg1_32) do
		if iter1_32 ~= IslandIllustration.TYPES.FISH or IslandMainBtnTipHelper.IsUnlock("book_fish") then
			local var0_32, var1_32 = arg0_32:GetCurPointInfos(iter1_32)

			if not arg0_32:IsGotAllPointAward(iter1_32) and var1_32 <= var0_32 then
				return true
			end

			for iter2_32, iter3_32 in pairs(arg0_32.dataMap[iter1_32] or {}) do
				if iter3_32:IsTip() then
					return true
				end
			end
		end
	end

	return false
end

return var0_0
