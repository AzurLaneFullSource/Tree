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
	setScrollTextWithSize(arg2_19:Find("name"), arg2_19:Find("scroll_name/name"), var3_19.name, 6)
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

	if var0_21.extraCostCount and var0_21.extraCostCount > 0 then
		var1_21 = string.format("%d/(%d<color=#ffae22>+%d</color>)", var0_21.itemCount, var0_21.costCount, var0_21.extraCostCount)
	end

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

function var0_0.GetAniExtraGainByConfigName(arg0_24, arg1_24)
	local var0_24 = 0

	if arg0_24.placeId ~= IslandProductConst.PasturePlaceId then
		return var0_24
	end

	local var1_24 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_24.placeId):GetDelegationSlotData(arg0_24.slotId):GetPartList()

	for iter0_24, iter1_24 in ipairs(var1_24) do
		var0_24 = var0_24 + pg.island_ranch_animal[iter1_24][arg1_24]
	end

	return var0_24
end

function var0_0.RefreshCost(arg0_25)
	arg0_25.commission_Cost_List = {}

	local var0_25 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_25 = arg0_25:GetAniExtraGainByConfigName("efficiency_cost")

	for iter0_25, iter1_25 in ipairs(arg0_25.formulaCfg.commission_cost) do
		local var2_25 = iter1_25[1]
		local var3_25 = var0_25:GetItemById(var2_25)
		local var4_25 = var3_25 and var3_25:GetCount() or 0
		local var5_25 = arg0_25.addDelegateFormulaTimes and arg0_25.curSelectCount - arg0_25.addDelegateFormulaTimes or arg0_25.curSelectCount
		local var6_25 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_25[1],
			itemCount = var4_25,
			costCount = iter1_25[2] * var5_25,
			extraCostCount = var1_25 * var5_25
		})

		table.insert(arg0_25.commission_Cost_List, var6_25)
	end

	arg0_25.costuiList:align(#arg0_25.commission_Cost_List)
	arg0_25:RefreshCurSelectCount()
	arg0_25:RefreshShipEnergy()
	arg0_25:RefreshCanStart()
end

function var0_0.CheckCanAddMaxTimes(arg0_26)
	arg0_26.commission_Cost_List = {}

	local var0_26 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_26 = arg0_26.productMaxTime
	local var2_26 = arg0_26:GetAniExtraGainByConfigName("efficiency_cost")

	for iter0_26, iter1_26 in ipairs(arg0_26.formulaCfg.commission_cost) do
		local var3_26 = iter1_26[1]
		local var4_26 = var0_26:GetItemById(var3_26)
		local var5_26 = var4_26 and var4_26:GetCount() or 0
		local var6_26 = iter1_26[2] + var2_26

		var1_26 = math.min(var1_26, math.floor(var5_26 / var6_26))
	end

	return (math.min(math.floor(arg0_26.selectedShip:GetCurrentEnergy() / arg0_26.formulaCfg.stamina_cost), var1_26))
end

function var0_0.RefreshCanStart(arg0_27)
	local function var0_27()
		for iter0_28, iter1_28 in ipairs(arg0_27.commission_Cost_List) do
			if iter1_28.costCount + iter1_28.extraCostCount > iter1_28.itemCount then
				return false
			end
		end

		return true
	end

	local function var1_27()
		local var0_29 = arg0_27.addDelegateFormulaTimes and arg0_27.curSelectCount - arg0_27.addDelegateFormulaTimes or arg0_27.curSelectCount

		if arg0_27.formulaCfg.stamina_cost * var0_29 > arg0_27.selectedShip:GetCurrentEnergy() then
			return false
		end

		return true
	end

	local function var2_27()
		local var0_30 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_27.placeId)
		local var1_30 = pg.island_production_slot[arg0_27.slotId]
		local var2_30 = var1_30.exclusion_slot == "" and {} or var1_30.exclusion_slot
		local var3_30 = {}
		local var4_30 = false

		for iter0_30, iter1_30 in ipairs(var2_30) do
			if var0_30:GetHandPlantSlotData(iter1_30).state == 1 then
				var4_30 = true

				table.insert(var3_30, iter1_30)
			end
		end

		return var4_30, var3_30
	end

	if var0_27() and var1_27() then
		setActive(arg0_27.enoughSureBg, true)
		setActive(arg0_27.notenoughSureBg, false)
		onButton(arg0_27, arg0_27.sureBtn, function()
			if arg0_27.addDelegateFormula then
				arg0_27.placeId = pg.island_production_slot[arg0_27.slotId].place

				local var0_31 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_27.placeId):GetDelegationSlotData(arg0_27.slotId)

				if var0_31 and not var0_31:GetSlotRoleData() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_additional_production_tip2"))

					return
				end
			end

			local var1_31 = arg0_27.formulaToActivityDic[arg0_27.selectFormulaId]

			if var1_31 then
				local var2_31 = getProxy(ActivityProxy):getActivityById(var1_31)

				if not var2_31 or var2_31:isEnd() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_activity_expired"))

					return
				end
			end

			local var3_31, var4_31 = var2_27()

			if var3_31 then
				arg0_27:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_production_manually_cancel"),
					onYes = function()
						pg.m02:sendNotification(GAME.ISLAND_STOP_HANDLE_PLANT_HALFWAY, {
							build_id = arg0_27.placeId,
							slot_list = var4_31
						})
						existCall(arg0_27.unLoadCharacterFunc)

						local var0_32 = arg0_27:GetAniExtraGainByConfigName("efficiency_cost")

						if arg0_27.addDelegateFormula then
							local var1_32 = arg0_27.curSelectCount - arg0_27.addDelegateFormulaTimes

							arg0_27:emit(IslandMediator.ADD_DELEGATION, arg0_27.placeId, arg0_27.slotId, var1_32, var0_32)
						else
							arg0_27:emit(IslandMediator.START_DELEGATION, arg0_27.placeId, arg0_27.slotId, arg0_27.selectedShipId, arg0_27.selectFormulaId, arg0_27.curSelectCount, var0_32)
						end

						existCall(arg0_27.confirmFunc)
						arg0_27:Hide()
					end,
					onNo = function()
						return
					end
				})

				return
			end

			existCall(arg0_27.unLoadCharacterFunc)

			local var5_31 = arg0_27:GetAniExtraGainByConfigName("efficiency_cost")

			if arg0_27.addDelegateFormula then
				local var6_31 = arg0_27.curSelectCount - arg0_27.addDelegateFormulaTimes

				arg0_27:emit(IslandMediator.ADD_DELEGATION, arg0_27.placeId, arg0_27.slotId, var6_31, var5_31)
			else
				arg0_27:emit(IslandMediator.START_DELEGATION, arg0_27.placeId, arg0_27.slotId, arg0_27.selectedShipId, arg0_27.selectFormulaId, arg0_27.curSelectCount, var5_31)
			end

			existCall(arg0_27.confirmFunc)
			arg0_27:Hide()
		end, SFX_PANEL)
	else
		setActive(arg0_27.enoughSureBg, false)
		setActive(arg0_27.notenoughSureBg, true)
		onButton(arg0_27, arg0_27.sureBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_cost_notenough"))
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_35, arg1_35)
	arg0_35:BlurPanel()

	arg0_35.commissionId = arg1_35.commissionId
	arg0_35.selectedShipId = arg1_35.selectedShipId
	arg0_35.cancelFunc = arg1_35.cancelFunc
	arg0_35.confirmFunc = arg1_35.confirmFunc
	arg0_35.unLoadCharacterFunc = arg1_35.unLoadCharacterFunc
	arg0_35.addDelegateFormula = arg1_35.addDelegateFormula
	arg0_35.addDelegateFormulaTimes = arg1_35.addDelegateFormulaTimes
	arg0_35.canRewardTime = arg1_35.canRewardTime

	setActive(arg0_35.addExpTF, arg0_35.selectedShipId ~= 1)

	if arg0_35.addDelegateFormulaTimes then
		setActive(arg0_35.barLimit, true)

		local var0_35 = pg.island_formula[arg0_35.addDelegateFormula].production_limit or 5
		local var1_35 = arg0_35.addDelegateFormulaTimes / var0_35 * 352.6

		arg0_35.barLimit.sizeDelta = Vector2(var1_35, 22)

		setActive(arg0_35.addCountTips, true)
	else
		setActive(arg0_35.barLimit, false)
		setActive(arg0_35.addCountTips, false)
	end

	local var2_35 = arg0_35.addDelegateFormulaTimes and i18n("island_additional_production_tip1") or i18n("island_production_start")

	setText(arg0_35.sureBtn:Find("adapt/time/Text"), var2_35)

	arg0_35.slotId = pg.island_production_commission[arg0_35.commissionId].slot
	arg0_35.placeId = pg.island_production_slot[arg0_35.slotId].place
	arg0_35.selectedShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_35.selectedShipId)

	arg0_35:InitUnlockedFormulaList()

	if #arg0_35.formulaList > 0 then
		arg0_35.uiList:align(#arg0_35.formulaList)
		setActive(arg0_35.rightInfo, true)
		setActive(arg0_35.rightInfoEmpty, false)
		arg0_35:OnSelectFormulaIndex(1)
	else
		arg0_35.uiList:align(#arg0_35.formulaList)
		setActive(arg0_35.rightInfo, false)
		setActive(arg0_35.rightInfoEmpty, true)
	end

	arg0_35:RefreshShip()
end

function var0_0.RefreshShip(arg0_36)
	local var0_36 = IslandShip.StaticGetPrefab(arg0_36.selectedShipId)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_36, "", arg0_36.selectShipIcon)
	setText(arg0_36.selectShipName, arg0_36.selectedShip:GetName())
	setText(arg0_36.selectShipLv, string.format("-Lv.%d", arg0_36.selectedShip:GetLevel()))

	local var1_36 = arg0_36.selectedShip:GetSkill()
	local var2_36 = var1_36:IsEffectiveInPlace(arg0_36.placeId)

	setActive(arg0_36.skillInUse, var2_36)
	setActive(arg0_36.skillUnUse, not var2_36)
	setActive(arg0_36.skillUnUse, not var2_36)

	arg0_36.skillName.text = string.format("%s - %s", var1_36:GetName(), "Lv." .. var1_36:GetLevel() .. "")
end

function var0_0.RefreshShipEnergy(arg0_37)
	local var0_37 = arg0_37.addDelegateFormulaTimes and arg0_37.curSelectCount - arg0_37.addDelegateFormulaTimes or arg0_37.curSelectCount
	local var1_37 = arg0_37.formulaCfg.stamina_cost * var0_37

	if arg0_37.selectedShipId == 1 then
		var1_37 = 0
	else
		arg0_37.animationPlayer:Play("anim_IslandFormulaSelectNewUI_bar_Loop")
	end

	setText(arg0_37.addExp, "EXP+" .. arg0_37.formulaCfg.ship_exp * var0_37)

	if arg0_37.eneryTimer then
		arg0_37.eneryTimer:Stop()
	end

	arg0_37.eneryTimer = Timer.New(function()
		local var0_38 = arg0_37.selectedShip:GetCurrentEnergy()
		local var1_38 = arg0_37.selectedShip:GetMaxEnergy()

		setSlider(arg0_37.energyBarTf, 0, 1, (var0_38 - var1_37) / var1_38)
		setSlider(arg0_37.energyBarUseTf, 0, 1, var0_38 / var1_38)
		setText(arg0_37.energy_countTf, string.format("%d-<color=#f7c35f>%d</color>/%d", var0_38, var1_37, var1_38))
	end, 1, -1)

	arg0_37.eneryTimer:Start()
	arg0_37.eneryTimer.func()
end

function var0_0.InitUnlockedFormulaList(arg0_39)
	arg0_39.formulaList = {}
	arg0_39.formulaToActivityDic = {}

	if arg0_39.addDelegateFormula then
		table.insert(arg0_39.formulaList, arg0_39.addDelegateFormula)

		return
	end

	local var0_39 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_39, iter1_39 in ipairs(pg.island_production_slot[arg0_39.slotId].activity_formula or {}) do
		local var1_39 = iter1_39[1]
		local var2_39 = iter1_39[2]
		local var3_39 = getProxy(ActivityProxy):getActivityById(var1_39)

		if var3_39 and not var3_39:isEnd() then
			for iter2_39, iter3_39 in ipairs(var2_39 or {}) do
				if pg.island_formula[iter3_39].unlock_type == 0 or var0_39:IsUnlockFormuate(iter3_39) then
					table.insert(arg0_39.formulaList, iter3_39)

					arg0_39.formulaToActivityDic[iter3_39] = var1_39
				end
			end
		end
	end

	for iter4_39, iter5_39 in ipairs(pg.island_production_slot[arg0_39.slotId].formula or {}) do
		local var4_39 = pg.island_formula[iter5_39].unlock_type == 0
		local var5_39 = pg.island_formula[iter5_39].unlock_type == -1
		local var6_39 = true

		if var5_39 then
			local var7_39 = pg.island_combo[iter5_39].unlock_condition
			local var8_39 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()

			for iter6_39, iter7_39 in ipairs(var7_39) do
				local var9_39 = iter7_39[1]
				local var10_39 = iter7_39[2]

				if not var8_39[var9_39] or var10_39 > var8_39[var9_39] then
					var6_39 = false

					break
				end
			end
		end

		if var4_39 or var0_39:IsUnlockFormuate(iter5_39) or var5_39 and var6_39 then
			table.insert(arg0_39.formulaList, iter5_39)
		end
	end
end

function var0_0.RefreshCurSelectCount(arg0_40)
	local var0_40 = arg0_40.addDelegateFormulaTimes or arg0_40.curSelectCount

	setText(arg0_40.curCountTips, tostring(var0_40))

	local var1_40 = arg0_40.addDelegateFormulaTimes and arg0_40.curSelectCount - arg0_40.addDelegateFormulaTimes or 0

	setText(arg0_40.addCountTips, "+" .. var1_40)
	setSlider(arg0_40.curCountNumSlider, 1, arg0_40.productMaxTime, arg0_40.curSelectCount)
	arg0_40:RefreshExtraProduct()

	local var2_40 = "×" .. arg0_40.formulaCfg.commission_product[1][2]
	local var3_40 = arg0_40:GetAniExtraGainByConfigName("efficiency_gains_num")

	if var3_40 > 0 then
		var2_40 = string.format("×(%s<color=#7df39f>+%d</color>)", arg0_40.formulaCfg.commission_product[1][2], var3_40)
	end

	setText(arg0_40.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), var2_40 .. i18n("island_production_tip"))

	local var4_40, var5_40 = arg0_40:CacaluteProductTime()
	local var6_40 = 0

	for iter0_40, iter1_40 in ipairs(var4_40) do
		var6_40 = var6_40 + iter1_40
	end

	local var7_40 = var5_40 - var6_40
	local var8_40 = pg.TimeMgr.GetInstance():DescCDTime(var6_40)

	if var7_40 > 0 then
		var8_40 = string.format("%s(<color=#7df39f>-%s</color>)", var8_40, pg.TimeMgr.GetInstance():DescCDTime(var7_40))
	end

	setText(arg0_40.needTimeText, var8_40)
end

function var0_0.RefreshExtraProduct(arg0_41)
	local var0_41 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	if #arg0_41.formulaCfg.second_product == 0 or not var0_41:IsUnlcokSecondProduct(arg0_41.selectFormulaId) then
		setActive(arg0_41.extraProduct, false)

		return
	end

	setActive(arg0_41.extraProduct, true)

	local var1_41 = arg0_41.formulaCfg.second_product_display[1][1]
	local var2_41 = arg0_41.formulaCfg.second_product_display[1][2]
	local var3_41 = pg.island_item_data_template[var1_41]
	local var4_41 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var1_41
	})

	onButton(arg0_41, arg0_41.extraProductIcon, function()
		arg0_41:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var4_41
		})
	end)
	GetImageSpriteFromAtlasAsync("island/" .. var3_41.icon, "", arg0_41.extraProductIcon)

	local var5_41 = "×" .. var2_41
	local var6_41 = arg0_41:GetAniExtraGainByConfigName("efficiency_gains_bonus_num")

	if var6_41 > 0 then
		var5_41 = string.format("×(%s<color=#7df39f>+%d</color>)", var2_41, var6_41)
	end

	setText(arg0_41.extraProductNum, var5_41 .. i18n("island_production_tip"))
	setText(arg0_41.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), curCountStr)

	local var7_41 = pg.island_production_slot[arg0_41.slotId].place
	local var8_41 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var7_41):GetDelegationSlotData(arg0_41.slotId):GetFromulaTatalCount(arg0_41.formulaCfg.id)
	local var9_41 = arg0_41.formulaCfg.second_product[1]
	local var10_41 = (var8_41 + (arg0_41.canRewardTime or 0)) % var9_41
	local var11_41 = var10_41 + (arg0_41.addDelegateFormulaTimes and arg0_41.curSelectCount - arg0_41.addDelegateFormulaTimes or arg0_41.curSelectCount)
	local var12_41 = math.floor(var11_41 / var9_41)

	arg0_41.extraProcess = var11_41 % var9_41

	setText(arg0_41.extraProductName, var3_41.name .. "×" .. var12_41)

	if arg0_41.addDelegateFormulaTimes then
		setActive(arg0_41.extraProductAddnum, true)

		local var13_41 = arg0_41.curSelectCount - arg0_41.addDelegateFormulaTimes
		local var14_41 = math.floor((var10_41 + var13_41) / var9_41)

		setText(arg0_41.extraProductAddnum, "+" .. var14_41)
	else
		setActive(arg0_41.extraProductAddnum, false)
	end

	arg0_41.extraProductList:align(var9_41)
end

function var0_0.CacaluteProductTime(arg0_43)
	local var0_43 = arg0_43.addDelegateFormulaTimes and arg0_43.curSelectCount - arg0_43.addDelegateFormulaTimes or arg0_43.curSelectCount
	local var1_43 = pg.island_set.base_efficiency.key_value_int
	local var2_43 = math.ceil(arg0_43.formulaCfg.workload / var1_43)

	return IslandProductTimeHelper.CalculateTimeToProductFormula(arg0_43.selectedShipId, arg0_43.selectFormulaId, var0_43, arg0_43.placeId, arg0_43.slotId), var2_43 * var0_43
end

function var0_0.CheckInPlace(arg0_44, arg1_44, arg2_44)
	for iter0_44, iter1_44 in ipairs(arg2_44) do
		if iter1_44 == arg1_44 then
			return true
		end
	end

	return false
end

function var0_0.GetAttrGrade(arg0_45, arg1_45)
	local var0_45 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_45, iter1_45 in ipairs(pg.island_chara_att.all) do
		local var1_45 = pg.island_chara_att[iter1_45]
		local var2_45 = var1_45.range[1]
		local var3_45 = var1_45.range[2]

		if var2_45 <= arg1_45 and arg1_45 <= var3_45 then
			var0_45 = iter1_45

			break
		end
	end

	return var0_45
end

function var0_0.GetAttrGrowingValueByBuff(arg0_46, arg1_46, arg2_46)
	for iter0_46, iter1_46 in ipairs(arg2_46) do
		if iter1_46[1] == arg1_46 then
			return iter1_46[2]
		end
	end

	return 0
end

function var0_0.OnHide(arg0_47)
	arg0_47:UnBlurPanel()

	if arg0_47.eneryTimer then
		arg0_47.eneryTimer:Stop()
	end
end

function var0_0.OnDisable(arg0_48)
	arg0_48:OnHide()
end

function var0_0.OnDestroy(arg0_49)
	arg0_49:OnHide()
end

function var0_0.Show(arg0_50, ...)
	arg0_50:AddListeners()
	arg0_50.islandUIController:Show(true)
	arg0_50:OnShow(...)
end

function var0_0.Hide(arg0_51, arg1_51, arg2_51)
	local var0_51 = defaultValue(arg1_51, true)

	local function var1_51()
		arg0_51:ClosePage(arg0_51)
		arg0_51:RemoveListeners()
		arg0_51:OnHide()

		if not arg2_51 then
			arg0_51:OnExit()
		end
	end

	if var0_51 then
		arg0_51.islandUIController:Hide(true, var1_51)
	else
		var1_51()
	end
end

return var0_0
