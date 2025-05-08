local var0_0 = class("IslandView", import(".IslandBaseView"))

function var0_0.Init(arg0_1)
	arg0_1.isInit = false
	arg0_1.unitList = {}
	arg0_1.systems = {}
	arg0_1.systemUnitList = {}
	arg0_1.unitBuilders = {
		[IslandConst.UNIT_TYPE_ITEM] = IslandStaticUnitBuilder.New(arg0_1),
		[IslandConst.UNIT_TYPE_CHAR] = IslandNpcBuilder.New(arg0_1),
		[IslandConst.UNIT_TYPE_VISITOR] = IslandNpcBuilder.New(arg0_1),
		[IslandConst.UNIT_TYPE_PLAYER] = IslandPlayerBuilder.New(arg0_1),
		[IslandConst.UNIT_TYPE_SYSTEM] = IslandSystemNpcBuilder.New(arg0_1),
		[IslandConst.UNIT_TYPE_ITEM_INTERACT] = IslandStaticUnitBuilder.New(arg0_1)
	}
	arg0_1.detectionSystem = IslandDetectionSystem.New(arg0_1)
	arg0_1.views = {
		arg0_1:CreateOpView(),
		arg0_1:CreateSlotHudView(),
		arg0_1:CreateBubbleView()
	}

	for iter0_1, iter1_1 in ipairs(arg0_1.views) do
		iter1_1:Init()
	end
end

function var0_0.GetSubView(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.views) do
		if isa(iter1_2, arg1_2) then
			return iter1_2
		end
	end

	return nil
end

function var0_0.CreateBubbleView(arg0_3)
	return IslandChatBubbleView.New(arg0_3)
end

function var0_0.CreateOpView(arg0_4)
	return IslandOpView.New(arg0_4)
end

function var0_0.CreateSlotHudView(arg0_5)
	return IslandSlotHudView.New(arg0_5)
end

function var0_0.IsLoaded(arg0_6)
	return _.all(arg0_6.views, function(arg0_7)
		return arg0_7:IsLoaded()
	end) and #arg0_6.unitList > 0 and _.all(arg0_6.unitList, function(arg0_8)
		return arg0_8:IsLoaded()
	end) and (#arg0_6.systems == 0 or _.all(arg0_6.systems, function(arg0_9)
		return arg0_9:IsLoaded()
	end)) and (#arg0_6.systemUnitList == 0 or _.all(arg0_6.systemUnitList, function(arg0_10)
		return arg0_10:IsLoaded()
	end))
end

function var0_0.Update(arg0_11)
	if not arg0_11.isInit then
		return
	end

	for iter0_11, iter1_11 in ipairs(arg0_11.unitList) do
		iter1_11:Update()
	end

	for iter2_11, iter3_11 in ipairs(arg0_11.views) do
		iter3_11:Update()
	end

	for iter4_11, iter5_11 in ipairs(arg0_11.systems) do
		iter5_11:Update()
	end

	for iter6_11, iter7_11 in ipairs(arg0_11.systemUnitList) do
		iter7_11:Update()
	end
end

function var0_0.LateUpdate(arg0_12)
	if not arg0_12.isInit then
		return
	end

	for iter0_12, iter1_12 in ipairs(arg0_12.unitList) do
		iter1_12:LateUpdate()
	end

	for iter2_12, iter3_12 in ipairs(arg0_12.views) do
		iter3_12:LateUpdate()
	end

	for iter4_12, iter5_12 in ipairs(arg0_12.systems) do
		iter5_12:LateUpdate()
	end

	for iter6_12, iter7_12 in ipairs(arg0_12.systemUnitList) do
		iter7_12:LateUpdate()
	end
end

function var0_0.AddListeners(arg0_13)
	arg0_13:AddListener(ISLAND_EVT.GEN_UNIT, arg0_13.OnGenUnit)
	arg0_13:AddListener(ISLAND_EVT.RMOVE_UNIT, arg0_13.OnRemoveUnit)
	arg0_13:AddListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_13.OnInterActionBegin)
	arg0_13:AddListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_13.OnInterActionEnd)
	arg0_13:AddListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_13.OnStopUnit)
	arg0_13:AddListener(ISLAND_EVT.MOVE_UNIT, arg0_13.OnMoveUnit)
	arg0_13:AddListener(ISLAND_EVT.INIT_FINISH, arg0_13.OnSceneInited)
	arg0_13:AddListener(ISLAND_EVT.MOVE_PLAYER, arg0_13.OnPlayerMove)
	arg0_13:AddListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_13.OnPlayerStopMove)
	arg0_13:AddListener(ISLAND_EVT.JUMP_PLAYER, arg0_13.OnPlayerJump)
	arg0_13:AddListener(ISLAND_EVT.PLANT, arg0_13.OnPlayerPlant)
	arg0_13:AddListener(ISLAND_EVT.APPROACH_UNIT, arg0_13.OnShowInterActionPanel)
	arg0_13:AddListener(ISLAND_EVT.LEAVE_UNIT, arg0_13.OnHideInterActionPanel)
	arg0_13:AddListener(ISLAND_EVT.TRACKING, arg0_13.OnTracking)
	arg0_13:AddListener(ISLAND_EVT.UNTRACKING, arg0_13.OnUnTracking)
	arg0_13:AddListener(ISLAND_EVT.AREACHANGE, arg0_13.OnPlayerAreaChange)
	arg0_13:AddListener(ISLAND_EVT.PLAYERRUN, arg0_13.OnPlayerPlayerRun)
	arg0_13:AddListener(ISLAND_EVT.SPRINT_PLAYER, arg0_13.OnPlayerPlayerSprint)
	arg0_13:AddListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_13.OnStopPlayerSprint)
	arg0_13:AddListener(ISLAND_EVT.SYNC_INTERACTION, arg0_13.OnSyncInteraction)
	arg0_13:AddListener(ISLAND_EVT.CHANGE_DRESS, arg0_13.OnChangeDress)
	arg0_13:AddListener(ISLAND_EVT.RESET_UNIT_POS, arg0_13.OnResetUnitPos)
	arg0_13:AddListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_13.OnAnyPageOpen)
	arg0_13:AddListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_13.OnAllPageClose)
	arg0_13:AddListener(ISLAND_EVT.PLAY_BUBBLE, arg0_13.OnPlayChatBubble)
	arg0_13:AddListener(ISLAND_EVT.START_STORY, arg0_13.OnStartStory)
	arg0_13:AddListener(ISLAND_EVT.END_STORY, arg0_13.OnEndStory)
	arg0_13:AddListener(ISLAND_EVT.START_DEGATION, arg0_13.OnStartDelegation)
	arg0_13:AddListener(ISLAND_EVT.END_DEGATION, arg0_13.OnEndDelegation)
	arg0_13:AddListener(ISLAND_EVT.GEN_SYSTEM, arg0_13.OnGenSystem)
	arg0_13:AddListener(ISLAND_EVT.GEN_SYSTEM_UNIT, arg0_13.OnCreateSystemUnit)
	arg0_13:AddListener(ISLAND_EVT.RMOVE_TYPE_UNIT, arg0_13.OnRemoveTypeUnit)
	arg0_13:AddListener(ISLAND_EVT.REMOVE_SYSTEM_UNIT, arg0_13.OnRemoveSystemUnit)
end

function var0_0.RemoveListeners(arg0_14)
	arg0_14:RemoveListener(ISLAND_EVT.GEN_UNIT, arg0_14.OnGenUnit)
	arg0_14:RemoveListener(ISLAND_EVT.RMOVE_UNIT, arg0_14.OnRemoveUnit)
	arg0_14:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_14.OnInterActionBegin)
	arg0_14:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_14.OnInterActionEnd)
	arg0_14:RemoveListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_14.OnStopUnit)
	arg0_14:RemoveListener(ISLAND_EVT.MOVE_UNIT, arg0_14.OnMoveUnit)
	arg0_14:RemoveListener(ISLAND_EVT.INIT_FINISH, arg0_14.OnSceneInited)
	arg0_14:RemoveListener(ISLAND_EVT.MOVE_PLAYER, arg0_14.OnPlayerMove)
	arg0_14:RemoveListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_14.OnPlayerStopMove)
	arg0_14:RemoveListener(ISLAND_EVT.JUMP_PLAYER, arg0_14.OnPlayerJump)
	arg0_14:RemoveListener(ISLAND_EVT.PLANT, arg0_14.OnPlayerPlant)
	arg0_14:RemoveListener(ISLAND_EVT.APPROACH_UNIT, arg0_14.OnShowInterActionPanel)
	arg0_14:RemoveListener(ISLAND_EVT.LEAVE_UNIT, arg0_14.OnHideInterActionPanel)
	arg0_14:RemoveListener(ISLAND_EVT.TRACKING, arg0_14.OnTracking)
	arg0_14:RemoveListener(ISLAND_EVT.UNTRACKING, arg0_14.OnUnTracking)
	arg0_14:RemoveListener(ISLAND_EVT.AREACHANGE, arg0_14.OnPlayerAreaChange)
	arg0_14:RemoveListener(ISLAND_EVT.PLAYERRUN, arg0_14.OnPlayerPlayerRun)
	arg0_14:RemoveListener(ISLAND_EVT.SPRINT_PLAYER, arg0_14.OnPlayerPlayerSprint)
	arg0_14:RemoveListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_14.OnStopPlayerSprint)
	arg0_14:RemoveListener(ISLAND_EVT.SYNC_INTERACTION, arg0_14.OnSyncInteraction)
	arg0_14:RemoveListener(ISLAND_EVT.CHANGE_DRESS, arg0_14.OnChangeDress)
	arg0_14:RemoveListener(ISLAND_EVT.RESET_UNIT_POS, arg0_14.OnResetUnitPos)
	arg0_14:RemoveListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_14.OnAnyPageOpen)
	arg0_14:RemoveListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_14.OnAllPageClose)
	arg0_14:RemoveListener(ISLAND_EVT.PLAY_BUBBLE, arg0_14.OnPlayChatBubble)
	arg0_14:RemoveListener(ISLAND_EVT.START_STORY, arg0_14.OnStartStory)
	arg0_14:RemoveListener(ISLAND_EVT.END_STORY, arg0_14.OnEndStory)
	arg0_14:RemoveListener(ISLAND_EVT.START_DEGATION, arg0_14.OnStartDelegation)
	arg0_14:RemoveListener(ISLAND_EVT.END_DEGATION, arg0_14.OnEndDelegation)
	arg0_14:RemoveListener(ISLAND_EVT.GEN_SYSTEM, arg0_14.OnGenSystem)
	arg0_14:RemoveListener(ISLAND_EVT.GEN_SYSTEM_UNIT, arg0_14.OnCreateSystemUnit)
	arg0_14:RemoveListener(ISLAND_EVT.RMOVE_TYPE_UNIT, arg0_14.OnRemoveTypeUnit)
	arg0_14:RemoveListener(ISLAND_EVT.REMOVE_SYSTEM_UNIT, arg0_14.OnRemoveSystemUnit)
end

function var0_0.OnGenSystem(arg0_15, arg1_15)
	local var0_15 = IslandCharacterSystem.New(arg0_15, arg1_15)

	table.insert(arg0_15.systems, var0_15)
end

function var0_0.OnStartStory(arg0_16)
	arg0_16.player:StopMoveHandle()
	arg0_16:GetSubView(IslandChatBubbleView):Disable()
	arg0_16:GetSubView(IslandOpView):DisablePlayerOp()
	arg0_16:GetSubView(IslandOpView):Hide()
end

function var0_0.OnEndStory(arg0_17)
	arg0_17:GetSubView(IslandOpView):EnablePlayerOp()
	arg0_17:GetSubView(IslandChatBubbleView):Enable()
	arg0_17:GetSubView(IslandOpView):Show()
end

function var0_0.OnPlayChatBubble(arg0_18, arg1_18)
	local var0_18 = arg0_18:GetUnitList()

	arg0_18:GetSubView(IslandChatBubbleView):Play(arg1_18.name, var0_18, arg1_18.callback)
end

function var0_0.OnAnyPageOpen(arg0_19, arg1_19)
	arg0_19.player:StopMoveHandle()
	arg0_19:GetSubView(IslandChatBubbleView):Disable()
	arg0_19:GetSubView(IslandOpView):DisablePlayerOp()
end

function var0_0.OnAllPageClose(arg0_20)
	arg0_20:GetSubView(IslandChatBubbleView):Enable()
	arg0_20:GetSubView(IslandOpView):EnablePlayerOp()
end

function var0_0.OnResetUnitPos(arg0_21, arg1_21, arg2_21)
	arg0_21:GetUnitModule(arg1_21)._go.transform.position = AgoraCalc.MapPosition2WorldPosition(arg2_21)
end

function var0_0.OnGenUnit(arg0_22, arg1_22)
	local var0_22 = arg0_22.unitBuilders[arg1_22:GetType()]:Build(arg1_22)

	table.insert(arg0_22.unitList, var0_22)

	if arg1_22:IsPlayer() then
		arg0_22.player = var0_22
	end
end

function var0_0.OnRemoveUnit(arg0_23, arg1_23)
	local var0_23 = 0

	for iter0_23, iter1_23 in ipairs(arg0_23.unitList or {}) do
		if iter1_23.id == arg1_23 then
			var0_23 = iter0_23

			break
		end
	end

	if var0_23 > 0 then
		local var1_23 = arg0_23.unitList[var0_23]

		table.removebyvalue(arg0_23.unitList, var1_23)
		var1_23:Dispose()
	end
end

function var0_0.OnRemoveSystemUnit(arg0_24, arg1_24)
	local var0_24 = 0

	for iter0_24, iter1_24 in ipairs(arg0_24.systemUnitList or {}) do
		if iter1_24.id == arg1_24 then
			var0_24 = iter0_24

			break
		end
	end

	if var0_24 > 0 then
		local var1_24 = arg0_24.systemUnitList[var0_24]

		table.removebyvalue(arg0_24.systemUnitList, var1_24)
		var1_24:Dispose()
	end
end

function var0_0.OnRemoveTypeUnit(arg0_25, arg1_25, arg2_25)
	if arg1_25 then
		arg0_25:OnRemoveSystemUnit(arg2_25)
	else
		arg0_25:OnRemoveUnit(arg2_25)
	end
end

function var0_0.OnSceneInited(arg0_26)
	IslandCameraMgr.instance:LookAt(arg0_26.player._tf)

	for iter0_26, iter1_26 in ipairs(arg0_26.unitList) do
		iter1_26:Start()
	end

	for iter2_26, iter3_26 in ipairs(arg0_26.systemUnitList) do
		iter3_26:Start()
	end

	for iter4_26, iter5_26 in ipairs(arg0_26.systems) do
		iter5_26:Start()
	end

	arg0_26.isInit = true
end

function var0_0.IsInit(arg0_27)
	return arg0_27.isInit
end

function var0_0.OnMoveUnit(arg0_28, arg1_28)
	if arg1_28.isSystem then
		local var0_28 = arg0_28:GetSystemUnitModule(arg1_28.id)

		if var0_28 then
			var0_28:SetDestination(arg1_28.position, arg1_28.speed)
		end
	else
		local var1_28 = arg0_28:GetUnitModule(arg1_28.id)

		if var1_28 then
			var1_28:SetDestination(arg1_28.position, arg1_28.speed)
		end
	end
end

function var0_0.OnStopUnit(arg0_29, arg1_29)
	if arg1_29.isSystem then
		local var0_29 = arg0_29:GetSystemUnitModule(arg1_29.id)

		if var0_29 then
			var0_29:StopMove()
		end
	else
		local var1_29 = arg0_29:GetUnitModule(arg1_29.id)

		if var1_29 then
			var1_29:StopMove()
		end
	end
end

function var0_0.OnInterActionBegin(arg0_30)
	arg0_30.player:StopMoveHandle()
	arg0_30:GetSubView(IslandOpView):DisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_31)
	arg0_31:GetSubView(IslandOpView):EnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_32, arg1_32)
	arg0_32.showInterObjId = arg1_32.id

	arg0_32.detectionSystem:CrossDetectionHandle(arg1_32)
	arg0_32:GetSubView(IslandOpView):ShowInterActionPanel(arg1_32)
	arg0_32:GetSubView(IslandSlotHudView):HandleHud(arg1_32)
end

function var0_0.OnHideInterActionPanel(arg0_33, arg1_33)
	if arg0_33.showInterObjId ~= arg1_33.id then
		return
	end

	arg0_33.showInterObjId = nil

	arg0_33:GetSubView(IslandOpView):HideInterActionPanel()
end

function var0_0.OnTracking(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetUnitModule(tonumber(arg1_34.id))

	if not var0_34 then
		return
	end

	arg0_34:GetSubView(IslandOpView):SetTrackingTarget(arg0_34.player, var0_34)
end

function var0_0.OnUnTracking(arg0_35)
	arg0_35:GetSubView(IslandOpView):CancelTracking()
end

function var0_0.OnPlayerMove(arg0_36, arg1_36)
	arg0_36.player:MoveHandle(arg1_36.targetDir, arg1_36.force)
end

function var0_0.OnPlayerStopMove(arg0_37)
	arg0_37.player:StopMoveHandle()
end

function var0_0.OnPlayerJump(arg0_38)
	arg0_38.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_39)
	arg0_39.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_40)
	arg0_40.player:OnPlayerPlayerSprint()
end

function var0_0.OnStopPlayerSprint(arg0_41)
	arg0_41.player:OnStopPlayerSprint()
end

function var0_0.DisableOp(arg0_42)
	arg0_42:GetSubView(IslandOpView):DisablePlayerOp()
	arg0_42:GetSubView(IslandOpView):Hide()
end

function var0_0.EnableOp(arg0_43)
	arg0_43:GetSubView(IslandOpView):EnablePlayerOp()
	arg0_43:GetSubView(IslandOpView):Show()
end

function var0_0.GetUnitModule(arg0_44, arg1_44)
	for iter0_44, iter1_44 in ipairs(arg0_44.unitList or {}) do
		if iter1_44.id == arg1_44 then
			return iter1_44
		end
	end

	return nil
end

function var0_0.GetUnitList(arg0_45)
	return arg0_45.unitList or {}
end

function var0_0.GetSystem(arg0_46, arg1_46)
	for iter0_46, iter1_46 in ipairs(arg0_46.systems or {}) do
		if iter1_46.id == arg1_46 then
			return iter1_46
		end
	end

	return nil
end

function var0_0.GetSystemList(arg0_47)
	return arg0_47.systems
end

function var0_0.GetSystemModule(arg0_48, arg1_48)
	for iter0_48, iter1_48 in ipairs(arg0_48.systems or {}) do
		if iter1_48.id == arg1_48 then
			return iter1_48
		end
	end

	return nil
end

function var0_0.GetSystemUnitModule(arg0_49, arg1_49)
	for iter0_49, iter1_49 in ipairs(arg0_49.systemUnitList or {}) do
		if iter1_49.id == arg1_49 then
			return iter1_49
		end
	end

	return nil
end

function var0_0.GetSystemUnitList(arg0_50)
	return arg0_50.systemUnitList
end

function var0_0.OnPlayerPlant(arg0_51)
	arg0_51.detectionSystem:OnPlayerPlant()
end

function var0_0.OnPlayerAreaChange(arg0_52)
	arg0_52.detectionSystem:SetAreaDetection()
end

function var0_0.OnSyncInteraction(arg0_53, arg1_53, arg2_53)
	arg0_53:Emit(ISLAND_EVT.SYNC_INTERACTION, arg1_53, arg2_53)
end

function var0_0.OnChangeDress(arg0_54, arg1_54)
	arg0_54.player:OnChangeDress(arg1_54)
end

function var0_0.OnCreateSystemUnit(arg0_55, arg1_55)
	local var0_55 = arg0_55.unitBuilders[arg1_55:GetType()]:Build(arg1_55)

	table.insert(arg0_55.systemUnitList, var0_55)
end

function var0_0.OnStartDelegation(arg0_56, arg1_56)
	local var0_56 = arg0_56:GetSystem(arg1_56.build_id)

	if var0_56 then
		var0_56:StartDelegation(arg1_56)
	end
end

function var0_0.OnEndDelegation(arg0_57, arg1_57)
	local var0_57 = arg0_57:GetSystem(arg1_57.build_id)

	if var0_57 then
		var0_57:EndDelegation(arg1_57)
	end
end

function var0_0.GetPlayerPosition(arg0_58)
	return arg0_58.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_59, arg1_59)
	local var0_59 = arg0_59:GetUnitModule(arg1_59)

	return var0_59 and var0_59._go.transform.position
end

function var0_0.OnDispose(arg0_60)
	for iter0_60, iter1_60 in ipairs(arg0_60.systems or {}) do
		iter1_60:Dispose()
	end

	arg0_60.systems = nil

	for iter2_60, iter3_60 in ipairs(arg0_60.systemUnitList or {}) do
		iter3_60:Dispose()
	end

	arg0_60.systemUnitList = nil

	for iter4_60, iter5_60 in ipairs(arg0_60.views) do
		iter5_60:Dispose()

		arg0_60.views[iter4_60] = nil
	end

	for iter6_60, iter7_60 in ipairs(arg0_60.unitList or {}) do
		iter7_60:Dispose()
	end

	arg0_60.unitList = nil
	arg0_60.player = nil
end

return var0_0
