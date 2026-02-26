local var0_0 = class("IslandCollectionPanel", import("view.base.BaseSubView"))
local var1_0 = 3
local var2_0 = "#ff7d36"
local var3_0 = "#39BFFF"

function var0_0.getUIName(arg0_1)
	return "IslandAutomaticCollectionPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiShipList = UIItemList.New(arg0_2.uiShipContent, arg0_2.uiShipTpl)
	arg0_2.uiTipList = UIItemList.New(arg0_2.uiTipContent, arg0_2.uiTipTpl)
end

function var0_0.ExistHandCollection(arg0_3)
	local var0_3 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var1_3 = {
		IslandProductConst.MinePlaceId,
		IslandProductConst.FellingPlaceId
	}

	for iter0_3, iter1_3 in ipairs(var1_3) do
		local var2_3 = var0_3:GetBuilding(iter1_3)
		local var3_3 = var2_3 and var2_3:GetBuildingCollectData() or nil

		if var3_3 then
			local var4_3 = var3_3:GetCollectSlotDatasDic()

			for iter2_3, iter3_3 in pairs(var4_3) do
				if iter3_3:GetCanCollectTimeStamps() == 0 then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.ExistGather(arg0_4)
	local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_4, iter1_4 in ipairs(arg0_4.gatherDataList) do
		if iter1_4.state == 0 or iter1_4.state == 1 and var0_4 > iter1_4.refresh_time then
			return true
		end
	end

	return false
end

function var0_0.CheckHasCollectData(arg0_5, arg1_5)
	if arg1_5 == IslandAutoCollectHelper.SelectType.HandCollection then
		return arg0_5:ExistHandCollection()
	elseif arg1_5 == IslandAutoCollectHelper.SelectType.Gather then
		return arg0_5:ExistGather()
	elseif arg1_5 == IslandAutoCollectHelper.SelectType.Both then
		return arg0_5:ExistHandCollection() or arg0_5:ExistGather()
	end

	return false
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.uiSelectConfirm, function()
		arg0_6.contextData:ShowMsgBox({
			content = i18n("collect_chapter_is_activation"),
			onYes = function(arg0_8, arg1_8)
				if arg0_6:CheckHasCollectData(arg0_8) == false then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_chara_gather_no_target"))

					return
				end

				arg0_6:AfterSelectType(arg0_8)
				arg1_8()
			end,
			type = IslandMsgBox.TYPE_COMMON_AUTO_CONFIRM
		})
	end)
	arg0_6.uiShipList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventInit then
			arg0_6:InitShipItem(arg1_9, arg2_9)
		elseif arg0_9 == UIItemList.EventUpdate then
			arg0_6:UpdateShipItem(arg1_9, arg2_9)
		end
	end)
	arg0_6.uiTipList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventInit then
			arg0_6:InitItem(arg1_10, arg2_10)
		elseif arg0_10 == UIItemList.EventUpdate then
			arg0_6:UpdateItem(arg1_10, arg2_10)
		end
	end)
	setText(arg0_6.uiSelectConfirmText, i18n("island_chara_gather_range"))
	setText(arg0_6.uiConfirmText, i18n("island_chara_gather_start"))
end

function var0_0.InitShipItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg1_11 + 1

	onButton(arg0_11, arg2_11:Find("unlock/btn"), function()
		arg0_11:emit(IslandMediator.OPEN_PAGE, "IslandShipSelectPage", {
			{
				attrType = IslandShipAttr.COLLECT_KEY,
				confirmFunc = function(arg0_13)
					arg0_11:AfterShipSelect(var0_11, arg0_13[1])
				end,
				autoCollectionSelectShip = arg0_11.selectShips
			}
		})
	end)
	onButton(arg0_11, arg2_11:Find("unlock/ship/delete"), function()
		arg0_11.selectShips[var0_11] = nil

		arg0_11:Flush()
	end)
end

function var0_0.UpdateShipItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.curType == IslandAutoCollectHelper.SelectType.None

	setActive(arg2_15:Find("lock"), var0_15)
	setActive(arg2_15:Find("unlock"), not var0_15)

	if var0_15 then
		return
	end

	local var1_15 = arg1_15 + 1
	local var2_15 = arg0_15.selectShips[var1_15]
	local var3_15 = var2_15 ~= nil and true or false

	setActive(arg2_15:Find("unlock/ship"), var3_15)
	setActive(arg2_15:Find("unlock/add"), not var3_15)
	setActive(arg2_15:Find("unlock/add"), not var3_15)

	if not var2_15 then
		return
	end

	local var4_15 = IslandShip.StaticGetPrefab(var2_15)

	LoadImageSpriteAsync("squareicon/" .. var4_15, arg2_15:Find("unlock/ship/mask/icon"))

	local var5_15 = arg0_15.expAddlist[var1_15]

	if not var5_15 then
		setActive(arg2_15:Find("unlock/ship/exp"), false)

		return
	end

	setActive(arg2_15:Find("unlock/ship/exp"), true)
	setText(arg2_15:Find("unlock/ship/exp/addExp"), string.format("EXP+%d", var5_15))
end

function var0_0.AfterShipSelect(arg0_16, arg1_16, arg2_16)
	arg0_16.selectShips[arg1_16] = arg2_16

	arg0_16:Flush()
end

function var0_0.InitItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17 + 1
	local var1_17 = IslandAutoCollectHelper.CostTipList[var0_17]

	setText(arg2_17:Find("name"), var1_17)
end

function var0_0.UpdateItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18 + 1
	local var1_18 = arg0_18.costTipList[var0_18]

	setText(arg2_18:Find("num"), var1_18)
end

function var0_0.Flush(arg0_19)
	setActive(arg0_19.uiSelectConfirm, arg0_19.curType == IslandAutoCollectHelper.SelectType.None)
	setActive(arg0_19.uiConfirmBtn, arg0_19.curType ~= IslandAutoCollectHelper.SelectType.None)
	arg0_19:RefreshData()

	if arg0_19.curType ~= IslandAutoCollectHelper.SelectType.None then
		setActive(arg0_19.uiConfirmBtn.transform:Find("blue"), arg0_19.cheackEnough)
		setActive(arg0_19.uiConfirmBtn.transform:Find("gray"), not arg0_19.cheackEnough)

		if arg0_19.cheackEnough then
			onButton(arg0_19, arg0_19.uiConfirmBtn, function()
				local var0_20 = {}

				for iter0_20, iter1_20 in pairs(arg0_19.selectShips) do
					table.insert(var0_20, iter1_20)
				end

				pg.m02:sendNotification(GAME.ISLAND_TAKE_AUTO_COLLECTION, {
					type = arg0_19.curType,
					ship_list = var0_20,
					gatherData = arg0_19.gatherDataList
				})
			end)
		else
			removeOnButton(arg0_19.uiConfirmBtn)
		end
	end

	arg0_19.uiShipList:align(var1_0)
	arg0_19.uiTipList:align(#IslandAutoCollectHelper.CostTipList)
end

function var0_0.GetCostData(arg0_21)
	local var0_21 = 0
	local var1_21 = 0
	local var2_21 = 0

	arg0_21.autoCostList = {}

	if arg0_21.curType == IslandAutoCollectHelper.SelectType.HandCollection or arg0_21.curType == IslandAutoCollectHelper.SelectType.Both then
		local var3_21 = {
			IslandProductConst.MinePlaceId,
			IslandProductConst.FellingPlaceId
		}
		local var4_21 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()

		for iter0_21, iter1_21 in ipairs(var3_21) do
			local var5_21 = var4_21:GetBuilding(iter1_21)
			local var6_21 = var5_21 and var5_21:GetBuildingCollectData() or nil
			local var7_21 = arg0_21.buildCostDic[iter1_21]

			if var6_21 then
				local var8_21 = var6_21:GetCollectSlotDatasDic()

				for iter2_21, iter3_21 in pairs(var8_21) do
					if iter3_21:GetCanCollectTimeStamps() == 0 and arg0_21:CheckIsDefauotSlot(iter1_21, iter3_21.id) then
						table.insert(arg0_21.autoCostList, {
							energyCost = var7_21.energyCost,
							coinCost = var7_21.coinCost,
							expAdd = var7_21.expCost
						})
					end
				end
			end
		end
	end

	if arg0_21.curType == IslandAutoCollectHelper.SelectType.Gather or arg0_21.curType == IslandAutoCollectHelper.SelectType.Both then
		local var9_21 = pg.TimeMgr.GetInstance():GetServerTime()

		for iter4_21, iter5_21 in ipairs(arg0_21.gatherDataList) do
			if iter5_21.state == 0 or iter5_21.state == 1 and var9_21 > iter5_21.refresh_time then
				local var10_21 = pg.island_wild_gather[iter5_21.id]

				table.insert(arg0_21.autoCostList, {
					energyCost = var10_21.auto_parameters[2],
					coinCost = var10_21.auto_parameters[1],
					expAdd = var10_21.auto_parameters[3]
				})
			end
		end
	end

	for iter6_21, iter7_21 in ipairs(arg0_21.autoCostList) do
		var0_21 = var0_21 + iter7_21.energyCost
		var1_21 = var1_21 + iter7_21.coinCost
		var2_21 = var2_21 + iter7_21.expAdd
	end

	return var0_21, var1_21, var2_21
end

function var0_0.GetGatherReducePercent(arg0_22)
	local var0_22 = 0

	for iter0_22, iter1_22 in pairs(arg0_22.selectShips) do
		var0_22 = var0_22 + IslandAutoCollectHelper.GetAttributeReducePercent(iter1_22)
	end

	return var0_22
end

function var0_0.GetShipCount(arg0_23)
	local var0_23 = 0

	for iter0_23, iter1_23 in pairs(arg0_23.selectShips) do
		var0_23 = var0_23 + 1
	end

	return var0_23
end

function var0_0.RefreshData(arg0_24)
	arg0_24.costTipList = {}
	arg0_24.expAddlist = {}
	arg0_24.cheackEnough = false

	local var0_24, var1_24, var2_24 = arg0_24:GetCostData()
	local var3_24
	local var4_24

	if arg0_24.curType == IslandAutoCollectHelper.SelectType.None then
		var3_24 = "/"
		var4_24 = "/"
	elseif arg0_24:GetShipCount() == 0 then
		var3_24 = var0_24
		var4_24 = var1_24
	else
		local var5_24 = arg0_24:GetGatherReducePercent()
		local var6_24 = math.floor(var0_24 * (1 - var5_24 * 0.01))
		local var7_24 = var6_24
		local var8_24 = 0

		for iter0_24 = 1, 3 do
			local var9_24 = arg0_24.selectShips[iter0_24]

			if var9_24 then
				local var10_24 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var9_24):GetCurrentEnergy()
				local var11_24 = 0

				if var10_24 <= var7_24 then
					var11_24 = var10_24
				else
					var11_24 = var7_24
				end

				var7_24 = var7_24 - var11_24
				var8_24 = var8_24 + var10_24

				local var12_24 = var11_24 / var6_24 * var2_24

				arg0_24.expAddlist[iter0_24] = math.floor(var12_24)
			end
		end

		local var13_24 = var6_24 <= var8_24
		local var14_24 = var13_24 and var3_0 or var2_0

		var3_24 = string.format("<color=%s>%d</color>/%d(-%d%%)", var14_24, var8_24, var6_24, var5_24)

		local var15_24 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetItemById(1)
		local var16_24 = var15_24 and var15_24:GetCount() or 0
		local var17_24 = var1_24 <= var16_24
		local var18_24 = var17_24 and var3_0 or var2_0

		var4_24 = string.format("<color=%s>%d</color>/%d", var18_24, var1_24, var16_24)
		arg0_24.cheackEnough = var13_24 and var17_24
	end

	table.insert(arg0_24.costTipList, var3_24)
	table.insert(arg0_24.costTipList, var4_24)
end

function var0_0.OnGetCollctionDone(arg0_25, arg1_25)
	local var0_25 = arg1_25.selectType

	if var0_25 == IslandAutoCollectHelper.SelectType.Gather or var0_25 == IslandAutoCollectHelper.SelectType.Both then
		arg0_25.gatherDataList = {}
	end

	arg0_25.curType = IslandAutoCollectHelper.SelectType.None

	arg0_25:Flush()
end

function var0_0.AfterSelectType(arg0_26, arg1_26)
	arg0_26.curType = arg1_26

	arg0_26:Flush()
end

function var0_0.OnDestroy(arg0_27)
	return
end

function var0_0.ConfigDataHandle(arg0_28)
	local var0_28 = pg.island_set.mining_auto_parameters.key_value_varchar

	arg0_28.buildCostDic = {}

	for iter0_28, iter1_28 in ipairs(var0_28) do
		local var1_28 = iter1_28[1]

		arg0_28.buildCostDic[var1_28] = {}
		arg0_28.buildCostDic[var1_28].coinCost = iter1_28[2]
		arg0_28.buildCostDic[var1_28].energyCost = iter1_28[3]
		arg0_28.buildCostDic[var1_28].expCost = iter1_28[4]
	end

	arg0_28.buildDefaultList = {}

	local var2_28 = pg.island_set.mining_default_slot.key_value_varchar

	for iter2_28, iter3_28 in ipairs(var2_28) do
		local var3_28 = iter3_28[1]

		arg0_28.buildDefaultList[var3_28] = {}

		for iter4_28, iter5_28 in ipairs(iter3_28[2]) do
			table.insert(arg0_28.buildDefaultList[var3_28], iter5_28)
		end
	end
end

function var0_0.CheckIsDefauotSlot(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.buildDefaultList[arg1_29] or {}

	for iter0_29, iter1_29 in ipairs(var0_29) do
		if iter1_29 == arg2_29 then
			return true
		end
	end

	return false
end

function var0_0.Show(arg0_30, arg1_30)
	var0_0.super.Show(arg0_30)
	arg0_30:ConfigDataHandle()

	arg0_30.gatherDataList = {}

	for iter0_30, iter1_30 in ipairs(arg1_30.gather_list) do
		table.insert(arg0_30.gatherDataList, IslandWildGatherData.New(iter1_30))
	end

	arg0_30.curType = IslandAutoCollectHelper.SelectType.None
	arg0_30.selectShips = {}
	arg0_30.uiItemTipList = {}

	arg0_30:Flush()
end

return var0_0
