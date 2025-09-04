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

		arg0_2:RefreshCost()
	end)
	setText(arg0_2:findTF("top/title/Text"), i18n("island_select_product"))

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
	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
end

function var0_0.AddListeners(arg0_4)
	return
end

function var0_0.RemoveListeners(arg0_5)
	return
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6.dftAniEvent:SetEndEvent(nil)
		arg0_6.dftAniEvent:SetEndEvent(function()
			arg0_6.dftAniEvent:SetEndEvent(nil)
			arg0_6:Hide()
			arg0_6.cancelFunc()
		end)
		arg0_6.animationPlayer:Play("anim_IslandFormulaSelectNewUI_Out")
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.reduceBtn, function()
		arg0_6.curSelectCount = arg0_6.curSelectCount - 1
		arg0_6.curSelectCount = arg0_6.curSelectCount < 1 and 1 or arg0_6.curSelectCount

		arg0_6:RefreshCost()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.addBtn, function()
		arg0_6.curSelectCount = arg0_6.curSelectCount + 1
		arg0_6.curSelectCount = arg0_6.curSelectCount > var2_0 and var2_0 or arg0_6.curSelectCount

		arg0_6:RefreshCost()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.maxBtn, function()
		arg0_6.curSelectCount = var2_0

		arg0_6:RefreshCost()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.skillTf, function()
		arg0_6:ShowMsgBox({
			type = IslandMsgBox.TYPE_SHIP_SKILL,
			skill = arg0_6.selectedShip:GetSkill()
		})
	end, SFX_PANEL)
	arg0_6.uiList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventInit then
			arg0_6:InitFormulaItem(arg1_13, arg2_13)
		elseif arg0_13 == UIItemList.EventUpdate then
			arg0_6:UpdateFormulaItem(arg1_13, arg2_13)
		end
	end)
	arg0_6.costuiList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventInit then
			arg0_6:InitCostItem(arg1_14, arg2_14)
		elseif arg0_14 == UIItemList.EventUpdate then
			arg0_6:UpdateCostItem(arg1_14, arg2_14)
		end
	end)
	arg0_6.extraProductList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventInit then
			-- block empty
		elseif arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg1_15 < arg0_6.extraProcess

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
	arg0_18.curSelectCount = 1
	arg0_18.selectedIdx = arg1_18

	arg0_18.uiList:align(#arg0_18.formulaList)
end

function var0_0.UpdateFormulaItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19 + 1
	local var1_19 = arg0_19.formulaList[arg1_19 + 1]
	local var2_19 = pg.island_formula[var1_19]
	local var3_19 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var4_19 = var2_19.item_id
	local var5_19 = var3_19:GetItemById(var4_19)
	local var6_19 = var5_19 and var5_19:GetCount() or 0

	updateCustomDrop(arg2_19, Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = var4_19,
		count = var6_19
	}))
	setActive(arg0_19:findTF("icon_bg/count_bg", arg2_19), true)
	setText(arg0_19:findTF("name", arg2_19), var2_19.name)
	setText(arg0_19:findTF("icon_bg/product_count_bg/product_count", arg2_19), "×" .. var2_19.commission_product[1][2])

	if arg0_19.selectedIdx == var0_19 then
		arg0_19:RefreshCurrentSelect()
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

function var0_0.RefreshCurrentSelect(arg0_22)
	local var0_22 = arg0_22.formulaList[arg0_22.selectedIdx]
	local var1_22 = pg.island_formula[var0_22].item_id
	local var2_22 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var1_22
	})
	local var3_22 = var2_22:getConfigTable().rarity
	local var4_22 = IslandItemRarity.Rarity2FrameName(var3_22)
	local var5_22 = var2_22:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/islandframe", var4_22, arg0_22.currentformulaIcon:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync("island/" .. var5_22, "", arg0_22.currentformulaIcon:Find("icon_bg/icon"))
	arg0_22:RefreshCost()
end

function var0_0.RefreshCost(arg0_23)
	local var0_23 = arg0_23.formulaList[arg0_23.selectedIdx]
	local var1_23 = pg.island_formula[var0_23]

	arg0_23.commission_Cost_List = {}

	local var2_23 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_23, iter1_23 in ipairs(var1_23.commission_cost) do
		local var3_23 = iter1_23[1]
		local var4_23 = var2_23:GetItemById(var3_23)
		local var5_23 = var4_23 and var4_23:GetCount() or 0
		local var6_23 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_23[1],
			itemCount = var5_23,
			costCount = iter1_23[2] * arg0_23.curSelectCount
		})

		table.insert(arg0_23.commission_Cost_List, var6_23)
	end

	arg0_23.costuiList:align(#arg0_23.commission_Cost_List)
	arg0_23:RefreshCurSelectCount()
	arg0_23:RefreshShipEnergy()
	arg0_23:RefreshCanStart()
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

	local var1_24 = arg0_24.formulaList[arg0_24.selectedIdx]
	local var2_24 = pg.island_formula[var1_24]

	local function var3_24()
		if var2_24.stamina_cost * arg0_24.curSelectCount > arg0_24.selectedShip:GetCurrentEnergy() then
			return false
		end

		return true
	end

	local function var4_24()
		local var0_27 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_24.place_Id)
		local var1_27 = pg.island_production_slot[arg0_24.logicCommissionId]
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

	if var0_24() and var3_24() then
		setActive(arg0_24.enoughSureBg, true)
		setActive(arg0_24.notenoughSureBg, false)
		onButton(arg0_24, arg0_24.sureBtn, function()
			local var0_28, var1_28 = var4_24()

			if var0_28 then
				arg0_24:ShowMsgBox({
					content = "当前委派槽位占用的手动种植槽位正在种植中,是否中断手动种植",
					type = IslandMsgBox.TYPE_COMMON,
					onYes = function()
						pg.m02:sendNotification(GAME.ISLAND_STOP_HANDLE_PLANT_HALFWAY, {
							build_id = arg0_24.place_Id,
							slot_list = var1_28
						})
					end,
					onNo = function()
						return
					end
				})

				return
			end

			local var2_28 = arg0_24.formulaList[arg0_24.selectedIdx]

			arg0_24:emit(IslandMediator.START_DELEGATION, arg0_24.place_Id, arg0_24.logicCommissionId, arg0_24.selectedShipId, var2_28, arg0_24.curSelectCount)
			arg0_24:Hide()
		end, SFX_PANEL)
	else
		setActive(arg0_24.enoughSureBg, false)
		setActive(arg0_24.notenoughSureBg, true)
		onButton(arg0_24, arg0_24.sureBtn, function()
			pg.TipsMgr.GetInstance():ShowTips("消耗不够")
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_32, arg1_32, arg2_32, arg3_32, arg4_32)
	arg0_32.cancelFunc = arg4_32
	arg0_32.place_Id = arg2_32
	arg0_32.selectedShipId = arg3_32
	arg0_32.selectedShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_32.selectedShipId)
	arg0_32.currentCommissionId = arg1_32
	arg0_32.logicCommissionId = pg.island_production_commission[arg0_32.currentCommissionId].slot

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
	local var2_33 = var1_33:IsEffectiveInPlace(arg0_33.place_Id)

	setActive(arg0_33.skillInUse, var2_33)
	setActive(arg0_33.skillUnUse, not var2_33)
	setActive(arg0_33.skillUnUse, not var2_33)

	arg0_33.skillName.text = string.format("%s - %s", var1_33:GetName(), "[Lv." .. var1_33:GetLevel() .. "]")
end

function var0_0.RefreshShipEnergy(arg0_34)
	local var0_34 = arg0_34.formulaList[arg0_34.selectedIdx]
	local var1_34 = pg.island_formula[var0_34].stamina_cost * arg0_34.curSelectCount

	if arg0_34.selectedShipId == 1 then
		var1_34 = 0
	else
		arg0_34.dftAniEvent:SetEndEvent(nil)
		arg0_34.dftAniEvent:SetEndEvent(function()
			arg0_34.dftAniEvent:SetEndEvent(nil)
			arg0_34.animationPlayer:Play("anim_IslandFormulaSelectNewUI_bar_Loop")
		end)
	end

	local var2_34 = arg0_34.selectedShip:GetCurrentEnergy()
	local var3_34 = arg0_34.selectedShip:GetMaxEnergy()

	setSlider(arg0_34.energyBarTf, 0, 1, (var2_34 - var1_34) / var3_34)
	setSlider(arg0_34.energyBarUseTf, 0, 1, var2_34 / var3_34)
	setText(arg0_34.energy_countTf, string.format("%d-<color=#f7c35f>%d</color>/%d", var2_34, var1_34, var3_34))
end

function var0_0.InitUnlockedFormulaList(arg0_36)
	arg0_36.formulaList = {}

	for iter0_36, iter1_36 in ipairs(pg.island_production_slot[arg0_36.logicCommissionId].formula or {}) do
		local var0_36 = getProxy(IslandProxy):GetIsland():GetAblityAgency()
		local var1_36 = pg.island_formula[iter1_36].unlock_type == 0
		local var2_36 = pg.island_formula[iter1_36].unlock_type == -1
		local var3_36 = true

		if var2_36 then
			local var4_36 = pg.island_combo[iter1_36].unlock_condition
			local var5_36 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()

			for iter2_36, iter3_36 in ipairs(var4_36) do
				local var6_36 = iter3_36[1]
				local var7_36 = iter3_36[2]

				if not var5_36[var6_36] or var7_36 > var5_36[var6_36] then
					var3_36 = false

					break
				end
			end
		end

		if var1_36 or var0_36:IsUnlockFormuate(iter1_36) or var2_36 and var3_36 then
			table.insert(arg0_36.formulaList, iter1_36)
		end
	end
end

function var0_0.RefreshCurSelectCount(arg0_37)
	setText(arg0_37.curCountTips, tostring(arg0_37.curSelectCount))
	setSlider(arg0_37.curCountNumSlider, 1, var2_0, arg0_37.curSelectCount)
	arg0_37:RefreshExtraProduct()

	local var0_37 = arg0_37.formulaList[arg0_37.selectedIdx]
	local var1_37 = pg.island_formula[var0_37]

	setText(arg0_37.currentformulaIcon:Find("icon_bg/product_count_bg/product_count"), "×" .. var1_37.commission_product[1][2] * arg0_37.curSelectCount)

	local var2_37 = arg0_37:CacaluteProductTime()
	local var3_37 = 0

	for iter0_37, iter1_37 in ipairs(var2_37) do
		var3_37 = var3_37 + iter1_37
	end

	setText(arg0_37.needTimeText, pg.TimeMgr.GetInstance():DescCDTime(var3_37))
end

function var0_0.RefreshExtraProduct(arg0_38)
	local var0_38 = getProxy(IslandProxy):GetIsland():GetAblityAgency()
	local var1_38 = arg0_38.formulaList[arg0_38.selectedIdx]
	local var2_38 = pg.island_formula[var1_38]

	if #var2_38.second_product == 0 or not var0_38:IsUnlcokSecondProduct(var1_38) then
		setActive(arg0_38.extraProduct, false)

		return
	end

	setActive(arg0_38.extraProduct, true)

	local var3_38 = var2_38.second_product[2][2]
	local var4_38 = pg.island_item_data_template[var3_38]

	GetImageSpriteFromAtlasAsync("island/" .. var4_38.icon, "", arg0_38.extraProductIcon)

	local var5_38 = pg.island_production_slot[arg0_38.logicCommissionId].place
	local var6_38 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var5_38):GetDelegationSlotData(arg0_38.logicCommissionId):GetFromulaTatalCount(var2_38.id)
	local var7_38 = var2_38.second_product[1]
	local var8_38 = math.floor((var6_38 + arg0_38.curSelectCount) / var7_38)

	arg0_38.extraProcess = (var6_38 + arg0_38.curSelectCount) % var7_38

	setText(arg0_38.extraProductName, i18n("island_sub_product_cnt", var8_38))
	arg0_38.extraProductList:align(var7_38)
end

function var0_0.CacaluteProductTime(arg0_39)
	local var0_39 = arg0_39.formulaList[arg0_39.selectedIdx]

	return IslandProductTimeHelper.CalculateTimeToProductFormula(arg0_39.selectedShipId, var0_39, arg0_39.curSelectCount, arg0_39.place_Id)
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

function var0_0.OnDestroy(arg0_43)
	arg0_43.dftAniEvent:SetEndEvent(nil)
end

return var0_0
