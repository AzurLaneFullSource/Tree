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
	arg0_21:AddListener(ISLAND_EVT.WILL_DEL_FOLLOWER, arg0_21.OnFollowerWillDelStep1)
	arg0_21:AddListener(ISLAND_EVT.DO_DEL_FOLLOWER, arg0_21.OnFollowerWillDelStep2)
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
	arg0_21:AddListener(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, arg0_21.OnAllDailyOrWeeklyFinish)
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
	arg0_22:RemoveListener(ISLAND_EVT.WILL_DEL_FOLLOWER, arg0_22.OnFollowerWillDelStep1)
	arg0_22:RemoveListener(ISLAND_EVT.DO_DEL_FOLLOWER, arg0_22.OnFollowerWillDelStep2)
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
	arg0_22:RemoveListener(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, arg0_22.OnAllDailyOrWeeklyFinish)
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

function var0_0.OnAllDailyOrWeeklyFinish(arg0_25, arg1_25)
	local var0_25 = arg0_25:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_25 = {}

	for iter0_25, iter1_25 in ipairs(var0_25) do
		if not iter1_25:IsExitState() then
			table.insert(var1_25, iter1_25)
		end
	end

	if #var1_25 <= 0 then
		return
	end

	for iter2_25, iter3_25 in ipairs(var1_25) do
		iter3_25:StopMove()
		iter3_25:PlayAnimation(arg1_25)
	end
end

function var0_0.OnSystemUnlock(arg0_26, arg1_26)
	if arg1_26 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_26:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.SelectedFishPoint(arg0_27, arg1_27)
	if not arg0_27:GetSelfIsland():GetAblityAgency():IsUnlockFishing() or arg1_27:GetUnitType() ~= IslandConst.UNIT_LIST_FISH_POINT or arg0_27.player:StandOnWorldObject() or not arg0_27.player:OnGrouded() then
		return
	end

	arg0_27:UnSelectedFishPoint()

	arg0_27.selectedFishPointId = arg1_27.id

	arg0_27:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.Fishing, arg1_27.id)
end

function var0_0.UnSelectedFishPoint(arg0_28)
	if arg0_28.selectedFishPointId then
		local var0_28 = arg0_28.selectedFishPointId

		arg0_28.selectedFishPointId = nil

		arg0_28:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, var0_28)
	end
end

function var0_0.OnStartFishing(arg0_29, arg1_29)
	local var0_29 = arg1_29.unitId
	local var1_29 = arg0_29:GetPlayerUnitModule(var0_29)

	if not var1_29 then
		return
	end

	if not isa(var1_29, IslandVisitorUnit) then
		return
	end

	var1_29:Sleep()

	local var2_29 = arg1_29.fishPointId
	local var3_29 = arg1_29.rodId
	local var4_29 = arg1_29.fishId
	local var5_29 = pg.island_fish_rod[var3_29].attachment_id
	local var6_29 = IslandVistorFishingPlayer.New(arg0_29, var1_29, var2_29, var5_29, var4_29)

	var6_29:Play()

	arg0_29.fishingSynPlayers[var0_29] = var6_29
end

function var0_0.OnFishingStateChange(arg0_30, arg1_30)
	local var0_30 = arg1_30.op
	local var1_30 = arg1_30.unitId
	local var2_30 = arg0_30:GetPlayerUnitModule(var1_30)
	local var3_30 = arg0_30.fishingSynPlayers[var1_30]

	if not isa(var2_30, IslandVisitorUnit) then
		return
	end

	if not var3_30 or not var3_30:IsSameFishPoint(arg1_30.fishPointId) then
		return
	end

	local function var4_30()
		var2_30:WakeUp()
		arg0_30.fishingSynPlayers[var1_30]:Dispose()

		arg0_30.fishingSynPlayers[var1_30] = nil
	end

	if var0_30 == IslandConst.FISHING_OP_CANCEL then
		var3_30:OnCancel(var4_30)
	elseif var0_30 == IslandConst.FISHING_OP_FAILD then
		var3_30:OnFailed(var4_30)
	elseif var0_30 == IslandConst.FISHING_OP_SUCCESS then
		var3_30:OnSuccess(var4_30)
	end
end

function var0_0.OnStartCoupleAction(arg0_32)
	arg0_32:UnBlockLayer1Event(false)
	arg0_32:GetSubView(IslandAniamtionOpView):OnStartCoupleAction()
end

function var0_0.OnEndCoupleAction(arg0_33)
	arg0_33:UnBlockLayer1Event(true)
	arg0_33:GetSubView(IslandAniamtionOpView):OnEndCoupleAction()
end

function var0_0.OnCancelCoupleAction(arg0_34)
	if arg0_34.coupleActionPlayer and arg0_34.coupleActionPlayer:IsPlaying() then
		arg0_34.coupleActionPlayer:Stop()
	end

	if arg0_34.coupleAction4FollowerPlayer and arg0_34.coupleAction4FollowerPlayer:IsPlaying() then
		arg0_34.coupleAction4FollowerPlayer:Stop()
	end

	arg0_34:OnEndCoupleAction()
end

function var0_0.OnCoupleActionWithFollower(arg0_35, arg1_35)
	local var0_35 = arg0_35:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_35 = arg0_35:GetPlayerPosition()
	local var2_35 = pg.island_set.action_bubble_range.key_value_int
	local var3_35 = _.select(var0_35, function(arg0_36)
		return not arg0_36:IsExitState() and Vector3.Distance(arg0_36:GetPosition(), var1_35) <= var2_35
	end)

	if #var3_35 <= 0 then
		return
	end

	local var4_35 = var3_35[math.random(1, #var3_35)]
	local var5_35 = pg.island_action[arg1_35]

	arg0_35.coupleAction4FollowerPlayer:Play(var4_35, arg0_35.player, var5_35)
	arg0_35:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
end

function var0_0.OnFollowerAdd(arg0_37, arg1_37)
	if arg0_37:GetSelectedNpcId() then
		local var0_37, var1_37 = IslandCalcUtil.GetTypeAndIdByUniqueId(arg0_37:GetSelectedNpcId())

		if var1_37 == arg1_37 then
			arg0_37.selectedNpcId = nil
		end
	end

	arg0_37:GetSubView(IslandOpView):FlushFollowerList()
	arg0_37.coupleNpcWordPlayer:Play(arg1_37)
end

function var0_0.OnFollowerWillDelStep1(arg0_38, arg1_38)
	local var0_38 = arg0_38:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_38

	for iter0_38, iter1_38 in ipairs(var0_38) do
		if iter1_38:GetDataVO():IsSameShip(arg1_38) then
			var1_38 = iter1_38

			break
		end
	end

	if not var1_38 or var1_38:IsExitState() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_follower_exiting_tip"))

		return
	end

	var1_38:DoExitHandle()
end

function var0_0.OnFollowerWillDelStep2(arg0_39, arg1_39)
	local var0_39 = arg1_39.node

	if not var0_39 then
		return
	end

	local var1_39 = var0_39:GetComponent(typeof(WorldObjectItem)).uniqueId
	local var2_39, var3_39 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_39)
	local var4_39 = arg0_39:GetUnitModuleWithType(var2_39, var3_39)

	if not var4_39 then
		return
	end

	arg0_39:NotifiyMeditor(IslandMediator.DEL_FOLLOWER, var4_39:GetDataVO():GetShipId())
end

function var0_0.OnFollowerDel(arg0_40, arg1_40)
	arg0_40:GetSubView(IslandOpView):FlushFollowerList()
	arg0_40.coupleNpcWordPlayer:Stop(arg1_40)
end

function var0_0.OnResetFollowRandomizer(arg0_41, arg1_41)
	local var0_41 = arg0_41:GetFollowerModule(arg1_41)

	if not var0_41 then
		return
	end

	var0_41:SetBtRandomizer()
end

function var0_0.OnShowChatMsg(arg0_42, arg1_42)
	local var0_42 = arg1_42.player.id
	local var1_42 = arg0_42:GetPlayerUnitModule(var0_42)

	if not var1_42 then
		return
	end

	arg0_42:GetSubView(IslandTopHeadHudView):PlayChat(var1_42, arg1_42.emojiId, arg1_42.content, nil)
end

function var0_0.OnChatRoomChange(arg0_43)
	arg0_43:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_44)
	arg0_44:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnPlaySingleAnimationEnd(arg0_45, arg1_45)
	if not arg0_45:GetSelectedNpcId() then
		arg0_45.npcActionPlayer:ResoponByRandom(arg0_45.player, arg1_45)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(1, arg1_45, 0, 0, 0, 0))

		return
	end

	local var0_45 = arg0_45:GetSelectedNpcId()
	local var1_45, var2_45 = IslandCalcUtil.GetTypeAndIdByUniqueId(var0_45)
	local var3_45 = arg0_45:GetUnitModuleWithType(var1_45, var2_45)

	if isa(var3_45, IslandStrollNpcUnit) and var3_45:GetDataVO():ExistActionFeedback() then
		arg0_45.npcActionPlayer:Resopon(var3_45, arg0_45.player, arg1_45)
	else
		arg0_45.npcActionPlayer:ResoponByRandom(arg0_45.player, arg1_45)
	end
end

function var0_0.OnShowNpcAniamtionBubble(arg0_46, arg1_46)
	local var0_46 = arg0_46:GetStrollUnitModule(arg1_46.id)

	if not var0_46 then
		return
	end

	local var1_46 = arg1_46:GetActionFeedback()

	arg0_46:GetSubView(IslandBottomHeadHudView):ShowAnimationOp(var0_46, var1_46)
end

function var0_0.OnHideNpcAniamtionBubble(arg0_47, arg1_47)
	local var0_47 = arg0_47:GetStrollUnitModule(arg1_47.id)

	arg0_47:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var0_47)
end

function var0_0.OnStartDoCoupleAction(arg0_48)
	arg0_48:GetSubView(IslandCancelAnimationOpView):ShowCancelableAnimationOp(arg0_48.player)
end

function var0_0.OnEndDoCoupleAction(arg0_49)
	arg0_49:GetSubView(IslandCancelAnimationOpView):HideCancelableAnimationOp(arg0_49.player)
end

function var0_0.OnResponAniamtionOp(arg0_50, arg1_50)
	local var0_50 = arg1_50.id
	local var1_50 = arg1_50.targetId
	local var2_50 = arg1_50.actionId
	local var3_50 = arg0_50:GetPlayerUnitModule(var0_50)

	if not var3_50 then
		return
	end

	if var2_50 == 0 then
		if not arg0_50:IsPlayer(var0_50) then
			arg0_50:GetSubView(IslandTopHeadHudView):HideAnimationOp(var3_50)
		else
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_50, 1, 0, 0, 0))
		end

		return
	end

	local var4_50 = pg.island_action[var2_50]

	if var1_50 == 0 and var4_50.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_50:IsPlayer(var0_50) then
		arg0_50:GetSubView(IslandTopHeadHudView):ShowAnimationOp(var3_50, var2_50)
	elseif var1_50 > 0 and var4_50.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_50:IsPlayer(var1_50) then
		local var5_50 = arg0_50:GetPlayerUnitModule(var1_50)

		arg0_50.coupleActionPlayer:Play(var3_50, var5_50, var4_50)
		arg0_50:GetSubView(IslandTopHeadHudView):HideAnimationOp(var5_50)
	elseif var1_50 > 0 and var4_50.type == IslandConst.ANIMATION_OP_DOUBLE and arg0_50:IsPlayer(var1_50) then
		local var6_50 = arg0_50:GetPlayerUnitModule(var1_50)

		arg0_50.coupleActionPlayer:Play(var3_50, var6_50, var4_50)
		arg0_50:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_50, 1, var1_50, 0, 1))
	end
end

function var0_0.OnShowChatMsg(arg0_51, arg1_51)
	local var0_51 = arg1_51.player.id
	local var1_51 = arg0_51:GetPlayerUnitModule(var0_51)

	if not var1_51 then
		return
	end

	arg0_51:GetSubView(IslandTopHeadHudView):PlayChat(var1_51, arg1_51.emojiId, arg1_51.content, nil)
end

function var0_0.OnChatRoomChange(arg0_52)
	arg0_52:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_53)
	arg0_53:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnFollowerAdd(arg0_54, arg1_54)
	arg0_54:GetSubView(IslandOpView):FlushFollowerList()
	arg0_54.coupleNpcWordPlayer:Play(arg1_54)
end

function var0_0.OnFollowerDel(arg0_55, arg1_55)
	arg0_55:GetSubView(IslandOpView):FlushFollowerList()
	arg0_55.coupleNpcWordPlayer:Stop(arg1_55)
end

function var0_0.OnResetFollowRandomizer(arg0_56, arg1_56)
	local var0_56 = arg0_56:GetFollowerModule(arg1_56)

	if not var0_56 then
		return
	end

	var0_56:SetBtRandomizer()
end

function var0_0.OnGenPathFinder(arg0_57, arg1_57)
	local var0_57 = IslandPathFinder.New(arg0_57)
	local var1_57 = defaultValue(arg1_57.navData.waitUntilDone, false)

	var0_57:Start(arg1_57.navData, function()
		table.removebyvalue(arg0_57.pathfinders, var0_57)
		var0_57:Dispose()

		if arg1_57.onEndAction then
			arg1_57.onEndAction()
		end

		arg0_57:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH_DONE, arg1_57.navData.index)

		if var1_57 and arg1_57.callback then
			arg1_57.callback()
		end
	end)
	arg0_57:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH, arg1_57.navData.index)

	if not var1_57 and arg1_57.callback then
		arg1_57.callback()
	end

	table.insert(arg0_57.pathfinders, var0_57)
end

function var0_0.OnRemovePathFinder(arg0_59, arg1_59)
	local var0_59 = arg0_59:GetUnitModuleWithType(arg1_59.unitType, arg1_59.unitId)
	local var1_59 = _.detect(arg0_59.pathfinders, function(arg0_60)
		return arg0_60:IsSameUnit(var0_59)
	end)

	if not var1_59 then
		return
	end

	var1_59:Stop()
	var1_59:Dispose()
	table.removebyvalue(arg0_59.pathfinders, var1_59)
end

function var0_0.OnTracking(arg0_61, arg1_61)
	local var0_61 = arg1_61.trackType

	if var0_61 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_61.mainTrackId = tonumber(arg1_61.id)
		arg0_61.needTryMainTrack = true
	elseif var0_61 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_61.trackId = tonumber(arg1_61.id)
		arg0_61.trackType = arg1_61.typ or IslandTaskType.MAIN
		arg0_61.needTryTrack = true
	end
end

function var0_0.TryTrack(arg0_62)
	arg0_62:TrySetTrack(arg0_62.trackId)
end

function var0_0.TrySetTrack(arg0_63, arg1_63)
	local var0_63 = arg0_63:GetOptTrackingTarget(arg1_63)

	if not var0_63 or not var0_63._go then
		return
	end

	arg0_63:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_63.player, var0_63, arg1_63, arg0_63.trackType, IslandTaskTrackCard.TYPES.OTHER)

	arg0_63.needTryTrack = false
end

function var0_0.TryMainTrack(arg0_64)
	arg0_64:TrySetMainTrack(arg0_64.mainTrackId)
end

function var0_0.TrySetMainTrack(arg0_65, arg1_65)
	local var0_65 = arg0_65:GetOptTrackingTarget(arg1_65)

	if not var0_65 or not var0_65._go then
		return
	end

	arg0_65:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_65.player, var0_65, arg1_65, IslandTaskType.MAIN, IslandTaskTrackCard.TYPES.MAIN)

	arg0_65.needTryMainTrack = false
end

function var0_0.OnUnTracking(arg0_66, arg1_66)
	if arg1_66 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_66.mainTrackId = nil
	elseif arg1_66 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_66.trackId = nil
	end

	arg0_66:GetSubView(IslandDistanceView):CancelTracking(arg1_66)
end

local function var1_0(arg0_67, arg1_67)
	local var0_67 = pg.island_world_objects[arg0_67]

	if not var0_67 then
		return
	end

	return var0_67.mapId == arg1_67
end

local function var2_0(arg0_68, arg1_68, arg2_68)
	for iter0_68, iter1_68 in ipairs(arg0_68) do
		for iter2_68, iter3_68 in ipairs(iter1_68[2]) do
			local var0_68 = pg.island_interaction[iter3_68]

			if var0_68.type == arg2_68 and var1_0(tonumber(var0_68.param), arg1_68) then
				return iter1_68[1]
			end
		end
	end

	return nil
end

local function var3_0(arg0_69)
	local var0_69 = {}
	local var1_69 = {}

	for iter0_69, iter1_69 in ipairs(arg0_69) do
		for iter2_69, iter3_69 in ipairs(iter1_69[2]) do
			local var2_69 = pg.island_interaction[iter3_69]

			if var2_69.type == IslandInteractionUntil.TYPE_TRANSFER then
				table.insert(var0_69, iter1_69[1])
			elseif var2_69.type == IslandInteractionUntil.TYPE_SP_TRANSFER then
				table.insert(var1_69, iter1_69[1])
			end
		end
	end

	if #var1_69 > 0 then
		return var1_69[1]
	end

	if #var0_69 > 0 then
		return var0_69[1]
	end

	return nil
end

function var0_0.GetOptTrackingTarget(arg0_70, arg1_70)
	local var0_70 = arg0_70:GetUnitModule(arg1_70)

	if var0_70 then
		return var0_70
	end

	local var1_70 = pg.island_world_objects[arg1_70]

	if not var1_70 then
		return nil
	end

	local var2_70 = {}

	for iter0_70, iter1_70 in ipairs(arg0_70:GetUnitListByKey(IslandConst.UNIT_LIST_OBJ)) do
		local var3_70, var4_70 = iter1_70:IsMapTransfer()

		if var3_70 then
			table.insert(var2_70, {
				iter1_70,
				var4_70
			})
		end
	end

	local var5_70
	local var6_70 = var2_0(var2_70, var1_70.mapId, IslandInteractionUntil.TYPE_TRANSFER) or var2_0(var2_70, var1_70.mapId, IslandInteractionUntil.TYPE_SP_TRANSFER)

	var6_70 = var6_70 or var3_0(var2_70)

	return var6_70
end

function var0_0.OnOpenAniamtionOpPage(arg0_71)
	arg0_71:GetSubView(IslandAniamtionOpView):TryEnable()
	arg0_71:GetSubView(IslandOpView):TryDisable()
	arg0_71:NotifiyIsland(ISLAND_EX_EVT.OPEN_ANIMATION_OP)
end

function var0_0.OnCloseAniamtionOpPage(arg0_72)
	arg0_72:GetSubView(IslandOpView):TryEnable()
	arg0_72:NotifiyIsland(ISLAND_EX_EVT.CLOSE_ANIMATION_OP)
end

function var0_0.OnAnyPageOpen(arg0_73, arg1_73)
	arg0_73.anyPageOpen = true

	arg0_73.player:StopMoveHandle()
	arg0_73:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_73:GetSubView(IslandSlotHudView):TryDisable()
	arg0_73:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_73:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_73:GetSubView(IslandAniamtionOpView):CloseAndReset()
end

function var0_0.OnAllPageClose(arg0_74)
	arg0_74.anyPageOpen = false

	arg0_74:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_74:GetSubView(IslandSlotHudView):TryEnable()
	arg0_74:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_74:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnStartStory(arg0_75)
	arg0_75.playingStory = true

	arg0_75:DisablePlayerOp()
end

function var0_0.OnEndStory(arg0_76)
	arg0_76.playingStory = false

	arg0_76:EnablePlayerOp()
end

function var0_0.OnStartPerformance(arg0_77)
	return
end

function var0_0.OnEndPerformance(arg0_78)
	if not arg0_78.anyPageOpen then
		arg0_78:GetSubView(IslandOpView):ResetShowBalance()
	end
end

function var0_0.OnStartGuide(arg0_79)
	arg0_79.player:StopMoveHandle()
	arg0_79:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_80)
	if arg0_80.playingStory then
		return
	end

	arg0_80:GetSubView(IslandOpView):EnableInput()
end

function var0_0.InitFocusCamera(arg0_81)
	local var0_81 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)

	var0_81.Follow = arg0_81.player._tf
	var0_81.LookAt = arg0_81.player._tf
end

function var0_0.InitTakePhotoCamera(arg0_82)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).Follow = arg0_82.firstTakePhotoItem._tf

	local var0_82 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)

	var0_82.Follow = arg0_82.thirdTakePhotoItem._tf
	var0_82.LookAt = arg0_82.thirdTakePhotoItem._tf
end

function var0_0.DisablePlayerOp(arg0_83)
	arg0_83.player:StopMoveHandle()
	arg0_83:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_83:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_83:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_83:GetSubView(IslandOpView):TryDisable()
end

function var0_0.EnablePlayerOp(arg0_84)
	arg0_84:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_84:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_84:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_84:GetSubView(IslandOpView):TryEnable()
end

function var0_0.OnInterActionBegin(arg0_85)
	arg0_85.player:StopMoveHandle()
	arg0_85:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_86)
	arg0_86:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_87, arg1_87)
	arg0_87.showInterObjId = arg1_87.id

	arg0_87:GetSubView(IslandInteractionView):ShowInterActionPanel(arg1_87)
	arg0_87:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_87.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_88, arg1_88)
	if arg0_88.showInterObjId ~= arg1_88.id then
		return
	end

	arg0_88.showInterObjId = nil

	arg0_88:GetSubView(IslandInteractionView):HideInterActionPanel()
end

function var0_0.OnRefreshInteractionBtn(arg0_89)
	arg0_89:GetSubView(IslandInteractionView):RefreshInteractionBtns()
end

function var0_0.OnSetOpMoveBtnActve(arg0_90, arg1_90, arg2_90)
	arg0_90:GetSubView(IslandOpView):ShowOrHideMoveBtn(arg1_90, arg2_90)
end

function var0_0.DisableInput(arg0_91)
	arg0_91.player:StopMoveHandle()
	arg0_91:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_92)
	arg0_92:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnUpdateCustomOpPositon(arg0_93)
	arg0_93:GetSubView(IslandOpView):InitOpCustumPositon()
end

function var0_0.OnChange_Photo_Height(arg0_94, arg1_94, arg2_94)
	arg0_94.takePhotoModel = arg1_94

	if arg0_94.takePhotoModel == IslandConst.TakePhotoModel.First then
		-- block empty
	elseif arg0_94.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_94.thirdTakePhotoItem:ChangeHeight(arg2_94)
	end
end

function var0_0.OnChangeTakePhotoModel(arg0_95, arg1_95)
	arg0_95.takePhotoModel = arg1_95

	if arg0_95.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_95.firstTakePhotoItem:Enable()

		arg0_95.firstTakePhotoItem._tf.position = arg0_95.player._tf.position
		arg0_95.firstTakePhotoItem._tf.rotation = arg0_95.player._tf.rotation

		arg0_95.firstTakePhotoItem:SetTargetRotation(arg0_95.player._tf.rotation)
		arg0_95.player:SetActiveByLayer(false)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook)):SetPosAndRotationByTargetDir(arg0_95.player._tf.forward)
	elseif arg0_95.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_95.thirdTakePhotoItem:Enable()

		arg0_95.player._tf.position = arg0_95.firstTakePhotoItem._tf.position
		arg0_95.player._tf.rotation = arg0_95.firstTakePhotoItem._tf.rotation

		arg0_95.player:SetTargetRotation(arg0_95.firstTakePhotoItem._tf.rotation)
		arg0_95.player:SetActiveByLayer(true)

		arg0_95.thirdTakePhotoItem._tf.position = arg0_95.firstTakePhotoItem._tf:TransformPoint(Vector3(0, 0, -5))
		arg0_95.thirdTakePhotoItem._tf.rotation = arg0_95.firstTakePhotoItem._tf.rotation

		arg0_95.thirdTakePhotoItem:SetTargetRotation(arg0_95.firstTakePhotoItem._tf.rotation)

		local var0_95 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook))
		local var1_95 = arg0_95.player._tf.position + Vector3(0, 0.5, 0)
		local var2_95 = arg0_95.thirdTakePhotoItem._tf.position + Vector3(0, 1, 0)

		var0_95:SetPosAndRotationByTargetDir((var1_95 - var2_95).normalized)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	else
		arg0_95.firstTakePhotoItem:Disable()
		arg0_95.thirdTakePhotoItem:Disable()

		arg0_95.player._tf.position = arg0_95.firstTakePhotoItem._tf.position
		arg0_95.player._tf.rotation = arg0_95.firstTakePhotoItem._tf.rotation

		arg0_95.player:SetTargetRotation(arg0_95.firstTakePhotoItem._tf.rotation)
		arg0_95.player:SetActiveByLayer(true)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraLook)):ResetCameraPos()
	end

	arg0_95:GetSubView(IslandOpView):ChangeTakePhotoModel(arg1_95)
end

function var0_0.OnNpcDetectorSelected(arg0_96, arg1_96)
	if arg0_96.selectedNpcId then
		return
	end

	local var0_96 = arg1_96.node

	if not var0_96 then
		return
	end

	local var1_96 = var0_96:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_96.selectedNpcId = var1_96

	arg0_96:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_96, true)
	arg0_96:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_96, true)
end

function var0_0.GetSelectedNpcId(arg0_97)
	return arg0_97.selectedNpcId
end

function var0_0.OnNpcDetectorUnSelected(arg0_98, arg1_98)
	local var0_98 = arg1_98.node

	if not var0_98 then
		return
	end

	local var1_98 = var0_98:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_98:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_98)
	arg0_98:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_98)

	if arg0_98.selectedNpcId ~= var1_98 then
		return
	end

	arg0_98.selectedNpcId = nil
end

function var0_0.OnDetectorChanged(arg0_99, arg1_99)
	local var0_99 = arg1_99.node

	if not var0_99 then
		return
	end

	local var1_99 = var0_99:GetBlackboardVariable("DetectorList")

	for iter0_99 = 1, var1_99.Count do
		local var2_99 = var1_99[iter0_99 - 1]
		local var3_99, var4_99 = IslandCalcUtil.GetTypeAndIdByUniqueId(var2_99)

		if var3_99 == IslandConst.UNIT_LIST_OBJ then
			local var5_99 = arg0_99:GetUnitModuleWithType(var3_99, var4_99)

			if var5_99 then
				arg0_99:Op("NotifiyIsland", ISLAND_EX_EVT.APPROACH_OBJECT, var5_99.id)
			end
		end
	end
end

function var0_0.OnDetectorSelected(arg0_100, arg1_100)
	local var0_100 = arg1_100.node

	if not var0_100 then
		return
	end

	local var1_100 = var0_100:GetBlackboardVariable("AnyOne")

	if not var1_100 or var1_100 == "" then
		arg0_100:OnClearSelectedUnit()
	else
		local var2_100, var3_100 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_100)
		local var4_100 = arg0_100:GetUnitModuleWithType(var2_100, var3_100)

		if var4_100 then
			arg0_100:OnSelectedUnit(var4_100)
		end
	end
end

function var0_0.OnClearSelectedUnit(arg0_101)
	return
end

function var0_0.OnSelectedUnit(arg0_102, arg1_102)
	return
end

function var0_0.OnPlayChatBubble(arg0_103, arg1_103)
	local var0_103 = arg0_103:GetAllUnits()

	arg0_103:GetSubView(IslandTopHeadHudView):PlayBubble(arg1_103.name, var0_103, arg1_103.callback)
end

function var0_0.OnRawPlayChatBubble(arg0_104, arg1_104)
	local var0_104 = arg0_104:GetAllUnits()

	arg0_104:GetSubView(IslandTopHeadHudView):RawPlayBubble(arg1_104.info, var0_104, arg1_104.callback)
end

function var0_0.OnRawStopChatBubble(arg0_105, arg1_105)
	arg0_105:GetSubView(IslandTopHeadHudView):RawStopBubble(arg1_105.info)
end

function var0_0.OnChangeVisterDress(arg0_106, arg1_106)
	local var0_106 = arg1_106.id

	if arg0_106:IsPlayer(var0_106) then
		return
	end

	local var1_106 = arg0_106:GetPlayerUnitModule(var0_106)

	if var1_106 then
		var1_106:OnChangeDress(arg1_106.changeDressData)
	end
end

function var0_0.OnSystemUnlock(arg0_107, arg1_107)
	if arg1_107 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_107:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.OnSceneInited(arg0_108, arg1_108)
	IslandCameraMgr.instance:LookAt(arg0_108.player._tf)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraZoom)):SetMaxMinZoom(arg1_108.min, arg1_108.max, arg1_108.value)
	arg0_108:InitFocusCamera()
	arg0_108:InitTakePhotoCamera()
	arg0_108:GetSubView(IslandOpView):LaterInit()
end

function var0_0.OnGenUnit(arg0_109, arg1_109, arg2_109)
	local var0_109 = arg0_109.unitBuilders[arg1_109:GetType()]:Build(arg1_109, arg2_109)

	arg0_109:AddUnit(var0_109)

	if arg1_109:IsPlayer() then
		arg0_109.player = var0_109
	end

	if arg1_109:IsFirstTakePhoto() then
		arg0_109.firstTakePhotoItem = var0_109
	end

	if arg1_109:IsThirdTakePhoto() then
		arg0_109.thirdTakePhotoItem = var0_109
	end
end

function var0_0.OnGenSystem(arg0_110, arg1_110)
	local var0_110 = arg0_110.systemBuilders[arg1_110:GetType()]:Build(arg1_110)

	arg0_110:AddUnit(var0_110)
end

function var0_0.IsPlayer(arg0_111, arg1_111)
	return arg0_111.player.id == arg1_111
end

function var0_0.OnActiveOrDisactiveUnit(arg0_112, arg1_112, arg2_112, arg3_112)
	local var0_112

	if arg1_112 == 0 then
		var0_112 = arg0_112.player
	else
		var0_112 = arg0_112:GetUnitModuleWithType(arg2_112, arg1_112)
	end

	if var0_112 and arg3_112 then
		var0_112:Enable()
	end

	if var0_112 and not arg3_112 then
		var0_112:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_113, arg1_113, arg2_113, arg3_113)
	local var0_113 = arg0_113:GetUnitModuleWithType(arg2_113, arg1_113)

	if var0_113 then
		var0_113._go.transform.position = arg3_113
	end
end

function var0_0.OnResetUnitRotation(arg0_114, arg1_114, arg2_114, arg3_114)
	local var0_114 = arg0_114:GetUnitModuleWithType(arg2_114, arg1_114)

	if var0_114 then
		var0_114._go.transform.eulerAngles = arg3_114
	end
end

function var0_0.OnMoveUnit(arg0_115, arg1_115)
	assert(arg1_115.type, "type should be exist")

	local var0_115 = arg0_115:GetUnitModuleWithType(arg1_115.type, arg1_115.id)

	if var0_115 then
		var0_115:SetDestination(arg1_115.position, arg1_115.speed, nil, arg1_115.charaRadius)
	end
end

function var0_0.OnStopUnit(arg0_116, arg1_116)
	assert(arg1_116.type, "type should be exist")

	local var0_116 = arg0_116:GetUnitModuleWithType(arg1_116.type, arg1_116.id)

	if var0_116 then
		var0_116:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_117, arg1_117, arg2_117)
	local var0_117 = arg0_117:GetUnitListByKey(arg1_117)
	local var1_117 = 0

	for iter0_117, iter1_117 in ipairs(var0_117 or {}) do
		if iter1_117.id == arg2_117 then
			var1_117 = iter0_117

			break
		end
	end

	if var1_117 > 0 then
		local var2_117 = var0_117[var1_117]

		for iter2_117 = #arg0_117.pathfinders, 1, -1 do
			local var3_117 = arg0_117.pathfinders[iter2_117]

			if var3_117:IsSameUnit(var2_117) then
				var3_117:Dispose()
				table.remove(arg0_117.pathfinders, iter2_117)
			end
		end

		arg0_117:RemoveUnit(var2_117)
		var2_117:Dispose()
		arg0_117:OnHideUnitHudAndOpBtn({
			type = arg1_117,
			id = var2_117.id
		}, true)
		arg0_117:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_117,
			id = arg2_117
		})
		arg0_117:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var2_117)
		arg0_117:GetSubView(IslandInteractionView):CloseInterActionPanelByUnitIdRemove(arg2_117)
	end
end

function var0_0.GetAllUnits(arg0_118)
	table.clear(arg0_118._unitList)

	for iter0_118, iter1_118 in pairs(arg0_118:GetUnitListRegitser()) do
		for iter2_118, iter3_118 in pairs(iter1_118) do
			table.insert(arg0_118._unitList, iter3_118)
		end
	end

	return arg0_118._unitList
end

function var0_0.GetUnitModuleWithType(arg0_119, arg1_119, arg2_119)
	if arg1_119 == IslandConst.UNIT_LIST_PLAYER and arg2_119 == 0 then
		return arg0_119.player
	end

	local var0_119 = arg0_119:GetUnitListByKey(arg1_119)

	for iter0_119, iter1_119 in ipairs(var0_119) do
		if iter1_119.id == arg2_119 then
			return iter1_119
		end
	end

	return nil
end

function var0_0.GetPlayerUnitModule(arg0_120, arg1_120)
	return arg0_120:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_120)
end

function var0_0.GetUnitModule(arg0_121, arg1_121)
	return arg0_121:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_121)
end

function var0_0.GetSystemModule(arg0_122, arg1_122)
	return arg0_122:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_122)
end

function var0_0.GetProductSystemModule(arg0_123, arg1_123)
	return arg0_123:GetUnitModuleWithType(IslandConst.UNIT_LIST_PRODUCT_SYSTEM, arg1_123)
end

function var0_0.GetSystemUnitModule(arg0_124, arg1_124)
	return arg0_124:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_124)
end

function var0_0.GetStrollUnitModule(arg0_125, arg1_125)
	return arg0_125:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_125)
end

function var0_0.GetManageSystemModule(arg0_126, arg1_126)
	return arg0_126:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_126)
end

function var0_0.GetFollowerModule(arg0_127, arg1_127)
	return arg0_127:GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg1_127)
end

function var0_0.OnMovePlayerBefore(arg0_128)
	if arg0_128.player:CheckMovement() and arg0_128.isLockPlayInput then
		arg0_128.isLockPlayInput = false
	end

	arg0_128:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnLockPlayerInput(arg0_129)
	if arg0_129.playerInputing then
		arg0_129.isLockPlayInput = true

		arg0_129.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerMove(arg0_130, arg1_130)
	if arg0_130.isLockPlayInput then
		return
	end

	arg0_130.playerInputing = true

	if arg0_130.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_130.firstTakePhotoItem:MoveHandle(arg1_130.targetDir, arg1_130.force)
	elseif arg0_130.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_130.thirdTakePhotoItem:MoveHandle(arg1_130.targetDir, arg1_130.force)
	else
		arg0_130.player:MoveHandle(arg1_130.targetDir, arg1_130.force)
	end
end

function var0_0.OnPlayerStopMove(arg0_131)
	if arg0_131.isLockPlayInput then
		arg0_131.isLockPlayInput = false
	end

	arg0_131.playerInputing = true

	if arg0_131.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_131.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_131.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_131.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_131.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerStopMoveHandle(arg0_132)
	if arg0_132.isLockPlayInput then
		arg0_132.isLockPlayInput = false
	end

	arg0_132.playerInputing = true

	if arg0_132.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_132.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_132.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_132.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_132.player:StopMoveHandleByInput()
	end
end

function var0_0.OnPlayerJump(arg0_133)
	if arg0_133.takePhotoModel == IslandConst.TakePhotoModel.First or arg0_133.takePhotoModel == IslandConst.TakePhotoModel.Third then
		return
	end

	arg0_133.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_134)
	arg0_134.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_135)
	if arg0_135.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_135.firstTakePhotoItem:OnPlayerPlayerSprint()
	elseif arg0_135.takePhotoModel == IslandConst.TakePhotoModel.Third then
		-- block empty
	else
		arg0_135.player:OnPlayerPlayerSprint()
	end
end

function var0_0.OnStopPlayerSprint(arg0_136)
	if arg0_136.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_136.firstTakePhotoItem:OnStopPlayerSprint()
	elseif arg0_136.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_136.thirdTakePhotoItem:OnStopPlayerSprint()
	else
		arg0_136.player:OnStopPlayerSprint()
	end
end

function var0_0.OnPlayerWork(arg0_137, arg1_137, arg2_137)
	arg0_137.player:WorkHandle(arg1_137, arg2_137)
end

function var0_0.OnPlayerDeviceStateChange(arg0_138, arg1_138)
	arg0_138.player:DeviceStateHandle(arg1_138)
end

function var0_0.OnSetVisitorSyncData(arg0_139, arg1_139, arg2_139)
	local var0_139 = arg0_139:GetPlayerUnitModule(arg1_139)

	if var0_139 then
		var0_139:UpdateSyncData(arg2_139)
	end
end

function var0_0.OnWorldObjectStartInteraction(arg0_140, arg1_140, arg2_140, arg3_140)
	local var0_140 = arg2_140:GetHostId()
	local var1_140 = arg2_140:GetUserId()
	local var2_140 = arg0_140:GetUnitModule(var0_140)
	local var3_140 = arg0_140:GetPlayerUnitModule(var1_140)
	local var4_140 = arg0_140.player == var3_140

	if var4_140 then
		arg0_140:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_140 = arg1_140:GetTimeline()[arg3_140]
	local var6_140 = arg1_140:GetBlackboardParam()[arg3_140]

	var2_140:StartInteract(var3_140, arg2_140.id, arg3_140, var5_140, var6_140, arg1_140:AnySlotUsing(), var4_140)
end

function var0_0.OnWorldObjectEndInteraction(arg0_141, arg1_141, arg2_141)
	local var0_141 = arg2_141:GetHostId()
	local var1_141 = arg2_141:GetUserId()
	local var2_141 = arg0_141:GetUnitModule(var0_141)
	local var3_141 = arg0_141:GetPlayerUnitModule(var1_141)
	local var4_141 = arg0_141.player == var3_141

	if var4_141 then
		arg0_141:GetSubView(IslandOpView):EndInteraction()
	end

	var2_141:EndInteract(var3_141, arg2_141.id, not arg1_141:AnySlotUsing(), var4_141)
end

function var0_0.OnWorldObjectInitStatus(arg0_142, arg1_142, arg2_142)
	local var0_142 = arg0_142:GetUnitModule(arg1_142.id)
	local var1_142 = arg1_142:GetTimeline()[arg2_142]
	local var2_142 = arg1_142:GetBlackboardParam()[arg2_142]

	var0_142:InitStatus(arg2_142, var1_142, var2_142)
end

function var0_0.InitInteractionOpView(arg0_143)
	arg0_143:GetSubView(IslandOpView):EndInteraction()
end

function var0_0.OnPlayerAreaChange(arg0_144)
	arg0_144.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_145, arg1_145, arg2_145)
	arg0_145.player:OnChangeDress(arg1_145, arg2_145)
end

function var0_0.OnCharacterChangeDress(arg0_146, arg1_146, arg2_146, arg3_146, arg4_146)
	local var0_146 = arg0_146:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_146)

	if var0_146 then
		var0_146:OnCharacterChangeDress(arg2_146, arg3_146, arg4_146)
	end

	local var1_146 = arg0_146:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_146, iter1_146 in ipairs(var1_146) do
		if iter1_146:GetDataVO():IsSameShip(arg1_146) then
			iter1_146:OnCharacterChangeDress(arg2_146, arg3_146, arg4_146)
		end
	end

	local var2_146 = arg0_146:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter2_146, iter3_146 in ipairs(var2_146) do
		if iter3_146:GetDataVO():IsSameShip(arg1_146) then
			iter3_146:OnCharacterChangeDress(arg2_146, arg3_146, arg4_146)
		end
	end
end

function var0_0.OnStartDelegation(arg0_147, arg1_147, arg2_147)
	local var0_147 = arg0_147:GetSystemModule(arg1_147.build_id)

	if var0_147 then
		var0_147:StartDelegation(arg1_147)
	end

	local var1_147 = arg0_147:GetProductSystemModule(arg1_147.build_id)

	if var1_147 then
		var1_147:StartDelegation(arg2_147)
	end
end

function var0_0.OnEndDelegation(arg0_148, arg1_148, arg2_148)
	local var0_148 = arg0_148:GetSystemModule(arg1_148.build_id)

	if var0_148 then
		var0_148:EndDelegation(arg1_148)
	end
end

function var0_0.GetPlayerPosition(arg0_149)
	return arg0_149.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_150, arg1_150)
	local var0_150 = arg0_150:GetUnitModule(arg1_150)

	return var0_150 and var0_150._go.transform.position
end

function var0_0.OnShowUnitHudAndOpBtn(arg0_151, arg1_151)
	arg0_151.currentHudUnitData = arg1_151

	arg0_151:GetSubView(IslandSlotHudView):ShowHud(arg1_151.id, arg1_151.height)
	arg0_151:GetSubView(IslandOpView):UpdateOperationButton(arg1_151.operationType, arg1_151.id)

	if arg1_151.isHighLightControl then
		arg0_151.detectionSystem:HighLightUnitHandle(arg1_151.id, true)
	end
end

function var0_0.OnHideUnitHudAndOpBtn(arg0_152, arg1_152, arg2_152)
	if not arg0_152.currentHudUnitData then
		return
	end

	if arg0_152.currentHudUnitData.id ~= arg1_152.id or arg0_152.currentHudUnitData.type ~= arg1_152.type then
		return
	end

	if not arg2_152 then
		arg0_152.currentHudUnitData = nil
	end

	arg0_152:GetSubView(IslandSlotHudView):HideUnitHud(arg1_152.id)
	arg0_152:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_152.id)

	if arg1_152.isHighLightControl then
		arg0_152.detectionSystem:HighLightUnitHandle(arg1_152.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_153, arg1_153)
	if not arg0_153.currentHudUnitData then
		return
	end

	if arg1_153 ~= arg0_153.currentHudUnitData.id then
		return
	end

	arg0_153:GetSubView(IslandSlotHudView):UpdateHud(arg0_153.currentHudUnitData.id, arg0_153.currentHudUnitData.height)
	arg0_153:GetSubView(IslandOpView):UpdateOperationButton(arg0_153.currentHudUnitData.operationType, arg0_153.currentHudUnitData.id)
end

function var0_0.OnUpdateHandCollectUnit(arg0_154, arg1_154)
	local var0_154 = arg0_154:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_154)

	if var0_154 then
		var0_154:UpdateHandCollet()
		var0_154:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_155, arg1_155)
	arg0_155:GetSubView(IslandTopHeadHudView):ShowHud(arg1_155)
	arg0_155:GetSubView(IslandDistanceView):ShowHud(arg1_155.id)
end

function var0_0.OnRefreshHud(arg0_156, arg1_156)
	arg0_156:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_156)
end

function var0_0.OnHideHud(arg0_157, arg1_157)
	arg0_157:GetSubView(IslandTopHeadHudView):HideHud(arg1_157)
	arg0_157:GetSubView(IslandDistanceView):HideHud(arg1_157.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_158, arg1_158)
	local var0_158 = arg0_158:GetUnitModuleWithType(arg1_158.type, arg1_158.id)

	if var0_158 then
		var0_158:DelegateSlotStartPerform()
	end
end

function var0_0.OnRecycleAllSlotEffct(arg0_159)
	arg0_159.effectMgr:RecycleAllSlotEffct()
end

function var0_0.OnLoadDelegatePreviewRole(arg0_160, arg1_160, arg2_160)
	arg0_160.effectMgr:LoadDelegatePreviewRole(arg1_160, arg2_160)
end

function var0_0.OnUnLoadDelegatePreviewRole(arg0_161)
	arg0_161.effectMgr:UnLoadDelegatePreviewRole()
end

function var0_0.OnSelectSlotEffectShow(arg0_162, arg1_162, arg2_162, arg3_162, arg4_162)
	arg0_162.effectMgr:SelectSlotEffectShow(arg1_162, arg2_162, arg3_162, arg4_162)
end

function var0_0.OnTakePlantAttack(arg0_163, arg1_163)
	local var0_163 = arg0_163:GetUnitModuleWithType(arg1_163.type, arg1_163.id)

	if var0_163 then
		var0_163:TakeAttack()
	end
end

function var0_0.OnStartManage(arg0_164, arg1_164)
	local var0_164 = arg0_164:GetManageSystemModule(arg1_164.id)

	if var0_164 then
		var0_164:StartManage(arg1_164)
	end
end

function var0_0.OnEndManage(arg0_165, arg1_165)
	local var0_165 = arg0_165:GetManageSystemModule(arg1_165.id)

	if var0_165 then
		var0_165:EndManage(arg1_165)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_166)
	arg0_166:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnRefreshWeatherSystem(arg0_167)
	arg0_167.weatherSystem:Play()
end

function var0_0.OnDispose(arg0_168)
	arg0_168.detectionSystem:Dispose()
	arg0_168.effectMgr:Dispose()
	arg0_168.coupleActionPlayer:Dispose()
	arg0_168.coupleAction4FollowerPlayer:Dispose()
	arg0_168.npcActionPlayer:Dispose()
	arg0_168.weatherSystem:Dispose()
	arg0_168.coupleNpcWordPlayer:Dispose()
	arg0_168:GetPoolMgr():ClearFishingEffect()

	for iter0_168, iter1_168 in ipairs(arg0_168.views) do
		iter1_168:Dispose()
	end

	for iter2_168, iter3_168 in ipairs(arg0_168.pathfinders) do
		iter3_168:Dispose()
	end

	for iter4_168, iter5_168 in ipairs(arg0_168:GetAllUnits()) do
		iter5_168:Dispose()
	end

	for iter6_168, iter7_168 in pairs(arg0_168.unitBuilders) do
		iter7_168:Dispose()
	end

	for iter8_168, iter9_168 in pairs(arg0_168.systemBuilders) do
		iter9_168:Dispose()
	end

	for iter10_168, iter11_168 in pairs(arg0_168.fishingSynPlayers) do
		iter11_168:Dispose()
	end

	arg0_168.fishingSynPlayers = nil
	arg0_168.npcActionPlayer = nil
	arg0_168.coupleActionPlayer = nil
	arg0_168.coupleAction4FollowerPlayer = nil
	arg0_168.pathfinders = nil
	arg0_168.unitBuilders = nil
	arg0_168.systemBuilders = nil
	arg0_168.views = nil
	arg0_168.player = nil
	arg0_168.isInit = false
	arg0_168._unitList = nil
	arg0_168.detectionSystem = nil
	arg0_168.effectMgr = nil
	arg0_168.coupleNpcWordPlayer = nil
end

return var0_0
