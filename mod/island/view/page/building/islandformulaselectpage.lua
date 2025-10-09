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
	onButton(arg0_5, arg0_5._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_commission.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:Hide()
		existCall(arg0_5.cancelFunc)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.reduceBtn, function()
		arg0_5.curSelectCount = arg0_5.curSelectCount - 1

		local var0_8 = arg0_5.addDelegateFormulaTimes and arg0_5.addDelegateFormulaTimes + 1 or 1

		arg0_5.curSelectCount = var0_8 > arg0_5.curSelectCount and var0_8 or arg0_5.curSelectCount

		arg0_5:RefreshCost()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.addBtn, function()
		local var0_9 = arg0_5.curSelectCount + 1

		if arg0_5.addDelegateFormulaTimes then
			local var1_9 = arg0_5:CheckCanAddMaxTimes() + arg0_5.addDelegateFormulaTimes

			var1_9 = var1_9 > arg0_5.productMaxTime and arg0_5.productMaxTime or var1_9
			var0_9 = var1_9 < var0_9 and var1_9 or var0_9

			if var0_9 < arg0_5.addDelegateFormulaTimes + 1 then
				var0_9 = arg0_5.addDelegateFormulaTimes + 1
			end

			arg0_5.curSelectCount = var0_9
		else
			local var2_9 = arg0_5:CheckCanAddMaxTimes()

			arg0_5.curSelectCount = var2_9 < var0_9 and var2_9 or var0_9

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
	onSlider(arg0_5, arg0_5.curCountNumSlider, function(arg0_11)
		if arg0_5.addDelegateFormulaTimes then
			local var0_11 = arg0_5:CheckCanAddMaxTimes() + arg0_5.addDelegateFormulaTimes

			var0_11 = var0_11 > arg0_5.productMaxTime and arg0_5.productMaxTime or var0_11
			arg0_11 = var0_11 < arg0_11 and var0_11 or arg0_11

			if arg0_11 < arg0_5.addDelegateFormulaTimes + 1 then
				arg0_11 = arg0_5.addDelegateFormulaTimes + 1
			end

			arg0_5.curSelectCount = arg0_11
		else
			local var1_11 = arg0_5:CheckCanAddMaxTimes()

			arg0_5.curSelectCount = var1_11 < arg0_11 and var1_11 or arg0_11

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
	arg0_5.uiList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventInit then
			arg0_5:InitFormulaItem(arg1_13, arg2_13)
		elseif arg0_13 == UIItemList.EventUpdate then
			arg0_5:UpdateFormulaItem(arg1_13, arg2_13)
		end
	end)
	arg0_5.costuiList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventInit then
			arg0_5:InitCostItem(arg1_14, arg2_14)
		elseif arg0_14 == UIItemList.EventUpdate then
			arg0_5:UpdateCostItem(arg1_14, arg2_14)
		end
	end)
	arg0_5.extraProductList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventInit then
			-- block empty
		elseif arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg1_15 < arg0_5.extraProcess

			setActive(arg2_15:Find("inprocess"), var0_15)
		end
	end)
end

function var0_0.InitFormulaItem(arg0_16, arg1_16, arg2_16)
	onButton(arg0_16, arg2_16, function()
		arg0_16:OnSelectFormulaIndex(arg1_16 + 1)
	end, SFX_PANEL)
end

function var0_0.OnSelectFormulaIndex(arg0_18, arg1_18)
	arg0_18.selectedIdx = arg1_18
	arg0_18.selectFormulaId = arg0_18.formulaList[arg0_18.selectedIdx]
	arg0_18.formulaCfg = pg.island_formula[arg0_18.selectFormulaId]
	arg0_18.productMaxTime = arg0_18.formulaCfg.production_limit
	arg0_18.curSelectCount = arg0_18.addDelegateFormulaTimes and arg0_18.addDelegateFormulaTimes + 1 or 1

	arg0_18.uiList:align(#arg0_18.formulaList)
end

function var0_0.UpdateFormulaItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19 + 1
	local var1_19 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var2_19 = arg0_19.formulaList[arg1_19 + 1]
	local var3_19 = pg.island_formula[var2_19]
	local var4_19 = var3_19.item_id
	local var5_19 = var1_19:GetItemById(var4_19)
	local var6_19 = var5_19 and var5_19:GetCount() or 0

	updateCustomDrop(arg2_19, Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = var4_19,
		count = var6_19
	}))
	setActive(arg0_19:findTF("icon_bg/count_bg", arg2_19), true)
	setText(arg0_19:findTF("name", arg2_19), var3_19.name)
	setText(arg0_19:findTF("icon_bg/product_count_bg/product_count", arg2_19), "×" .. var3_19.commission_product[1][2])
	setText(arg0_19:findTF("icon_bg/count_bg/count", arg2_19), i18n("island_production_hold", var6_19))

	if arg0_19.selectedIdx == var0_19 then
		arg0_19:RefreshCurrentSelectFormula()
	end

	setActive(arg0_19:findTF("selected", arg2_19), arg0_19.selectedIdx == var0_19)
end

function var0_0.InitCostItem(arg0_20, arg1_20, arg2_20)
	return
end

function var0_0.UpdateCostItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.commission_Cost_List[arg1_21 + 1]

	updateCustomDrop(arg2_21, var0_21)

	local var1_21 = string.format("%d/%d", var0_21.itemCount, var0_21.costCount)

	setActive(arg0_21:findTF("icon_bg/count_bg", arg2_21), true)
	setText(arg2_21:Find("icon_bg/count_bg/count"), var1_21)
end

function var0_0.RefreshCurrentSelectFormula(arg0_22)
	local var0_22 = arg0_22.formulaCfg.item_id
	local var1_22 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var0_22
	})
	local var2_22 = var1_22:getConfigTable().rarity
	local var3_22 = IslandItemRarity.Rarity2FrameName(var2_22)
	local var4_22 = var1_22:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/islandframe", var3_22, arg0_22.currentformulaIcon:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync("island/" .. var4_22, "", arg0_22.currentformulaIcon:Find("icon_bg/icon"))
	arg0_22:RefreshCost()
end

function var0_0.RefreshCost(arg0_23)
	arg0_23.commission_Cost_List = {}

	local var0_23 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_23, iter1_23 in ipairs(arg0_23.formulaCfg.commission_cost) do
		local var1_23 = iter1_23[1]
		local var2_23 = var0_23:GetItemById(var1_23)
		local var3_23 = var2_23 and var2_23:GetCount() or 0
		local var4_23 = arg0_23.addDelegateFormulaTimes and arg0_23.curSelectCount - arg0_23.addDelegateFormulaTimes or arg0_23.curSelectCount
		local var5_23 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_23[1],
			itemCount = var3_23,
			costCount = iter1_23[2] * var4_23
		})

		table.insert(arg0_23.commission_Cost_List, var5_23)
	end

	arg0_23.costuiList:align(#arg0_23.commission_Cost_List)
	arg0_23:RefreshCurSelectCount()
	arg0_23:RefreshShipEnergy()
	arg0_23:RefreshCanStart()
end

function var0_0.CheckCanAddMaxTimes(arg0_24)
	arg0_24.commission_Cost_List = {}

	local var0_24 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_24 = arg0_24.productMaxTime

	for iter0_24, iter1_24 in ipairs(arg0_24.formulaCfg.commission_cost) do
		local var2_24 = iter1_24[1]
		local var3_24 = var0_24:GetItemById(var2_24)
		local var4_24 = var3_24 and var3_24:GetCount() or 0
		local var5_24 = iter1_24[2]

		var1_24 = math.min(var1_24, math.floor(var4_24 / var5_24))
	end

	return (math.min(math.floor(arg0_24.selectedShip:GetCurrentEnergy() / arg0_24.formulaCfg.stamina_cost), var1_24))
end

function var0_0.RefreshCanStart(arg0_25)
	local function var0_25()
		for iter0_26, iter1_26 in ipairs(arg0_25.commission_Cost_List) do
			if iter1_26.costCount > iter1_26.itemCount then
				return false
			end
		end

		return true
	end

	local function var1_25()
		local var0_27 = arg0_25.addDelegateFormulaTimes and arg0_25.curSelectCount - arg0_25.addDelegateFormulaTimes or arg0_25.curSelectCount

		if arg0_25.formulaCfg.stamina_cost * var0_27 > arg0_25.selectedShip:GetCurrentEnergy() then
			return false
		end

		return true
	end

	local function var2_25()
		local var0_28 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_25.placeId)
		local var1_28 = pg.island_production_slot[arg0_25.slotId]
		local var2_28 = var1_28.exclusion_slot == "" and {} or var1_28.exclusion_slot
		local var3_28 = {}
		local var4_28 = false

		for iter0_28, iter1_28 in ipairs(var2_28) do
			if var0_28:GetHandPlantSlotData(iter1_28).state == 1 then
				var4_28 = true

				table.insert(var3_28, iter1_28)
			end
		end

		return var4_28, var3_28
	end

	if var0_25() and var1_25() then
		setActive(arg0_25.enoughSureBg, true)
		setActive(arg0_25.notenoughSureBg, false)
		onButton(arg0_25, arg0_25.sureBtn, function()
			if arg0_25.addDelegateFormula then
				arg0_25.placeId = pg.island_production_slot[arg0_25.slotId].place

				local var0_29 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_25.placeId):GetDelegationSlotData(arg0_25.slotId)

				if var0_29 and not var0_29:GetSlotRoleData() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_additional_production_tip2"))

					return
				end
			end

			local var1_29 = arg0_25.formulaToActivityDic[arg0_25.selectFormulaId]

			if var1_29 then
				local var2_29 = getProxy(ActivityProxy):getActivityById(var1_29)

				if not var2_29 or var2_29:isEnd() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_activity_expired"))

					return
				end
			end

			local var3_29, var4_29 = var2_25()

			if var3_29 then
				arg0_25:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_production_manually_cancel"),
					onYes = function()
						pg.m02:sendNotification(GAME.ISLAND_STOP_HANDLE_PLANT_HALFWAY, {
							build_id = arg0_25.placeId,
							slot_list = var4_29
						})
						existCall(arg0_25.unLoadCharacterFunc)

						if arg0_25.addDelegateFormula then
							local var0_30 = arg0_25.curSelectCount - arg0_25.addDelegateFormulaTimes

							arg0_25:emit(IslandMediator.ADD_DELEGATION, arg0_25.placeId, arg0_25.slotId, var0_30)
						else
							arg0_25:emit(IslandMediator.START_DELEGATION, arg0_25.placeId, arg0_25.slotId, arg0_25.selectedShipId, arg0_25.selectFormulaId, arg0_25.curSelectCount)
						end

						existCall(arg0_25.confirmFunc)
						arg0_25:Hide()
					end,
					onNo = function()
						return
					end
				})

				return
			end

			existCall(arg0_25.unLoadCharacterFunc)

			if arg0_25.addDelegateFormula then
				local var5_29 = arg0_25.curSelectCount - arg0_25.addDelegateFormulaTimes

				arg0_25:emit(IslandMediator.ADD_DELEGATION, arg0_25.placeId, arg0_25.slotId, var5_29)
			else
				arg0_25:emit(IslandMediator.START_DELEGATION, arg0_25.placeId, arg0_25.slotId, arg0_25.selectedShipId, arg0_25.selectFormulaId, arg0_25.curSelectCount)
			end

			existCall(arg0_25.confirmFunc)
			arg0_25:Hide()
		end, SFX_PANEL)
	else
		setActive(arg0_25.enoughSureBg, false)
		setActive(arg0_25.notenoughSureBg, true)
		onButton(arg0_25, arg0_25.sureBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_cost_notenough"))
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_33, arg1_33)
	arg0_33:BlurPanel()

	arg0_33.commissionId = arg1_33.commissionId
	arg0_33.selectedShipId = arg1_33.selectedShipId
	arg0_33.cancelFunc = arg1_33.cancelFunc
	arg0_33.confirmFunc = arg1_33.confirmFunc
	arg0_33.unLoadCharacterFunc = arg1_33.unLoadCharacterFunc
	arg0_33.addDelegateFormula = arg1_33.addDelegateFormula
	arg0_33.addDelegateFormulaTimes = arg1_33.addDelegateFormulaTimes
	arg0_33.canRewardTime = arg1_33.canRewardTime

	setActive(arg0_33.addExpTF, arg0_33.selectedShipId ~= 1)

	if arg0_33.addDelegateFormulaTimes then
		setActive(arg0_33.barLimit, true)

		local var0_33 = arg0_33.addDelegateFormulaTimes / 5 * 352.6

		arg0_33.barLimit.sizeDelta = Vector2(var0_33, 22)

		setActive(arg0_33.addCountTips, true)
	else
		setActive(arg0_33.barLimit, false)
		setActive(arg0_33.addCountTips, false)
	end

	local var1_33 = arg0_33.addDelegateFormulaTimes and i18n("island_additional_production_tip1") or i18n("island_production_start")

	setText(arg0_33.sureBtn:Find("adapt/time/Text"), var1_33)

	arg0_33.slotId = pg.island_production_commission[arg0_33.commissionId].slot
	arg0_33.placeId = pg.island_production_slot[arg0_33.slotId].place
	arg0_33.selectedShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_33.selectedShipId)

	arg0_33:InitUnlockedFormulaList()

	if #arg0_33.formulaList > 0 then
		arg0_33.uiList:align(#arg0_33.formulaList)
		setActive(arg0_33.rightInfo, true)
		setActive(arg0_33.rightInfoEmpty, false)
		arg0_33:OnSelectFormulaIndex(1)
	else
		arg0_33.uiList:align(#arg0_33.formulaList)
		setActive(arg0_33.rightInfo, false)
		setActive(arg0_33.rightInfoEmpty, true)
	end

	arg0_33:RefreshShip()
end

function var0_0.RefreshShip(arg0_34)
	local var0_34 = IslandShip.StaticGetPrefab(arg0_34.selectedShipId)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_34, "", arg0_34.selectShipIcon)
	setText(arg0_34.selectShipName, arg0_34.selectedShip:GetName())
	setText(arg0_34.selectShipLv, string.format("-Lv.%d", arg0_34.selectedShip:GetLevel()))

	local var1_34 = arg0_34.selectedShip:GetSkill()
	local var2_34 = var1_34:IsEffectiveInPlace(arg0_34.placeId)

	setActive(arg0_34.skillInUse, var2_34)
	setActive(arg0_34.skillUnUse, not var2_34)
	setActive(arg0_34.skillUnUse, not var2_34)

	arg0_34.skillName.text = string.format("%s - %s", var1_34:GetName(), "Lv." .. var1_34:GetLevel() .. "")
end

function var0_0.RefreshShipEnergy(arg0_35)
	local var0_35 = arg0_35.addDelegateFormulaTimes and arg0_35.curSelectCount - arg0_35.addDelegateFormulaTimes or arg0_35.curSelectCount
	local var1_35 = arg0_35.formulaCfg.stamina_cost * var0_35

	if arg0_35.selectedShipId == 1 then
		var1_35 = 0
	else
		arg0_35.animationPlayer:Play("anim_IslandFormulaSelectNewUI_bar_Loop")
	end

	setText(arg0_35.addExp, "EXP+" .. arg0_35.formulaCfg.ship_exp * var0_35)

	if arg0_35.eneryTimer then
		arg0_35.eneryTimer:Stop()
	end

	arg0_35.eneryTimer = Timer.New(function()
		local var0_36 = arg0_35.selectedShip:GetCurrentEnergy()
		local var1_36 = arg0_35.selectedShip:GetMaxEnergy()

		setSlider(arg0_35.energyBarTf, 0, 1, (var0_36 - var1_35) / var1_36)
		setSlider(arg0_35.energyBarUseTf, 0, 1, var0_36 / var1_36)
		setText(arg0_35.energy_countTf, string.format("%d-<color=#f7c35f>%d</color>/%d", var0_36, var1_35, var1_36))
	end, 1, -1)

	arg0_35.eneryTimer:Start()
	arg0_35.eneryTimer.func()
end

function var0_0.InitUnlockedFormulaList(arg0_37)
	arg0_37.formulaList = {}
	arg0_37.formulaToActivityDic = {}

	if arg0_37.addDelegateFormula then
		table.insert(arg0_37.formulaList, arg0_37.addDelegateFormula)

		return
	end

	local var0_37 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_37, iter1_37 in ipairs(pg.island_production_slot[arg0_37.slotId].activity_formula or {}) do
		local var1_37 = iter1_37[1]
		local var2_37 = iter1_37[2]
		local var3_37 = getProxy(ActivityProxy):getActivityById(var1_37)

		if var3_37 and not var3_37:isEnd() then
			for iter2_37, iter3_37 in ipairs(var2_37 or {}) do
				if pg.island_formula[iter3_37].unlock_type == 0 or var0_37:IsUnlockFormuate(iter3_37) then
					table.insert(arg0_37.formulaList, iter3_37)

					arg0_37.formulaToActivityDic[iter3_37] = var1_37
				end
			end
		end
	end

	for iter4_37, iter5_37 in ipairs(pg.island_production_slot[arg0_37.slotId].formula or {}) do
		local var4_37 = pg.island_formula[iter5_37].unlock_type == 0
		local var5_37 = pg.island_formula[iter5_37].unlock_type == -1
		local var6_37 = true

		if var5_37 then
			local var7_37 = pg.island_combo[iter5_37].unlock_condition
			local var8_37 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()

			for iter6_37, iter7_37 in ipairs(var7_37) do
				local var9_37 = iter7_37[1]
				local var10_37 = iter7_37[2]

				if not var8_37[var9_37] or var10_37 > var8_37[var9_37] then
					var6_37 = false

					break
				end
			end
		end

		if var4_37 or var0_37:IsUnlockFormuate(iter5_37) or var5_37 and var6_37 then
			table.insert(arg0_37.formulaList, iter5_37)
		end
	end
end

function var0_0.RefreshCurSelectCount(arg0_38)
	local var0_38 = arg0_38.addDelegateFormulaTimes or arg0_38.curSelectCount

	setText(arg0_38.curCountTips, tostring(var0_38))

	local var1_38 = arg0_38.addDelegateFormulaTimes and arg0_38.curSelectCount - arg0_38.addDelegateFormulaTimes or 0

	setText(arg0_38.addCountTips, "+" .. var1_38)
	setSlider(arg0_38.curCountNumSlider, 1, arg0_38.productMaxTime, arg0_38.curSelectCount)
	arg0_38:RefreshExtraProduct()
	setText(arg0_38.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), "×" .. arg0_38.formulaCfg.commission_product[1][2])

	local var2_38 = arg0_38:CacaluteProductTime()
	local var3_38 = 0

	for iter0_38, iter1_38 in ipairs(var2_38) do
		var3_38 = var3_38 + iter1_38
	end

	setText(arg0_38.needTimeText, pg.TimeMgr.GetInstance():DescCDTime(var3_38))
end

function var0_0.RefreshExtraProduct(arg0_39)
	local var0_39 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	if #arg0_39.formulaCfg.second_product == 0 or not var0_39:IsUnlcokSecondProduct(arg0_39.selectFormulaId) then
		setActive(arg0_39.extraProduct, false)

		return
	end

	setActive(arg0_39.extraProduct, true)

	local var1_39 = arg0_39.formulaCfg.second_product_display[1][1]
	local var2_39 = arg0_39.formulaCfg.second_product_display[1][2]
	local var3_39 = pg.island_item_data_template[var1_39]

	GetImageSpriteFromAtlasAsync("island/" .. var3_39.icon, "", arg0_39.extraProductIcon)
	setText(arg0_39.extraProductNum, "×" .. var2_39)

	local var4_39 = pg.island_production_slot[arg0_39.slotId].place
	local var5_39 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var4_39):GetDelegationSlotData(arg0_39.slotId):GetFromulaTatalCount(arg0_39.formulaCfg.id)
	local var6_39 = arg0_39.formulaCfg.second_product[1]
	local var7_39 = (var5_39 + (arg0_39.canRewardTime or 0)) % var6_39
	local var8_39 = var7_39 + (arg0_39.addDelegateFormulaTimes and arg0_39.curSelectCount - arg0_39.addDelegateFormulaTimes or arg0_39.curSelectCount)
	local var9_39 = math.floor(var8_39 / var6_39)

	arg0_39.extraProcess = var8_39 % var6_39

	setText(arg0_39.extraProductName, var3_39.name .. "×" .. var9_39)

	if arg0_39.addDelegateFormulaTimes then
		setActive(arg0_39.extraProductAddnum, true)

		local var10_39 = arg0_39.curSelectCount - arg0_39.addDelegateFormulaTimes
		local var11_39 = math.floor((var7_39 + var10_39) / var6_39)

		setText(arg0_39.extraProductAddnum, "+" .. var11_39)
	else
		setActive(arg0_39.extraProductAddnum, false)
	end

	arg0_39.extraProductList:align(var6_39)
end

function var0_0.CacaluteProductTime(arg0_40)
	local var0_40 = arg0_40.addDelegateFormulaTimes and arg0_40.curSelectCount - arg0_40.addDelegateFormulaTimes or arg0_40.curSelectCount

	return IslandProductTimeHelper.CalculateTimeToProductFormula(arg0_40.selectedShipId, arg0_40.selectFormulaId, var0_40, arg0_40.placeId, arg0_40.slotId)
end

function var0_0.CheckInPlace(arg0_41, arg1_41, arg2_41)
	for iter0_41, iter1_41 in ipairs(arg2_41) do
		if iter1_41 == arg1_41 then
			return true
		end
	end

	return false
end

function var0_0.GetAttrGrade(arg0_42, arg1_42)
	local var0_42 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_42, iter1_42 in ipairs(pg.island_chara_att.all) do
		local var1_42 = pg.island_chara_att[iter1_42]
		local var2_42 = var1_42.range[1]
		local var3_42 = var1_42.range[2]

		if var2_42 <= arg1_42 and arg1_42 <= var3_42 then
			var0_42 = iter1_42

			break
		end
	end

	return var0_42
end

function var0_0.GetAttrGrowingValueByBuff(arg0_43, arg1_43, arg2_43)
	for iter0_43, iter1_43 in ipairs(arg2_43) do
		if iter1_43[1] == arg1_43 then
			return iter1_43[2]
		end
	end

	return 0
end

function var0_0.OnHide(arg0_44)
	arg0_44:UnBlurPanel()

	if arg0_44.eneryTimer then
		arg0_44.eneryTimer:Stop()
	end
end

function var0_0.OnDisable(arg0_45)
	arg0_45:OnHide()
end

function var0_0.OnDestroy(arg0_46)
	return
end

function var0_0.Show(arg0_47, ...)
	arg0_47:AddListeners()
	arg0_47.islandUIController:Show(true)
	arg0_47:OnShow(...)
end

function var0_0.Hide(arg0_48, arg1_48, arg2_48)
	local var0_48 = defaultValue(arg1_48, true)

	local function var1_48()
		arg0_48:ClosePage(arg0_48)
		arg0_48:RemoveListeners()
		arg0_48:OnHide()

		if not arg2_48 then
			arg0_48:OnExit()
		end
	end

	if var0_48 then
		arg0_48.islandUIController:Hide(true, var1_48)
	else
		var1_48()
	end
end

return var0_0
