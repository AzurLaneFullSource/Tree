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
end

function var0_0.InitPlaceCfg(arg0_9)
	arg0_9.npcToPlaceCfg = {}

	for iter0_9, iter1_9 in ipairs(pg.island_production_place.all) do
		local var0_9 = pg.island_production_place[iter1_9]

		if not arg0_9.npcToPlaceCfg[var0_9.npc_birthplace] then
			arg0_9.npcToPlaceCfg[var0_9.npc_birthplace] = {}
		end

		table.insert(arg0_9.npcToPlaceCfg[var0_9.npc_birthplace], iter1_9)
	end
end

function var0_0.InitDelegationTabItem(arg0_10, arg1_10, arg2_10)
	onButton(arg0_10, arg2_10, function()
		arg0_10:OnSelectTargetIndexCommission(arg1_10)
	end, SFX_PANEL)
end

function var0_0.InitDelegationItem(arg0_12, arg1_12, arg2_12)
	onButton(arg0_12, arg2_12, function()
		arg0_12:OnSelectTargetIndexCommission(arg1_12)
	end, SFX_PANEL)
end

function var0_0.UpdateDelegationItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.placeCommissionList[arg1_14 + 1]
	local var1_14 = pg.island_production_commission[var0_14]
	local var2_14 = pg.island_world_objects[var1_14.birthplace].param.position
	local var3_14 = Vector3(var2_14[1], var2_14[2], var2_14[3])
	local var4_14 = pg.island_world_objects[var1_14.birthplace].param.rotation
	local var5_14 = Vector3(var4_14[1], var4_14[2], var4_14[3])
	local var6_14 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_14.content, var3_14)

	arg2_14.transform.localPosition = var6_14 + var2_0

	setActive(arg0_14:findTF("select", arg2_14), false)
	setActive(arg0_14:findTF("unselect", arg2_14), false)

	local var7_14 = arg1_14 + 1
	local var8_14 = arg0_14.placeCommissionList[var7_14]
	local var9_14 = pg.island_production_commission[var8_14].slot
	local var10_14 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_14.placeId):GetDelegationSlotData(var9_14)

	setButtonEnabled(arg2_14, var10_14 ~= nil)

	local var11_14 = arg1_14 + 1

	arg0_14:emitCore(ISLAND_EVT.SELECTDELEEFFECT_SHOW, var11_14, arg0_14.selectedIdx, var3_14, var5_14)
end

function var0_0.OnSelectTargetIndexCommission(arg0_15, arg1_15, arg2_15)
	if arg0_15.selectedIdx == arg1_15 + 1 and not arg2_15 then
		return
	end

	if not arg2_15 then
		arg0_15.selectedShip = nil

		arg0_15:UnloadPreconcenCharacter()
	end

	arg0_15.selectedIdx = arg1_15 + 1
	arg0_15.contextData.selectedIdx = arg0_15.selectedIdx

	local var0_15 = arg0_15.placeCommissionList[arg0_15.selectedIdx]

	arg0_15.selectPanel:ExecuteAction("Show", var0_15, arg0_15.selectedShip, function(arg0_16)
		arg0_15.contextData.selectedShip = arg0_16
		arg0_15.selectedShip = arg0_16

		arg0_15:LoadPreconcenCharacter(arg0_16)
	end, function()
		arg0_15.contextData.selectedShip = nil
		arg0_15.selectedShip = nil

		arg0_15:UnloadPreconcenCharacter()
	end)
	arg0_15.delegationTabList:align(#arg0_15.placeCommissionList)
	arg0_15.delegationList:align(#arg0_15.placeCommissionList)
end

function var0_0.UpdateDelegationTabItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18 + 1

	setActive(arg0_18:findTF("select", arg2_18), arg0_18.selectedIdx == var0_18)
	setActive(arg0_18:findTF("unselect", arg2_18), arg0_18.selectedIdx ~= var0_18)

	local var1_18 = arg0_18.placeCommissionList[var0_18]
	local var2_18 = pg.island_production_commission[var1_18].slot
	local var3_18 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_18.placeId):GetDelegationSlotData(var2_18)

	setActive(arg0_18:findTF("lock", arg2_18), not var3_18)
	setButtonEnabled(arg2_18, var3_18 ~= nil)

	if arg0_18.selectedIdx == var0_18 then
		arg0_18.selectPanel:ExecuteAction("Flush")
	end

	if not var3_18 then
		setActive(arg0_18:findTF("complete ", arg2_18), false)
		setActive(arg0_18:findTF("product_icon", arg2_18), false)

		return
	end

	local var4_18 = var3_18:GetSlotRoleData()
	local var5_18 = var3_18:GetSlotRewardData()
	local var6_18 = var4_18 == nil and var5_18 ~= nil

	setActive(arg0_18:findTF("complete ", arg2_18), var6_18)

	local var7_18 = var4_18 and var4_18.formula_id or nil

	var7_18 = var7_18 or var5_18 and var5_18.formula_id or nil

	if var7_18 then
		setActive(arg0_18:findTF("product_icon", arg2_18), true)

		local var8_18 = pg.island_formula[var7_18]
		local var9_18 = pg.island_item_data_template[var8_18.item_id]

		GetImageSpriteFromAtlasAsync("island/" .. var9_18.icon, "", arg0_18:findTF("product_icon", arg2_18))
	else
		setActive(arg0_18:findTF("product_icon", arg2_18), false)
	end
end

function var0_0.Flush(arg0_19)
	arg0_19.delegationList:align(#arg0_19.placeCommissionList)
	arg0_19.delegationTabList:align(#arg0_19.placeCommissionList)
end

function var0_0.OnShow(arg0_20, arg1_20, arg2_20)
	if arg1_20 then
		arg0_20.placeId = arg1_20
	else
		arg0_20.placeId = arg0_20.npcToPlaceCfg[arg2_20][1]
	end

	arg0_20.placeCfg = pg.island_production_place[arg0_20.placeId]
	arg0_20.placeCommissionList = arg0_20.placeCfg.commission_slot

	if arg0_20.placeCfg.delegationCamera then
		IslandCameraMgr.instance:ActiveVirtualCamera(arg0_20.placeCfg.delegationCamera)
	end

	arg0_20.timeMgr = pg.TimeMgr.GetInstance()
	arg0_20.selectedShip = arg0_20.contextData.selectedShip

	arg0_20:DefaultTargetTabIndex()

	if arg0_20.selectedShip then
		arg0_20:LoadPreconcenCharacter(arg0_20.selectedShip)
	end

	arg0_20:StopTimer()
	arg0_20:StartTimer()
	setText(arg0_20:findTF("top/title/Text"), arg0_20.placeCfg.name)
	setText(arg0_20:findTF("top/title/Text/en"), "PRODUCTING")
end

function var0_0.DefaultTargetTabIndex(arg0_21)
	local var0_21 = arg0_21.contextData.selectedIdx or 1

	arg0_21:OnSelectTargetIndexCommission(var0_21 - 1, true)
end

function var0_0.OnHide(arg0_22)
	arg0_22:StopTimer()
	arg0_22:emitCore(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT)
	arg0_22:UnloadPreconcenCharacter()

	if arg0_22.awardDisplayPanel then
		arg0_22.awardDisplayPanel:Hide()
	end
end

function var0_0.OnExit(arg0_23)
	arg0_23.contextData.selectedIdx = nil
	arg0_23.contextData.selectedShip = nil
end

function var0_0.StartTimer(arg0_24)
	setActive(arg0_24.content, false)

	arg0_24.timer = Timer.New(function()
		setActive(arg0_24.content, true)
		arg0_24:Flush()
	end, var1_0, 0)

	arg0_24.timer:Start()
end

function var0_0.StopTimer(arg0_26)
	if arg0_26.timer ~= nil then
		arg0_26.timer:Stop()

		arg0_26.timer = nil
	end
end

function var0_0.OnDestroy(arg0_27)
	arg0_27:StopTimer()

	if arg0_27.selectPanel then
		arg0_27.selectPanel:Destroy()

		arg0_27.selectPanel = nil
	end

	if arg0_27.awardDisplayPanel then
		arg0_27.awardDisplayPanel:Destroy()

		arg0_27.awardDisplayPanel = nil
	end
end

function var0_0.OnGetDelegationAwardDone(arg0_28, arg1_28)
	if arg1_28.addShipExpData then
		local var0_28 = {}
		local var1_28 = arg1_28.addShipExpData.addShipId
		local var2_28 = arg1_28.addShipExpData.addExp
		local var3_28 = IslandShip.StaticGetPrefab(var1_28)
		local var4_28 = "island/IslandShipIcon/" .. var3_28

		arg0_28:UpdateMainAwardReward({
			shipExp = true,
			icon = var4_28,
			num = var2_28
		})
	end

	arg0_28.delegationTabList:align(#arg0_28.placeCommissionList)
end

function var0_0.OnFinishDelegationDone(arg0_29, arg1_29)
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

function var0_0.OnUseTicketDone(arg0_30, arg1_30)
	if arg1_30.type == IslandUseTicketCommand.TYPES.APPOINT then
		arg0_30.delegationTabList:align(#arg0_30.placeCommissionList)
	end
end

function var0_0.OnDelegationStartDone(arg0_31)
	arg0_31.delegationTabList:align(#arg0_31.placeCommissionList)
end

function var0_0.LoadPreconcenCharacter(arg0_32, arg1_32)
	arg0_32:UnloadPreconcenCharacter()

	local var0_32 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_32)
	local var1_32 = arg0_32.placeCommissionList[arg0_32.selectedIdx]
	local var2_32 = pg.island_production_commission[var1_32].birthplace

	arg0_32:emitCore(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, var0_32:GetModel(), var2_32)
end

function var0_0.UnloadPreconcenCharacter(arg0_33)
	arg0_33:emitCore(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE)
end

function var0_0.UpdateMainAwardReward(arg0_34, arg1_34)
	arg0_34.awardDisplayPanel:ExecuteAction("ShowAwards", arg1_34)
end

return var0_0
