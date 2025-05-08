local var0_0 = class("IslandFormulaSelectPage", import("...base.IslandBasePage"))
local var1_0 = 40
local var2_0 = 5

function var0_0.getUIName(arg0_1)
	return "IslandFormulaSelectNewUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("top/back")
	arg0_2.title = arg0_2:findTF("top/title")
	arg0_2.rightInfo = arg0_2:findTF("rightInfo")
	arg0_2.rightInfoEmpty = arg0_2:findTF("rightInfo_empty")
	arg0_2.currentformulaIcon = arg0_2:findTF("rightInfo/formula/currentformula")
	arg0_2.sureBtn = arg0_2:findTF("rightInfo/sure")
	arg0_2.formulaItem = arg0_2:findTF("rightInfo/formula")
	arg0_2.curCountTips = arg0_2.formulaItem:Find("curCount")
	arg0_2.reduceBtn = arg0_2.formulaItem:Find("limit/reduce")
	arg0_2.addBtn = arg0_2.formulaItem:Find("limit/add")
	arg0_2.maxBtn = arg0_2.formulaItem:Find("limit/max")
	arg0_2.curCountNumSlider = arg0_2.formulaItem:Find("limit/num_bg")
	arg0_2.extraProduct = arg0_2.formulaItem:Find("extra")
	arg0_2.extraProductIcon = arg0_2.extraProduct:Find("icon")
	arg0_2.extraProductName = arg0_2.extraProduct:Find("Text")
	arg0_2.needTimeText = arg0_2.sureBtn:Find("adapt/time/time_text")
	arg0_2.extraProductList = UIItemList.New(arg0_2.extraProduct:Find("process"), arg0_2.extraProduct:Find("process/item"))
	arg0_2.uiList = UIItemList.New(arg0_2:findTF("formulaView/content"), arg0_2:findTF("formulaView/content/tpl"))
	arg0_2.costuiList = UIItemList.New(arg0_2:findTF("rightInfo/formula/needItem/content"), arg0_2:findTF("rightInfo/formula/needItem/content/IslandItemTpl"))

	onSlider(arg0_2, arg0_2.curCountNumSlider, function(arg0_3)
		arg0_2.curSelectCount = arg0_3

		arg0_2:RefreshCurSelectCount()
	end)
	setText(arg0_2:findTF("top/title/Text"), i18n1("产物选择"))
end

function var0_0.AddListeners(arg0_4)
	return
end

function var0_0.RemoveListeners(arg0_5)
	return
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:Hide()
		arg0_6.cancelFunc()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.sureBtn, function()
		local var0_8 = arg0_6.formulaList[arg0_6.selectedIdx]

		arg0_6:emit(IslandMediator.START_DELEGATION, arg0_6.place_Id, arg0_6.logicCommissionId, arg0_6.selectedShip, var0_8, arg0_6.curSelectCount)
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.reduceBtn, function()
		arg0_6.curSelectCount = arg0_6.curSelectCount - 1
		arg0_6.curSelectCount = arg0_6.curSelectCount < 1 and 1 or arg0_6.curSelectCount

		arg0_6:RefreshCurSelectCount()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.addBtn, function()
		arg0_6.curSelectCount = arg0_6.curSelectCount + 1
		arg0_6.curSelectCount = arg0_6.curSelectCount > var2_0 and var2_0 or arg0_6.curSelectCount

		arg0_6:RefreshCurSelectCount()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.maxBtn, function()
		arg0_6.curSelectCount = var2_0

		arg0_6:RefreshCurSelectCount()
	end, SFX_PANEL)
	arg0_6.uiList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventInit then
			arg0_6:InitFormulaItem(arg1_12, arg2_12)
		elseif arg0_12 == UIItemList.EventUpdate then
			arg0_6:UpdateFormulaItem(arg1_12, arg2_12)
		end
	end)
	arg0_6.costuiList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventInit then
			arg0_6:InitCostItem(arg1_13, arg2_13)
		elseif arg0_13 == UIItemList.EventUpdate then
			arg0_6:UpdateCostItem(arg1_13, arg2_13)
		end
	end)
	arg0_6.extraProductList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventInit then
			-- block empty
		elseif arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg1_14 < arg0_6.extraProcess

			setActive(arg2_14:Find("inprocess"), var0_14)
		end
	end)
end

function var0_0.InitFormulaItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.formulaList[arg1_15 + 1]
	local var1_15 = pg.island_formula[var0_15]
	local var2_15 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var3_15 = var1_15.item_id
	local var4_15 = var2_15:GetItemById(var3_15)
	local var5_15 = var4_15 and var4_15:GetCount() or 0

	updateDrop(arg2_15, Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = var3_15,
		count = var5_15
	}))
	setActive(arg0_15:findTF("icon_bg/count_bg", arg2_15), true)
	setText(arg0_15:findTF("name", arg2_15), var1_15.name)
	setText(arg0_15:findTF("icon_bg/product_count_bg/product_count", arg2_15), "×" .. var1_15.commission_product[1][2])
	onButton(arg0_15, arg2_15, function()
		arg0_15:OnSelectFormulaIndex(arg1_15 + 1)
	end, SFX_PANEL)
end

function var0_0.OnSelectFormulaIndex(arg0_17, arg1_17)
	arg0_17.curSelectCount = 1
	arg0_17.selectedIdx = arg1_17

	arg0_17.uiList:align(#arg0_17.formulaList)
end

function var0_0.UpdateFormulaItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18 + 1

	if arg0_18.selectedIdx == var0_18 then
		arg0_18:RefreshCurrentSelect()
	end

	setActive(arg0_18:findTF("selected", arg2_18), arg0_18.selectedIdx == var0_18)
end

function var0_0.InitCostItem(arg0_19, arg1_19, arg2_19)
	return
end

function var0_0.UpdateCostItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.commission_productList[arg1_20 + 1]

	updateDrop(arg2_20, var0_20)
end

function var0_0.RefreshCurrentSelect(arg0_21)
	local var0_21 = arg0_21.formulaList[arg0_21.selectedIdx]
	local var1_21 = pg.island_formula[var0_21]
	local var2_21 = var1_21.item_id
	local var3_21 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var2_21
	})
	local var4_21 = var3_21:getConfigTable().rarity
	local var5_21 = IslandItemRarity.Rarity2FrameName(var4_21)
	local var6_21 = var3_21:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("islandframe", var5_21, arg0_21.currentformulaIcon:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync(var6_21, "", arg0_21.currentformulaIcon:Find("icon_bg/icon"))

	arg0_21.commission_productList = {}

	for iter0_21, iter1_21 in ipairs(var1_21.commission_product) do
		local var7_21 = Drop.New({
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_21[1],
			count = iter1_21[2]
		})

		table.insert(arg0_21.commission_productList, var7_21)
	end

	arg0_21.costuiList:align(#arg0_21.commission_productList)
	arg0_21:RefreshCurSelectCount()
end

function var0_0.OnShow(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	arg0_22.cancelFunc = arg4_22
	arg0_22.place_Id = arg2_22
	arg0_22.selectedShip = arg3_22
	arg0_22.currentCommissionId = arg1_22
	arg0_22.logicCommissionId = pg.island_production_commission[arg0_22.currentCommissionId].slot

	arg0_22:InitUnlockedFormulaList()

	if #arg0_22.formulaList > 0 then
		setActive(arg0_22.rightInfo, true)
		setActive(arg0_22.rightInfoEmpty, false)
		arg0_22:OnSelectFormulaIndex(1)
	else
		arg0_22.uiList:align(#arg0_22.formulaList)
		setActive(arg0_22.rightInfo, false)
		setActive(arg0_22.rightInfoEmpty, true)
	end
end

function var0_0.InitUnlockedFormulaList(arg0_23)
	arg0_23.formulaList = {}

	for iter0_23, iter1_23 in ipairs(pg.island_production_slot[arg0_23.logicCommissionId].formula or {}) do
		local var0_23 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

		if pg.island_formula[iter1_23].unlock_type == 0 or var0_23:IsUnlockFormuate(iter1_23) then
			table.insert(arg0_23.formulaList, iter1_23)
		end
	end
end

function var0_0.RefreshCurSelectCount(arg0_24)
	setText(arg0_24.curCountTips, tostring(arg0_24.curSelectCount))
	setSlider(arg0_24.curCountNumSlider, 0, var2_0, arg0_24.curSelectCount)
	arg0_24:RefreshExtraProduct()

	local var0_24 = arg0_24.formulaList[arg0_24.selectedIdx]
	local var1_24 = pg.island_formula[var0_24]

	setText(arg0_24.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), "×" .. var1_24.commission_product[1][2] * arg0_24.curSelectCount)
	setText(arg0_24.needTimeText, pg.TimeMgr.GetInstance():DescCDTime(var1_24.workload * arg0_24.curSelectCount))
end

function var0_0.RefreshExtraProduct(arg0_25)
	local var0_25 = arg0_25.formulaList[arg0_25.selectedIdx]
	local var1_25 = pg.island_formula[var0_25]

	if #var1_25.second_product == 0 then
		setActive(arg0_25.extraProduct, false)

		return
	end

	setActive(arg0_25.extraProduct, true)

	local var2_25 = var1_25.second_product[2][1]
	local var3_25 = pg.island_item_data_template[var2_25]

	GetImageSpriteFromAtlasAsync(var3_25.icon, "", arg0_25.currentformulaIcon)

	local var4_25 = pg.island_production_slot[arg0_25.logicCommissionId].place
	local var5_25 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var4_25):GetDelegationSlotData(arg0_25.logicCommissionId):GetFromulaTatalCount(var1_25.id)
	local var6_25 = var1_25.second_product[1]
	local var7_25 = math.floor((var5_25 + arg0_25.curSelectCount) / var6_25)

	arg0_25.extraProcess = (var5_25 + arg0_25.curSelectCount) % var6_25

	setText(arg0_25.extraProductName, "副产物 × " .. var7_25)
	arg0_25.extraProductList:align(var6_25)
end

function var0_0.OnDestroy(arg0_26)
	return
end

return var0_0
