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

function var0_0.CreateTopHeadHudView(arg0_5)
	return IslandTopHeadHudView.New(arg0_5)
end

function var0_0.CreateBottomHeadHudeView(arg0_6)
	return IslandBottomHeadHudView.New(arg0_6)
end

function var0_0.CreateAnimationOpView(arg0_7)
	return IslandAniamtionOpView.New(arg0_7)
end

function var0_0.CreateInteractionView(arg0_8)
	return IslandInteractionView.New(arg0_8)
end

function var0_0.CreateDistanceView(arg0_9)
	return IslandDistanceView.New(arg0_9)
end

function var0_0.CreateSeedOpView(arg0_10)
	return IslandSeedOpView.New(arg0_10)
end

function var0_0.IsLoaded(arg0_11)
	local var0_11 = arg0_11:GetAllUnits()

	return _.all(arg0_11.views, function(arg0_12)
		return arg0_12:IsLoaded()
	end) and #var0_11 > 0 and _.all(var0_11, function(arg0_13)
		return arg0_13:IsLoaded()
	end)
end

function var0_0.IsInit(arg0_14)
	return arg0_14.isInit
end

function var0_0.Update(arg0_15)
	if not arg0_15.isInit then
		return
	end

	for iter0_15, iter1_15 in ipairs(arg0_15:GetAllUnits()) do
		iter1_15:Update()
	end

	for iter2_15, iter3_15 in ipairs(arg0_15.views) do
		iter3_15:Update()
	end

	for iter4_15, iter5_15 in ipairs(arg0_15.pathfinders) do
		iter5_15:Update()
	end

	if arg0_15.needTryTrack then
		arg0_15:TryTrack()
	end
end

function var0_0.LateUpdate(arg0_16)
	if not arg0_16.isInit then
		return
	end

	for iter0_16, iter1_16 in ipairs(arg0_16:GetAllUnits()) do
		iter1_16:LateUpdate()
	end

	for iter2_16, iter3_16 in ipairs(arg0_16.views) do
		iter3_16:LateUpdate()
	end

	for iter4_16, iter5_16 in ipairs(arg0_16.pathfinders) do
		iter5_16:LateUpdate()
	end
end

function var0_0.AddListeners(arg0_17)
	arg0_17:AddListener(ISLAND_EVT.GEN_UNIT, arg0_17.OnGenUnit)
	arg0_17:AddListener(ISLAND_EVT.RMOVE_UNIT, arg0_17.OnRemoveUnit)
	arg0_17:AddListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_17.OnInterActionBegin)
	arg0_17:AddListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_17.OnInterActionEnd)
	arg0_17:AddListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_17.OnStopUnit)
	arg0_17:AddListener(ISLAND_EVT.MOVE_UNIT, arg0_17.OnMoveUnit)
	arg0_17:AddListener(ISLAND_EVT.INIT_FINISH, arg0_17.OnSceneInited)
	arg0_17:AddListener(ISLAND_EVT.MOVE_PLAYER, arg0_17.OnPlayerMove)
	arg0_17:AddListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_17.OnPlayerStopMove)
	arg0_17:AddListener(ISLAND_EVT.JUMP_PLAYER, arg0_17.OnPlayerJump)
	arg0_17:AddListener(ISLAND_EVT.APPROACH_UNIT, arg0_17.OnShowInterActionPanel)
	arg0_17:AddListener(ISLAND_EVT.LEAVE_UNIT, arg0_17.OnHideInterActionPanel)
	arg0_17:AddListener(ISLAND_EVT.TRACKING, arg0_17.OnTracking)
	arg0_17:AddListener(ISLAND_EVT.UNTRACKING, arg0_17.OnUnTracking)
	arg0_17:AddListener(ISLAND_EVT.AREACHANGE, arg0_17.OnPlayerAreaChange)
	arg0_17:AddListener(ISLAND_EVT.PLAYERRUN, arg0_17.OnPlayerPlayerRun)
	arg0_17:AddListener(ISLAND_EVT.SPRINT_PLAYER, arg0_17.OnPlayerPlayerSprint)
	arg0_17:AddListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_17.OnStopPlayerSprint)
	arg0_17:AddListener(ISLAND_EVT.CHANGE_DRESS, arg0_17.OnChangeDress)
	arg0_17:AddListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_17.OnCharacterChangeDress)
	arg0_17:AddListener(ISLAND_EVT.RESET_UNIT_POS, arg0_17.OnResetUnitPos)
	arg0_17:AddListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_17.OnResetUnitRotation)
	arg0_17:AddListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_17.OnAnyPageOpen)
	arg0_17:AddListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_17.OnAllPageClose)
	arg0_17:AddListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_17.OnChangeTakePhotoModel)
	arg0_17:AddListener(ISLAND_EVT.Change_Photo_Height, arg0_17.OnChange_Photo_Height)
	arg0_17:AddListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_17.OnSetOpMoveBtnActve)
	arg0_17:AddListener(ISLAND_EVT.PLAY_BUBBLE, arg0_17.OnPlayChatBubble)
	arg0_17:AddListener(ISLAND_EVT.START_STORY, arg0_17.OnStartStory)
	arg0_17:AddListener(ISLAND_EVT.END_STORY, arg0_17.OnEndStory)
	arg0_17:AddListener(ISLAND_EVT.START_DEGATION, arg0_17.OnStartDelegation)
	arg0_17:AddListener(ISLAND_EVT.END_DEGATION, arg0_17.OnEndDelegation)
	arg0_17:AddListener(ISLAND_EVT.GEN_SYSTEM, arg0_17.OnGenSystem)
	arg0_17:AddListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_17.OnWorldObjectStartInteraction)
	arg0_17:AddListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_17.OnWorldObjectEndInteraction)
	arg0_17:AddListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_17.OnWorldObjectInitStatus)
	arg0_17:AddListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_17.OnRefreshInteractionBtn)
	arg0_17:AddListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_17.OnShowUnitHudAndOpBtn)
	arg0_17:AddListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_17.OnHideUnitHudAndOpBtn)
	arg0_17:AddListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_17.OnDetectorChanged)
	arg0_17:AddListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_17.OnDetectorSelected)
	arg0_17:AddListener(ISLAND_EVT.NPC_DETECTED, arg0_17.OnNpcDetectorSelected)
	arg0_17:AddListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_17.OnNpcDetectorUnSelected)
	arg0_17:AddListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_17.OnPlayerWork)
	arg0_17:AddListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_17.OnPlayerDeviceStateChange)
	arg0_17:AddListener(ISLAND_EVT.UPDATE_HUD, arg0_17.OnUpdateHud)
	arg0_17:AddListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_17.OnUpdateHandCollectUnit)
	arg0_17:AddListener(ISLAND_EVT.START_DELEGATE_SLOT_PERFORM, arg0_17.OnDelegateSlotStartPerform)
	arg0_17:AddListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_17.OnRecycleAllSlotEffct)
	arg0_17:AddListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_17.OnSelectSlotEffectShow)
	arg0_17:AddListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_17.OnLoadDelegatePreviewRole)
	arg0_17:AddListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_17.OnUnLoadDelegatePreviewRole)
	arg0_17:AddListener(ISLAND_EVT.Take_Plant_Attact, arg0_17.OnTakePlantAttack)
	arg0_17:AddListener(ISLAND_EVT.START_MANAGE, arg0_17.OnStartManage)
	arg0_17:AddListener(ISLAND_EVT.END_MANAGE, arg0_17.OnEndManage)
	arg0_17:AddListener(ISLAND_EVT.SHOW_HUD, arg0_17.OnShowHud)
	arg0_17:AddListener(ISLAND_EVT.HIDE_HUD, arg0_17.OnHideHud)
	arg0_17:AddListener(ISLAND_EVT.REFRESH_HUD, arg0_17.OnRefreshHud)
	arg0_17:AddListener(ISLAND_EVT.START_GUIDE, arg0_17.OnStartGuide)
	arg0_17:AddListener(ISLAND_EVT.END_GUIDE, arg0_17.OnEndGuide)
	arg0_17:AddListener(ISLAND_EVT.START_PERFORMANCE, arg0_17.OnStartPerformance)
	arg0_17:AddListener(ISLAND_EVT.END_PERFORMANCE, arg0_17.OnEndPerformance)
	arg0_17:AddListener(ISLAND_EVT.DISABLE_INPUT, arg0_17.DisableInput)
	arg0_17:AddListener(ISLAND_EVT.ENABLE_INPUT, arg0_17.EnableInput)
	arg0_17:AddListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_17.OnGenPathFinder)
	arg0_17:AddListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_17.OnActiveOrDisactiveUnit)
	arg0_17:AddListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_17.OnOpenAniamtionOpPage)
	arg0_17:AddListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_17.OnCloseAniamtionOpPage)
	arg0_17:AddListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_17.OnMovePlayerBefore)
	arg0_17:AddListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_17.OnRefreshTaskInfoHud)
	arg0_17:AddListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_17.OnResponAniamtionOp)
	arg0_17:AddListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_17.OnChangeVisterDress)
	arg0_17:AddListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_17.OnSetVisitorSyncData)
	arg0_17:AddListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_17.OnShowNpcAniamtionBubble)
	arg0_17:AddListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_17.OnHideNpcAniamtionBubble)
	arg0_17:AddListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_17.OnPlaySingleAnimationEnd)
	arg0_17:AddListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_17.OnUpdateCustomOpPositon)
	arg0_17:AddListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_17.OnChatMsgUpdate)
	arg0_17:AddListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_17.OnChatRoomChange)
	arg0_17:AddListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_17.OnShowChatMsg)
	arg0_17:AddListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_17.OnResetFollowRandomizer)
	arg0_17:AddListener(ISLAND_EVT.ADD_FOLLOWER, arg0_17.OnFollowerAdd)
	arg0_17:AddListener(ISLAND_EVT.DEL_FOLLOWER, arg0_17.OnFollowerDel)
	arg0_17:AddListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_17.OnCoupleActionWithFollower)
	arg0_17:AddListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_17.OnLockPlayerInput)
	arg0_17:AddListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_17.OnStartCoupleAction)
	arg0_17:AddListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_17.OnEndCoupleAction)
	arg0_17:AddListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_17.OnRefreshWeatherSystem)
	arg0_17:AddListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_17.OnSystemUnlock)
end

function var0_0.RemoveListeners(arg0_18)
	arg0_18:RemoveListener(ISLAND_EVT.GEN_UNIT, arg0_18.OnGenUnit)
	arg0_18:RemoveListener(ISLAND_EVT.RMOVE_UNIT, arg0_18.OnRemoveUnit)
	arg0_18:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_18.OnInterActionBegin)
	arg0_18:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_18.OnInterActionEnd)
	arg0_18:RemoveListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_18.OnStopUnit)
	arg0_18:RemoveListener(ISLAND_EVT.MOVE_UNIT, arg0_18.OnMoveUnit)
	arg0_18:RemoveListener(ISLAND_EVT.INIT_FINISH, arg0_18.OnSceneInited)
	arg0_18:RemoveListener(ISLAND_EVT.MOVE_PLAYER, arg0_18.OnPlayerMove)
	arg0_18:RemoveListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_18.OnPlayerStopMove)
	arg0_18:RemoveListener(ISLAND_EVT.JUMP_PLAYER, arg0_18.OnPlayerJump)
	arg0_18:RemoveListener(ISLAND_EVT.APPROACH_UNIT, arg0_18.OnShowInterActionPanel)
	arg0_18:RemoveListener(ISLAND_EVT.LEAVE_UNIT, arg0_18.OnHideInterActionPanel)
	arg0_18:RemoveListener(ISLAND_EVT.TRACKING, arg0_18.OnTracking)
	arg0_18:RemoveListener(ISLAND_EVT.UNTRACKING, arg0_18.OnUnTracking)
	arg0_18:RemoveListener(ISLAND_EVT.AREACHANGE, arg0_18.OnPlayerAreaChange)
	arg0_18:RemoveListener(ISLAND_EVT.PLAYERRUN, arg0_18.OnPlayerPlayerRun)
	arg0_18:RemoveListener(ISLAND_EVT.SPRINT_PLAYER, arg0_18.OnPlayerPlayerSprint)
	arg0_18:RemoveListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_18.OnStopPlayerSprint)
	arg0_18:RemoveListener(ISLAND_EVT.CHANGE_DRESS, arg0_18.OnChangeDress)
	arg0_18:RemoveListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_18.OnCharacterChangeDress)
	arg0_18:RemoveListener(ISLAND_EVT.RESET_UNIT_POS, arg0_18.OnResetUnitPos)
	arg0_18:RemoveListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_18.OnResetUnitRotation)
	arg0_18:RemoveListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_18.OnAnyPageOpen)
	arg0_18:RemoveListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_18.OnChangeTakePhotoModel)
	arg0_18:RemoveListener(ISLAND_EVT.Change_Photo_Height, arg0_18.OnChange_Photo_Height)
	arg0_18:RemoveListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_18.OnSetOpMoveBtnActve)
	arg0_18:RemoveListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_18.OnAllPageClose)
	arg0_18:RemoveListener(ISLAND_EVT.PLAY_BUBBLE, arg0_18.OnPlayChatBubble)
	arg0_18:RemoveListener(ISLAND_EVT.START_STORY, arg0_18.OnStartStory)
	arg0_18:RemoveListener(ISLAND_EVT.END_STORY, arg0_18.OnEndStory)
	arg0_18:RemoveListener(ISLAND_EVT.START_DEGATION, arg0_18.OnStartDelegation)
	arg0_18:RemoveListener(ISLAND_EVT.END_DEGATION, arg0_18.OnEndDelegation)
	arg0_18:RemoveListener(ISLAND_EVT.GEN_SYSTEM, arg0_18.OnGenSystem)
	arg0_18:RemoveListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_18.OnWorldObjectStartInteraction)
	arg0_18:RemoveListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_18.OnWorldObjectEndInteraction)
	arg0_18:RemoveListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_18.OnWorldObjectInitStatus)
	arg0_18:RemoveListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_18.OnRefreshInteractionBtn)
	arg0_18:RemoveListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_18.OnShowUnitHudAndOpBtn)
	arg0_18:RemoveListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_18.OnHideUnitHudAndOpBtn)
	arg0_18:RemoveListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_18.OnDetectorChanged)
	arg0_18:RemoveListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_18.OnDetectorSelected)
	arg0_18:RemoveListener(ISLAND_EVT.NPC_DETECTED, arg0_18.OnNpcDetectorSelected)
	arg0_18:RemoveListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_18.OnNpcDetectorUnSelected)
	arg0_18:RemoveListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_18.OnPlayerWork)
	arg0_18:RemoveListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_18.OnPlayerDeviceStateChange)
	arg0_18:RemoveListener(ISLAND_EVT.UPDATE_HUD, arg0_18.OnUpdateHud)
	arg0_18:RemoveListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_18.OnUpdateHandCollectUnit)
	arg0_18:RemoveListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_18.OnRecycleAllSlotEffct)
	arg0_18:RemoveListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_18.OnSelectSlotEffectShow)
	arg0_18:RemoveListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_18.OnLoadDelegatePreviewRole)
	arg0_18:RemoveListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_18.OnUnLoadDelegatePreviewRole)
	arg0_18:RemoveListener(ISLAND_EVT.Take_Plant_Attact, arg0_18.OnTakePlantAttack)
	arg0_18:RemoveListener(ISLAND_EVT.START_MANAGE, arg0_18.OnStartManage)
	arg0_18:RemoveListener(ISLAND_EVT.END_MANAGE, arg0_18.OnEndManage)
	arg0_18:RemoveListener(ISLAND_EVT.SHOW_HUD, arg0_18.OnShowHud)
	arg0_18:RemoveListener(ISLAND_EVT.HIDE_HUD, arg0_18.OnHideHud)
	arg0_18:RemoveListener(ISLAND_EVT.REFRESH_HUD, arg0_18.OnRefreshHud)
	arg0_18:RemoveListener(ISLAND_EVT.START_GUIDE, arg0_18.OnStartGuide)
	arg0_18:RemoveListener(ISLAND_EVT.END_GUIDE, arg0_18.OnEndGuide)
	arg0_18:RemoveListener(ISLAND_EVT.START_PERFORMANCE, arg0_18.OnStartPerformance)
	arg0_18:RemoveListener(ISLAND_EVT.END_PERFORMANCE, arg0_18.OnEndPerformance)
	arg0_18:RemoveListener(ISLAND_EVT.DISABLE_INPUT, arg0_18.DisableInput)
	arg0_18:RemoveListener(ISLAND_EVT.ENABLE_INPUT, arg0_18.EnableInput)
	arg0_18:RemoveListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_18.OnGenPathFinder)
	arg0_18:RemoveListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_18.OnActiveOrDisactiveUnit)
	arg0_18:RemoveListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_18.OnOpenAniamtionOpPage)
	arg0_18:RemoveListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_18.OnCloseAniamtionOpPage)
	arg0_18:RemoveListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_18.OnMovePlayerBefore)
	arg0_18:RemoveListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_18.OnRefreshTaskInfoHud)
	arg0_18:RemoveListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_18.OnResponAniamtionOp)
	arg0_18:RemoveListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_18.OnChangeVisterDress)
	arg0_18:RemoveListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_18.OnSetVisitorSyncData)
	arg0_18:RemoveListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_18.OnShowNpcAniamtionBubble)
	arg0_18:RemoveListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_18.OnHideNpcAniamtionBubble)
	arg0_18:RemoveListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_18.OnPlaySingleAnimationEnd)
	arg0_18:RemoveListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_18.OnUpdateCustomOpPositon)
	arg0_18:RemoveListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_18.OnChatMsgUpdate)
	arg0_18:RemoveListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_18.OnChatRoomChange)
	arg0_18:RemoveListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_18.OnShowChatMsg)
	arg0_18:RemoveListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_18.OnResetFollowRandomizer)
	arg0_18:RemoveListener(ISLAND_EVT.ADD_FOLLOWER, arg0_18.OnFollowerAdd)
	arg0_18:RemoveListener(ISLAND_EVT.DEL_FOLLOWER, arg0_18.OnFollowerDel)
	arg0_18:RemoveListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_18.OnCoupleActionWithFollower)
	arg0_18:RemoveListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_18.OnLockPlayerInput)
	arg0_18:RemoveListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_18.OnStartCoupleAction)
	arg0_18:RemoveListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_18.OnEndCoupleAction)
	arg0_18:RemoveListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_18.OnRefreshWeatherSystem)
	arg0_18:RemoveListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_18.OnSystemUnlock)
end

function var0_0.OnSystemUnlock(arg0_19, arg1_19)
	if arg1_19 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_19:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.OnStartCoupleAction(arg0_20)
	arg0_20:UnBlockLayer1Event(false)
	arg0_20:GetSubView(IslandAniamtionOpView):OnStartCoupleAction()
end

function var0_0.OnEndCoupleAction(arg0_21)
	arg0_21:UnBlockLayer1Event(true)
	arg0_21:GetSubView(IslandAniamtionOpView):OnEndCoupleAction()
end

function var0_0.OnCoupleActionWithFollower(arg0_22, arg1_22)
	local var0_22 = arg0_22:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_22 = arg0_22:GetPlayerPosition()
	local var2_22 = pg.island_set.action_bubble_range.key_value_int
	local var3_22 = _.select(var0_22, function(arg0_23)
		return Vector3.Distance(arg0_23:GetPosition(), var1_22) <= var2_22
	end)

	if #var3_22 <= 0 then
		return
	end

	local var4_22 = var3_22[math.random(1, #var3_22)]
	local var5_22 = pg.island_action[arg1_22]

	arg0_22.coupleAction4FollowerPlayer:Play(var4_22, arg0_22.player, var5_22)
	arg0_22:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
end

function var0_0.OnFollowerAdd(arg0_24)
	arg0_24:GetSubView(IslandOpView):FlushFollowerList()
end

function var0_0.OnFollowerDel(arg0_25)
	arg0_25:GetSubView(IslandOpView):FlushFollowerList()
end

function var0_0.OnResetFollowRandomizer(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetFollowerModule(arg1_26)

	if not var0_26 then
		return
	end

	var0_26:SetBtRandomizer()
end

function var0_0.OnShowChatMsg(arg0_27, arg1_27)
	local var0_27 = arg1_27.player.id
	local var1_27 = arg0_27:GetPlayerUnitModule(var0_27)

	if not var1_27 then
		return
	end

	arg0_27:GetSubView(IslandTopHeadHudView):PlayChat(var1_27, arg1_27.emojiId, arg1_27.content, nil)
end

function var0_0.OnChatRoomChange(arg0_28)
	arg0_28:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_29)
	arg0_29:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnPlaySingleAnimationEnd(arg0_30, arg1_30)
	if not arg0_30:GetSelectedNpcId() then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(1, arg1_30, 0, 0, 0, 0))

		return
	end

	local var0_30 = arg0_30:GetSelectedNpcId()
	local var1_30, var2_30 = IslandCalcUtil.GetTypeAndIdByUniqueId(var0_30)
	local var3_30 = arg0_30:GetUnitModuleWithType(var1_30, var2_30)

	arg0_30.npcActionPlayer:Play(var3_30, arg0_30.player, arg1_30)
end

function var0_0.OnShowNpcAniamtionBubble(arg0_31, arg1_31)
	local var0_31 = arg0_31:GetStrollUnitModule(arg1_31.id)

	if not var0_31 then
		return
	end

	local var1_31 = arg1_31:GetActionFeedback()

	arg0_31:GetSubView(IslandBottomHeadHudView):ShowAnimationOp(var0_31, var1_31)
end

function var0_0.OnHideNpcAniamtionBubble(arg0_32, arg1_32)
	local var0_32 = arg0_32:GetStrollUnitModule(arg1_32.id)

	arg0_32:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var0_32)
end

function var0_0.OnResponAniamtionOp(arg0_33, arg1_33)
	local var0_33 = arg1_33.id
	local var1_33 = arg1_33.targetId
	local var2_33 = arg1_33.actionId
	local var3_33 = arg0_33:GetPlayerUnitModule(var0_33)

	if not var3_33 then
		return
	end

	if var2_33 == 0 then
		if not arg0_33:IsPlayer(var0_33) then
			arg0_33:GetSubView(IslandTopHeadHudView):HideAnimationOp(var3_33)
		else
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_33, 1, 0, 0, 0))
		end

		return
	end

	local var4_33 = pg.island_action[var2_33]

	if var1_33 == 0 and var4_33.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_33:IsPlayer(var0_33) then
		arg0_33:GetSubView(IslandTopHeadHudView):ShowAnimationOp(var3_33, var2_33)
	elseif var1_33 > 0 and var4_33.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_33:IsPlayer(var1_33) then
		local var5_33 = arg0_33:GetPlayerUnitModule(var1_33)

		arg0_33.coupleActionPlayer:Play(var3_33, var5_33, var4_33)
		arg0_33:GetSubView(IslandTopHeadHudView):HideAnimationOp(var5_33)
	elseif var1_33 > 0 and var4_33.type == IslandConst.ANIMATION_OP_DOUBLE and arg0_33:IsPlayer(var1_33) then
		local var6_33 = arg0_33:GetPlayerUnitModule(var1_33)

		arg0_33.coupleActionPlayer:Play(var3_33, var6_33, var4_33)
		arg0_33:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_33, 1, var1_33, 0, 1))
	end
end

function var0_0.OnChangeVisterDress(arg0_34, arg1_34)
	local var0_34 = arg1_34.id

	if arg0_34:IsPlayer(var0_34) then
		return
	end

	local var1_34 = arg0_34:GetPlayerUnitModule(var0_34)

	if var1_34 then
		var1_34:OnChangeDress(arg1_34.changeDressData)
	end
end

function var0_0.IsPlayer(arg0_35, arg1_35)
	return arg0_35.player.id == arg1_35
end

function var0_0.OnOpenAniamtionOpPage(arg0_36)
	arg0_36:GetSubView(IslandAniamtionOpView):TryEnable()
	arg0_36:GetSubView(IslandOpView):TryDisable()
	arg0_36:NotifiyIsland(ISLAND_EX_EVT.OPEN_ANIMATION_OP)
end

function var0_0.OnCloseAniamtionOpPage(arg0_37)
	arg0_37:GetSubView(IslandOpView):TryEnable()
	arg0_37:NotifiyIsland(ISLAND_EX_EVT.CLOSE_ANIMATION_OP)
end

function var0_0.OnGenPathFinder(arg0_38, arg1_38)
	local var0_38 = IslandPathFinder.New(arg0_38)
	local var1_38 = defaultValue(arg1_38.navData.waitUntilDone, false)

	var0_38:Start(arg1_38.navData, function()
		table.removebyvalue(arg0_38.pathfinders, var0_38)
		var0_38:Dispose()
		arg0_38:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH_DONE, arg1_38.navData.index)

		if var1_38 and arg1_38.callback then
			arg1_38.callback()
		end
	end)
	arg0_38:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH, arg1_38.navData.index)

	if not var1_38 and arg1_38.callback then
		arg1_38.callback()
	end

	table.insert(arg0_38.pathfinders, var0_38)
end

function var0_0.OnSceneInited(arg0_40, arg1_40)
	IslandCameraMgr.instance:LookAt(arg0_40.player._tf)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraZoom)):SetMaxMinZoom(arg1_40.min, arg1_40.max, arg1_40.value)
	arg0_40:InitFocusCamera()
	arg0_40:InitTakePhotoCamera()

	for iter0_40, iter1_40 in ipairs(arg0_40:GetAllUnits()) do
		iter1_40:Start()
	end

	arg0_40.isInit = true
end

function var0_0.InitFocusCamera(arg0_41)
	local var0_41 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)

	var0_41.Follow = arg0_41.player._tf
	var0_41.LookAt = arg0_41.player._tf
end

function var0_0.InitTakePhotoCamera(arg0_42)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).Follow = arg0_42.firstTakePhotoItem._tf

	local var0_42 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)

	var0_42.Follow = arg0_42.thirdTakePhotoItem._tf
	var0_42.LookAt = arg0_42.thirdTakePhotoItem._tf
end

function var0_0.OnNpcDetectorSelected(arg0_43, arg1_43)
	if arg0_43.selectedNpcId then
		return
	end

	local var0_43 = arg1_43.node

	if not var0_43 then
		return
	end

	arg0_43.selectedNpcId = var0_43:GetComponent(typeof(WorldObjectItem)).uniqueId
end

function var0_0.GetSelectedNpcId(arg0_44)
	return arg0_44.selectedNpcId
end

function var0_0.OnNpcDetectorUnSelected(arg0_45, arg1_45)
	local var0_45 = arg1_45.node

	if not var0_45 then
		return
	end

	local var1_45 = var0_45:GetComponent(typeof(WorldObjectItem)).uniqueId

	if arg0_45.selectedNpcId ~= var1_45 then
		return
	end

	arg0_45.selectedNpcId = nil
end

function var0_0.OnDetectorChanged(arg0_46, arg1_46)
	local var0_46 = arg1_46.node

	if not var0_46 then
		return
	end

	local var1_46 = var0_46:GetBlackboardVariable("DetectorList")

	for iter0_46 = 1, var1_46.Count do
		local var2_46 = var1_46[iter0_46 - 1]
		local var3_46, var4_46 = IslandCalcUtil.GetTypeAndIdByUniqueId(var2_46)

		if var3_46 == IslandConst.UNIT_LIST_OBJ then
			local var5_46 = arg0_46:GetUnitModuleWithType(var3_46, var4_46)

			if var5_46 then
				arg0_46:Op("NotifiyIsland", ISLAND_EX_EVT.APPROACH_OBJECT, var5_46.id)
			end
		end
	end
end

function var0_0.OnDetectorSelected(arg0_47, arg1_47)
	local var0_47 = arg1_47.node

	if not var0_47 then
		return
	end

	local var1_47 = var0_47:GetBlackboardVariable("SelectedObj")

	if not var1_47 or var1_47 == "" then
		arg0_47:OnClearSelectedUnit()
	else
		local var2_47, var3_47 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_47)
		local var4_47 = arg0_47:GetUnitModuleWithType(var2_47, var3_47)

		if var4_47 then
			arg0_47:OnSelectedUnit(var4_47)
		end
	end
end

function var0_0.OnClearSelectedUnit(arg0_48)
	return
end

function var0_0.OnSelectedUnit(arg0_49, arg1_49)
	return
end

function var0_0.OnRefreshInteractionBtn(arg0_50)
	arg0_50:GetSubView(IslandInteractionView):RefreshInteractionBtns()
end

function var0_0.OnStartStory(arg0_51)
	arg0_51.playingStory = true

	arg0_51:DisablePlayerOp()
end

function var0_0.OnEndStory(arg0_52)
	arg0_52.playingStory = false

	arg0_52:EnablePlayerOp()
end

function var0_0.DisablePlayerOp(arg0_53)
	arg0_53.player:StopMoveHandle()
	arg0_53:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_53:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_53:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_53:GetSubView(IslandOpView):TryDisable()
end

function var0_0.EnablePlayerOp(arg0_54)
	arg0_54:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_54:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_54:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_54:GetSubView(IslandOpView):TryEnable()
end

function var0_0.OnStartPerformance(arg0_55)
	return
end

function var0_0.OnEndPerformance(arg0_56)
	if not arg0_56.anyPageOpen then
		arg0_56:GetSubView(IslandOpView):ResetShowBalance()
	end
end

function var0_0.OnPlayChatBubble(arg0_57, arg1_57)
	local var0_57 = arg0_57:GetAllUnits()

	arg0_57:GetSubView(IslandTopHeadHudView):PlayBubble(arg1_57.name, var0_57, arg1_57.callback)
end

function var0_0.OnAnyPageOpen(arg0_58, arg1_58)
	arg0_58.anyPageOpen = true

	arg0_58.player:StopMoveHandle()
	arg0_58:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_58:GetSubView(IslandSlotHudView):TryDisable()
	arg0_58:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_58:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_58:GetSubView(IslandAniamtionOpView):CloseAndReset()
end

function var0_0.OnAllPageClose(arg0_59)
	arg0_59.anyPageOpen = false

	arg0_59:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_59:GetSubView(IslandSlotHudView):TryEnable()
	arg0_59:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_59:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnChange_Photo_Height(arg0_60, arg1_60, arg2_60)
	arg0_60.takePhotoModel = arg1_60

	if arg0_60.takePhotoModel == IslandConst.TakePhotoModel.First then
		-- block empty
	elseif arg0_60.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_60.thirdTakePhotoItem:ChangeHeight(arg2_60)
	end
end

function var0_0.OnChangeTakePhotoModel(arg0_61, arg1_61)
	arg0_61.takePhotoModel = arg1_61

	if arg0_61.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_61.firstTakePhotoItem:Enable()

		arg0_61.firstTakePhotoItem._tf.position = arg0_61.player._tf.position
		arg0_61.firstTakePhotoItem._tf.rotation = arg0_61.player._tf.rotation

		arg0_61.firstTakePhotoItem:SetTargetRotation(arg0_61.player._tf.rotation)
		arg0_61.player:SetActiveByLayer(false)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook)):SetPosAndRotationByTargetDir(arg0_61.player._tf.forward)
	elseif arg0_61.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_61.thirdTakePhotoItem:Enable()

		arg0_61.player._tf.position = arg0_61.firstTakePhotoItem._tf.position
		arg0_61.player._tf.rotation = arg0_61.firstTakePhotoItem._tf.rotation

		arg0_61.player:SetTargetRotation(arg0_61.firstTakePhotoItem._tf.rotation)
		arg0_61.player:SetActiveByLayer(true)

		arg0_61.thirdTakePhotoItem._tf.position = arg0_61.firstTakePhotoItem._tf:TransformPoint(Vector3(0, 0, -5))
		arg0_61.thirdTakePhotoItem._tf.rotation = arg0_61.firstTakePhotoItem._tf.rotation

		arg0_61.thirdTakePhotoItem:SetTargetRotation(arg0_61.firstTakePhotoItem._tf.rotation)

		local var0_61 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook))
		local var1_61 = arg0_61.player._tf.position + Vector3(0, 0.5, 0)
		local var2_61 = arg0_61.thirdTakePhotoItem._tf.position + Vector3(0, 1, 0)

		var0_61:SetPosAndRotationByTargetDir((var1_61 - var2_61).normalized)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	else
		arg0_61.firstTakePhotoItem:Disable()
		arg0_61.thirdTakePhotoItem:Disable()

		arg0_61.player._tf.position = arg0_61.firstTakePhotoItem._tf.position
		arg0_61.player._tf.rotation = arg0_61.firstTakePhotoItem._tf.rotation

		arg0_61.player:SetTargetRotation(arg0_61.firstTakePhotoItem._tf.rotation)
		arg0_61.player:SetActiveByLayer(true)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraLook)):ResetCameraPos()
	end

	arg0_61:GetSubView(IslandOpView):ChangeTakePhotoModel(arg1_61)
end

function var0_0.OnSetOpMoveBtnActve(arg0_62, arg1_62, arg2_62)
	arg0_62:GetSubView(IslandOpView):ShowOrHideMoveBtn(arg1_62, arg2_62)
end

function var0_0.OnInterActionBegin(arg0_63)
	arg0_63.player:StopMoveHandle()
	arg0_63:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_64)
	arg0_64:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_65, arg1_65)
	arg0_65.showInterObjId = arg1_65.id

	arg0_65:GetSubView(IslandInteractionView):ShowInterActionPanel(arg1_65)
	arg0_65:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_65.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_66, arg1_66)
	if arg0_66.showInterObjId ~= arg1_66.id then
		return
	end

	arg0_66.showInterObjId = nil

	arg0_66:GetSubView(IslandInteractionView):HideInterActionPanel()
end

function var0_0.OnStartGuide(arg0_67)
	arg0_67.player:StopMoveHandle()
	arg0_67:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_68)
	if arg0_68.playingStory then
		return
	end

	arg0_68:GetSubView(IslandOpView):EnableInput()
end

function var0_0.DisableInput(arg0_69)
	arg0_69.player:StopMoveHandle()
	arg0_69:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_70)
	arg0_70:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnTracking(arg0_71, arg1_71)
	arg0_71.trackId = tonumber(arg1_71.id)
	arg0_71.needTryTrack = true
end

function var0_0.TryTrack(arg0_72)
	local var0_72 = arg0_72:GetUnitModule(arg0_72.trackId)

	if not var0_72 or not var0_72._go then
		return
	end

	arg0_72:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_72.player, var0_72, arg0_72.trackId)

	arg0_72.needTryTrack = false
end

function var0_0.OnUnTracking(arg0_73)
	arg0_73.trackId = nil

	arg0_73:GetSubView(IslandDistanceView):CancelTracking()
end

function var0_0.OnUpdateCustomOpPositon(arg0_74)
	arg0_74:GetSubView(IslandOpView):InitOpCustumPositon()
end

function var0_0.OnGenUnit(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75.unitBuilders[arg1_75:GetType()]:Build(arg1_75, arg2_75)

	arg0_75:AddUnit(var0_75)

	if arg1_75:IsPlayer() then
		arg0_75.player = var0_75
	end

	if arg1_75:IsFirstTakePhoto() then
		arg0_75.firstTakePhotoItem = var0_75
	end

	if arg1_75:IsThirdTakePhoto() then
		arg0_75.thirdTakePhotoItem = var0_75
	end
end

function var0_0.OnGenSystem(arg0_76, arg1_76)
	local var0_76 = arg0_76.systemBuilders[arg1_76:GetType()]:Build(arg1_76)

	arg0_76:AddUnit(var0_76)
end

function var0_0.OnActiveOrDisactiveUnit(arg0_77, arg1_77, arg2_77, arg3_77)
	local var0_77

	if arg1_77 == 0 then
		var0_77 = arg0_77.player
	else
		var0_77 = arg0_77:GetUnitModuleWithType(arg2_77, arg1_77)
	end

	if var0_77 and arg3_77 then
		var0_77:Enable()
	end

	if var0_77 and not arg3_77 then
		var0_77:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_78, arg1_78, arg2_78, arg3_78)
	local var0_78 = arg0_78:GetUnitModuleWithType(arg2_78, arg1_78)

	if var0_78 then
		var0_78._go.transform.position = arg3_78
	end
end

function var0_0.OnResetUnitRotation(arg0_79, arg1_79, arg2_79, arg3_79)
	local var0_79 = arg0_79:GetUnitModuleWithType(arg2_79, arg1_79)

	if var0_79 then
		var0_79._go.transform.eulerAngles = arg3_79
	end
end

function var0_0.OnMoveUnit(arg0_80, arg1_80)
	assert(arg1_80.type, "type should be exist")

	local var0_80 = arg0_80:GetUnitModuleWithType(arg1_80.type, arg1_80.id)

	if var0_80 then
		var0_80:SetDestination(arg1_80.position, arg1_80.speed, nil, arg1_80.charaRadius)
	end
end

function var0_0.OnStopUnit(arg0_81, arg1_81)
	assert(arg1_81.type, "type should be exist")

	local var0_81 = arg0_81:GetUnitModuleWithType(arg1_81.type, arg1_81.id)

	if var0_81 then
		var0_81:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_82, arg1_82, arg2_82)
	local var0_82 = arg0_82:GetUnitListByKey(arg1_82)
	local var1_82 = 0

	for iter0_82, iter1_82 in ipairs(var0_82 or {}) do
		if iter1_82.id == arg2_82 then
			var1_82 = iter0_82

			break
		end
	end

	if var1_82 > 0 then
		local var2_82 = var0_82[var1_82]

		for iter2_82 = #arg0_82.pathfinders, 1, -1 do
			local var3_82 = arg0_82.pathfinders[iter2_82]

			if var3_82:IsSameUnit(var2_82) then
				var3_82:Dispose()
				table.remove(arg0_82.pathfinders, iter2_82)
			end
		end

		arg0_82:RemoveUnit(var2_82)
		var2_82:Dispose()
		arg0_82:OnHideUnitHudAndOpBtn({
			type = arg1_82,
			id = var2_82.id
		}, true)
		arg0_82:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_82,
			id = arg2_82
		})
		arg0_82:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var2_82)
		arg0_82:GetSubView(IslandInteractionView):CloseInterActionPanelByUnitIdRemove(arg2_82)
	end
end

function var0_0.GetAllUnits(arg0_83)
	table.clear(arg0_83._unitList)

	for iter0_83, iter1_83 in pairs(arg0_83:GetUnitListRegitser()) do
		for iter2_83, iter3_83 in pairs(iter1_83) do
			table.insert(arg0_83._unitList, iter3_83)
		end
	end

	return arg0_83._unitList
end

function var0_0.GetUnitModuleWithType(arg0_84, arg1_84, arg2_84)
	local var0_84 = arg0_84:GetUnitListByKey(arg1_84)

	for iter0_84, iter1_84 in ipairs(var0_84) do
		if iter1_84.id == arg2_84 then
			return iter1_84
		end
	end

	return nil
end

function var0_0.GetPlayerUnitModule(arg0_85, arg1_85)
	return arg0_85:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_85)
end

function var0_0.GetUnitModule(arg0_86, arg1_86)
	return arg0_86:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_86)
end

function var0_0.GetSystemModule(arg0_87, arg1_87)
	return arg0_87:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_87)
end

function var0_0.GetSystemUnitModule(arg0_88, arg1_88)
	return arg0_88:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_88)
end

function var0_0.GetStrollUnitModule(arg0_89, arg1_89)
	return arg0_89:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_89)
end

function var0_0.GetManageSystemModule(arg0_90, arg1_90)
	return arg0_90:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_90)
end

function var0_0.GetFollowerModule(arg0_91, arg1_91)
	return arg0_91:GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg1_91)
end

function var0_0.OnMovePlayerBefore(arg0_92)
	if arg0_92.player:CheckMovement() and arg0_92.isLockPlayInput then
		arg0_92.isLockPlayInput = false
	end

	arg0_92:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnLockPlayerInput(arg0_93)
	if arg0_93.playerInputing then
		arg0_93.isLockPlayInput = true

		arg0_93.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerMove(arg0_94, arg1_94)
	if arg0_94.isLockPlayInput then
		return
	end

	arg0_94.playerInputing = true

	if arg0_94.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_94.firstTakePhotoItem:MoveHandle(arg1_94.targetDir, arg1_94.force)
	elseif arg0_94.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_94.thirdTakePhotoItem:MoveHandle(arg1_94.targetDir, arg1_94.force)
	else
		arg0_94.player:MoveHandle(arg1_94.targetDir, arg1_94.force)
	end
end

function var0_0.OnPlayerStopMove(arg0_95)
	if arg0_95.isLockPlayInput then
		arg0_95.isLockPlayInput = false
	end

	arg0_95.playerInputing = true

	if arg0_95.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_95.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_95.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_95.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_95.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerJump(arg0_96)
	if arg0_96.takePhotoModel == IslandConst.TakePhotoModel.First or arg0_96.takePhotoModel == IslandConst.TakePhotoModel.Third then
		return
	end

	arg0_96.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_97)
	arg0_97.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_98)
	if arg0_98.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_98.firstTakePhotoItem:OnPlayerPlayerSprint()
	elseif arg0_98.takePhotoModel == IslandConst.TakePhotoModel.Third then
		-- block empty
	else
		arg0_98.player:OnPlayerPlayerSprint()
	end
end

function var0_0.OnStopPlayerSprint(arg0_99)
	if arg0_99.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_99.firstTakePhotoItem:OnStopPlayerSprint()
	elseif arg0_99.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_99.thirdTakePhotoItem:OnStopPlayerSprint()
	else
		arg0_99.player:OnStopPlayerSprint()
	end
end

function var0_0.OnPlayerWork(arg0_100, arg1_100, arg2_100)
	arg0_100.player:WorkHandle(arg1_100, arg2_100)
end

function var0_0.OnPlayerDeviceStateChange(arg0_101, arg1_101)
	arg0_101.player:DeviceStateHandle(arg1_101)
end

function var0_0.OnSetVisitorSyncData(arg0_102, arg1_102, arg2_102)
	local var0_102 = arg0_102:GetPlayerUnitModule(arg1_102)

	if var0_102 then
		var0_102:UpdateSyncData(arg2_102)
	end
end

function var0_0.OnWorldObjectStartInteraction(arg0_103, arg1_103, arg2_103, arg3_103)
	local var0_103 = arg2_103:GetHostId()
	local var1_103 = arg2_103:GetUserId()
	local var2_103 = arg0_103:GetUnitModule(var0_103)
	local var3_103 = arg0_103:GetPlayerUnitModule(var1_103)
	local var4_103 = arg0_103.player == var3_103

	if var4_103 then
		arg0_103:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_103 = arg1_103:GetTimeline()[arg3_103]
	local var6_103 = arg1_103:GetBlackboardParam()[arg3_103]

	var2_103:StartInteract(var3_103, arg2_103.id, arg3_103, var5_103, var6_103, arg1_103:AnySlotUsing(), var4_103)
end

function var0_0.OnWorldObjectEndInteraction(arg0_104, arg1_104, arg2_104)
	local var0_104 = arg2_104:GetHostId()
	local var1_104 = arg2_104:GetUserId()
	local var2_104 = arg0_104:GetUnitModule(var0_104)
	local var3_104 = arg0_104:GetPlayerUnitModule(var1_104)
	local var4_104 = arg0_104.player == var3_104

	if var4_104 then
		arg0_104:GetSubView(IslandOpView):EndInteraction()
	end

	var2_104:EndInteract(var3_104, arg2_104.id, not arg1_104:AnySlotUsing(), var4_104)
end

function var0_0.OnWorldObjectInitStatus(arg0_105, arg1_105, arg2_105)
	local var0_105 = arg0_105:GetUnitModule(arg1_105.id)
	local var1_105 = arg1_105:GetTimeline()[arg2_105]
	local var2_105 = arg1_105:GetBlackboardParam()[arg2_105]

	var0_105:InitStatus(arg2_105, var1_105, var2_105)
end

function var0_0.OnPlayerAreaChange(arg0_106)
	arg0_106.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_107, arg1_107, arg2_107)
	arg0_107.player:OnChangeDress(arg1_107, arg2_107)
end

function var0_0.OnCharacterChangeDress(arg0_108, arg1_108, arg2_108, arg3_108, arg4_108)
	local var0_108 = arg0_108:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_108)

	if var0_108 then
		var0_108:OnCharacterChangeDress(arg2_108, arg3_108, arg4_108)
	end

	local var1_108 = arg0_108:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_108, iter1_108 in ipairs(var1_108) do
		if iter1_108:GetDataVO():IsSameShip(arg1_108) then
			iter1_108:OnCharacterChangeDress(arg2_108, arg3_108, arg4_108)
		end
	end

	local var2_108 = arg0_108:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter2_108, iter3_108 in ipairs(var2_108) do
		if iter3_108:GetDataVO():IsSameShip(arg1_108) then
			iter3_108:OnCharacterChangeDress(arg2_108, arg3_108, arg4_108)
		end
	end
end

function var0_0.OnStartDelegation(arg0_109, arg1_109, arg2_109)
	local var0_109 = arg0_109:GetSystemModule(arg1_109.build_id)

	if var0_109 then
		var0_109:StartDelegation(arg1_109)
	end
end

function var0_0.OnEndDelegation(arg0_110, arg1_110, arg2_110)
	local var0_110 = arg0_110:GetSystemModule(arg1_110.build_id)

	if var0_110 then
		var0_110:EndDelegation(arg1_110)
	end
end

function var0_0.GetPlayerPosition(arg0_111)
	return arg0_111.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_112, arg1_112)
	local var0_112 = arg0_112:GetUnitModule(arg1_112)

	return var0_112 and var0_112._go.transform.position
end

function var0_0.OnShowUnitHudAndOpBtn(arg0_113, arg1_113)
	arg0_113.currentHudUnitData = arg1_113

	arg0_113:GetSubView(IslandSlotHudView):ShowHud(arg1_113.id, arg1_113.height)
	arg0_113:GetSubView(IslandOpView):UpdateOperationButton(arg1_113.operationType, arg1_113.id)

	if arg1_113.isHighLightControl then
		arg0_113.detectionSystem:HighLightUnitHandle(arg1_113.id, true)
	end
end

function var0_0.OnHideUnitHudAndOpBtn(arg0_114, arg1_114, arg2_114)
	if not arg0_114.currentHudUnitData then
		return
	end

	if arg0_114.currentHudUnitData.id ~= arg1_114.id or arg0_114.currentHudUnitData.type ~= arg1_114.type then
		return
	end

	if not arg2_114 then
		arg0_114.currentHudUnitData = nil
	end

	arg0_114:GetSubView(IslandSlotHudView):HideUnitHud(arg1_114.id)
	arg0_114:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_114.id)

	if arg1_114.isHighLightControl then
		arg0_114.detectionSystem:HighLightUnitHandle(arg1_114.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_115, arg1_115)
	if not arg0_115.currentHudUnitData then
		return
	end

	if arg1_115 ~= arg0_115.currentHudUnitData.id then
		return
	end

	arg0_115:GetSubView(IslandSlotHudView):UpdateHud(arg0_115.currentHudUnitData.id, arg0_115.currentHudUnitData.height)
	arg0_115:GetSubView(IslandOpView):UpdateOperationButton(arg0_115.currentHudUnitData.operationType, arg0_115.currentHudUnitData.id)
end

function var0_0.OnUpdateHandCollectUnit(arg0_116, arg1_116)
	local var0_116 = arg0_116:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_116)

	if var0_116 then
		var0_116:UpdateHandCollet()
		var0_116:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_117, arg1_117)
	arg0_117:GetSubView(IslandTopHeadHudView):ShowHud(arg1_117)
	arg0_117:GetSubView(IslandDistanceView):ShowHud(arg1_117.id)
end

function var0_0.OnRefreshHud(arg0_118, arg1_118)
	arg0_118:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_118)
end

function var0_0.OnHideHud(arg0_119, arg1_119)
	arg0_119:GetSubView(IslandTopHeadHudView):HideHud(arg1_119)
	arg0_119:GetSubView(IslandDistanceView):HideHud(arg1_119.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_120, arg1_120)
	local var0_120 = arg0_120:GetUnitModuleWithType(arg1_120.type, arg1_120.id)

	if var0_120 then
		var0_120:DelegateSlotStartPerform()
	end
end

function var0_0.OnRecycleAllSlotEffct(arg0_121)
	arg0_121.effectMgr:RecycleAllSlotEffct()
end

function var0_0.OnLoadDelegatePreviewRole(arg0_122, arg1_122, arg2_122)
	arg0_122.effectMgr:LoadDelegatePreviewRole(arg1_122, arg2_122)
end

function var0_0.OnUnLoadDelegatePreviewRole(arg0_123)
	arg0_123.effectMgr:UnLoadDelegatePreviewRole()
end

function var0_0.OnSelectSlotEffectShow(arg0_124, arg1_124, arg2_124, arg3_124, arg4_124)
	arg0_124.effectMgr:SelectSlotEffectShow(arg1_124, arg2_124, arg3_124, arg4_124)
end

function var0_0.OnTakePlantAttack(arg0_125, arg1_125)
	local var0_125 = arg0_125:GetUnitModuleWithType(arg1_125.type, arg1_125.id)

	if var0_125 then
		var0_125:TakeAttack()
	end
end

function var0_0.OnStartManage(arg0_126, arg1_126)
	local var0_126 = arg0_126:GetManageSystemModule(arg1_126.id)

	if var0_126 then
		var0_126:StartManage(arg1_126)
	end
end

function var0_0.OnEndManage(arg0_127, arg1_127)
	local var0_127 = arg0_127:GetManageSystemModule(arg1_127.id)

	if var0_127 then
		var0_127:EndManage(arg1_127)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_128)
	arg0_128:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnRefreshWeatherSystem(arg0_129)
	arg0_129.weatherSystem:Play()
end

function var0_0.OnDispose(arg0_130)
	arg0_130.detectionSystem:Dispose()
	arg0_130.effectMgr:Dispose()
	arg0_130.coupleActionPlayer:Dispose()
	arg0_130.coupleAction4FollowerPlayer:Dispose()
	arg0_130.npcActionPlayer:Dispose()
	arg0_130.weatherSystem:Dispose()

	for iter0_130, iter1_130 in ipairs(arg0_130.views) do
		iter1_130:Dispose()
	end

	for iter2_130, iter3_130 in ipairs(arg0_130.pathfinders) do
		iter3_130:Dispose()
	end

	for iter4_130, iter5_130 in ipairs(arg0_130:GetAllUnits()) do
		iter5_130:Dispose()
	end

	for iter6_130, iter7_130 in pairs(arg0_130.unitBuilders) do
		iter7_130:Dispose()
	end

	for iter8_130, iter9_130 in pairs(arg0_130.systemBuilders) do
		iter9_130:Dispose()
	end

	arg0_130.npcActionPlayer = nil
	arg0_130.coupleActionPlayer = nil
	arg0_130.coupleAction4FollowerPlayer = nil
	arg0_130.pathfinders = nil
	arg0_130.unitBuilders = nil
	arg0_130.systemBuilders = nil
	arg0_130.views = nil
	arg0_130.player = nil
	arg0_130.isInit = false
	arg0_130._unitList = nil
	arg0_130.detectionSystem = nil
	arg0_130.effectMgr = nil
end

return var0_0
