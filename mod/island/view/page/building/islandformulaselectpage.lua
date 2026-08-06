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
	arg0_3:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_3.RefreshCurrentSelectFormula)
end

function var0_0.RemoveListeners(arg0_4)
	arg0_4:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_4.RefreshCurrentSelectFormula)
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
	onButton(arg0_21, arg2_21:Find("icon_bg/icon"), function()
		arg0_21:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var0_21
		})
	end)
end

function var0_0.RefreshCurrentSelectFormula(arg0_24)
	local var0_24 = arg0_24.formulaCfg.item_id
	local var1_24 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var0_24
	})
	local var2_24 = var1_24:getConfigTable().rarity
	local var3_24 = IslandItemRarity.Rarity2FrameName(var2_24)
	local var4_24 = var1_24:getConfigTable().icon

	onButton(arg0_24, arg0_24.currentformulaIcon, function()
		arg0_24:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var1_24
		})
	end)
	GetImageSpriteFromAtlasAsync("island/islandframe", var3_24, arg0_24.currentformulaIcon:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync("island/" .. var4_24, "", arg0_24.currentformulaIcon:Find("icon_bg/icon"))
	arg0_24:RefreshCost()
end

function var0_0.GetAniExtraGainByConfigName(arg0_26, arg1_26)
	local var0_26 = 0

	if arg0_26.placeId ~= IslandProductConst.PasturePlaceId then
		return var0_26
	end

	local var1_26 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_26.placeId):GetDelegationSlotData(arg0_26.slotId):GetPartList()

	for iter0_26, iter1_26 in ipairs(var1_26) do
		var0_26 = var0_26 + pg.island_ranch_animal[iter1_26][arg1_26]
	end

	return var0_26
end

function var0_0.RefreshCost(arg0_27)
	arg0_27.commission_Cost_List = {}

	local var0_27 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_27 = arg0_27:GetAniExtraGainByConfigName("efficiency_cost")

	for iter0_27, iter1_27 in ipairs(arg0_27.formulaCfg.commission_cost) do
		local var2_27 = iter1_27[1]
		local var3_27 = var0_27:GetItemById(var2_27)
		local var4_27 = var3_27 and var3_27:GetCount() or 0
		local var5_27 = arg0_27.addDelegateFormulaTimes and arg0_27.curSelectCount - arg0_27.addDelegateFormulaTimes or arg0_27.curSelectCount
		local var6_27 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_27[1],
			itemCount = var4_27,
			costCount = iter1_27[2] * var5_27,
			extraCostCount = var1_27 * var5_27
		})

		table.insert(arg0_27.commission_Cost_List, var6_27)
	end

	arg0_27.costuiList:align(#arg0_27.commission_Cost_List)
	arg0_27:RefreshCurSelectCount()
	arg0_27:RefreshShipEnergy()
	arg0_27:RefreshCanStart()
end

function var0_0.CheckCanAddMaxTimes(arg0_28)
	arg0_28.commission_Cost_List = {}

	local var0_28 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_28 = arg0_28.productMaxTime
	local var2_28 = arg0_28:GetAniExtraGainByConfigName("efficiency_cost")

	for iter0_28, iter1_28 in ipairs(arg0_28.formulaCfg.commission_cost) do
		local var3_28 = iter1_28[1]
		local var4_28 = var0_28:GetItemById(var3_28)
		local var5_28 = var4_28 and var4_28:GetCount() or 0
		local var6_28 = iter1_28[2] + var2_28

		var1_28 = math.min(var1_28, math.floor(var5_28 / var6_28))
	end

	local var7_28 = arg0_28:GetOneFormulaEnergyCost()

	return (math.min(math.floor(arg0_28.selectedShip:GetCurrentEnergy() / var7_28), var1_28))
end

function var0_0.RefreshCanStart(arg0_29)
	local function var0_29()
		for iter0_30, iter1_30 in ipairs(arg0_29.commission_Cost_List) do
			if iter1_30.costCount + iter1_30.extraCostCount > iter1_30.itemCount then
				return false
			end
		end

		return true
	end

	local function var1_29()
		local var0_31 = arg0_29.addDelegateFormulaTimes and arg0_29.curSelectCount - arg0_29.addDelegateFormulaTimes or arg0_29.curSelectCount

		if arg0_29:GetOneFormulaEnergyCost() * var0_31 > arg0_29.selectedShip:GetCurrentEnergy() then
			return false
		end

		return true
	end

	local function var2_29()
		local var0_32 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_29.placeId)
		local var1_32 = pg.island_production_slot[arg0_29.slotId]
		local var2_32 = var1_32.exclusion_slot == "" and {} or var1_32.exclusion_slot
		local var3_32 = {}
		local var4_32 = false

		for iter0_32, iter1_32 in ipairs(var2_32) do
			if var0_32:GetHandPlantSlotData(iter1_32).state == 1 then
				var4_32 = true

				table.insert(var3_32, iter1_32)
			end
		end

		return var4_32, var3_32
	end

	if var0_29() and var1_29() then
		setActive(arg0_29.enoughSureBg, true)
		setActive(arg0_29.notenoughSureBg, false)
		onButton(arg0_29, arg0_29.sureBtn, function()
			if arg0_29.addDelegateFormula then
				arg0_29.placeId = pg.island_production_slot[arg0_29.slotId].place

				local var0_33 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_29.placeId):GetDelegationSlotData(arg0_29.slotId)

				if var0_33 and not var0_33:GetSlotRoleData() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_additional_production_tip2"))

					return
				end
			end

			local var1_33 = arg0_29.formulaToActivityDic[arg0_29.selectFormulaId]

			if var1_33 then
				local var2_33 = getProxy(ActivityProxy):getActivityById(var1_33)

				if not var2_33 or var2_33:isEnd() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_activity_expired"))

					return
				end
			end

			local var3_33, var4_33 = var2_29()

			if var3_33 then
				arg0_29:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_production_manually_cancel"),
					onYes = function()
						pg.m02:sendNotification(GAME.ISLAND_STOP_HANDLE_PLANT_HALFWAY, {
							build_id = arg0_29.placeId,
							slot_list = var4_33
						})
						existCall(arg0_29.unLoadCharacterFunc)

						local var0_34 = arg0_29:GetAniExtraGainByConfigName("efficiency_cost")

						if arg0_29.addDelegateFormula then
							local var1_34 = arg0_29.curSelectCount - arg0_29.addDelegateFormulaTimes

							arg0_29:emit(IslandMediator.ADD_DELEGATION, arg0_29.placeId, arg0_29.slotId, var1_34, var0_34)
						else
							arg0_29:emit(IslandMediator.START_DELEGATION, arg0_29.placeId, arg0_29.slotId, arg0_29.selectedShipId, arg0_29.selectFormulaId, arg0_29.curSelectCount, var0_34)
						end

						existCall(arg0_29.confirmFunc)
						arg0_29:Hide()
					end,
					onNo = function()
						return
					end
				})

				return
			end

			existCall(arg0_29.unLoadCharacterFunc)

			local var5_33 = arg0_29:GetAniExtraGainByConfigName("efficiency_cost")

			if arg0_29.addDelegateFormula then
				local var6_33 = arg0_29.curSelectCount - arg0_29.addDelegateFormulaTimes

				arg0_29:emit(IslandMediator.ADD_DELEGATION, arg0_29.placeId, arg0_29.slotId, var6_33, var5_33)
			else
				arg0_29:emit(IslandMediator.START_DELEGATION, arg0_29.placeId, arg0_29.slotId, arg0_29.selectedShipId, arg0_29.selectFormulaId, arg0_29.curSelectCount, var5_33)
			end

			existCall(arg0_29.confirmFunc)
			arg0_29:Hide()
		end, SFX_PANEL)
	else
		setActive(arg0_29.enoughSureBg, false)
		setActive(arg0_29.notenoughSureBg, true)
		onButton(arg0_29, arg0_29.sureBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_cost_notenough"))
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_37, arg1_37)
	arg0_37:BlurPanel()

	arg0_37.commissionId = arg1_37.commissionId
	arg0_37.selectedShipId = arg1_37.selectedShipId
	arg0_37.cancelFunc = arg1_37.cancelFunc
	arg0_37.confirmFunc = arg1_37.confirmFunc
	arg0_37.unLoadCharacterFunc = arg1_37.unLoadCharacterFunc
	arg0_37.addDelegateFormula = arg1_37.addDelegateFormula
	arg0_37.addDelegateFormulaTimes = arg1_37.addDelegateFormulaTimes
	arg0_37.canRewardTime = arg1_37.canRewardTime
	arg0_37.selectFormulaId = arg1_37.selectFormulaId

	setActive(arg0_37.addExpTF, arg0_37.selectedShipId ~= 1)

	if arg0_37.addDelegateFormulaTimes then
		setActive(arg0_37.barLimit, true)

		local var0_37 = pg.island_formula[arg0_37.addDelegateFormula].production_limit or 5
		local var1_37 = arg0_37.addDelegateFormulaTimes / var0_37 * 352.6

		arg0_37.barLimit.sizeDelta = Vector2(var1_37, 22)

		setActive(arg0_37.addCountTips, true)
	else
		setActive(arg0_37.barLimit, false)
		setActive(arg0_37.addCountTips, false)
	end

	local var2_37 = arg0_37.addDelegateFormulaTimes and i18n("island_additional_production_tip1") or i18n("island_production_start")

	setText(arg0_37.sureBtn:Find("adapt/time/Text"), var2_37)

	arg0_37.slotId = pg.island_production_commission[arg0_37.commissionId].slot
	arg0_37.placeId = pg.island_production_slot[arg0_37.slotId].place
	arg0_37.selectedShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_37.selectedShipId)

	arg0_37:InitUnlockedFormulaList()

	if #arg0_37.formulaList > 0 then
		local var3_37 = 1

		if arg0_37.selectFormulaId then
			for iter0_37, iter1_37 in ipairs(arg0_37.formulaList) do
				if iter1_37 == arg0_37.selectFormulaId then
					var3_37 = iter0_37

					break
				end
			end
		end

		arg0_37:OnSelectFormulaIndex(var3_37)
		onNextTick(function()
			local var0_38 = arg0_37._tf:Find("formulaView/content")
			local var1_38 = var0_38.sizeDelta.y
			local var2_38 = arg0_37._tf:Find("formulaView/content/tpl").rect.height
			local var3_38 = math.min((var3_37 - 1) * var2_38, var1_38)

			setAnchoredPosition(var0_38, {
				y = var3_38
			})
		end)
	else
		arg0_37.uiList:align(#arg0_37.formulaList)
		setActive(arg0_37.rightInfo, false)
		setActive(arg0_37.rightInfoEmpty, true)
	end

	arg0_37:RefreshShip()
end

function var0_0.RefreshShip(arg0_39)
	local var0_39 = IslandShip.StaticGetPrefab(arg0_39.selectedShipId)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_39, "", arg0_39.selectShipIcon)
	setText(arg0_39.selectShipName, arg0_39.selectedShip:GetName())
	setText(arg0_39.selectShipLv, string.format("-Lv.%d", arg0_39.selectedShip:GetLevel()))

	local var1_39 = arg0_39.selectedShip:GetSkill()
	local var2_39 = var1_39:IsEffectiveInPlace(arg0_39.placeId)

	setActive(arg0_39.skillInUse, var2_39)
	setActive(arg0_39.skillUnUse, not var2_39)
	setActive(arg0_39.skillUnUse, not var2_39)

	arg0_39.skillName.text = string.format("%s - %s", var1_39:GetName(), "Lv." .. var1_39:GetLevel() .. "")
end

function var0_0.RefreshShipEnergy(arg0_40)
	local var0_40 = arg0_40.addDelegateFormulaTimes and arg0_40.curSelectCount - arg0_40.addDelegateFormulaTimes or arg0_40.curSelectCount
	local var1_40 = arg0_40:GetOneFormulaEnergyCost() * var0_40

	if arg0_40.selectedShipId == 1 then
		var1_40 = 0
	else
		arg0_40.animationPlayer:Play("anim_IslandFormulaSelectNewUI_bar_Loop")
	end

	setText(arg0_40.addExp, "EXP+" .. arg0_40.formulaCfg.ship_exp * var0_40)

	if arg0_40.eneryTimer then
		arg0_40.eneryTimer:Stop()
	end

	arg0_40.eneryTimer = Timer.New(function()
		local var0_41 = arg0_40.selectedShip:GetCurrentEnergy()
		local var1_41 = arg0_40.selectedShip:GetMaxEnergy()

		setSlider(arg0_40.energyBarTf, 0, 1, (var0_41 - var1_40) / var1_41)
		setSlider(arg0_40.energyBarUseTf, 0, 1, var0_41 / var1_41)
		setText(arg0_40.energy_countTf, string.format("%d-<color=#f7c35f>%d</color>/%d", var0_41, var1_40, var1_41))
	end, 1, -1)

	arg0_40.eneryTimer:Start()
	arg0_40.eneryTimer.func()
end

function var0_0.InitUnlockedFormulaList(arg0_42)
	arg0_42.formulaList = {}
	arg0_42.formulaToActivityDic = {}

	if arg0_42.addDelegateFormula then
		table.insert(arg0_42.formulaList, arg0_42.addDelegateFormula)

		return
	end

	local var0_42 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_42, iter1_42 in ipairs(pg.island_production_slot[arg0_42.slotId].activity_formula or {}) do
		local var1_42 = iter1_42[1]
		local var2_42 = iter1_42[2]
		local var3_42 = getProxy(ActivityProxy):getActivityById(var1_42)

		if var3_42 and not var3_42:isEnd() then
			for iter2_42, iter3_42 in ipairs(var2_42 or {}) do
				if pg.island_formula[iter3_42].unlock_type == 0 or var0_42:IsUnlockFormuate(iter3_42) then
					table.insert(arg0_42.formulaList, iter3_42)

					arg0_42.formulaToActivityDic[iter3_42] = var1_42
				end
			end
		end
	end

	for iter4_42, iter5_42 in ipairs(pg.island_production_slot[arg0_42.slotId].formula or {}) do
		local var4_42 = pg.island_formula[iter5_42].unlock_type == 0
		local var5_42 = pg.island_formula[iter5_42].unlock_type == -1
		local var6_42 = true

		if var5_42 then
			local var7_42 = pg.island_combo[iter5_42].unlock_condition
			local var8_42 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()

			for iter6_42, iter7_42 in ipairs(var7_42) do
				local var9_42 = iter7_42[1]
				local var10_42 = iter7_42[2]

				if not var8_42[var9_42] or var10_42 > var8_42[var9_42] then
					var6_42 = false

					break
				end
			end
		end

		if var4_42 or var0_42:IsUnlockFormuate(iter5_42) or var5_42 and var6_42 then
			table.insert(arg0_42.formulaList, iter5_42)
		end
	end
end

function var0_0.RefreshCurSelectCount(arg0_43)
	local var0_43 = arg0_43.addDelegateFormulaTimes or arg0_43.curSelectCount

	setText(arg0_43.curCountTips, tostring(var0_43))

	local var1_43 = arg0_43.addDelegateFormulaTimes and arg0_43.curSelectCount - arg0_43.addDelegateFormulaTimes or 0

	setText(arg0_43.addCountTips, "+" .. var1_43)
	setSlider(arg0_43.curCountNumSlider, 1, arg0_43.productMaxTime, arg0_43.curSelectCount)
	arg0_43:RefreshExtraProduct()

	local var2_43 = "×" .. arg0_43.formulaCfg.commission_product[1][2]
	local var3_43 = arg0_43:GetAniExtraGainByConfigName("efficiency_gains_num")

	if var3_43 > 0 then
		var2_43 = string.format("×(%s<color=#7df39f>+%d</color>)", arg0_43.formulaCfg.commission_product[1][2], var3_43)
	end

	setText(arg0_43.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), var2_43 .. i18n("island_production_tip"))

	local var4_43, var5_43 = arg0_43:CacaluteProductTime()
	local var6_43 = 0

	for iter0_43, iter1_43 in ipairs(var4_43) do
		var6_43 = var6_43 + iter1_43
	end

	local var7_43 = var5_43 - var6_43
	local var8_43 = pg.TimeMgr.GetInstance():DescCDTime(var6_43)

	if var7_43 > 0 then
		var8_43 = string.format("%s(<color=#7df39f>-%s</color>)", var8_43, pg.TimeMgr.GetInstance():DescCDTime(var7_43))
	end

	setText(arg0_43.needTimeText, var8_43)
end

function var0_0.RefreshExtraProduct(arg0_44)
	local var0_44 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	if #arg0_44.formulaCfg.second_product == 0 or not var0_44:IsUnlcokSecondProduct(arg0_44.selectFormulaId) then
		setActive(arg0_44.extraProduct, false)

		return
	end

	setActive(arg0_44.extraProduct, true)

	local var1_44 = arg0_44.formulaCfg.second_product_display[1][1]
	local var2_44 = arg0_44.formulaCfg.second_product_display[1][2]
	local var3_44 = pg.island_item_data_template[var1_44]
	local var4_44 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var1_44
	})

	onButton(arg0_44, arg0_44.extraProductIcon, function()
		arg0_44:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var4_44
		})
	end)
	GetImageSpriteFromAtlasAsync("island/" .. var3_44.icon, "", arg0_44.extraProductIcon)

	local var5_44 = "×" .. var2_44
	local var6_44 = arg0_44:GetAniExtraGainByConfigName("efficiency_gains_bonus_num")

	if var6_44 > 0 then
		var5_44 = string.format("×(%s<color=#7df39f>+%d</color>)", var2_44, var6_44)
	end

	setText(arg0_44.extraProductNum, var5_44 .. i18n("island_production_tip"))

	local var7_44 = pg.island_production_slot[arg0_44.slotId].place
	local var8_44 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var7_44):GetDelegationSlotData(arg0_44.slotId):GetFromulaTatalCount(arg0_44.formulaCfg.id)
	local var9_44 = arg0_44.formulaCfg.second_product[1]
	local var10_44 = (var8_44 + (arg0_44.canRewardTime or 0)) % var9_44
	local var11_44 = var10_44 + (arg0_44.addDelegateFormulaTimes and arg0_44.curSelectCount - arg0_44.addDelegateFormulaTimes or arg0_44.curSelectCount)
	local var12_44 = math.floor(var11_44 / var9_44)

	arg0_44.extraProcess = var11_44 % var9_44

	setText(arg0_44.extraProductName, var3_44.name .. "×" .. var12_44)

	if arg0_44.addDelegateFormulaTimes then
		setActive(arg0_44.extraProductAddnum, true)

		local var13_44 = arg0_44.curSelectCount - arg0_44.addDelegateFormulaTimes
		local var14_44 = math.floor((var10_44 + var13_44) / var9_44)

		setText(arg0_44.extraProductAddnum, "+" .. var14_44)
	else
		setActive(arg0_44.extraProductAddnum, false)
	end

	arg0_44.extraProductList:align(var9_44)
end

function var0_0.CacaluteProductTime(arg0_46)
	local var0_46 = arg0_46.addDelegateFormulaTimes and arg0_46.curSelectCount - arg0_46.addDelegateFormulaTimes or arg0_46.curSelectCount
	local var1_46 = pg.island_set.base_efficiency.key_value_int
	local var2_46 = math.ceil(arg0_46.formulaCfg.workload / var1_46)

	return IslandProductTimeHelper.CalculateTimeToProductFormula(arg0_46.selectedShipId, arg0_46.selectFormulaId, var0_46, arg0_46.placeId, arg0_46.slotId), var2_46 * var0_46
end

function var0_0.CheckInPlace(arg0_47, arg1_47, arg2_47)
	for iter0_47, iter1_47 in ipairs(arg2_47) do
		if iter1_47 == arg1_47 then
			return true
		end
	end

	return false
end

function var0_0.GetAttrGrade(arg0_48, arg1_48)
	local var0_48 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_48, iter1_48 in ipairs(pg.island_chara_att.all) do
		local var1_48 = pg.island_chara_att[iter1_48]
		local var2_48 = var1_48.range[1]
		local var3_48 = var1_48.range[2]

		if var2_48 <= arg1_48 and arg1_48 <= var3_48 then
			var0_48 = iter1_48

			break
		end
	end

	return var0_48
end

function var0_0.GetAttrGrowingValueByBuff(arg0_49, arg1_49, arg2_49)
	for iter0_49, iter1_49 in ipairs(arg2_49) do
		if iter1_49[1] == arg1_49 then
			return iter1_49[2]
		end
	end

	return 0
end

function var0_0.GetOneFormulaEnergyCost(arg0_50)
	local var0_50 = math.floor(arg0_50.formulaCfg.stamina_cost * (1 - IslandProductCostHelper.GetReducePercentInPlace(arg0_50.selectedShipId, arg0_50.placeId)))

	return (math.max(var0_50, 1))
end

function var0_0.OnHide(arg0_51)
	arg0_51:UnBlurPanel()

	if arg0_51.eneryTimer then
		arg0_51.eneryTimer:Stop()
	end
end

function var0_0.OnDisable(arg0_52)
	arg0_52:OnHide()
end

function var0_0.OnDestroy(arg0_53)
	arg0_53:OnHide()
end

function var0_0.Show(arg0_54, ...)
	arg0_54:AddListeners()
	arg0_54.islandUIController:Show(true)
	arg0_54:OnShow(...)
end

function var0_0.Hide(arg0_55, arg1_55, arg2_55)
	local var0_55 = defaultValue(arg1_55, true)

	local function var1_55()
		arg0_55:ClosePage(arg0_55)
		arg0_55:RemoveListeners()
		arg0_55:OnHide()

		if not arg2_55 then
			arg0_55:OnExit()
		end
	end

	if var0_55 then
		arg0_55.islandUIController:Hide(true, var1_55)
	else
		var1_55()
	end
end

return var0_0
