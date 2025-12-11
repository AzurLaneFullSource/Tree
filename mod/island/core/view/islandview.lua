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

function var0_0.DoEnter(arg0_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2:GetAllUnits()) do
		table.insert(var0_2, function(arg0_3)
			iter1_2:Start()

			if iter0_2 % 3 == 0 then
				arg0_3()
			else
				onNextTick(arg0_3)
			end
		end)
	end

	seriesAsync(var0_2, function()
		arg0_2.isInit = true
	end)
end

function var0_0.GetSubView(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.views or {}) do
		if isa(iter1_5, arg1_5) then
			return iter1_5
		end
	end

	return nil
end

function var0_0.CreateOpView(arg0_6)
	return IslandOpView.New(arg0_6)
end

function var0_0.CreateSlotHudView(arg0_7)
	return IslandSlotHudView.New(arg0_7)
end

function var0_0.CreateCancelAnimationOpView(arg0_8)
	return IslandCancelAnimationOpView.New(arg0_8)
end

function var0_0.CreateTopHeadHudView(arg0_9)
	return IslandTopHeadHudView.New(arg0_9)
end

function var0_0.CreateBottomHeadHudeView(arg0_10)
	return IslandBottomHeadHudView.New(arg0_10)
end

function var0_0.CreateAnimationOpView(arg0_11)
	return IslandAniamtionOpView.New(arg0_11)
end

function var0_0.CreateInteractionView(arg0_12)
	return IslandInteractionView.New(arg0_12)
end

function var0_0.CreateDistanceView(arg0_13)
	return IslandDistanceView.New(arg0_13)
end

function var0_0.CreateSeedOpView(arg0_14)
	return IslandSeedOpView.New(arg0_14)
end

function var0_0.IsLoaded(arg0_15)
	local var0_15 = arg0_15:GetAllUnits()

	return _.all(arg0_15.views, function(arg0_16)
		return arg0_16:IsLoaded()
	end) and #var0_15 > 0 and _.all(var0_15, function(arg0_17)
		return arg0_17:IsLoaded()
	end)
end

function var0_0.IsInit(arg0_18)
	return arg0_18.isInit
end

function var0_0.Update(arg0_19)
	if not arg0_19.isInit then
		return
	end

	for iter0_19, iter1_19 in ipairs(arg0_19:GetAllUnits()) do
		iter1_19:Update()
	end

	for iter2_19, iter3_19 in ipairs(arg0_19.views) do
		iter3_19:Update()
	end

	for iter4_19, iter5_19 in ipairs(arg0_19.pathfinders) do
		iter5_19:Update()
	end

	if arg0_19.needTryTrack then
		arg0_19:TryTrack()
	end

	if arg0_19.needTryMainTrack then
		arg0_19:TryMainTrack()
	end
end

function var0_0.LateUpdate(arg0_20)
	if not arg0_20.isInit then
		return
	end

	for iter0_20, iter1_20 in ipairs(arg0_20:GetAllUnits()) do
		iter1_20:LateUpdate()
	end

	for iter2_20, iter3_20 in ipairs(arg0_20.views) do
		iter3_20:LateUpdate()
	end

	for iter4_20, iter5_20 in ipairs(arg0_20.pathfinders) do
		iter5_20:LateUpdate()
	end
end

function var0_0.AddListeners(arg0_21)
	arg0_21:AddListener(ISLAND_EVT.GEN_UNIT, arg0_21.OnGenUnit)
	arg0_21:AddListener(ISLAND_EVT.RMOVE_UNIT, arg0_21.OnRemoveUnit)
	arg0_21:AddListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_21.OnInterActionBegin)
	arg0_21:AddListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_21.OnInterActionEnd)
	arg0_21:AddListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_21.OnStopUnit)
	arg0_21:AddListener(ISLAND_EVT.MOVE_UNIT, arg0_21.OnMoveUnit)
	arg0_21:AddListener(ISLAND_EVT.INIT_FINISH, arg0_21.OnSceneInited)
	arg0_21:AddListener(ISLAND_EVT.MOVE_PLAYER, arg0_21.OnPlayerMove)
	arg0_21:AddListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_21.OnPlayerStopMoveHandle)
	arg0_21:AddListener(ISLAND_EVT.JUMP_PLAYER, arg0_21.OnPlayerJump)
	arg0_21:AddListener(ISLAND_EVT.APPROACH_UNIT, arg0_21.OnShowInterActionPanel)
	arg0_21:AddListener(ISLAND_EVT.LEAVE_UNIT, arg0_21.OnHideInterActionPanel)
	arg0_21:AddListener(ISLAND_EVT.TRACKING, arg0_21.OnTracking)
	arg0_21:AddListener(ISLAND_EVT.UNTRACKING, arg0_21.OnUnTracking)
	arg0_21:AddListener(ISLAND_EVT.AREACHANGE, arg0_21.OnPlayerAreaChange)
	arg0_21:AddListener(ISLAND_EVT.PLAYERRUN, arg0_21.OnPlayerPlayerRun)
	arg0_21:AddListener(ISLAND_EVT.SPRINT_PLAYER, arg0_21.OnPlayerPlayerSprint)
	arg0_21:AddListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_21.OnStopPlayerSprint)
	arg0_21:AddListener(ISLAND_EVT.CHANGE_DRESS, arg0_21.OnChangeDress)
	arg0_21:AddListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_21.OnCharacterChangeDress)
	arg0_21:AddListener(ISLAND_EVT.RESET_UNIT_POS, arg0_21.OnResetUnitPos)
	arg0_21:AddListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_21.OnResetUnitRotation)
	arg0_21:AddListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_21.OnAnyPageOpen)
	arg0_21:AddListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_21.OnAllPageClose)
	arg0_21:AddListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_21.OnChangeTakePhotoModel)
	arg0_21:AddListener(ISLAND_EVT.Change_Photo_Height, arg0_21.OnChange_Photo_Height)
	arg0_21:AddListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_21.OnSetOpMoveBtnActve)
	arg0_21:AddListener(ISLAND_EVT.PLAY_BUBBLE, arg0_21.OnPlayChatBubble)
	arg0_21:AddListener(ISLAND_EVT.RAW_PLAY_BUBBLE, arg0_21.OnRawPlayChatBubble)
	arg0_21:AddListener(ISLAND_EVT.RAW_STOP_BUBBLE, arg0_21.OnRawStopChatBubble)
	arg0_21:AddListener(ISLAND_EVT.START_STORY, arg0_21.OnStartStory)
	arg0_21:AddListener(ISLAND_EVT.END_STORY, arg0_21.OnEndStory)
	arg0_21:AddListener(ISLAND_EVT.START_DEGATION, arg0_21.OnStartDelegation)
	arg0_21:AddListener(ISLAND_EVT.END_DEGATION, arg0_21.OnEndDelegation)
	arg0_21:AddListener(ISLAND_EVT.GEN_SYSTEM, arg0_21.OnGenSystem)
	arg0_21:AddListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_21.OnWorldObjectStartInteraction)
	arg0_21:AddListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_21.OnWorldObjectEndInteraction)
	arg0_21:AddListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_21.OnWorldObjectInitStatus)
	arg0_21:AddListener(ISLAND_EVT.INIT_INTERACTION_OP_VIEW, arg0_21.InitInteractionOpView)
	arg0_21:AddListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_21.OnRefreshInteractionBtn)
	arg0_21:AddListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_21.OnShowUnitHudAndOpBtn)
	arg0_21:AddListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_21.OnHideUnitHudAndOpBtn)
	arg0_21:AddListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_21.OnDetectorChanged)
	arg0_21:AddListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_21.OnDetectorSelected)
	arg0_21:AddListener(ISLAND_EVT.FISHPOINT_DETECTOR, arg0_21.OnFishPointSelected)
	arg0_21:AddListener(ISLAND_EVT.NPC_DETECTED, arg0_21.OnNpcDetectorSelected)
	arg0_21:AddListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_21.OnNpcDetectorUnSelected)
	arg0_21:AddListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_21.OnPlayerWork)
	arg0_21:AddListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_21.OnPlayerDeviceStateChange)
	arg0_21:AddListener(ISLAND_EVT.UPDATE_HUD, arg0_21.OnUpdateHud)
	arg0_21:AddListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_21.OnUpdateHandCollectUnit)
	arg0_21:AddListener(ISLAND_EVT.START_DELEGATE_SLOT_PERFORM, arg0_21.OnDelegateSlotStartPerform)
	arg0_21:AddListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_21.OnRecycleAllSlotEffct)
	arg0_21:AddListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_21.OnSelectSlotEffectShow)
	arg0_21:AddListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_21.OnLoadDelegatePreviewRole)
	arg0_21:AddListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_21.OnUnLoadDelegatePreviewRole)
	arg0_21:AddListener(ISLAND_EVT.Take_Plant_Attact, arg0_21.OnTakePlantAttack)
	arg0_21:AddListener(ISLAND_EVT.START_MANAGE, arg0_21.OnStartManage)
	arg0_21:AddListener(ISLAND_EVT.END_MANAGE, arg0_21.OnEndManage)
	arg0_21:AddListener(ISLAND_EVT.SHOW_HUD, arg0_21.OnShowHud)
	arg0_21:AddListener(ISLAND_EVT.HIDE_HUD, arg0_21.OnHideHud)
	arg0_21:AddListener(ISLAND_EVT.REFRESH_HUD, arg0_21.OnRefreshHud)
	arg0_21:AddListener(ISLAND_EVT.START_GUIDE, arg0_21.OnStartGuide)
	arg0_21:AddListener(ISLAND_EVT.END_GUIDE, arg0_21.OnEndGuide)
	arg0_21:AddListener(ISLAND_EVT.START_PERFORMANCE, arg0_21.OnStartPerformance)
	arg0_21:AddListener(ISLAND_EVT.END_PERFORMANCE, arg0_21.OnEndPerformance)
	arg0_21:AddListener(ISLAND_EVT.DISABLE_INPUT, arg0_21.DisableInput)
	arg0_21:AddListener(ISLAND_EVT.ENABLE_INPUT, arg0_21.EnableInput)
	arg0_21:AddListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_21.OnGenPathFinder)
	arg0_21:AddListener(ISLAND_EVT.REMOVE_PATH_FINDER, arg0_21.OnRemovePathFinder)
	arg0_21:AddListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_21.OnActiveOrDisactiveUnit)
	arg0_21:AddListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_21.OnOpenAniamtionOpPage)
	arg0_21:AddListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_21.OnCloseAniamtionOpPage)
	arg0_21:AddListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_21.OnMovePlayerBefore)
	arg0_21:AddListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_21.OnRefreshTaskInfoHud)
	arg0_21:AddListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_21.OnResponAniamtionOp)
	arg0_21:AddListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_21.OnChangeVisterDress)
	arg0_21:AddListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_21.OnSetVisitorSyncData)
	arg0_21:AddListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_21.OnShowNpcAniamtionBubble)
	arg0_21:AddListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_21.OnHideNpcAniamtionBubble)
	arg0_21:AddListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_21.OnPlaySingleAnimationEnd)
	arg0_21:AddListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_21.OnUpdateCustomOpPositon)
	arg0_21:AddListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_21.OnChatMsgUpdate)
	arg0_21:AddListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_21.OnChatRoomChange)
	arg0_21:AddListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_21.OnShowChatMsg)
	arg0_21:AddListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_21.OnResetFollowRandomizer)
	arg0_21:AddListener(ISLAND_EVT.ADD_FOLLOWER, arg0_21.OnFollowerAdd)
	arg0_21:AddListener(ISLAND_EVT.DEL_FOLLOWER, arg0_21.OnFollowerDel)
	arg0_21:AddListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_21.OnCoupleActionWithFollower)
	arg0_21:AddListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_21.OnLockPlayerInput)
	arg0_21:AddListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_21.OnStartCoupleAction)
	arg0_21:AddListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_21.OnEndCoupleAction)
	arg0_21:AddListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_21.OnRefreshWeatherSystem)
	arg0_21:AddListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_21.OnSystemUnlock)
	arg0_21:AddListener(ISLAND_EVT.START_DO_COUPLE_ACTION, arg0_21.OnStartDoCoupleAction)
	arg0_21:AddListener(ISLAND_EVT.END_DO_COUPLE_ACTION, arg0_21.OnEndDoCoupleAction)
	arg0_21:AddListener(ISLAND_EVT.CANCEL_COUPLE_ACTION, arg0_21.OnCancelCoupleAction)
	arg0_21:AddListener(ISLAND_EVT.BAIT_UPDATE, arg0_21.OnBaitUpdate)
	arg0_21:AddListener(ISLAND_EVT.START_FISHING, arg0_21.OnStartFishing)
	arg0_21:AddListener(ISLAND_EVT.FISHING_STATE_CHANGE, arg0_21.OnFishingStateChange)
end

function var0_0.RemoveListeners(arg0_22)
	arg0_22:RemoveListener(ISLAND_EVT.GEN_UNIT, arg0_22.OnGenUnit)
	arg0_22:RemoveListener(ISLAND_EVT.RMOVE_UNIT, arg0_22.OnRemoveUnit)
	arg0_22:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_22.OnInterActionBegin)
	arg0_22:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_22.OnInterActionEnd)
	arg0_22:RemoveListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_22.OnStopUnit)
	arg0_22:RemoveListener(ISLAND_EVT.MOVE_UNIT, arg0_22.OnMoveUnit)
	arg0_22:RemoveListener(ISLAND_EVT.INIT_FINISH, arg0_22.OnSceneInited)
	arg0_22:RemoveListener(ISLAND_EVT.MOVE_PLAYER, arg0_22.OnPlayerMove)
	arg0_22:RemoveListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_22.OnPlayerStopMoveHandle)
	arg0_22:RemoveListener(ISLAND_EVT.JUMP_PLAYER, arg0_22.OnPlayerJump)
	arg0_22:RemoveListener(ISLAND_EVT.APPROACH_UNIT, arg0_22.OnShowInterActionPanel)
	arg0_22:RemoveListener(ISLAND_EVT.LEAVE_UNIT, arg0_22.OnHideInterActionPanel)
	arg0_22:RemoveListener(ISLAND_EVT.TRACKING, arg0_22.OnTracking)
	arg0_22:RemoveListener(ISLAND_EVT.UNTRACKING, arg0_22.OnUnTracking)
	arg0_22:RemoveListener(ISLAND_EVT.AREACHANGE, arg0_22.OnPlayerAreaChange)
	arg0_22:RemoveListener(ISLAND_EVT.PLAYERRUN, arg0_22.OnPlayerPlayerRun)
	arg0_22:RemoveListener(ISLAND_EVT.SPRINT_PLAYER, arg0_22.OnPlayerPlayerSprint)
	arg0_22:RemoveListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_22.OnStopPlayerSprint)
	arg0_22:RemoveListener(ISLAND_EVT.CHANGE_DRESS, arg0_22.OnChangeDress)
	arg0_22:RemoveListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_22.OnCharacterChangeDress)
	arg0_22:RemoveListener(ISLAND_EVT.RESET_UNIT_POS, arg0_22.OnResetUnitPos)
	arg0_22:RemoveListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_22.OnResetUnitRotation)
	arg0_22:RemoveListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_22.OnAnyPageOpen)
	arg0_22:RemoveListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_22.OnChangeTakePhotoModel)
	arg0_22:RemoveListener(ISLAND_EVT.Change_Photo_Height, arg0_22.OnChange_Photo_Height)
	arg0_22:RemoveListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_22.OnSetOpMoveBtnActve)
	arg0_22:RemoveListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_22.OnAllPageClose)
	arg0_22:RemoveListener(ISLAND_EVT.PLAY_BUBBLE, arg0_22.OnPlayChatBubble)
	arg0_22:RemoveListener(ISLAND_EVT.RAW_PLAY_BUBBLE, arg0_22.OnRawPlayChatBubble)
	arg0_22:RemoveListener(ISLAND_EVT.RAW_STOP_BUBBLE, arg0_22.OnRawStopChatBubble)
	arg0_22:RemoveListener(ISLAND_EVT.START_STORY, arg0_22.OnStartStory)
	arg0_22:RemoveListener(ISLAND_EVT.END_STORY, arg0_22.OnEndStory)
	arg0_22:RemoveListener(ISLAND_EVT.START_DEGATION, arg0_22.OnStartDelegation)
	arg0_22:RemoveListener(ISLAND_EVT.END_DEGATION, arg0_22.OnEndDelegation)
	arg0_22:RemoveListener(ISLAND_EVT.GEN_SYSTEM, arg0_22.OnGenSystem)
	arg0_22:RemoveListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_22.OnWorldObjectStartInteraction)
	arg0_22:RemoveListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_22.OnWorldObjectEndInteraction)
	arg0_22:RemoveListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_22.OnWorldObjectInitStatus)
	arg0_22:RemoveListener(ISLAND_EVT.INIT_INTERACTION_OP_VIEW, arg0_22.InitInteractionOpView)
	arg0_22:RemoveListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_22.OnRefreshInteractionBtn)
	arg0_22:RemoveListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_22.OnShowUnitHudAndOpBtn)
	arg0_22:RemoveListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_22.OnHideUnitHudAndOpBtn)
	arg0_22:RemoveListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_22.OnDetectorChanged)
	arg0_22:RemoveListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_22.OnDetectorSelected)
	arg0_22:RemoveListener(ISLAND_EVT.FISHPOINT_DETECTOR, arg0_22.OnFishPointSelected)
	arg0_22:RemoveListener(ISLAND_EVT.NPC_DETECTED, arg0_22.OnNpcDetectorSelected)
	arg0_22:RemoveListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_22.OnNpcDetectorUnSelected)
	arg0_22:RemoveListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_22.OnPlayerWork)
	arg0_22:RemoveListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_22.OnPlayerDeviceStateChange)
	arg0_22:RemoveListener(ISLAND_EVT.UPDATE_HUD, arg0_22.OnUpdateHud)
	arg0_22:RemoveListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_22.OnUpdateHandCollectUnit)
	arg0_22:RemoveListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_22.OnRecycleAllSlotEffct)
	arg0_22:RemoveListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_22.OnSelectSlotEffectShow)
	arg0_22:RemoveListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_22.OnLoadDelegatePreviewRole)
	arg0_22:RemoveListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_22.OnUnLoadDelegatePreviewRole)
	arg0_22:RemoveListener(ISLAND_EVT.Take_Plant_Attact, arg0_22.OnTakePlantAttack)
	arg0_22:RemoveListener(ISLAND_EVT.START_MANAGE, arg0_22.OnStartManage)
	arg0_22:RemoveListener(ISLAND_EVT.END_MANAGE, arg0_22.OnEndManage)
	arg0_22:RemoveListener(ISLAND_EVT.SHOW_HUD, arg0_22.OnShowHud)
	arg0_22:RemoveListener(ISLAND_EVT.HIDE_HUD, arg0_22.OnHideHud)
	arg0_22:RemoveListener(ISLAND_EVT.REFRESH_HUD, arg0_22.OnRefreshHud)
	arg0_22:RemoveListener(ISLAND_EVT.START_GUIDE, arg0_22.OnStartGuide)
	arg0_22:RemoveListener(ISLAND_EVT.END_GUIDE, arg0_22.OnEndGuide)
	arg0_22:RemoveListener(ISLAND_EVT.START_PERFORMANCE, arg0_22.OnStartPerformance)
	arg0_22:RemoveListener(ISLAND_EVT.END_PERFORMANCE, arg0_22.OnEndPerformance)
	arg0_22:RemoveListener(ISLAND_EVT.DISABLE_INPUT, arg0_22.DisableInput)
	arg0_22:RemoveListener(ISLAND_EVT.ENABLE_INPUT, arg0_22.EnableInput)
	arg0_22:RemoveListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_22.OnGenPathFinder)
	arg0_22:RemoveListener(ISLAND_EVT.REMOVE_PATH_FINDER, arg0_22.OnRemovePathFinder)
	arg0_22:RemoveListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_22.OnActiveOrDisactiveUnit)
	arg0_22:RemoveListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_22.OnOpenAniamtionOpPage)
	arg0_22:RemoveListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_22.OnCloseAniamtionOpPage)
	arg0_22:RemoveListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_22.OnMovePlayerBefore)
	arg0_22:RemoveListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_22.OnRefreshTaskInfoHud)
	arg0_22:RemoveListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_22.OnResponAniamtionOp)
	arg0_22:RemoveListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_22.OnChangeVisterDress)
	arg0_22:RemoveListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_22.OnSetVisitorSyncData)
	arg0_22:RemoveListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_22.OnShowNpcAniamtionBubble)
	arg0_22:RemoveListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_22.OnHideNpcAniamtionBubble)
	arg0_22:RemoveListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_22.OnPlaySingleAnimationEnd)
	arg0_22:RemoveListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_22.OnUpdateCustomOpPositon)
	arg0_22:RemoveListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_22.OnChatMsgUpdate)
	arg0_22:RemoveListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_22.OnChatRoomChange)
	arg0_22:RemoveListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_22.OnShowChatMsg)
	arg0_22:RemoveListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_22.OnResetFollowRandomizer)
	arg0_22:RemoveListener(ISLAND_EVT.ADD_FOLLOWER, arg0_22.OnFollowerAdd)
	arg0_22:RemoveListener(ISLAND_EVT.DEL_FOLLOWER, arg0_22.OnFollowerDel)
	arg0_22:RemoveListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_22.OnCoupleActionWithFollower)
	arg0_22:RemoveListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_22.OnLockPlayerInput)
	arg0_22:RemoveListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_22.OnStartCoupleAction)
	arg0_22:RemoveListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_22.OnEndCoupleAction)
	arg0_22:RemoveListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_22.OnRefreshWeatherSystem)
	arg0_22:RemoveListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_22.OnSystemUnlock)
	arg0_22:RemoveListener(ISLAND_EVT.START_DO_COUPLE_ACTION, arg0_22.OnStartDoCoupleAction)
	arg0_22:RemoveListener(ISLAND_EVT.END_DO_COUPLE_ACTION, arg0_22.OnEndDoCoupleAction)
	arg0_22:RemoveListener(ISLAND_EVT.CANCEL_COUPLE_ACTION, arg0_22.OnCancelCoupleAction)
	arg0_22:RemoveListener(ISLAND_EVT.BAIT_UPDATE, arg0_22.OnBaitUpdate)
	arg0_22:RemoveListener(ISLAND_EVT.START_FISHING, arg0_22.OnStartFishing)
	arg0_22:RemoveListener(ISLAND_EVT.FISHING_STATE_CHANGE, arg0_22.OnFishingStateChange)
end

function var0_0.OnBaitUpdate(arg0_23, arg1_23)
	arg0_23:GetSubView(IslandOpView):UpdateLureBtn()
end

function var0_0.OnFishPointSelected(arg0_24, arg1_24)
	local var0_24 = arg1_24.node

	if not var0_24 then
		return
	end

	local var1_24 = var0_24:GetBlackboardVariable("FishPoint")

	if not var1_24 or var1_24 == "" then
		arg0_24:UnSelectedFishPoint()
	else
		local var2_24, var3_24 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_24)
		local var4_24 = arg0_24:GetUnitModuleWithType(var2_24, var3_24)

		if var4_24 then
			arg0_24:SelectedFishPoint(var4_24)
		end
	end
end

function var0_0.SelectedFishPoint(arg0_25, arg1_25)
	if not arg0_25:GetSelfIsland():GetAblityAgency():IsUnlockFishing() or arg1_25:GetUnitType() ~= IslandConst.UNIT_LIST_FISH_POINT or arg0_25.player:StandOnWorldObject() or not arg0_25.player:OnGrouded() then
		return
	end

	arg0_25:UnSelectedFishPoint()

	arg0_25.selectedFishPointId = arg1_25.id

	arg0_25:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.Fishing, arg1_25.id)
end

function var0_0.UnSelectedFishPoint(arg0_26)
	if arg0_26.selectedFishPointId then
		local var0_26 = arg0_26.selectedFishPointId

		arg0_26.selectedFishPointId = nil

		arg0_26:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, var0_26)
	end
end

function var0_0.OnStartFishing(arg0_27, arg1_27)
	local var0_27 = arg1_27.unitId
	local var1_27 = arg0_27:GetPlayerUnitModule(var0_27)

	if not var1_27 then
		return
	end

	if not isa(var1_27, IslandVisitorUnit) then
		return
	end

	var1_27:Sleep()

	local var2_27 = arg1_27.fishPointId
	local var3_27 = arg1_27.rodId
	local var4_27 = arg1_27.fishId
	local var5_27 = pg.island_fish_rod[var3_27].attachment_id
	local var6_27 = IslandVistorFishingPlayer.New(arg0_27, var1_27, var2_27, var5_27, var4_27)

	var6_27:Play()

	arg0_27.fishingSynPlayers[var0_27] = var6_27
end

function var0_0.OnFishingStateChange(arg0_28, arg1_28)
	local var0_28 = arg1_28.op
	local var1_28 = arg1_28.unitId
	local var2_28 = arg0_28:GetPlayerUnitModule(var1_28)
	local var3_28 = arg0_28.fishingSynPlayers[var1_28]

	if not isa(var2_28, IslandVisitorUnit) then
		return
	end

	if not var3_28 or not var3_28:IsSameFishPoint(arg1_28.fishPointId) then
		return
	end

	local function var4_28()
		var2_28:WakeUp()
		arg0_28.fishingSynPlayers[var1_28]:Dispose()

		arg0_28.fishingSynPlayers[var1_28] = nil
	end

	if var0_28 == IslandConst.FISHING_OP_CANCEL then
		var3_28:OnCancel(var4_28)
	elseif var0_28 == IslandConst.FISHING_OP_FAILD then
		var3_28:OnFailed(var4_28)
	elseif var0_28 == IslandConst.FISHING_OP_SUCCESS then
		var3_28:OnSuccess(var4_28)
	end
end

function var0_0.OnStartCoupleAction(arg0_30)
	arg0_30:UnBlockLayer1Event(false)
	arg0_30:GetSubView(IslandAniamtionOpView):OnStartCoupleAction()
end

function var0_0.OnEndCoupleAction(arg0_31)
	arg0_31:UnBlockLayer1Event(true)
	arg0_31:GetSubView(IslandAniamtionOpView):OnEndCoupleAction()
end

function var0_0.OnCancelCoupleAction(arg0_32)
	if arg0_32.coupleActionPlayer and arg0_32.coupleActionPlayer:IsPlaying() then
		arg0_32.coupleActionPlayer:Stop()
	end

	if arg0_32.coupleAction4FollowerPlayer and arg0_32.coupleAction4FollowerPlayer:IsPlaying() then
		arg0_32.coupleAction4FollowerPlayer:Stop()
	end

	arg0_32:OnEndCoupleAction()
end

function var0_0.OnCoupleActionWithFollower(arg0_33, arg1_33)
	local var0_33 = arg0_33:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_33 = arg0_33:GetPlayerPosition()
	local var2_33 = pg.island_set.action_bubble_range.key_value_int
	local var3_33 = _.select(var0_33, function(arg0_34)
		return Vector3.Distance(arg0_34:GetPosition(), var1_33) <= var2_33
	end)

	if #var3_33 <= 0 then
		return
	end

	local var4_33 = var3_33[math.random(1, #var3_33)]
	local var5_33 = pg.island_action[arg1_33]

	arg0_33.coupleAction4FollowerPlayer:Play(var4_33, arg0_33.player, var5_33)
	arg0_33:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
end

function var0_0.OnPlaySingleAnimationEnd(arg0_35, arg1_35)
	if not arg0_35:GetSelectedNpcId() then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(1, arg1_35, 0, 0, 0, 0))

		return
	end

	local var0_35 = arg0_35:GetSelectedNpcId()
	local var1_35, var2_35 = IslandCalcUtil.GetTypeAndIdByUniqueId(var0_35)
	local var3_35 = arg0_35:GetUnitModuleWithType(var1_35, var2_35)

	arg0_35.npcActionPlayer:Play(var3_35, arg0_35.player, arg1_35)
end

function var0_0.OnShowNpcAniamtionBubble(arg0_36, arg1_36)
	local var0_36 = arg0_36:GetStrollUnitModule(arg1_36.id)

	if not var0_36 then
		return
	end

	local var1_36 = arg1_36:GetActionFeedback()

	arg0_36:GetSubView(IslandBottomHeadHudView):ShowAnimationOp(var0_36, var1_36)
end

function var0_0.OnHideNpcAniamtionBubble(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetStrollUnitModule(arg1_37.id)

	arg0_37:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var0_37)
end

function var0_0.OnStartDoCoupleAction(arg0_38)
	arg0_38:GetSubView(IslandCancelAnimationOpView):ShowCancelableAnimationOp(arg0_38.player)
end

function var0_0.OnEndDoCoupleAction(arg0_39)
	arg0_39:GetSubView(IslandCancelAnimationOpView):HideCancelableAnimationOp(arg0_39.player)
end

function var0_0.OnResponAniamtionOp(arg0_40, arg1_40)
	local var0_40 = arg1_40.id
	local var1_40 = arg1_40.targetId
	local var2_40 = arg1_40.actionId
	local var3_40 = arg0_40:GetPlayerUnitModule(var0_40)

	if not var3_40 then
		return
	end

	if var2_40 == 0 then
		if not arg0_40:IsPlayer(var0_40) then
			arg0_40:GetSubView(IslandTopHeadHudView):HideAnimationOp(var3_40)
		else
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_40, 1, 0, 0, 0))
		end

		return
	end

	local var4_40 = pg.island_action[var2_40]

	if var1_40 == 0 and var4_40.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_40:IsPlayer(var0_40) then
		arg0_40:GetSubView(IslandTopHeadHudView):ShowAnimationOp(var3_40, var2_40)
	elseif var1_40 > 0 and var4_40.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_40:IsPlayer(var1_40) then
		local var5_40 = arg0_40:GetPlayerUnitModule(var1_40)

		arg0_40.coupleActionPlayer:Play(var3_40, var5_40, var4_40)
		arg0_40:GetSubView(IslandTopHeadHudView):HideAnimationOp(var5_40)
	elseif var1_40 > 0 and var4_40.type == IslandConst.ANIMATION_OP_DOUBLE and arg0_40:IsPlayer(var1_40) then
		local var6_40 = arg0_40:GetPlayerUnitModule(var1_40)

		arg0_40.coupleActionPlayer:Play(var3_40, var6_40, var4_40)
		arg0_40:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_40, 1, var1_40, 0, 1))
	end
end

function var0_0.OnShowChatMsg(arg0_41, arg1_41)
	local var0_41 = arg1_41.player.id
	local var1_41 = arg0_41:GetPlayerUnitModule(var0_41)

	if not var1_41 then
		return
	end

	arg0_41:GetSubView(IslandTopHeadHudView):PlayChat(var1_41, arg1_41.emojiId, arg1_41.content, nil)
end

function var0_0.OnChatRoomChange(arg0_42)
	arg0_42:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_43)
	arg0_43:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnFollowerAdd(arg0_44, arg1_44)
	arg0_44:GetSubView(IslandOpView):FlushFollowerList()
	arg0_44.coupleNpcWordPlayer:Play(arg1_44)
end

function var0_0.OnFollowerDel(arg0_45, arg1_45)
	arg0_45:GetSubView(IslandOpView):FlushFollowerList()
	arg0_45.coupleNpcWordPlayer:Stop(arg1_45)
end

function var0_0.OnResetFollowRandomizer(arg0_46, arg1_46)
	local var0_46 = arg0_46:GetFollowerModule(arg1_46)

	if not var0_46 then
		return
	end

	var0_46:SetBtRandomizer()
end

function var0_0.OnGenPathFinder(arg0_47, arg1_47)
	local var0_47 = IslandPathFinder.New(arg0_47)
	local var1_47 = defaultValue(arg1_47.navData.waitUntilDone, false)

	var0_47:Start(arg1_47.navData, function()
		table.removebyvalue(arg0_47.pathfinders, var0_47)
		var0_47:Dispose()

		if arg1_47.onEndAction then
			arg1_47.onEndAction()
		end

		arg0_47:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH_DONE, arg1_47.navData.index)

		if var1_47 and arg1_47.callback then
			arg1_47.callback()
		end
	end)
	arg0_47:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH, arg1_47.navData.index)

	if not var1_47 and arg1_47.callback then
		arg1_47.callback()
	end

	table.insert(arg0_47.pathfinders, var0_47)
end

function var0_0.OnRemovePathFinder(arg0_49, arg1_49)
	local var0_49 = arg0_49:GetUnitModuleWithType(arg1_49.unitType, arg1_49.unitId)
	local var1_49 = _.detect(arg0_49.pathfinders, function(arg0_50)
		return arg0_50:IsSameUnit(var0_49)
	end)

	if not var1_49 then
		return
	end

	var1_49:Stop()
	var1_49:Dispose()
	table.removebyvalue(arg0_49.pathfinders, var1_49)
end

function var0_0.OnTracking(arg0_51, arg1_51)
	local var0_51 = arg1_51.trackType

	if var0_51 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_51.mainTrackId = tonumber(arg1_51.id)
		arg0_51.needTryMainTrack = true
	elseif var0_51 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_51.trackId = tonumber(arg1_51.id)
		arg0_51.trackType = arg1_51.typ or IslandTaskType.MAIN
		arg0_51.needTryTrack = true
	end
end

function var0_0.TryTrack(arg0_52)
	arg0_52:TrySetTrack(arg0_52.trackId)
end

function var0_0.TrySetTrack(arg0_53, arg1_53)
	local var0_53 = arg0_53:GetOptTrackingTarget(arg1_53)

	if not var0_53 or not var0_53._go then
		return
	end

	arg0_53:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_53.player, var0_53, arg1_53, arg0_53.trackType, IslandTaskTrackCard.TYPES.OTHER)

	arg0_53.needTryTrack = false
end

function var0_0.TryMainTrack(arg0_54)
	arg0_54:TrySetMainTrack(arg0_54.mainTrackId)
end

function var0_0.TrySetMainTrack(arg0_55, arg1_55)
	local var0_55 = arg0_55:GetOptTrackingTarget(arg1_55)

	if not var0_55 or not var0_55._go then
		return
	end

	arg0_55:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_55.player, var0_55, arg1_55, IslandTaskType.MAIN, IslandTaskTrackCard.TYPES.MAIN)

	arg0_55.needTryMainTrack = false
end

function var0_0.OnUnTracking(arg0_56, arg1_56)
	if arg1_56 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_56.mainTrackId = nil
	elseif arg1_56 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_56.trackId = nil
	end

	arg0_56:GetSubView(IslandDistanceView):CancelTracking(arg1_56)
end

local function var1_0(arg0_57, arg1_57)
	local var0_57 = pg.island_world_objects[arg0_57]

	if not var0_57 then
		return
	end

	return var0_57.mapId == arg1_57
end

local function var2_0(arg0_58, arg1_58, arg2_58)
	for iter0_58, iter1_58 in ipairs(arg0_58) do
		for iter2_58, iter3_58 in ipairs(iter1_58[2]) do
			local var0_58 = pg.island_interaction[iter3_58]

			if var0_58.type == arg2_58 and var1_0(tonumber(var0_58.param), arg1_58) then
				return iter1_58[1]
			end
		end
	end

	return nil
end

local function var3_0(arg0_59)
	local var0_59 = {}
	local var1_59 = {}

	for iter0_59, iter1_59 in ipairs(arg0_59) do
		for iter2_59, iter3_59 in ipairs(iter1_59[2]) do
			local var2_59 = pg.island_interaction[iter3_59]

			if var2_59.type == IslandInteractionUntil.TYPE_TRANSFER then
				table.insert(var0_59, iter1_59[1])
			elseif var2_59.type == IslandInteractionUntil.TYPE_SP_TRANSFER then
				table.insert(var1_59, iter1_59[1])
			end
		end
	end

	if #var1_59 > 0 then
		return var1_59[1]
	end

	if #var0_59 > 0 then
		return var0_59[1]
	end

	return nil
end

function var0_0.GetOptTrackingTarget(arg0_60, arg1_60)
	local var0_60 = arg0_60:GetUnitModule(arg1_60)

	if var0_60 then
		return var0_60
	end

	local var1_60 = pg.island_world_objects[arg1_60]

	if not var1_60 then
		return nil
	end

	local var2_60 = {}

	for iter0_60, iter1_60 in ipairs(arg0_60:GetUnitListByKey(IslandConst.UNIT_LIST_OBJ)) do
		local var3_60, var4_60 = iter1_60:IsMapTransfer()

		if var3_60 then
			table.insert(var2_60, {
				iter1_60,
				var4_60
			})
		end
	end

	local var5_60
	local var6_60 = var2_0(var2_60, var1_60.mapId, IslandInteractionUntil.TYPE_TRANSFER) or var2_0(var2_60, var1_60.mapId, IslandInteractionUntil.TYPE_SP_TRANSFER)

	var6_60 = var6_60 or var3_0(var2_60)

	return var6_60
end

function var0_0.OnOpenAniamtionOpPage(arg0_61)
	arg0_61:GetSubView(IslandAniamtionOpView):TryEnable()
	arg0_61:GetSubView(IslandOpView):TryDisable()
	arg0_61:NotifiyIsland(ISLAND_EX_EVT.OPEN_ANIMATION_OP)
end

function var0_0.OnCloseAniamtionOpPage(arg0_62)
	arg0_62:GetSubView(IslandOpView):TryEnable()
	arg0_62:NotifiyIsland(ISLAND_EX_EVT.CLOSE_ANIMATION_OP)
end

function var0_0.OnAnyPageOpen(arg0_63, arg1_63)
	arg0_63.anyPageOpen = true

	arg0_63.player:StopMoveHandle()
	arg0_63:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_63:GetSubView(IslandSlotHudView):TryDisable()
	arg0_63:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_63:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_63:GetSubView(IslandAniamtionOpView):CloseAndReset()
end

function var0_0.OnAllPageClose(arg0_64)
	arg0_64.anyPageOpen = false

	arg0_64:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_64:GetSubView(IslandSlotHudView):TryEnable()
	arg0_64:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_64:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnStartStory(arg0_65)
	arg0_65.playingStory = true

	arg0_65:DisablePlayerOp()
end

function var0_0.OnEndStory(arg0_66)
	arg0_66.playingStory = false

	arg0_66:EnablePlayerOp()
end

function var0_0.OnStartPerformance(arg0_67)
	return
end

function var0_0.OnEndPerformance(arg0_68)
	if not arg0_68.anyPageOpen then
		arg0_68:GetSubView(IslandOpView):ResetShowBalance()
	end
end

function var0_0.OnStartGuide(arg0_69)
	arg0_69.player:StopMoveHandle()
	arg0_69:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_70)
	if arg0_70.playingStory then
		return
	end

	arg0_70:GetSubView(IslandOpView):EnableInput()
end

function var0_0.InitFocusCamera(arg0_71)
	local var0_71 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)

	var0_71.Follow = arg0_71.player._tf
	var0_71.LookAt = arg0_71.player._tf
end

function var0_0.InitTakePhotoCamera(arg0_72)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).Follow = arg0_72.firstTakePhotoItem._tf

	local var0_72 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)

	var0_72.Follow = arg0_72.thirdTakePhotoItem._tf
	var0_72.LookAt = arg0_72.thirdTakePhotoItem._tf
end

function var0_0.DisablePlayerOp(arg0_73)
	arg0_73.player:StopMoveHandle()
	arg0_73:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_73:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_73:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_73:GetSubView(IslandOpView):TryDisable()
end

function var0_0.EnablePlayerOp(arg0_74)
	arg0_74:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_74:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_74:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_74:GetSubView(IslandOpView):TryEnable()
end

function var0_0.OnInterActionBegin(arg0_75)
	arg0_75.player:StopMoveHandle()
	arg0_75:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_76)
	arg0_76:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_77, arg1_77)
	arg0_77.showInterObjId = arg1_77.id

	arg0_77:GetSubView(IslandInteractionView):ShowInterActionPanel(arg1_77)
	arg0_77:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_77.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_78, arg1_78)
	if arg0_78.showInterObjId ~= arg1_78.id then
		return
	end

	arg0_78.showInterObjId = nil

	arg0_78:GetSubView(IslandInteractionView):HideInterActionPanel()
end

function var0_0.OnRefreshInteractionBtn(arg0_79)
	arg0_79:GetSubView(IslandInteractionView):RefreshInteractionBtns()
end

function var0_0.OnSetOpMoveBtnActve(arg0_80, arg1_80, arg2_80)
	arg0_80:GetSubView(IslandOpView):ShowOrHideMoveBtn(arg1_80, arg2_80)
end

function var0_0.DisableInput(arg0_81)
	arg0_81.player:StopMoveHandle()
	arg0_81:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_82)
	arg0_82:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnUpdateCustomOpPositon(arg0_83)
	arg0_83:GetSubView(IslandOpView):InitOpCustumPositon()
end

function var0_0.OnChange_Photo_Height(arg0_84, arg1_84, arg2_84)
	arg0_84.takePhotoModel = arg1_84

	if arg0_84.takePhotoModel == IslandConst.TakePhotoModel.First then
		-- block empty
	elseif arg0_84.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_84.thirdTakePhotoItem:ChangeHeight(arg2_84)
	end
end

function var0_0.OnChangeTakePhotoModel(arg0_85, arg1_85)
	arg0_85.takePhotoModel = arg1_85

	if arg0_85.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_85.firstTakePhotoItem:Enable()

		arg0_85.firstTakePhotoItem._tf.position = arg0_85.player._tf.position
		arg0_85.firstTakePhotoItem._tf.rotation = arg0_85.player._tf.rotation

		arg0_85.firstTakePhotoItem:SetTargetRotation(arg0_85.player._tf.rotation)
		arg0_85.player:SetActiveByLayer(false)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook)):SetPosAndRotationByTargetDir(arg0_85.player._tf.forward)
	elseif arg0_85.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_85.thirdTakePhotoItem:Enable()

		arg0_85.player._tf.position = arg0_85.firstTakePhotoItem._tf.position
		arg0_85.player._tf.rotation = arg0_85.firstTakePhotoItem._tf.rotation

		arg0_85.player:SetTargetRotation(arg0_85.firstTakePhotoItem._tf.rotation)
		arg0_85.player:SetActiveByLayer(true)

		arg0_85.thirdTakePhotoItem._tf.position = arg0_85.firstTakePhotoItem._tf:TransformPoint(Vector3(0, 0, -5))
		arg0_85.thirdTakePhotoItem._tf.rotation = arg0_85.firstTakePhotoItem._tf.rotation

		arg0_85.thirdTakePhotoItem:SetTargetRotation(arg0_85.firstTakePhotoItem._tf.rotation)

		local var0_85 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook))
		local var1_85 = arg0_85.player._tf.position + Vector3(0, 0.5, 0)
		local var2_85 = arg0_85.thirdTakePhotoItem._tf.position + Vector3(0, 1, 0)

		var0_85:SetPosAndRotationByTargetDir((var1_85 - var2_85).normalized)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	else
		arg0_85.firstTakePhotoItem:Disable()
		arg0_85.thirdTakePhotoItem:Disable()

		arg0_85.player._tf.position = arg0_85.firstTakePhotoItem._tf.position
		arg0_85.player._tf.rotation = arg0_85.firstTakePhotoItem._tf.rotation

		arg0_85.player:SetTargetRotation(arg0_85.firstTakePhotoItem._tf.rotation)
		arg0_85.player:SetActiveByLayer(true)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraLook)):ResetCameraPos()
	end

	arg0_85:GetSubView(IslandOpView):ChangeTakePhotoModel(arg1_85)
end

function var0_0.OnNpcDetectorSelected(arg0_86, arg1_86)
	if arg0_86.selectedNpcId then
		return
	end

	local var0_86 = arg1_86.node

	if not var0_86 then
		return
	end

	local var1_86 = var0_86:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_86.selectedNpcId = var1_86

	arg0_86:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_86, true)
	arg0_86:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_86, true)
end

function var0_0.GetSelectedNpcId(arg0_87)
	return arg0_87.selectedNpcId
end

function var0_0.OnNpcDetectorUnSelected(arg0_88, arg1_88)
	local var0_88 = arg1_88.node

	if not var0_88 then
		return
	end

	local var1_88 = var0_88:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_88:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_88)
	arg0_88:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_88)

	if arg0_88.selectedNpcId ~= var1_88 then
		return
	end

	arg0_88.selectedNpcId = nil
end

function var0_0.OnDetectorChanged(arg0_89, arg1_89)
	local var0_89 = arg1_89.node

	if not var0_89 then
		return
	end

	local var1_89 = var0_89:GetBlackboardVariable("DetectorList")

	for iter0_89 = 1, var1_89.Count do
		local var2_89 = var1_89[iter0_89 - 1]
		local var3_89, var4_89 = IslandCalcUtil.GetTypeAndIdByUniqueId(var2_89)

		if var3_89 == IslandConst.UNIT_LIST_OBJ then
			local var5_89 = arg0_89:GetUnitModuleWithType(var3_89, var4_89)

			if var5_89 then
				arg0_89:Op("NotifiyIsland", ISLAND_EX_EVT.APPROACH_OBJECT, var5_89.id)
			end
		end
	end
end

function var0_0.OnDetectorSelected(arg0_90, arg1_90)
	local var0_90 = arg1_90.node

	if not var0_90 then
		return
	end

	local var1_90 = var0_90:GetBlackboardVariable("AnyOne")

	if not var1_90 or var1_90 == "" then
		arg0_90:OnClearSelectedUnit()
	else
		local var2_90, var3_90 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_90)
		local var4_90 = arg0_90:GetUnitModuleWithType(var2_90, var3_90)

		if var4_90 then
			arg0_90:OnSelectedUnit(var4_90)
		end
	end
end

function var0_0.OnClearSelectedUnit(arg0_91)
	return
end

function var0_0.OnSelectedUnit(arg0_92, arg1_92)
	return
end

function var0_0.OnPlayChatBubble(arg0_93, arg1_93)
	local var0_93 = arg0_93:GetAllUnits()

	arg0_93:GetSubView(IslandTopHeadHudView):PlayBubble(arg1_93.name, var0_93, arg1_93.callback)
end

function var0_0.OnRawPlayChatBubble(arg0_94, arg1_94)
	local var0_94 = arg0_94:GetAllUnits()

	arg0_94:GetSubView(IslandTopHeadHudView):RawPlayBubble(arg1_94.info, var0_94, arg1_94.callback)
end

function var0_0.OnRawStopChatBubble(arg0_95, arg1_95)
	arg0_95:GetSubView(IslandTopHeadHudView):RawStopBubble(arg1_95.info)
end

function var0_0.OnChangeVisterDress(arg0_96, arg1_96)
	local var0_96 = arg1_96.id

	if arg0_96:IsPlayer(var0_96) then
		return
	end

	local var1_96 = arg0_96:GetPlayerUnitModule(var0_96)

	if var1_96 then
		var1_96:OnChangeDress(arg1_96.changeDressData)
	end
end

function var0_0.OnSystemUnlock(arg0_97, arg1_97)
	if arg1_97 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_97:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.OnSceneInited(arg0_98, arg1_98)
	IslandCameraMgr.instance:LookAt(arg0_98.player._tf)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraZoom)):SetMaxMinZoom(arg1_98.min, arg1_98.max, arg1_98.value)
	arg0_98:InitFocusCamera()
	arg0_98:InitTakePhotoCamera()
	arg0_98:GetSubView(IslandOpView):LaterInit()
end

function var0_0.OnGenUnit(arg0_99, arg1_99, arg2_99)
	local var0_99 = arg0_99.unitBuilders[arg1_99:GetType()]:Build(arg1_99, arg2_99)

	arg0_99:AddUnit(var0_99)

	if arg1_99:IsPlayer() then
		arg0_99.player = var0_99
	end

	if arg1_99:IsFirstTakePhoto() then
		arg0_99.firstTakePhotoItem = var0_99
	end

	if arg1_99:IsThirdTakePhoto() then
		arg0_99.thirdTakePhotoItem = var0_99
	end
end

function var0_0.OnGenSystem(arg0_100, arg1_100)
	local var0_100 = arg0_100.systemBuilders[arg1_100:GetType()]:Build(arg1_100)

	arg0_100:AddUnit(var0_100)
end

function var0_0.IsPlayer(arg0_101, arg1_101)
	return arg0_101.player.id == arg1_101
end

function var0_0.OnActiveOrDisactiveUnit(arg0_102, arg1_102, arg2_102, arg3_102)
	local var0_102

	if arg1_102 == 0 then
		var0_102 = arg0_102.player
	else
		var0_102 = arg0_102:GetUnitModuleWithType(arg2_102, arg1_102)
	end

	if var0_102 and arg3_102 then
		var0_102:Enable()
	end

	if var0_102 and not arg3_102 then
		var0_102:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_103, arg1_103, arg2_103, arg3_103)
	local var0_103 = arg0_103:GetUnitModuleWithType(arg2_103, arg1_103)

	if var0_103 then
		var0_103._go.transform.position = arg3_103
	end
end

function var0_0.OnResetUnitRotation(arg0_104, arg1_104, arg2_104, arg3_104)
	local var0_104 = arg0_104:GetUnitModuleWithType(arg2_104, arg1_104)

	if var0_104 then
		var0_104._go.transform.eulerAngles = arg3_104
	end
end

function var0_0.OnMoveUnit(arg0_105, arg1_105)
	assert(arg1_105.type, "type should be exist")

	local var0_105 = arg0_105:GetUnitModuleWithType(arg1_105.type, arg1_105.id)

	if var0_105 then
		var0_105:SetDestination(arg1_105.position, arg1_105.speed, nil, arg1_105.charaRadius)
	end
end

function var0_0.OnStopUnit(arg0_106, arg1_106)
	assert(arg1_106.type, "type should be exist")

	local var0_106 = arg0_106:GetUnitModuleWithType(arg1_106.type, arg1_106.id)

	if var0_106 then
		var0_106:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_107, arg1_107, arg2_107)
	local var0_107 = arg0_107:GetUnitListByKey(arg1_107)
	local var1_107 = 0

	for iter0_107, iter1_107 in ipairs(var0_107 or {}) do
		if iter1_107.id == arg2_107 then
			var1_107 = iter0_107

			break
		end
	end

	if var1_107 > 0 then
		local var2_107 = var0_107[var1_107]

		for iter2_107 = #arg0_107.pathfinders, 1, -1 do
			local var3_107 = arg0_107.pathfinders[iter2_107]

			if var3_107:IsSameUnit(var2_107) then
				var3_107:Dispose()
				table.remove(arg0_107.pathfinders, iter2_107)
			end
		end

		arg0_107:RemoveUnit(var2_107)
		var2_107:Dispose()
		arg0_107:OnHideUnitHudAndOpBtn({
			type = arg1_107,
			id = var2_107.id
		}, true)
		arg0_107:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_107,
			id = arg2_107
		})
		arg0_107:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var2_107)
		arg0_107:GetSubView(IslandInteractionView):CloseInterActionPanelByUnitIdRemove(arg2_107)
	end
end

function var0_0.GetAllUnits(arg0_108)
	table.clear(arg0_108._unitList)

	for iter0_108, iter1_108 in pairs(arg0_108:GetUnitListRegitser()) do
		for iter2_108, iter3_108 in pairs(iter1_108) do
			table.insert(arg0_108._unitList, iter3_108)
		end
	end

	return arg0_108._unitList
end

function var0_0.GetUnitModuleWithType(arg0_109, arg1_109, arg2_109)
	if arg1_109 == IslandConst.UNIT_LIST_PLAYER and arg2_109 == 0 then
		return arg0_109.player
	end

	local var0_109 = arg0_109:GetUnitListByKey(arg1_109)

	for iter0_109, iter1_109 in ipairs(var0_109) do
		if iter1_109.id == arg2_109 then
			return iter1_109
		end
	end

	return nil
end

function var0_0.GetPlayerUnitModule(arg0_110, arg1_110)
	return arg0_110:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_110)
end

function var0_0.GetUnitModule(arg0_111, arg1_111)
	return arg0_111:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_111)
end

function var0_0.GetSystemModule(arg0_112, arg1_112)
	return arg0_112:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_112)
end

function var0_0.GetProductSystemModule(arg0_113, arg1_113)
	return arg0_113:GetUnitModuleWithType(IslandConst.UNIT_LIST_PRODUCT_SYSTEM, arg1_113)
end

function var0_0.GetSystemUnitModule(arg0_114, arg1_114)
	return arg0_114:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_114)
end

function var0_0.GetStrollUnitModule(arg0_115, arg1_115)
	return arg0_115:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_115)
end

function var0_0.GetManageSystemModule(arg0_116, arg1_116)
	return arg0_116:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_116)
end

function var0_0.GetFollowerModule(arg0_117, arg1_117)
	return arg0_117:GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg1_117)
end

function var0_0.OnMovePlayerBefore(arg0_118)
	if arg0_118.player:CheckMovement() and arg0_118.isLockPlayInput then
		arg0_118.isLockPlayInput = false
	end

	arg0_118:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnLockPlayerInput(arg0_119)
	if arg0_119.playerInputing then
		arg0_119.isLockPlayInput = true

		arg0_119.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerMove(arg0_120, arg1_120)
	if arg0_120.isLockPlayInput then
		return
	end

	arg0_120.playerInputing = true

	if arg0_120.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_120.firstTakePhotoItem:MoveHandle(arg1_120.targetDir, arg1_120.force)
	elseif arg0_120.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_120.thirdTakePhotoItem:MoveHandle(arg1_120.targetDir, arg1_120.force)
	else
		arg0_120.player:MoveHandle(arg1_120.targetDir, arg1_120.force)
	end
end

function var0_0.OnPlayerStopMove(arg0_121)
	if arg0_121.isLockPlayInput then
		arg0_121.isLockPlayInput = false
	end

	arg0_121.playerInputing = true

	if arg0_121.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_121.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_121.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_121.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_121.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerStopMoveHandle(arg0_122)
	if arg0_122.isLockPlayInput then
		arg0_122.isLockPlayInput = false
	end

	arg0_122.playerInputing = true

	if arg0_122.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_122.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_122.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_122.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_122.player:StopMoveHandleByInput()
	end
end

function var0_0.OnPlayerJump(arg0_123)
	if arg0_123.takePhotoModel == IslandConst.TakePhotoModel.First or arg0_123.takePhotoModel == IslandConst.TakePhotoModel.Third then
		return
	end

	arg0_123.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_124)
	arg0_124.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_125)
	if arg0_125.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_125.firstTakePhotoItem:OnPlayerPlayerSprint()
	elseif arg0_125.takePhotoModel == IslandConst.TakePhotoModel.Third then
		-- block empty
	else
		arg0_125.player:OnPlayerPlayerSprint()
	end
end

function var0_0.OnStopPlayerSprint(arg0_126)
	if arg0_126.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_126.firstTakePhotoItem:OnStopPlayerSprint()
	elseif arg0_126.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_126.thirdTakePhotoItem:OnStopPlayerSprint()
	else
		arg0_126.player:OnStopPlayerSprint()
	end
end

function var0_0.OnPlayerWork(arg0_127, arg1_127, arg2_127)
	arg0_127.player:WorkHandle(arg1_127, arg2_127)
end

function var0_0.OnPlayerDeviceStateChange(arg0_128, arg1_128)
	arg0_128.player:DeviceStateHandle(arg1_128)
end

function var0_0.OnSetVisitorSyncData(arg0_129, arg1_129, arg2_129)
	local var0_129 = arg0_129:GetPlayerUnitModule(arg1_129)

	if var0_129 then
		var0_129:UpdateSyncData(arg2_129)
	end
end

function var0_0.OnWorldObjectStartInteraction(arg0_130, arg1_130, arg2_130, arg3_130)
	local var0_130 = arg2_130:GetHostId()
	local var1_130 = arg2_130:GetUserId()
	local var2_130 = arg0_130:GetUnitModule(var0_130)
	local var3_130 = arg0_130:GetPlayerUnitModule(var1_130)
	local var4_130 = arg0_130.player == var3_130

	if var4_130 then
		arg0_130:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_130 = arg1_130:GetTimeline()[arg3_130]
	local var6_130 = arg1_130:GetBlackboardParam()[arg3_130]

	var2_130:StartInteract(var3_130, arg2_130.id, arg3_130, var5_130, var6_130, arg1_130:AnySlotUsing(), var4_130)
end

function var0_0.OnWorldObjectEndInteraction(arg0_131, arg1_131, arg2_131)
	local var0_131 = arg2_131:GetHostId()
	local var1_131 = arg2_131:GetUserId()
	local var2_131 = arg0_131:GetUnitModule(var0_131)
	local var3_131 = arg0_131:GetPlayerUnitModule(var1_131)
	local var4_131 = arg0_131.player == var3_131

	if var4_131 then
		arg0_131:GetSubView(IslandOpView):EndInteraction()
	end

	var2_131:EndInteract(var3_131, arg2_131.id, not arg1_131:AnySlotUsing(), var4_131)
end

function var0_0.OnWorldObjectInitStatus(arg0_132, arg1_132, arg2_132)
	local var0_132 = arg0_132:GetUnitModule(arg1_132.id)
	local var1_132 = arg1_132:GetTimeline()[arg2_132]
	local var2_132 = arg1_132:GetBlackboardParam()[arg2_132]

	var0_132:InitStatus(arg2_132, var1_132, var2_132)
end

function var0_0.InitInteractionOpView(arg0_133)
	arg0_133:GetSubView(IslandOpView):EndInteraction()
end

function var0_0.OnPlayerAreaChange(arg0_134)
	arg0_134.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_135, arg1_135, arg2_135)
	arg0_135.player:OnChangeDress(arg1_135, arg2_135)
end

function var0_0.OnCharacterChangeDress(arg0_136, arg1_136, arg2_136, arg3_136, arg4_136)
	local var0_136 = arg0_136:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_136)

	if var0_136 then
		var0_136:OnCharacterChangeDress(arg2_136, arg3_136, arg4_136)
	end

	local var1_136 = arg0_136:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_136, iter1_136 in ipairs(var1_136) do
		if iter1_136:GetDataVO():IsSameShip(arg1_136) then
			iter1_136:OnCharacterChangeDress(arg2_136, arg3_136, arg4_136)
		end
	end

	local var2_136 = arg0_136:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter2_136, iter3_136 in ipairs(var2_136) do
		if iter3_136:GetDataVO():IsSameShip(arg1_136) then
			iter3_136:OnCharacterChangeDress(arg2_136, arg3_136, arg4_136)
		end
	end
end

function var0_0.OnStartDelegation(arg0_137, arg1_137, arg2_137)
	local var0_137 = arg0_137:GetSystemModule(arg1_137.build_id)

	if var0_137 then
		var0_137:StartDelegation(arg1_137)
	end

	local var1_137 = arg0_137:GetProductSystemModule(arg1_137.build_id)

	if var1_137 then
		var1_137:StartDelegation(arg2_137)
	end
end

function var0_0.OnEndDelegation(arg0_138, arg1_138, arg2_138)
	local var0_138 = arg0_138:GetSystemModule(arg1_138.build_id)

	if var0_138 then
		var0_138:EndDelegation(arg1_138)
	end
end

function var0_0.GetPlayerPosition(arg0_139)
	return arg0_139.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_140, arg1_140)
	local var0_140 = arg0_140:GetUnitModule(arg1_140)

	return var0_140 and var0_140._go.transform.position
end

function var0_0.OnShowUnitHudAndOpBtn(arg0_141, arg1_141)
	arg0_141.currentHudUnitData = arg1_141

	arg0_141:GetSubView(IslandSlotHudView):ShowHud(arg1_141.id, arg1_141.height)
	arg0_141:GetSubView(IslandOpView):UpdateOperationButton(arg1_141.operationType, arg1_141.id)

	if arg1_141.isHighLightControl then
		arg0_141.detectionSystem:HighLightUnitHandle(arg1_141.id, true)
	end
end

function var0_0.OnHideUnitHudAndOpBtn(arg0_142, arg1_142, arg2_142)
	if not arg0_142.currentHudUnitData then
		return
	end

	if arg0_142.currentHudUnitData.id ~= arg1_142.id or arg0_142.currentHudUnitData.type ~= arg1_142.type then
		return
	end

	if not arg2_142 then
		arg0_142.currentHudUnitData = nil
	end

	arg0_142:GetSubView(IslandSlotHudView):HideUnitHud(arg1_142.id)
	arg0_142:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_142.id)

	if arg1_142.isHighLightControl then
		arg0_142.detectionSystem:HighLightUnitHandle(arg1_142.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_143, arg1_143)
	if not arg0_143.currentHudUnitData then
		return
	end

	if arg1_143 ~= arg0_143.currentHudUnitData.id then
		return
	end

	arg0_143:GetSubView(IslandSlotHudView):UpdateHud(arg0_143.currentHudUnitData.id, arg0_143.currentHudUnitData.height)
	arg0_143:GetSubView(IslandOpView):UpdateOperationButton(arg0_143.currentHudUnitData.operationType, arg0_143.currentHudUnitData.id)
end

function var0_0.OnUpdateHandCollectUnit(arg0_144, arg1_144)
	local var0_144 = arg0_144:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_144)

	if var0_144 then
		var0_144:UpdateHandCollet()
		var0_144:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_145, arg1_145)
	arg0_145:GetSubView(IslandTopHeadHudView):ShowHud(arg1_145)
	arg0_145:GetSubView(IslandDistanceView):ShowHud(arg1_145.id)
end

function var0_0.OnRefreshHud(arg0_146, arg1_146)
	arg0_146:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_146)
end

function var0_0.OnHideHud(arg0_147, arg1_147)
	arg0_147:GetSubView(IslandTopHeadHudView):HideHud(arg1_147)
	arg0_147:GetSubView(IslandDistanceView):HideHud(arg1_147.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_148, arg1_148)
	local var0_148 = arg0_148:GetUnitModuleWithType(arg1_148.type, arg1_148.id)

	if var0_148 then
		var0_148:DelegateSlotStartPerform()
	end
end

function var0_0.OnRecycleAllSlotEffct(arg0_149)
	arg0_149.effectMgr:RecycleAllSlotEffct()
end

function var0_0.OnLoadDelegatePreviewRole(arg0_150, arg1_150, arg2_150)
	arg0_150.effectMgr:LoadDelegatePreviewRole(arg1_150, arg2_150)
end

function var0_0.OnUnLoadDelegatePreviewRole(arg0_151)
	arg0_151.effectMgr:UnLoadDelegatePreviewRole()
end

function var0_0.OnSelectSlotEffectShow(arg0_152, arg1_152, arg2_152, arg3_152, arg4_152)
	arg0_152.effectMgr:SelectSlotEffectShow(arg1_152, arg2_152, arg3_152, arg4_152)
end

function var0_0.OnTakePlantAttack(arg0_153, arg1_153)
	local var0_153 = arg0_153:GetUnitModuleWithType(arg1_153.type, arg1_153.id)

	if var0_153 then
		var0_153:TakeAttack()
	end
end

function var0_0.OnStartManage(arg0_154, arg1_154)
	local var0_154 = arg0_154:GetManageSystemModule(arg1_154.id)

	if var0_154 then
		var0_154:StartManage(arg1_154)
	end
end

function var0_0.OnEndManage(arg0_155, arg1_155)
	local var0_155 = arg0_155:GetManageSystemModule(arg1_155.id)

	if var0_155 then
		var0_155:EndManage(arg1_155)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_156)
	arg0_156:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnRefreshWeatherSystem(arg0_157)
	arg0_157.weatherSystem:Play()
end

function var0_0.OnDispose(arg0_158)
	arg0_158.detectionSystem:Dispose()
	arg0_158.effectMgr:Dispose()
	arg0_158.coupleActionPlayer:Dispose()
	arg0_158.coupleAction4FollowerPlayer:Dispose()
	arg0_158.npcActionPlayer:Dispose()
	arg0_158.weatherSystem:Dispose()
	arg0_158.coupleNpcWordPlayer:Dispose()
	arg0_158:GetPoolMgr():ClearFishingEffect()

	for iter0_158, iter1_158 in ipairs(arg0_158.views) do
		iter1_158:Dispose()
	end

	for iter2_158, iter3_158 in ipairs(arg0_158.pathfinders) do
		iter3_158:Dispose()
	end

	for iter4_158, iter5_158 in ipairs(arg0_158:GetAllUnits()) do
		iter5_158:Dispose()
	end

	for iter6_158, iter7_158 in pairs(arg0_158.unitBuilders) do
		iter7_158:Dispose()
	end

	for iter8_158, iter9_158 in pairs(arg0_158.systemBuilders) do
		iter9_158:Dispose()
	end

	for iter10_158, iter11_158 in pairs(arg0_158.fishingSynPlayers) do
		iter11_158:Dispose()
	end

	arg0_158.fishingSynPlayers = nil
	arg0_158.npcActionPlayer = nil
	arg0_158.coupleActionPlayer = nil
	arg0_158.coupleAction4FollowerPlayer = nil
	arg0_158.pathfinders = nil
	arg0_158.unitBuilders = nil
	arg0_158.systemBuilders = nil
	arg0_158.views = nil
	arg0_158.player = nil
	arg0_158.isInit = false
	arg0_158._unitList = nil
	arg0_158.detectionSystem = nil
	arg0_158.effectMgr = nil
	arg0_158.coupleNpcWordPlayer = nil
end

return var0_0
