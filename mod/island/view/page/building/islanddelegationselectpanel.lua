local var0_0 = class("IslandDelegationSelectPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandDelegationSelectPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2._tf:Find("close")
	arg0_2.layoutTF = arg0_2._tf:Find("layout")

	local var0_2 = arg0_2._tf:Find("layout/select_container/selectInfo")

	arg0_2.slotNameTF = var0_2:Find("slotName")
	arg0_2.unlockSlot = var0_2:Find("unlock")
	arg0_2.lockSlot = var0_2:Find("lock")
	arg0_2.emptyAddShipTF = arg0_2.unlockSlot:Find("empty")
	arg0_2.emptyBtn = arg0_2.unlockSlot:Find("emptyBtn")
	arg0_2.contentTF = arg0_2.unlockSlot:Find("content")
	arg0_2.processTF = arg0_2.contentTF:Find("process")
	arg0_2.selectShipTF = arg0_2.processTF:Find("ship/selectShip")
	arg0_2.selectShipBtn = arg0_2.selectShipTF:Find("selectShipButton")
	arg0_2.energySliderTF = arg0_2.selectShipTF:Find("energy/energy_bar")
	arg0_2.energyTFText = arg0_2.selectShipTF:Find("energy/Text")
	arg0_2.seletShipName = arg0_2.selectShipTF:Find("name")
	arg0_2.shipIconTF = arg0_2.selectShipTF:Find("icon_mask/icon")
	arg0_2.expGetTF = arg0_2.selectShipTF:Find("exp_get")

	setActive(arg0_2.expGetTF, false)

	arg0_2.selectFormulaBtn = arg0_2.processTF:Find("selectFormula")
	arg0_2.inprocessFormulaTF = arg0_2.processTF:Find("inprocess")
	arg0_2.inproduction = arg0_2.inprocessFormulaTF:Find("inproduction")
	arg0_2.speedupBtn = arg0_2.inproduction:Find("quick")
	arg0_2.timeTF = arg0_2.inproduction:Find("time/Text")
	arg0_2.roleDelegationSliderTF = arg0_2.inproduction:Find("time/time_bar")
	arg0_2.currentFormula = arg0_2.inprocessFormulaTF:Find("formulalayout/formula")
	arg0_2.currentFormulaIcon = arg0_2.currentFormula:Find("curformula")
	arg0_2.currentFormulaNum = arg0_2.currentFormulaIcon:Find("product_count_bg/product_count")
	arg0_2.currentFormulaLastNum = arg0_2.currentFormula:Find("tips_num")
	arg0_2.formulaProcess = arg0_2.currentFormula:Find("process"):GetComponent(typeof(Image))
	arg0_2.extraProduct = arg0_2.inprocessFormulaTF:Find("formulalayout/second_formula")
	arg0_2.extraProductIcon = arg0_2.extraProduct:Find("bg/icon")
	arg0_2.extraProductName = arg0_2.extraProduct:Find("name")
	arg0_2.extraProductNum = arg0_2.extraProductIcon:Find("product_count_bg/product_count")
	arg0_2.extraProductLastNum = arg0_2.extraProduct:Find("name/num")
	arg0_2.currentExtroFormula = arg0_2.inprocessFormulaTF:Find("formulalayout/second_formula")
	arg0_2.finishTF = arg0_2.contentTF:Find("finish")
	arg0_2.finishFurmalaIcon = arg0_2.finishTF:Find("formulalayout/formula/curformula")

	setText(arg0_2.finishTF:Find("formulalayout/formula/tips"), i18n("island_production_finish"))

	arg0_2.stopBtn = arg0_2.contentTF:Find("btns/stop")
	arg0_2.getBtn = arg0_2.contentTF:Find("btns/get")
	arg0_2.addBtn = arg0_2.contentTF:Find("btns/add")
	arg0_2.canRewardIcon = arg0_2.getBtn:Find("hasicon")
	arg0_2.canRewardNum = arg0_2.getBtn:Find("num")
	arg0_2.canExtraRewardIcon = arg0_2.getBtn:Find("extraIcon")
	arg0_2.canExtraRewardNum = arg0_2.getBtn:Find("extraNum")
	arg0_2.shipDetailsBtn = arg0_2.processTF:Find("ship/details")
	arg0_2.shipDetailsPanel = arg0_2._tf:Find("layout/ship_container")
	arg0_2.shipDetailBack = arg0_2.shipDetailsPanel:Find("back")
	arg0_2.shipSkillEmp = arg0_2.shipDetailsPanel:Find("skillEmp")
	arg0_2.shipSkillEmpDes = arg0_2.shipDetailsPanel:Find("skillEmp/Text")
	arg0_2.shipSkillDetails = arg0_2.shipDetailsPanel:Find("skill")
	arg0_2.shipDetailsIcon = arg0_2.shipSkillDetails:Find("icon")
	arg0_2.shipDetailsName = arg0_2.shipSkillDetails:Find("name"):GetComponent(typeof(Text))
	arg0_2.shipDetailsDes = arg0_2.shipSkillDetails:Find("desc/Text"):GetComponent(typeof(Text))

	setText(arg0_2.shipDetailsPanel:Find("title"), i18n("island_production_character_info"))
	setText(arg0_2.getBtn:Find("Text"), i18n("island_production_collect"))
	setText(arg0_2.addBtn:Find("num"), i18n("island_additional_production_tip1"))
	setText(arg0_2.currentFormula:Find("tips"), i18n("island_production_count"))
	arg0_2:ApplyDiff()

	arg0_2.extraProductList = UIItemList.New(arg0_2.extraProduct:Find("process"), arg0_2.extraProduct:Find("process/item"))
end

function var0_0.ApplyDiff(arg0_3)
	if arg0_3.contextData and arg0_3.contextData.isPermanent then
		setActive(arg0_3.closeBtn, false)
	end

	if arg0_3.contextData and arg0_3.contextData.alignRight then
		arg0_3.layoutTF.anchorMin = Vector2(1, 0.5)
		arg0_3.layoutTF.anchorMax = Vector2(1, 0.5)
		arg0_3.layoutTF.pivot = Vector2(1, 0.5)

		setAnchoredPosition(arg0_3.layoutTF, {
			x = -35,
			y = 0
		})
	end
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.closeBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.shipDetailsBtn, function()
		arg0_4:ShowDetailPanel()
	end)
	onButton(arg0_4, arg0_4.shipDetailBack, function()
		arg0_4:HideDetailPanel()
	end)
	onButton(arg0_4, arg0_4.emptyAddShipTF, function()
		arg0_4:OpenShipSelectPage()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.selectShipBtn, function()
		arg0_4:OpenShipSelectPage()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.selectFormulaBtn, function()
		arg0_4:OpenFormulaSelectPage()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.getBtn, function()
		local var0_11 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_4.placeId):GetDelegationSlotData(arg0_4.slotId)

		if not var0_11 then
			return
		end

		local var1_11 = not var0_11:GetSlotRoleData() and var0_11:GetSlotRewardData() and 2 or 1

		arg0_4:emit(IslandMediator.GET_DELEGATION_AWARD, arg0_4.placeId, arg0_4.slotId, var1_11, nil, arg0_4.contextData.isPost)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.stopBtn, function()
		arg0_4:emit(IslandMediator.STOP_DELEGATION, arg0_4.placeId, arg0_4.slotId)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.speedupBtn, function()
		arg0_4:emit(IslandMediator.OPEN_PAGE, "IslandTicketUsePage", {
			IslandUseTicketCommand.TYPES.APPOINT,
			arg0_4.slotId
		})
	end, SFX_PANEL)
	arg0_4.extraProductList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventInit then
			-- block empty
		elseif arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg1_14 < arg0_4.extraProcess

			setActive(arg2_14:Find("inprocess"), var0_14)
		end
	end)
end

function var0_0.ShowDetailPanel(arg0_15)
	setActive(arg0_15.shipDetailsPanel, true)

	local var0_15 = arg0_15.showShip:GetSkill()
	local var1_15 = var0_15:IsUnlock()

	setActive(arg0_15.shipSkillDetails, var1_15)
	setActive(arg0_15.shipSkillEmp, not var1_15)
	setText(arg0_15.shipSkillEmpDes, i18n("island_need_star", arg0_15.showShip:GetSkillUnlockLevel()))
	GetImageSpriteFromAtlasAsync("island/IslandSkillIcon/" .. var0_15:GetIcon(), "", arg0_15.shipDetailsIcon)

	arg0_15.shipDetailsName.text = string.format("%s - %s", var0_15:GetName(), "[Lv." .. var0_15:GetLevel() .. "]")
	arg0_15.shipDetailsDes.text = var0_15:GetEffectDesc()
end

function var0_0.HideDetailPanel(arg0_16)
	setActive(arg0_16.shipDetailsPanel, false)
end

function var0_0.Show(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	arg0_17.super.Show(arg0_17)

	arg0_17.loadCharacterFunc = arg3_17
	arg0_17.unLoadCharacterFunc = arg4_17
	arg0_17.selectedShipId = arg2_17
	arg0_17.commissionId = arg1_17 or arg0_17.commissionId
	arg0_17.slotId = pg.island_production_commission[arg0_17.commissionId].slot
	arg0_17.placeId = pg.island_production_slot[arg0_17.slotId].place

	if arg0_17.placeId == IslandProductConst.PasturePlaceId then
		IslandGuideChecker.CheckGuide("ISLAND_GUIDE_24")
	end

	arg0_17.timeMgr = pg.TimeMgr.GetInstance()

	arg0_17:HideDetailPanel()
	arg0_17:Flush()
end

function var0_0.Flush(arg0_18)
	arg0_18:FlushInfos()
	arg0_18:StopTimer()
	arg0_18:StartTimer()
end

function var0_0.FlushInfos(arg0_19)
	arg0_19.slotData = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_19.placeId):GetDelegationSlotData(arg0_19.slotId)

	local var0_19 = pg.island_production_place[arg0_19.placeId].name

	setText(arg0_19.slotNameTF, var0_19 .. "-" .. pg.island_production_commission[arg0_19.commissionId].name)
	setActive(arg0_19.lockSlot, not arg0_19.slotData)
	setActive(arg0_19.unlockSlot, arg0_19.slotData)
	setActive(arg0_19.addBtn, false)
	setActive(arg0_19.canExtraRewardIcon, false)
	setActive(arg0_19.canExtraRewardNum, false)

	if not arg0_19.slotData then
		return
	end

	if arg0_19.slotData:CanStartDelegation() then
		setActive(arg0_19.finishTF, false)
		setActive(arg0_19.emptyAddShipTF, not arg0_19.selectedShipId)
		setActive(arg0_19.contentTF, arg0_19.selectedShipId)
		setActive(arg0_19.emptyBtn, not arg0_19.selectedShipId)
		setActive(arg0_19.processTF, arg0_19.selectedShipId)
		setActive(arg0_19.selectShipBtn, arg0_19.selectedShipId)
		setActive(arg0_19.selectFormulaBtn, arg0_19.selectedShipId)
		setActive(arg0_19.inprocessFormulaTF, false)

		if arg0_19.selectedShipId then
			arg0_19.showShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_19.selectedShipId)

			local var1_19 = arg0_19.showShip:GetCurrentEnergy()
			local var2_19 = arg0_19.showShip:GetMaxEnergy()

			setText(arg0_19.energyTFText, var1_19 .. "/" .. var2_19)
			setSlider(arg0_19.energySliderTF, 0, 1, var1_19 / var2_19)
			setText(arg0_19.seletShipName, arg0_19.showShip:GetName())

			local var3_19 = IslandShip.StaticGetPrefab(arg0_19.selectedShipId)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var3_19, "", arg0_19.shipIconTF)
		end

		setActive(arg0_19.stopBtn, false)
		setActive(arg0_19.getBtn, false)
	else
		setActive(arg0_19.contentTF, true)
		setActive(arg0_19.emptyAddShipTF, false)
		setActive(arg0_19.emptyBtn, false)
		setActive(arg0_19.selectShipBtn, false)
		setActive(arg0_19.selectFormulaBtn, false)

		local var4_19 = arg0_19.slotData:GetSlotRoleData()
		local var5_19 = arg0_19.slotData:GetSlotRewardData()
		local var6_19 = not var4_19 and var5_19

		setActive(arg0_19.processTF, not var6_19)
		setActive(arg0_19.finishTF, var6_19)
		setActive(arg0_19.getBtn, var6_19)
		setActive(arg0_19.stopBtn, not var6_19)
		setActive(arg0_19.inprocessFormulaTF, not var6_19)

		if var6_19 then
			local var7_19 = var5_19.formula_id
			local var8_19 = pg.island_formula[var7_19].commission_product
			local var9_19 = var8_19[1][1]
			local var10_19 = var5_19.formula_drop_list[1].num * var8_19[1][2]
			local var11_19 = Drop.New({
				count = 0,
				type = DROP_TYPE_ISLAND_ITEM,
				id = var9_19
			}):getConfigTable().icon

			GetImageSpriteFromAtlasAsync("island/" .. var11_19, "", arg0_19.canRewardIcon)

			local var12_19 = var5_19.main_num or 0
			local var13_19 = "×" .. var10_19 + var12_19

			if var12_19 > 0 then
				setTextColor(arg0_19.canRewardNum, Color.NewHex("#7df39f"))
			else
				setTextColor(arg0_19.canRewardNum, Color.NewHex("#FFFFFF"))
			end

			setText(arg0_19.canRewardNum, var13_19)

			local var14_19 = pg.island_formula[var7_19].item_id
			local var15_19 = pg.island_item_data_template[var14_19]

			GetImageSpriteFromAtlasAsync("island/" .. var15_19.icon, "", arg0_19.finishFurmalaIcon)

			if var5_19.formula_drop_list[2] then
				setActive(arg0_19.canExtraRewardIcon, true)
				setActive(arg0_19.canExtraRewardNum, true)

				local var16_19 = pg.island_formula[var7_19].second_product_display[1][1]
				local var17_19 = var5_19.formula_drop_list[2].num * pg.island_formula[var7_19].second_product_display[1][2]
				local var18_19 = Drop.New({
					count = 0,
					type = DROP_TYPE_ISLAND_ITEM,
					id = var16_19
				}):getConfigTable().icon

				GetImageSpriteFromAtlasAsync("island/" .. var18_19, "", arg0_19.canExtraRewardIcon)

				local var19_19 = var5_19.other_num or 0
				local var20_19 = "×" .. var17_19 + var19_19

				if var19_19 > 0 then
					setTextColor(arg0_19.canExtraRewardNum, Color.NewHex("#7df39f"))
				else
					setTextColor(arg0_19.canExtraRewardNum, Color.NewHex("#FFFFFF"))
				end

				setText(arg0_19.canExtraRewardNum, var20_19)
			end
		end

		if var4_19 then
			arg0_19.showShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var4_19.ship_id)

			local var21_19 = arg0_19.showShip:GetCurrentEnergy()
			local var22_19 = arg0_19.showShip:GetMaxEnergy()

			setText(arg0_19.energyTFText, var21_19 .. "/" .. var22_19)
			setSlider(arg0_19.energySliderTF, 0, 1, var21_19 / var22_19)
			setText(arg0_19.seletShipName, arg0_19.showShip:GetName())

			local var23_19 = IslandShip.StaticGetPrefab(var4_19.ship_id)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var23_19, "", arg0_19.shipIconTF)

			local var24_19 = var4_19.formula_id
			local var25_19 = pg.island_formula[var24_19]
			local var26_19 = var25_19.commission_product[1][1]
			local var27_19 = pg.island_item_data_template[var26_19]
			local var28_19 = Drop.New({
				count = 0,
				type = DROP_TYPE_ISLAND_ITEM,
				id = var26_19
			})

			onButton(arg0_19, arg0_19.currentFormulaIcon, function()
				arg0_19.contextData:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var28_19
				})
			end)
			GetImageSpriteFromAtlasAsync("island/" .. var27_19.icon, "", arg0_19.currentFormulaIcon)
			setText(arg0_19.currentFormulaNum, "×" .. var25_19.commission_product[1][2])
			GetImageSpriteFromAtlasAsync("island/" .. var27_19.icon, "", arg0_19.canRewardIcon)

			local var29_19 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

			if #var25_19.second_product == 0 or not var29_19:IsUnlcokSecondProduct(var24_19) then
				setActive(arg0_19.extraProduct, false)
				setActive(arg0_19.canExtraRewardIcon, false)
				setActive(arg0_19.canExtraRewardNum, false)
			else
				setActive(arg0_19.extraProduct, true)

				local var30_19 = var25_19.second_product_display
				local var31_19 = var30_19[1][1]
				local var32_19 = pg.island_item_data_template[var31_19]

				GetImageSpriteFromAtlasAsync("island/" .. var32_19.icon, "", arg0_19.extraProductIcon)
				GetImageSpriteFromAtlasAsync("island/" .. var32_19.icon, "", arg0_19.canExtraRewardIcon)
				setText(arg0_19.extraProductName, var32_19.name)
				setText(arg0_19.extraProductNum, "×" .. var30_19[1][2])

				local var33_19 = Drop.New({
					count = 0,
					type = DROP_TYPE_ISLAND_ITEM,
					id = var31_19
				})

				onButton(arg0_19, arg0_19.extraProductIcon, function()
					arg0_19.contextData:ShowMsgBox({
						title = i18n("island_word_desc"),
						type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
						dropData = var33_19
					})
				end)
			end
		end
	end
end

function var0_0.AfterShipSelect(arg0_22, arg1_22)
	arg0_22.selectedShipId = arg1_22

	arg0_22:Flush()
	existCall(arg0_22.loadCharacterFunc, arg0_22.selectedShipId)
	arg0_22:OpenFormulaSelectPage()
end

function var0_0.OpenShipSelectPage(arg0_23)
	local var0_23 = pg.island_production_slot[arg0_23.slotId].attribute

	arg0_23:emit(IslandMediator.OPEN_PAGE, "IslandShipSelectPage", {
		{
			needWorkSpeed = true,
			attrType = var0_23,
			confirmFunc = function(arg0_24)
				arg0_23:AfterShipSelect(arg0_24[1])
			end,
			placeId = arg0_23.placeId
		}
	})
end

function var0_0.OpenFormulaSelectPage(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	arg0_25:emit(IslandMediator.OPEN_PAGE, "IslandFormulaSelectPage", {
		{
			commissionId = arg0_25.commissionId,
			selectedShipId = arg4_25 or arg0_25.selectedShipId,
			unLoadCharacterFunc = arg0_25.unLoadCharacterFunc,
			addDelegateFormula = arg1_25,
			addDelegateFormulaTimes = arg2_25,
			canRewardTime = arg3_25,
			confirmFunc = function()
				if arg0_25.contextData and arg0_25.contextData.isPermanent then
					return
				end

				arg0_25:Hide()
			end
		}
	})
	arg0_25:HideDetailPanel()
end

function var0_0.UpdateTime(arg0_27)
	local var0_27 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_27.placeId):GetDelegationSlotData(arg0_27.slotId)

	if not var0_27 then
		arg0_27:FlushInfos()

		return
	end

	local var1_27 = var0_27:GetSlotRoleData()

	if not var1_27 then
		arg0_27:FlushInfos()

		return
	end

	local var2_27 = var1_27:GetFinishTime() - arg0_27.timeMgr:GetServerTime()

	setText(arg0_27.timeTF, arg0_27.timeMgr:DescCDTime(var2_27))
	setSlider(arg0_27.roleDelegationSliderTF, 0, 1, 1 - var2_27 / var1_27:GetAllTime())

	local var3_27 = var1_27:CanRewardTimes()
	local var4_27 = var1_27.formula_id
	local var5_27 = pg.island_formula[var4_27]
	local var6_27 = var1_27:GetCurrentCanRewardExtraMainNum()
	local var7_27 = "×" .. tostring(var5_27.commission_product[1][2] * var3_27 + var6_27)

	if var6_27 and var6_27 > 0 then
		setTextColor(arg0_27.canRewardNum, Color.NewHex("#7df39f"))
	else
		setTextColor(arg0_27.canRewardNum, Color.NewHex("#FFFFFF"))
	end

	setText(arg0_27.canRewardNum, var7_27)

	local var8_27 = var1_27:InCurrentTime()
	local var9_27 = arg0_27.timeMgr:GetServerTime() - var1_27:InCurrentTimeStart(var8_27)

	arg0_27.formulaProcess.fillAmount = var9_27 / var1_27:CurrentTimeNeed(var8_27)

	local var10_27 = var1_27:LastTimes()

	setText(arg0_27.currentFormulaLastNum, var10_27)

	local var11_27 = var1_27:GetExtraMainProduct(var8_27)
	local var12_27 = "×" .. var5_27.commission_product[1][2]

	if var11_27 > 0 then
		var12_27 = string.format("×(%s<color=#7df39f>+%d</color>)", var5_27.commission_product[1][2], var11_27)
	end

	setText(arg0_27.currentFormulaNum, var12_27 .. i18n("island_production_tip"))

	if var3_27 > 0 then
		setActive(arg0_27.getBtn, true)
		setActive(arg0_27.addBtn, false)
	else
		local var13_27 = var5_27.production_limit or 5

		setActive(arg0_27.addBtn, var10_27 < var13_27)
		onButton(arg0_27, arg0_27.addBtn, function()
			arg0_27:OpenFormulaSelectPage(var4_27, var10_27, var3_27, var1_27.ship_id)
		end, SFX_PANEL)
	end

	if #var5_27.second_product == 0 or not getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlcokSecondProduct(var4_27) then
		return
	end

	local var14_27 = var1_27:GetExtraExtraProduct(var8_27)
	local var15_27 = "×" .. var5_27.second_product_display[1][2]

	if var14_27 > 0 then
		var15_27 = string.format("×(%s<color=#7df39f>+%d</color>)", var5_27.second_product_display[1][2], var14_27)
	end

	setText(arg0_27.extraProductNum, var15_27 .. i18n("island_production_tip"))

	local var16_27 = var0_27:GetFromulaTatalCount(var5_27.id)
	local var17_27 = var16_27 + var3_27
	local var18_27 = var5_27.second_product[1]
	local var19_27 = var17_27 % var18_27

	if var19_27 ~= arg0_27.extraProcess then
		arg0_27.extraProcess = var19_27

		arg0_27.extraProductList:align(var18_27)
	end

	local var20_27 = math.floor((var10_27 + var19_27) / var18_27)

	setText(arg0_27.extraProductLastNum, "×" .. var20_27)

	local var21_27 = math.floor(var16_27 / var18_27)
	local var22_27 = math.floor(var17_27 / var18_27) - var21_27

	setActive(arg0_27.canExtraRewardIcon, var22_27 > 0)
	setActive(arg0_27.canExtraRewardNum, var22_27 > 0)

	if var22_27 > 0 then
		local var23_27 = var16_27 % var18_27
		local var24_27 = 0

		for iter0_27 = 1, var22_27 do
			local var25_27 = var8_27 - (iter0_27 - 1) * var18_27
			local var26_27 = math.floor((var25_27 + var23_27) / var18_27) * var18_27 - var23_27

			var24_27 = var24_27 + var1_27:GetExtraExtraProduct(var26_27)
		end

		local var27_27 = "×" .. var5_27.second_product_display[1][2] * var22_27 + var24_27

		if var24_27 > 0 then
			setTextColor(arg0_27.canExtraRewardNum, Color.NewHex("#7df39f"))
		else
			setTextColor(arg0_27.canExtraRewardNum, Color.NewHex("#FFFFFF"))
		end

		setText(arg0_27.canExtraRewardNum, var27_27)
	end
end

function var0_0.StartTimer(arg0_29)
	arg0_29.timer = Timer.New(function()
		arg0_29:UpdateTime()
	end, 1, -1)

	arg0_29.timer:Start()
	arg0_29:UpdateTime()
end

function var0_0.StopTimer(arg0_31)
	if arg0_31.timer ~= nil then
		arg0_31.timer:Stop()

		arg0_31.timer = nil
	end
end

function var0_0.Hide(arg0_32)
	arg0_32.super.Hide(arg0_32)
	arg0_32:OnHide()
end

function var0_0.OnHide(arg0_33)
	arg0_33:StopTimer()
end

function var0_0.OnDestroy(arg0_34)
	arg0_34:OnHide()
end

return var0_0
