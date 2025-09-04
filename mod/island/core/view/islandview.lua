local var0_0 = class("IslandView", import(".IslandBaseView"))

function var0_0.Init(arg0_1)
	arg0_1._unitList = {}
	arg0_1.isInit = false

	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_OBJ)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_SYSTEM)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_DELEGATION)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_STROLL)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_MANAGE_SYSTEM)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_MANAGE)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_DELEGATION_ANIMATION)

	arg0_1.unitBuilders = {
		[IslandConst.UNIT_TYPE_ITEM] = IslandStaticUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_CHAR] = IslandNpcBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_VISITOR] = IslandVisitorBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_PLAYER] = IslandPlayerBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_ITEM_INTERACT] = IslandItemInteractBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT] = IslandItemHandCollectBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING] = IslandItemHandPlantBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_STROLL] = IslandStrollNpcBuilder.New(arg0_1, IslandConst.UNIT_LIST_STROLL),
		[IslandConst.UNIT_TYPE_SYSTEM] = IslandSystemNpcBuilder.New(arg0_1, IslandConst.UNIT_LIST_DELEGATION),
		[IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM] = IslandItemWildGahterBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM] = IslandItemWildGahterBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_MANAGE_CHARA] = IslandSystemDelegationUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_MANAGE),
		[IslandConst.UNIT_TYPE_MANAGE_ITEM] = IslandStaticUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_MANAGE),
		[IslandConst.UNIT_TYPE_MANAGE_CUSTOMER] = IslandStaticCharaBuilder.New(arg0_1, IslandConst.UNIT_LIST_MANAGE),
		[IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION] = IslandSystemDelegationUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_DELEGATION),
		[IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION] = IslandSystemDelegationUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_DELEGATION_ANIMATION)
	}
	arg0_1.systemBuilders = {
		[IslandConst.SYSTEM_TYPE_CHARACTER] = IslandSystemBuilder.New(arg0_1, IslandCharacterSystem),
		[IslandConst.SYSTEM_TYPE_PRODUCT] = IslandSystemBuilder.New(arg0_1, IslandCharacterSystem),
		[IslandConst.SYSTEM_TYPE_SEEKGAME] = IslandSystemBuilder.New(arg0_1, IslandSeekGameSystem),
		[IslandConst.SYSTEM_TYPE_GROUND] = IslandGroundSystemBuilder.New(arg0_1, IslandGoundLayerSystem),
		[IslandConst.SYSTEM_TYPE_MANAGE] = IslandManageSystemBuilder.New(arg0_1, IslandManageSystem)
	}
	arg0_1.detectionSystem = IslandDetectionSystem.New(arg0_1)
	arg0_1.effectMgr = IslandDelegateEffectMgr.New(arg0_1)
	arg0_1.pathfinders = {}
	arg0_1.views = {
		arg0_1:CreateOpView(),
		arg0_1:CreateSlotHudView(),
		arg0_1:CreateTopHeadHudView(),
		arg0_1:CreateAnimationOpView()
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

function var0_0.CreateOpView(arg0_3)
	return IslandOpView.New(arg0_3)
end

function var0_0.CreateSlotHudView(arg0_4)
	return IslandSlotHudView.New(arg0_4)
end

function var0_0.CreateTopHeadHudView(arg0_5)
	return IslandTopHeadHudView.New(arg0_5)
end

function var0_0.CreateAnimationOpView(arg0_6)
	return IslandAniamtionOpView.New(arg0_6)
end

function var0_0.IsLoaded(arg0_7)
	local var0_7 = arg0_7:GetAllUnits()

	return _.all(arg0_7.views, function(arg0_8)
		return arg0_8:IsLoaded()
	end) and #var0_7 > 0 and _.all(var0_7, function(arg0_9)
		return arg0_9:IsLoaded()
	end)
end

function var0_0.IsInit(arg0_10)
	return arg0_10.isInit
end

function var0_0.Update(arg0_11)
	if not arg0_11.isInit then
		return
	end

	for iter0_11, iter1_11 in ipairs(arg0_11:GetAllUnits()) do
		iter1_11:Update()
	end

	for iter2_11, iter3_11 in ipairs(arg0_11.views) do
		iter3_11:Update()
	end

	for iter4_11, iter5_11 in ipairs(arg0_11.pathfinders) do
		iter5_11:Update()
	end

	if arg0_11.needTryTrack then
		arg0_11:TryTrack()
	end
end

function var0_0.LateUpdate(arg0_12)
	if not arg0_12.isInit then
		return
	end

	for iter0_12, iter1_12 in ipairs(arg0_12:GetAllUnits()) do
		iter1_12:LateUpdate()
	end

	for iter2_12, iter3_12 in ipairs(arg0_12.views) do
		iter3_12:LateUpdate()
	end

	for iter4_12, iter5_12 in ipairs(arg0_12.pathfinders) do
		iter5_12:LateUpdate()
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
	arg0_13:AddListener(ISLAND_EVT.APPROACH_UNIT, arg0_13.OnShowInterActionPanel)
	arg0_13:AddListener(ISLAND_EVT.LEAVE_UNIT, arg0_13.OnHideInterActionPanel)
	arg0_13:AddListener(ISLAND_EVT.TRACKING, arg0_13.OnTracking)
	arg0_13:AddListener(ISLAND_EVT.UNTRACKING, arg0_13.OnUnTracking)
	arg0_13:AddListener(ISLAND_EVT.AREACHANGE, arg0_13.OnPlayerAreaChange)
	arg0_13:AddListener(ISLAND_EVT.PLAYERRUN, arg0_13.OnPlayerPlayerRun)
	arg0_13:AddListener(ISLAND_EVT.SPRINT_PLAYER, arg0_13.OnPlayerPlayerSprint)
	arg0_13:AddListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_13.OnStopPlayerSprint)
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
	arg0_13:AddListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_13.OnWorldObjectStartInteraction)
	arg0_13:AddListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_13.OnWorldObjectEndInteraction)
	arg0_13:AddListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_13.OnWorldObjectInitStatus)
	arg0_13:AddListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_13.OnRefreshInteractionBtn)
	arg0_13:AddListener(ISLAND_EVT.SHOW_UNIT_HUD, arg0_13.OnShowUnitHud)
	arg0_13:AddListener(ISLAND_EVT.HIDE_UNIT_HUD, arg0_13.OnHideUnitHud)
	arg0_13:AddListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_13.OnDetectorChanged)
	arg0_13:AddListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_13.OnDetectorSelected)
	arg0_13:AddListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_13.OnPlayerWork)
	arg0_13:AddListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_13.OnPlayerDeviceStateChange)
	arg0_13:AddListener(ISLAND_EVT.UPDATE_HUD, arg0_13.OnUpdateHud)
	arg0_13:AddListener(ISLAND_EVT.UPDATE_UNIT_HP, arg0_13.OnUpdateUnitHp)
	arg0_13:AddListener(ISLAND_EVT.START_DELEGATE_SLOT_PERFORM, arg0_13.OnDelegateSlotStartPerform)
	arg0_13:AddListener(ISLAND_EVT.LOAD_DELEGATE_SLOT_EFFECCT, arg0_13.OnDelegateSlotEffectInit)
	arg0_13:AddListener(ISLAND_EVT.DEFAULTDELEFFECT_SHOW, arg0_13.OnDefaultSlotEffectShow)
	arg0_13:AddListener(ISLAND_EVT.UPDATE_DELEGATION_EFFECT_POSITION, arg0_13.OnUpdateEffectPos)
	arg0_13:AddListener(ISLAND_EVT.SELECTDELEFFECT_SHOW, arg0_13.OnSelectSlotEffectShow)
	arg0_13:AddListener(ISLAND_EVT.START_MANAGE, arg0_13.OnStartManage)
	arg0_13:AddListener(ISLAND_EVT.END_MANAGE, arg0_13.OnEndManage)
	arg0_13:AddListener(ISLAND_EVT.SHOW_HUD, arg0_13.OnShowHud)
	arg0_13:AddListener(ISLAND_EVT.HIDE_HUD, arg0_13.OnHideHud)
	arg0_13:AddListener(ISLAND_EVT.REFRESH_HUD, arg0_13.OnRefreshHud)
	arg0_13:AddListener(ISLAND_EVT.START_GUIDE, arg0_13.OnStartGuide)
	arg0_13:AddListener(ISLAND_EVT.END_GUIDE, arg0_13.OnEndGuide)
	arg0_13:AddListener(ISLAND_EVT.START_PERFORMANCE, arg0_13.OnStartPerformance)
	arg0_13:AddListener(ISLAND_EVT.END_PERFORMANCE, arg0_13.OnEndPerformance)
	arg0_13:AddListener(ISLAND_EVT.DISABLE_INPUT, arg0_13.DisableInput)
	arg0_13:AddListener(ISLAND_EVT.ENABLE_INPUT, arg0_13.EnableInput)
	arg0_13:AddListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_13.OnGenPathFinder)
	arg0_13:AddListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_13.OnActiveOrDisactiveUnit)
	arg0_13:AddListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_13.OnOpenAniamtionOpPage)
	arg0_13:AddListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_13.OnCloseAniamtionOpPage)
	arg0_13:AddListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_13.OnMovePlayerBefore)
	arg0_13:AddListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_13.OnRefreshTaskInfoHud)
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
	arg0_14:RemoveListener(ISLAND_EVT.APPROACH_UNIT, arg0_14.OnShowInterActionPanel)
	arg0_14:RemoveListener(ISLAND_EVT.LEAVE_UNIT, arg0_14.OnHideInterActionPanel)
	arg0_14:RemoveListener(ISLAND_EVT.TRACKING, arg0_14.OnTracking)
	arg0_14:RemoveListener(ISLAND_EVT.UNTRACKING, arg0_14.OnUnTracking)
	arg0_14:RemoveListener(ISLAND_EVT.AREACHANGE, arg0_14.OnPlayerAreaChange)
	arg0_14:RemoveListener(ISLAND_EVT.PLAYERRUN, arg0_14.OnPlayerPlayerRun)
	arg0_14:RemoveListener(ISLAND_EVT.SPRINT_PLAYER, arg0_14.OnPlayerPlayerSprint)
	arg0_14:RemoveListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_14.OnStopPlayerSprint)
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
	arg0_14:RemoveListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_14.OnWorldObjectStartInteraction)
	arg0_14:RemoveListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_14.OnWorldObjectEndInteraction)
	arg0_14:RemoveListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_14.OnWorldObjectInitStatus)
	arg0_14:RemoveListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_14.OnRefreshInteractionBtn)
	arg0_14:RemoveListener(ISLAND_EVT.SHOW_UNIT_HUD, arg0_14.OnShowUnitHud)
	arg0_14:RemoveListener(ISLAND_EVT.HIDE_UNIT_HUD, arg0_14.OnHideUnitHud)
	arg0_14:RemoveListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_14.OnDetectorChanged)
	arg0_14:RemoveListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_14.OnDetectorSelected)
	arg0_14:RemoveListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_14.OnPlayerWork)
	arg0_14:RemoveListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_14.OnPlayerDeviceStateChange)
	arg0_14:RemoveListener(ISLAND_EVT.UPDATE_HUD, arg0_14.OnUpdateHud)
	arg0_14:RemoveListener(ISLAND_EVT.UPDATE_UNIT_HP, arg0_14.OnUpdateUnitHp)
	arg0_14:RemoveListener(ISLAND_EVT.LOAD_DELEGATE_SLOT_EFFECCT, arg0_14.OnDelegateSlotEffectInit)
	arg0_14:RemoveListener(ISLAND_EVT.DEFAULTDELEFFECT_SHOW, arg0_14.OnDefaultSlotEffectShow)
	arg0_14:RemoveListener(ISLAND_EVT.UPDATE_DELEGATION_EFFECT_POSITION, arg0_14.OnUpdateEffectPos)
	arg0_14:RemoveListener(ISLAND_EVT.SELECTDELEFFECT_SHOW, arg0_14.OnSelectSlotEffectShow)
	arg0_14:RemoveListener(ISLAND_EVT.START_MANAGE, arg0_14.OnStartManage)
	arg0_14:RemoveListener(ISLAND_EVT.END_MANAGE, arg0_14.OnEndManage)
	arg0_14:RemoveListener(ISLAND_EVT.SHOW_HUD, arg0_14.OnShowHud)
	arg0_14:RemoveListener(ISLAND_EVT.HIDE_HUD, arg0_14.OnHideHud)
	arg0_14:RemoveListener(ISLAND_EVT.REFRESH_HUD, arg0_14.OnRefreshHud)
	arg0_14:RemoveListener(ISLAND_EVT.START_GUIDE, arg0_14.OnStartGuide)
	arg0_14:RemoveListener(ISLAND_EVT.END_GUIDE, arg0_14.OnEndGuide)
	arg0_14:RemoveListener(ISLAND_EVT.START_PERFORMANCE, arg0_14.OnStartPerformance)
	arg0_14:RemoveListener(ISLAND_EVT.END_PERFORMANCE, arg0_14.OnEndPerformance)
	arg0_14:RemoveListener(ISLAND_EVT.DISABLE_INPUT, arg0_14.DisableInput)
	arg0_14:RemoveListener(ISLAND_EVT.ENABLE_INPUT, arg0_14.EnableInput)
	arg0_14:RemoveListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_14.OnGenPathFinder)
	arg0_14:RemoveListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_14.OnActiveOrDisactiveUnit)
	arg0_14:RemoveListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_14.OnOpenAniamtionOpPage)
	arg0_14:RemoveListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_14.OnCloseAniamtionOpPage)
	arg0_14:RemoveListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_14.OnMovePlayerBefore)
	arg0_14:RemoveListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_14.OnRefreshTaskInfoHud)
end

function var0_0.OnOpenAniamtionOpPage(arg0_15)
	arg0_15:GetSubView(IslandAniamtionOpView):Show()
	arg0_15:GetSubView(IslandOpView):Disable()
	arg0_15:NotifiyIsland(ISLAND_EX_EVT.OPEN_ANIMATION_OP)
end

function var0_0.OnCloseAniamtionOpPage(arg0_16)
	arg0_16:GetSubView(IslandOpView):Enable()
	arg0_16:NotifiyIsland(ISLAND_EX_EVT.CLOSE_ANIMATION_OP)
end

function var0_0.OnGenPathFinder(arg0_17, arg1_17)
	local var0_17 = IslandPathFinder.New(arg0_17)
	local var1_17 = defaultValue(arg1_17.navData.waitUntilDone, false)

	var0_17:Start(arg1_17.navData, function()
		table.removebyvalue(arg0_17.pathfinders, var0_17)
		var0_17:Dispose()
		arg0_17:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH_DONE, arg1_17.navData.index)

		if var1_17 and arg1_17.callback then
			arg1_17.callback()
		end
	end)

	if not var1_17 and arg1_17.callback then
		arg1_17.callback()
	end

	table.insert(arg0_17.pathfinders, var0_17)
end

function var0_0.OnSceneInited(arg0_19, arg1_19)
	IslandCameraMgr.instance:LookAt(arg0_19.player._tf)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraZoom)):SetMaxMinZoom(arg1_19.min, arg1_19.max, arg1_19.value)
	arg0_19:InitFocusCamera()

	for iter0_19, iter1_19 in ipairs(arg0_19:GetAllUnits()) do
		iter1_19:Start()
	end

	arg0_19.isInit = true
end

function var0_0.InitFocusCamera(arg0_20)
	local var0_20 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)

	var0_20.Follow = arg0_20.player._tf
	var0_20.LookAt = arg0_20.player._tf
end

function var0_0.OnDetectorChanged(arg0_21, arg1_21)
	local var0_21 = arg1_21.node

	if not var0_21 then
		return
	end

	local var1_21 = var0_21:GetBlackboardVariable("DetectorList")

	for iter0_21 = 1, var1_21.Count do
		local var2_21 = var1_21[iter0_21 - 1]
		local var3_21, var4_21 = IslandCalcUtil.GetTypeAndIdByUniqueId(var2_21)

		if var3_21 == IslandConst.UNIT_LIST_OBJ then
			local var5_21 = arg0_21:GetUnitModuleWithType(var3_21, var4_21)

			if var5_21 then
				arg0_21:Op("NotifiyIsland", ISLAND_EX_EVT.APPROACH_OBJECT, var5_21.id)
			end
		end
	end
end

function var0_0.OnDetectorSelected(arg0_22, arg1_22)
	local var0_22 = arg1_22.node

	if not var0_22 then
		return
	end

	local var1_22 = var0_22:GetBlackboardVariable("SelectedObj")

	if not var1_22 or var1_22 == "" then
		arg0_22:OnClearSelectedUnit()
	else
		local var2_22, var3_22 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_22)
		local var4_22 = arg0_22:GetUnitModuleWithType(var2_22, var3_22)

		arg0_22:OnSelectedUnit(var4_22)
	end
end

function var0_0.OnClearSelectedUnit(arg0_23)
	return
end

function var0_0.OnSelectedUnit(arg0_24, arg1_24)
	return
end

function var0_0.OnRefreshInteractionBtn(arg0_25)
	arg0_25:GetSubView(IslandOpView):RefreshInteractionBtns()
end

function var0_0.OnStartStory(arg0_26)
	arg0_26.playingStory = true

	arg0_26.player:StopMoveHandle()
	arg0_26:GetSubView(IslandTopHeadHudView):Disable()
	arg0_26:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_26:GetSubView(IslandOpView):Hide()
end

function var0_0.OnEndStory(arg0_27)
	arg0_27.playingStory = false

	arg0_27:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_27:GetSubView(IslandTopHeadHudView):Enable()
	arg0_27:GetSubView(IslandOpView):Show()
end

function var0_0.OnStartPerformance(arg0_28)
	return
end

function var0_0.OnEndPerformance(arg0_29)
	arg0_29:GetSubView(IslandOpView):ResetShowBalance()
end

function var0_0.OnPlayChatBubble(arg0_30, arg1_30)
	local var0_30 = arg0_30:GetAllUnits()

	arg0_30:GetSubView(IslandTopHeadHudView):PlayBubble(arg1_30.name, var0_30, arg1_30.callback)
end

function var0_0.OnAnyPageOpen(arg0_31, arg1_31)
	arg0_31.player:StopMoveHandle()
	arg0_31:GetSubView(IslandTopHeadHudView):Disable()
	arg0_31:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnAllPageClose(arg0_32)
	arg0_32:GetSubView(IslandTopHeadHudView):Enable()
	arg0_32:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnInterActionBegin(arg0_33)
	arg0_33.player:StopMoveHandle()
	arg0_33:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_34)
	arg0_34:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_35, arg1_35)
	arg0_35.showInterObjId = arg1_35.id

	arg0_35:GetSubView(IslandOpView):ShowInterActionPanel(arg1_35)
	arg0_35:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_35.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_36, arg1_36)
	if arg0_36.showInterObjId ~= arg1_36.id then
		return
	end

	arg0_36.showInterObjId = nil

	arg0_36:GetSubView(IslandOpView):HideInterActionPanel()
end

function var0_0.OnStartGuide(arg0_37)
	arg0_37.player:StopMoveHandle()
	arg0_37:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_38)
	if arg0_38.playingStory then
		return
	end

	arg0_38:GetSubView(IslandOpView):EnableInput()
end

function var0_0.DisableInput(arg0_39)
	arg0_39.player:StopMoveHandle()
	arg0_39:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_40)
	arg0_40:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnTracking(arg0_41, arg1_41)
	arg0_41.trackId = tonumber(arg1_41.id)
	arg0_41.needTryTrack = true
end

function var0_0.TryTrack(arg0_42)
	local var0_42 = arg0_42:GetUnitModule(arg0_42.trackId)

	if not var0_42 or not var0_42._go then
		return
	end

	arg0_42:GetSubView(IslandOpView):SetTrackingTarget(arg0_42.player, var0_42, arg0_42.trackId)

	arg0_42.needTryTrack = false
end

function var0_0.OnUnTracking(arg0_43)
	arg0_43.trackId = nil

	arg0_43:GetSubView(IslandOpView):CancelTracking()
end

function var0_0.OnGenUnit(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.unitBuilders[arg1_44:GetType()]:Build(arg1_44, arg2_44)

	arg0_44:AddUnit(var0_44)

	if arg1_44:IsPlayer() then
		arg0_44.player = var0_44
	end
end

function var0_0.OnGenSystem(arg0_45, arg1_45)
	local var0_45 = arg0_45.systemBuilders[arg1_45:GetType()]:Build(arg1_45)

	arg0_45:AddUnit(var0_45)
end

function var0_0.OnActiveOrDisactiveUnit(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = arg0_46:GetUnitModuleWithType(arg2_46, arg1_46)

	if var0_46 and arg3_46 then
		var0_46:Enable()
	end

	if var0_46 and not arg3_46 then
		var0_46:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg0_47:GetUnitModule(arg1_47)

	if var0_47 then
		var0_47._go.transform.position = arg2_47
	end
end

function var0_0.OnMoveUnit(arg0_48, arg1_48)
	assert(arg1_48.type, "type should be exist")

	local var0_48 = arg0_48:GetUnitModuleWithType(arg1_48.type, arg1_48.id)

	if var0_48 then
		var0_48:SetDestination(arg1_48.position, arg1_48.speed)
	end
end

function var0_0.OnStopUnit(arg0_49, arg1_49)
	assert(arg1_49.type, "type should be exist")

	local var0_49 = arg0_49:GetUnitModuleWithType(arg1_49.type, arg1_49.id)

	if var0_49 then
		var0_49:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg0_50:GetUnitListByKey(arg1_50)
	local var1_50 = 0

	for iter0_50, iter1_50 in ipairs(var0_50 or {}) do
		if iter1_50.id == arg2_50 then
			var1_50 = iter0_50

			break
		end
	end

	if var1_50 > 0 then
		local var2_50 = var0_50[var1_50]

		arg0_50:RemoveUnit(var2_50)
		var2_50:Dispose()
		arg0_50:OnHideUnitHud({
			id = var2_50.id
		}, true)
		arg0_50:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_50,
			id = arg2_50
		})
		arg0_50:GetSubView(IslandOpView):CloseInterActionPanelByUnitIdRemove(arg2_50)
	end
end

function var0_0.GetAllUnits(arg0_51)
	table.clear(arg0_51._unitList)

	for iter0_51, iter1_51 in pairs(arg0_51:GetUnitListRegitser()) do
		for iter2_51, iter3_51 in pairs(iter1_51) do
			table.insert(arg0_51._unitList, iter3_51)
		end
	end

	return arg0_51._unitList
end

function var0_0.GetUnitModuleWithType(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg0_52:GetUnitListByKey(arg1_52)

	for iter0_52, iter1_52 in ipairs(var0_52) do
		if iter1_52.id == arg2_52 then
			return iter1_52
		end
	end

	return nil
end

function var0_0.GetUnitModule(arg0_53, arg1_53)
	return arg0_53:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_53)
end

function var0_0.GetSystemModule(arg0_54, arg1_54)
	return arg0_54:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_54)
end

function var0_0.GetSystemUnitModule(arg0_55, arg1_55)
	return arg0_55:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_55)
end

function var0_0.GetStrollUnitModule(arg0_56, arg1_56)
	return arg0_56:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_56)
end

function var0_0.GetManageSystemModule(arg0_57, arg1_57)
	return arg0_57:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_57)
end

function var0_0.OnMovePlayerBefore(arg0_58)
	arg0_58:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnPlayerMove(arg0_59, arg1_59)
	arg0_59.player:MoveHandle(arg1_59.targetDir, arg1_59.force)
end

function var0_0.OnPlayerStopMove(arg0_60)
	arg0_60.player:StopMoveHandle()
end

function var0_0.OnPlayerJump(arg0_61)
	arg0_61.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_62)
	arg0_62.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_63)
	arg0_63.player:OnPlayerPlayerSprint()
end

function var0_0.OnStopPlayerSprint(arg0_64)
	arg0_64.player:OnStopPlayerSprint()
end

function var0_0.OnPlayerWork(arg0_65, arg1_65, arg2_65, arg3_65)
	arg0_65.player:WorkHandle(arg1_65, arg2_65, arg3_65)
end

function var0_0.OnPlayerDeviceStateChange(arg0_66, arg1_66)
	arg0_66.player:DeviceStateHandle(arg1_66)
end

function var0_0.OnWorldObjectStartInteraction(arg0_67, arg1_67, arg2_67, arg3_67)
	local var0_67 = arg2_67:GetHostId()
	local var1_67 = arg2_67:GetUserId()
	local var2_67 = arg0_67:GetUnitModule(var0_67)
	local var3_67 = arg0_67:GetUnitModule(var1_67)
	local var4_67 = arg0_67.player == var3_67

	if var4_67 then
		arg0_67:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_67 = arg1_67:GetTimeline()[arg3_67]
	local var6_67 = arg1_67:GetBlackboardParam()[arg3_67]

	var2_67:StartInteract(var3_67, arg2_67.id, arg3_67, var5_67, var6_67, arg1_67:AnySlotUsing(), var4_67)
end

function var0_0.OnWorldObjectEndInteraction(arg0_68, arg1_68, arg2_68)
	local var0_68 = arg2_68:GetHostId()
	local var1_68 = arg2_68:GetUserId()
	local var2_68 = arg0_68:GetUnitModule(var0_68)
	local var3_68 = arg0_68:GetUnitModule(var1_68)
	local var4_68 = arg0_68.player == var3_68

	if var4_68 then
		arg0_68:GetSubView(IslandOpView):EndInteraction()
	end

	var2_68:EndInteract(var3_68, arg2_68.id, not arg1_68:AnySlotUsing(), var4_68)
end

function var0_0.OnWorldObjectInitStatus(arg0_69, arg1_69, arg2_69)
	local var0_69 = arg0_69:GetUnitModule(arg1_69.id)
	local var1_69 = arg1_69:GetTimeline()[arg2_69]
	local var2_69 = arg1_69:GetBlackboardParam()[arg2_69]

	var0_69:InitStatus(arg2_69, var1_69, var2_69)
end

function var0_0.OnPlayerAreaChange(arg0_70)
	arg0_70.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_71, arg1_71, arg2_71)
	arg0_71.player:OnChangeDress(arg1_71, arg2_71)
end

function var0_0.OnStartDelegation(arg0_72, arg1_72, arg2_72)
	local var0_72 = arg0_72:GetSystemModule(arg1_72.build_id)

	if var0_72 then
		var0_72:StartDelegation(arg1_72)
	end
end

function var0_0.OnEndDelegation(arg0_73, arg1_73, arg2_73)
	local var0_73 = arg0_73:GetSystemModule(arg1_73.build_id)

	if var0_73 then
		var0_73:EndDelegation(arg1_73)
	end
end

function var0_0.GetPlayerPosition(arg0_74)
	return arg0_74.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_75, arg1_75)
	local var0_75 = arg0_75:GetUnitModule(arg1_75)

	return var0_75 and var0_75._go.transform.position
end

function var0_0.OnShowUnitHud(arg0_76, arg1_76)
	arg0_76.currentHudUnitData = arg1_76

	arg0_76:GetSubView(IslandSlotHudView):ShowHud(arg1_76.id, arg1_76.height)
	arg0_76:GetSubView(IslandOpView):UpdateOperationButton(arg1_76.operationType, arg1_76.id)

	if arg1_76.isHighLightControl then
		arg0_76.detectionSystem:HighLightUnitHandle(arg1_76.id, true)
	end
end

function var0_0.OnHideUnitHud(arg0_77, arg1_77, arg2_77)
	if not arg0_77.currentHudUnitData or arg0_77.currentHudUnitData.id ~= arg1_77.id then
		return
	end

	if not arg2_77 then
		arg0_77.currentHudUnitData = nil
	end

	arg0_77:GetSubView(IslandSlotHudView):HideUnitHud(arg1_77.id)
	arg0_77:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_77.id)

	if arg1_77.isHighLightControl then
		arg0_77.detectionSystem:HighLightUnitHandle(arg1_77.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_78, arg1_78)
	if not arg0_78.currentHudUnitData then
		return
	end

	if arg1_78 ~= arg0_78.currentHudUnitData.id then
		return
	end

	arg0_78:GetSubView(IslandSlotHudView):UpdateHud(arg0_78.currentHudUnitData.id)
	arg0_78:GetSubView(IslandOpView):UpdateOperationButton(arg0_78.currentHudUnitData.operationType, arg0_78.currentHudUnitData.id)
end

function var0_0.OnUpdateUnitHp(arg0_79, arg1_79)
	local var0_79 = arg0_79:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_79)

	if var0_79 then
		var0_79:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_80, arg1_80)
	arg0_80:GetSubView(IslandTopHeadHudView):ShowHud(arg1_80)
	arg0_80:GetSubView(IslandOpView):OnShowHud(arg1_80.id)
end

function var0_0.OnRefreshHud(arg0_81, arg1_81)
	arg0_81:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_81)
end

function var0_0.OnHideHud(arg0_82, arg1_82)
	arg0_82:GetSubView(IslandTopHeadHudView):HideHud(arg1_82)
	arg0_82:GetSubView(IslandOpView):OnHideHud(arg1_82.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_83, arg1_83)
	local var0_83 = arg0_83:GetUnitModuleWithType(arg1_83.type, arg1_83.id)

	if var0_83 then
		var0_83:DelegateSlotStartPerform()
	end
end

function var0_0.OnDelegateSlotEffectInit(arg0_84, arg1_84, arg2_84, arg3_84)
	arg0_84.effectMgr:GenEffect(arg1_84, arg2_84, arg3_84)
end

function var0_0.OnUpdateEffectPos(arg0_85, arg1_85, arg2_85, arg3_85)
	arg0_85.effectMgr:UpdateEffect(arg1_85, arg2_85, arg3_85)
end

function var0_0.OnDefaultSlotEffectShow(arg0_86, arg1_86, arg2_86)
	arg0_86.effectMgr:OnDefaultSlotEffectShow(arg1_86, arg2_86)
end

function var0_0.OnSelectSlotEffectShow(arg0_87, arg1_87, arg2_87)
	arg0_87.effectMgr:OnSelectSlotEffectShow(arg1_87, arg2_87)
end

function var0_0.OnStartManage(arg0_88, arg1_88)
	local var0_88 = arg0_88:GetManageSystemModule(arg1_88.id)

	if var0_88 then
		var0_88:StartManage(arg1_88)
	end
end

function var0_0.OnEndManage(arg0_89, arg1_89)
	local var0_89 = arg0_89:GetManageSystemModule(arg1_89.id)

	if var0_89 then
		var0_89:EndManage(arg1_89)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_90)
	arg0_90:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnDispose(arg0_91)
	arg0_91.detectionSystem:Dispose()
	arg0_91.effectMgr:Dispose()

	for iter0_91, iter1_91 in ipairs(arg0_91.views) do
		iter1_91:Dispose()
	end

	for iter2_91, iter3_91 in ipairs(arg0_91.pathfinders) do
		iter3_91:Dispose()
	end

	for iter4_91, iter5_91 in ipairs(arg0_91:GetAllUnits()) do
		iter5_91:Dispose()
	end

	for iter6_91, iter7_91 in pairs(arg0_91.unitBuilders) do
		iter7_91:Dispose()
	end

	for iter8_91, iter9_91 in pairs(arg0_91.systemBuilders) do
		iter9_91:Dispose()
	end

	arg0_91.pathfinders = nil
	arg0_91.unitBuilders = nil
	arg0_91.systemBuilders = nil
	arg0_91.views = nil
	arg0_91.player = nil
	arg0_91.isInit = false
	arg0_91._unitList = nil
	arg0_91.detectionSystem = nil
	arg0_91.effectMgr = nil
end

return var0_0
