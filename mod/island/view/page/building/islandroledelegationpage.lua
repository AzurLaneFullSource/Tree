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
	arg0_4.backBtn = arg0_4._tf:Find("top/back")
	arg0_4.title = arg0_4._tf:Find("top/title")
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

	arg0_4.selectPanel = IslandDelegationSelectPanel.New(arg0_4._tf, arg0_4.event, setmetatable({
		alignRight = true,
		isPermanent = true,
		ShowMsgBox = function(arg0_7, arg1_7)
			arg0_4:ShowMsgBox(arg1_7)
		end
	}, {
		__index = arg0_4.contextData
	}))
	arg0_4.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_4._tf, arg0_4.event)
end

function var0_0.OnInit(arg0_8)
	arg0_8:InitPlaceCfg()
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:Hide()
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_commission.tip
		})
	end, SFX_PANEL)
end

function var0_0.InitPlaceCfg(arg0_11)
	arg0_11.npcToPlaceCfg = {}

	for iter0_11, iter1_11 in ipairs(pg.island_production_place.all) do
		local var0_11 = pg.island_production_place[iter1_11]

		if not arg0_11.npcToPlaceCfg[var0_11.npc_birthplace] then
			arg0_11.npcToPlaceCfg[var0_11.npc_birthplace] = {}
		end

		table.insert(arg0_11.npcToPlaceCfg[var0_11.npc_birthplace], iter1_11)
	end
end

function var0_0.InitDelegationTabItem(arg0_12, arg1_12, arg2_12)
	onButton(arg0_12, arg2_12, function()
		arg0_12:OnSelectTargetIndexCommission(arg1_12)
	end, SFX_PANEL)
end

function var0_0.InitDelegationItem(arg0_14, arg1_14, arg2_14)
	onButton(arg0_14, arg2_14, function()
		arg0_14:OnSelectTargetIndexCommission(arg1_14)
	end, SFX_PANEL)
end

function var0_0.UpdateDelegationItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.placeCommissionList[arg1_16 + 1]
	local var1_16 = pg.island_production_commission[var0_16]
	local var2_16 = pg.island_world_objects[var1_16.birthplace].param.position
	local var3_16 = Vector3(var2_16[1], var2_16[2], var2_16[3])
	local var4_16 = pg.island_world_objects[var1_16.birthplace].param.rotation
	local var5_16 = Vector3(var4_16[1], var4_16[2], var4_16[3])
	local var6_16 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_16.content, var3_16)

	arg2_16.transform.localPosition = var6_16 + var2_0

	setActive(arg2_16:Find("select"), false)
	setActive(arg2_16:Find("unselect"), false)

	local var7_16 = arg1_16 + 1
	local var8_16 = arg0_16.placeCommissionList[var7_16]
	local var9_16 = pg.island_production_commission[var8_16].slot
	local var10_16 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_16.placeId):GetDelegationSlotData(var9_16)

	setButtonEnabled(arg2_16, var10_16 ~= nil)

	local var11_16 = arg1_16 + 1

	arg0_16:emitCore(ISLAND_EVT.SELECTDELEEFFECT_SHOW, var11_16, arg0_16.selectedIdx, var3_16, var5_16)
end

function var0_0.OnSelectTargetIndexCommission(arg0_17, arg1_17, arg2_17)
	if arg0_17.selectedIdx == arg1_17 + 1 and not arg2_17 then
		return
	end

	if not arg2_17 then
		arg0_17.selectedShip = nil

		arg0_17:UnloadPreconcenCharacter()
	end

	arg0_17.selectedIdx = arg1_17 + 1
	arg0_17.contextData.selectedIdx = arg0_17.selectedIdx

	local var0_17 = arg0_17.placeCommissionList[arg0_17.selectedIdx]

	arg0_17.selectPanel:ExecuteAction("Show", var0_17, arg0_17.selectedShip, function(arg0_18)
		arg0_17.contextData.selectedShip = arg0_18
		arg0_17.selectedShip = arg0_18

		arg0_17:LoadPreconcenCharacter(arg0_18)
	end, function()
		arg0_17.contextData.selectedShip = nil
		arg0_17.selectedShip = nil

		arg0_17:UnloadPreconcenCharacter()
	end)
	arg0_17.delegationTabList:align(#arg0_17.placeCommissionList)
	arg0_17.delegationList:align(#arg0_17.placeCommissionList)
end

function var0_0.UpdateDelegationTabItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg1_20 + 1

	setActive(arg2_20:Find("select"), arg0_20.selectedIdx == var0_20)
	setActive(arg2_20:Find("unselect"), arg0_20.selectedIdx ~= var0_20)

	local var1_20 = arg0_20.placeCommissionList[var0_20]
	local var2_20 = pg.island_production_commission[var1_20].slot
	local var3_20 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_20.placeId):GetDelegationSlotData(var2_20)

	setActive(arg2_20:Find("lock"), not var3_20)
	setActive(arg2_20:Find("slotName"), var3_20)
	setButtonEnabled(arg2_20, var3_20 ~= nil)

	if arg0_20.selectedIdx == var0_20 then
		arg0_20.selectPanel:ExecuteAction("Flush")
	end

	if not var3_20 then
		setActive(arg2_20:Find("complete "), false)
		setActive(arg2_20:Find("product_icon"), false)

		return
	end

	local var4_20 = var3_20:GetSlotRoleData()
	local var5_20 = var3_20:GetSlotRewardData()
	local var6_20 = var4_20 == nil and var5_20 ~= nil

	setActive(arg2_20:Find("complete "), var6_20)

	local var7_20 = var4_20 and var4_20.formula_id or nil

	var7_20 = var7_20 or var5_20 and var5_20.formula_id or nil

	if var7_20 then
		setActive(arg2_20:Find("product_icon"), true)

		local var8_20 = pg.island_formula[var7_20]
		local var9_20 = pg.island_item_data_template[var8_20.item_id]

		GetImageSpriteFromAtlasAsync("island/" .. var9_20.icon, "", arg2_20:Find("product_icon"))
	else
		setActive(arg2_20:Find("product_icon"), false)
	end
end

function var0_0.Flush(arg0_21)
	arg0_21.delegationList:align(#arg0_21.placeCommissionList)
	arg0_21.delegationTabList:align(#arg0_21.placeCommissionList)
end

function var0_0.OnShow(arg0_22, arg1_22, arg2_22)
	if arg1_22 then
		arg0_22.placeId = arg1_22
	else
		arg0_22.placeId = arg0_22.npcToPlaceCfg[arg2_22][1]
	end

	arg0_22.placeCfg = pg.island_production_place[arg0_22.placeId]
	arg0_22.placeCommissionList = arg0_22.placeCfg.commission_slot

	if arg0_22.placeCfg.delegationCamera then
		IslandCameraMgr.instance:ActiveVirtualCamera(arg0_22.placeCfg.delegationCamera)
	end

	arg0_22.timeMgr = pg.TimeMgr.GetInstance()
	arg0_22.selectedShip = arg0_22.contextData.selectedShip

	arg0_22:DefaultTargetTabIndex()

	if arg0_22.selectedShip then
		arg0_22:LoadPreconcenCharacter(arg0_22.selectedShip)
	end

	arg0_22:StopTimer()
	arg0_22:StartTimer()
	setText(arg0_22._tf:Find("top/title/Text"), arg0_22.placeCfg.name)
	setText(arg0_22._tf:Find("top/title/Text/en"), "PRODUCTING")
end

function var0_0.DefaultTargetTabIndex(arg0_23)
	local var0_23 = arg0_23.contextData.selectedIdx or 1

	arg0_23:OnSelectTargetIndexCommission(var0_23 - 1, true)
end

function var0_0.OnHide(arg0_24)
	arg0_24:StopTimer()
	arg0_24:emitCore(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT)
	arg0_24:UnloadPreconcenCharacter()

	if arg0_24.awardDisplayPanel then
		arg0_24.awardDisplayPanel:Hide()
	end
end

function var0_0.OnExit(arg0_25)
	arg0_25.contextData.selectedIdx = nil
	arg0_25.contextData.selectedShip = nil

	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
end

function var0_0.StartTimer(arg0_26)
	setActive(arg0_26.content, false)

	arg0_26.timer = Timer.New(function()
		setActive(arg0_26.content, true)
		arg0_26:Flush()
	end, var1_0, 0)

	arg0_26.timer:Start()
end

function var0_0.StopTimer(arg0_28)
	if arg0_28.timer ~= nil then
		arg0_28.timer:Stop()

		arg0_28.timer = nil
	end
end

function var0_0.OnDestroy(arg0_29)
	arg0_29:StopTimer()

	if arg0_29.selectPanel then
		arg0_29.selectPanel:Destroy()

		arg0_29.selectPanel = nil
	end

	if arg0_29.awardDisplayPanel then
		arg0_29.awardDisplayPanel:Destroy()

		arg0_29.awardDisplayPanel = nil
	end
end

function var0_0.OnGetDelegationAwardDone(arg0_30, arg1_30)
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

function var0_0.OnFinishDelegationDone(arg0_31, arg1_31)
	if arg1_31.addShipExpData then
		local var0_31 = {}
		local var1_31 = arg1_31.addShipExpData.addShipId
		local var2_31 = arg1_31.addShipExpData.addExp
		local var3_31 = IslandShip.StaticGetPrefab(var1_31)
		local var4_31 = "island/IslandShipIcon/" .. var3_31

		arg0_31:UpdateMainAwardReward({
			shipExp = true,
			icon = var4_31,
			num = var2_31
		})
	end

	arg0_31.delegationTabList:align(#arg0_31.placeCommissionList)
end

function var0_0.OnUseTicketDone(arg0_32, arg1_32)
	if arg1_32.type == IslandUseTicketCommand.TYPES.APPOINT then
		arg0_32.delegationTabList:align(#arg0_32.placeCommissionList)
	end
end

function var0_0.OnDelegationStartDone(arg0_33)
	arg0_33.delegationTabList:align(#arg0_33.placeCommissionList)
end

function var0_0.LoadPreconcenCharacter(arg0_34, arg1_34)
	arg0_34:UnloadPreconcenCharacter()

	local var0_34 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_34)
	local var1_34 = arg0_34.placeCommissionList[arg0_34.selectedIdx]
	local var2_34 = pg.island_production_commission[var1_34].birthplace

	arg0_34:emitCore(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, var0_34:GetModel(), var2_34)
end

function var0_0.UnloadPreconcenCharacter(arg0_35)
	arg0_35:emitCore(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE)
end

function var0_0.UpdateMainAwardReward(arg0_36, arg1_36)
	arg0_36.awardDisplayPanel:ExecuteAction("ShowAwards", arg1_36)
end

return var0_0
