local var0_0 = class("IslandFormulaSelectPage", import("...base.IslandBasePage"))

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
	arg0_2.addCountTips = arg0_2.formulaItem:Find("addCount")
	arg0_2.reduceBtn = arg0_2.formulaItem:Find("limit/reduce")
	arg0_2.addBtn = arg0_2.formulaItem:Find("limit/add")
	arg0_2.maxBtn = arg0_2.formulaItem:Find("limit/max")
	arg0_2.curCountNumSlider = arg0_2.formulaItem:Find("limit/num_bg")
	arg0_2.extraProduct = arg0_2.formulaItem:Find("extra")
	arg0_2.extraProductIcon = arg0_2.extraProduct:Find("icon")
	arg0_2.extraProductNum = arg0_2.extraProductIcon:Find("product_count_bg/product_count")
	arg0_2.extraProductName = arg0_2.extraProduct:Find("Text")
	arg0_2.extraProductAddnum = arg0_2.extraProduct:Find("Text/addCount")
	arg0_2.needTimeText = arg0_2.sureBtn:Find("adapt/time/time_text")
	arg0_2.barLimit = arg0_2.formulaItem:Find("limit/hasLimit")
	arg0_2.extraProductList = UIItemList.New(arg0_2.extraProduct:Find("process"), arg0_2.extraProduct:Find("process/item"))
	arg0_2.uiList = UIItemList.New(arg0_2:findTF("formulaView/content"), arg0_2:findTF("formulaView/content/tpl"))
	arg0_2.costuiList = UIItemList.New(arg0_2:findTF("rightInfo/formula/needItem/content"), arg0_2:findTF("rightInfo/formula/needItem/content/IslandItemTpl"))

	setText(arg0_2:findTF("top/title/Text"), i18n("island_select_product"))
	setText(arg0_2.formulaItem:Find("tips"), i18n("island_production_count"))

	arg0_2.baseEffectSpeed = pg.island_set.base_efficiency.key_value_int
	arg0_2.selectShipTf = arg0_2.rightInfo:Find("selectShip")
	arg0_2.selectShipName = arg0_2.selectShipTf:Find("info/name")
	arg0_2.selectShipLv = arg0_2.selectShipTf:Find("info/lv")
	arg0_2.selectShipIcon = arg0_2.selectShipTf:Find("bg/icon")
	arg0_2.skillTf = arg0_2.selectShipTf:Find("skill")
	arg0_2.skillInUse = arg0_2.skillTf:Find("skillBg/skillTabBg/skill_bright")
	arg0_2.skillUnUse = arg0_2.skillTf:Find("skillBg/skillTabBg/skill_dark")
	arg0_2.skillName = arg0_2.skillTf:Find("skillBg/skillText"):GetComponent(typeof(Text))
	arg0_2.energyBarTf = arg0_2.selectShipTf:Find("ener_bar")
	arg0_2.energyBarUseTf = arg0_2.selectShipTf:Find("ener_bar_1")
	arg0_2.energy_countTf = arg0_2.selectShipTf:Find("energy_count")
	arg0_2.enoughSureBg = arg0_2.sureBtn:Find("okBg")
	arg0_2.notenoughSureBg = arg0_2.sureBtn:Find("notBg")
	arg0_2.animationPlayer = arg0_2.rightInfo:GetComponent(typeof(Animation))
	arg0_2.addExpTF = arg0_2.selectShipTf:Find("exp")
	arg0_2.addExp = arg0_2.selectShipTf:Find("exp/addExp")
end

function var0_0.AddListeners(arg0_3)
	return
end

function var0_0.RemoveListeners(arg0_4)
	return
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:Hide()
		existCall(arg0_5.cancelFunc)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.reduceBtn, function()
		arg0_5.curSelectCount = arg0_5.curSelectCount - 1

		local var0_7 = arg0_5.addDelegateFormulaTimes and arg0_5.addDelegateFormulaTimes + 1 or 1

		arg0_5.curSelectCount = var0_7 > arg0_5.curSelectCount and var0_7 or arg0_5.curSelectCount

		arg0_5:RefreshCost()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.addBtn, function()
		local var0_8 = arg0_5.curSelectCount + 1

		if arg0_5.addDelegateFormulaTimes then
			local var1_8 = arg0_5:CheckCanAddMaxTimes() + arg0_5.addDelegateFormulaTimes

			var1_8 = var1_8 > arg0_5.productMaxTime and arg0_5.productMaxTime or var1_8
			var0_8 = var1_8 < var0_8 and var1_8 or var0_8

			if var0_8 < arg0_5.addDelegateFormulaTimes + 1 then
				var0_8 = arg0_5.addDelegateFormulaTimes + 1
			end

			arg0_5.curSelectCount = var0_8
		else
			local var2_8 = arg0_5:CheckCanAddMaxTimes()

			arg0_5.curSelectCount = var2_8 < var0_8 and var2_8 or var0_8

			if arg0_5.curSelectCount < 1 then
				arg0_5.curSelectCount = 1
			end
		end

		arg0_5:RefreshCost()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.maxBtn, function()
		arg0_5.curSelectCount = arg0_5:CheckCanAddMaxTimes()

		if arg0_5.curSelectCount < 1 then
			arg0_5.curSelectCount = 1
		end

		arg0_5:RefreshCost()
	end, SFX_PANEL)
	onSlider(arg0_5, arg0_5.curCountNumSlider, function(arg0_10)
		if arg0_5.addDelegateFormulaTimes then
			local var0_10 = arg0_5:CheckCanAddMaxTimes() + arg0_5.addDelegateFormulaTimes

			var0_10 = var0_10 > arg0_5.productMaxTime and arg0_5.productMaxTime or var0_10
			arg0_10 = var0_10 < arg0_10 and var0_10 or arg0_10

			if arg0_10 < arg0_5.addDelegateFormulaTimes + 1 then
				arg0_10 = arg0_5.addDelegateFormulaTimes + 1
			end

			arg0_5.curSelectCount = arg0_10
		else
			local var1_10 = arg0_5:CheckCanAddMaxTimes()

			arg0_5.curSelectCount = var1_10 < arg0_10 and var1_10 or arg0_10

			if arg0_5.curSelectCount < 1 then
				arg0_5.curSelectCount = 1
			end
		end

		arg0_5:RefreshCost()
	end)
	onButton(arg0_5, arg0_5.skillTf, function()
		arg0_5:ShowMsgBox({
			type = IslandMsgBox.TYPE_SHIP_SKILL,
			skill = arg0_5.selectedShip:GetSkill()
		})
	end, SFX_PANEL)
	arg0_5.uiList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventInit then
			arg0_5:InitFormulaItem(arg1_12, arg2_12)
		elseif arg0_12 == UIItemList.EventUpdate then
			arg0_5:UpdateFormulaItem(arg1_12, arg2_12)
		end
	end)
	arg0_5.costuiList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventInit then
			arg0_5:InitCostItem(arg1_13, arg2_13)
		elseif arg0_13 == UIItemList.EventUpdate then
			arg0_5:UpdateCostItem(arg1_13, arg2_13)
		end
	end)
	arg0_5.extraProductList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventInit then
			-- block empty
		elseif arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg1_14 < arg0_5.extraProcess

			setActive(arg2_14:Find("inprocess"), var0_14)
		end
	end)
end

function var0_0.InitFormulaItem(arg0_15, arg1_15, arg2_15)
	onButton(arg0_15, arg2_15, function()
		arg0_15:OnSelectFormulaIndex(arg1_15 + 1)
	end, SFX_PANEL)
end

function var0_0.OnSelectFormulaIndex(arg0_17, arg1_17)
	arg0_17.selectedIdx = arg1_17
	arg0_17.selectFormulaId = arg0_17.formulaList[arg0_17.selectedIdx]
	arg0_17.formulaCfg = pg.island_formula[arg0_17.selectFormulaId]
	arg0_17.productMaxTime = arg0_17.formulaCfg.production_limit
	arg0_17.curSelectCount = arg0_17.addDelegateFormulaTimes and arg0_17.addDelegateFormulaTimes + 1 or 1

	arg0_17.uiList:align(#arg0_17.formulaList)
end

function var0_0.UpdateFormulaItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18 + 1
	local var1_18 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var2_18 = arg0_18.formulaList[arg1_18 + 1]
	local var3_18 = pg.island_formula[var2_18]
	local var4_18 = var3_18.item_id
	local var5_18 = var1_18:GetItemById(var4_18)
	local var6_18 = var5_18 and var5_18:GetCount() or 0

	updateCustomDrop(arg2_18, Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = var4_18,
		count = var6_18
	}))
	setActive(arg0_18:findTF("icon_bg/count_bg", arg2_18), true)
	setText(arg0_18:findTF("name", arg2_18), var3_18.name)
	setText(arg0_18:findTF("icon_bg/product_count_bg/product_count", arg2_18), "×" .. var3_18.commission_product[1][2])
	setText(arg0_18:findTF("icon_bg/count_bg/count", arg2_18), i18n("island_production_hold", var6_18))

	if arg0_18.selectedIdx == var0_18 then
		arg0_18:RefreshCurrentSelectFormula()
	end

	setActive(arg0_18:findTF("selected", arg2_18), arg0_18.selectedIdx == var0_18)
end

function var0_0.InitCostItem(arg0_19, arg1_19, arg2_19)
	return
end

function var0_0.UpdateCostItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.commission_Cost_List[arg1_20 + 1]

	updateCustomDrop(arg2_20, var0_20)

	local var1_20 = string.format("%d/%d", var0_20.itemCount, var0_20.costCount)

	setActive(arg0_20:findTF("icon_bg/count_bg", arg2_20), true)
	setText(arg2_20:Find("icon_bg/count_bg/count"), var1_20)
end

function var0_0.RefreshCurrentSelectFormula(arg0_21)
	local var0_21 = arg0_21.formulaCfg.item_id
	local var1_21 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var0_21
	})
	local var2_21 = var1_21:getConfigTable().rarity
	local var3_21 = IslandItemRarity.Rarity2FrameName(var2_21)
	local var4_21 = var1_21:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/islandframe", var3_21, arg0_21.currentformulaIcon:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync("island/" .. var4_21, "", arg0_21.currentformulaIcon:Find("icon_bg/icon"))
	arg0_21:RefreshCost()
end

function var0_0.RefreshCost(arg0_22)
	arg0_22.commission_Cost_List = {}

	local var0_22 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_22, iter1_22 in ipairs(arg0_22.formulaCfg.commission_cost) do
		local var1_22 = iter1_22[1]
		local var2_22 = var0_22:GetItemById(var1_22)
		local var3_22 = var2_22 and var2_22:GetCount() or 0
		local var4_22 = arg0_22.addDelegateFormulaTimes and arg0_22.curSelectCount - arg0_22.addDelegateFormulaTimes or arg0_22.curSelectCount
		local var5_22 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_22[1],
			itemCount = var3_22,
			costCount = iter1_22[2] * var4_22
		})

		table.insert(arg0_22.commission_Cost_List, var5_22)
	end

	arg0_22.costuiList:align(#arg0_22.commission_Cost_List)
	arg0_22:RefreshCurSelectCount()
	arg0_22:RefreshShipEnergy()
	arg0_22:RefreshCanStart()
end

function var0_0.CheckCanAddMaxTimes(arg0_23)
	arg0_23.commission_Cost_List = {}

	local var0_23 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_23 = arg0_23.productMaxTime

	for iter0_23, iter1_23 in ipairs(arg0_23.formulaCfg.commission_cost) do
		local var2_23 = iter1_23[1]
		local var3_23 = var0_23:GetItemById(var2_23)
		local var4_23 = var3_23 and var3_23:GetCount() or 0
		local var5_23 = iter1_23[2]

		var1_23 = math.min(var1_23, math.floor(var4_23 / var5_23))
	end

	return (math.min(math.floor(arg0_23.selectedShip:GetCurrentEnergy() / arg0_23.formulaCfg.stamina_cost), var1_23))
end

function var0_0.RefreshCanStart(arg0_24)
	local function var0_24()
		for iter0_25, iter1_25 in ipairs(arg0_24.commission_Cost_List) do
			if iter1_25.costCount > iter1_25.itemCount then
				return false
			end
		end

		return true
	end

	local function var1_24()
		local var0_26 = arg0_24.addDelegateFormulaTimes and arg0_24.curSelectCount - arg0_24.addDelegateFormulaTimes or arg0_24.curSelectCount

		if arg0_24.formulaCfg.stamina_cost * var0_26 > arg0_24.selectedShip:GetCurrentEnergy() then
			return false
		end

		return true
	end

	local function var2_24()
		local var0_27 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_24.placeId)
		local var1_27 = pg.island_production_slot[arg0_24.slotId]
		local var2_27 = var1_27.exclusion_slot == "" and {} or var1_27.exclusion_slot
		local var3_27 = {}
		local var4_27 = false

		for iter0_27, iter1_27 in ipairs(var2_27) do
			if var0_27:GetHandPlantSlotData(iter1_27).state == 1 then
				var4_27 = true

				table.insert(var3_27, iter1_27)
			end
		end

		return var4_27, var3_27
	end

	if var0_24() and var1_24() then
		setActive(arg0_24.enoughSureBg, true)
		setActive(arg0_24.notenoughSureBg, false)
		onButton(arg0_24, arg0_24.sureBtn, function()
			if arg0_24.addDelegateFormula then
				arg0_24.placeId = pg.island_production_slot[arg0_24.slotId].place

				local var0_28 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_24.placeId):GetDelegationSlotData(arg0_24.slotId)

				if var0_28 and not var0_28:GetSlotRoleData() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_additional_production_tip2"))

					return
				end
			end

			local var1_28 = arg0_24.formulaToActivityDic[arg0_24.selectFormulaId]

			if var1_28 then
				local var2_28 = getProxy(ActivityProxy):getActivityById(var1_28)

				if not var2_28 or var2_28:isEnd() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_activity_expired"))

					return
				end
			end

			local var3_28, var4_28 = var2_24()

			if var3_28 then
				arg0_24:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_production_manually_cancel"),
					onYes = function()
						pg.m02:sendNotification(GAME.ISLAND_STOP_HANDLE_PLANT_HALFWAY, {
							build_id = arg0_24.placeId,
							slot_list = var4_28
						})
					end,
					onNo = function()
						return
					end
				})

				return
			end

			existCall(arg0_24.unLoadCharacterFunc)

			if arg0_24.addDelegateFormula then
				local var5_28 = arg0_24.curSelectCount - arg0_24.addDelegateFormulaTimes

				arg0_24:emit(IslandMediator.ADD_DELEGATION, arg0_24.placeId, arg0_24.slotId, var5_28)
			else
				arg0_24:emit(IslandMediator.START_DELEGATION, arg0_24.placeId, arg0_24.slotId, arg0_24.selectedShipId, arg0_24.selectFormulaId, arg0_24.curSelectCount)
			end

			existCall(arg0_24.confirmFunc)
			arg0_24:Hide()
		end, SFX_PANEL)
	else
		setActive(arg0_24.enoughSureBg, false)
		setActive(arg0_24.notenoughSureBg, true)
		onButton(arg0_24, arg0_24.sureBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_cost_notenough"))
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_32, arg1_32)
	arg0_32:BlurPanel()

	arg0_32.commissionId = arg1_32.commissionId
	arg0_32.selectedShipId = arg1_32.selectedShipId
	arg0_32.cancelFunc = arg1_32.cancelFunc
	arg0_32.confirmFunc = arg1_32.confirmFunc
	arg0_32.unLoadCharacterFunc = arg1_32.unLoadCharacterFunc
	arg0_32.addDelegateFormula = arg1_32.addDelegateFormula
	arg0_32.addDelegateFormulaTimes = arg1_32.addDelegateFormulaTimes
	arg0_32.canRewardTime = arg1_32.canRewardTime

	setActive(arg0_32.addExpTF, arg0_32.selectedShipId ~= 1)

	if arg0_32.addDelegateFormulaTimes then
		setActive(arg0_32.barLimit, true)

		local var0_32 = arg0_32.addDelegateFormulaTimes / 5 * 352.6

		arg0_32.barLimit.sizeDelta = Vector2(var0_32, 22)

		setActive(arg0_32.addCountTips, true)
	else
		setActive(arg0_32.barLimit, false)
		setActive(arg0_32.addCountTips, false)
	end

	local var1_32 = arg0_32.addDelegateFormulaTimes and i18n("island_additional_production_tip1") or i18n("island_production_start")

	setText(arg0_32.sureBtn:Find("adapt/time/Text"), var1_32)

	arg0_32.slotId = pg.island_production_commission[arg0_32.commissionId].slot
	arg0_32.placeId = pg.island_production_slot[arg0_32.slotId].place
	arg0_32.selectedShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_32.selectedShipId)

	arg0_32:InitUnlockedFormulaList()

	if #arg0_32.formulaList > 0 then
		arg0_32.uiList:align(#arg0_32.formulaList)
		setActive(arg0_32.rightInfo, true)
		setActive(arg0_32.rightInfoEmpty, false)
		arg0_32:OnSelectFormulaIndex(1)
	else
		arg0_32.uiList:align(#arg0_32.formulaList)
		setActive(arg0_32.rightInfo, false)
		setActive(arg0_32.rightInfoEmpty, true)
	end

	arg0_32:RefreshShip()
end

function var0_0.RefreshShip(arg0_33)
	local var0_33 = IslandShip.StaticGetPrefab(arg0_33.selectedShipId)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_33, "", arg0_33.selectShipIcon)
	setText(arg0_33.selectShipName, arg0_33.selectedShip:GetName())
	setText(arg0_33.selectShipLv, string.format("-Lv.%d", arg0_33.selectedShip:GetLevel()))

	local var1_33 = arg0_33.selectedShip:GetSkill()
	local var2_33 = var1_33:IsEffectiveInPlace(arg0_33.placeId)

	setActive(arg0_33.skillInUse, var2_33)
	setActive(arg0_33.skillUnUse, not var2_33)
	setActive(arg0_33.skillUnUse, not var2_33)

	arg0_33.skillName.text = string.format("%s - %s", var1_33:GetName(), "Lv." .. var1_33:GetLevel() .. "")
end

function var0_0.RefreshShipEnergy(arg0_34)
	local var0_34 = arg0_34.addDelegateFormulaTimes and arg0_34.curSelectCount - arg0_34.addDelegateFormulaTimes or arg0_34.curSelectCount
	local var1_34 = arg0_34.formulaCfg.stamina_cost * var0_34

	if arg0_34.selectedShipId == 1 then
		var1_34 = 0
	else
		arg0_34.animationPlayer:Play("anim_IslandFormulaSelectNewUI_bar_Loop")
	end

	setText(arg0_34.addExp, "EXP+" .. arg0_34.formulaCfg.ship_exp * var0_34)

	if arg0_34.eneryTimer then
		arg0_34.eneryTimer:Stop()
	end

	arg0_34.eneryTimer = Timer.New(function()
		local var0_35 = arg0_34.selectedShip:GetCurrentEnergy()
		local var1_35 = arg0_34.selectedShip:GetMaxEnergy()

		setSlider(arg0_34.energyBarTf, 0, 1, (var0_35 - var1_34) / var1_35)
		setSlider(arg0_34.energyBarUseTf, 0, 1, var0_35 / var1_35)
		setText(arg0_34.energy_countTf, string.format("%d-<color=#f7c35f>%d</color>/%d", var0_35, var1_34, var1_35))
	end, 1, -1)

	arg0_34.eneryTimer:Start()
	arg0_34.eneryTimer.func()
end

function var0_0.InitUnlockedFormulaList(arg0_36)
	arg0_36.formulaList = {}
	arg0_36.formulaToActivityDic = {}

	if arg0_36.addDelegateFormula then
		table.insert(arg0_36.formulaList, arg0_36.addDelegateFormula)

		return
	end

	local var0_36 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_36, iter1_36 in ipairs(pg.island_production_slot[arg0_36.slotId].activity_formula or {}) do
		local var1_36 = iter1_36[1]
		local var2_36 = iter1_36[2]
		local var3_36 = getProxy(ActivityProxy):getActivityById(var1_36)

		if var3_36 and not var3_36:isEnd() then
			for iter2_36, iter3_36 in ipairs(var2_36 or {}) do
				if pg.island_formula[iter3_36].unlock_type == 0 or var0_36:IsUnlockFormuate(iter3_36) then
					table.insert(arg0_36.formulaList, iter3_36)

					arg0_36.formulaToActivityDic[iter3_36] = var1_36
				end
			end
		end
	end

	for iter4_36, iter5_36 in ipairs(pg.island_production_slot[arg0_36.slotId].formula or {}) do
		local var4_36 = pg.island_formula[iter5_36].unlock_type == 0
		local var5_36 = pg.island_formula[iter5_36].unlock_type == -1
		local var6_36 = true

		if var5_36 then
			local var7_36 = pg.island_combo[iter5_36].unlock_condition
			local var8_36 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()

			for iter6_36, iter7_36 in ipairs(var7_36) do
				local var9_36 = iter7_36[1]
				local var10_36 = iter7_36[2]

				if not var8_36[var9_36] or var10_36 > var8_36[var9_36] then
					var6_36 = false

					break
				end
			end
		end

		if var4_36 or var0_36:IsUnlockFormuate(iter5_36) or var5_36 and var6_36 then
			table.insert(arg0_36.formulaList, iter5_36)
		end
	end
end

function var0_0.RefreshCurSelectCount(arg0_37)
	local var0_37 = arg0_37.addDelegateFormulaTimes or arg0_37.curSelectCount

	setText(arg0_37.curCountTips, tostring(var0_37))

	local var1_37 = arg0_37.addDelegateFormulaTimes and arg0_37.curSelectCount - arg0_37.addDelegateFormulaTimes or 0

	setText(arg0_37.addCountTips, "+" .. var1_37)
	setSlider(arg0_37.curCountNumSlider, 1, arg0_37.productMaxTime, arg0_37.curSelectCount)
	arg0_37:RefreshExtraProduct()
	setText(arg0_37.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), "×" .. arg0_37.formulaCfg.commission_product[1][2])

	local var2_37 = arg0_37:CacaluteProductTime()
	local var3_37 = 0

	for iter0_37, iter1_37 in ipairs(var2_37) do
		var3_37 = var3_37 + iter1_37
	end

	setText(arg0_37.needTimeText, pg.TimeMgr.GetInstance():DescCDTime(var3_37))
end

function var0_0.RefreshExtraProduct(arg0_38)
	local var0_38 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	if #arg0_38.formulaCfg.second_product == 0 or not var0_38:IsUnlcokSecondProduct(arg0_38.selectFormulaId) then
		setActive(arg0_38.extraProduct, false)

		return
	end

	setActive(arg0_38.extraProduct, true)

	local var1_38 = arg0_38.formulaCfg.second_product_display[1][1]
	local var2_38 = arg0_38.formulaCfg.second_product_display[1][2]
	local var3_38 = pg.island_item_data_template[var1_38]

	GetImageSpriteFromAtlasAsync("island/" .. var3_38.icon, "", arg0_38.extraProductIcon)
	setText(arg0_38.extraProductNum, "×" .. var2_38)

	local var4_38 = pg.island_production_slot[arg0_38.slotId].place
	local var5_38 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var4_38):GetDelegationSlotData(arg0_38.slotId):GetFromulaTatalCount(arg0_38.formulaCfg.id)
	local var6_38 = arg0_38.formulaCfg.second_product[1]
	local var7_38 = (var5_38 + (arg0_38.canRewardTime or 0)) % var6_38
	local var8_38 = var7_38 + (arg0_38.addDelegateFormulaTimes and arg0_38.curSelectCount - arg0_38.addDelegateFormulaTimes or arg0_38.curSelectCount)
	local var9_38 = math.floor(var8_38 / var6_38)

	arg0_38.extraProcess = var8_38 % var6_38

	setText(arg0_38.extraProductName, var3_38.name .. "×" .. var9_38)

	if arg0_38.addDelegateFormulaTimes then
		setActive(arg0_38.extraProductAddnum, true)

		local var10_38 = arg0_38.curSelectCount - arg0_38.addDelegateFormulaTimes
		local var11_38 = math.floor((var7_38 + var10_38) / var6_38)

		setText(arg0_38.extraProductAddnum, "+" .. var11_38)
	else
		setActive(arg0_38.extraProductAddnum, false)
	end

	arg0_38.extraProductList:align(var6_38)
end

function var0_0.CacaluteProductTime(arg0_39)
	local var0_39 = arg0_39.addDelegateFormulaTimes and arg0_39.curSelectCount - arg0_39.addDelegateFormulaTimes or arg0_39.curSelectCount

	return IslandProductTimeHelper.CalculateTimeToProductFormula(arg0_39.selectedShipId, arg0_39.selectFormulaId, var0_39, arg0_39.placeId, arg0_39.slotId)
end

function var0_0.CheckInPlace(arg0_40, arg1_40, arg2_40)
	for iter0_40, iter1_40 in ipairs(arg2_40) do
		if iter1_40 == arg1_40 then
			return true
		end
	end

	return false
end

function var0_0.GetAttrGrade(arg0_41, arg1_41)
	local var0_41 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_41, iter1_41 in ipairs(pg.island_chara_att.all) do
		local var1_41 = pg.island_chara_att[iter1_41]
		local var2_41 = var1_41.range[1]
		local var3_41 = var1_41.range[2]

		if var2_41 <= arg1_41 and arg1_41 <= var3_41 then
			var0_41 = iter1_41

			break
		end
	end

	return var0_41
end

function var0_0.GetAttrGrowingValueByBuff(arg0_42, arg1_42, arg2_42)
	for iter0_42, iter1_42 in ipairs(arg2_42) do
		if iter1_42[1] == arg1_42 then
			return iter1_42[2]
		end
	end

	return 0
end

function var0_0.OnHide(arg0_43)
	arg0_43:UnBlurPanel()

	if arg0_43.eneryTimer then
		arg0_43.eneryTimer:Stop()
	end
end

function var0_0.OnDestroy(arg0_44)
	return
end

function var0_0.Show(arg0_45, ...)
	arg0_45:AddListeners()
	arg0_45.islandUIController:Show(true)
	arg0_45:OnShow(...)
end

function var0_0.Hide(arg0_46, arg1_46, arg2_46)
	local var0_46 = defaultValue(arg1_46, true)

	local function var1_46()
		arg0_46:ClosePage(arg0_46)
		arg0_46:RemoveListeners()
		arg0_46:OnHide()

		if not arg2_46 then
			arg0_46:OnExit()
		end
	end

	if var0_46 then
		arg0_46.islandUIController:Hide(true, var1_46)
	else
		var1_46()
	end
end

return var0_0
