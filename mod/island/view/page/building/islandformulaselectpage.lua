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
	onButton(arg0_21, arg2_21:Find("icon_bg/icon"), function()
		arg0_21:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var0_21
		})
	end)
end

function var0_0.RefreshCurrentSelectFormula(arg0_23)
	local var0_23 = arg0_23.formulaCfg.item_id
	local var1_23 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var0_23
	})
	local var2_23 = var1_23:getConfigTable().rarity
	local var3_23 = IslandItemRarity.Rarity2FrameName(var2_23)
	local var4_23 = var1_23:getConfigTable().icon

	onButton(arg0_23, arg0_23.currentformulaIcon, function()
		arg0_23:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var1_23
		})
	end)
	GetImageSpriteFromAtlasAsync("island/islandframe", var3_23, arg0_23.currentformulaIcon:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync("island/" .. var4_23, "", arg0_23.currentformulaIcon:Find("icon_bg/icon"))
	arg0_23:RefreshCost()
end

function var0_0.GetAniExtraGainByConfigName(arg0_25, arg1_25)
	local var0_25 = 0

	if arg0_25.placeId ~= IslandProductConst.PasturePlaceId then
		return var0_25
	end

	local var1_25 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_25.placeId):GetDelegationSlotData(arg0_25.slotId):GetPartList()

	for iter0_25, iter1_25 in ipairs(var1_25) do
		var0_25 = var0_25 + pg.island_ranch_animal[iter1_25][arg1_25]
	end

	return var0_25
end

function var0_0.RefreshCost(arg0_26)
	arg0_26.commission_Cost_List = {}

	local var0_26 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_26 = arg0_26:GetAniExtraGainByConfigName("efficiency_cost")

	for iter0_26, iter1_26 in ipairs(arg0_26.formulaCfg.commission_cost) do
		local var2_26 = iter1_26[1]
		local var3_26 = var0_26:GetItemById(var2_26)
		local var4_26 = var3_26 and var3_26:GetCount() or 0
		local var5_26 = arg0_26.addDelegateFormulaTimes and arg0_26.curSelectCount - arg0_26.addDelegateFormulaTimes or arg0_26.curSelectCount
		local var6_26 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_26[1],
			itemCount = var4_26,
			costCount = iter1_26[2] * var5_26,
			extraCostCount = var1_26 * var5_26
		})

		table.insert(arg0_26.commission_Cost_List, var6_26)
	end

	arg0_26.costuiList:align(#arg0_26.commission_Cost_List)
	arg0_26:RefreshCurSelectCount()
	arg0_26:RefreshShipEnergy()
	arg0_26:RefreshCanStart()
end

function var0_0.CheckCanAddMaxTimes(arg0_27)
	arg0_27.commission_Cost_List = {}

	local var0_27 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_27 = arg0_27.productMaxTime
	local var2_27 = arg0_27:GetAniExtraGainByConfigName("efficiency_cost")

	for iter0_27, iter1_27 in ipairs(arg0_27.formulaCfg.commission_cost) do
		local var3_27 = iter1_27[1]
		local var4_27 = var0_27:GetItemById(var3_27)
		local var5_27 = var4_27 and var4_27:GetCount() or 0
		local var6_27 = iter1_27[2] + var2_27

		var1_27 = math.min(var1_27, math.floor(var5_27 / var6_27))
	end

	return (math.min(math.floor(arg0_27.selectedShip:GetCurrentEnergy() / arg0_27.formulaCfg.stamina_cost), var1_27))
end

function var0_0.RefreshCanStart(arg0_28)
	local function var0_28()
		for iter0_29, iter1_29 in ipairs(arg0_28.commission_Cost_List) do
			if iter1_29.costCount + iter1_29.extraCostCount > iter1_29.itemCount then
				return false
			end
		end

		return true
	end

	local function var1_28()
		local var0_30 = arg0_28.addDelegateFormulaTimes and arg0_28.curSelectCount - arg0_28.addDelegateFormulaTimes or arg0_28.curSelectCount

		if arg0_28.formulaCfg.stamina_cost * var0_30 > arg0_28.selectedShip:GetCurrentEnergy() then
			return false
		end

		return true
	end

	local function var2_28()
		local var0_31 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_28.placeId)
		local var1_31 = pg.island_production_slot[arg0_28.slotId]
		local var2_31 = var1_31.exclusion_slot == "" and {} or var1_31.exclusion_slot
		local var3_31 = {}
		local var4_31 = false

		for iter0_31, iter1_31 in ipairs(var2_31) do
			if var0_31:GetHandPlantSlotData(iter1_31).state == 1 then
				var4_31 = true

				table.insert(var3_31, iter1_31)
			end
		end

		return var4_31, var3_31
	end

	if var0_28() and var1_28() then
		setActive(arg0_28.enoughSureBg, true)
		setActive(arg0_28.notenoughSureBg, false)
		onButton(arg0_28, arg0_28.sureBtn, function()
			if arg0_28.addDelegateFormula then
				arg0_28.placeId = pg.island_production_slot[arg0_28.slotId].place

				local var0_32 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_28.placeId):GetDelegationSlotData(arg0_28.slotId)

				if var0_32 and not var0_32:GetSlotRoleData() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_additional_production_tip2"))

					return
				end
			end

			local var1_32 = arg0_28.formulaToActivityDic[arg0_28.selectFormulaId]

			if var1_32 then
				local var2_32 = getProxy(ActivityProxy):getActivityById(var1_32)

				if not var2_32 or var2_32:isEnd() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_activity_expired"))

					return
				end
			end

			local var3_32, var4_32 = var2_28()

			if var3_32 then
				arg0_28:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_production_manually_cancel"),
					onYes = function()
						pg.m02:sendNotification(GAME.ISLAND_STOP_HANDLE_PLANT_HALFWAY, {
							build_id = arg0_28.placeId,
							slot_list = var4_32
						})
						existCall(arg0_28.unLoadCharacterFunc)

						local var0_33 = arg0_28:GetAniExtraGainByConfigName("efficiency_cost")

						if arg0_28.addDelegateFormula then
							local var1_33 = arg0_28.curSelectCount - arg0_28.addDelegateFormulaTimes

							arg0_28:emit(IslandMediator.ADD_DELEGATION, arg0_28.placeId, arg0_28.slotId, var1_33, var0_33)
						else
							arg0_28:emit(IslandMediator.START_DELEGATION, arg0_28.placeId, arg0_28.slotId, arg0_28.selectedShipId, arg0_28.selectFormulaId, arg0_28.curSelectCount, var0_33)
						end

						existCall(arg0_28.confirmFunc)
						arg0_28:Hide()
					end,
					onNo = function()
						return
					end
				})

				return
			end

			existCall(arg0_28.unLoadCharacterFunc)

			local var5_32 = arg0_28:GetAniExtraGainByConfigName("efficiency_cost")

			if arg0_28.addDelegateFormula then
				local var6_32 = arg0_28.curSelectCount - arg0_28.addDelegateFormulaTimes

				arg0_28:emit(IslandMediator.ADD_DELEGATION, arg0_28.placeId, arg0_28.slotId, var6_32, var5_32)
			else
				arg0_28:emit(IslandMediator.START_DELEGATION, arg0_28.placeId, arg0_28.slotId, arg0_28.selectedShipId, arg0_28.selectFormulaId, arg0_28.curSelectCount, var5_32)
			end

			existCall(arg0_28.confirmFunc)
			arg0_28:Hide()
		end, SFX_PANEL)
	else
		setActive(arg0_28.enoughSureBg, false)
		setActive(arg0_28.notenoughSureBg, true)
		onButton(arg0_28, arg0_28.sureBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_cost_notenough"))
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_36, arg1_36)
	arg0_36:BlurPanel()

	arg0_36.commissionId = arg1_36.commissionId
	arg0_36.selectedShipId = arg1_36.selectedShipId
	arg0_36.cancelFunc = arg1_36.cancelFunc
	arg0_36.confirmFunc = arg1_36.confirmFunc
	arg0_36.unLoadCharacterFunc = arg1_36.unLoadCharacterFunc
	arg0_36.addDelegateFormula = arg1_36.addDelegateFormula
	arg0_36.addDelegateFormulaTimes = arg1_36.addDelegateFormulaTimes
	arg0_36.canRewardTime = arg1_36.canRewardTime

	setActive(arg0_36.addExpTF, arg0_36.selectedShipId ~= 1)

	if arg0_36.addDelegateFormulaTimes then
		setActive(arg0_36.barLimit, true)

		local var0_36 = pg.island_formula[arg0_36.addDelegateFormula].production_limit or 5
		local var1_36 = arg0_36.addDelegateFormulaTimes / var0_36 * 352.6

		arg0_36.barLimit.sizeDelta = Vector2(var1_36, 22)

		setActive(arg0_36.addCountTips, true)
	else
		setActive(arg0_36.barLimit, false)
		setActive(arg0_36.addCountTips, false)
	end

	local var2_36 = arg0_36.addDelegateFormulaTimes and i18n("island_additional_production_tip1") or i18n("island_production_start")

	setText(arg0_36.sureBtn:Find("adapt/time/Text"), var2_36)

	arg0_36.slotId = pg.island_production_commission[arg0_36.commissionId].slot
	arg0_36.placeId = pg.island_production_slot[arg0_36.slotId].place
	arg0_36.selectedShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_36.selectedShipId)

	arg0_36:InitUnlockedFormulaList()

	if #arg0_36.formulaList > 0 then
		arg0_36.uiList:align(#arg0_36.formulaList)
		setActive(arg0_36.rightInfo, true)
		setActive(arg0_36.rightInfoEmpty, false)
		arg0_36:OnSelectFormulaIndex(1)
	else
		arg0_36.uiList:align(#arg0_36.formulaList)
		setActive(arg0_36.rightInfo, false)
		setActive(arg0_36.rightInfoEmpty, true)
	end

	arg0_36:RefreshShip()
end

function var0_0.RefreshShip(arg0_37)
	local var0_37 = IslandShip.StaticGetPrefab(arg0_37.selectedShipId)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_37, "", arg0_37.selectShipIcon)
	setText(arg0_37.selectShipName, arg0_37.selectedShip:GetName())
	setText(arg0_37.selectShipLv, string.format("-Lv.%d", arg0_37.selectedShip:GetLevel()))

	local var1_37 = arg0_37.selectedShip:GetSkill()
	local var2_37 = var1_37:IsEffectiveInPlace(arg0_37.placeId)

	setActive(arg0_37.skillInUse, var2_37)
	setActive(arg0_37.skillUnUse, not var2_37)
	setActive(arg0_37.skillUnUse, not var2_37)

	arg0_37.skillName.text = string.format("%s - %s", var1_37:GetName(), "Lv." .. var1_37:GetLevel() .. "")
end

function var0_0.RefreshShipEnergy(arg0_38)
	local var0_38 = arg0_38.addDelegateFormulaTimes and arg0_38.curSelectCount - arg0_38.addDelegateFormulaTimes or arg0_38.curSelectCount
	local var1_38 = arg0_38.formulaCfg.stamina_cost * var0_38

	if arg0_38.selectedShipId == 1 then
		var1_38 = 0
	else
		arg0_38.animationPlayer:Play("anim_IslandFormulaSelectNewUI_bar_Loop")
	end

	setText(arg0_38.addExp, "EXP+" .. arg0_38.formulaCfg.ship_exp * var0_38)

	if arg0_38.eneryTimer then
		arg0_38.eneryTimer:Stop()
	end

	arg0_38.eneryTimer = Timer.New(function()
		local var0_39 = arg0_38.selectedShip:GetCurrentEnergy()
		local var1_39 = arg0_38.selectedShip:GetMaxEnergy()

		setSlider(arg0_38.energyBarTf, 0, 1, (var0_39 - var1_38) / var1_39)
		setSlider(arg0_38.energyBarUseTf, 0, 1, var0_39 / var1_39)
		setText(arg0_38.energy_countTf, string.format("%d-<color=#f7c35f>%d</color>/%d", var0_39, var1_38, var1_39))
	end, 1, -1)

	arg0_38.eneryTimer:Start()
	arg0_38.eneryTimer.func()
end

function var0_0.InitUnlockedFormulaList(arg0_40)
	arg0_40.formulaList = {}
	arg0_40.formulaToActivityDic = {}

	if arg0_40.addDelegateFormula then
		table.insert(arg0_40.formulaList, arg0_40.addDelegateFormula)

		return
	end

	local var0_40 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_40, iter1_40 in ipairs(pg.island_production_slot[arg0_40.slotId].activity_formula or {}) do
		local var1_40 = iter1_40[1]
		local var2_40 = iter1_40[2]
		local var3_40 = getProxy(ActivityProxy):getActivityById(var1_40)

		if var3_40 and not var3_40:isEnd() then
			for iter2_40, iter3_40 in ipairs(var2_40 or {}) do
				if pg.island_formula[iter3_40].unlock_type == 0 or var0_40:IsUnlockFormuate(iter3_40) then
					table.insert(arg0_40.formulaList, iter3_40)

					arg0_40.formulaToActivityDic[iter3_40] = var1_40
				end
			end
		end
	end

	for iter4_40, iter5_40 in ipairs(pg.island_production_slot[arg0_40.slotId].formula or {}) do
		local var4_40 = pg.island_formula[iter5_40].unlock_type == 0
		local var5_40 = pg.island_formula[iter5_40].unlock_type == -1
		local var6_40 = true

		if var5_40 then
			local var7_40 = pg.island_combo[iter5_40].unlock_condition
			local var8_40 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()

			for iter6_40, iter7_40 in ipairs(var7_40) do
				local var9_40 = iter7_40[1]
				local var10_40 = iter7_40[2]

				if not var8_40[var9_40] or var10_40 > var8_40[var9_40] then
					var6_40 = false

					break
				end
			end
		end

		if var4_40 or var0_40:IsUnlockFormuate(iter5_40) or var5_40 and var6_40 then
			table.insert(arg0_40.formulaList, iter5_40)
		end
	end
end

function var0_0.RefreshCurSelectCount(arg0_41)
	local var0_41 = arg0_41.addDelegateFormulaTimes or arg0_41.curSelectCount

	setText(arg0_41.curCountTips, tostring(var0_41))

	local var1_41 = arg0_41.addDelegateFormulaTimes and arg0_41.curSelectCount - arg0_41.addDelegateFormulaTimes or 0

	setText(arg0_41.addCountTips, "+" .. var1_41)
	setSlider(arg0_41.curCountNumSlider, 1, arg0_41.productMaxTime, arg0_41.curSelectCount)
	arg0_41:RefreshExtraProduct()

	local var2_41 = "×" .. arg0_41.formulaCfg.commission_product[1][2]
	local var3_41 = arg0_41:GetAniExtraGainByConfigName("efficiency_gains_num")

	if var3_41 > 0 then
		var2_41 = string.format("×(%s<color=#7df39f>+%d</color>)", arg0_41.formulaCfg.commission_product[1][2], var3_41)
	end

	setText(arg0_41.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), var2_41 .. i18n("island_production_tip"))

	local var4_41, var5_41 = arg0_41:CacaluteProductTime()
	local var6_41 = 0

	for iter0_41, iter1_41 in ipairs(var4_41) do
		var6_41 = var6_41 + iter1_41
	end

	local var7_41 = var5_41 - var6_41
	local var8_41 = pg.TimeMgr.GetInstance():DescCDTime(var6_41)

	if var7_41 > 0 then
		var8_41 = string.format("%s(<color=#7df39f>-%s</color>)", var8_41, pg.TimeMgr.GetInstance():DescCDTime(var7_41))
	end

	setText(arg0_41.needTimeText, var8_41)
end

function var0_0.RefreshExtraProduct(arg0_42)
	local var0_42 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	if #arg0_42.formulaCfg.second_product == 0 or not var0_42:IsUnlcokSecondProduct(arg0_42.selectFormulaId) then
		setActive(arg0_42.extraProduct, false)

		return
	end

	setActive(arg0_42.extraProduct, true)

	local var1_42 = arg0_42.formulaCfg.second_product_display[1][1]
	local var2_42 = arg0_42.formulaCfg.second_product_display[1][2]
	local var3_42 = pg.island_item_data_template[var1_42]
	local var4_42 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var1_42
	})

	onButton(arg0_42, arg0_42.extraProductIcon, function()
		arg0_42:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var4_42
		})
	end)
	GetImageSpriteFromAtlasAsync("island/" .. var3_42.icon, "", arg0_42.extraProductIcon)

	local var5_42 = "×" .. var2_42
	local var6_42 = arg0_42:GetAniExtraGainByConfigName("efficiency_gains_bonus_num")

	if var6_42 > 0 then
		var5_42 = string.format("×(%s<color=#7df39f>+%d</color>)", var2_42, var6_42)
	end

	setText(arg0_42.extraProductNum, var5_42 .. i18n("island_production_tip"))
	setText(arg0_42.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), curCountStr)

	local var7_42 = pg.island_production_slot[arg0_42.slotId].place
	local var8_42 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var7_42):GetDelegationSlotData(arg0_42.slotId):GetFromulaTatalCount(arg0_42.formulaCfg.id)
	local var9_42 = arg0_42.formulaCfg.second_product[1]
	local var10_42 = (var8_42 + (arg0_42.canRewardTime or 0)) % var9_42
	local var11_42 = var10_42 + (arg0_42.addDelegateFormulaTimes and arg0_42.curSelectCount - arg0_42.addDelegateFormulaTimes or arg0_42.curSelectCount)
	local var12_42 = math.floor(var11_42 / var9_42)

	arg0_42.extraProcess = var11_42 % var9_42

	setText(arg0_42.extraProductName, var3_42.name .. "×" .. var12_42)

	if arg0_42.addDelegateFormulaTimes then
		setActive(arg0_42.extraProductAddnum, true)

		local var13_42 = arg0_42.curSelectCount - arg0_42.addDelegateFormulaTimes
		local var14_42 = math.floor((var10_42 + var13_42) / var9_42)

		setText(arg0_42.extraProductAddnum, "+" .. var14_42)
	else
		setActive(arg0_42.extraProductAddnum, false)
	end

	arg0_42.extraProductList:align(var9_42)
end

function var0_0.CacaluteProductTime(arg0_44)
	local var0_44 = arg0_44.addDelegateFormulaTimes and arg0_44.curSelectCount - arg0_44.addDelegateFormulaTimes or arg0_44.curSelectCount
	local var1_44 = pg.island_set.base_efficiency.key_value_int
	local var2_44 = math.ceil(arg0_44.formulaCfg.workload / var1_44)

	return IslandProductTimeHelper.CalculateTimeToProductFormula(arg0_44.selectedShipId, arg0_44.selectFormulaId, var0_44, arg0_44.placeId, arg0_44.slotId), var2_44 * var0_44
end

function var0_0.CheckInPlace(arg0_45, arg1_45, arg2_45)
	for iter0_45, iter1_45 in ipairs(arg2_45) do
		if iter1_45 == arg1_45 then
			return true
		end
	end

	return false
end

function var0_0.GetAttrGrade(arg0_46, arg1_46)
	local var0_46 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_46, iter1_46 in ipairs(pg.island_chara_att.all) do
		local var1_46 = pg.island_chara_att[iter1_46]
		local var2_46 = var1_46.range[1]
		local var3_46 = var1_46.range[2]

		if var2_46 <= arg1_46 and arg1_46 <= var3_46 then
			var0_46 = iter1_46

			break
		end
	end

	return var0_46
end

function var0_0.GetAttrGrowingValueByBuff(arg0_47, arg1_47, arg2_47)
	for iter0_47, iter1_47 in ipairs(arg2_47) do
		if iter1_47[1] == arg1_47 then
			return iter1_47[2]
		end
	end

	return 0
end

function var0_0.OnHide(arg0_48)
	arg0_48:UnBlurPanel()

	if arg0_48.eneryTimer then
		arg0_48.eneryTimer:Stop()
	end
end

function var0_0.OnDisable(arg0_49)
	arg0_49:OnHide()
end

function var0_0.OnDestroy(arg0_50)
	arg0_50:OnHide()
end

function var0_0.Show(arg0_51, ...)
	arg0_51:AddListeners()
	arg0_51.islandUIController:Show(true)
	arg0_51:OnShow(...)
end

function var0_0.Hide(arg0_52, arg1_52, arg2_52)
	local var0_52 = defaultValue(arg1_52, true)

	local function var1_52()
		arg0_52:ClosePage(arg0_52)
		arg0_52:RemoveListeners()
		arg0_52:OnHide()

		if not arg2_52 then
			arg0_52:OnExit()
		end
	end

	if var0_52 then
		arg0_52.islandUIController:Hide(true, var1_52)
	else
		var1_52()
	end
end

return var0_0
