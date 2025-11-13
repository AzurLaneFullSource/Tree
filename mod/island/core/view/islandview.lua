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
	arg0_1.coupleNpcWordPlayer = IslandCoupleNpcWordPlayer.New(arg0_1)
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

	if arg0_16.needTryMainTrack then
		arg0_16:TryMainTrack()
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
	arg0_18:AddListener(ISLAND_EVT.RAW_PLAY_BUBBLE, arg0_18.OnRawPlayChatBubble)
	arg0_18:AddListener(ISLAND_EVT.RAW_STOP_BUBBLE, arg0_18.OnRawStopChatBubble)
	arg0_18:AddListener(ISLAND_EVT.START_STORY, arg0_18.OnStartStory)
	arg0_18:AddListener(ISLAND_EVT.END_STORY, arg0_18.OnEndStory)
	arg0_18:AddListener(ISLAND_EVT.START_DEGATION, arg0_18.OnStartDelegation)
	arg0_18:AddListener(ISLAND_EVT.END_DEGATION, arg0_18.OnEndDelegation)
	arg0_18:AddListener(ISLAND_EVT.GEN_SYSTEM, arg0_18.OnGenSystem)
	arg0_18:AddListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_18.OnWorldObjectStartInteraction)
	arg0_18:AddListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_18.OnWorldObjectEndInteraction)
	arg0_18:AddListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_18.OnWorldObjectInitStatus)
	arg0_18:AddListener(ISLAND_EVT.INIT_INTERACTION_OP_VIEW, arg0_18.InitInteractionOpView)
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
	arg0_19:RemoveListener(ISLAND_EVT.RAW_PLAY_BUBBLE, arg0_19.OnRawPlayChatBubble)
	arg0_19:RemoveListener(ISLAND_EVT.RAW_STOP_BUBBLE, arg0_19.OnRawStopChatBubble)
	arg0_19:RemoveListener(ISLAND_EVT.START_STORY, arg0_19.OnStartStory)
	arg0_19:RemoveListener(ISLAND_EVT.END_STORY, arg0_19.OnEndStory)
	arg0_19:RemoveListener(ISLAND_EVT.START_DEGATION, arg0_19.OnStartDelegation)
	arg0_19:RemoveListener(ISLAND_EVT.END_DEGATION, arg0_19.OnEndDelegation)
	arg0_19:RemoveListener(ISLAND_EVT.GEN_SYSTEM, arg0_19.OnGenSystem)
	arg0_19:RemoveListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_19.OnWorldObjectStartInteraction)
	arg0_19:RemoveListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_19.OnWorldObjectEndInteraction)
	arg0_19:RemoveListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_19.OnWorldObjectInitStatus)
	arg0_19:RemoveListener(ISLAND_EVT.INIT_INTERACTION_OP_VIEW, arg0_19.InitInteractionOpView)
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

function var0_0.OnFollowerAdd(arg0_26, arg1_26)
	arg0_26:GetSubView(IslandOpView):FlushFollowerList()
	arg0_26.coupleNpcWordPlayer:Play(arg1_26)
end

function var0_0.OnFollowerDel(arg0_27, arg1_27)
	arg0_27:GetSubView(IslandOpView):FlushFollowerList()
	arg0_27.coupleNpcWordPlayer:Stop(arg1_27)
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

function var0_0.OnRawPlayChatBubble(arg0_64, arg1_64)
	local var0_64 = arg0_64:GetAllUnits()

	arg0_64:GetSubView(IslandTopHeadHudView):RawPlayBubble(arg1_64.info, var0_64, arg1_64.callback)
end

function var0_0.OnRawStopChatBubble(arg0_65, arg1_65)
	arg0_65:GetSubView(IslandTopHeadHudView):RawStopBubble(arg1_65.info)
end

function var0_0.OnAnyPageOpen(arg0_66, arg1_66)
	arg0_66.anyPageOpen = true

	arg0_66.player:StopMoveHandle()
	arg0_66:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_66:GetSubView(IslandSlotHudView):TryDisable()
	arg0_66:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_66:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_66:GetSubView(IslandAniamtionOpView):CloseAndReset()
end

function var0_0.OnAllPageClose(arg0_67)
	arg0_67.anyPageOpen = false

	arg0_67:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_67:GetSubView(IslandSlotHudView):TryEnable()
	arg0_67:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_67:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnChange_Photo_Height(arg0_68, arg1_68, arg2_68)
	arg0_68.takePhotoModel = arg1_68

	if arg0_68.takePhotoModel == IslandConst.TakePhotoModel.First then
		-- block empty
	elseif arg0_68.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_68.thirdTakePhotoItem:ChangeHeight(arg2_68)
	end
end

function var0_0.OnChangeTakePhotoModel(arg0_69, arg1_69)
	arg0_69.takePhotoModel = arg1_69

	if arg0_69.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_69.firstTakePhotoItem:Enable()

		arg0_69.firstTakePhotoItem._tf.position = arg0_69.player._tf.position
		arg0_69.firstTakePhotoItem._tf.rotation = arg0_69.player._tf.rotation

		arg0_69.firstTakePhotoItem:SetTargetRotation(arg0_69.player._tf.rotation)
		arg0_69.player:SetActiveByLayer(false)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook)):SetPosAndRotationByTargetDir(arg0_69.player._tf.forward)
	elseif arg0_69.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_69.thirdTakePhotoItem:Enable()

		arg0_69.player._tf.position = arg0_69.firstTakePhotoItem._tf.position
		arg0_69.player._tf.rotation = arg0_69.firstTakePhotoItem._tf.rotation

		arg0_69.player:SetTargetRotation(arg0_69.firstTakePhotoItem._tf.rotation)
		arg0_69.player:SetActiveByLayer(true)

		arg0_69.thirdTakePhotoItem._tf.position = arg0_69.firstTakePhotoItem._tf:TransformPoint(Vector3(0, 0, -5))
		arg0_69.thirdTakePhotoItem._tf.rotation = arg0_69.firstTakePhotoItem._tf.rotation

		arg0_69.thirdTakePhotoItem:SetTargetRotation(arg0_69.firstTakePhotoItem._tf.rotation)

		local var0_69 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook))
		local var1_69 = arg0_69.player._tf.position + Vector3(0, 0.5, 0)
		local var2_69 = arg0_69.thirdTakePhotoItem._tf.position + Vector3(0, 1, 0)

		var0_69:SetPosAndRotationByTargetDir((var1_69 - var2_69).normalized)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	else
		arg0_69.firstTakePhotoItem:Disable()
		arg0_69.thirdTakePhotoItem:Disable()

		arg0_69.player._tf.position = arg0_69.firstTakePhotoItem._tf.position
		arg0_69.player._tf.rotation = arg0_69.firstTakePhotoItem._tf.rotation

		arg0_69.player:SetTargetRotation(arg0_69.firstTakePhotoItem._tf.rotation)
		arg0_69.player:SetActiveByLayer(true)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraLook)):ResetCameraPos()
	end

	arg0_69:GetSubView(IslandOpView):ChangeTakePhotoModel(arg1_69)
end

function var0_0.OnSetOpMoveBtnActve(arg0_70, arg1_70, arg2_70)
	arg0_70:GetSubView(IslandOpView):ShowOrHideMoveBtn(arg1_70, arg2_70)
end

function var0_0.OnInterActionBegin(arg0_71)
	arg0_71.player:StopMoveHandle()
	arg0_71:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_72)
	arg0_72:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_73, arg1_73)
	arg0_73.showInterObjId = arg1_73.id

	arg0_73:GetSubView(IslandInteractionView):ShowInterActionPanel(arg1_73)
	arg0_73:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_73.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_74, arg1_74)
	if arg0_74.showInterObjId ~= arg1_74.id then
		return
	end

	arg0_74.showInterObjId = nil

	arg0_74:GetSubView(IslandInteractionView):HideInterActionPanel()
end

function var0_0.OnStartGuide(arg0_75)
	arg0_75.player:StopMoveHandle()
	arg0_75:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_76)
	if arg0_76.playingStory then
		return
	end

	arg0_76:GetSubView(IslandOpView):EnableInput()
end

function var0_0.DisableInput(arg0_77)
	arg0_77.player:StopMoveHandle()
	arg0_77:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_78)
	arg0_78:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnTracking(arg0_79, arg1_79)
	local var0_79 = arg1_79.trackType

	if var0_79 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_79.mainTrackId = tonumber(arg1_79.id)
		arg0_79.needTryMainTrack = true
	elseif var0_79 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_79.trackId = tonumber(arg1_79.id)
		arg0_79.trackType = arg1_79.typ or IslandTaskType.MAIN
		arg0_79.needTryTrack = true
	end
end

function var0_0.TryTrack(arg0_80)
	arg0_80:TrySetTrack(arg0_80.trackId)
end

function var0_0.TrySetTrack(arg0_81, arg1_81)
	local var0_81 = arg0_81:GetOptTrackingTarget(arg1_81)

	if not var0_81 or not var0_81._go then
		return
	end

	arg0_81:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_81.player, var0_81, arg1_81, arg0_81.trackType, IslandTaskTrackCard.TYPES.OTHER)

	arg0_81.needTryTrack = false
end

function var0_0.TryMainTrack(arg0_82)
	arg0_82:TrySetMainTrack(arg0_82.mainTrackId)
end

function var0_0.TrySetMainTrack(arg0_83, arg1_83)
	local var0_83 = arg0_83:GetOptTrackingTarget(arg1_83)

	if not var0_83 or not var0_83._go then
		return
	end

	arg0_83:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_83.player, var0_83, arg1_83, IslandTaskType.MAIN, IslandTaskTrackCard.TYPES.MAIN)

	arg0_83.needTryMainTrack = false
end

function var0_0.OnUnTracking(arg0_84, arg1_84)
	if arg1_84 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_84.mainTrackId = nil
	elseif arg1_84 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_84.trackId = nil
	end

	arg0_84:GetSubView(IslandDistanceView):CancelTracking(arg1_84)
end

local function var1_0(arg0_85, arg1_85)
	local var0_85 = pg.island_world_objects[arg0_85]

	if not var0_85 then
		return
	end

	return var0_85.mapId == arg1_85
end

local function var2_0(arg0_86, arg1_86, arg2_86)
	for iter0_86, iter1_86 in ipairs(arg0_86) do
		for iter2_86, iter3_86 in ipairs(iter1_86[2]) do
			local var0_86 = pg.island_interaction[iter3_86]

			if var0_86.type == arg2_86 and var1_0(tonumber(var0_86.param), arg1_86) then
				return iter1_86[1]
			end
		end
	end

	return nil
end

local function var3_0(arg0_87)
	local var0_87 = {}
	local var1_87 = {}

	for iter0_87, iter1_87 in ipairs(arg0_87) do
		for iter2_87, iter3_87 in ipairs(iter1_87[2]) do
			local var2_87 = pg.island_interaction[iter3_87]

			if var2_87.type == IslandInteractionUntil.TYPE_TRANSFER then
				table.insert(var0_87, iter1_87[1])
			elseif var2_87.type == IslandInteractionUntil.TYPE_SP_TRANSFER then
				table.insert(var1_87, iter1_87[1])
			end
		end
	end

	if #var1_87 > 0 then
		return var1_87[1]
	end

	if #var0_87 > 0 then
		return var0_87[1]
	end

	return nil
end

function var0_0.GetOptTrackingTarget(arg0_88, arg1_88)
	local var0_88 = arg0_88:GetUnitModule(arg1_88)

	if var0_88 then
		return var0_88
	end

	local var1_88 = pg.island_world_objects[arg1_88]

	if not var1_88 then
		return nil
	end

	local var2_88 = {}

	for iter0_88, iter1_88 in ipairs(arg0_88:GetUnitListByKey(IslandConst.UNIT_LIST_OBJ)) do
		local var3_88, var4_88 = iter1_88:IsMapTransfer()

		if var3_88 then
			table.insert(var2_88, {
				iter1_88,
				var4_88
			})
		end
	end

	local var5_88
	local var6_88 = var2_0(var2_88, var1_88.mapId, IslandInteractionUntil.TYPE_TRANSFER) or var2_0(var2_88, var1_88.mapId, IslandInteractionUntil.TYPE_SP_TRANSFER)

	var6_88 = var6_88 or var3_0(var2_88)

	return var6_88
end

function var0_0.OnUpdateCustomOpPositon(arg0_89)
	arg0_89:GetSubView(IslandOpView):InitOpCustumPositon()
end

function var0_0.OnGenUnit(arg0_90, arg1_90, arg2_90)
	local var0_90 = arg0_90.unitBuilders[arg1_90:GetType()]:Build(arg1_90, arg2_90)

	arg0_90:AddUnit(var0_90)

	if arg1_90:IsPlayer() then
		arg0_90.player = var0_90
	end

	if arg1_90:IsFirstTakePhoto() then
		arg0_90.firstTakePhotoItem = var0_90
	end

	if arg1_90:IsThirdTakePhoto() then
		arg0_90.thirdTakePhotoItem = var0_90
	end
end

function var0_0.OnGenSystem(arg0_91, arg1_91)
	local var0_91 = arg0_91.systemBuilders[arg1_91:GetType()]:Build(arg1_91)

	arg0_91:AddUnit(var0_91)
end

function var0_0.OnActiveOrDisactiveUnit(arg0_92, arg1_92, arg2_92, arg3_92)
	local var0_92

	if arg1_92 == 0 then
		var0_92 = arg0_92.player
	else
		var0_92 = arg0_92:GetUnitModuleWithType(arg2_92, arg1_92)
	end

	if var0_92 and arg3_92 then
		var0_92:Enable()
	end

	if var0_92 and not arg3_92 then
		var0_92:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_93, arg1_93, arg2_93, arg3_93)
	local var0_93 = arg0_93:GetUnitModuleWithType(arg2_93, arg1_93)

	if var0_93 then
		var0_93._go.transform.position = arg3_93
	end
end

function var0_0.OnResetUnitRotation(arg0_94, arg1_94, arg2_94, arg3_94)
	local var0_94 = arg0_94:GetUnitModuleWithType(arg2_94, arg1_94)

	if var0_94 then
		var0_94._go.transform.eulerAngles = arg3_94
	end
end

function var0_0.OnMoveUnit(arg0_95, arg1_95)
	assert(arg1_95.type, "type should be exist")

	local var0_95 = arg0_95:GetUnitModuleWithType(arg1_95.type, arg1_95.id)

	if var0_95 then
		var0_95:SetDestination(arg1_95.position, arg1_95.speed, nil, arg1_95.charaRadius)
	end
end

function var0_0.OnStopUnit(arg0_96, arg1_96)
	assert(arg1_96.type, "type should be exist")

	local var0_96 = arg0_96:GetUnitModuleWithType(arg1_96.type, arg1_96.id)

	if var0_96 then
		var0_96:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_97, arg1_97, arg2_97)
	local var0_97 = arg0_97:GetUnitListByKey(arg1_97)
	local var1_97 = 0

	for iter0_97, iter1_97 in ipairs(var0_97 or {}) do
		if iter1_97.id == arg2_97 then
			var1_97 = iter0_97

			break
		end
	end

	if var1_97 > 0 then
		local var2_97 = var0_97[var1_97]

		for iter2_97 = #arg0_97.pathfinders, 1, -1 do
			local var3_97 = arg0_97.pathfinders[iter2_97]

			if var3_97:IsSameUnit(var2_97) then
				var3_97:Dispose()
				table.remove(arg0_97.pathfinders, iter2_97)
			end
		end

		arg0_97:RemoveUnit(var2_97)
		var2_97:Dispose()
		arg0_97:OnHideUnitHudAndOpBtn({
			type = arg1_97,
			id = var2_97.id
		}, true)
		arg0_97:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_97,
			id = arg2_97
		})
		arg0_97:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var2_97)
		arg0_97:GetSubView(IslandInteractionView):CloseInterActionPanelByUnitIdRemove(arg2_97)
	end
end

function var0_0.GetAllUnits(arg0_98)
	table.clear(arg0_98._unitList)

	for iter0_98, iter1_98 in pairs(arg0_98:GetUnitListRegitser()) do
		for iter2_98, iter3_98 in pairs(iter1_98) do
			table.insert(arg0_98._unitList, iter3_98)
		end
	end

	return arg0_98._unitList
end

function var0_0.GetUnitModuleWithType(arg0_99, arg1_99, arg2_99)
	if arg1_99 == IslandConst.UNIT_LIST_PLAYER and arg2_99 == 0 then
		return arg0_99.player
	end

	local var0_99 = arg0_99:GetUnitListByKey(arg1_99)

	for iter0_99, iter1_99 in ipairs(var0_99) do
		if iter1_99.id == arg2_99 then
			return iter1_99
		end
	end

	return nil
end

function var0_0.GetPlayerUnitModule(arg0_100, arg1_100)
	return arg0_100:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_100)
end

function var0_0.GetUnitModule(arg0_101, arg1_101)
	return arg0_101:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_101)
end

function var0_0.GetSystemModule(arg0_102, arg1_102)
	return arg0_102:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_102)
end

function var0_0.GetSystemUnitModule(arg0_103, arg1_103)
	return arg0_103:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_103)
end

function var0_0.GetStrollUnitModule(arg0_104, arg1_104)
	return arg0_104:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_104)
end

function var0_0.GetManageSystemModule(arg0_105, arg1_105)
	return arg0_105:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_105)
end

function var0_0.GetFollowerModule(arg0_106, arg1_106)
	return arg0_106:GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg1_106)
end

function var0_0.OnMovePlayerBefore(arg0_107)
	if arg0_107.player:CheckMovement() and arg0_107.isLockPlayInput then
		arg0_107.isLockPlayInput = false
	end

	arg0_107:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnLockPlayerInput(arg0_108)
	if arg0_108.playerInputing then
		arg0_108.isLockPlayInput = true

		arg0_108.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerMove(arg0_109, arg1_109)
	if arg0_109.isLockPlayInput then
		return
	end

	arg0_109.playerInputing = true

	if arg0_109.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_109.firstTakePhotoItem:MoveHandle(arg1_109.targetDir, arg1_109.force)
	elseif arg0_109.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_109.thirdTakePhotoItem:MoveHandle(arg1_109.targetDir, arg1_109.force)
	else
		arg0_109.player:MoveHandle(arg1_109.targetDir, arg1_109.force)
	end
end

function var0_0.OnPlayerStopMove(arg0_110)
	if arg0_110.isLockPlayInput then
		arg0_110.isLockPlayInput = false
	end

	arg0_110.playerInputing = true

	if arg0_110.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_110.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_110.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_110.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_110.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerStopMoveHandle(arg0_111)
	if arg0_111.isLockPlayInput then
		arg0_111.isLockPlayInput = false
	end

	arg0_111.playerInputing = true

	if arg0_111.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_111.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_111.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_111.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_111.player:StopMoveHandleByInput()
	end
end

function var0_0.OnPlayerJump(arg0_112)
	if arg0_112.takePhotoModel == IslandConst.TakePhotoModel.First or arg0_112.takePhotoModel == IslandConst.TakePhotoModel.Third then
		return
	end

	arg0_112.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_113)
	arg0_113.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_114)
	if arg0_114.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_114.firstTakePhotoItem:OnPlayerPlayerSprint()
	elseif arg0_114.takePhotoModel == IslandConst.TakePhotoModel.Third then
		-- block empty
	else
		arg0_114.player:OnPlayerPlayerSprint()
	end
end

function var0_0.OnStopPlayerSprint(arg0_115)
	if arg0_115.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_115.firstTakePhotoItem:OnStopPlayerSprint()
	elseif arg0_115.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_115.thirdTakePhotoItem:OnStopPlayerSprint()
	else
		arg0_115.player:OnStopPlayerSprint()
	end
end

function var0_0.OnPlayerWork(arg0_116, arg1_116, arg2_116)
	arg0_116.player:WorkHandle(arg1_116, arg2_116)
end

function var0_0.OnPlayerDeviceStateChange(arg0_117, arg1_117)
	arg0_117.player:DeviceStateHandle(arg1_117)
end

function var0_0.OnSetVisitorSyncData(arg0_118, arg1_118, arg2_118)
	local var0_118 = arg0_118:GetPlayerUnitModule(arg1_118)

	if var0_118 then
		var0_118:UpdateSyncData(arg2_118)
	end
end

function var0_0.OnWorldObjectStartInteraction(arg0_119, arg1_119, arg2_119, arg3_119)
	local var0_119 = arg2_119:GetHostId()
	local var1_119 = arg2_119:GetUserId()
	local var2_119 = arg0_119:GetUnitModule(var0_119)
	local var3_119 = arg0_119:GetPlayerUnitModule(var1_119)
	local var4_119 = arg0_119.player == var3_119

	if var4_119 then
		arg0_119:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_119 = arg1_119:GetTimeline()[arg3_119]
	local var6_119 = arg1_119:GetBlackboardParam()[arg3_119]

	var2_119:StartInteract(var3_119, arg2_119.id, arg3_119, var5_119, var6_119, arg1_119:AnySlotUsing(), var4_119)
end

function var0_0.OnWorldObjectEndInteraction(arg0_120, arg1_120, arg2_120)
	local var0_120 = arg2_120:GetHostId()
	local var1_120 = arg2_120:GetUserId()
	local var2_120 = arg0_120:GetUnitModule(var0_120)
	local var3_120 = arg0_120:GetPlayerUnitModule(var1_120)
	local var4_120 = arg0_120.player == var3_120

	if var4_120 then
		arg0_120:GetSubView(IslandOpView):EndInteraction()
	end

	var2_120:EndInteract(var3_120, arg2_120.id, not arg1_120:AnySlotUsing(), var4_120)
end

function var0_0.OnWorldObjectInitStatus(arg0_121, arg1_121, arg2_121)
	local var0_121 = arg0_121:GetUnitModule(arg1_121.id)
	local var1_121 = arg1_121:GetTimeline()[arg2_121]
	local var2_121 = arg1_121:GetBlackboardParam()[arg2_121]

	var0_121:InitStatus(arg2_121, var1_121, var2_121)
end

function var0_0.InitInteractionOpView(arg0_122)
	arg0_122:GetSubView(IslandOpView):EndInteraction()
end

function var0_0.OnPlayerAreaChange(arg0_123)
	arg0_123.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_124, arg1_124, arg2_124)
	arg0_124.player:OnChangeDress(arg1_124, arg2_124)
end

function var0_0.OnCharacterChangeDress(arg0_125, arg1_125, arg2_125, arg3_125, arg4_125)
	local var0_125 = arg0_125:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_125)

	if var0_125 then
		var0_125:OnCharacterChangeDress(arg2_125, arg3_125, arg4_125)
	end

	local var1_125 = arg0_125:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_125, iter1_125 in ipairs(var1_125) do
		if iter1_125:GetDataVO():IsSameShip(arg1_125) then
			iter1_125:OnCharacterChangeDress(arg2_125, arg3_125, arg4_125)
		end
	end

	local var2_125 = arg0_125:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter2_125, iter3_125 in ipairs(var2_125) do
		if iter3_125:GetDataVO():IsSameShip(arg1_125) then
			iter3_125:OnCharacterChangeDress(arg2_125, arg3_125, arg4_125)
		end
	end
end

function var0_0.OnStartDelegation(arg0_126, arg1_126, arg2_126)
	local var0_126 = arg0_126:GetSystemModule(arg1_126.build_id)

	if var0_126 then
		var0_126:StartDelegation(arg1_126)
	end
end

function var0_0.OnEndDelegation(arg0_127, arg1_127, arg2_127)
	local var0_127 = arg0_127:GetSystemModule(arg1_127.build_id)

	if var0_127 then
		var0_127:EndDelegation(arg1_127)
	end
end

function var0_0.GetPlayerPosition(arg0_128)
	return arg0_128.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_129, arg1_129)
	local var0_129 = arg0_129:GetUnitModule(arg1_129)

	return var0_129 and var0_129._go.transform.position
end

function var0_0.OnShowUnitHudAndOpBtn(arg0_130, arg1_130)
	arg0_130.currentHudUnitData = arg1_130

	arg0_130:GetSubView(IslandSlotHudView):ShowHud(arg1_130.id, arg1_130.height)
	arg0_130:GetSubView(IslandOpView):UpdateOperationButton(arg1_130.operationType, arg1_130.id)

	if arg1_130.isHighLightControl then
		arg0_130.detectionSystem:HighLightUnitHandle(arg1_130.id, true)
	end
end

function var0_0.OnHideUnitHudAndOpBtn(arg0_131, arg1_131, arg2_131)
	if not arg0_131.currentHudUnitData then
		return
	end

	if arg0_131.currentHudUnitData.id ~= arg1_131.id or arg0_131.currentHudUnitData.type ~= arg1_131.type then
		return
	end

	if not arg2_131 then
		arg0_131.currentHudUnitData = nil
	end

	arg0_131:GetSubView(IslandSlotHudView):HideUnitHud(arg1_131.id)
	arg0_131:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_131.id)

	if arg1_131.isHighLightControl then
		arg0_131.detectionSystem:HighLightUnitHandle(arg1_131.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_132, arg1_132)
	if not arg0_132.currentHudUnitData then
		return
	end

	if arg1_132 ~= arg0_132.currentHudUnitData.id then
		return
	end

	arg0_132:GetSubView(IslandSlotHudView):UpdateHud(arg0_132.currentHudUnitData.id, arg0_132.currentHudUnitData.height)
	arg0_132:GetSubView(IslandOpView):UpdateOperationButton(arg0_132.currentHudUnitData.operationType, arg0_132.currentHudUnitData.id)
end

function var0_0.OnUpdateHandCollectUnit(arg0_133, arg1_133)
	local var0_133 = arg0_133:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_133)

	if var0_133 then
		var0_133:UpdateHandCollet()
		var0_133:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_134, arg1_134)
	arg0_134:GetSubView(IslandTopHeadHudView):ShowHud(arg1_134)
	arg0_134:GetSubView(IslandDistanceView):ShowHud(arg1_134.id)
end

function var0_0.OnRefreshHud(arg0_135, arg1_135)
	arg0_135:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_135)
end

function var0_0.OnHideHud(arg0_136, arg1_136)
	arg0_136:GetSubView(IslandTopHeadHudView):HideHud(arg1_136)
	arg0_136:GetSubView(IslandDistanceView):HideHud(arg1_136.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_137, arg1_137)
	local var0_137 = arg0_137:GetUnitModuleWithType(arg1_137.type, arg1_137.id)

	if var0_137 then
		var0_137:DelegateSlotStartPerform()
	end
end

function var0_0.OnRecycleAllSlotEffct(arg0_138)
	arg0_138.effectMgr:RecycleAllSlotEffct()
end

function var0_0.OnLoadDelegatePreviewRole(arg0_139, arg1_139, arg2_139)
	arg0_139.effectMgr:LoadDelegatePreviewRole(arg1_139, arg2_139)
end

function var0_0.OnUnLoadDelegatePreviewRole(arg0_140)
	arg0_140.effectMgr:UnLoadDelegatePreviewRole()
end

function var0_0.OnSelectSlotEffectShow(arg0_141, arg1_141, arg2_141, arg3_141, arg4_141)
	arg0_141.effectMgr:SelectSlotEffectShow(arg1_141, arg2_141, arg3_141, arg4_141)
end

function var0_0.OnTakePlantAttack(arg0_142, arg1_142)
	local var0_142 = arg0_142:GetUnitModuleWithType(arg1_142.type, arg1_142.id)

	if var0_142 then
		var0_142:TakeAttack()
	end
end

function var0_0.OnStartManage(arg0_143, arg1_143)
	local var0_143 = arg0_143:GetManageSystemModule(arg1_143.id)

	if var0_143 then
		var0_143:StartManage(arg1_143)
	end
end

function var0_0.OnEndManage(arg0_144, arg1_144)
	local var0_144 = arg0_144:GetManageSystemModule(arg1_144.id)

	if var0_144 then
		var0_144:EndManage(arg1_144)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_145)
	arg0_145:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnRefreshWeatherSystem(arg0_146)
	arg0_146.weatherSystem:Play()
end

function var0_0.OnDispose(arg0_147)
	arg0_147.detectionSystem:Dispose()
	arg0_147.effectMgr:Dispose()
	arg0_147.coupleActionPlayer:Dispose()
	arg0_147.coupleAction4FollowerPlayer:Dispose()
	arg0_147.npcActionPlayer:Dispose()
	arg0_147.weatherSystem:Dispose()
	arg0_147.coupleNpcWordPlayer:Dispose()

	for iter0_147, iter1_147 in ipairs(arg0_147.views) do
		iter1_147:Dispose()
	end

	for iter2_147, iter3_147 in ipairs(arg0_147.pathfinders) do
		iter3_147:Dispose()
	end

	for iter4_147, iter5_147 in ipairs(arg0_147:GetAllUnits()) do
		iter5_147:Dispose()
	end

	for iter6_147, iter7_147 in pairs(arg0_147.unitBuilders) do
		iter7_147:Dispose()
	end

	for iter8_147, iter9_147 in pairs(arg0_147.systemBuilders) do
		iter9_147:Dispose()
	end

	arg0_147.npcActionPlayer = nil
	arg0_147.coupleActionPlayer = nil
	arg0_147.coupleAction4FollowerPlayer = nil
	arg0_147.pathfinders = nil
	arg0_147.unitBuilders = nil
	arg0_147.systemBuilders = nil
	arg0_147.views = nil
	arg0_147.player = nil
	arg0_147.isInit = false
	arg0_147._unitList = nil
	arg0_147.detectionSystem = nil
	arg0_147.effectMgr = nil
	arg0_147.coupleNpcWordPlayer = nil
end

return var0_0
