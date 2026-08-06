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
	arg0_2.quickBtn = arg0_2.unlockSlot:Find("emptyBtn")
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
	setText(arg0_2.quickBtn:Find("Text"), i18n("island_quick_delegation"))
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
	onButton(arg0_4, arg0_4.quickBtn, function()
		local var0_15, var1_15 = (function()
			local var0_16 = IslandStartDelegationCommand.GetLocalKeyForLastData(arg0_4.slotId)
			local var1_16 = PlayerPrefs.GetString(var0_16, "")

			return UnpackIntFromString(var1_16)
		end)()
		local var2_15 = pg.island_formula[var1_15]
		local var3_15 = math.floor(var2_15.stamina_cost * (1 - IslandProductCostHelper.GetReducePercentInPlace(var0_15, arg0_4.placeId)))
		local var4_15 = math.max(var3_15, 1)
		local var5_15 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var0_15)

		if not var5_15:IsDelegable() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_quick_delegation_notenough_onduty", var5_15:GetName()))

			arg0_4.selectedShipId = 1
		elseif var4_15 > var5_15:GetCurrentEnergy() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_quick_delegation_notenough_encourage", var5_15:GetName()))

			arg0_4.selectedShipId = 1
		else
			arg0_4.selectedShipId = var0_15
		end

		arg0_4:OpenFormulaSelectPage(nil, nil, nil, nil, var1_15)
	end, SFX_PANEL)
end

function var0_0.ShowDetailPanel(arg0_17)
	setActive(arg0_17.shipDetailsPanel, true)

	local var0_17 = arg0_17.showShip:GetSkill()
	local var1_17 = var0_17:IsUnlock()

	setActive(arg0_17.shipSkillDetails, var1_17)
	setActive(arg0_17.shipSkillEmp, not var1_17)
	setText(arg0_17.shipSkillEmpDes, i18n("island_need_star", arg0_17.showShip:GetSkillUnlockLevel()))
	GetImageSpriteFromAtlasAsync("island/IslandSkillIcon/" .. var0_17:GetIcon(), "", arg0_17.shipDetailsIcon)

	arg0_17.shipDetailsName.text = string.format("%s - %s", var0_17:GetName(), "[Lv." .. var0_17:GetLevel() .. "]")
	arg0_17.shipDetailsDes.text = var0_17:GetEffectDesc()
end

function var0_0.HideDetailPanel(arg0_18)
	setActive(arg0_18.shipDetailsPanel, false)
end

function var0_0.Show(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	arg0_19.super.Show(arg0_19)

	arg0_19.loadCharacterFunc = arg3_19
	arg0_19.unLoadCharacterFunc = arg4_19
	arg0_19.selectedShipId = arg2_19
	arg0_19.commissionId = arg1_19 or arg0_19.commissionId
	arg0_19.slotId = pg.island_production_commission[arg0_19.commissionId].slot
	arg0_19.placeId = pg.island_production_slot[arg0_19.slotId].place

	if arg0_19.placeId == IslandProductConst.PasturePlaceId then
		IslandGuideChecker.CheckGuide("ISLAND_GUIDE_24")
	end

	arg0_19.timeMgr = pg.TimeMgr.GetInstance()

	arg0_19:HideDetailPanel()
	arg0_19:Flush()
end

function var0_0.Flush(arg0_20)
	arg0_20:FlushInfos()
	arg0_20:StopTimer()
	arg0_20:StartTimer()
end

function var0_0.FlushInfos(arg0_21)
	arg0_21.slotData = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_21.placeId):GetDelegationSlotData(arg0_21.slotId)

	local var0_21 = pg.island_production_place[arg0_21.placeId].name

	setText(arg0_21.slotNameTF, var0_21 .. "-" .. pg.island_production_commission[arg0_21.commissionId].name)
	setActive(arg0_21.lockSlot, not arg0_21.slotData)
	setActive(arg0_21.unlockSlot, arg0_21.slotData)
	setActive(arg0_21.addBtn, false)
	setActive(arg0_21.canExtraRewardIcon, false)
	setActive(arg0_21.canExtraRewardNum, false)

	if not arg0_21.slotData then
		return
	end

	if arg0_21.slotData:CanStartDelegation() then
		setActive(arg0_21.finishTF, false)
		setActive(arg0_21.emptyAddShipTF, not arg0_21.selectedShipId)
		setActive(arg0_21.contentTF, arg0_21.selectedShipId)

		local var1_21 = IslandStartDelegationCommand.GetLocalKeyForLastData(arg0_21.slotId)

		if PlayerPrefs.GetString(var1_21, "") ~= "" then
			setActive(arg0_21.quickBtn, true)
		else
			setActive(arg0_21.quickBtn, false)
		end

		setActive(arg0_21.processTF, arg0_21.selectedShipId)
		setActive(arg0_21.selectShipBtn, arg0_21.selectedShipId)
		setActive(arg0_21.selectFormulaBtn, arg0_21.selectedShipId)
		setActive(arg0_21.inprocessFormulaTF, false)

		if arg0_21.selectedShipId then
			arg0_21.showShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_21.selectedShipId)

			local var2_21 = arg0_21.showShip:GetCurrentEnergy()
			local var3_21 = arg0_21.showShip:GetMaxEnergy()

			setText(arg0_21.energyTFText, var2_21 .. "/" .. var3_21)
			setSlider(arg0_21.energySliderTF, 0, 1, var2_21 / var3_21)
			setText(arg0_21.seletShipName, arg0_21.showShip:GetName())

			local var4_21 = IslandShip.StaticGetPrefab(arg0_21.selectedShipId)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var4_21, "", arg0_21.shipIconTF)
		end

		setActive(arg0_21.stopBtn, false)
		setActive(arg0_21.getBtn, false)
	else
		setActive(arg0_21.contentTF, true)
		setActive(arg0_21.emptyAddShipTF, false)
		setActive(arg0_21.quickBtn, false)
		setActive(arg0_21.selectShipBtn, false)
		setActive(arg0_21.selectFormulaBtn, false)

		local var5_21 = arg0_21.slotData:GetSlotRoleData()
		local var6_21 = arg0_21.slotData:GetSlotRewardData()
		local var7_21 = not var5_21 and var6_21

		setActive(arg0_21.processTF, not var7_21)
		setActive(arg0_21.finishTF, var7_21)
		setActive(arg0_21.getBtn, var7_21)
		setActive(arg0_21.stopBtn, not var7_21)
		setActive(arg0_21.inprocessFormulaTF, not var7_21)

		if var7_21 then
			local var8_21 = var6_21.formula_id
			local var9_21 = pg.island_formula[var8_21].commission_product
			local var10_21 = var9_21[1][1]
			local var11_21 = var6_21.formula_drop_list[1].num * var9_21[1][2]
			local var12_21 = Drop.New({
				count = 0,
				type = DROP_TYPE_ISLAND_ITEM,
				id = var10_21
			}):getConfigTable().icon

			GetImageSpriteFromAtlasAsync("island/" .. var12_21, "", arg0_21.canRewardIcon)

			local var13_21 = var6_21.main_num or 0
			local var14_21 = "×" .. var11_21 + var13_21

			if var13_21 > 0 then
				setTextColor(arg0_21.canRewardNum, Color.NewHex("#7df39f"))
			else
				setTextColor(arg0_21.canRewardNum, Color.NewHex("#FFFFFF"))
			end

			setText(arg0_21.canRewardNum, var14_21)

			local var15_21 = pg.island_formula[var8_21].item_id
			local var16_21 = pg.island_item_data_template[var15_21]

			GetImageSpriteFromAtlasAsync("island/" .. var16_21.icon, "", arg0_21.finishFurmalaIcon)

			if var6_21.formula_drop_list[2] then
				setActive(arg0_21.canExtraRewardIcon, true)
				setActive(arg0_21.canExtraRewardNum, true)

				local var17_21 = pg.island_formula[var8_21].second_product_display[1][1]
				local var18_21 = var6_21.formula_drop_list[2].num * pg.island_formula[var8_21].second_product_display[1][2]
				local var19_21 = Drop.New({
					count = 0,
					type = DROP_TYPE_ISLAND_ITEM,
					id = var17_21
				}):getConfigTable().icon

				GetImageSpriteFromAtlasAsync("island/" .. var19_21, "", arg0_21.canExtraRewardIcon)

				local var20_21 = var6_21.other_num or 0
				local var21_21 = "×" .. var18_21 + var20_21

				if var20_21 > 0 then
					setTextColor(arg0_21.canExtraRewardNum, Color.NewHex("#7df39f"))
				else
					setTextColor(arg0_21.canExtraRewardNum, Color.NewHex("#FFFFFF"))
				end

				setText(arg0_21.canExtraRewardNum, var21_21)
			end
		end

		if var5_21 then
			arg0_21.showShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var5_21.ship_id)

			local var22_21 = arg0_21.showShip:GetCurrentEnergy()
			local var23_21 = arg0_21.showShip:GetMaxEnergy()

			setText(arg0_21.energyTFText, var22_21 .. "/" .. var23_21)
			setSlider(arg0_21.energySliderTF, 0, 1, var22_21 / var23_21)
			setText(arg0_21.seletShipName, arg0_21.showShip:GetName())

			local var24_21 = IslandShip.StaticGetPrefab(var5_21.ship_id)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var24_21, "", arg0_21.shipIconTF)

			local var25_21 = var5_21.formula_id
			local var26_21 = pg.island_formula[var25_21]
			local var27_21 = var26_21.commission_product[1][1]
			local var28_21 = pg.island_item_data_template[var27_21]
			local var29_21 = Drop.New({
				count = 0,
				type = DROP_TYPE_ISLAND_ITEM,
				id = var27_21
			})

			onButton(arg0_21, arg0_21.currentFormulaIcon, function()
				arg0_21.contextData:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var29_21
				})
			end)
			GetImageSpriteFromAtlasAsync("island/" .. var28_21.icon, "", arg0_21.currentFormulaIcon)
			setText(arg0_21.currentFormulaNum, "×" .. var26_21.commission_product[1][2])
			GetImageSpriteFromAtlasAsync("island/" .. var28_21.icon, "", arg0_21.canRewardIcon)

			local var30_21 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

			if #var26_21.second_product == 0 or not var30_21:IsUnlcokSecondProduct(var25_21) then
				setActive(arg0_21.extraProduct, false)
				setActive(arg0_21.canExtraRewardIcon, false)
				setActive(arg0_21.canExtraRewardNum, false)
			else
				setActive(arg0_21.extraProduct, true)

				local var31_21 = var26_21.second_product_display
				local var32_21 = var31_21[1][1]
				local var33_21 = pg.island_item_data_template[var32_21]

				GetImageSpriteFromAtlasAsync("island/" .. var33_21.icon, "", arg0_21.extraProductIcon)
				GetImageSpriteFromAtlasAsync("island/" .. var33_21.icon, "", arg0_21.canExtraRewardIcon)
				setText(arg0_21.extraProductName, var33_21.name)
				setText(arg0_21.extraProductNum, "×" .. var31_21[1][2])

				local var34_21 = Drop.New({
					count = 0,
					type = DROP_TYPE_ISLAND_ITEM,
					id = var32_21
				})

				onButton(arg0_21, arg0_21.extraProductIcon, function()
					arg0_21.contextData:ShowMsgBox({
						title = i18n("island_word_desc"),
						type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
						dropData = var34_21
					})
				end)
			end
		end
	end
end

function var0_0.AfterShipSelect(arg0_24, arg1_24)
	arg0_24.selectedShipId = arg1_24

	arg0_24:Flush()
	existCall(arg0_24.loadCharacterFunc, arg0_24.selectedShipId)
	arg0_24:OpenFormulaSelectPage()
end

function var0_0.OpenShipSelectPage(arg0_25)
	local var0_25 = pg.island_production_slot[arg0_25.slotId].attribute

	arg0_25:emit(IslandMediator.OPEN_PAGE, "IslandShipSelectPage", {
		{
			needWorkSpeed = true,
			showType = IslandSelectShipCard.SHOW_TYPE.PLACE,
			attrType = var0_25,
			confirmFunc = function(arg0_26)
				arg0_25:AfterShipSelect(arg0_26[1])
			end,
			placeId = arg0_25.placeId
		}
	})
end

function var0_0.OpenFormulaSelectPage(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27)
	arg0_27:emit(IslandMediator.OPEN_PAGE, "IslandFormulaSelectPage", {
		{
			commissionId = arg0_27.commissionId,
			selectedShipId = arg4_27 or arg0_27.selectedShipId,
			unLoadCharacterFunc = arg0_27.unLoadCharacterFunc,
			addDelegateFormula = arg1_27,
			addDelegateFormulaTimes = arg2_27,
			canRewardTime = arg3_27,
			selectFormulaId = arg5_27,
			confirmFunc = function()
				if arg0_27.contextData and arg0_27.contextData.isPermanent then
					return
				end

				arg0_27:Hide()
			end
		}
	})
	arg0_27:HideDetailPanel()
end

function var0_0.UpdateTime(arg0_29)
	local var0_29 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_29.placeId):GetDelegationSlotData(arg0_29.slotId)

	if not var0_29 then
		arg0_29:FlushInfos()

		return
	end

	local var1_29 = var0_29:GetSlotRoleData()

	if not var1_29 then
		arg0_29:FlushInfos()

		return
	end

	local var2_29 = var1_29:GetFinishTime() - arg0_29.timeMgr:GetServerTime()

	setText(arg0_29.timeTF, arg0_29.timeMgr:DescCDTime(var2_29))
	setSlider(arg0_29.roleDelegationSliderTF, 0, 1, 1 - var2_29 / var1_29:GetAllTime())

	local var3_29 = var1_29:CanRewardTimes()
	local var4_29 = var1_29.formula_id
	local var5_29 = pg.island_formula[var4_29]
	local var6_29 = var1_29:GetCurrentCanRewardExtraMainNum()
	local var7_29 = "×" .. tostring(var5_29.commission_product[1][2] * var3_29 + var6_29)

	if var6_29 and var6_29 > 0 then
		setTextColor(arg0_29.canRewardNum, Color.NewHex("#7df39f"))
	else
		setTextColor(arg0_29.canRewardNum, Color.NewHex("#FFFFFF"))
	end

	setText(arg0_29.canRewardNum, var7_29)

	local var8_29 = var1_29:InCurrentTime()
	local var9_29 = arg0_29.timeMgr:GetServerTime() - var1_29:InCurrentTimeStart(var8_29)

	arg0_29.formulaProcess.fillAmount = var9_29 / var1_29:CurrentTimeNeed(var8_29)

	local var10_29 = var1_29:LastTimes()

	setText(arg0_29.currentFormulaLastNum, var10_29)

	local var11_29 = var1_29:GetExtraMainProduct(var8_29)
	local var12_29 = "×" .. var5_29.commission_product[1][2]

	if var11_29 > 0 then
		var12_29 = string.format("×(%s<color=#7df39f>+%d</color>)", var5_29.commission_product[1][2], var11_29)
	end

	setText(arg0_29.currentFormulaNum, var12_29 .. i18n("island_production_tip"))

	if var3_29 > 0 then
		setActive(arg0_29.getBtn, true)
		setActive(arg0_29.addBtn, false)
	else
		local var13_29 = var5_29.production_limit or 5

		setActive(arg0_29.addBtn, var10_29 < var13_29)
		onButton(arg0_29, arg0_29.addBtn, function()
			arg0_29:OpenFormulaSelectPage(var4_29, var10_29, var3_29, var1_29.ship_id)
		end, SFX_PANEL)
	end

	if #var5_29.second_product == 0 or not getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlcokSecondProduct(var4_29) then
		return
	end

	local var14_29 = var1_29:GetExtraExtraProduct(var8_29)
	local var15_29 = "×" .. var5_29.second_product_display[1][2]

	if var14_29 > 0 then
		var15_29 = string.format("×(%s<color=#7df39f>+%d</color>)", var5_29.second_product_display[1][2], var14_29)
	end

	setText(arg0_29.extraProductNum, var15_29 .. i18n("island_production_tip"))

	local var16_29 = var0_29:GetFromulaTatalCount(var5_29.id)
	local var17_29 = var16_29 + var3_29
	local var18_29 = var5_29.second_product[1]
	local var19_29 = var17_29 % var18_29

	if var19_29 ~= arg0_29.extraProcess then
		arg0_29.extraProcess = var19_29

		arg0_29.extraProductList:align(var18_29)
	end

	local var20_29 = math.floor((var10_29 + var19_29) / var18_29)

	setText(arg0_29.extraProductLastNum, "×" .. var20_29)

	local var21_29 = math.floor(var16_29 / var18_29)
	local var22_29 = math.floor(var17_29 / var18_29) - var21_29

	setActive(arg0_29.canExtraRewardIcon, var22_29 > 0)
	setActive(arg0_29.canExtraRewardNum, var22_29 > 0)

	if var22_29 > 0 then
		local var23_29 = var16_29 % var18_29
		local var24_29 = 0

		for iter0_29 = 1, var22_29 do
			local var25_29 = var8_29 - (iter0_29 - 1) * var18_29
			local var26_29 = math.floor((var25_29 + var23_29) / var18_29) * var18_29 - var23_29

			var24_29 = var24_29 + var1_29:GetExtraExtraProduct(var26_29)
		end

		local var27_29 = "×" .. var5_29.second_product_display[1][2] * var22_29 + var24_29

		if var24_29 > 0 then
			setTextColor(arg0_29.canExtraRewardNum, Color.NewHex("#7df39f"))
		else
			setTextColor(arg0_29.canExtraRewardNum, Color.NewHex("#FFFFFF"))
		end

		setText(arg0_29.canExtraRewardNum, var27_29)
	end
end

function var0_0.StartTimer(arg0_31)
	arg0_31.timer = Timer.New(function()
		arg0_31:UpdateTime()
	end, 1, -1)

	arg0_31.timer:Start()
	arg0_31:UpdateTime()
end

function var0_0.StopTimer(arg0_33)
	if arg0_33.timer ~= nil then
		arg0_33.timer:Stop()

		arg0_33.timer = nil
	end
end

function var0_0.Hide(arg0_34)
	arg0_34.super.Hide(arg0_34)
	arg0_34:OnHide()
end

function var0_0.OnHide(arg0_35)
	arg0_35:StopTimer()
end

function var0_0.OnDestroy(arg0_36)
	arg0_36:OnHide()
end

return var0_0
