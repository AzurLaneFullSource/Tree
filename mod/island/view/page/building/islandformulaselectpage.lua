local var0_0 = class("IslandFormulaSelectPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandFormulaSelectNewUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2._tf:Find("top/back")
	arg0_2.title = arg0_2._tf:Find("top/title")
	arg0_2.rightInfo = arg0_2._tf:Find("rightInfo")
	arg0_2.rightInfoEmpty = arg0_2._tf:Find("rightInfo_empty")
	arg0_2.currentformulaIcon = arg0_2._tf:Find("rightInfo/formula/currentformula")
	arg0_2.sureBtn = arg0_2._tf:Find("rightInfo/sure")
	arg0_2.formulaItem = arg0_2._tf:Find("rightInfo/formula")
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
	arg0_2.uiList = UIItemList.New(arg0_2._tf:Find("formulaView/content"), arg0_2._tf:Find("formulaView/content/tpl"))
	arg0_2.costuiList = UIItemList.New(arg0_2._tf:Find("rightInfo/formula/needItem/content"), arg0_2._tf:Find("rightInfo/formula/needItem/content/IslandItemTpl"))

	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_select_product"))
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
		if arg0_5.addDelegateFormulaTimes then
			local var0_10 = arg0_5:CheckCanAddMaxTimes() + arg0_5.addDelegateFormulaTimes

			arg0_5.curSelectCount = var0_10 > arg0_5.productMaxTime and arg0_5.productMaxTime or var0_10

			if arg0_5.curSelectCount < 1 then
				arg0_5.curSelectCount = 1
			end
		else
			arg0_5.curSelectCount = arg0_5:CheckCanAddMaxTimes()

			if arg0_5.curSelectCount < 1 then
				arg0_5.curSelectCount = 1
			end
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
	setActive(arg2_19:Find("icon_bg/count_bg"), true)
	setText(arg2_19:Find("name"), var3_19.name)
	setText(arg2_19:Find("icon_bg/product_count_bg/product_count"), "×" .. var3_19.commission_product[1][2])
	setText(arg2_19:Find("icon_bg/count_bg/count"), i18n("island_production_hold", var6_19))

	if arg0_19.selectedIdx == var0_19 then
		arg0_19:RefreshCurrentSelectFormula()
	end

	setActive(arg2_19:Find("selected"), arg0_19.selectedIdx == var0_19)
end

function var0_0.InitCostItem(arg0_20, arg1_20, arg2_20)
	return
end

function var0_0.UpdateCostItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.commission_Cost_List[arg1_21 + 1]

	updateCustomDrop(arg2_21, var0_21)

	local var1_21 = string.format("%d/%d", var0_21.itemCount, var0_21.costCount)

	setActive(arg2_21:Find("icon_bg/count_bg"), true)
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

	onButton(arg0_22, arg0_22.currentformulaIcon, function()
		arg0_22:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var1_22
		})
	end)
	GetImageSpriteFromAtlasAsync("island/islandframe", var3_22, arg0_22.currentformulaIcon:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync("island/" .. var4_22, "", arg0_22.currentformulaIcon:Find("icon_bg/icon"))
	arg0_22:RefreshCost()
end

function var0_0.RefreshCost(arg0_24)
	arg0_24.commission_Cost_List = {}

	local var0_24 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_24, iter1_24 in ipairs(arg0_24.formulaCfg.commission_cost) do
		local var1_24 = iter1_24[1]
		local var2_24 = var0_24:GetItemById(var1_24)
		local var3_24 = var2_24 and var2_24:GetCount() or 0
		local var4_24 = arg0_24.addDelegateFormulaTimes and arg0_24.curSelectCount - arg0_24.addDelegateFormulaTimes or arg0_24.curSelectCount
		local var5_24 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_24[1],
			itemCount = var3_24,
			costCount = iter1_24[2] * var4_24
		})

		table.insert(arg0_24.commission_Cost_List, var5_24)
	end

	arg0_24.costuiList:align(#arg0_24.commission_Cost_List)
	arg0_24:RefreshCurSelectCount()
	arg0_24:RefreshShipEnergy()
	arg0_24:RefreshCanStart()
end

function var0_0.CheckCanAddMaxTimes(arg0_25)
	arg0_25.commission_Cost_List = {}

	local var0_25 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_25 = arg0_25.productMaxTime

	for iter0_25, iter1_25 in ipairs(arg0_25.formulaCfg.commission_cost) do
		local var2_25 = iter1_25[1]
		local var3_25 = var0_25:GetItemById(var2_25)
		local var4_25 = var3_25 and var3_25:GetCount() or 0
		local var5_25 = iter1_25[2]

		var1_25 = math.min(var1_25, math.floor(var4_25 / var5_25))
	end

	return (math.min(math.floor(arg0_25.selectedShip:GetCurrentEnergy() / arg0_25.formulaCfg.stamina_cost), var1_25))
end

function var0_0.RefreshCanStart(arg0_26)
	local function var0_26()
		for iter0_27, iter1_27 in ipairs(arg0_26.commission_Cost_List) do
			if iter1_27.costCount > iter1_27.itemCount then
				return false
			end
		end

		return true
	end

	local function var1_26()
		local var0_28 = arg0_26.addDelegateFormulaTimes and arg0_26.curSelectCount - arg0_26.addDelegateFormulaTimes or arg0_26.curSelectCount

		if arg0_26.formulaCfg.stamina_cost * var0_28 > arg0_26.selectedShip:GetCurrentEnergy() then
			return false
		end

		return true
	end

	local function var2_26()
		local var0_29 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_26.placeId)
		local var1_29 = pg.island_production_slot[arg0_26.slotId]
		local var2_29 = var1_29.exclusion_slot == "" and {} or var1_29.exclusion_slot
		local var3_29 = {}
		local var4_29 = false

		for iter0_29, iter1_29 in ipairs(var2_29) do
			if var0_29:GetHandPlantSlotData(iter1_29).state == 1 then
				var4_29 = true

				table.insert(var3_29, iter1_29)
			end
		end

		return var4_29, var3_29
	end

	if var0_26() and var1_26() then
		setActive(arg0_26.enoughSureBg, true)
		setActive(arg0_26.notenoughSureBg, false)
		onButton(arg0_26, arg0_26.sureBtn, function()
			if arg0_26.addDelegateFormula then
				arg0_26.placeId = pg.island_production_slot[arg0_26.slotId].place

				local var0_30 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_26.placeId):GetDelegationSlotData(arg0_26.slotId)

				if var0_30 and not var0_30:GetSlotRoleData() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_additional_production_tip2"))

					return
				end
			end

			local var1_30 = arg0_26.formulaToActivityDic[arg0_26.selectFormulaId]

			if var1_30 then
				local var2_30 = getProxy(ActivityProxy):getActivityById(var1_30)

				if not var2_30 or var2_30:isEnd() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_activity_expired"))

					return
				end
			end

			local var3_30, var4_30 = var2_26()

			if var3_30 then
				arg0_26:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_production_manually_cancel"),
					onYes = function()
						pg.m02:sendNotification(GAME.ISLAND_STOP_HANDLE_PLANT_HALFWAY, {
							build_id = arg0_26.placeId,
							slot_list = var4_30
						})
						existCall(arg0_26.unLoadCharacterFunc)

						if arg0_26.addDelegateFormula then
							local var0_31 = arg0_26.curSelectCount - arg0_26.addDelegateFormulaTimes

							arg0_26:emit(IslandMediator.ADD_DELEGATION, arg0_26.placeId, arg0_26.slotId, var0_31)
						else
							arg0_26:emit(IslandMediator.START_DELEGATION, arg0_26.placeId, arg0_26.slotId, arg0_26.selectedShipId, arg0_26.selectFormulaId, arg0_26.curSelectCount)
						end

						existCall(arg0_26.confirmFunc)
						arg0_26:Hide()
					end,
					onNo = function()
						return
					end
				})

				return
			end

			existCall(arg0_26.unLoadCharacterFunc)

			if arg0_26.addDelegateFormula then
				local var5_30 = arg0_26.curSelectCount - arg0_26.addDelegateFormulaTimes

				arg0_26:emit(IslandMediator.ADD_DELEGATION, arg0_26.placeId, arg0_26.slotId, var5_30)
			else
				arg0_26:emit(IslandMediator.START_DELEGATION, arg0_26.placeId, arg0_26.slotId, arg0_26.selectedShipId, arg0_26.selectFormulaId, arg0_26.curSelectCount)
			end

			existCall(arg0_26.confirmFunc)
			arg0_26:Hide()
		end, SFX_PANEL)
	else
		setActive(arg0_26.enoughSureBg, false)
		setActive(arg0_26.notenoughSureBg, true)
		onButton(arg0_26, arg0_26.sureBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_cost_notenough"))
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_34, arg1_34)
	arg0_34:BlurPanel()

	arg0_34.commissionId = arg1_34.commissionId
	arg0_34.selectedShipId = arg1_34.selectedShipId
	arg0_34.cancelFunc = arg1_34.cancelFunc
	arg0_34.confirmFunc = arg1_34.confirmFunc
	arg0_34.unLoadCharacterFunc = arg1_34.unLoadCharacterFunc
	arg0_34.addDelegateFormula = arg1_34.addDelegateFormula
	arg0_34.addDelegateFormulaTimes = arg1_34.addDelegateFormulaTimes
	arg0_34.canRewardTime = arg1_34.canRewardTime

	setActive(arg0_34.addExpTF, arg0_34.selectedShipId ~= 1)

	if arg0_34.addDelegateFormulaTimes then
		setActive(arg0_34.barLimit, true)

		local var0_34 = arg0_34.addDelegateFormulaTimes / 5 * 352.6

		arg0_34.barLimit.sizeDelta = Vector2(var0_34, 22)

		setActive(arg0_34.addCountTips, true)
	else
		setActive(arg0_34.barLimit, false)
		setActive(arg0_34.addCountTips, false)
	end

	local var1_34 = arg0_34.addDelegateFormulaTimes and i18n("island_additional_production_tip1") or i18n("island_production_start")

	setText(arg0_34.sureBtn:Find("adapt/time/Text"), var1_34)

	arg0_34.slotId = pg.island_production_commission[arg0_34.commissionId].slot
	arg0_34.placeId = pg.island_production_slot[arg0_34.slotId].place
	arg0_34.selectedShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_34.selectedShipId)

	arg0_34:InitUnlockedFormulaList()

	if #arg0_34.formulaList > 0 then
		arg0_34.uiList:align(#arg0_34.formulaList)
		setActive(arg0_34.rightInfo, true)
		setActive(arg0_34.rightInfoEmpty, false)
		arg0_34:OnSelectFormulaIndex(1)
	else
		arg0_34.uiList:align(#arg0_34.formulaList)
		setActive(arg0_34.rightInfo, false)
		setActive(arg0_34.rightInfoEmpty, true)
	end

	arg0_34:RefreshShip()
end

function var0_0.RefreshShip(arg0_35)
	local var0_35 = IslandShip.StaticGetPrefab(arg0_35.selectedShipId)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_35, "", arg0_35.selectShipIcon)
	setText(arg0_35.selectShipName, arg0_35.selectedShip:GetName())
	setText(arg0_35.selectShipLv, string.format("-Lv.%d", arg0_35.selectedShip:GetLevel()))

	local var1_35 = arg0_35.selectedShip:GetSkill()
	local var2_35 = var1_35:IsEffectiveInPlace(arg0_35.placeId)

	setActive(arg0_35.skillInUse, var2_35)
	setActive(arg0_35.skillUnUse, not var2_35)
	setActive(arg0_35.skillUnUse, not var2_35)

	arg0_35.skillName.text = string.format("%s - %s", var1_35:GetName(), "Lv." .. var1_35:GetLevel() .. "")
end

function var0_0.RefreshShipEnergy(arg0_36)
	local var0_36 = arg0_36.addDelegateFormulaTimes and arg0_36.curSelectCount - arg0_36.addDelegateFormulaTimes or arg0_36.curSelectCount
	local var1_36 = arg0_36.formulaCfg.stamina_cost * var0_36

	if arg0_36.selectedShipId == 1 then
		var1_36 = 0
	else
		arg0_36.animationPlayer:Play("anim_IslandFormulaSelectNewUI_bar_Loop")
	end

	setText(arg0_36.addExp, "EXP+" .. arg0_36.formulaCfg.ship_exp * var0_36)

	if arg0_36.eneryTimer then
		arg0_36.eneryTimer:Stop()
	end

	arg0_36.eneryTimer = Timer.New(function()
		local var0_37 = arg0_36.selectedShip:GetCurrentEnergy()
		local var1_37 = arg0_36.selectedShip:GetMaxEnergy()

		setSlider(arg0_36.energyBarTf, 0, 1, (var0_37 - var1_36) / var1_37)
		setSlider(arg0_36.energyBarUseTf, 0, 1, var0_37 / var1_37)
		setText(arg0_36.energy_countTf, string.format("%d-<color=#f7c35f>%d</color>/%d", var0_37, var1_36, var1_37))
	end, 1, -1)

	arg0_36.eneryTimer:Start()
	arg0_36.eneryTimer.func()
end

function var0_0.InitUnlockedFormulaList(arg0_38)
	arg0_38.formulaList = {}
	arg0_38.formulaToActivityDic = {}

	if arg0_38.addDelegateFormula then
		table.insert(arg0_38.formulaList, arg0_38.addDelegateFormula)

		return
	end

	local var0_38 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_38, iter1_38 in ipairs(pg.island_production_slot[arg0_38.slotId].activity_formula or {}) do
		local var1_38 = iter1_38[1]
		local var2_38 = iter1_38[2]
		local var3_38 = getProxy(ActivityProxy):getActivityById(var1_38)

		if var3_38 and not var3_38:isEnd() then
			for iter2_38, iter3_38 in ipairs(var2_38 or {}) do
				if pg.island_formula[iter3_38].unlock_type == 0 or var0_38:IsUnlockFormuate(iter3_38) then
					table.insert(arg0_38.formulaList, iter3_38)

					arg0_38.formulaToActivityDic[iter3_38] = var1_38
				end
			end
		end
	end

	for iter4_38, iter5_38 in ipairs(pg.island_production_slot[arg0_38.slotId].formula or {}) do
		local var4_38 = pg.island_formula[iter5_38].unlock_type == 0
		local var5_38 = pg.island_formula[iter5_38].unlock_type == -1
		local var6_38 = true

		if var5_38 then
			local var7_38 = pg.island_combo[iter5_38].unlock_condition
			local var8_38 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()

			for iter6_38, iter7_38 in ipairs(var7_38) do
				local var9_38 = iter7_38[1]
				local var10_38 = iter7_38[2]

				if not var8_38[var9_38] or var10_38 > var8_38[var9_38] then
					var6_38 = false

					break
				end
			end
		end

		if var4_38 or var0_38:IsUnlockFormuate(iter5_38) or var5_38 and var6_38 then
			table.insert(arg0_38.formulaList, iter5_38)
		end
	end
end

function var0_0.RefreshCurSelectCount(arg0_39)
	local var0_39 = arg0_39.addDelegateFormulaTimes or arg0_39.curSelectCount

	setText(arg0_39.curCountTips, tostring(var0_39))

	local var1_39 = arg0_39.addDelegateFormulaTimes and arg0_39.curSelectCount - arg0_39.addDelegateFormulaTimes or 0

	setText(arg0_39.addCountTips, "+" .. var1_39)
	setSlider(arg0_39.curCountNumSlider, 1, arg0_39.productMaxTime, arg0_39.curSelectCount)
	arg0_39:RefreshExtraProduct()
	setText(arg0_39.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), "×" .. arg0_39.formulaCfg.commission_product[1][2])

	local var2_39 = arg0_39:CacaluteProductTime()
	local var3_39 = 0

	for iter0_39, iter1_39 in ipairs(var2_39) do
		var3_39 = var3_39 + iter1_39
	end

	setText(arg0_39.needTimeText, pg.TimeMgr.GetInstance():DescCDTime(var3_39))
end

function var0_0.RefreshExtraProduct(arg0_40)
	local var0_40 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	if #arg0_40.formulaCfg.second_product == 0 or not var0_40:IsUnlcokSecondProduct(arg0_40.selectFormulaId) then
		setActive(arg0_40.extraProduct, false)

		return
	end

	setActive(arg0_40.extraProduct, true)

	local var1_40 = arg0_40.formulaCfg.second_product_display[1][1]
	local var2_40 = arg0_40.formulaCfg.second_product_display[1][2]
	local var3_40 = pg.island_item_data_template[var1_40]
	local var4_40 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var1_40
	})

	onButton(arg0_40, arg0_40.extraProductIcon, function()
		arg0_40:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var4_40
		})
	end)
	GetImageSpriteFromAtlasAsync("island/" .. var3_40.icon, "", arg0_40.extraProductIcon)
	setText(arg0_40.extraProductNum, "×" .. var2_40)

	local var5_40 = pg.island_production_slot[arg0_40.slotId].place
	local var6_40 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var5_40):GetDelegationSlotData(arg0_40.slotId):GetFromulaTatalCount(arg0_40.formulaCfg.id)
	local var7_40 = arg0_40.formulaCfg.second_product[1]
	local var8_40 = (var6_40 + (arg0_40.canRewardTime or 0)) % var7_40
	local var9_40 = var8_40 + (arg0_40.addDelegateFormulaTimes and arg0_40.curSelectCount - arg0_40.addDelegateFormulaTimes or arg0_40.curSelectCount)
	local var10_40 = math.floor(var9_40 / var7_40)

	arg0_40.extraProcess = var9_40 % var7_40

	setText(arg0_40.extraProductName, var3_40.name .. "×" .. var10_40)

	if arg0_40.addDelegateFormulaTimes then
		setActive(arg0_40.extraProductAddnum, true)

		local var11_40 = arg0_40.curSelectCount - arg0_40.addDelegateFormulaTimes
		local var12_40 = math.floor((var8_40 + var11_40) / var7_40)

		setText(arg0_40.extraProductAddnum, "+" .. var12_40)
	else
		setActive(arg0_40.extraProductAddnum, false)
	end

	arg0_40.extraProductList:align(var7_40)
end

function var0_0.CacaluteProductTime(arg0_42)
	local var0_42 = arg0_42.addDelegateFormulaTimes and arg0_42.curSelectCount - arg0_42.addDelegateFormulaTimes or arg0_42.curSelectCount

	return IslandProductTimeHelper.CalculateTimeToProductFormula(arg0_42.selectedShipId, arg0_42.selectFormulaId, var0_42, arg0_42.placeId, arg0_42.slotId)
end

function var0_0.CheckInPlace(arg0_43, arg1_43, arg2_43)
	for iter0_43, iter1_43 in ipairs(arg2_43) do
		if iter1_43 == arg1_43 then
			return true
		end
	end

	return false
end

function var0_0.GetAttrGrade(arg0_44, arg1_44)
	local var0_44 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_44, iter1_44 in ipairs(pg.island_chara_att.all) do
		local var1_44 = pg.island_chara_att[iter1_44]
		local var2_44 = var1_44.range[1]
		local var3_44 = var1_44.range[2]

		if var2_44 <= arg1_44 and arg1_44 <= var3_44 then
			var0_44 = iter1_44

			break
		end
	end

	return var0_44
end

function var0_0.GetAttrGrowingValueByBuff(arg0_45, arg1_45, arg2_45)
	for iter0_45, iter1_45 in ipairs(arg2_45) do
		if iter1_45[1] == arg1_45 then
			return iter1_45[2]
		end
	end

	return 0
end

function var0_0.OnHide(arg0_46)
	arg0_46:UnBlurPanel()

	if arg0_46.eneryTimer then
		arg0_46.eneryTimer:Stop()
	end
end

function var0_0.OnDisable(arg0_47)
	arg0_47:OnHide()
end

function var0_0.OnDestroy(arg0_48)
	return
end

function var0_0.Show(arg0_49, ...)
	arg0_49:AddListeners()
	arg0_49.islandUIController:Show(true)
	arg0_49:OnShow(...)
end

function var0_0.Hide(arg0_50, arg1_50, arg2_50)
	local var0_50 = defaultValue(arg1_50, true)

	local function var1_50()
		arg0_50:ClosePage(arg0_50)
		arg0_50:RemoveListeners()
		arg0_50:OnHide()

		if not arg2_50 then
			arg0_50:OnExit()
		end
	end

	if var0_50 then
		arg0_50.islandUIController:Hide(true, var1_50)
	else
		var1_50()
	end
end

return var0_0
