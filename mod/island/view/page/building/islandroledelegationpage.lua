local var0_0 = class("IslandRoleDelegationPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandRoleDelegationUI"
end

local var1_0 = 0.5

function var0_0.AddListeners(arg0_2)
	arg0_2:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_2.OnGetDelegationAwardDone)
	arg0_2:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_2.OnFinishDelegationDone)
	arg0_2:AddListener(GAME.ISLAND_USESPEEDUPCARD_DONE, arg0_2.OnUseSpeedupCardDone)
	arg0_2:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_2.OnDelegationStartDone)
end

function var0_0.RemoveListeners(arg0_3)
	arg0_3:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_3.OnGetDelegationAwardDone)
	arg0_3:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_3.OnFinishDelegationDone)
	arg0_3:RemoveListener(GAME.ISLAND_USESPEEDUPCARD_DONE, arg0_3.OnUseSpeedupCardDone)
	arg0_3:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_3.OnDelegationStartDone)
end

local var2_0 = Vector3(0, 0, 0)

function var0_0.OnLoaded(arg0_4)
	arg0_4.backBtn = arg0_4:findTF("top/back")
	arg0_4.title = arg0_4:findTF("top/title")
	arg0_4.content = arg0_4._tf:Find("content")
	arg0_4.selectInfo = arg0_4._tf:Find("selectInfo")
	arg0_4.slotName = arg0_4.selectInfo:Find("slotName")
	arg0_4.normalTitle = arg0_4.selectInfo:Find("title")
	arg0_4.finishTitle = arg0_4.selectInfo:Find("finishTitle")
	arg0_4.unlockSlot = arg0_4.selectInfo:Find("unlock")
	arg0_4.lockSlot = arg0_4.selectInfo:Find("lock")
	arg0_4.emptyShip = arg0_4.unlockSlot:Find("unselctShip")
	arg0_4.process = arg0_4.unlockSlot:Find("process")
	arg0_4.finish = arg0_4.unlockSlot:Find("finish")
	arg0_4.finishFurmalaIcon = arg0_4.finish:Find("formula/curformula")
	arg0_4.selectFormula = arg0_4.process:Find("selectFormula")
	arg0_4.inprocess = arg0_4.process:Find("inprocess")
	arg0_4.currentFormula = arg0_4.inprocess:Find("formula")
	arg0_4.currentFormulaIcon = arg0_4.currentFormula:Find("curformula")
	arg0_4.formulaProcess = arg0_4.currentFormula:Find("process"):GetComponent(typeof(Image))
	arg0_4.inproduction = arg0_4.inprocess:Find("inproduction")
	arg0_4.stopBtn = arg0_4.unlockSlot:Find("btns/stop")
	arg0_4.getBtn = arg0_4.unlockSlot:Find("btns/get")
	arg0_4.emptyBtn = arg0_4.unlockSlot:Find("btns/empty")
	arg0_4.speedupBtn = arg0_4.inproduction:Find("quick")

	setActive(arg0_4.speedupBtn, false)

	arg0_4.canRewardIcon = arg0_4.getBtn:Find("hasicon")
	arg0_4.canRewardNum = arg0_4.getBtn:Find("hasicon/num")
	arg0_4.timeTF = arg0_4.inproduction:Find("time/Text")
	arg0_4.roleDelegationSliderTF = arg0_4.inproduction:Find("time/time_bar")
	arg0_4.delegationList = UIItemList.New(arg0_4.content, arg0_4.content:Find("tpl"))

	arg0_4.delegationList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			arg0_4:InitDelegationItem(arg1_5, arg2_5)
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateDelegationItem(arg1_5, arg2_5)
		end
	end)

	arg0_4.leftcontent = arg0_4._tf:Find("left/left_content")
	arg0_4.delegationTabList = UIItemList.New(arg0_4.leftcontent, arg0_4.leftcontent:Find("tpl"))

	arg0_4.delegationTabList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			arg0_4:InitDelegationTabItem(arg1_6, arg2_6)
		elseif arg0_6 == UIItemList.EventUpdate then
			arg0_4:UpdateDelegationTabItem(arg1_6, arg2_6)
		end
	end)

	arg0_4.selectShip = arg0_4.process:Find("ship/selectShip")
	arg0_4.energySliderTF = arg0_4.selectShip:Find("energy/energy_bar")
	arg0_4.energyTFText = arg0_4.selectShip:Find("energy/Text")
	arg0_4.seletShipName = arg0_4.selectShip:Find("name")
	arg0_4.shipDetailsBtn = arg0_4.process:Find("ship/details")
	arg0_4.shipDetails = arg0_4:findTF("shipDetails")
	arg0_4.shipSkillDetails = arg0_4.shipDetails:Find("skill")
	arg0_4.shipSkillEmp = arg0_4.shipDetails:Find("skillEmp")
	arg0_4.shipSkillEmpDes = arg0_4.shipDetails:Find("skillEmp/Text")
	arg0_4.shipDetailsIcon = arg0_4.shipSkillDetails:Find("icon")
	arg0_4.shipDetailsName = arg0_4.shipSkillDetails:Find("name"):GetComponent(typeof(Text))
	arg0_4.shipDetailsDes = arg0_4.shipSkillDetails:Find("desc/Text"):GetComponent(typeof(Text))
	arg0_4.selectShipButton = arg0_4.selectShip:Find("selectShipButton")
	arg0_4.shipDetailBack = arg0_4.shipDetails:Find("back")
	arg0_4.shipIconTF = arg0_4.selectShip:Find("icon_mask/icon")
	arg0_4.exp_getTf = arg0_4.selectShip:Find("exp_get")

	setActive(arg0_4.exp_getTf, false)
end

function var0_0.OnInit(arg0_7)
	arg0_7:InitPlaceCfg()
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:Hide()
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
	end, SFX_PANEL)

	local function var0_7()
		local var0_9 = arg0_7.placeCommissionList[arg0_7.selectedIdx]
		local var1_9 = pg.island_production_commission[var0_9].slot
		local var2_9 = pg.island_production_slot[var1_9].attribute

		arg0_7:Disable()
		arg0_7:OpenPage(IslandShipSelectPage, 1, {}, var2_9, function(arg0_10)
			arg0_7:AfterShipSelect(arg0_10[1])
		end, function()
			arg0_7:Enable()
		end, {
			place_Id = arg0_7.place_Id
		})
	end

	onButton(arg0_7, arg0_7.emptyShip, function()
		var0_7()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.selectFormula, function()
		local var0_13 = arg0_7.placeCommissionList[arg0_7.selectedIdx]

		arg0_7:Disable()
		arg0_7:OpenPage(IslandFormulaSelectPage, var0_13, arg0_7.place_Id, arg0_7.selectedShip, function()
			arg0_7:Enable()
		end)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.stopBtn, function()
		local var0_15 = arg0_7.placeCommissionList[arg0_7.selectedIdx]
		local var1_15 = pg.island_production_commission[var0_15].slot

		arg0_7:emit(IslandMediator.STOP_DELEGATION, arg0_7.place_Id, var1_15)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.speedupBtn, function()
		local var0_16 = arg0_7.placeCommissionList[arg0_7.selectedIdx]
		local var1_16 = pg.island_production_commission[var0_16].slot

		arg0_7:emit(IslandMediator.USE_SPEEDUPCARD, arg0_7.place_Id, var1_16, 0, 1)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.selectShipButton, function()
		var0_7()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.shipDetailsBtn, function()
		setActive(arg0_7.shipDetails, true)

		local var0_18 = arg0_7.selectedShipInfo:GetSkill()
		local var1_18 = var0_18:IsUnlock()

		setActive(arg0_7.shipSkillDetails, var1_18)
		setActive(arg0_7.shipSkillEmp, not var1_18)
		setText(arg0_7.shipSkillEmpDes, i18n("island_need_star", arg0_7.selectedShipInfo:GetSkillUnlockLevel()))
		GetImageSpriteFromAtlasAsync("island/IslandSkillIcon/" .. var0_18:GetIcon(), "", arg0_7.shipDetailsIcon)

		arg0_7.shipDetailsName.text = string.format("%s - %s", var0_18:GetName(), "[Lv." .. var0_18:GetLevel() .. "]")
		arg0_7.shipDetailsDes.text = var0_18:GetEffectDesc()
	end)
	onButton(arg0_7, arg0_7.shipDetailBack, function()
		setActive(arg0_7.shipDetails, false)
	end)
end

function var0_0.InitPlaceCfg(arg0_20)
	arg0_20.npcToPlaceCfg = {}

	for iter0_20, iter1_20 in ipairs(pg.island_production_place.all) do
		local var0_20 = pg.island_production_place[iter1_20]

		if not arg0_20.npcToPlaceCfg[var0_20.npc_birthplace] then
			arg0_20.npcToPlaceCfg[var0_20.npc_birthplace] = {}
		end

		table.insert(arg0_20.npcToPlaceCfg[var0_20.npc_birthplace], iter1_20)
	end
end

function var0_0.RefreshRightUI(arg0_21, arg1_21)
	arg0_21:StopTimer()

	local var0_21 = arg0_21.placeCommissionList[arg0_21.selectedIdx]
	local var1_21 = pg.island_production_commission[var0_21]

	setText(arg0_21.slotName, arg0_21.placeCfg.name .. "-" .. var1_21.name)

	if not arg1_21 then
		setActive(arg0_21.lockSlot, true)
		setActive(arg0_21.unlockSlot, false)

		return
	end

	setActive(arg0_21.unlockSlot, true)
	setActive(arg0_21.lockSlot, false)
	setActive(arg0_21.selectShipButton, false)

	local var2_21 = arg1_21:CanStartDelegation()

	setActive(arg0_21.normalTitle, true)
	setActive(arg0_21.finishTitle, false)
	setActive(arg0_21.emptyBtn, false)
	setActive(arg0_21.getBtn, false)
	setActive(arg0_21.stopBtn, false)

	if var2_21 then
		setActive(arg0_21.finish, false)

		local var3_21 = arg0_21.selectedShip ~= nil

		setActive(arg0_21.emptyBtn, true)

		if not var3_21 then
			setActive(arg0_21.emptyShip, true)
			setActive(arg0_21.process, false)

			return
		end

		setActive(arg0_21.emptyShip, false)
		setActive(arg0_21.process, true)
		setActive(arg0_21.inprocess, false)
		setActive(arg0_21.selectFormula, true)

		arg0_21.selectedShipInfo = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_21.selectedShip)

		local var4_21 = arg0_21.selectedShipInfo:GetCurrentEnergy()
		local var5_21 = arg0_21.selectedShipInfo:GetMaxEnergy()

		setText(arg0_21.energyTFText, var4_21 .. "/" .. var5_21)
		setSlider(arg0_21.energySliderTF, 0, 1, var4_21 / var5_21)
		setText(arg0_21.seletShipName, arg0_21.selectedShipInfo:GetName())

		local var6_21 = IslandShip.StaticGetPrefab(arg0_21.selectedShip)

		GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var6_21, "", arg0_21.shipIconTF)
		setActive(arg0_21.selectShipButton, true)

		return
	end

	local var7_21 = arg1_21:GetSlotRoleData()
	local var8_21 = arg1_21:GetSlotRewardData()

	if var7_21 == nil and var8_21 ~= nil then
		setActive(arg0_21.normalTitle, false)
		setActive(arg0_21.finishTitle, true)
		setActive(arg0_21.finish, true)
		setActive(arg0_21.process, false)
		setActive(arg0_21.emptyShip, false)
		setActive(arg0_21.getBtn, true)
		onButton(arg0_21, arg0_21.getBtn, function()
			local var0_22 = arg0_21.placeCommissionList[arg0_21.selectedIdx]
			local var1_22 = pg.island_production_commission[var0_22].slot
			local var2_22 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_21.place_Id):GetDelegationSlotData(var1_22)
			local var3_22 = var2_22:GetSlotRoleData()
			local var4_22 = var2_22:GetSlotRewardData()
			local var5_22 = var3_22 == nil and var4_22 ~= nil and 2 or 1

			arg0_21:emit(IslandMediator.GET_DELEGATION_AWARD, arg0_21.place_Id, var1_22, var5_22)
		end, SFX_PANEL)

		local var9_21 = var8_21.formula_id
		local var10_21 = pg.island_formula[var9_21].commission_product
		local var11_21 = var10_21[1][1]
		local var12_21 = var8_21.formula_drop_list[1].num * var10_21[1][2]
		local var13_21 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = var11_21
		}):getConfigTable().icon

		GetImageSpriteFromAtlasAsync("island/" .. var13_21, "", arg0_21.canRewardIcon)
		setText(arg0_21.canRewardNum, "×" .. var12_21)

		local var14_21 = pg.island_formula[var9_21].item_id
		local var15_21 = pg.island_item_data_template[var14_21]

		GetImageSpriteFromAtlasAsync("island/" .. var15_21.icon, "", arg0_21.finishFurmalaIcon)

		return
	end

	setActive(arg0_21.getBtn, true)
	setActive(arg0_21.stopBtn, true)
	setActive(arg0_21.process, true)
	setActive(arg0_21.inprocess, true)
	setActive(arg0_21.emptyShip, false)
	setActive(arg0_21.selectFormula, false)
	setActive(arg0_21.finish, false)

	if var7_21 ~= nil then
		arg0_21:StopTimer()
		arg0_21:StartRoleTimer(var7_21)

		local var16_21 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var7_21.ship_id)
		local var17_21 = var16_21:GetCurrentEnergy()
		local var18_21 = var16_21:GetMaxEnergy()

		setText(arg0_21.energyTFText, var17_21 .. "/" .. var18_21)
		setSlider(arg0_21.energySliderTF, 0, 1, var17_21 / var18_21)
		setText(arg0_21.seletShipName, var16_21:GetName())

		local var19_21 = IslandShip.StaticGetPrefab(var7_21.ship_id)

		GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var19_21, "", arg0_21.shipIconTF)

		local var20_21 = pg.island_formula[var7_21.formula_id].item_id
		local var21_21 = pg.island_item_data_template[var20_21]

		GetImageSpriteFromAtlasAsync("island/" .. var21_21.icon, "", arg0_21.currentFormulaIcon)
	end
end

function var0_0.StartRoleTimer(arg0_23, arg1_23)
	arg0_23:UpdateTime(arg1_23)

	arg0_23.roleTimer = Timer.New(function()
		arg0_23:UpdateTime(arg1_23)
	end, 1, -1)

	arg0_23.roleTimer:Start()
end

function var0_0.StopTimer(arg0_25)
	if arg0_25.roleTimer ~= nil then
		arg0_25.roleTimer:Stop()

		arg0_25.roleTimer = nil
	end
end

function var0_0.UpdateTime(arg0_26, arg1_26)
	local var0_26 = arg1_26:GetFinishTime() - arg0_26.timeMgr:GetServerTime()

	setText(arg0_26.timeTF, arg0_26.timeMgr:DescCDTime(var0_26))
	setSlider(arg0_26.roleDelegationSliderTF, 0, 1, 1 - var0_26 / arg1_26:GetAllTime())

	local var1_26 = arg1_26:CanRewardTimes()
	local var2_26 = arg1_26.formula_id
	local var3_26 = pg.island_formula[var2_26]
	local var4_26 = var3_26.item_id
	local var5_26 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var4_26
	}):getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/" .. var5_26, "", arg0_26.canRewardIcon)
	setText(arg0_26.canRewardNum, "×" .. tostring(var3_26.commission_product[1][2] * var1_26))

	local var6_26 = arg1_26:InCurrentTime()

	if var1_26 > 0 then
		onButton(arg0_26, arg0_26.getBtn, function()
			local var0_27 = arg0_26.placeCommissionList[arg0_26.selectedIdx]
			local var1_27 = pg.island_production_commission[var0_27].slot
			local var2_27 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_26.place_Id):GetDelegationSlotData(var1_27)
			local var3_27 = var2_27:GetSlotRoleData()
			local var4_27 = var2_27:GetSlotRewardData()
			local var5_27 = var3_27 == nil and var4_27 ~= nil and 2 or 1

			arg0_26:emit(IslandMediator.GET_DELEGATION_AWARD, arg0_26.place_Id, var1_27, var5_27)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_26.getBtn)
	end

	local var7_26 = arg0_26.timeMgr:GetServerTime() - arg1_26:InCurrentTimeStart(var6_26)

	arg0_26.formulaProcess.fillAmount = var7_26 / arg1_26:CurrentTimeNeed(var6_26)

	if var0_26 <= 0 then
		arg0_26:StopTimer()
	end
end

function var0_0.InitDelegationTabItem(arg0_28, arg1_28, arg2_28)
	onButton(arg0_28, arg2_28, function()
		arg0_28:OnSelectTargetIndexCommission(arg1_28)
	end, SFX_PANEL)
end

function var0_0.InitDelegationItem(arg0_30, arg1_30, arg2_30)
	onButton(arg0_30, arg2_30, function()
		arg0_30:OnSelectTargetIndexCommission(arg1_30)
	end, SFX_PANEL)

	local var0_30 = arg1_30 + 1
	local var1_30 = arg0_30.placeCommissionList[arg1_30 + 1]
	local var2_30 = pg.island_production_commission[var1_30]
	local var3_30 = pg.island_world_objects[var2_30.birthplace].param.position
	local var4_30 = Vector3(var3_30[1], var3_30[2], var3_30[3])
	local var5_30 = pg.island_world_objects[var2_30.birthplace].param.rotation
	local var6_30 = Vector3(var5_30[1], var5_30[2], var5_30[3])

	arg0_30:emitCore(ISLAND_EVT.LOAD_DELEGATE_SLOT_EFFECCT, var0_30, var4_30, var6_30)
end

function var0_0.UpdateDelegationItem(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.placeCommissionList[arg1_32 + 1]
	local var1_32 = pg.island_production_commission[var0_32]
	local var2_32 = pg.island_world_objects[var1_32.birthplace].param.position
	local var3_32 = Vector3(var2_32[1], var2_32[2], var2_32[3])
	local var4_32 = pg.island_world_objects[var1_32.birthplace].param.rotation
	local var5_32 = Vector3(var4_32[1], var4_32[2], var4_32[3])
	local var6_32 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_32.content, var3_32)

	arg2_32.transform.localPosition = var6_32 + var2_0

	setActive(arg0_32:findTF("select", arg2_32), false)
	setActive(arg0_32:findTF("unselect", arg2_32), false)

	local var7_32 = arg1_32 + 1
	local var8_32 = arg0_32.placeCommissionList[var7_32]
	local var9_32 = pg.island_production_commission[var8_32].slot
	local var10_32 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_32.place_Id):GetDelegationSlotData(var9_32)

	setButtonEnabled(arg2_32, var10_32 ~= nil)

	local var11_32 = arg1_32 + 1

	arg0_32:emitCore(ISLAND_EVT.UPDATE_DELEGATION_EFFECT_POSITION, var11_32, var3_32, var5_32)
	arg0_32:emitCore(ISLAND_EVT.DEFAULTDELEFFECT_SHOW, var11_32, arg0_32.selectedIdx ~= var11_32)
	arg0_32:emitCore(ISLAND_EVT.SELECTDELEFFECT_SHOW, var11_32, arg0_32.selectedIdx == var11_32)
end

function var0_0.OnSelectTargetIndexCommission(arg0_33, arg1_33)
	if arg0_33.selectedIdx == arg1_33 + 1 then
		return
	end

	arg0_33.selectedShip = nil
	arg0_33.selectedIdx = arg1_33 + 1

	arg0_33.delegationTabList:align(#arg0_33.placeCommissionList)
	arg0_33.delegationList:align(#arg0_33.placeCommissionList)
end

function var0_0.UpdateDelegationTabItem(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg1_34 + 1

	setActive(arg0_34:findTF("select", arg2_34), arg0_34.selectedIdx == var0_34)
	setActive(arg0_34:findTF("unselect", arg2_34), arg0_34.selectedIdx ~= var0_34)

	local var1_34 = arg0_34.placeCommissionList[var0_34]
	local var2_34 = pg.island_production_commission[var1_34].slot
	local var3_34 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_34.place_Id):GetDelegationSlotData(var2_34)

	setActive(arg0_34:findTF("lock", arg2_34), not var3_34)
	setButtonEnabled(arg2_34, var3_34 ~= nil)

	if arg0_34.selectedIdx == var0_34 then
		arg0_34:RefreshRightUI(var3_34)
	end

	if not var3_34 then
		setActive(arg0_34:findTF("complete ", arg2_34), false)
		setActive(arg0_34:findTF("product_icon", arg2_34), false)

		return
	end

	local var4_34 = var3_34:GetSlotRoleData()
	local var5_34 = var3_34:GetSlotRewardData()
	local var6_34 = var4_34 == nil and var5_34 ~= nil

	setActive(arg0_34:findTF("complete ", arg2_34), var6_34)

	local var7_34 = var4_34 and var4_34.formula_id or nil

	var7_34 = var7_34 or var5_34 and var5_34.formula_id or nil

	if var7_34 then
		setActive(arg0_34:findTF("product_icon", arg2_34), true)

		local var8_34 = pg.island_formula[var7_34]
		local var9_34 = pg.island_item_data_template[var8_34.item_id]

		GetImageSpriteFromAtlasAsync("island/" .. var9_34.icon, "", arg0_34:findTF("product_icon", arg2_34))
	else
		setActive(arg0_34:findTF("product_icon", arg2_34), false)
	end
end

function var0_0.Flush(arg0_35)
	arg0_35.selectedIdx = 1

	arg0_35.delegationList:align(#arg0_35.placeCommissionList)
	arg0_35.delegationTabList:align(#arg0_35.placeCommissionList)
end

function var0_0.OnShow(arg0_36, arg1_36, arg2_36)
	if arg1_36 then
		arg0_36.place_Id = arg1_36
	else
		arg0_36.place_Id = arg0_36.npcToPlaceCfg[arg2_36][1]
	end

	if arg0_36.place_Id == IslandProductSystemVO.PasturePlaceId then
		IslandGuideChecker.CheckGuide("ISLAND_GUIDE_26")
	elseif arg0_36.place_Id == IslandProductSystemVO.MinePlaceId then
		IslandGuideChecker.CheckGuide("ISLAND_GUIDE_23")
	end

	arg0_36.placeCfg = pg.island_production_place[arg0_36.place_Id]
	arg0_36.placeCommissionList = arg0_36.placeCfg.commission_slot

	if arg0_36.placeCfg.delegationCamera then
		IslandCameraMgr.instance:ActiveVirtualCamera(arg0_36.placeCfg.delegationCamera)
	end

	arg0_36.timeMgr = pg.TimeMgr.GetInstance()
	arg0_36.selectedShip = nil

	arg0_36:Flush()
	setActive(arg0_36.content, false)

	arg0_36.timer = Timer.New(function()
		setActive(arg0_36.content, true)
		arg0_36:Flush()
	end, var1_0, 0)

	arg0_36.timer:Start()
	setActive(arg0_36.shipDetails, false)
	setText(arg0_36:findTF("top/title/Text"), arg0_36.placeCfg.name)
	setText(arg0_36:findTF("top/title/Text/en"), "PRODUCTING")
end

function var0_0.OnHide(arg0_38)
	if arg0_38.timer ~= nil then
		arg0_38.timer:Stop()

		arg0_38.timer = nil
	end

	arg0_38:StopTimer()

	for iter0_38, iter1_38 in ipairs(arg0_38.placeCommissionList) do
		arg0_38:emitCore(ISLAND_EVT.DEFAULTDELEFFECT_SHOW, iter0_38, false)
		arg0_38:emitCore(ISLAND_EVT.SELECTDELEFFECT_SHOW, iter0_38, false)
	end
end

function var0_0.OnDestroy(arg0_39)
	if arg0_39.timer ~= nil then
		arg0_39.timer:Stop()

		arg0_39.timer = nil
	end

	arg0_39:StopTimer()
end

function var0_0.AfterShipSelect(arg0_40, arg1_40)
	arg0_40.selectedShip = arg1_40

	arg0_40.delegationTabList:align(#arg0_40.placeCommissionList)

	local var0_40 = arg0_40.placeCommissionList[arg0_40.selectedIdx]

	arg0_40:OpenPage(IslandFormulaSelectPage, var0_40, arg0_40.place_Id, arg0_40.selectedShip, function()
		arg0_40:Enable()
	end)
	setActive(arg0_40.shipDetails, false)
end

function var0_0.OnGetDelegationAwardDone(arg0_42)
	arg0_42.delegationTabList:align(#arg0_42.placeCommissionList)
end

function var0_0.OnFinishDelegationDone(arg0_43)
	arg0_43.delegationTabList:align(#arg0_43.placeCommissionList)
end

function var0_0.OnUseSpeedupCardDone(arg0_44)
	arg0_44.delegationTabList:align(#arg0_44.placeCommissionList)
end

function var0_0.OnDelegationStartDone(arg0_45)
	arg0_45:Enable()
	arg0_45.delegationTabList:align(#arg0_45.placeCommissionList)
end

return var0_0
