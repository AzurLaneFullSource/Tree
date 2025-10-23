local var0_0 = class("IslandView", import(".IslandBaseView"))

function var0_0.Init(arg0_1)
	arg0_1._unitList = {}
	arg0_1.isInit = false

	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_PLAYER)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_OBJ)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_SYSTEM)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_DELEGATION)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_STROLL)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_MANAGE_SYSTEM)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_MANAGE)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_DELEGATION_ANIMATION)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_FOLLOW)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_DELAY)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_PHOTO)

	arg0_1.unitBuilders = {
		[IslandConst.UNIT_TYPE_ITEM] = IslandStaticUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_CHAR] = IslandNpcBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
		[IslandConst.UNIT_TYPE_VISITOR] = IslandVisitorBuilder.New(arg0_1, IslandConst.UNIT_LIST_PLAYER),
		[IslandConst.UNIT_TYPE_PLAYER] = IslandPlayerBuilder.New(arg0_1, IslandConst.UNIT_LIST_PLAYER),
		[IslandConst.UNIT_TYPE_VIRTUAL_INTERACT] = IslandVirtualInteractBuilder.New(arg0_1, IslandConst.UNIT_LIST_OBJ),
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
		[IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION] = IslandSystemDelegationUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_DELEGATION_ANIMATION),
		[IslandConst.UNIT_TYPE_FOLLOWER] = IslandFollowNpcBuilder.New(arg0_1, IslandConst.UNIT_LIST_FOLLOW),
		[IslandConst.UNIT_TYPE_ITEM_DELAY_RECYCLE] = IslandDelayRecycleUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_DELAY),
		[IslandConst.UNIT_TYPE_FIRST_TAKE_PHOTO_ITEM] = IslandTakePhotoBuilder.New(arg0_1, IslandConst.UNIT_LIST_PHOTO)
	}
	arg0_1.systemBuilders = {
		[IslandConst.SYSTEM_TYPE_CHARACTER] = IslandSystemBuilder.New(arg0_1, IslandCharacterSystem),
		[IslandConst.SYSTEM_TYPE_PRODUCT] = IslandSystemBuilder.New(arg0_1, IslandCharacterSystem),
		[IslandConst.SYSTEM_TYPE_SEEKGAME] = IslandSystemBuilder.New(arg0_1, IslandSeekGameSystem),
		[IslandConst.SYSTEM_TYPE_GROUND] = IslandGroundSystemBuilder.New(arg0_1, IslandGoundLayerSystem),
		[IslandConst.SYSTEM_TYPE_GRASSLAND] = IslandSystemBuilder.New(arg0_1, IslandGrassLandSystem),
		[IslandConst.SYSTEM_TYPE_MANAGE] = IslandManageSystemBuilder.New(arg0_1, IslandManageSystem)
	}
	arg0_1.detectionSystem = IslandDetectionSystem.New(arg0_1)
	arg0_1.effectMgr = IslandDelegateEffectMgr.New(arg0_1)
	arg0_1.coupleActionPlayer = IslandCoupleActionPlayer.New(arg0_1)
	arg0_1.coupleAction4FollowerPlayer = IslandCoupleAction4FollowerPlayer.New(arg0_1)
	arg0_1.npcActionPlayer = IslandNpcActionPlayer.New(arg0_1)
	arg0_1.weatherSystem = IslandWeatherSystem.New(arg0_1)
	arg0_1.pathfinders = {}
	arg0_1.views = {
		arg0_1:CreateInteractionView(),
		arg0_1:CreateDistanceView(),
		arg0_1:CreateSeedOpView(),
		arg0_1:CreateOpView(),
		arg0_1:CreateSlotHudView(),
		arg0_1:CreateTopHeadHudView(),
		arg0_1:CreateBottomHeadHudeView(),
		arg0_1:CreateCancelAnimationOpView(),
		arg0_1:CreateAnimationOpView()
	}
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

function var0_0.CreateCancelAnimationOpView(arg0_5)
	return IslandCancelAnimationOpView.New(arg0_5)
end

function var0_0.CreateTopHeadHudView(arg0_6)
	return IslandTopHeadHudView.New(arg0_6)
end

function var0_0.CreateBottomHeadHudeView(arg0_7)
	return IslandBottomHeadHudView.New(arg0_7)
end

function var0_0.CreateAnimationOpView(arg0_8)
	return IslandAniamtionOpView.New(arg0_8)
end

function var0_0.CreateInteractionView(arg0_9)
	return IslandInteractionView.New(arg0_9)
end

function var0_0.CreateDistanceView(arg0_10)
	return IslandDistanceView.New(arg0_10)
end

function var0_0.CreateSeedOpView(arg0_11)
	return IslandSeedOpView.New(arg0_11)
end

function var0_0.IsLoaded(arg0_12)
	local var0_12 = arg0_12:GetAllUnits()

	return _.all(arg0_12.views, function(arg0_13)
		return arg0_13:IsLoaded()
	end) and #var0_12 > 0 and _.all(var0_12, function(arg0_14)
		return arg0_14:IsLoaded()
	end)
end

function var0_0.IsInit(arg0_15)
	return arg0_15.isInit
end

function var0_0.Update(arg0_16)
	if not arg0_16.isInit then
		return
	end

	for iter0_16, iter1_16 in ipairs(arg0_16:GetAllUnits()) do
		iter1_16:Update()
	end

	for iter2_16, iter3_16 in ipairs(arg0_16.views) do
		iter3_16:Update()
	end

	for iter4_16, iter5_16 in ipairs(arg0_16.pathfinders) do
		iter5_16:Update()
	end

	if arg0_16.needTryTrack then
		arg0_16:TryTrack()
	end
end

function var0_0.LateUpdate(arg0_17)
	if not arg0_17.isInit then
		return
	end

	for iter0_17, iter1_17 in ipairs(arg0_17:GetAllUnits()) do
		iter1_17:LateUpdate()
	end

	for iter2_17, iter3_17 in ipairs(arg0_17.views) do
		iter3_17:LateUpdate()
	end

	for iter4_17, iter5_17 in ipairs(arg0_17.pathfinders) do
		iter5_17:LateUpdate()
	end
end

function var0_0.AddListeners(arg0_18)
	arg0_18:AddListener(ISLAND_EVT.GEN_UNIT, arg0_18.OnGenUnit)
	arg0_18:AddListener(ISLAND_EVT.RMOVE_UNIT, arg0_18.OnRemoveUnit)
	arg0_18:AddListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_18.OnInterActionBegin)
	arg0_18:AddListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_18.OnInterActionEnd)
	arg0_18:AddListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_18.OnStopUnit)
	arg0_18:AddListener(ISLAND_EVT.MOVE_UNIT, arg0_18.OnMoveUnit)
	arg0_18:AddListener(ISLAND_EVT.INIT_FINISH, arg0_18.OnSceneInited)
	arg0_18:AddListener(ISLAND_EVT.MOVE_PLAYER, arg0_18.OnPlayerMove)
	arg0_18:AddListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_18.OnPlayerStopMoveHandle)
	arg0_18:AddListener(ISLAND_EVT.JUMP_PLAYER, arg0_18.OnPlayerJump)
	arg0_18:AddListener(ISLAND_EVT.APPROACH_UNIT, arg0_18.OnShowInterActionPanel)
	arg0_18:AddListener(ISLAND_EVT.LEAVE_UNIT, arg0_18.OnHideInterActionPanel)
	arg0_18:AddListener(ISLAND_EVT.TRACKING, arg0_18.OnTracking)
	arg0_18:AddListener(ISLAND_EVT.UNTRACKING, arg0_18.OnUnTracking)
	arg0_18:AddListener(ISLAND_EVT.AREACHANGE, arg0_18.OnPlayerAreaChange)
	arg0_18:AddListener(ISLAND_EVT.PLAYERRUN, arg0_18.OnPlayerPlayerRun)
	arg0_18:AddListener(ISLAND_EVT.SPRINT_PLAYER, arg0_18.OnPlayerPlayerSprint)
	arg0_18:AddListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_18.OnStopPlayerSprint)
	arg0_18:AddListener(ISLAND_EVT.CHANGE_DRESS, arg0_18.OnChangeDress)
	arg0_18:AddListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_18.OnCharacterChangeDress)
	arg0_18:AddListener(ISLAND_EVT.RESET_UNIT_POS, arg0_18.OnResetUnitPos)
	arg0_18:AddListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_18.OnResetUnitRotation)
	arg0_18:AddListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_18.OnAnyPageOpen)
	arg0_18:AddListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_18.OnAllPageClose)
	arg0_18:AddListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_18.OnChangeTakePhotoModel)
	arg0_18:AddListener(ISLAND_EVT.Change_Photo_Height, arg0_18.OnChange_Photo_Height)
	arg0_18:AddListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_18.OnSetOpMoveBtnActve)
	arg0_18:AddListener(ISLAND_EVT.PLAY_BUBBLE, arg0_18.OnPlayChatBubble)
	arg0_18:AddListener(ISLAND_EVT.START_STORY, arg0_18.OnStartStory)
	arg0_18:AddListener(ISLAND_EVT.END_STORY, arg0_18.OnEndStory)
	arg0_18:AddListener(ISLAND_EVT.START_DEGATION, arg0_18.OnStartDelegation)
	arg0_18:AddListener(ISLAND_EVT.END_DEGATION, arg0_18.OnEndDelegation)
	arg0_18:AddListener(ISLAND_EVT.GEN_SYSTEM, arg0_18.OnGenSystem)
	arg0_18:AddListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_18.OnWorldObjectStartInteraction)
	arg0_18:AddListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_18.OnWorldObjectEndInteraction)
	arg0_18:AddListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_18.OnWorldObjectInitStatus)
	arg0_18:AddListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_18.OnRefreshInteractionBtn)
	arg0_18:AddListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_18.OnShowUnitHudAndOpBtn)
	arg0_18:AddListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_18.OnHideUnitHudAndOpBtn)
	arg0_18:AddListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_18.OnDetectorChanged)
	arg0_18:AddListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_18.OnDetectorSelected)
	arg0_18:AddListener(ISLAND_EVT.NPC_DETECTED, arg0_18.OnNpcDetectorSelected)
	arg0_18:AddListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_18.OnNpcDetectorUnSelected)
	arg0_18:AddListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_18.OnPlayerWork)
	arg0_18:AddListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_18.OnPlayerDeviceStateChange)
	arg0_18:AddListener(ISLAND_EVT.UPDATE_HUD, arg0_18.OnUpdateHud)
	arg0_18:AddListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_18.OnUpdateHandCollectUnit)
	arg0_18:AddListener(ISLAND_EVT.START_DELEGATE_SLOT_PERFORM, arg0_18.OnDelegateSlotStartPerform)
	arg0_18:AddListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_18.OnRecycleAllSlotEffct)
	arg0_18:AddListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_18.OnSelectSlotEffectShow)
	arg0_18:AddListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_18.OnLoadDelegatePreviewRole)
	arg0_18:AddListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_18.OnUnLoadDelegatePreviewRole)
	arg0_18:AddListener(ISLAND_EVT.Take_Plant_Attact, arg0_18.OnTakePlantAttack)
	arg0_18:AddListener(ISLAND_EVT.START_MANAGE, arg0_18.OnStartManage)
	arg0_18:AddListener(ISLAND_EVT.END_MANAGE, arg0_18.OnEndManage)
	arg0_18:AddListener(ISLAND_EVT.SHOW_HUD, arg0_18.OnShowHud)
	arg0_18:AddListener(ISLAND_EVT.HIDE_HUD, arg0_18.OnHideHud)
	arg0_18:AddListener(ISLAND_EVT.REFRESH_HUD, arg0_18.OnRefreshHud)
	arg0_18:AddListener(ISLAND_EVT.START_GUIDE, arg0_18.OnStartGuide)
	arg0_18:AddListener(ISLAND_EVT.END_GUIDE, arg0_18.OnEndGuide)
	arg0_18:AddListener(ISLAND_EVT.START_PERFORMANCE, arg0_18.OnStartPerformance)
	arg0_18:AddListener(ISLAND_EVT.END_PERFORMANCE, arg0_18.OnEndPerformance)
	arg0_18:AddListener(ISLAND_EVT.DISABLE_INPUT, arg0_18.DisableInput)
	arg0_18:AddListener(ISLAND_EVT.ENABLE_INPUT, arg0_18.EnableInput)
	arg0_18:AddListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_18.OnGenPathFinder)
	arg0_18:AddListener(ISLAND_EVT.REMOVE_PATH_FINDER, arg0_18.OnRemovePathFinder)
	arg0_18:AddListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_18.OnActiveOrDisactiveUnit)
	arg0_18:AddListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_18.OnOpenAniamtionOpPage)
	arg0_18:AddListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_18.OnCloseAniamtionOpPage)
	arg0_18:AddListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_18.OnMovePlayerBefore)
	arg0_18:AddListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_18.OnRefreshTaskInfoHud)
	arg0_18:AddListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_18.OnResponAniamtionOp)
	arg0_18:AddListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_18.OnChangeVisterDress)
	arg0_18:AddListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_18.OnSetVisitorSyncData)
	arg0_18:AddListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_18.OnShowNpcAniamtionBubble)
	arg0_18:AddListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_18.OnHideNpcAniamtionBubble)
	arg0_18:AddListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_18.OnPlaySingleAnimationEnd)
	arg0_18:AddListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_18.OnUpdateCustomOpPositon)
	arg0_18:AddListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_18.OnChatMsgUpdate)
	arg0_18:AddListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_18.OnChatRoomChange)
	arg0_18:AddListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_18.OnShowChatMsg)
	arg0_18:AddListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_18.OnResetFollowRandomizer)
	arg0_18:AddListener(ISLAND_EVT.ADD_FOLLOWER, arg0_18.OnFollowerAdd)
	arg0_18:AddListener(ISLAND_EVT.DEL_FOLLOWER, arg0_18.OnFollowerDel)
	arg0_18:AddListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_18.OnCoupleActionWithFollower)
	arg0_18:AddListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_18.OnLockPlayerInput)
	arg0_18:AddListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_18.OnStartCoupleAction)
	arg0_18:AddListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_18.OnEndCoupleAction)
	arg0_18:AddListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_18.OnRefreshWeatherSystem)
	arg0_18:AddListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_18.OnSystemUnlock)
	arg0_18:AddListener(ISLAND_EVT.START_DO_COUPLE_ACTION, arg0_18.OnStartDoCoupleAction)
	arg0_18:AddListener(ISLAND_EVT.END_DO_COUPLE_ACTION, arg0_18.OnEndDoCoupleAction)
	arg0_18:AddListener(ISLAND_EVT.CANCEL_COUPLE_ACTION, arg0_18.OnCancelCoupleAction)
end

function var0_0.RemoveListeners(arg0_19)
	arg0_19:RemoveListener(ISLAND_EVT.GEN_UNIT, arg0_19.OnGenUnit)
	arg0_19:RemoveListener(ISLAND_EVT.RMOVE_UNIT, arg0_19.OnRemoveUnit)
	arg0_19:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_19.OnInterActionBegin)
	arg0_19:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_19.OnInterActionEnd)
	arg0_19:RemoveListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_19.OnStopUnit)
	arg0_19:RemoveListener(ISLAND_EVT.MOVE_UNIT, arg0_19.OnMoveUnit)
	arg0_19:RemoveListener(ISLAND_EVT.INIT_FINISH, arg0_19.OnSceneInited)
	arg0_19:RemoveListener(ISLAND_EVT.MOVE_PLAYER, arg0_19.OnPlayerMove)
	arg0_19:RemoveListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_19.OnPlayerStopMoveHandle)
	arg0_19:RemoveListener(ISLAND_EVT.JUMP_PLAYER, arg0_19.OnPlayerJump)
	arg0_19:RemoveListener(ISLAND_EVT.APPROACH_UNIT, arg0_19.OnShowInterActionPanel)
	arg0_19:RemoveListener(ISLAND_EVT.LEAVE_UNIT, arg0_19.OnHideInterActionPanel)
	arg0_19:RemoveListener(ISLAND_EVT.TRACKING, arg0_19.OnTracking)
	arg0_19:RemoveListener(ISLAND_EVT.UNTRACKING, arg0_19.OnUnTracking)
	arg0_19:RemoveListener(ISLAND_EVT.AREACHANGE, arg0_19.OnPlayerAreaChange)
	arg0_19:RemoveListener(ISLAND_EVT.PLAYERRUN, arg0_19.OnPlayerPlayerRun)
	arg0_19:RemoveListener(ISLAND_EVT.SPRINT_PLAYER, arg0_19.OnPlayerPlayerSprint)
	arg0_19:RemoveListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_19.OnStopPlayerSprint)
	arg0_19:RemoveListener(ISLAND_EVT.CHANGE_DRESS, arg0_19.OnChangeDress)
	arg0_19:RemoveListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_19.OnCharacterChangeDress)
	arg0_19:RemoveListener(ISLAND_EVT.RESET_UNIT_POS, arg0_19.OnResetUnitPos)
	arg0_19:RemoveListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_19.OnResetUnitRotation)
	arg0_19:RemoveListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_19.OnAnyPageOpen)
	arg0_19:RemoveListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_19.OnChangeTakePhotoModel)
	arg0_19:RemoveListener(ISLAND_EVT.Change_Photo_Height, arg0_19.OnChange_Photo_Height)
	arg0_19:RemoveListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_19.OnSetOpMoveBtnActve)
	arg0_19:RemoveListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_19.OnAllPageClose)
	arg0_19:RemoveListener(ISLAND_EVT.PLAY_BUBBLE, arg0_19.OnPlayChatBubble)
	arg0_19:RemoveListener(ISLAND_EVT.START_STORY, arg0_19.OnStartStory)
	arg0_19:RemoveListener(ISLAND_EVT.END_STORY, arg0_19.OnEndStory)
	arg0_19:RemoveListener(ISLAND_EVT.START_DEGATION, arg0_19.OnStartDelegation)
	arg0_19:RemoveListener(ISLAND_EVT.END_DEGATION, arg0_19.OnEndDelegation)
	arg0_19:RemoveListener(ISLAND_EVT.GEN_SYSTEM, arg0_19.OnGenSystem)
	arg0_19:RemoveListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_19.OnWorldObjectStartInteraction)
	arg0_19:RemoveListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_19.OnWorldObjectEndInteraction)
	arg0_19:RemoveListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_19.OnWorldObjectInitStatus)
	arg0_19:RemoveListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_19.OnRefreshInteractionBtn)
	arg0_19:RemoveListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_19.OnShowUnitHudAndOpBtn)
	arg0_19:RemoveListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_19.OnHideUnitHudAndOpBtn)
	arg0_19:RemoveListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_19.OnDetectorChanged)
	arg0_19:RemoveListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_19.OnDetectorSelected)
	arg0_19:RemoveListener(ISLAND_EVT.NPC_DETECTED, arg0_19.OnNpcDetectorSelected)
	arg0_19:RemoveListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_19.OnNpcDetectorUnSelected)
	arg0_19:RemoveListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_19.OnPlayerWork)
	arg0_19:RemoveListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_19.OnPlayerDeviceStateChange)
	arg0_19:RemoveListener(ISLAND_EVT.UPDATE_HUD, arg0_19.OnUpdateHud)
	arg0_19:RemoveListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_19.OnUpdateHandCollectUnit)
	arg0_19:RemoveListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_19.OnRecycleAllSlotEffct)
	arg0_19:RemoveListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_19.OnSelectSlotEffectShow)
	arg0_19:RemoveListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_19.OnLoadDelegatePreviewRole)
	arg0_19:RemoveListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_19.OnUnLoadDelegatePreviewRole)
	arg0_19:RemoveListener(ISLAND_EVT.Take_Plant_Attact, arg0_19.OnTakePlantAttack)
	arg0_19:RemoveListener(ISLAND_EVT.START_MANAGE, arg0_19.OnStartManage)
	arg0_19:RemoveListener(ISLAND_EVT.END_MANAGE, arg0_19.OnEndManage)
	arg0_19:RemoveListener(ISLAND_EVT.SHOW_HUD, arg0_19.OnShowHud)
	arg0_19:RemoveListener(ISLAND_EVT.HIDE_HUD, arg0_19.OnHideHud)
	arg0_19:RemoveListener(ISLAND_EVT.REFRESH_HUD, arg0_19.OnRefreshHud)
	arg0_19:RemoveListener(ISLAND_EVT.START_GUIDE, arg0_19.OnStartGuide)
	arg0_19:RemoveListener(ISLAND_EVT.END_GUIDE, arg0_19.OnEndGuide)
	arg0_19:RemoveListener(ISLAND_EVT.START_PERFORMANCE, arg0_19.OnStartPerformance)
	arg0_19:RemoveListener(ISLAND_EVT.END_PERFORMANCE, arg0_19.OnEndPerformance)
	arg0_19:RemoveListener(ISLAND_EVT.DISABLE_INPUT, arg0_19.DisableInput)
	arg0_19:RemoveListener(ISLAND_EVT.ENABLE_INPUT, arg0_19.EnableInput)
	arg0_19:RemoveListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_19.OnGenPathFinder)
	arg0_19:RemoveListener(ISLAND_EVT.REMOVE_PATH_FINDER, arg0_19.OnRemovePathFinder)
	arg0_19:RemoveListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_19.OnActiveOrDisactiveUnit)
	arg0_19:RemoveListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_19.OnOpenAniamtionOpPage)
	arg0_19:RemoveListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_19.OnCloseAniamtionOpPage)
	arg0_19:RemoveListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_19.OnMovePlayerBefore)
	arg0_19:RemoveListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_19.OnRefreshTaskInfoHud)
	arg0_19:RemoveListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_19.OnResponAniamtionOp)
	arg0_19:RemoveListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_19.OnChangeVisterDress)
	arg0_19:RemoveListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_19.OnSetVisitorSyncData)
	arg0_19:RemoveListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_19.OnShowNpcAniamtionBubble)
	arg0_19:RemoveListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_19.OnHideNpcAniamtionBubble)
	arg0_19:RemoveListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_19.OnPlaySingleAnimationEnd)
	arg0_19:RemoveListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_19.OnUpdateCustomOpPositon)
	arg0_19:RemoveListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_19.OnChatMsgUpdate)
	arg0_19:RemoveListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_19.OnChatRoomChange)
	arg0_19:RemoveListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_19.OnShowChatMsg)
	arg0_19:RemoveListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_19.OnResetFollowRandomizer)
	arg0_19:RemoveListener(ISLAND_EVT.ADD_FOLLOWER, arg0_19.OnFollowerAdd)
	arg0_19:RemoveListener(ISLAND_EVT.DEL_FOLLOWER, arg0_19.OnFollowerDel)
	arg0_19:RemoveListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_19.OnCoupleActionWithFollower)
	arg0_19:RemoveListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_19.OnLockPlayerInput)
	arg0_19:RemoveListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_19.OnStartCoupleAction)
	arg0_19:RemoveListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_19.OnEndCoupleAction)
	arg0_19:RemoveListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_19.OnRefreshWeatherSystem)
	arg0_19:RemoveListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_19.OnSystemUnlock)
	arg0_19:RemoveListener(ISLAND_EVT.START_DO_COUPLE_ACTION, arg0_19.OnStartDoCoupleAction)
	arg0_19:RemoveListener(ISLAND_EVT.END_DO_COUPLE_ACTION, arg0_19.OnEndDoCoupleAction)
	arg0_19:RemoveListener(ISLAND_EVT.CANCEL_COUPLE_ACTION, arg0_19.OnCancelCoupleAction)
end

function var0_0.OnSystemUnlock(arg0_20, arg1_20)
	if arg1_20 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_20:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.OnStartCoupleAction(arg0_21)
	arg0_21:UnBlockLayer1Event(false)
	arg0_21:GetSubView(IslandAniamtionOpView):OnStartCoupleAction()
end

function var0_0.OnEndCoupleAction(arg0_22)
	arg0_22:UnBlockLayer1Event(true)
	arg0_22:GetSubView(IslandAniamtionOpView):OnEndCoupleAction()
end

function var0_0.OnCancelCoupleAction(arg0_23)
	if arg0_23.coupleActionPlayer and arg0_23.coupleActionPlayer:IsPlaying() then
		arg0_23.coupleActionPlayer:Stop()
	end

	if arg0_23.coupleAction4FollowerPlayer and arg0_23.coupleAction4FollowerPlayer:IsPlaying() then
		arg0_23.coupleAction4FollowerPlayer:Stop()
	end

	arg0_23:OnEndCoupleAction()
end

function var0_0.OnCoupleActionWithFollower(arg0_24, arg1_24)
	local var0_24 = arg0_24:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_24 = arg0_24:GetPlayerPosition()
	local var2_24 = pg.island_set.action_bubble_range.key_value_int
	local var3_24 = _.select(var0_24, function(arg0_25)
		return Vector3.Distance(arg0_25:GetPosition(), var1_24) <= var2_24
	end)

	if #var3_24 <= 0 then
		return
	end

	local var4_24 = var3_24[math.random(1, #var3_24)]
	local var5_24 = pg.island_action[arg1_24]

	arg0_24.coupleAction4FollowerPlayer:Play(var4_24, arg0_24.player, var5_24)
	arg0_24:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
end

function var0_0.OnFollowerAdd(arg0_26)
	arg0_26:GetSubView(IslandOpView):FlushFollowerList()
end

function var0_0.OnFollowerDel(arg0_27)
	arg0_27:GetSubView(IslandOpView):FlushFollowerList()
end

function var0_0.OnResetFollowRandomizer(arg0_28, arg1_28)
	local var0_28 = arg0_28:GetFollowerModule(arg1_28)

	if not var0_28 then
		return
	end

	var0_28:SetBtRandomizer()
end

function var0_0.OnShowChatMsg(arg0_29, arg1_29)
	local var0_29 = arg1_29.player.id
	local var1_29 = arg0_29:GetPlayerUnitModule(var0_29)

	if not var1_29 then
		return
	end

	arg0_29:GetSubView(IslandTopHeadHudView):PlayChat(var1_29, arg1_29.emojiId, arg1_29.content, nil)
end

function var0_0.OnChatRoomChange(arg0_30)
	arg0_30:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_31)
	arg0_31:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnPlaySingleAnimationEnd(arg0_32, arg1_32)
	if not arg0_32:GetSelectedNpcId() then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(1, arg1_32, 0, 0, 0, 0))

		return
	end

	local var0_32 = arg0_32:GetSelectedNpcId()
	local var1_32, var2_32 = IslandCalcUtil.GetTypeAndIdByUniqueId(var0_32)
	local var3_32 = arg0_32:GetUnitModuleWithType(var1_32, var2_32)

	arg0_32.npcActionPlayer:Play(var3_32, arg0_32.player, arg1_32)
end

function var0_0.OnShowNpcAniamtionBubble(arg0_33, arg1_33)
	local var0_33 = arg0_33:GetStrollUnitModule(arg1_33.id)

	if not var0_33 then
		return
	end

	local var1_33 = arg1_33:GetActionFeedback()

	arg0_33:GetSubView(IslandBottomHeadHudView):ShowAnimationOp(var0_33, var1_33)
end

function var0_0.OnHideNpcAniamtionBubble(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetStrollUnitModule(arg1_34.id)

	arg0_34:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var0_34)
end

function var0_0.OnStartDoCoupleAction(arg0_35)
	arg0_35:GetSubView(IslandCancelAnimationOpView):ShowCancelableAnimationOp(arg0_35.player)
end

function var0_0.OnEndDoCoupleAction(arg0_36)
	arg0_36:GetSubView(IslandCancelAnimationOpView):HideCancelableAnimationOp(arg0_36.player)
end

function var0_0.OnResponAniamtionOp(arg0_37, arg1_37)
	local var0_37 = arg1_37.id
	local var1_37 = arg1_37.targetId
	local var2_37 = arg1_37.actionId
	local var3_37 = arg0_37:GetPlayerUnitModule(var0_37)

	if not var3_37 then
		return
	end

	if var2_37 == 0 then
		if not arg0_37:IsPlayer(var0_37) then
			arg0_37:GetSubView(IslandTopHeadHudView):HideAnimationOp(var3_37)
		else
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_37, 1, 0, 0, 0))
		end

		return
	end

	local var4_37 = pg.island_action[var2_37]

	if var1_37 == 0 and var4_37.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_37:IsPlayer(var0_37) then
		arg0_37:GetSubView(IslandTopHeadHudView):ShowAnimationOp(var3_37, var2_37)
	elseif var1_37 > 0 and var4_37.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_37:IsPlayer(var1_37) then
		local var5_37 = arg0_37:GetPlayerUnitModule(var1_37)

		arg0_37.coupleActionPlayer:Play(var3_37, var5_37, var4_37)
		arg0_37:GetSubView(IslandTopHeadHudView):HideAnimationOp(var5_37)
	elseif var1_37 > 0 and var4_37.type == IslandConst.ANIMATION_OP_DOUBLE and arg0_37:IsPlayer(var1_37) then
		local var6_37 = arg0_37:GetPlayerUnitModule(var1_37)

		arg0_37.coupleActionPlayer:Play(var3_37, var6_37, var4_37)
		arg0_37:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_37, 1, var1_37, 0, 1))
	end
end

function var0_0.OnChangeVisterDress(arg0_38, arg1_38)
	local var0_38 = arg1_38.id

	if arg0_38:IsPlayer(var0_38) then
		return
	end

	local var1_38 = arg0_38:GetPlayerUnitModule(var0_38)

	if var1_38 then
		var1_38:OnChangeDress(arg1_38.changeDressData)
	end
end

function var0_0.IsPlayer(arg0_39, arg1_39)
	return arg0_39.player.id == arg1_39
end

function var0_0.OnOpenAniamtionOpPage(arg0_40)
	arg0_40:GetSubView(IslandAniamtionOpView):TryEnable()
	arg0_40:GetSubView(IslandOpView):TryDisable()
	arg0_40:NotifiyIsland(ISLAND_EX_EVT.OPEN_ANIMATION_OP)
end

function var0_0.OnCloseAniamtionOpPage(arg0_41)
	arg0_41:GetSubView(IslandOpView):TryEnable()
	arg0_41:NotifiyIsland(ISLAND_EX_EVT.CLOSE_ANIMATION_OP)
end

function var0_0.OnGenPathFinder(arg0_42, arg1_42)
	local var0_42 = IslandPathFinder.New(arg0_42)
	local var1_42 = defaultValue(arg1_42.navData.waitUntilDone, false)

	var0_42:Start(arg1_42.navData, function()
		table.removebyvalue(arg0_42.pathfinders, var0_42)
		var0_42:Dispose()

		if arg1_42.onEndAction then
			arg1_42.onEndAction()
		end

		arg0_42:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH_DONE, arg1_42.navData.index)

		if var1_42 and arg1_42.callback then
			arg1_42.callback()
		end
	end)
	arg0_42:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH, arg1_42.navData.index)

	if not var1_42 and arg1_42.callback then
		arg1_42.callback()
	end

	table.insert(arg0_42.pathfinders, var0_42)
end

function var0_0.OnRemovePathFinder(arg0_44, arg1_44)
	local var0_44 = arg0_44:GetUnitModuleWithType(arg1_44.unitType, arg1_44.unitId)
	local var1_44 = _.detect(arg0_44.pathfinders, function(arg0_45)
		return arg0_45:IsSameUnit(var0_44)
	end)

	if not var1_44 then
		return
	end

	var1_44:Stop()
	var1_44:Dispose()
	table.removebyvalue(arg0_44.pathfinders, var1_44)
end

function var0_0.OnSceneInited(arg0_46, arg1_46)
	IslandCameraMgr.instance:LookAt(arg0_46.player._tf)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraZoom)):SetMaxMinZoom(arg1_46.min, arg1_46.max, arg1_46.value)
	arg0_46:InitFocusCamera()
	arg0_46:InitTakePhotoCamera()

	for iter0_46, iter1_46 in ipairs(arg0_46:GetAllUnits()) do
		iter1_46:Start()
	end

	arg0_46:GetSubView(IslandOpView):LaterInit()

	arg0_46.isInit = true
end

function var0_0.InitFocusCamera(arg0_47)
	local var0_47 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)

	var0_47.Follow = arg0_47.player._tf
	var0_47.LookAt = arg0_47.player._tf
end

function var0_0.InitTakePhotoCamera(arg0_48)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).Follow = arg0_48.firstTakePhotoItem._tf

	local var0_48 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)

	var0_48.Follow = arg0_48.thirdTakePhotoItem._tf
	var0_48.LookAt = arg0_48.thirdTakePhotoItem._tf
end

function var0_0.OnNpcDetectorSelected(arg0_49, arg1_49)
	if arg0_49.selectedNpcId then
		return
	end

	local var0_49 = arg1_49.node

	if not var0_49 then
		return
	end

	local var1_49 = var0_49:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_49.selectedNpcId = var1_49

	arg0_49:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_49, true)
	arg0_49:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_49, true)
end

function var0_0.GetSelectedNpcId(arg0_50)
	return arg0_50.selectedNpcId
end

function var0_0.OnNpcDetectorUnSelected(arg0_51, arg1_51)
	local var0_51 = arg1_51.node

	if not var0_51 then
		return
	end

	local var1_51 = var0_51:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_51:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_51)
	arg0_51:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_51)

	if arg0_51.selectedNpcId ~= var1_51 then
		return
	end

	arg0_51.selectedNpcId = nil
end

function var0_0.OnDetectorChanged(arg0_52, arg1_52)
	local var0_52 = arg1_52.node

	if not var0_52 then
		return
	end

	local var1_52 = var0_52:GetBlackboardVariable("DetectorList")

	for iter0_52 = 1, var1_52.Count do
		local var2_52 = var1_52[iter0_52 - 1]
		local var3_52, var4_52 = IslandCalcUtil.GetTypeAndIdByUniqueId(var2_52)

		if var3_52 == IslandConst.UNIT_LIST_OBJ then
			local var5_52 = arg0_52:GetUnitModuleWithType(var3_52, var4_52)

			if var5_52 then
				arg0_52:Op("NotifiyIsland", ISLAND_EX_EVT.APPROACH_OBJECT, var5_52.id)
			end
		end
	end
end

function var0_0.OnDetectorSelected(arg0_53, arg1_53)
	local var0_53 = arg1_53.node

	if not var0_53 then
		return
	end

	local var1_53 = var0_53:GetBlackboardVariable("SelectedObj")

	if not var1_53 or var1_53 == "" then
		arg0_53:OnClearSelectedUnit()
	else
		local var2_53, var3_53 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_53)
		local var4_53 = arg0_53:GetUnitModuleWithType(var2_53, var3_53)

		if var4_53 then
			arg0_53:OnSelectedUnit(var4_53)
		end
	end
end

function var0_0.OnClearSelectedUnit(arg0_54)
	return
end

function var0_0.OnSelectedUnit(arg0_55, arg1_55)
	return
end

function var0_0.OnRefreshInteractionBtn(arg0_56)
	arg0_56:GetSubView(IslandInteractionView):RefreshInteractionBtns()
end

function var0_0.OnStartStory(arg0_57)
	arg0_57.playingStory = true

	arg0_57:DisablePlayerOp()
end

function var0_0.OnEndStory(arg0_58)
	arg0_58.playingStory = false

	arg0_58:EnablePlayerOp()
end

function var0_0.DisablePlayerOp(arg0_59)
	arg0_59.player:StopMoveHandle()
	arg0_59:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_59:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_59:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_59:GetSubView(IslandOpView):TryDisable()
end

function var0_0.EnablePlayerOp(arg0_60)
	arg0_60:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_60:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_60:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_60:GetSubView(IslandOpView):TryEnable()
end

function var0_0.OnStartPerformance(arg0_61)
	return
end

function var0_0.OnEndPerformance(arg0_62)
	if not arg0_62.anyPageOpen then
		arg0_62:GetSubView(IslandOpView):ResetShowBalance()
	end
end

function var0_0.OnPlayChatBubble(arg0_63, arg1_63)
	local var0_63 = arg0_63:GetAllUnits()

	arg0_63:GetSubView(IslandTopHeadHudView):PlayBubble(arg1_63.name, var0_63, arg1_63.callback)
end

function var0_0.OnAnyPageOpen(arg0_64, arg1_64)
	arg0_64.anyPageOpen = true

	arg0_64.player:StopMoveHandle()
	arg0_64:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_64:GetSubView(IslandSlotHudView):TryDisable()
	arg0_64:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_64:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_64:GetSubView(IslandAniamtionOpView):CloseAndReset()
end

function var0_0.OnAllPageClose(arg0_65)
	arg0_65.anyPageOpen = false

	arg0_65:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_65:GetSubView(IslandSlotHudView):TryEnable()
	arg0_65:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_65:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnChange_Photo_Height(arg0_66, arg1_66, arg2_66)
	arg0_66.takePhotoModel = arg1_66

	if arg0_66.takePhotoModel == IslandConst.TakePhotoModel.First then
		-- block empty
	elseif arg0_66.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_66.thirdTakePhotoItem:ChangeHeight(arg2_66)
	end
end

function var0_0.OnChangeTakePhotoModel(arg0_67, arg1_67)
	arg0_67.takePhotoModel = arg1_67

	if arg0_67.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_67.firstTakePhotoItem:Enable()

		arg0_67.firstTakePhotoItem._tf.position = arg0_67.player._tf.position
		arg0_67.firstTakePhotoItem._tf.rotation = arg0_67.player._tf.rotation

		arg0_67.firstTakePhotoItem:SetTargetRotation(arg0_67.player._tf.rotation)
		arg0_67.player:SetActiveByLayer(false)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook)):SetPosAndRotationByTargetDir(arg0_67.player._tf.forward)
	elseif arg0_67.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_67.thirdTakePhotoItem:Enable()

		arg0_67.player._tf.position = arg0_67.firstTakePhotoItem._tf.position
		arg0_67.player._tf.rotation = arg0_67.firstTakePhotoItem._tf.rotation

		arg0_67.player:SetTargetRotation(arg0_67.firstTakePhotoItem._tf.rotation)
		arg0_67.player:SetActiveByLayer(true)

		arg0_67.thirdTakePhotoItem._tf.position = arg0_67.firstTakePhotoItem._tf:TransformPoint(Vector3(0, 0, -5))
		arg0_67.thirdTakePhotoItem._tf.rotation = arg0_67.firstTakePhotoItem._tf.rotation

		arg0_67.thirdTakePhotoItem:SetTargetRotation(arg0_67.firstTakePhotoItem._tf.rotation)

		local var0_67 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook))
		local var1_67 = arg0_67.player._tf.position + Vector3(0, 0.5, 0)
		local var2_67 = arg0_67.thirdTakePhotoItem._tf.position + Vector3(0, 1, 0)

		var0_67:SetPosAndRotationByTargetDir((var1_67 - var2_67).normalized)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	else
		arg0_67.firstTakePhotoItem:Disable()
		arg0_67.thirdTakePhotoItem:Disable()

		arg0_67.player._tf.position = arg0_67.firstTakePhotoItem._tf.position
		arg0_67.player._tf.rotation = arg0_67.firstTakePhotoItem._tf.rotation

		arg0_67.player:SetTargetRotation(arg0_67.firstTakePhotoItem._tf.rotation)
		arg0_67.player:SetActiveByLayer(true)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraLook)):ResetCameraPos()
	end

	arg0_67:GetSubView(IslandOpView):ChangeTakePhotoModel(arg1_67)
end

function var0_0.OnSetOpMoveBtnActve(arg0_68, arg1_68, arg2_68)
	arg0_68:GetSubView(IslandOpView):ShowOrHideMoveBtn(arg1_68, arg2_68)
end

function var0_0.OnInterActionBegin(arg0_69)
	arg0_69.player:StopMoveHandle()
	arg0_69:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_70)
	arg0_70:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_71, arg1_71)
	arg0_71.showInterObjId = arg1_71.id

	arg0_71:GetSubView(IslandInteractionView):ShowInterActionPanel(arg1_71)
	arg0_71:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_71.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_72, arg1_72)
	if arg0_72.showInterObjId ~= arg1_72.id then
		return
	end

	arg0_72.showInterObjId = nil

	arg0_72:GetSubView(IslandInteractionView):HideInterActionPanel()
end

function var0_0.OnStartGuide(arg0_73)
	arg0_73.player:StopMoveHandle()
	arg0_73:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_74)
	if arg0_74.playingStory then
		return
	end

	arg0_74:GetSubView(IslandOpView):EnableInput()
end

function var0_0.DisableInput(arg0_75)
	arg0_75.player:StopMoveHandle()
	arg0_75:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_76)
	arg0_76:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnTracking(arg0_77, arg1_77)
	arg0_77.trackId = tonumber(arg1_77.id)
	arg0_77.trackType = arg1_77.typ or IslandTaskType.MAIN
	arg0_77.needTryTrack = true
end

function var0_0.TryTrack(arg0_78)
	arg0_78:TrySetTrack(arg0_78.trackId)
end

function var0_0.TrySetTrack(arg0_79, arg1_79)
	local var0_79 = arg0_79:GetOptTrackingTarget(arg1_79)

	if not var0_79 or not var0_79._go then
		return
	end

	arg0_79:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_79.player, var0_79, arg1_79, arg0_79.trackType)

	arg0_79.needTryTrack = false
end

local function var1_0(arg0_80, arg1_80)
	local var0_80 = pg.island_world_objects[arg0_80]

	if not var0_80 then
		return
	end

	return var0_80.mapId == arg1_80
end

local function var2_0(arg0_81, arg1_81, arg2_81)
	for iter0_81, iter1_81 in ipairs(arg0_81) do
		for iter2_81, iter3_81 in ipairs(iter1_81[2]) do
			local var0_81 = pg.island_interaction[iter3_81]

			if var0_81.type == arg2_81 and var1_0(tonumber(var0_81.param), arg1_81) then
				return iter1_81[1]
			end
		end
	end

	return nil
end

local function var3_0(arg0_82)
	local var0_82 = {}
	local var1_82 = {}

	for iter0_82, iter1_82 in ipairs(arg0_82) do
		for iter2_82, iter3_82 in ipairs(iter1_82[2]) do
			local var2_82 = pg.island_interaction[iter3_82]

			if var2_82.type == IslandInteractionUntil.TYPE_TRANSFER then
				table.insert(var0_82, iter1_82[1])
			elseif var2_82.type == IslandInteractionUntil.TYPE_SP_TRANSFER then
				table.insert(var1_82, iter1_82[1])
			end
		end
	end

	if #var1_82 > 0 then
		return var1_82[1]
	end

	if #var0_82 > 0 then
		return var0_82[1]
	end

	return nil
end

function var0_0.GetOptTrackingTarget(arg0_83, arg1_83)
	local var0_83 = arg0_83:GetUnitModule(arg1_83)

	if var0_83 then
		return var0_83
	end

	local var1_83 = pg.island_world_objects[arg1_83]

	if not var1_83 then
		return nil
	end

	local var2_83 = {}

	for iter0_83, iter1_83 in ipairs(arg0_83:GetUnitListByKey(IslandConst.UNIT_LIST_OBJ)) do
		local var3_83, var4_83 = iter1_83:IsMapTransfer()

		if var3_83 then
			table.insert(var2_83, {
				iter1_83,
				var4_83
			})
		end
	end

	local var5_83
	local var6_83 = var2_0(var2_83, var1_83.mapId, IslandInteractionUntil.TYPE_TRANSFER) or var2_0(var2_83, var1_83.mapId, IslandInteractionUntil.TYPE_SP_TRANSFER)

	var6_83 = var6_83 or var3_0(var2_83)

	return var6_83
end

function var0_0.OnUnTracking(arg0_84)
	arg0_84.trackId = nil

	arg0_84:GetSubView(IslandDistanceView):CancelTracking()
end

function var0_0.OnUpdateCustomOpPositon(arg0_85)
	arg0_85:GetSubView(IslandOpView):InitOpCustumPositon()
end

function var0_0.OnGenUnit(arg0_86, arg1_86, arg2_86)
	local var0_86 = arg0_86.unitBuilders[arg1_86:GetType()]:Build(arg1_86, arg2_86)

	arg0_86:AddUnit(var0_86)

	if arg1_86:IsPlayer() then
		arg0_86.player = var0_86
	end

	if arg1_86:IsFirstTakePhoto() then
		arg0_86.firstTakePhotoItem = var0_86
	end

	if arg1_86:IsThirdTakePhoto() then
		arg0_86.thirdTakePhotoItem = var0_86
	end
end

function var0_0.OnGenSystem(arg0_87, arg1_87)
	local var0_87 = arg0_87.systemBuilders[arg1_87:GetType()]:Build(arg1_87)

	arg0_87:AddUnit(var0_87)
end

function var0_0.OnActiveOrDisactiveUnit(arg0_88, arg1_88, arg2_88, arg3_88)
	local var0_88

	if arg1_88 == 0 then
		var0_88 = arg0_88.player
	else
		var0_88 = arg0_88:GetUnitModuleWithType(arg2_88, arg1_88)
	end

	if var0_88 and arg3_88 then
		var0_88:Enable()
	end

	if var0_88 and not arg3_88 then
		var0_88:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_89, arg1_89, arg2_89, arg3_89)
	local var0_89 = arg0_89:GetUnitModuleWithType(arg2_89, arg1_89)

	if var0_89 then
		var0_89._go.transform.position = arg3_89
	end
end

function var0_0.OnResetUnitRotation(arg0_90, arg1_90, arg2_90, arg3_90)
	local var0_90 = arg0_90:GetUnitModuleWithType(arg2_90, arg1_90)

	if var0_90 then
		var0_90._go.transform.eulerAngles = arg3_90
	end
end

function var0_0.OnMoveUnit(arg0_91, arg1_91)
	assert(arg1_91.type, "type should be exist")

	local var0_91 = arg0_91:GetUnitModuleWithType(arg1_91.type, arg1_91.id)

	if var0_91 then
		var0_91:SetDestination(arg1_91.position, arg1_91.speed, nil, arg1_91.charaRadius)
	end
end

function var0_0.OnStopUnit(arg0_92, arg1_92)
	assert(arg1_92.type, "type should be exist")

	local var0_92 = arg0_92:GetUnitModuleWithType(arg1_92.type, arg1_92.id)

	if var0_92 then
		var0_92:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_93, arg1_93, arg2_93)
	local var0_93 = arg0_93:GetUnitListByKey(arg1_93)
	local var1_93 = 0

	for iter0_93, iter1_93 in ipairs(var0_93 or {}) do
		if iter1_93.id == arg2_93 then
			var1_93 = iter0_93

			break
		end
	end

	if var1_93 > 0 then
		local var2_93 = var0_93[var1_93]

		for iter2_93 = #arg0_93.pathfinders, 1, -1 do
			local var3_93 = arg0_93.pathfinders[iter2_93]

			if var3_93:IsSameUnit(var2_93) then
				var3_93:Dispose()
				table.remove(arg0_93.pathfinders, iter2_93)
			end
		end

		arg0_93:RemoveUnit(var2_93)
		var2_93:Dispose()
		arg0_93:OnHideUnitHudAndOpBtn({
			type = arg1_93,
			id = var2_93.id
		}, true)
		arg0_93:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_93,
			id = arg2_93
		})
		arg0_93:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var2_93)
		arg0_93:GetSubView(IslandInteractionView):CloseInterActionPanelByUnitIdRemove(arg2_93)
	end
end

function var0_0.GetAllUnits(arg0_94)
	table.clear(arg0_94._unitList)

	for iter0_94, iter1_94 in pairs(arg0_94:GetUnitListRegitser()) do
		for iter2_94, iter3_94 in pairs(iter1_94) do
			table.insert(arg0_94._unitList, iter3_94)
		end
	end

	return arg0_94._unitList
end

function var0_0.GetUnitModuleWithType(arg0_95, arg1_95, arg2_95)
	local var0_95 = arg0_95:GetUnitListByKey(arg1_95)

	for iter0_95, iter1_95 in ipairs(var0_95) do
		if iter1_95.id == arg2_95 then
			return iter1_95
		end
	end

	return nil
end

function var0_0.GetPlayerUnitModule(arg0_96, arg1_96)
	return arg0_96:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_96)
end

function var0_0.GetUnitModule(arg0_97, arg1_97)
	return arg0_97:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_97)
end

function var0_0.GetSystemModule(arg0_98, arg1_98)
	return arg0_98:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_98)
end

function var0_0.GetSystemUnitModule(arg0_99, arg1_99)
	return arg0_99:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_99)
end

function var0_0.GetStrollUnitModule(arg0_100, arg1_100)
	return arg0_100:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_100)
end

function var0_0.GetManageSystemModule(arg0_101, arg1_101)
	return arg0_101:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_101)
end

function var0_0.GetFollowerModule(arg0_102, arg1_102)
	return arg0_102:GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg1_102)
end

function var0_0.OnMovePlayerBefore(arg0_103)
	if arg0_103.player:CheckMovement() and arg0_103.isLockPlayInput then
		arg0_103.isLockPlayInput = false
	end

	arg0_103:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnLockPlayerInput(arg0_104)
	if arg0_104.playerInputing then
		arg0_104.isLockPlayInput = true

		arg0_104.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerMove(arg0_105, arg1_105)
	if arg0_105.isLockPlayInput then
		return
	end

	arg0_105.playerInputing = true

	if arg0_105.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_105.firstTakePhotoItem:MoveHandle(arg1_105.targetDir, arg1_105.force)
	elseif arg0_105.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_105.thirdTakePhotoItem:MoveHandle(arg1_105.targetDir, arg1_105.force)
	else
		arg0_105.player:MoveHandle(arg1_105.targetDir, arg1_105.force)
	end
end

function var0_0.OnPlayerStopMove(arg0_106)
	if arg0_106.isLockPlayInput then
		arg0_106.isLockPlayInput = false
	end

	arg0_106.playerInputing = true

	if arg0_106.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_106.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_106.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_106.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_106.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerStopMoveHandle(arg0_107)
	if arg0_107.isLockPlayInput then
		arg0_107.isLockPlayInput = false
	end

	arg0_107.playerInputing = true

	if arg0_107.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_107.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_107.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_107.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_107.player:StopMoveHandleByInput()
	end
end

function var0_0.OnPlayerJump(arg0_108)
	if arg0_108.takePhotoModel == IslandConst.TakePhotoModel.First or arg0_108.takePhotoModel == IslandConst.TakePhotoModel.Third then
		return
	end

	arg0_108.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_109)
	arg0_109.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_110)
	if arg0_110.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_110.firstTakePhotoItem:OnPlayerPlayerSprint()
	elseif arg0_110.takePhotoModel == IslandConst.TakePhotoModel.Third then
		-- block empty
	else
		arg0_110.player:OnPlayerPlayerSprint()
	end
end

function var0_0.OnStopPlayerSprint(arg0_111)
	if arg0_111.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_111.firstTakePhotoItem:OnStopPlayerSprint()
	elseif arg0_111.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_111.thirdTakePhotoItem:OnStopPlayerSprint()
	else
		arg0_111.player:OnStopPlayerSprint()
	end
end

function var0_0.OnPlayerWork(arg0_112, arg1_112, arg2_112)
	arg0_112.player:WorkHandle(arg1_112, arg2_112)
end

function var0_0.OnPlayerDeviceStateChange(arg0_113, arg1_113)
	arg0_113.player:DeviceStateHandle(arg1_113)
end

function var0_0.OnSetVisitorSyncData(arg0_114, arg1_114, arg2_114)
	local var0_114 = arg0_114:GetPlayerUnitModule(arg1_114)

	if var0_114 then
		var0_114:UpdateSyncData(arg2_114)
	end
end

function var0_0.OnWorldObjectStartInteraction(arg0_115, arg1_115, arg2_115, arg3_115)
	local var0_115 = arg2_115:GetHostId()
	local var1_115 = arg2_115:GetUserId()
	local var2_115 = arg0_115:GetUnitModule(var0_115)
	local var3_115 = arg0_115:GetPlayerUnitModule(var1_115)
	local var4_115 = arg0_115.player == var3_115

	if var4_115 then
		arg0_115:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_115 = arg1_115:GetTimeline()[arg3_115]
	local var6_115 = arg1_115:GetBlackboardParam()[arg3_115]

	var2_115:StartInteract(var3_115, arg2_115.id, arg3_115, var5_115, var6_115, arg1_115:AnySlotUsing(), var4_115)
end

function var0_0.OnWorldObjectEndInteraction(arg0_116, arg1_116, arg2_116)
	local var0_116 = arg2_116:GetHostId()
	local var1_116 = arg2_116:GetUserId()
	local var2_116 = arg0_116:GetUnitModule(var0_116)
	local var3_116 = arg0_116:GetPlayerUnitModule(var1_116)
	local var4_116 = arg0_116.player == var3_116

	if var4_116 then
		arg0_116:GetSubView(IslandOpView):EndInteraction()
	end

	var2_116:EndInteract(var3_116, arg2_116.id, not arg1_116:AnySlotUsing(), var4_116)
end

function var0_0.OnWorldObjectInitStatus(arg0_117, arg1_117, arg2_117)
	local var0_117 = arg0_117:GetUnitModule(arg1_117.id)
	local var1_117 = arg1_117:GetTimeline()[arg2_117]
	local var2_117 = arg1_117:GetBlackboardParam()[arg2_117]

	var0_117:InitStatus(arg2_117, var1_117, var2_117)
end

function var0_0.OnPlayerAreaChange(arg0_118)
	arg0_118.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_119, arg1_119, arg2_119)
	arg0_119.player:OnChangeDress(arg1_119, arg2_119)
end

function var0_0.OnCharacterChangeDress(arg0_120, arg1_120, arg2_120, arg3_120, arg4_120)
	local var0_120 = arg0_120:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_120)

	if var0_120 then
		var0_120:OnCharacterChangeDress(arg2_120, arg3_120, arg4_120)
	end

	local var1_120 = arg0_120:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_120, iter1_120 in ipairs(var1_120) do
		if iter1_120:GetDataVO():IsSameShip(arg1_120) then
			iter1_120:OnCharacterChangeDress(arg2_120, arg3_120, arg4_120)
		end
	end

	local var2_120 = arg0_120:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter2_120, iter3_120 in ipairs(var2_120) do
		if iter3_120:GetDataVO():IsSameShip(arg1_120) then
			iter3_120:OnCharacterChangeDress(arg2_120, arg3_120, arg4_120)
		end
	end
end

function var0_0.OnStartDelegation(arg0_121, arg1_121, arg2_121)
	local var0_121 = arg0_121:GetSystemModule(arg1_121.build_id)

	if var0_121 then
		var0_121:StartDelegation(arg1_121)
	end
end

function var0_0.OnEndDelegation(arg0_122, arg1_122, arg2_122)
	local var0_122 = arg0_122:GetSystemModule(arg1_122.build_id)

	if var0_122 then
		var0_122:EndDelegation(arg1_122)
	end
end

function var0_0.GetPlayerPosition(arg0_123)
	return arg0_123.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_124, arg1_124)
	local var0_124 = arg0_124:GetUnitModule(arg1_124)

	return var0_124 and var0_124._go.transform.position
end

function var0_0.OnShowUnitHudAndOpBtn(arg0_125, arg1_125)
	arg0_125.currentHudUnitData = arg1_125

	arg0_125:GetSubView(IslandSlotHudView):ShowHud(arg1_125.id, arg1_125.height)
	arg0_125:GetSubView(IslandOpView):UpdateOperationButton(arg1_125.operationType, arg1_125.id)

	if arg1_125.isHighLightControl then
		arg0_125.detectionSystem:HighLightUnitHandle(arg1_125.id, true)
	end
end

function var0_0.OnHideUnitHudAndOpBtn(arg0_126, arg1_126, arg2_126)
	if not arg0_126.currentHudUnitData then
		return
	end

	if arg0_126.currentHudUnitData.id ~= arg1_126.id or arg0_126.currentHudUnitData.type ~= arg1_126.type then
		return
	end

	if not arg2_126 then
		arg0_126.currentHudUnitData = nil
	end

	arg0_126:GetSubView(IslandSlotHudView):HideUnitHud(arg1_126.id)
	arg0_126:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_126.id)

	if arg1_126.isHighLightControl then
		arg0_126.detectionSystem:HighLightUnitHandle(arg1_126.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_127, arg1_127)
	if not arg0_127.currentHudUnitData then
		return
	end

	if arg1_127 ~= arg0_127.currentHudUnitData.id then
		return
	end

	arg0_127:GetSubView(IslandSlotHudView):UpdateHud(arg0_127.currentHudUnitData.id, arg0_127.currentHudUnitData.height)
	arg0_127:GetSubView(IslandOpView):UpdateOperationButton(arg0_127.currentHudUnitData.operationType, arg0_127.currentHudUnitData.id)
end

function var0_0.OnUpdateHandCollectUnit(arg0_128, arg1_128)
	local var0_128 = arg0_128:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_128)

	if var0_128 then
		var0_128:UpdateHandCollet()
		var0_128:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_129, arg1_129)
	arg0_129:GetSubView(IslandTopHeadHudView):ShowHud(arg1_129)
	arg0_129:GetSubView(IslandDistanceView):ShowHud(arg1_129.id)
end

function var0_0.OnRefreshHud(arg0_130, arg1_130)
	arg0_130:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_130)
end

function var0_0.OnHideHud(arg0_131, arg1_131)
	arg0_131:GetSubView(IslandTopHeadHudView):HideHud(arg1_131)
	arg0_131:GetSubView(IslandDistanceView):HideHud(arg1_131.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_132, arg1_132)
	local var0_132 = arg0_132:GetUnitModuleWithType(arg1_132.type, arg1_132.id)

	if var0_132 then
		var0_132:DelegateSlotStartPerform()
	end
end

function var0_0.OnRecycleAllSlotEffct(arg0_133)
	arg0_133.effectMgr:RecycleAllSlotEffct()
end

function var0_0.OnLoadDelegatePreviewRole(arg0_134, arg1_134, arg2_134)
	arg0_134.effectMgr:LoadDelegatePreviewRole(arg1_134, arg2_134)
end

function var0_0.OnUnLoadDelegatePreviewRole(arg0_135)
	arg0_135.effectMgr:UnLoadDelegatePreviewRole()
end

function var0_0.OnSelectSlotEffectShow(arg0_136, arg1_136, arg2_136, arg3_136, arg4_136)
	arg0_136.effectMgr:SelectSlotEffectShow(arg1_136, arg2_136, arg3_136, arg4_136)
end

function var0_0.OnTakePlantAttack(arg0_137, arg1_137)
	local var0_137 = arg0_137:GetUnitModuleWithType(arg1_137.type, arg1_137.id)

	if var0_137 then
		var0_137:TakeAttack()
	end
end

function var0_0.OnStartManage(arg0_138, arg1_138)
	local var0_138 = arg0_138:GetManageSystemModule(arg1_138.id)

	if var0_138 then
		var0_138:StartManage(arg1_138)
	end
end

function var0_0.OnEndManage(arg0_139, arg1_139)
	local var0_139 = arg0_139:GetManageSystemModule(arg1_139.id)

	if var0_139 then
		var0_139:EndManage(arg1_139)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_140)
	arg0_140:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnRefreshWeatherSystem(arg0_141)
	arg0_141.weatherSystem:Play()
end

function var0_0.OnDispose(arg0_142)
	arg0_142.detectionSystem:Dispose()
	arg0_142.effectMgr:Dispose()
	arg0_142.coupleActionPlayer:Dispose()
	arg0_142.coupleAction4FollowerPlayer:Dispose()
	arg0_142.npcActionPlayer:Dispose()
	arg0_142.weatherSystem:Dispose()

	for iter0_142, iter1_142 in ipairs(arg0_142.views) do
		iter1_142:Dispose()
	end

	for iter2_142, iter3_142 in ipairs(arg0_142.pathfinders) do
		iter3_142:Dispose()
	end

	for iter4_142, iter5_142 in ipairs(arg0_142:GetAllUnits()) do
		iter5_142:Dispose()
	end

	for iter6_142, iter7_142 in pairs(arg0_142.unitBuilders) do
		iter7_142:Dispose()
	end

	for iter8_142, iter9_142 in pairs(arg0_142.systemBuilders) do
		iter9_142:Dispose()
	end

	arg0_142.npcActionPlayer = nil
	arg0_142.coupleActionPlayer = nil
	arg0_142.coupleAction4FollowerPlayer = nil
	arg0_142.pathfinders = nil
	arg0_142.unitBuilders = nil
	arg0_142.systemBuilders = nil
	arg0_142.views = nil
	arg0_142.player = nil
	arg0_142.isInit = false
	arg0_142._unitList = nil
	arg0_142.detectionSystem = nil
	arg0_142.effectMgr = nil
end

return var0_0
