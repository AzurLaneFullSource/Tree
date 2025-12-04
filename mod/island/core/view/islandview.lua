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
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_FISH_POINT)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_DELEGATE_UNIT)
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_PRODUCT_SYSTEM)

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
		[IslandConst.UNIT_TYPE_FIRST_TAKE_PHOTO_ITEM] = IslandTakePhotoBuilder.New(arg0_1, IslandConst.UNIT_LIST_PHOTO),
		[IslandConst.UNIT_TYPE_FISH_POINT] = IslandStaticUnitBuilder.New(arg0_1, IslandConst.UNIT_LIST_FISH_POINT),
		[IslandConst.UNIT_TYPE_DELEGATE_FISH] = IslandDelegationFishBuilder.New(arg0_1, IslandConst.UNIT_LIST_DELEGATE_UNIT)
	}
	arg0_1.systemBuilders = {
		[IslandConst.SYSTEM_TYPE_CHARACTER] = IslandSystemBuilder.New(arg0_1, IslandCharacterSystem),
		[IslandConst.SYSTEM_TYPE_PRODUCT] = IslandSystemBuilder.New(arg0_1, IslandProductSystem, IslandConst.UNIT_LIST_PRODUCT_SYSTEM),
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
	arg0_1.fishingSynPlayers = {}
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
	for iter0_2, iter1_2 in ipairs(arg0_2.views or {}) do
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
	arg0_18:AddListener(ISLAND_EVT.FISHPOINT_DETECTOR, arg0_18.OnFishPointSelected)
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
	arg0_18:AddListener(ISLAND_EVT.BAIT_UPDATE, arg0_18.OnBaitUpdate)
	arg0_18:AddListener(ISLAND_EVT.START_FISHING, arg0_18.OnStartFishing)
	arg0_18:AddListener(ISLAND_EVT.FISHING_STATE_CHANGE, arg0_18.OnFishingStateChange)
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
	arg0_19:RemoveListener(ISLAND_EVT.FISHPOINT_DETECTOR, arg0_19.OnFishPointSelected)
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
	arg0_19:RemoveListener(ISLAND_EVT.BAIT_UPDATE, arg0_19.OnBaitUpdate)
	arg0_19:RemoveListener(ISLAND_EVT.START_FISHING, arg0_19.OnStartFishing)
	arg0_19:RemoveListener(ISLAND_EVT.FISHING_STATE_CHANGE, arg0_19.OnFishingStateChange)
end

function var0_0.OnBaitUpdate(arg0_20, arg1_20)
	arg0_20:GetSubView(IslandOpView):UpdateLureBtn()
end

function var0_0.OnFishPointSelected(arg0_21, arg1_21)
	local var0_21 = arg1_21.node

	if not var0_21 then
		return
	end

	local var1_21 = var0_21:GetBlackboardVariable("FishPoint")

	if not var1_21 or var1_21 == "" then
		arg0_21:UnSelectedFishPoint()
	else
		local var2_21, var3_21 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_21)
		local var4_21 = arg0_21:GetUnitModuleWithType(var2_21, var3_21)

		if var4_21 then
			arg0_21:SelectedFishPoint(var4_21)
		end
	end
end

function var0_0.SelectedFishPoint(arg0_22, arg1_22)
	if not arg0_22:GetSelfIsland():GetAblityAgency():IsUnlockFishing() or arg1_22:GetUnitType() ~= IslandConst.UNIT_LIST_FISH_POINT or arg0_22.player:StandOnWorldObject() or not arg0_22.player:OnGrouded() then
		return
	end

	arg0_22:UnSelectedFishPoint()

	arg0_22.selectedFishPointId = arg1_22.id

	arg0_22:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.Fishing, arg1_22.id)
end

function var0_0.UnSelectedFishPoint(arg0_23)
	if arg0_23.selectedFishPointId then
		local var0_23 = arg0_23.selectedFishPointId

		arg0_23.selectedFishPointId = nil

		arg0_23:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, var0_23)
	end
end

function var0_0.OnStartFishing(arg0_24, arg1_24)
	local var0_24 = arg1_24.unitId
	local var1_24 = arg0_24:GetPlayerUnitModule(var0_24)

	if not var1_24 then
		return
	end

	if not isa(var1_24, IslandVisitorUnit) then
		return
	end

	var1_24:Sleep()

	local var2_24 = arg1_24.fishPointId
	local var3_24 = arg1_24.rodId
	local var4_24 = arg1_24.fishId
	local var5_24 = pg.island_fish_rod[var3_24].attachment_id
	local var6_24 = IslandVistorFishingPlayer.New(arg0_24, var1_24, var2_24, var5_24, var4_24)

	var6_24:Play()

	arg0_24.fishingSynPlayers[var0_24] = var6_24
end

function var0_0.OnFishingStateChange(arg0_25, arg1_25)
	local var0_25 = arg1_25.op
	local var1_25 = arg1_25.unitId
	local var2_25 = arg0_25:GetPlayerUnitModule(var1_25)
	local var3_25 = arg0_25.fishingSynPlayers[var1_25]

	if not isa(var2_25, IslandVisitorUnit) then
		return
	end

	if not var3_25 or not var3_25:IsSameFishPoint(arg1_25.fishPointId) then
		return
	end

	local function var4_25()
		var2_25:WakeUp()
		arg0_25.fishingSynPlayers[var1_25]:Dispose()

		arg0_25.fishingSynPlayers[var1_25] = nil
	end

	if var0_25 == IslandConst.FISHING_OP_CANCEL then
		var3_25:OnCancel(var4_25)
	elseif var0_25 == IslandConst.FISHING_OP_FAILD then
		var3_25:OnFailed(var4_25)
	elseif var0_25 == IslandConst.FISHING_OP_SUCCESS then
		var3_25:OnSuccess(var4_25)
	end
end

function var0_0.OnStartCoupleAction(arg0_27)
	arg0_27:UnBlockLayer1Event(false)
	arg0_27:GetSubView(IslandAniamtionOpView):OnStartCoupleAction()
end

function var0_0.OnEndCoupleAction(arg0_28)
	arg0_28:UnBlockLayer1Event(true)
	arg0_28:GetSubView(IslandAniamtionOpView):OnEndCoupleAction()
end

function var0_0.OnCancelCoupleAction(arg0_29)
	if arg0_29.coupleActionPlayer and arg0_29.coupleActionPlayer:IsPlaying() then
		arg0_29.coupleActionPlayer:Stop()
	end

	if arg0_29.coupleAction4FollowerPlayer and arg0_29.coupleAction4FollowerPlayer:IsPlaying() then
		arg0_29.coupleAction4FollowerPlayer:Stop()
	end

	arg0_29:OnEndCoupleAction()
end

function var0_0.OnCoupleActionWithFollower(arg0_30, arg1_30)
	local var0_30 = arg0_30:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_30 = arg0_30:GetPlayerPosition()
	local var2_30 = pg.island_set.action_bubble_range.key_value_int
	local var3_30 = _.select(var0_30, function(arg0_31)
		return Vector3.Distance(arg0_31:GetPosition(), var1_30) <= var2_30
	end)

	if #var3_30 <= 0 then
		return
	end

	local var4_30 = var3_30[math.random(1, #var3_30)]
	local var5_30 = pg.island_action[arg1_30]

	arg0_30.coupleAction4FollowerPlayer:Play(var4_30, arg0_30.player, var5_30)
	arg0_30:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
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

function var0_0.OnShowChatMsg(arg0_38, arg1_38)
	local var0_38 = arg1_38.player.id
	local var1_38 = arg0_38:GetPlayerUnitModule(var0_38)

	if not var1_38 then
		return
	end

	arg0_38:GetSubView(IslandTopHeadHudView):PlayChat(var1_38, arg1_38.emojiId, arg1_38.content, nil)
end

function var0_0.OnChatRoomChange(arg0_39)
	arg0_39:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_40)
	arg0_40:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnFollowerAdd(arg0_41, arg1_41)
	arg0_41:GetSubView(IslandOpView):FlushFollowerList()
	arg0_41.coupleNpcWordPlayer:Play(arg1_41)
end

function var0_0.OnFollowerDel(arg0_42, arg1_42)
	arg0_42:GetSubView(IslandOpView):FlushFollowerList()
	arg0_42.coupleNpcWordPlayer:Stop(arg1_42)
end

function var0_0.OnResetFollowRandomizer(arg0_43, arg1_43)
	local var0_43 = arg0_43:GetFollowerModule(arg1_43)

	if not var0_43 then
		return
	end

	var0_43:SetBtRandomizer()
end

function var0_0.OnGenPathFinder(arg0_44, arg1_44)
	local var0_44 = IslandPathFinder.New(arg0_44)
	local var1_44 = defaultValue(arg1_44.navData.waitUntilDone, false)

	var0_44:Start(arg1_44.navData, function()
		table.removebyvalue(arg0_44.pathfinders, var0_44)
		var0_44:Dispose()

		if arg1_44.onEndAction then
			arg1_44.onEndAction()
		end

		arg0_44:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH_DONE, arg1_44.navData.index)

		if var1_44 and arg1_44.callback then
			arg1_44.callback()
		end
	end)
	arg0_44:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH, arg1_44.navData.index)

	if not var1_44 and arg1_44.callback then
		arg1_44.callback()
	end

	table.insert(arg0_44.pathfinders, var0_44)
end

function var0_0.OnRemovePathFinder(arg0_46, arg1_46)
	local var0_46 = arg0_46:GetUnitModuleWithType(arg1_46.unitType, arg1_46.unitId)
	local var1_46 = _.detect(arg0_46.pathfinders, function(arg0_47)
		return arg0_47:IsSameUnit(var0_46)
	end)

	if not var1_46 then
		return
	end

	var1_46:Stop()
	var1_46:Dispose()
	table.removebyvalue(arg0_46.pathfinders, var1_46)
end

function var0_0.OnTracking(arg0_48, arg1_48)
	local var0_48 = arg1_48.trackType

	if var0_48 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_48.mainTrackId = tonumber(arg1_48.id)
		arg0_48.needTryMainTrack = true
	elseif var0_48 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_48.trackId = tonumber(arg1_48.id)
		arg0_48.trackType = arg1_48.typ or IslandTaskType.MAIN
		arg0_48.needTryTrack = true
	end
end

function var0_0.TryTrack(arg0_49)
	arg0_49:TrySetTrack(arg0_49.trackId)
end

function var0_0.TrySetTrack(arg0_50, arg1_50)
	local var0_50 = arg0_50:GetOptTrackingTarget(arg1_50)

	if not var0_50 or not var0_50._go then
		return
	end

	arg0_50:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_50.player, var0_50, arg1_50, arg0_50.trackType, IslandTaskTrackCard.TYPES.OTHER)

	arg0_50.needTryTrack = false
end

function var0_0.TryMainTrack(arg0_51)
	arg0_51:TrySetMainTrack(arg0_51.mainTrackId)
end

function var0_0.TrySetMainTrack(arg0_52, arg1_52)
	local var0_52 = arg0_52:GetOptTrackingTarget(arg1_52)

	if not var0_52 or not var0_52._go then
		return
	end

	arg0_52:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_52.player, var0_52, arg1_52, IslandTaskType.MAIN, IslandTaskTrackCard.TYPES.MAIN)

	arg0_52.needTryMainTrack = false
end

function var0_0.OnUnTracking(arg0_53, arg1_53)
	if arg1_53 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_53.mainTrackId = nil
	elseif arg1_53 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_53.trackId = nil
	end

	arg0_53:GetSubView(IslandDistanceView):CancelTracking(arg1_53)
end

local function var1_0(arg0_54, arg1_54)
	local var0_54 = pg.island_world_objects[arg0_54]

	if not var0_54 then
		return
	end

	return var0_54.mapId == arg1_54
end

local function var2_0(arg0_55, arg1_55, arg2_55)
	for iter0_55, iter1_55 in ipairs(arg0_55) do
		for iter2_55, iter3_55 in ipairs(iter1_55[2]) do
			local var0_55 = pg.island_interaction[iter3_55]

			if var0_55.type == arg2_55 and var1_0(tonumber(var0_55.param), arg1_55) then
				return iter1_55[1]
			end
		end
	end

	return nil
end

local function var3_0(arg0_56)
	local var0_56 = {}
	local var1_56 = {}

	for iter0_56, iter1_56 in ipairs(arg0_56) do
		for iter2_56, iter3_56 in ipairs(iter1_56[2]) do
			local var2_56 = pg.island_interaction[iter3_56]

			if var2_56.type == IslandInteractionUntil.TYPE_TRANSFER then
				table.insert(var0_56, iter1_56[1])
			elseif var2_56.type == IslandInteractionUntil.TYPE_SP_TRANSFER then
				table.insert(var1_56, iter1_56[1])
			end
		end
	end

	if #var1_56 > 0 then
		return var1_56[1]
	end

	if #var0_56 > 0 then
		return var0_56[1]
	end

	return nil
end

function var0_0.GetOptTrackingTarget(arg0_57, arg1_57)
	local var0_57 = arg0_57:GetUnitModule(arg1_57)

	if var0_57 then
		return var0_57
	end

	local var1_57 = pg.island_world_objects[arg1_57]

	if not var1_57 then
		return nil
	end

	local var2_57 = {}

	for iter0_57, iter1_57 in ipairs(arg0_57:GetUnitListByKey(IslandConst.UNIT_LIST_OBJ)) do
		local var3_57, var4_57 = iter1_57:IsMapTransfer()

		if var3_57 then
			table.insert(var2_57, {
				iter1_57,
				var4_57
			})
		end
	end

	local var5_57
	local var6_57 = var2_0(var2_57, var1_57.mapId, IslandInteractionUntil.TYPE_TRANSFER) or var2_0(var2_57, var1_57.mapId, IslandInteractionUntil.TYPE_SP_TRANSFER)

	var6_57 = var6_57 or var3_0(var2_57)

	return var6_57
end

function var0_0.OnOpenAniamtionOpPage(arg0_58)
	arg0_58:GetSubView(IslandAniamtionOpView):TryEnable()
	arg0_58:GetSubView(IslandOpView):TryDisable()
	arg0_58:NotifiyIsland(ISLAND_EX_EVT.OPEN_ANIMATION_OP)
end

function var0_0.OnCloseAniamtionOpPage(arg0_59)
	arg0_59:GetSubView(IslandOpView):TryEnable()
	arg0_59:NotifiyIsland(ISLAND_EX_EVT.CLOSE_ANIMATION_OP)
end

function var0_0.OnAnyPageOpen(arg0_60, arg1_60)
	arg0_60.anyPageOpen = true

	arg0_60.player:StopMoveHandle()
	arg0_60:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_60:GetSubView(IslandSlotHudView):TryDisable()
	arg0_60:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_60:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_60:GetSubView(IslandAniamtionOpView):CloseAndReset()
end

function var0_0.OnAllPageClose(arg0_61)
	arg0_61.anyPageOpen = false

	arg0_61:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_61:GetSubView(IslandSlotHudView):TryEnable()
	arg0_61:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_61:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnStartStory(arg0_62)
	arg0_62.playingStory = true

	arg0_62:DisablePlayerOp()
end

function var0_0.OnEndStory(arg0_63)
	arg0_63.playingStory = false

	arg0_63:EnablePlayerOp()
end

function var0_0.OnStartPerformance(arg0_64)
	return
end

function var0_0.OnEndPerformance(arg0_65)
	if not arg0_65.anyPageOpen then
		arg0_65:GetSubView(IslandOpView):ResetShowBalance()
	end
end

function var0_0.OnStartGuide(arg0_66)
	arg0_66.player:StopMoveHandle()
	arg0_66:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_67)
	if arg0_67.playingStory then
		return
	end

	arg0_67:GetSubView(IslandOpView):EnableInput()
end

function var0_0.InitFocusCamera(arg0_68)
	local var0_68 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)

	var0_68.Follow = arg0_68.player._tf
	var0_68.LookAt = arg0_68.player._tf
end

function var0_0.InitTakePhotoCamera(arg0_69)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).Follow = arg0_69.firstTakePhotoItem._tf

	local var0_69 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)

	var0_69.Follow = arg0_69.thirdTakePhotoItem._tf
	var0_69.LookAt = arg0_69.thirdTakePhotoItem._tf
end

function var0_0.DisablePlayerOp(arg0_70)
	arg0_70.player:StopMoveHandle()
	arg0_70:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_70:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_70:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_70:GetSubView(IslandOpView):TryDisable()
end

function var0_0.EnablePlayerOp(arg0_71)
	arg0_71:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_71:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_71:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_71:GetSubView(IslandOpView):TryEnable()
end

function var0_0.OnInterActionBegin(arg0_72)
	arg0_72.player:StopMoveHandle()
	arg0_72:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_73)
	arg0_73:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_74, arg1_74)
	arg0_74.showInterObjId = arg1_74.id

	arg0_74:GetSubView(IslandInteractionView):ShowInterActionPanel(arg1_74)
	arg0_74:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_74.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_75, arg1_75)
	if arg0_75.showInterObjId ~= arg1_75.id then
		return
	end

	arg0_75.showInterObjId = nil

	arg0_75:GetSubView(IslandInteractionView):HideInterActionPanel()
end

function var0_0.OnRefreshInteractionBtn(arg0_76)
	arg0_76:GetSubView(IslandInteractionView):RefreshInteractionBtns()
end

function var0_0.OnSetOpMoveBtnActve(arg0_77, arg1_77, arg2_77)
	arg0_77:GetSubView(IslandOpView):ShowOrHideMoveBtn(arg1_77, arg2_77)
end

function var0_0.DisableInput(arg0_78)
	arg0_78.player:StopMoveHandle()
	arg0_78:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_79)
	arg0_79:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnUpdateCustomOpPositon(arg0_80)
	arg0_80:GetSubView(IslandOpView):InitOpCustumPositon()
end

function var0_0.OnChange_Photo_Height(arg0_81, arg1_81, arg2_81)
	arg0_81.takePhotoModel = arg1_81

	if arg0_81.takePhotoModel == IslandConst.TakePhotoModel.First then
		-- block empty
	elseif arg0_81.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_81.thirdTakePhotoItem:ChangeHeight(arg2_81)
	end
end

function var0_0.OnChangeTakePhotoModel(arg0_82, arg1_82)
	arg0_82.takePhotoModel = arg1_82

	if arg0_82.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_82.firstTakePhotoItem:Enable()

		arg0_82.firstTakePhotoItem._tf.position = arg0_82.player._tf.position
		arg0_82.firstTakePhotoItem._tf.rotation = arg0_82.player._tf.rotation

		arg0_82.firstTakePhotoItem:SetTargetRotation(arg0_82.player._tf.rotation)
		arg0_82.player:SetActiveByLayer(false)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook)):SetPosAndRotationByTargetDir(arg0_82.player._tf.forward)
	elseif arg0_82.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_82.thirdTakePhotoItem:Enable()

		arg0_82.player._tf.position = arg0_82.firstTakePhotoItem._tf.position
		arg0_82.player._tf.rotation = arg0_82.firstTakePhotoItem._tf.rotation

		arg0_82.player:SetTargetRotation(arg0_82.firstTakePhotoItem._tf.rotation)
		arg0_82.player:SetActiveByLayer(true)

		arg0_82.thirdTakePhotoItem._tf.position = arg0_82.firstTakePhotoItem._tf:TransformPoint(Vector3(0, 0, -5))
		arg0_82.thirdTakePhotoItem._tf.rotation = arg0_82.firstTakePhotoItem._tf.rotation

		arg0_82.thirdTakePhotoItem:SetTargetRotation(arg0_82.firstTakePhotoItem._tf.rotation)

		local var0_82 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook))
		local var1_82 = arg0_82.player._tf.position + Vector3(0, 0.5, 0)
		local var2_82 = arg0_82.thirdTakePhotoItem._tf.position + Vector3(0, 1, 0)

		var0_82:SetPosAndRotationByTargetDir((var1_82 - var2_82).normalized)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	else
		arg0_82.firstTakePhotoItem:Disable()
		arg0_82.thirdTakePhotoItem:Disable()

		arg0_82.player._tf.position = arg0_82.firstTakePhotoItem._tf.position
		arg0_82.player._tf.rotation = arg0_82.firstTakePhotoItem._tf.rotation

		arg0_82.player:SetTargetRotation(arg0_82.firstTakePhotoItem._tf.rotation)
		arg0_82.player:SetActiveByLayer(true)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraLook)):ResetCameraPos()
	end

	arg0_82:GetSubView(IslandOpView):ChangeTakePhotoModel(arg1_82)
end

function var0_0.OnNpcDetectorSelected(arg0_83, arg1_83)
	if arg0_83.selectedNpcId then
		return
	end

	local var0_83 = arg1_83.node

	if not var0_83 then
		return
	end

	local var1_83 = var0_83:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_83.selectedNpcId = var1_83

	arg0_83:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_83, true)
	arg0_83:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_83, true)
end

function var0_0.GetSelectedNpcId(arg0_84)
	return arg0_84.selectedNpcId
end

function var0_0.OnNpcDetectorUnSelected(arg0_85, arg1_85)
	local var0_85 = arg1_85.node

	if not var0_85 then
		return
	end

	local var1_85 = var0_85:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_85:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_85)
	arg0_85:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_85)

	if arg0_85.selectedNpcId ~= var1_85 then
		return
	end

	arg0_85.selectedNpcId = nil
end

function var0_0.OnDetectorChanged(arg0_86, arg1_86)
	local var0_86 = arg1_86.node

	if not var0_86 then
		return
	end

	local var1_86 = var0_86:GetBlackboardVariable("DetectorList")

	for iter0_86 = 1, var1_86.Count do
		local var2_86 = var1_86[iter0_86 - 1]
		local var3_86, var4_86 = IslandCalcUtil.GetTypeAndIdByUniqueId(var2_86)

		if var3_86 == IslandConst.UNIT_LIST_OBJ then
			local var5_86 = arg0_86:GetUnitModuleWithType(var3_86, var4_86)

			if var5_86 then
				arg0_86:Op("NotifiyIsland", ISLAND_EX_EVT.APPROACH_OBJECT, var5_86.id)
			end
		end
	end
end

function var0_0.OnDetectorSelected(arg0_87, arg1_87)
	local var0_87 = arg1_87.node

	if not var0_87 then
		return
	end

	local var1_87 = var0_87:GetBlackboardVariable("AnyOne")

	if not var1_87 or var1_87 == "" then
		arg0_87:OnClearSelectedUnit()
	else
		local var2_87, var3_87 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_87)
		local var4_87 = arg0_87:GetUnitModuleWithType(var2_87, var3_87)

		if var4_87 then
			arg0_87:OnSelectedUnit(var4_87)
		end
	end
end

function var0_0.OnClearSelectedUnit(arg0_88)
	return
end

function var0_0.OnSelectedUnit(arg0_89, arg1_89)
	return
end

function var0_0.OnPlayChatBubble(arg0_90, arg1_90)
	local var0_90 = arg0_90:GetAllUnits()

	arg0_90:GetSubView(IslandTopHeadHudView):PlayBubble(arg1_90.name, var0_90, arg1_90.callback)
end

function var0_0.OnRawPlayChatBubble(arg0_91, arg1_91)
	local var0_91 = arg0_91:GetAllUnits()

	arg0_91:GetSubView(IslandTopHeadHudView):RawPlayBubble(arg1_91.info, var0_91, arg1_91.callback)
end

function var0_0.OnRawStopChatBubble(arg0_92, arg1_92)
	arg0_92:GetSubView(IslandTopHeadHudView):RawStopBubble(arg1_92.info)
end

function var0_0.OnChangeVisterDress(arg0_93, arg1_93)
	local var0_93 = arg1_93.id

	if arg0_93:IsPlayer(var0_93) then
		return
	end

	local var1_93 = arg0_93:GetPlayerUnitModule(var0_93)

	if var1_93 then
		var1_93:OnChangeDress(arg1_93.changeDressData)
	end
end

function var0_0.OnSystemUnlock(arg0_94, arg1_94)
	if arg1_94 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_94:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.OnSceneInited(arg0_95, arg1_95)
	IslandCameraMgr.instance:LookAt(arg0_95.player._tf)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraZoom)):SetMaxMinZoom(arg1_95.min, arg1_95.max, arg1_95.value)
	arg0_95:InitFocusCamera()
	arg0_95:InitTakePhotoCamera()

	for iter0_95, iter1_95 in ipairs(arg0_95:GetAllUnits()) do
		iter1_95:Start()
	end

	arg0_95:GetSubView(IslandOpView):LaterInit()

	arg0_95.isInit = true
end

function var0_0.OnGenUnit(arg0_96, arg1_96, arg2_96)
	local var0_96 = arg0_96.unitBuilders[arg1_96:GetType()]:Build(arg1_96, arg2_96)

	arg0_96:AddUnit(var0_96)

	if arg1_96:IsPlayer() then
		arg0_96.player = var0_96
	end

	if arg1_96:IsFirstTakePhoto() then
		arg0_96.firstTakePhotoItem = var0_96
	end

	if arg1_96:IsThirdTakePhoto() then
		arg0_96.thirdTakePhotoItem = var0_96
	end
end

function var0_0.OnGenSystem(arg0_97, arg1_97)
	local var0_97 = arg0_97.systemBuilders[arg1_97:GetType()]:Build(arg1_97)

	arg0_97:AddUnit(var0_97)
end

function var0_0.IsPlayer(arg0_98, arg1_98)
	return arg0_98.player.id == arg1_98
end

function var0_0.OnActiveOrDisactiveUnit(arg0_99, arg1_99, arg2_99, arg3_99)
	local var0_99

	if arg1_99 == 0 then
		var0_99 = arg0_99.player
	else
		var0_99 = arg0_99:GetUnitModuleWithType(arg2_99, arg1_99)
	end

	if var0_99 and arg3_99 then
		var0_99:Enable()
	end

	if var0_99 and not arg3_99 then
		var0_99:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_100, arg1_100, arg2_100, arg3_100)
	local var0_100 = arg0_100:GetUnitModuleWithType(arg2_100, arg1_100)

	if var0_100 then
		var0_100._go.transform.position = arg3_100
	end
end

function var0_0.OnResetUnitRotation(arg0_101, arg1_101, arg2_101, arg3_101)
	local var0_101 = arg0_101:GetUnitModuleWithType(arg2_101, arg1_101)

	if var0_101 then
		var0_101._go.transform.eulerAngles = arg3_101
	end
end

function var0_0.OnMoveUnit(arg0_102, arg1_102)
	assert(arg1_102.type, "type should be exist")

	local var0_102 = arg0_102:GetUnitModuleWithType(arg1_102.type, arg1_102.id)

	if var0_102 then
		var0_102:SetDestination(arg1_102.position, arg1_102.speed, nil, arg1_102.charaRadius)
	end
end

function var0_0.OnStopUnit(arg0_103, arg1_103)
	assert(arg1_103.type, "type should be exist")

	local var0_103 = arg0_103:GetUnitModuleWithType(arg1_103.type, arg1_103.id)

	if var0_103 then
		var0_103:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_104, arg1_104, arg2_104)
	local var0_104 = arg0_104:GetUnitListByKey(arg1_104)
	local var1_104 = 0

	for iter0_104, iter1_104 in ipairs(var0_104 or {}) do
		if iter1_104.id == arg2_104 then
			var1_104 = iter0_104

			break
		end
	end

	if var1_104 > 0 then
		local var2_104 = var0_104[var1_104]

		for iter2_104 = #arg0_104.pathfinders, 1, -1 do
			local var3_104 = arg0_104.pathfinders[iter2_104]

			if var3_104:IsSameUnit(var2_104) then
				var3_104:Dispose()
				table.remove(arg0_104.pathfinders, iter2_104)
			end
		end

		arg0_104:RemoveUnit(var2_104)
		var2_104:Dispose()
		arg0_104:OnHideUnitHudAndOpBtn({
			type = arg1_104,
			id = var2_104.id
		}, true)
		arg0_104:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_104,
			id = arg2_104
		})
		arg0_104:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var2_104)
		arg0_104:GetSubView(IslandInteractionView):CloseInterActionPanelByUnitIdRemove(arg2_104)
	end
end

function var0_0.GetAllUnits(arg0_105)
	table.clear(arg0_105._unitList)

	for iter0_105, iter1_105 in pairs(arg0_105:GetUnitListRegitser()) do
		for iter2_105, iter3_105 in pairs(iter1_105) do
			table.insert(arg0_105._unitList, iter3_105)
		end
	end

	return arg0_105._unitList
end

function var0_0.GetUnitModuleWithType(arg0_106, arg1_106, arg2_106)
	if arg1_106 == IslandConst.UNIT_LIST_PLAYER and arg2_106 == 0 then
		return arg0_106.player
	end

	local var0_106 = arg0_106:GetUnitListByKey(arg1_106)

	for iter0_106, iter1_106 in ipairs(var0_106) do
		if iter1_106.id == arg2_106 then
			return iter1_106
		end
	end

	return nil
end

function var0_0.GetPlayerUnitModule(arg0_107, arg1_107)
	return arg0_107:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_107)
end

function var0_0.GetUnitModule(arg0_108, arg1_108)
	return arg0_108:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_108)
end

function var0_0.GetSystemModule(arg0_109, arg1_109)
	return arg0_109:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_109)
end

function var0_0.GetProductSystemModule(arg0_110, arg1_110)
	return arg0_110:GetUnitModuleWithType(IslandConst.UNIT_LIST_PRODUCT_SYSTEM, arg1_110)
end

function var0_0.GetSystemUnitModule(arg0_111, arg1_111)
	return arg0_111:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_111)
end

function var0_0.GetStrollUnitModule(arg0_112, arg1_112)
	return arg0_112:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_112)
end

function var0_0.GetManageSystemModule(arg0_113, arg1_113)
	return arg0_113:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_113)
end

function var0_0.GetFollowerModule(arg0_114, arg1_114)
	return arg0_114:GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg1_114)
end

function var0_0.OnMovePlayerBefore(arg0_115)
	if arg0_115.player:CheckMovement() and arg0_115.isLockPlayInput then
		arg0_115.isLockPlayInput = false
	end

	arg0_115:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnLockPlayerInput(arg0_116)
	if arg0_116.playerInputing then
		arg0_116.isLockPlayInput = true

		arg0_116.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerMove(arg0_117, arg1_117)
	if arg0_117.isLockPlayInput then
		return
	end

	arg0_117.playerInputing = true

	if arg0_117.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_117.firstTakePhotoItem:MoveHandle(arg1_117.targetDir, arg1_117.force)
	elseif arg0_117.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_117.thirdTakePhotoItem:MoveHandle(arg1_117.targetDir, arg1_117.force)
	else
		arg0_117.player:MoveHandle(arg1_117.targetDir, arg1_117.force)
	end
end

function var0_0.OnPlayerStopMove(arg0_118)
	if arg0_118.isLockPlayInput then
		arg0_118.isLockPlayInput = false
	end

	arg0_118.playerInputing = true

	if arg0_118.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_118.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_118.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_118.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_118.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerStopMoveHandle(arg0_119)
	if arg0_119.isLockPlayInput then
		arg0_119.isLockPlayInput = false
	end

	arg0_119.playerInputing = true

	if arg0_119.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_119.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_119.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_119.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_119.player:StopMoveHandleByInput()
	end
end

function var0_0.OnPlayerJump(arg0_120)
	if arg0_120.takePhotoModel == IslandConst.TakePhotoModel.First or arg0_120.takePhotoModel == IslandConst.TakePhotoModel.Third then
		return
	end

	arg0_120.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_121)
	arg0_121.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_122)
	if arg0_122.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_122.firstTakePhotoItem:OnPlayerPlayerSprint()
	elseif arg0_122.takePhotoModel == IslandConst.TakePhotoModel.Third then
		-- block empty
	else
		arg0_122.player:OnPlayerPlayerSprint()
	end
end

function var0_0.OnStopPlayerSprint(arg0_123)
	if arg0_123.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_123.firstTakePhotoItem:OnStopPlayerSprint()
	elseif arg0_123.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_123.thirdTakePhotoItem:OnStopPlayerSprint()
	else
		arg0_123.player:OnStopPlayerSprint()
	end
end

function var0_0.OnPlayerWork(arg0_124, arg1_124, arg2_124)
	arg0_124.player:WorkHandle(arg1_124, arg2_124)
end

function var0_0.OnPlayerDeviceStateChange(arg0_125, arg1_125)
	arg0_125.player:DeviceStateHandle(arg1_125)
end

function var0_0.OnSetVisitorSyncData(arg0_126, arg1_126, arg2_126)
	local var0_126 = arg0_126:GetPlayerUnitModule(arg1_126)

	if var0_126 then
		var0_126:UpdateSyncData(arg2_126)
	end
end

function var0_0.OnWorldObjectStartInteraction(arg0_127, arg1_127, arg2_127, arg3_127)
	local var0_127 = arg2_127:GetHostId()
	local var1_127 = arg2_127:GetUserId()
	local var2_127 = arg0_127:GetUnitModule(var0_127)
	local var3_127 = arg0_127:GetPlayerUnitModule(var1_127)
	local var4_127 = arg0_127.player == var3_127

	if var4_127 then
		arg0_127:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_127 = arg1_127:GetTimeline()[arg3_127]
	local var6_127 = arg1_127:GetBlackboardParam()[arg3_127]

	var2_127:StartInteract(var3_127, arg2_127.id, arg3_127, var5_127, var6_127, arg1_127:AnySlotUsing(), var4_127)
end

function var0_0.OnWorldObjectEndInteraction(arg0_128, arg1_128, arg2_128)
	local var0_128 = arg2_128:GetHostId()
	local var1_128 = arg2_128:GetUserId()
	local var2_128 = arg0_128:GetUnitModule(var0_128)
	local var3_128 = arg0_128:GetPlayerUnitModule(var1_128)
	local var4_128 = arg0_128.player == var3_128

	if var4_128 then
		arg0_128:GetSubView(IslandOpView):EndInteraction()
	end

	var2_128:EndInteract(var3_128, arg2_128.id, not arg1_128:AnySlotUsing(), var4_128)
end

function var0_0.OnWorldObjectInitStatus(arg0_129, arg1_129, arg2_129)
	local var0_129 = arg0_129:GetUnitModule(arg1_129.id)
	local var1_129 = arg1_129:GetTimeline()[arg2_129]
	local var2_129 = arg1_129:GetBlackboardParam()[arg2_129]

	var0_129:InitStatus(arg2_129, var1_129, var2_129)
end

function var0_0.InitInteractionOpView(arg0_130)
	arg0_130:GetSubView(IslandOpView):EndInteraction()
end

function var0_0.OnPlayerAreaChange(arg0_131)
	arg0_131.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_132, arg1_132, arg2_132)
	arg0_132.player:OnChangeDress(arg1_132, arg2_132)
end

function var0_0.OnCharacterChangeDress(arg0_133, arg1_133, arg2_133, arg3_133, arg4_133)
	local var0_133 = arg0_133:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_133)

	if var0_133 then
		var0_133:OnCharacterChangeDress(arg2_133, arg3_133, arg4_133)
	end

	local var1_133 = arg0_133:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_133, iter1_133 in ipairs(var1_133) do
		if iter1_133:GetDataVO():IsSameShip(arg1_133) then
			iter1_133:OnCharacterChangeDress(arg2_133, arg3_133, arg4_133)
		end
	end

	local var2_133 = arg0_133:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter2_133, iter3_133 in ipairs(var2_133) do
		if iter3_133:GetDataVO():IsSameShip(arg1_133) then
			iter3_133:OnCharacterChangeDress(arg2_133, arg3_133, arg4_133)
		end
	end
end

function var0_0.OnStartDelegation(arg0_134, arg1_134, arg2_134)
	local var0_134 = arg0_134:GetSystemModule(arg1_134.build_id)

	if var0_134 then
		var0_134:StartDelegation(arg1_134)
	end

	local var1_134 = arg0_134:GetProductSystemModule(arg1_134.build_id)

	if var1_134 then
		var1_134:StartDelegation(arg2_134)
	end
end

function var0_0.OnEndDelegation(arg0_135, arg1_135, arg2_135)
	local var0_135 = arg0_135:GetSystemModule(arg1_135.build_id)

	if var0_135 then
		var0_135:EndDelegation(arg1_135)
	end
end

function var0_0.GetPlayerPosition(arg0_136)
	return arg0_136.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_137, arg1_137)
	local var0_137 = arg0_137:GetUnitModule(arg1_137)

	return var0_137 and var0_137._go.transform.position
end

function var0_0.OnShowUnitHudAndOpBtn(arg0_138, arg1_138)
	arg0_138.currentHudUnitData = arg1_138

	arg0_138:GetSubView(IslandSlotHudView):ShowHud(arg1_138.id, arg1_138.height)
	arg0_138:GetSubView(IslandOpView):UpdateOperationButton(arg1_138.operationType, arg1_138.id)

	if arg1_138.isHighLightControl then
		arg0_138.detectionSystem:HighLightUnitHandle(arg1_138.id, true)
	end
end

function var0_0.OnHideUnitHudAndOpBtn(arg0_139, arg1_139, arg2_139)
	if not arg0_139.currentHudUnitData then
		return
	end

	if arg0_139.currentHudUnitData.id ~= arg1_139.id or arg0_139.currentHudUnitData.type ~= arg1_139.type then
		return
	end

	if not arg2_139 then
		arg0_139.currentHudUnitData = nil
	end

	arg0_139:GetSubView(IslandSlotHudView):HideUnitHud(arg1_139.id)
	arg0_139:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_139.id)

	if arg1_139.isHighLightControl then
		arg0_139.detectionSystem:HighLightUnitHandle(arg1_139.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_140, arg1_140)
	if not arg0_140.currentHudUnitData then
		return
	end

	if arg1_140 ~= arg0_140.currentHudUnitData.id then
		return
	end

	arg0_140:GetSubView(IslandSlotHudView):UpdateHud(arg0_140.currentHudUnitData.id, arg0_140.currentHudUnitData.height)
	arg0_140:GetSubView(IslandOpView):UpdateOperationButton(arg0_140.currentHudUnitData.operationType, arg0_140.currentHudUnitData.id)
end

function var0_0.OnUpdateHandCollectUnit(arg0_141, arg1_141)
	local var0_141 = arg0_141:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_141)

	if var0_141 then
		var0_141:UpdateHandCollet()
		var0_141:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_142, arg1_142)
	arg0_142:GetSubView(IslandTopHeadHudView):ShowHud(arg1_142)
	arg0_142:GetSubView(IslandDistanceView):ShowHud(arg1_142.id)
end

function var0_0.OnRefreshHud(arg0_143, arg1_143)
	arg0_143:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_143)
end

function var0_0.OnHideHud(arg0_144, arg1_144)
	arg0_144:GetSubView(IslandTopHeadHudView):HideHud(arg1_144)
	arg0_144:GetSubView(IslandDistanceView):HideHud(arg1_144.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_145, arg1_145)
	local var0_145 = arg0_145:GetUnitModuleWithType(arg1_145.type, arg1_145.id)

	if var0_145 then
		var0_145:DelegateSlotStartPerform()
	end
end

function var0_0.OnRecycleAllSlotEffct(arg0_146)
	arg0_146.effectMgr:RecycleAllSlotEffct()
end

function var0_0.OnLoadDelegatePreviewRole(arg0_147, arg1_147, arg2_147)
	arg0_147.effectMgr:LoadDelegatePreviewRole(arg1_147, arg2_147)
end

function var0_0.OnUnLoadDelegatePreviewRole(arg0_148)
	arg0_148.effectMgr:UnLoadDelegatePreviewRole()
end

function var0_0.OnSelectSlotEffectShow(arg0_149, arg1_149, arg2_149, arg3_149, arg4_149)
	arg0_149.effectMgr:SelectSlotEffectShow(arg1_149, arg2_149, arg3_149, arg4_149)
end

function var0_0.OnTakePlantAttack(arg0_150, arg1_150)
	local var0_150 = arg0_150:GetUnitModuleWithType(arg1_150.type, arg1_150.id)

	if var0_150 then
		var0_150:TakeAttack()
	end
end

function var0_0.OnStartManage(arg0_151, arg1_151)
	local var0_151 = arg0_151:GetManageSystemModule(arg1_151.id)

	if var0_151 then
		var0_151:StartManage(arg1_151)
	end
end

function var0_0.OnEndManage(arg0_152, arg1_152)
	local var0_152 = arg0_152:GetManageSystemModule(arg1_152.id)

	if var0_152 then
		var0_152:EndManage(arg1_152)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_153)
	arg0_153:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnRefreshWeatherSystem(arg0_154)
	arg0_154.weatherSystem:Play()
end

function var0_0.OnDispose(arg0_155)
	arg0_155.detectionSystem:Dispose()
	arg0_155.effectMgr:Dispose()
	arg0_155.coupleActionPlayer:Dispose()
	arg0_155.coupleAction4FollowerPlayer:Dispose()
	arg0_155.npcActionPlayer:Dispose()
	arg0_155.weatherSystem:Dispose()
	arg0_155.coupleNpcWordPlayer:Dispose()
	arg0_155:GetPoolMgr():ClearFishingEffect()

	for iter0_155, iter1_155 in ipairs(arg0_155.views) do
		iter1_155:Dispose()
	end

	for iter2_155, iter3_155 in ipairs(arg0_155.pathfinders) do
		iter3_155:Dispose()
	end

	for iter4_155, iter5_155 in ipairs(arg0_155:GetAllUnits()) do
		iter5_155:Dispose()
	end

	for iter6_155, iter7_155 in pairs(arg0_155.unitBuilders) do
		iter7_155:Dispose()
	end

	for iter8_155, iter9_155 in pairs(arg0_155.systemBuilders) do
		iter9_155:Dispose()
	end

	for iter10_155, iter11_155 in pairs(arg0_155.fishingSynPlayers) do
		iter11_155:Dispose()
	end

	arg0_155.fishingSynPlayers = nil
	arg0_155.npcActionPlayer = nil
	arg0_155.coupleActionPlayer = nil
	arg0_155.coupleAction4FollowerPlayer = nil
	arg0_155.pathfinders = nil
	arg0_155.unitBuilders = nil
	arg0_155.systemBuilders = nil
	arg0_155.views = nil
	arg0_155.player = nil
	arg0_155.isInit = false
	arg0_155._unitList = nil
	arg0_155.detectionSystem = nil
	arg0_155.effectMgr = nil
	arg0_155.coupleNpcWordPlayer = nil
end

return var0_0
