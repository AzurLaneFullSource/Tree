local var0_0 = class("IslandRoleDelegationPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandRoleDelegationUI"
end

local var1_0 = 0.6

function var0_0.AddListeners(arg0_2)
	arg0_2:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_2.OnGetDelegationAwardDone)
	arg0_2:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_2.OnFinishDelegationDone)
	arg0_2:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_2.OnDelegationStartDone)
	arg0_2:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_2.OnUseTicketDone)
end

function var0_0.RemoveListeners(arg0_3)
	arg0_3:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_3.OnGetDelegationAwardDone)
	arg0_3:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_3.OnFinishDelegationDone)
	arg0_3:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_3.OnDelegationStartDone)
	arg0_3:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_3.OnUseTicketDone)
end

local var2_0 = Vector3(0, 0, 0)

function var0_0.OnLoaded(arg0_4)
	arg0_4.backBtn = arg0_4:findTF("top/back")
	arg0_4.title = arg0_4:findTF("top/title")
	arg0_4.content = arg0_4._tf:Find("content")
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

	arg0_4.selectPanel = IslandDelegationSelectPanel.New(arg0_4._tf, arg0_4.event, {
		isPermanent = true,
		alignRight = true
	})
	arg0_4.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_4._tf, arg0_4.event)
end

function var0_0.OnInit(arg0_7)
	arg0_7:InitPlaceCfg()
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:Hide()
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_commission.tip
		})
	end, SFX_PANEL)
end

function var0_0.InitPlaceCfg(arg0_10)
	arg0_10.npcToPlaceCfg = {}

	for iter0_10, iter1_10 in ipairs(pg.island_production_place.all) do
		local var0_10 = pg.island_production_place[iter1_10]

		if not arg0_10.npcToPlaceCfg[var0_10.npc_birthplace] then
			arg0_10.npcToPlaceCfg[var0_10.npc_birthplace] = {}
		end

		table.insert(arg0_10.npcToPlaceCfg[var0_10.npc_birthplace], iter1_10)
	end
end

function var0_0.InitDelegationTabItem(arg0_11, arg1_11, arg2_11)
	onButton(arg0_11, arg2_11, function()
		arg0_11:OnSelectTargetIndexCommission(arg1_11)
	end, SFX_PANEL)
end

function var0_0.InitDelegationItem(arg0_13, arg1_13, arg2_13)
	onButton(arg0_13, arg2_13, function()
		arg0_13:OnSelectTargetIndexCommission(arg1_13)
	end, SFX_PANEL)
end

function var0_0.UpdateDelegationItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.placeCommissionList[arg1_15 + 1]
	local var1_15 = pg.island_production_commission[var0_15]
	local var2_15 = pg.island_world_objects[var1_15.birthplace].param.position
	local var3_15 = Vector3(var2_15[1], var2_15[2], var2_15[3])
	local var4_15 = pg.island_world_objects[var1_15.birthplace].param.rotation
	local var5_15 = Vector3(var4_15[1], var4_15[2], var4_15[3])
	local var6_15 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_15.content, var3_15)

	arg2_15.transform.localPosition = var6_15 + var2_0

	setActive(arg0_15:findTF("select", arg2_15), false)
	setActive(arg0_15:findTF("unselect", arg2_15), false)

	local var7_15 = arg1_15 + 1
	local var8_15 = arg0_15.placeCommissionList[var7_15]
	local var9_15 = pg.island_production_commission[var8_15].slot
	local var10_15 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_15.placeId):GetDelegationSlotData(var9_15)

	setButtonEnabled(arg2_15, var10_15 ~= nil)

	local var11_15 = arg1_15 + 1

	arg0_15:emitCore(ISLAND_EVT.SELECTDELEEFFECT_SHOW, var11_15, arg0_15.selectedIdx, var3_15, var5_15)
end

function var0_0.OnSelectTargetIndexCommission(arg0_16, arg1_16, arg2_16)
	if arg0_16.selectedIdx == arg1_16 + 1 and not arg2_16 then
		return
	end

	if not arg2_16 then
		arg0_16.selectedShip = nil

		arg0_16:UnloadPreconcenCharacter()
	end

	arg0_16.selectedIdx = arg1_16 + 1
	arg0_16.contextData.selectedIdx = arg0_16.selectedIdx

	local var0_16 = arg0_16.placeCommissionList[arg0_16.selectedIdx]

	arg0_16.selectPanel:ExecuteAction("Show", var0_16, arg0_16.selectedShip, function(arg0_17)
		arg0_16.contextData.selectedShip = arg0_17
		arg0_16.selectedShip = arg0_17

		arg0_16:LoadPreconcenCharacter(arg0_17)
	end, function()
		arg0_16.contextData.selectedShip = nil
		arg0_16.selectedShip = nil

		arg0_16:UnloadPreconcenCharacter()
	end)
	arg0_16.delegationTabList:align(#arg0_16.placeCommissionList)
	arg0_16.delegationList:align(#arg0_16.placeCommissionList)
end

function var0_0.UpdateDelegationTabItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19 + 1

	setActive(arg0_19:findTF("select", arg2_19), arg0_19.selectedIdx == var0_19)
	setActive(arg0_19:findTF("unselect", arg2_19), arg0_19.selectedIdx ~= var0_19)

	local var1_19 = arg0_19.placeCommissionList[var0_19]
	local var2_19 = pg.island_production_commission[var1_19].slot
	local var3_19 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_19.placeId):GetDelegationSlotData(var2_19)

	setActive(arg0_19:findTF("lock", arg2_19), not var3_19)
	setButtonEnabled(arg2_19, var3_19 ~= nil)

	if arg0_19.selectedIdx == var0_19 then
		arg0_19.selectPanel:ExecuteAction("Flush")
	end

	if not var3_19 then
		setActive(arg0_19:findTF("complete ", arg2_19), false)
		setActive(arg0_19:findTF("product_icon", arg2_19), false)

		return
	end

	local var4_19 = var3_19:GetSlotRoleData()
	local var5_19 = var3_19:GetSlotRewardData()
	local var6_19 = var4_19 == nil and var5_19 ~= nil

	setActive(arg0_19:findTF("complete ", arg2_19), var6_19)

	local var7_19 = var4_19 and var4_19.formula_id or nil

	var7_19 = var7_19 or var5_19 and var5_19.formula_id or nil

	if var7_19 then
		setActive(arg0_19:findTF("product_icon", arg2_19), true)

		local var8_19 = pg.island_formula[var7_19]
		local var9_19 = pg.island_item_data_template[var8_19.item_id]

		GetImageSpriteFromAtlasAsync("island/" .. var9_19.icon, "", arg0_19:findTF("product_icon", arg2_19))
	else
		setActive(arg0_19:findTF("product_icon", arg2_19), false)
	end
end

function var0_0.Flush(arg0_20)
	arg0_20.delegationList:align(#arg0_20.placeCommissionList)
	arg0_20.delegationTabList:align(#arg0_20.placeCommissionList)
end

function var0_0.OnShow(arg0_21, arg1_21, arg2_21)
	if arg1_21 then
		arg0_21.placeId = arg1_21
	else
		arg0_21.placeId = arg0_21.npcToPlaceCfg[arg2_21][1]
	end

	arg0_21.placeCfg = pg.island_production_place[arg0_21.placeId]
	arg0_21.placeCommissionList = arg0_21.placeCfg.commission_slot

	if arg0_21.placeCfg.delegationCamera then
		IslandCameraMgr.instance:ActiveVirtualCamera(arg0_21.placeCfg.delegationCamera)
	end

	arg0_21.timeMgr = pg.TimeMgr.GetInstance()
	arg0_21.selectedShip = arg0_21.contextData.selectedShip

	arg0_21:DefaultTargetTabIndex()

	if arg0_21.selectedShip then
		arg0_21:LoadPreconcenCharacter(arg0_21.selectedShip)
	end

	arg0_21:StopTimer()
	arg0_21:StartTimer()
	setText(arg0_21:findTF("top/title/Text"), arg0_21.placeCfg.name)
	setText(arg0_21:findTF("top/title/Text/en"), "PRODUCTING")
end

function var0_0.DefaultTargetTabIndex(arg0_22)
	local var0_22 = arg0_22.contextData.selectedIdx or 1

	arg0_22:OnSelectTargetIndexCommission(var0_22 - 1, true)
end

function var0_0.OnHide(arg0_23)
	arg0_23:StopTimer()
	arg0_23:emitCore(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT)
	arg0_23:UnloadPreconcenCharacter()

	if arg0_23.awardDisplayPanel then
		arg0_23.awardDisplayPanel:Hide()
	end
end

function var0_0.OnExit(arg0_24)
	arg0_24.contextData.selectedIdx = nil
	arg0_24.contextData.selectedShip = nil
end

function var0_0.StartTimer(arg0_25)
	setActive(arg0_25.content, false)

	arg0_25.timer = Timer.New(function()
		setActive(arg0_25.content, true)
		arg0_25:Flush()
	end, var1_0, 0)

	arg0_25.timer:Start()
end

function var0_0.StopTimer(arg0_27)
	if arg0_27.timer ~= nil then
		arg0_27.timer:Stop()

		arg0_27.timer = nil
	end
end

function var0_0.OnDestroy(arg0_28)
	arg0_28:StopTimer()

	if arg0_28.selectPanel then
		arg0_28.selectPanel:Destroy()

		arg0_28.selectPanel = nil
	end

	if arg0_28.awardDisplayPanel then
		arg0_28.awardDisplayPanel:Destroy()

		arg0_28.awardDisplayPanel = nil
	end
end

function var0_0.OnGetDelegationAwardDone(arg0_29, arg1_29)
	if arg1_29.addShipExpData then
		local var0_29 = {}
		local var1_29 = arg1_29.addShipExpData.addShipId
		local var2_29 = arg1_29.addShipExpData.addExp
		local var3_29 = IslandShip.StaticGetPrefab(var1_29)
		local var4_29 = "island/IslandShipIcon/" .. var3_29

		arg0_29:UpdateMainAwardReward({
			shipExp = true,
			icon = var4_29,
			num = var2_29
		})
	end

	arg0_29.delegationTabList:align(#arg0_29.placeCommissionList)
end

function var0_0.OnFinishDelegationDone(arg0_30, arg1_30)
	if arg1_30.addShipExpData then
		local var0_30 = {}
		local var1_30 = arg1_30.addShipExpData.addShipId
		local var2_30 = arg1_30.addShipExpData.addExp
		local var3_30 = IslandShip.StaticGetPrefab(var1_30)
		local var4_30 = "island/IslandShipIcon/" .. var3_30

		arg0_30:UpdateMainAwardReward({
			shipExp = true,
			icon = var4_30,
			num = var2_30
		})
	end

	arg0_30.delegationTabList:align(#arg0_30.placeCommissionList)
end

function var0_0.OnUseTicketDone(arg0_31, arg1_31)
	if arg1_31.type == IslandUseTicketCommand.TYPES.APPOINT then
		arg0_31.delegationTabList:align(#arg0_31.placeCommissionList)
	end
end

function var0_0.OnDelegationStartDone(arg0_32)
	arg0_32.delegationTabList:align(#arg0_32.placeCommissionList)
end

function var0_0.LoadPreconcenCharacter(arg0_33, arg1_33)
	arg0_33:UnloadPreconcenCharacter()

	local var0_33 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_33)
	local var1_33 = arg0_33.placeCommissionList[arg0_33.selectedIdx]
	local var2_33 = pg.island_production_commission[var1_33].birthplace

	arg0_33:emitCore(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, var0_33:GetModel(), var2_33)
end

function var0_0.UnloadPreconcenCharacter(arg0_34)
	arg0_34:emitCore(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE)
end

function var0_0.UpdateMainAwardReward(arg0_35, arg1_35)
	arg0_35.awardDisplayPanel:ExecuteAction("ShowAwards", arg1_35)
end

return var0_0
