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
	onButton(arg0_6, arg0_6.uiBackBtn, function()
		arg0_6.curType = IslandAutoCollectHelper.SelectType.None

		arg0_6:Flush()
	end)
	arg0_6.uiShipList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventInit then
			arg0_6:InitShipItem(arg1_10, arg2_10)
		elseif arg0_10 == UIItemList.EventUpdate then
			arg0_6:UpdateShipItem(arg1_10, arg2_10)
		end
	end)
	arg0_6.uiTipList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventInit then
			arg0_6:InitItem(arg1_11, arg2_11)
		elseif arg0_11 == UIItemList.EventUpdate then
			arg0_6:UpdateItem(arg1_11, arg2_11)
		end
	end)
	setText(arg0_6.uiSelectConfirmText, i18n("island_chara_gather_range"))
	setText(arg0_6.uiConfirmText, i18n("island_chara_gather_start"))
	setText(arg0_6.uiBackText, i18n("word_back"))
end

function var0_0.InitShipItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12 + 1

	onButton(arg0_12, arg2_12:Find("unlock/btn"), function()
		arg0_12:emit(IslandMediator.OPEN_PAGE, "IslandShipSelectPage", {
			{
				attrType = IslandShipAttr.COLLECT_KEY,
				confirmFunc = function(arg0_14)
					arg0_12:AfterShipSelect(var0_12, arg0_14[1])
				end,
				autoCollectionSelectShip = arg0_12.selectShips
			}
		})
	end)
	onButton(arg0_12, arg2_12:Find("unlock/ship/delete"), function()
		arg0_12.selectShips[var0_12] = nil

		arg0_12:Flush()
	end)
end

function var0_0.UpdateShipItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.curType == IslandAutoCollectHelper.SelectType.None

	setActive(arg2_16:Find("lock"), var0_16)
	setActive(arg2_16:Find("unlock"), not var0_16)

	if var0_16 then
		return
	end

	local var1_16 = arg1_16 + 1
	local var2_16 = arg0_16.selectShips[var1_16]
	local var3_16 = var2_16 ~= nil and true or false

	setActive(arg2_16:Find("unlock/ship"), var3_16)
	setActive(arg2_16:Find("unlock/add"), not var3_16)
	setActive(arg2_16:Find("unlock/add"), not var3_16)

	if not var2_16 then
		return
	end

	local var4_16 = IslandShip.StaticGetPrefab(var2_16)

	LoadImageSpriteAsync("squareicon/" .. var4_16, arg2_16:Find("unlock/ship/mask/icon"))

	local var5_16 = arg0_16.expAddlist[var1_16]

	if not var5_16 then
		setActive(arg2_16:Find("unlock/ship/exp"), false)

		return
	end

	setActive(arg2_16:Find("unlock/ship/exp"), true)
	setText(arg2_16:Find("unlock/ship/exp/addExp"), string.format("EXP+%d", var5_16))
end

function var0_0.AfterShipSelect(arg0_17, arg1_17, arg2_17)
	arg0_17.selectShips[arg1_17] = arg2_17

	arg0_17:Flush()
end

function var0_0.InitItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18 + 1
	local var1_18 = IslandAutoCollectHelper.CostTipList[var0_18]

	setText(arg2_18:Find("name"), var1_18)
end

function var0_0.UpdateItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19 + 1
	local var1_19 = arg0_19.costTipList[var0_19]

	setText(arg2_19:Find("num"), var1_19)
end

function var0_0.Flush(arg0_20)
	setActive(arg0_20.uiSelectConfirm, arg0_20.curType == IslandAutoCollectHelper.SelectType.None)
	setActive(arg0_20.uiConfirmBtn, arg0_20.curType ~= IslandAutoCollectHelper.SelectType.None)
	setActive(arg0_20.uiBackBtn, arg0_20.curType ~= IslandAutoCollectHelper.SelectType.None)
	arg0_20:RefreshData()

	if arg0_20.curType ~= IslandAutoCollectHelper.SelectType.None then
		setActive(arg0_20.uiConfirmBtn.transform:Find("blue"), arg0_20.cheackEnough)
		setActive(arg0_20.uiConfirmBtn.transform:Find("gray"), not arg0_20.cheackEnough)

		if arg0_20.cheackEnough then
			onButton(arg0_20, arg0_20.uiConfirmBtn, function()
				local var0_21 = {}

				for iter0_21, iter1_21 in pairs(arg0_20.selectShips) do
					table.insert(var0_21, iter1_21)
				end

				pg.m02:sendNotification(GAME.ISLAND_TAKE_AUTO_COLLECTION, {
					type = arg0_20.curType,
					ship_list = var0_21,
					gatherData = arg0_20.gatherDataList
				})
			end)
		else
			removeOnButton(arg0_20.uiConfirmBtn)
		end
	end

	arg0_20.uiShipList:align(var1_0)
	arg0_20.uiTipList:align(#IslandAutoCollectHelper.CostTipList)
end

function var0_0.GetCostData(arg0_22)
	local var0_22 = 0
	local var1_22 = 0
	local var2_22 = 0

	arg0_22.autoCostList = {}

	if arg0_22.curType == IslandAutoCollectHelper.SelectType.HandCollection or arg0_22.curType == IslandAutoCollectHelper.SelectType.Both then
		local var3_22 = {
			IslandProductConst.MinePlaceId,
			IslandProductConst.FellingPlaceId
		}
		local var4_22 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()

		for iter0_22, iter1_22 in ipairs(var3_22) do
			local var5_22 = var4_22:GetBuilding(iter1_22)
			local var6_22 = var5_22 and var5_22:GetBuildingCollectData() or nil
			local var7_22 = arg0_22.buildCostDic[iter1_22]

			if var6_22 then
				local var8_22 = var6_22:GetCollectSlotDatasDic()

				for iter2_22, iter3_22 in pairs(var8_22) do
					if iter3_22:GetCanCollectTimeStamps() == 0 and arg0_22:CheckIsDefauotSlot(iter1_22, iter3_22.id) then
						table.insert(arg0_22.autoCostList, {
							energyCost = var7_22.energyCost,
							coinCost = var7_22.coinCost,
							expAdd = var7_22.expCost
						})
					end
				end
			end
		end
	end

	if arg0_22.curType == IslandAutoCollectHelper.SelectType.Gather or arg0_22.curType == IslandAutoCollectHelper.SelectType.Both then
		local var9_22 = pg.TimeMgr.GetInstance():GetServerTime()

		for iter4_22, iter5_22 in ipairs(arg0_22.gatherDataList) do
			if iter5_22.state == 0 or iter5_22.state == 1 and var9_22 > iter5_22.refresh_time then
				local var10_22 = pg.island_wild_gather[iter5_22.id]

				table.insert(arg0_22.autoCostList, {
					energyCost = var10_22.auto_parameters[2],
					coinCost = var10_22.auto_parameters[1],
					expAdd = var10_22.auto_parameters[3]
				})
			end
		end
	end

	for iter6_22, iter7_22 in ipairs(arg0_22.autoCostList) do
		var0_22 = var0_22 + iter7_22.energyCost
		var1_22 = var1_22 + iter7_22.coinCost
		var2_22 = var2_22 + iter7_22.expAdd
	end

	return var0_22, var1_22, var2_22
end

function var0_0.GetGatherReducePercent(arg0_23)
	local var0_23 = 0

	for iter0_23, iter1_23 in pairs(arg0_23.selectShips) do
		var0_23 = var0_23 + IslandAutoCollectHelper.GetAttributeReducePercent(iter1_23)
	end

	return var0_23
end

function var0_0.GetShipCount(arg0_24)
	local var0_24 = 0

	for iter0_24, iter1_24 in pairs(arg0_24.selectShips) do
		var0_24 = var0_24 + 1
	end

	return var0_24
end

function var0_0.RefreshData(arg0_25)
	arg0_25.costTipList = {}
	arg0_25.expAddlist = {}
	arg0_25.cheackEnough = false

	local var0_25, var1_25, var2_25 = arg0_25:GetCostData()
	local var3_25
	local var4_25

	if arg0_25.curType == IslandAutoCollectHelper.SelectType.None then
		var3_25 = "/"
		var4_25 = "/"
	elseif arg0_25:GetShipCount() == 0 then
		var3_25 = var0_25
		var4_25 = var1_25
	else
		local var5_25 = arg0_25:GetGatherReducePercent()
		local var6_25 = math.floor(var0_25 * (1 - var5_25 * 0.01))
		local var7_25 = var6_25
		local var8_25 = 0

		for iter0_25 = 1, 3 do
			local var9_25 = arg0_25.selectShips[iter0_25]

			if var9_25 then
				local var10_25 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var9_25):GetCurrentEnergy()
				local var11_25 = 0

				if var10_25 <= var7_25 then
					var11_25 = var10_25
				else
					var11_25 = var7_25
				end

				var7_25 = var7_25 - var11_25
				var8_25 = var8_25 + var10_25

				local var12_25 = var11_25 / var6_25 * var2_25

				arg0_25.expAddlist[iter0_25] = math.floor(var12_25)
			end
		end

		local var13_25 = var6_25 <= var8_25
		local var14_25 = var13_25 and var3_0 or var2_0

		var3_25 = string.format("<color=%s>%d</color>/%d(-%d%%)", var14_25, var8_25, var6_25, var5_25)

		local var15_25 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetItemById(1)
		local var16_25 = var15_25 and var15_25:GetCount() or 0
		local var17_25 = var1_25 <= var16_25
		local var18_25 = var17_25 and var3_0 or var2_0

		var4_25 = string.format("<color=%s>%d</color>/%d", var18_25, var1_25, var16_25)
		arg0_25.cheackEnough = var13_25 and var17_25
	end

	table.insert(arg0_25.costTipList, var3_25)
	table.insert(arg0_25.costTipList, var4_25)
end

function var0_0.OnGetCollctionDone(arg0_26, arg1_26)
	local var0_26 = arg1_26.selectType

	if var0_26 == IslandAutoCollectHelper.SelectType.Gather or var0_26 == IslandAutoCollectHelper.SelectType.Both then
		arg0_26.gatherDataList = {}
	end

	arg0_26.curType = IslandAutoCollectHelper.SelectType.None

	arg0_26:Flush()
end

function var0_0.AfterSelectType(arg0_27, arg1_27)
	arg0_27.curType = arg1_27

	arg0_27:Flush()
end

function var0_0.OnDestroy(arg0_28)
	return
end

function var0_0.ConfigDataHandle(arg0_29)
	local var0_29 = pg.island_set.mining_auto_parameters.key_value_varchar

	arg0_29.buildCostDic = {}

	for iter0_29, iter1_29 in ipairs(var0_29) do
		local var1_29 = iter1_29[1]

		arg0_29.buildCostDic[var1_29] = {}
		arg0_29.buildCostDic[var1_29].coinCost = iter1_29[2]
		arg0_29.buildCostDic[var1_29].energyCost = iter1_29[3]
		arg0_29.buildCostDic[var1_29].expCost = iter1_29[4]
	end

	arg0_29.buildDefaultList = {}

	local var2_29 = pg.island_set.mining_default_slot.key_value_varchar

	for iter2_29, iter3_29 in ipairs(var2_29) do
		local var3_29 = iter3_29[1]

		arg0_29.buildDefaultList[var3_29] = {}

		for iter4_29, iter5_29 in ipairs(iter3_29[2]) do
			table.insert(arg0_29.buildDefaultList[var3_29], iter5_29)
		end
	end
end

function var0_0.CheckIsDefauotSlot(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.buildDefaultList[arg1_30] or {}

	for iter0_30, iter1_30 in ipairs(var0_30) do
		if iter1_30 == arg2_30 then
			return true
		end
	end

	return false
end

function var0_0.Show(arg0_31, arg1_31)
	var0_0.super.Show(arg0_31)
	arg0_31:ConfigDataHandle()

	arg0_31.gatherDataList = {}

	for iter0_31, iter1_31 in ipairs(arg1_31.gather_list) do
		table.insert(arg0_31.gatherDataList, IslandWildGatherData.New(iter1_31))
	end

	arg0_31.curType = IslandAutoCollectHelper.SelectType.None
	arg0_31.selectShips = {}
	arg0_31.uiItemTipList = {}

	arg0_31:Flush()
end

return var0_0
