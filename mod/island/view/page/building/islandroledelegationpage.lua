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
	arg0_4.selectFormula = arg0_4.process:Find("selectFormula")
	arg0_4.inprocess = arg0_4.process:Find("inprocess")
	arg0_4.currentFormula = arg0_4.inprocess:Find("formula")
	arg0_4.formulaProcess = arg0_4.currentFormula:Find("process"):GetComponent(typeof(Image))
	arg0_4.inproduction = arg0_4.inprocess:Find("inproduction")
	arg0_4.stopBtn = arg0_4.unlockSlot:Find("btns/stop")
	arg0_4.getBtn = arg0_4.unlockSlot:Find("btns/get")
	arg0_4.emptyBtn = arg0_4.unlockSlot:Find("btns/empty")
	arg0_4.speedupBtn = arg0_4.inproduction:Find("quick")
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
end

function var0_0.OnInit(arg0_7)
	arg0_7:InitPlaceCfg()
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:Hide()
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.emptyShip, function()
		local var0_9 = arg0_7.placeCommissionList[arg0_7.selectedIdx]

		arg0_7:Disable()
		arg0_7:OpenPage(IslandShipSelectPage, var0_9, function(arg0_10)
			arg0_7:AfterShipSelect(arg0_10)
		end, function()
			arg0_7:Enable()
		end)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.selectFormula, function()
		local var0_12 = arg0_7.placeCommissionList[arg0_7.selectedIdx]

		arg0_7:Disable()
		arg0_7:OpenPage(IslandFormulaSelectPage, var0_12, arg0_7.place_Id, arg0_7.selectedShip, function()
			arg0_7:Enable()
		end)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.stopBtn, function()
		local var0_14 = arg0_7.placeCommissionList[arg0_7.selectedIdx]
		local var1_14 = pg.island_production_commission[var0_14].slot

		arg0_7:emit(IslandMediator.STOP_DELEGATION, arg0_7.place_Id, var1_14)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.getBtn, function()
		local var0_15 = arg0_7.placeCommissionList[arg0_7.selectedIdx]
		local var1_15 = pg.island_production_commission[var0_15].slot
		local var2_15 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_7.place_Id):GetDelegationSlotData(var1_15)
		local var3_15 = var2_15:GetSlotRoleData()
		local var4_15 = var2_15:GetSlotRewardData()
		local var5_15 = var3_15 == nil and var4_15 ~= nil and 2 or 1

		arg0_7:emit(IslandMediator.GET_DELEGATION_AWARD, arg0_7.place_Id, var1_15, var5_15)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.speedupBtn, function()
		local var0_16 = arg0_7.placeCommissionList[arg0_7.selectedIdx]
		local var1_16 = pg.island_production_commission[var0_16].slot

		arg0_7:emit(IslandMediator.USE_SPEEDUPCARD, arg0_7.place_Id, var1_16, 0, 1)
	end, SFX_PANEL)
end

function var0_0.InitPlaceCfg(arg0_17)
	arg0_17.npcToPlaceCfg = {}

	for iter0_17, iter1_17 in ipairs(pg.island_production_place.all) do
		local var0_17 = pg.island_production_place[iter1_17]

		if not arg0_17.npcToPlaceCfg[var0_17.npc_birthplace] then
			arg0_17.npcToPlaceCfg[var0_17.npc_birthplace] = iter1_17
		end
	end
end

function var0_0.RefreshRightUI(arg0_18, arg1_18)
	arg0_18:StopTimer()

	local var0_18 = arg0_18.placeCommissionList[arg0_18.selectedIdx]
	local var1_18 = pg.island_production_commission[var0_18]

	setText(arg0_18.slotName, arg0_18.placeCfg.name .. "-" .. var1_18.name)

	if not arg1_18 then
		setActive(arg0_18.lockSlot, true)
		setActive(arg0_18.unlockSlot, false)

		return
	end

	setActive(arg0_18.unlockSlot, true)
	setActive(arg0_18.lockSlot, false)

	local var2_18 = arg1_18:CanStartDelegation()

	setActive(arg0_18.normalTitle, true)
	setActive(arg0_18.finishTitle, false)
	setActive(arg0_18.emptyBtn, false)
	setActive(arg0_18.getBtn, false)
	setActive(arg0_18.stopBtn, false)

	if var2_18 then
		setActive(arg0_18.finish, false)

		local var3_18 = arg0_18.selectedShip ~= nil

		setActive(arg0_18.emptyBtn, true)

		if not var3_18 then
			setActive(arg0_18.emptyShip, true)
			setActive(arg0_18.process, false)

			return
		end

		setActive(arg0_18.emptyShip, false)
		setActive(arg0_18.process, true)
		setActive(arg0_18.inprocess, false)
		setActive(arg0_18.selectFormula, true)

		return
	end

	local var4_18 = arg1_18:GetSlotRoleData()
	local var5_18 = arg1_18:GetSlotRewardData()

	if var4_18 == nil and var5_18 ~= nil then
		setActive(arg0_18.normalTitle, false)
		setActive(arg0_18.finishTitle, true)
		setActive(arg0_18.finish, true)
		setActive(arg0_18.process, false)
		setActive(arg0_18.emptyShip, false)
		setActive(arg0_18.getBtn, true)

		local var6_18 = var5_18.formula_drop_list[1].id
		local var7_18 = var5_18.formula_drop_list[1].num
		local var8_18 = 2001
		local var9_18 = 1
		local var10_18 = Drop.New({
			count = 0,
			type = DROP_TYPE_ISLAND_ITEM,
			id = var8_18
		}):getConfigTable().icon

		GetImageSpriteFromAtlasAsync(var10_18, "", arg0_18.canRewardIcon)
		setText(arg0_18.canRewardNum, "×" .. var9_18)

		return
	end

	setActive(arg0_18.getBtn, true)
	setActive(arg0_18.stopBtn, true)
	setActive(arg0_18.process, true)
	setActive(arg0_18.inprocess, true)
	setActive(arg0_18.emptyShip, false)
	setActive(arg0_18.selectFormula, false)
	setActive(arg0_18.finish, false)

	if var4_18 ~= nil then
		arg0_18:StopTimer()
		arg0_18:StartRoleTimer(var4_18)
	end
end

function var0_0.StartRoleTimer(arg0_19, arg1_19)
	arg0_19:UpdateTime(arg1_19)

	arg0_19.roleTimer = Timer.New(function()
		arg0_19:UpdateTime(arg1_19)
	end, 1, -1)

	arg0_19.roleTimer:Start()
end

function var0_0.StopTimer(arg0_21)
	if arg0_21.roleTimer ~= nil then
		arg0_21.roleTimer:Stop()

		arg0_21.roleTimer = nil
	end
end

function var0_0.UpdateTime(arg0_22, arg1_22)
	local var0_22 = arg1_22:GetFinishTime() - arg0_22.timeMgr:GetServerTime()

	setText(arg0_22.timeTF, arg0_22.timeMgr:DescCDTime(var0_22))
	setSlider(arg0_22.roleDelegationSliderTF, 0, 1, 1 - var0_22 / arg1_22:GetAllTime())

	local var1_22 = arg1_22:CanRewardTimes()
	local var2_22 = arg1_22.formula_id
	local var3_22 = pg.island_formula[var2_22]
	local var4_22 = var3_22.item_id
	local var5_22 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = var4_22
	}):getConfigTable().icon

	GetImageSpriteFromAtlasAsync(var5_22, "", arg0_22.canRewardIcon)
	setText(arg0_22.canRewardNum, "×" .. tostring(var3_22.commission_product[1][2] * var1_22))

	local var6_22 = arg0_22.timeMgr:GetServerTime() - arg1_22:InCurrentTimeStart()

	arg0_22.formulaProcess.fillAmount = var6_22 / arg1_22.once_cost_time

	if var0_22 <= 0 then
		arg0_22:StopTimer()
	end
end

function var0_0.InitDelegationTabItem(arg0_23, arg1_23, arg2_23)
	onButton(arg0_23, arg2_23, function()
		arg0_23:OnSelectTargetIndexCommission(arg1_23)
	end, SFX_PANEL)
end

function var0_0.InitDelegationItem(arg0_25, arg1_25, arg2_25)
	onButton(arg0_25, arg2_25, function()
		arg0_25:OnSelectTargetIndexCommission(arg1_25)
	end, SFX_PANEL)
end

function var0_0.OnSelectTargetIndexCommission(arg0_27, arg1_27)
	if arg0_27.selectedIdx == arg1_27 + 1 then
		return
	end

	arg0_27.selectedShip = nil
	arg0_27.selectedIdx = arg1_27 + 1

	arg0_27.delegationTabList:align(#arg0_27.placeCommissionList)
	arg0_27.delegationList:align(#arg0_27.placeCommissionList)
end

function var0_0.UpdateDelegationTabItem(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg1_28 + 1

	setActive(arg0_28:findTF("select", arg2_28), arg0_28.selectedIdx == var0_28)
	setActive(arg0_28:findTF("unselect", arg2_28), arg0_28.selectedIdx ~= var0_28)

	local var1_28 = arg0_28.placeCommissionList[var0_28]
	local var2_28 = pg.island_production_commission[var1_28].slot
	local var3_28 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_28.place_Id):GetDelegationSlotData(var2_28)

	if arg0_28.selectedIdx == var0_28 then
		arg0_28:RefreshRightUI(var3_28)
	end

	if not var3_28 then
		setActive(arg0_28:findTF("complete ", arg2_28), false)
		setActive(arg0_28:findTF("product_icon", arg2_28), false)

		return
	end

	local var4_28 = var3_28:GetSlotRoleData()
	local var5_28 = var3_28:GetSlotRewardData()
	local var6_28 = var4_28 == nil and var5_28 ~= nil

	setActive(arg0_28:findTF("complete ", arg2_28), var6_28)

	local var7_28 = var4_28 and var4_28.formula_id or nil

	var7_28 = var7_28 or var5_28 and var5_28.formula_id or nil

	if var7_28 then
		setActive(arg0_28:findTF("product_icon", arg2_28), true)

		local var8_28 = pg.island_formula[var7_28]
		local var9_28 = pg.island_item_data_template[var8_28.item_id]

		GetImageSpriteFromAtlasAsync(var9_28.icon, "", arg0_28:findTF("product_icon", arg2_28))
	else
		setActive(arg0_28:findTF("product_icon", arg2_28), false)
	end
end

function var0_0.UpdateDelegationItem(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.placeCommissionList[arg1_29 + 1]
	local var1_29 = pg.island_production_commission[var0_29]
	local var2_29 = pg.island_world_objects[var1_29.birthplace].param.position
	local var3_29 = Vector3(var2_29[1], var2_29[2], var2_29[3])
	local var4_29 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_29.content, var3_29)

	arg2_29.transform.localPosition = var4_29 + var2_0

	setActive(arg0_29:findTF("select", arg2_29), arg0_29.selectedIdx == arg1_29 + 1)
	setActive(arg0_29:findTF("unselect", arg2_29), arg0_29.selectedIdx ~= arg1_29 + 1)
end

function var0_0.Flush(arg0_30)
	arg0_30.selectedIdx = 1

	arg0_30.delegationList:align(#arg0_30.placeCommissionList)
	arg0_30.delegationTabList:align(#arg0_30.placeCommissionList)
end

function var0_0.OnShow(arg0_31, arg1_31)
	arg0_31.place_Id = arg0_31.npcToPlaceCfg[arg1_31]
	arg0_31.placeCfg = pg.island_production_place[arg0_31.place_Id]
	arg0_31.placeCommissionList = arg0_31.placeCfg.commission_slot

	if arg0_31.placeCfg.delegationCamera then
		IslandCameraMgr.instance:ActiveVirtualCamera(arg0_31.placeCfg.delegationCamera)
	end

	arg0_31.timeMgr = pg.TimeMgr.GetInstance()
	arg0_31.selectedShip = nil

	arg0_31:Flush()
	setActive(arg0_31.content, false)

	arg0_31.timer = Timer.New(function()
		setActive(arg0_31.content, true)
		arg0_31:Flush()
	end, var1_0, 0)

	arg0_31.timer:Start()
	setText(arg0_31:findTF("top/title/Text"), arg0_31.placeCfg.name)
end

function var0_0.OnHide(arg0_33)
	if arg0_33.timer ~= nil then
		arg0_33.timer:Stop()

		arg0_33.timer = nil
	end

	arg0_33:StopTimer()
end

function var0_0.OnDestroy(arg0_34)
	if arg0_34.timer ~= nil then
		arg0_34.timer:Stop()

		arg0_34.timer = nil
	end

	arg0_34:StopTimer()
end

function var0_0.AfterShipSelect(arg0_35, arg1_35)
	arg0_35.selectedShip = arg1_35

	arg0_35.delegationTabList:align(#arg0_35.placeCommissionList)

	local var0_35 = arg0_35.placeCommissionList[arg0_35.selectedIdx]

	arg0_35:OpenPage(IslandFormulaSelectPage, var0_35, arg0_35.place_Id, arg0_35.selectedShip, function()
		arg0_35:Enable()
	end)
end

function var0_0.OnGetDelegationAwardDone(arg0_37)
	arg0_37.delegationTabList:align(#arg0_37.placeCommissionList)
end

function var0_0.OnFinishDelegationDone(arg0_38)
	arg0_38.delegationTabList:align(#arg0_38.placeCommissionList)
end

function var0_0.OnUseSpeedupCardDone(arg0_39)
	arg0_39.delegationTabList:align(#arg0_39.placeCommissionList)
end

function var0_0.OnDelegationStartDone(arg0_40)
	arg0_40:Enable()
	arg0_40.delegationTabList:align(#arg0_40.placeCommissionList)
end

return var0_0
