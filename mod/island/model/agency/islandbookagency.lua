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

		local var5_1 = var3_1 == IslandIllustration.TYPES.CHAR and IslandCharIllustration.New(iter7_1) or IslandIllustration.New(iter7_1)

		if table.contains(var1_1, iter7_1) then
			var5_1:SetStatus(IslandIllustration.STATUS.UNLOCK)
		elseif var2_1[var3_1] and var2_1[var3_1][var4_1] then
			var5_1:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
		end

		arg0_1.dataMap[var3_1][var4_1] = var5_1
	end

	arg0_1:SetPointDatas(var0_1.book_collects)

	arg0_1.pointAwardGotIds = {}

	for iter8_1, iter9_1 in ipairs(var0_1.book_awards) do
		table.insert(arg0_1.pointAwardGotIds, iter9_1)
	end

	arg0_1.pointAwardIds = Clone(pg.island_collection_reward.all)

	table.sort(arg0_1.pointAwardIds, CompareFuncs({
		function(arg0_2)
			return pg.island_collection_reward[arg0_2].level
		end,
		function(arg0_3)
			return arg0_3
		end
	}))
end

function var0_0.SetPointDatas(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg1_4 or {}) do
		local var0_4, var1_4 = IslandIllustration.GetTypeAndLinkId(iter1_4.id)

		arg0_4.dataMap[var0_4][var1_4]:SetPointData(iter1_4)
	end
end

function var0_0.InitShipTypeData(arg0_5)
	local var0_5 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	for iter0_5, iter1_5 in pairs(arg0_5.dataMap[IslandIllustration.TYPES.CHAR] or {}) do
		if var0_5:GetShipById(iter1_5:GetLinkConfigID()) then
			local var1_5 = iter1_5:GetStatus()

			if var1_5 == IslandIllustration.STATUS.UNLOCK then
				iter1_5:CheckTip()
			elseif var1_5 == IslandIllustration.STATUS.LOCK then
				iter1_5:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
			end
		end
	end
end

function var0_0.GetListByType(arg0_6, arg1_6)
	return underscore.values(arg0_6.dataMap[arg1_6])
end

function var0_0.GetIllustration(arg0_7, arg1_7, arg2_7)
	return arg0_7.dataMap[arg1_7] and arg0_7.dataMap[arg1_7][arg2_7]
end

function var0_0.GetAllPoints(arg0_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in pairs(arg0_8.dataMap[IslandIllustration.TYPES.CHAR]) do
		var0_8 = var0_8 + iter1_8:GetPoints()
	end

	return var0_8
end

function var0_0.GetPoints(arg0_9, arg1_9, arg2_9)
	return arg0_9.dataMap[arg1_9][arg2_9]:GetPoints()
end

function var0_0.GetCurLevelPointAwardId(arg0_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.pointAwardIds) do
		if not table.contains(arg0_10.pointAwardGotIds, iter1_10) then
			return iter1_10
		end
	end

	return arg0_10.pointAwardIds[#arg0_10.pointAwardIds]
end

function var0_0.GetPointAwardGotIds(arg0_11)
	return arg0_11.pointAwardGotIds
end

function var0_0.IsGotAllPointAward(arg0_12)
	return table.contains(arg0_12.pointAwardGotIds, arg0_12.pointAwardIds[#arg0_12.pointAwardIds])
end

function var0_0.GetCurPointInfos(arg0_13)
	local var0_13 = arg0_13:GetCurLevelPointAwardId()

	return arg0_13:GetAllPoints(), pg.island_collection_reward[var0_13].need_exp
end

function var0_0.AddCanUnlock(arg0_14, arg1_14, arg2_14)
	arg0_14.dataMap[arg1_14][arg2_14]:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
end

function var0_0.AddCanUnlockItems(arg0_15, arg1_15)
	local var0_15 = IslandIllustration.TYPES.ITEM

	for iter0_15, iter1_15 in ipairs(arg1_15 or {}) do
		arg0_15:AddCanUnlock(var0_15, iter1_15)
	end
end

function var0_0.AddUnlock(arg0_16, arg1_16)
	local var0_16, var1_16 = IslandIllustration.GetTypeAndLinkId(arg1_16)

	arg0_16.dataMap[var0_16][var1_16]:SetStatus(IslandIllustration.STATUS.UNLOCK)
	arg0_16.dataMap[var0_16][var1_16]:CheckTip()
end

function var0_0.AddPointAwardGotId(arg0_17, arg1_17)
	table.insert(arg0_17.pointAwardGotIds, arg1_17)
end

function var0_0.OnGetPointDone(arg0_18, arg1_18)
	arg0_18:SetPointDatas(arg1_18)

	for iter0_18, iter1_18 in ipairs(arg1_18 or {}) do
		local var0_18, var1_18 = IslandIllustration.GetTypeAndLinkId(iter1_18.id)

		arg0_18.dataMap[var0_18][var1_18]:CheckTip()
	end
end

function var0_0.OnAddNewShip(arg0_19, arg1_19)
	local var0_19 = arg0_19.dataMap[IslandIllustration.TYPES.CHAR][arg1_19]

	if var0_19 then
		var0_19:SetStatus(IslandIllustration.STATUS.CAN_UNLOCK)
	end
end

function var0_0.OnShipUpgradeOrBreakOut(arg0_20, arg1_20)
	local var0_20 = arg0_20.dataMap[IslandIllustration.TYPES.CHAR][arg1_20]

	if var0_20 then
		var0_20:CheckTip()
	end
end

function var0_0.IsTipFromTypes(arg0_21, arg1_21)
	local var0_21, var1_21 = arg0_21:GetCurPointInfos()
	local var2_21 = not arg0_21:IsGotAllPointAward() and var1_21 <= var0_21

	if table.contains(arg1_21, IslandIllustration.TYPES.CHAR) and var2_21 then
		return true
	end

	for iter0_21, iter1_21 in ipairs(arg1_21) do
		for iter2_21, iter3_21 in pairs(arg0_21.dataMap[iter1_21] or {}) do
			if iter3_21:IsTip() then
				return true
			end
		end
	end

	return false
end

return var0_0
