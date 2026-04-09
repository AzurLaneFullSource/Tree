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
	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_CHEATER_ITEM)

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
		[IslandConst.UNIT_TYPE_DELEGATE_FISH] = IslandDelegationFishBuilder.New(arg0_1, IslandConst.UNIT_LIST_DELEGATE_UNIT),
		[IslandConst.UNIT_TYPE_CHEATERTAVERN_PLAYER] = IslandCheaterTavernPlayerBuilder.New(arg0_1, IslandConst.UNIT_LIST_PLAYER),
		[IslandConst.UNIT_TYPE_CHEATERTAVERN_TABLE] = IslandCheaterTavernTableBuilder.New(arg0_1, IslandConst.UNIT_LIST_CHEATER_ITEM),
		[IslandConst.UNIT_TYPE_CHEATERTAVERN_CHAIR] = IslandCheaterTavernChairBuilder.New(arg0_1, IslandConst.UNIT_LIST_CHEATER_ITEM)
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

	arg0_1:CreateViews()
end

function var0_0.CreateViews(arg0_2)
	arg0_2.views = {
		arg0_2:CreateInteractionView(),
		arg0_2:CreateDistanceView(),
		arg0_2:CreateSeedOpView(),
		arg0_2:CreateOpView(),
		arg0_2:CreateSlotHudView(),
		arg0_2:CreateTopHeadHudView(),
		arg0_2:CreateBottomHeadHudeView(),
		arg0_2:CreateCancelAnimationOpView(),
		arg0_2:CreateAnimationOpView()
	}
end

function var0_0.DoEnter(arg0_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3:GetAllUnits()) do
		table.insert(var0_3, function(arg0_4)
			iter1_3:Start()

			if iter0_3 % 3 == 0 then
				arg0_4()
			else
				onNextTick(arg0_4)
			end
		end)
	end

	seriesAsync(var0_3, function()
		arg0_3.isInit = true
	end)
end

function var0_0.GetSubView(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.views or {}) do
		if isa(iter1_6, arg1_6) then
			return iter1_6
		end
	end

	return nil
end

function var0_0.CreateOpView(arg0_7)
	return IslandOpView.New(arg0_7)
end

function var0_0.CreateSlotHudView(arg0_8)
	return IslandSlotHudView.New(arg0_8)
end

function var0_0.CreateCancelAnimationOpView(arg0_9)
	return IslandCancelAnimationOpView.New(arg0_9)
end

function var0_0.CreateTopHeadHudView(arg0_10)
	return IslandTopHeadHudView.New(arg0_10)
end

function var0_0.CreateBottomHeadHudeView(arg0_11)
	return IslandBottomHeadHudView.New(arg0_11)
end

function var0_0.CreateAnimationOpView(arg0_12)
	return IslandAniamtionOpView.New(arg0_12)
end

function var0_0.CreateInteractionView(arg0_13)
	return IslandInteractionView.New(arg0_13)
end

function var0_0.CreateDistanceView(arg0_14)
	return IslandDistanceView.New(arg0_14)
end

function var0_0.CreateSeedOpView(arg0_15)
	return IslandSeedOpView.New(arg0_15)
end

function var0_0.IsLoaded(arg0_16)
	local var0_16 = arg0_16:GetAllUnits()

	return _.all(arg0_16.views, function(arg0_17)
		return arg0_17:IsLoaded()
	end) and #var0_16 > 0 and _.all(var0_16, function(arg0_18)
		return arg0_18:IsLoaded()
	end)
end

function var0_0.IsInit(arg0_19)
	return arg0_19.isInit
end

function var0_0.Update(arg0_20)
	if not arg0_20.isInit then
		return
	end

	for iter0_20, iter1_20 in ipairs(arg0_20:GetAllUnits()) do
		iter1_20:Update()
	end

	for iter2_20, iter3_20 in ipairs(arg0_20.views) do
		iter3_20:Update()
	end

	for iter4_20, iter5_20 in ipairs(arg0_20.pathfinders) do
		iter5_20:Update()
	end

	if arg0_20.needTryTrack then
		arg0_20:TryTrack()
	end

	if arg0_20.needTryMainTrack then
		arg0_20:TryMainTrack()
	end
end

function var0_0.LateUpdate(arg0_21)
	if not arg0_21.isInit then
		return
	end

	for iter0_21, iter1_21 in ipairs(arg0_21:GetAllUnits()) do
		iter1_21:LateUpdate()
	end

	for iter2_21, iter3_21 in ipairs(arg0_21.views) do
		iter3_21:LateUpdate()
	end

	for iter4_21, iter5_21 in ipairs(arg0_21.pathfinders) do
		iter5_21:LateUpdate()
	end
end

function var0_0.AddListeners(arg0_22)
	arg0_22:AddListener(ISLAND_EVT.GEN_UNIT, arg0_22.OnGenUnit)
	arg0_22:AddListener(ISLAND_EVT.RMOVE_UNIT, arg0_22.OnRemoveUnit)
	arg0_22:AddListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_22.OnInterActionBegin)
	arg0_22:AddListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_22.OnInterActionEnd)
	arg0_22:AddListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_22.OnStopUnit)
	arg0_22:AddListener(ISLAND_EVT.MOVE_UNIT, arg0_22.OnMoveUnit)
	arg0_22:AddListener(ISLAND_EVT.INIT_FINISH, arg0_22.OnSceneInited)
	arg0_22:AddListener(ISLAND_EVT.MOVE_PLAYER, arg0_22.OnPlayerMove)
	arg0_22:AddListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_22.OnPlayerStopMoveHandle)
	arg0_22:AddListener(ISLAND_EVT.JUMP_PLAYER, arg0_22.OnPlayerJump)
	arg0_22:AddListener(ISLAND_EVT.APPROACH_UNIT, arg0_22.OnShowInterActionPanel)
	arg0_22:AddListener(ISLAND_EVT.LEAVE_UNIT, arg0_22.OnHideInterActionPanel)
	arg0_22:AddListener(ISLAND_EVT.TRACKING, arg0_22.OnTracking)
	arg0_22:AddListener(ISLAND_EVT.UNTRACKING, arg0_22.OnUnTracking)
	arg0_22:AddListener(ISLAND_EVT.AREACHANGE, arg0_22.OnPlayerAreaChange)
	arg0_22:AddListener(ISLAND_EVT.PLAYERRUN, arg0_22.OnPlayerPlayerRun)
	arg0_22:AddListener(ISLAND_EVT.SPRINT_PLAYER, arg0_22.OnPlayerPlayerSprint)
	arg0_22:AddListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_22.OnStopPlayerSprint)
	arg0_22:AddListener(ISLAND_EVT.CHANGE_DRESS, arg0_22.OnChangeDress)
	arg0_22:AddListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_22.OnCharacterChangeDress)
	arg0_22:AddListener(ISLAND_EVT.RESET_UNIT_POS, arg0_22.OnResetUnitPos)
	arg0_22:AddListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_22.OnResetUnitRotation)
	arg0_22:AddListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_22.OnAnyPageOpen)
	arg0_22:AddListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_22.OnAllPageClose)
	arg0_22:AddListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_22.OnChangeTakePhotoModel)
	arg0_22:AddListener(ISLAND_EVT.Change_Photo_Height, arg0_22.OnChange_Photo_Height)
	arg0_22:AddListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_22.OnSetOpMoveBtnActve)
	arg0_22:AddListener(ISLAND_EVT.PLAY_BUBBLE, arg0_22.OnPlayChatBubble)
	arg0_22:AddListener(ISLAND_EVT.RAW_PLAY_BUBBLE, arg0_22.OnRawPlayChatBubble)
	arg0_22:AddListener(ISLAND_EVT.RAW_STOP_BUBBLE, arg0_22.OnRawStopChatBubble)
	arg0_22:AddListener(ISLAND_EVT.START_STORY, arg0_22.OnStartStory)
	arg0_22:AddListener(ISLAND_EVT.END_STORY, arg0_22.OnEndStory)
	arg0_22:AddListener(ISLAND_EVT.START_DEGATION, arg0_22.OnStartDelegation)
	arg0_22:AddListener(ISLAND_EVT.END_DEGATION, arg0_22.OnEndDelegation)
	arg0_22:AddListener(ISLAND_EVT.GEN_SYSTEM, arg0_22.OnGenSystem)
	arg0_22:AddListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_22.OnWorldObjectStartInteraction)
	arg0_22:AddListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_22.OnWorldObjectEndInteraction)
	arg0_22:AddListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_22.OnWorldObjectInitStatus)
	arg0_22:AddListener(ISLAND_EVT.INIT_INTERACTION_OP_VIEW, arg0_22.InitInteractionOpView)
	arg0_22:AddListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_22.OnRefreshInteractionBtn)
	arg0_22:AddListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_22.OnShowUnitHudAndOpBtn)
	arg0_22:AddListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_22.OnHideUnitHudAndOpBtn)
	arg0_22:AddListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_22.OnDetectorChanged)
	arg0_22:AddListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_22.OnDetectorSelected)
	arg0_22:AddListener(ISLAND_EVT.FISHPOINT_DETECTOR, arg0_22.OnFishPointSelected)
	arg0_22:AddListener(ISLAND_EVT.NPC_DETECTED, arg0_22.OnNpcDetectorSelected)
	arg0_22:AddListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_22.OnNpcDetectorUnSelected)
	arg0_22:AddListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_22.OnPlayerWork)
	arg0_22:AddListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_22.OnPlayerDeviceStateChange)
	arg0_22:AddListener(ISLAND_EVT.UPDATE_HUD, arg0_22.OnUpdateHud)
	arg0_22:AddListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_22.OnUpdateHandCollectUnit)
	arg0_22:AddListener(ISLAND_EVT.START_DELEGATE_SLOT_PERFORM, arg0_22.OnDelegateSlotStartPerform)
	arg0_22:AddListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_22.OnRecycleAllSlotEffct)
	arg0_22:AddListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_22.OnSelectSlotEffectShow)
	arg0_22:AddListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_22.OnLoadDelegatePreviewRole)
	arg0_22:AddListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_22.OnUnLoadDelegatePreviewRole)
	arg0_22:AddListener(ISLAND_EVT.Take_Plant_Attact, arg0_22.OnTakePlantAttack)
	arg0_22:AddListener(ISLAND_EVT.START_MANAGE, arg0_22.OnStartManage)
	arg0_22:AddListener(ISLAND_EVT.END_MANAGE, arg0_22.OnEndManage)
	arg0_22:AddListener(ISLAND_EVT.SHOW_HUD, arg0_22.OnShowHud)
	arg0_22:AddListener(ISLAND_EVT.HIDE_HUD, arg0_22.OnHideHud)
	arg0_22:AddListener(ISLAND_EVT.REFRESH_HUD, arg0_22.OnRefreshHud)
	arg0_22:AddListener(ISLAND_EVT.START_GUIDE, arg0_22.OnStartGuide)
	arg0_22:AddListener(ISLAND_EVT.END_GUIDE, arg0_22.OnEndGuide)
	arg0_22:AddListener(ISLAND_EVT.START_PERFORMANCE, arg0_22.OnStartPerformance)
	arg0_22:AddListener(ISLAND_EVT.END_PERFORMANCE, arg0_22.OnEndPerformance)
	arg0_22:AddListener(ISLAND_EVT.DISABLE_INPUT, arg0_22.DisableInput)
	arg0_22:AddListener(ISLAND_EVT.ENABLE_INPUT, arg0_22.EnableInput)
	arg0_22:AddListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_22.OnGenPathFinder)
	arg0_22:AddListener(ISLAND_EVT.REMOVE_PATH_FINDER, arg0_22.OnRemovePathFinder)
	arg0_22:AddListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_22.OnActiveOrDisactiveUnit)
	arg0_22:AddListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_22.OnOpenAniamtionOpPage)
	arg0_22:AddListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_22.OnCloseAniamtionOpPage)
	arg0_22:AddListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_22.OnMovePlayerBefore)
	arg0_22:AddListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_22.OnRefreshTaskInfoHud)
	arg0_22:AddListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_22.OnResponAniamtionOp)
	arg0_22:AddListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_22.OnChangeVisterDress)
	arg0_22:AddListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_22.OnSetVisitorSyncData)
	arg0_22:AddListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_22.OnShowNpcAniamtionBubble)
	arg0_22:AddListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_22.OnHideNpcAniamtionBubble)
	arg0_22:AddListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_22.OnPlaySingleAnimationEnd)
	arg0_22:AddListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_22.OnUpdateCustomOpPositon)
	arg0_22:AddListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_22.OnChatMsgUpdate)
	arg0_22:AddListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_22.OnChatRoomChange)
	arg0_22:AddListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_22.OnShowChatMsg)
	arg0_22:AddListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_22.OnResetFollowRandomizer)
	arg0_22:AddListener(ISLAND_EVT.ADD_FOLLOWER, arg0_22.OnFollowerAdd)
	arg0_22:AddListener(ISLAND_EVT.WILL_DEL_FOLLOWER, arg0_22.OnFollowerWillDelStep1)
	arg0_22:AddListener(ISLAND_EVT.DO_DEL_FOLLOWER, arg0_22.OnFollowerWillDelStep2)
	arg0_22:AddListener(ISLAND_EVT.DEL_FOLLOWER, arg0_22.OnFollowerDel)
	arg0_22:AddListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_22.OnCoupleActionWithFollower)
	arg0_22:AddListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_22.OnLockPlayerInput)
	arg0_22:AddListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_22.OnStartCoupleAction)
	arg0_22:AddListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_22.OnEndCoupleAction)
	arg0_22:AddListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_22.OnRefreshWeatherSystem)
	arg0_22:AddListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_22.OnSystemUnlock)
	arg0_22:AddListener(ISLAND_EVT.START_DO_COUPLE_ACTION, arg0_22.OnStartDoCoupleAction)
	arg0_22:AddListener(ISLAND_EVT.END_DO_COUPLE_ACTION, arg0_22.OnEndDoCoupleAction)
	arg0_22:AddListener(ISLAND_EVT.CANCEL_COUPLE_ACTION, arg0_22.OnCancelCoupleAction)
	arg0_22:AddListener(ISLAND_EVT.BAIT_UPDATE, arg0_22.OnBaitUpdate)
	arg0_22:AddListener(ISLAND_EVT.START_FISHING, arg0_22.OnStartFishing)
	arg0_22:AddListener(ISLAND_EVT.FISHING_STATE_CHANGE, arg0_22.OnFishingStateChange)
	arg0_22:AddListener(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, arg0_22.OnAllDailyOrWeeklyFinish)
end

function var0_0.RemoveListeners(arg0_23)
	arg0_23:RemoveListener(ISLAND_EVT.GEN_UNIT, arg0_23.OnGenUnit)
	arg0_23:RemoveListener(ISLAND_EVT.RMOVE_UNIT, arg0_23.OnRemoveUnit)
	arg0_23:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_23.OnInterActionBegin)
	arg0_23:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_23.OnInterActionEnd)
	arg0_23:RemoveListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_23.OnStopUnit)
	arg0_23:RemoveListener(ISLAND_EVT.MOVE_UNIT, arg0_23.OnMoveUnit)
	arg0_23:RemoveListener(ISLAND_EVT.INIT_FINISH, arg0_23.OnSceneInited)
	arg0_23:RemoveListener(ISLAND_EVT.MOVE_PLAYER, arg0_23.OnPlayerMove)
	arg0_23:RemoveListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_23.OnPlayerStopMoveHandle)
	arg0_23:RemoveListener(ISLAND_EVT.JUMP_PLAYER, arg0_23.OnPlayerJump)
	arg0_23:RemoveListener(ISLAND_EVT.APPROACH_UNIT, arg0_23.OnShowInterActionPanel)
	arg0_23:RemoveListener(ISLAND_EVT.LEAVE_UNIT, arg0_23.OnHideInterActionPanel)
	arg0_23:RemoveListener(ISLAND_EVT.TRACKING, arg0_23.OnTracking)
	arg0_23:RemoveListener(ISLAND_EVT.UNTRACKING, arg0_23.OnUnTracking)
	arg0_23:RemoveListener(ISLAND_EVT.AREACHANGE, arg0_23.OnPlayerAreaChange)
	arg0_23:RemoveListener(ISLAND_EVT.PLAYERRUN, arg0_23.OnPlayerPlayerRun)
	arg0_23:RemoveListener(ISLAND_EVT.SPRINT_PLAYER, arg0_23.OnPlayerPlayerSprint)
	arg0_23:RemoveListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_23.OnStopPlayerSprint)
	arg0_23:RemoveListener(ISLAND_EVT.CHANGE_DRESS, arg0_23.OnChangeDress)
	arg0_23:RemoveListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_23.OnCharacterChangeDress)
	arg0_23:RemoveListener(ISLAND_EVT.RESET_UNIT_POS, arg0_23.OnResetUnitPos)
	arg0_23:RemoveListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_23.OnResetUnitRotation)
	arg0_23:RemoveListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_23.OnAnyPageOpen)
	arg0_23:RemoveListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_23.OnChangeTakePhotoModel)
	arg0_23:RemoveListener(ISLAND_EVT.Change_Photo_Height, arg0_23.OnChange_Photo_Height)
	arg0_23:RemoveListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_23.OnSetOpMoveBtnActve)
	arg0_23:RemoveListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_23.OnAllPageClose)
	arg0_23:RemoveListener(ISLAND_EVT.PLAY_BUBBLE, arg0_23.OnPlayChatBubble)
	arg0_23:RemoveListener(ISLAND_EVT.RAW_PLAY_BUBBLE, arg0_23.OnRawPlayChatBubble)
	arg0_23:RemoveListener(ISLAND_EVT.RAW_STOP_BUBBLE, arg0_23.OnRawStopChatBubble)
	arg0_23:RemoveListener(ISLAND_EVT.START_STORY, arg0_23.OnStartStory)
	arg0_23:RemoveListener(ISLAND_EVT.END_STORY, arg0_23.OnEndStory)
	arg0_23:RemoveListener(ISLAND_EVT.START_DEGATION, arg0_23.OnStartDelegation)
	arg0_23:RemoveListener(ISLAND_EVT.END_DEGATION, arg0_23.OnEndDelegation)
	arg0_23:RemoveListener(ISLAND_EVT.GEN_SYSTEM, arg0_23.OnGenSystem)
	arg0_23:RemoveListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_23.OnWorldObjectStartInteraction)
	arg0_23:RemoveListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_23.OnWorldObjectEndInteraction)
	arg0_23:RemoveListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_23.OnWorldObjectInitStatus)
	arg0_23:RemoveListener(ISLAND_EVT.INIT_INTERACTION_OP_VIEW, arg0_23.InitInteractionOpView)
	arg0_23:RemoveListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_23.OnRefreshInteractionBtn)
	arg0_23:RemoveListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_23.OnShowUnitHudAndOpBtn)
	arg0_23:RemoveListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_23.OnHideUnitHudAndOpBtn)
	arg0_23:RemoveListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_23.OnDetectorChanged)
	arg0_23:RemoveListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_23.OnDetectorSelected)
	arg0_23:RemoveListener(ISLAND_EVT.FISHPOINT_DETECTOR, arg0_23.OnFishPointSelected)
	arg0_23:RemoveListener(ISLAND_EVT.NPC_DETECTED, arg0_23.OnNpcDetectorSelected)
	arg0_23:RemoveListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_23.OnNpcDetectorUnSelected)
	arg0_23:RemoveListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_23.OnPlayerWork)
	arg0_23:RemoveListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_23.OnPlayerDeviceStateChange)
	arg0_23:RemoveListener(ISLAND_EVT.UPDATE_HUD, arg0_23.OnUpdateHud)
	arg0_23:RemoveListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_23.OnUpdateHandCollectUnit)
	arg0_23:RemoveListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_23.OnRecycleAllSlotEffct)
	arg0_23:RemoveListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_23.OnSelectSlotEffectShow)
	arg0_23:RemoveListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_23.OnLoadDelegatePreviewRole)
	arg0_23:RemoveListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_23.OnUnLoadDelegatePreviewRole)
	arg0_23:RemoveListener(ISLAND_EVT.Take_Plant_Attact, arg0_23.OnTakePlantAttack)
	arg0_23:RemoveListener(ISLAND_EVT.START_MANAGE, arg0_23.OnStartManage)
	arg0_23:RemoveListener(ISLAND_EVT.END_MANAGE, arg0_23.OnEndManage)
	arg0_23:RemoveListener(ISLAND_EVT.SHOW_HUD, arg0_23.OnShowHud)
	arg0_23:RemoveListener(ISLAND_EVT.HIDE_HUD, arg0_23.OnHideHud)
	arg0_23:RemoveListener(ISLAND_EVT.REFRESH_HUD, arg0_23.OnRefreshHud)
	arg0_23:RemoveListener(ISLAND_EVT.START_GUIDE, arg0_23.OnStartGuide)
	arg0_23:RemoveListener(ISLAND_EVT.END_GUIDE, arg0_23.OnEndGuide)
	arg0_23:RemoveListener(ISLAND_EVT.START_PERFORMANCE, arg0_23.OnStartPerformance)
	arg0_23:RemoveListener(ISLAND_EVT.END_PERFORMANCE, arg0_23.OnEndPerformance)
	arg0_23:RemoveListener(ISLAND_EVT.DISABLE_INPUT, arg0_23.DisableInput)
	arg0_23:RemoveListener(ISLAND_EVT.ENABLE_INPUT, arg0_23.EnableInput)
	arg0_23:RemoveListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_23.OnGenPathFinder)
	arg0_23:RemoveListener(ISLAND_EVT.REMOVE_PATH_FINDER, arg0_23.OnRemovePathFinder)
	arg0_23:RemoveListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_23.OnActiveOrDisactiveUnit)
	arg0_23:RemoveListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_23.OnOpenAniamtionOpPage)
	arg0_23:RemoveListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_23.OnCloseAniamtionOpPage)
	arg0_23:RemoveListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_23.OnMovePlayerBefore)
	arg0_23:RemoveListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_23.OnRefreshTaskInfoHud)
	arg0_23:RemoveListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_23.OnResponAniamtionOp)
	arg0_23:RemoveListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_23.OnChangeVisterDress)
	arg0_23:RemoveListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_23.OnSetVisitorSyncData)
	arg0_23:RemoveListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_23.OnShowNpcAniamtionBubble)
	arg0_23:RemoveListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_23.OnHideNpcAniamtionBubble)
	arg0_23:RemoveListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_23.OnPlaySingleAnimationEnd)
	arg0_23:RemoveListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_23.OnUpdateCustomOpPositon)
	arg0_23:RemoveListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_23.OnChatMsgUpdate)
	arg0_23:RemoveListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_23.OnChatRoomChange)
	arg0_23:RemoveListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_23.OnShowChatMsg)
	arg0_23:RemoveListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_23.OnResetFollowRandomizer)
	arg0_23:RemoveListener(ISLAND_EVT.ADD_FOLLOWER, arg0_23.OnFollowerAdd)
	arg0_23:RemoveListener(ISLAND_EVT.WILL_DEL_FOLLOWER, arg0_23.OnFollowerWillDelStep1)
	arg0_23:RemoveListener(ISLAND_EVT.DO_DEL_FOLLOWER, arg0_23.OnFollowerWillDelStep2)
	arg0_23:RemoveListener(ISLAND_EVT.DEL_FOLLOWER, arg0_23.OnFollowerDel)
	arg0_23:RemoveListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_23.OnCoupleActionWithFollower)
	arg0_23:RemoveListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_23.OnLockPlayerInput)
	arg0_23:RemoveListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_23.OnStartCoupleAction)
	arg0_23:RemoveListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_23.OnEndCoupleAction)
	arg0_23:RemoveListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_23.OnRefreshWeatherSystem)
	arg0_23:RemoveListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_23.OnSystemUnlock)
	arg0_23:RemoveListener(ISLAND_EVT.START_DO_COUPLE_ACTION, arg0_23.OnStartDoCoupleAction)
	arg0_23:RemoveListener(ISLAND_EVT.END_DO_COUPLE_ACTION, arg0_23.OnEndDoCoupleAction)
	arg0_23:RemoveListener(ISLAND_EVT.CANCEL_COUPLE_ACTION, arg0_23.OnCancelCoupleAction)
	arg0_23:RemoveListener(ISLAND_EVT.BAIT_UPDATE, arg0_23.OnBaitUpdate)
	arg0_23:RemoveListener(ISLAND_EVT.START_FISHING, arg0_23.OnStartFishing)
	arg0_23:RemoveListener(ISLAND_EVT.FISHING_STATE_CHANGE, arg0_23.OnFishingStateChange)
	arg0_23:RemoveListener(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, arg0_23.OnAllDailyOrWeeklyFinish)
end

function var0_0.OnBaitUpdate(arg0_24, arg1_24)
	arg0_24:GetSubView(IslandOpView):UpdateLureBtn()
end

function var0_0.OnFishPointSelected(arg0_25, arg1_25)
	local var0_25 = arg1_25.node

	if not var0_25 then
		return
	end

	local var1_25 = var0_25:GetBlackboardVariable("FishPoint")

	if not var1_25 or var1_25 == "" then
		arg0_25:UnSelectedFishPoint()
	else
		local var2_25, var3_25 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_25)
		local var4_25 = arg0_25:GetUnitModuleWithType(var2_25, var3_25)

		if var4_25 then
			arg0_25:SelectedFishPoint(var4_25)
		end
	end
end

function var0_0.OnAllDailyOrWeeklyFinish(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_26 = {}

	for iter0_26, iter1_26 in ipairs(var0_26) do
		if not iter1_26:IsExitState() then
			table.insert(var1_26, iter1_26)
		end
	end

	if #var1_26 <= 0 then
		return
	end

	for iter2_26, iter3_26 in ipairs(var1_26) do
		iter3_26:StopMove()
		iter3_26:PlayAnimation(arg1_26)
	end
end

function var0_0.OnSystemUnlock(arg0_27, arg1_27)
	if arg1_27 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_27:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.SelectedFishPoint(arg0_28, arg1_28)
	if not arg0_28:GetSelfIsland():GetAblityAgency():IsUnlockFishing() or arg1_28:GetUnitType() ~= IslandConst.UNIT_LIST_FISH_POINT or arg0_28.player:StandOnWorldObject() or not arg0_28.player:OnGrouded() then
		return
	end

	arg0_28:UnSelectedFishPoint()

	arg0_28.selectedFishPointId = arg1_28.id

	arg0_28:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.Fishing, arg1_28.id)
end

function var0_0.UnSelectedFishPoint(arg0_29)
	if arg0_29.selectedFishPointId then
		local var0_29 = arg0_29.selectedFishPointId

		arg0_29.selectedFishPointId = nil

		arg0_29:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, var0_29)
	end
end

function var0_0.OnStartFishing(arg0_30, arg1_30)
	local var0_30 = arg1_30.unitId
	local var1_30 = arg0_30:GetPlayerUnitModule(var0_30)

	if not var1_30 then
		return
	end

	if not isa(var1_30, IslandVisitorUnit) then
		return
	end

	var1_30:Sleep()

	local var2_30 = arg1_30.fishPointId
	local var3_30 = arg1_30.rodId
	local var4_30 = arg1_30.fishId
	local var5_30 = pg.island_fish_rod[var3_30].attachment_id
	local var6_30 = IslandVistorFishingPlayer.New(arg0_30, var1_30, var2_30, var5_30, var4_30)

	var6_30:Play()

	arg0_30.fishingSynPlayers[var0_30] = var6_30
end

function var0_0.OnFishingStateChange(arg0_31, arg1_31)
	local var0_31 = arg1_31.op
	local var1_31 = arg1_31.unitId
	local var2_31 = arg0_31:GetPlayerUnitModule(var1_31)
	local var3_31 = arg0_31.fishingSynPlayers[var1_31]

	if not isa(var2_31, IslandVisitorUnit) then
		return
	end

	if not var3_31 or not var3_31:IsSameFishPoint(arg1_31.fishPointId) then
		return
	end

	local function var4_31()
		var2_31:WakeUp()
		arg0_31.fishingSynPlayers[var1_31]:Dispose()

		arg0_31.fishingSynPlayers[var1_31] = nil
	end

	if var0_31 == IslandConst.FISHING_OP_CANCEL then
		var3_31:OnCancel(var4_31)
	elseif var0_31 == IslandConst.FISHING_OP_FAILD then
		var3_31:OnFailed(var4_31)
	elseif var0_31 == IslandConst.FISHING_OP_SUCCESS then
		var3_31:OnSuccess(var4_31)
	end
end

function var0_0.OnStartCoupleAction(arg0_33)
	arg0_33:UnBlockLayer1Event(false)
	arg0_33:GetSubView(IslandAniamtionOpView):OnStartCoupleAction()
end

function var0_0.OnEndCoupleAction(arg0_34)
	arg0_34:UnBlockLayer1Event(true)
	arg0_34:GetSubView(IslandAniamtionOpView):OnEndCoupleAction()
end

function var0_0.OnCancelCoupleAction(arg0_35)
	if arg0_35.coupleActionPlayer and arg0_35.coupleActionPlayer:IsPlaying() then
		arg0_35.coupleActionPlayer:Stop()
	end

	if arg0_35.coupleAction4FollowerPlayer and arg0_35.coupleAction4FollowerPlayer:IsPlaying() then
		arg0_35.coupleAction4FollowerPlayer:Stop()
	end

	arg0_35:OnEndCoupleAction()
end

function var0_0.OnCoupleActionWithFollower(arg0_36, arg1_36)
	local var0_36 = arg0_36:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_36 = arg0_36:GetPlayerPosition()
	local var2_36 = pg.island_set.action_bubble_range.key_value_int
	local var3_36 = _.select(var0_36, function(arg0_37)
		return not arg0_37:IsExitState() and Vector3.Distance(arg0_37:GetPosition(), var1_36) <= var2_36
	end)

	if #var3_36 <= 0 then
		return
	end

	local var4_36 = var3_36[math.random(1, #var3_36)]
	local var5_36 = pg.island_action[arg1_36]

	arg0_36.coupleAction4FollowerPlayer:Play(var4_36, arg0_36.player, var5_36)
	arg0_36:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
end

function var0_0.OnFollowerAdd(arg0_38, arg1_38)
	if arg0_38:GetSelectedNpcId() then
		local var0_38, var1_38 = IslandCalcUtil.GetTypeAndIdByUniqueId(arg0_38:GetSelectedNpcId())

		if var1_38 == arg1_38 then
			arg0_38.selectedNpcId = nil
		end
	end

	arg0_38:GetSubView(IslandOpView):FlushFollowerList()
	arg0_38.coupleNpcWordPlayer:Play(arg1_38)
end

function var0_0.OnFollowerWillDelStep1(arg0_39, arg1_39)
	local var0_39 = arg0_39:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_39

	for iter0_39, iter1_39 in ipairs(var0_39) do
		if iter1_39:GetDataVO():IsSameShip(arg1_39) then
			var1_39 = iter1_39

			break
		end
	end

	if not var1_39 or var1_39:IsExitState() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_follower_exiting_tip"))

		return
	end

	var1_39:DoExitHandle()
end

function var0_0.OnFollowerWillDelStep2(arg0_40, arg1_40)
	local var0_40 = arg1_40.node

	if not var0_40 then
		return
	end

	local var1_40 = var0_40:GetComponent(typeof(WorldObjectItem)).uniqueId
	local var2_40, var3_40 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_40)
	local var4_40 = arg0_40:GetUnitModuleWithType(var2_40, var3_40)

	if not var4_40 then
		return
	end

	arg0_40:NotifiyMeditor(IslandMediator.DEL_FOLLOWER, var4_40:GetDataVO():GetShipId())
end

function var0_0.OnFollowerDel(arg0_41, arg1_41)
	arg0_41:GetSubView(IslandOpView):FlushFollowerList()
	arg0_41.coupleNpcWordPlayer:Stop(arg1_41)
end

function var0_0.OnResetFollowRandomizer(arg0_42, arg1_42)
	local var0_42 = arg0_42:GetFollowerModule(arg1_42)

	if not var0_42 then
		return
	end

	var0_42:SetBtRandomizer()
end

function var0_0.OnShowChatMsg(arg0_43, arg1_43)
	local var0_43 = arg1_43.player.id
	local var1_43 = arg0_43:GetPlayerUnitModule(var0_43)

	if not var1_43 then
		return
	end

	arg0_43:GetSubView(IslandTopHeadHudView):PlayChat(var1_43, arg1_43.emojiId, arg1_43.content, nil)
end

function var0_0.OnChatRoomChange(arg0_44)
	arg0_44:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_45)
	arg0_45:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnPlaySingleAnimationEnd(arg0_46, arg1_46)
	if not arg0_46:GetSelectedNpcId() then
		arg0_46.npcActionPlayer:ResoponByRandom(arg0_46.player, arg1_46)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(1, arg1_46, 0, 0, 0, 0))

		return
	end

	local var0_46 = arg0_46:GetSelectedNpcId()
	local var1_46, var2_46 = IslandCalcUtil.GetTypeAndIdByUniqueId(var0_46)
	local var3_46 = arg0_46:GetUnitModuleWithType(var1_46, var2_46)

	if isa(var3_46, IslandStrollNpcUnit) and var3_46:GetDataVO():ExistActionFeedback() then
		arg0_46.npcActionPlayer:Resopon(var3_46, arg0_46.player, arg1_46)
	else
		arg0_46.npcActionPlayer:ResoponByRandom(arg0_46.player, arg1_46)
	end
end

function var0_0.OnShowNpcAniamtionBubble(arg0_47, arg1_47)
	local var0_47 = arg0_47:GetStrollUnitModule(arg1_47.id)

	if not var0_47 then
		return
	end

	local var1_47 = arg1_47:GetActionFeedback()

	arg0_47:GetSubView(IslandBottomHeadHudView):ShowAnimationOp(var0_47, var1_47)
end

function var0_0.OnHideNpcAniamtionBubble(arg0_48, arg1_48)
	local var0_48 = arg0_48:GetStrollUnitModule(arg1_48.id)

	arg0_48:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var0_48)
end

function var0_0.OnStartDoCoupleAction(arg0_49)
	arg0_49:GetSubView(IslandCancelAnimationOpView):ShowCancelableAnimationOp(arg0_49.player)
end

function var0_0.OnEndDoCoupleAction(arg0_50)
	arg0_50:GetSubView(IslandCancelAnimationOpView):HideCancelableAnimationOp(arg0_50.player)
end

function var0_0.OnResponAniamtionOp(arg0_51, arg1_51)
	local var0_51 = arg1_51.id
	local var1_51 = arg1_51.targetId
	local var2_51 = arg1_51.actionId
	local var3_51 = arg0_51:GetPlayerUnitModule(var0_51)

	if not var3_51 then
		return
	end

	if var2_51 == 0 then
		if not arg0_51:IsPlayer(var0_51) then
			arg0_51:GetSubView(IslandTopHeadHudView):HideAnimationOp(var3_51)
		else
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_51, 1, 0, 0, 0))
		end

		return
	end

	local var4_51 = pg.island_action[var2_51]

	if var1_51 == 0 and var4_51.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_51:IsPlayer(var0_51) then
		arg0_51:GetSubView(IslandTopHeadHudView):ShowAnimationOp(var3_51, var2_51)
	elseif var1_51 > 0 and var4_51.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_51:IsPlayer(var1_51) then
		local var5_51 = arg0_51:GetPlayerUnitModule(var1_51)

		arg0_51.coupleActionPlayer:Play(var3_51, var5_51, var4_51)
		arg0_51:GetSubView(IslandTopHeadHudView):HideAnimationOp(var5_51)
	elseif var1_51 > 0 and var4_51.type == IslandConst.ANIMATION_OP_DOUBLE and arg0_51:IsPlayer(var1_51) then
		local var6_51 = arg0_51:GetPlayerUnitModule(var1_51)

		arg0_51.coupleActionPlayer:Play(var3_51, var6_51, var4_51)
		arg0_51:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_51, 1, var1_51, 0, 1))
	end
end

function var0_0.OnShowChatMsg(arg0_52, arg1_52)
	local var0_52 = arg1_52.player.id
	local var1_52 = arg0_52:GetPlayerUnitModule(var0_52)

	if not var1_52 then
		return
	end

	arg0_52:GetSubView(IslandTopHeadHudView):PlayChat(var1_52, arg1_52.emojiId, arg1_52.content, nil)
end

function var0_0.OnChatRoomChange(arg0_53)
	arg0_53:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_54)
	arg0_54:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnFollowerAdd(arg0_55, arg1_55)
	arg0_55:GetSubView(IslandOpView):FlushFollowerList()
	arg0_55.coupleNpcWordPlayer:Play(arg1_55)
end

function var0_0.OnFollowerDel(arg0_56, arg1_56)
	arg0_56:GetSubView(IslandOpView):FlushFollowerList()
	arg0_56.coupleNpcWordPlayer:Stop(arg1_56)
end

function var0_0.OnResetFollowRandomizer(arg0_57, arg1_57)
	local var0_57 = arg0_57:GetFollowerModule(arg1_57)

	if not var0_57 then
		return
	end

	var0_57:SetBtRandomizer()
end

function var0_0.OnGenPathFinder(arg0_58, arg1_58)
	local var0_58 = IslandPathFinder.New(arg0_58)
	local var1_58 = defaultValue(arg1_58.navData.waitUntilDone, false)

	var0_58:Start(arg1_58.navData, function()
		table.removebyvalue(arg0_58.pathfinders, var0_58)
		var0_58:Dispose()

		if arg1_58.onEndAction then
			arg1_58.onEndAction()
		end

		arg0_58:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH_DONE, arg1_58.navData.index)

		if var1_58 and arg1_58.callback then
			arg1_58.callback()
		end
	end)
	arg0_58:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH, arg1_58.navData.index)

	if not var1_58 and arg1_58.callback then
		arg1_58.callback()
	end

	table.insert(arg0_58.pathfinders, var0_58)
end

function var0_0.OnRemovePathFinder(arg0_60, arg1_60)
	local var0_60 = arg0_60:GetUnitModuleWithType(arg1_60.unitType, arg1_60.unitId)
	local var1_60 = _.detect(arg0_60.pathfinders, function(arg0_61)
		return arg0_61:IsSameUnit(var0_60)
	end)

	if not var1_60 then
		return
	end

	var1_60:Stop()
	var1_60:Dispose()
	table.removebyvalue(arg0_60.pathfinders, var1_60)
end

function var0_0.OnTracking(arg0_62, arg1_62)
	local var0_62 = arg1_62.trackType

	if var0_62 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_62.mainTrackId = tonumber(arg1_62.id)
		arg0_62.needTryMainTrack = true
	elseif var0_62 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_62.trackId = tonumber(arg1_62.id)
		arg0_62.trackType = arg1_62.typ or IslandTaskType.MAIN
		arg0_62.needTryTrack = true
	end
end

function var0_0.TryTrack(arg0_63)
	arg0_63:TrySetTrack(arg0_63.trackId)
end

function var0_0.TrySetTrack(arg0_64, arg1_64)
	local var0_64 = arg0_64:GetOptTrackingTarget(arg1_64)

	if not var0_64 or not var0_64._go then
		return
	end

	arg0_64:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_64.player, var0_64, arg1_64, arg0_64.trackType, IslandTaskTrackCard.TYPES.OTHER)

	arg0_64.needTryTrack = false
end

function var0_0.TryMainTrack(arg0_65)
	arg0_65:TrySetMainTrack(arg0_65.mainTrackId)
end

function var0_0.TrySetMainTrack(arg0_66, arg1_66)
	local var0_66 = arg0_66:GetOptTrackingTarget(arg1_66)

	if not var0_66 or not var0_66._go then
		return
	end

	arg0_66:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_66.player, var0_66, arg1_66, IslandTaskType.MAIN, IslandTaskTrackCard.TYPES.MAIN)

	arg0_66.needTryMainTrack = false
end

function var0_0.OnUnTracking(arg0_67, arg1_67)
	if arg1_67 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_67.mainTrackId = nil
	elseif arg1_67 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_67.trackId = nil
	end

	arg0_67:GetSubView(IslandDistanceView):CancelTracking(arg1_67)
end

local function var1_0(arg0_68, arg1_68)
	local var0_68 = pg.island_world_objects[arg0_68]

	if not var0_68 then
		return
	end

	return var0_68.mapId == arg1_68
end

local function var2_0(arg0_69, arg1_69, arg2_69)
	for iter0_69, iter1_69 in ipairs(arg0_69) do
		for iter2_69, iter3_69 in ipairs(iter1_69[2]) do
			local var0_69 = pg.island_interaction[iter3_69]

			if var0_69.type == arg2_69 and var1_0(tonumber(var0_69.param), arg1_69) then
				return iter1_69[1]
			end
		end
	end

	return nil
end

local function var3_0(arg0_70)
	local var0_70 = {}
	local var1_70 = {}

	for iter0_70, iter1_70 in ipairs(arg0_70) do
		for iter2_70, iter3_70 in ipairs(iter1_70[2]) do
			local var2_70 = pg.island_interaction[iter3_70]

			if var2_70.type == IslandInteractionUntil.TYPE_TRANSFER then
				table.insert(var0_70, iter1_70[1])
			elseif var2_70.type == IslandInteractionUntil.TYPE_SP_TRANSFER then
				table.insert(var1_70, iter1_70[1])
			end
		end
	end

	if #var1_70 > 0 then
		return var1_70[1]
	end

	if #var0_70 > 0 then
		return var0_70[1]
	end

	return nil
end

function var0_0.GetOptTrackingTarget(arg0_71, arg1_71)
	local var0_71 = arg0_71:GetUnitModule(arg1_71)

	if var0_71 then
		return var0_71
	end

	local var1_71 = pg.island_world_objects[arg1_71]

	if not var1_71 then
		return nil
	end

	local var2_71 = {}

	for iter0_71, iter1_71 in ipairs(arg0_71:GetUnitListByKey(IslandConst.UNIT_LIST_OBJ)) do
		local var3_71, var4_71 = iter1_71:IsMapTransfer()

		if var3_71 then
			table.insert(var2_71, {
				iter1_71,
				var4_71
			})
		end
	end

	local var5_71
	local var6_71 = var2_0(var2_71, var1_71.mapId, IslandInteractionUntil.TYPE_TRANSFER) or var2_0(var2_71, var1_71.mapId, IslandInteractionUntil.TYPE_SP_TRANSFER)

	var6_71 = var6_71 or var3_0(var2_71)

	return var6_71
end

function var0_0.OnOpenAniamtionOpPage(arg0_72)
	arg0_72:GetSubView(IslandAniamtionOpView):TryEnable()
	arg0_72:GetSubView(IslandOpView):TryDisable()
	arg0_72:NotifiyIsland(ISLAND_EX_EVT.OPEN_ANIMATION_OP)
end

function var0_0.OnCloseAniamtionOpPage(arg0_73)
	arg0_73:GetSubView(IslandOpView):TryEnable()
	arg0_73:NotifiyIsland(ISLAND_EX_EVT.CLOSE_ANIMATION_OP)
end

function var0_0.OnAnyPageOpen(arg0_74, arg1_74)
	arg0_74.anyPageOpen = true

	arg0_74.player:StopMoveHandle()
	arg0_74:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_74:GetSubView(IslandSlotHudView):TryDisable()
	arg0_74:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_74:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_74:GetSubView(IslandAniamtionOpView):CloseAndReset()
end

function var0_0.OnAllPageClose(arg0_75)
	arg0_75.anyPageOpen = false

	arg0_75:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_75:GetSubView(IslandSlotHudView):TryEnable()
	arg0_75:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_75:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnStartStory(arg0_76)
	arg0_76.playingStory = true

	arg0_76:DisablePlayerOp()
end

function var0_0.OnEndStory(arg0_77)
	arg0_77.playingStory = false

	arg0_77:EnablePlayerOp()
end

function var0_0.OnStartPerformance(arg0_78)
	return
end

function var0_0.OnEndPerformance(arg0_79)
	if not arg0_79.anyPageOpen then
		arg0_79:GetSubView(IslandOpView):ResetShowBalance()
	end
end

function var0_0.OnStartGuide(arg0_80)
	arg0_80.player:StopMoveHandle()
	arg0_80:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_81)
	if arg0_81.playingStory then
		return
	end

	arg0_81:GetSubView(IslandOpView):EnableInput()
end

function var0_0.InitFocusCamera(arg0_82)
	local var0_82 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)

	var0_82.Follow = arg0_82.player._tf
	var0_82.LookAt = arg0_82.player._tf
end

function var0_0.InitTakePhotoCamera(arg0_83)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).Follow = arg0_83.firstTakePhotoItem._tf

	local var0_83 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)

	var0_83.Follow = arg0_83.thirdTakePhotoItem._tf
	var0_83.LookAt = arg0_83.thirdTakePhotoItem._tf
end

function var0_0.DisablePlayerOp(arg0_84)
	arg0_84.player:StopMoveHandle()
	arg0_84:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_84:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_84:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_84:GetSubView(IslandOpView):TryDisable()
end

function var0_0.EnablePlayerOp(arg0_85)
	arg0_85:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_85:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_85:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_85:GetSubView(IslandOpView):TryEnable()
end

function var0_0.OnInterActionBegin(arg0_86)
	arg0_86.player:StopMoveHandle()
	arg0_86:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_87)
	arg0_87:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_88, arg1_88)
	arg0_88.showInterObjId = arg1_88.id

	arg0_88:GetSubView(IslandInteractionView):ShowInterActionPanel(arg1_88)
	arg0_88:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_88.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_89, arg1_89)
	if arg0_89.showInterObjId ~= arg1_89.id then
		return
	end

	arg0_89.showInterObjId = nil

	arg0_89:GetSubView(IslandInteractionView):HideInterActionPanel()
end

function var0_0.OnRefreshInteractionBtn(arg0_90)
	arg0_90:GetSubView(IslandInteractionView):RefreshInteractionBtns()
end

function var0_0.OnSetOpMoveBtnActve(arg0_91, arg1_91, arg2_91)
	arg0_91:GetSubView(IslandOpView):ShowOrHideMoveBtn(arg1_91, arg2_91)
end

function var0_0.DisableInput(arg0_92)
	arg0_92.player:StopMoveHandle()
	arg0_92:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_93)
	arg0_93:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnUpdateCustomOpPositon(arg0_94)
	arg0_94:GetSubView(IslandOpView):InitOpCustumPositon()
end

function var0_0.OnChange_Photo_Height(arg0_95, arg1_95, arg2_95)
	arg0_95.takePhotoModel = arg1_95

	if arg0_95.takePhotoModel == IslandConst.TakePhotoModel.First then
		-- block empty
	elseif arg0_95.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_95.thirdTakePhotoItem:ChangeHeight(arg2_95)
	end
end

function var0_0.OnChangeTakePhotoModel(arg0_96, arg1_96, arg2_96)
	arg0_96.takePhotoModel = arg1_96

	if arg0_96.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_96.firstTakePhotoItem:Enable()

		arg0_96.firstTakePhotoItem._tf.position = arg0_96.player._tf.position
		arg0_96.firstTakePhotoItem._tf.rotation = arg0_96.player._tf.rotation

		arg0_96.firstTakePhotoItem:SetTargetRotation(arg0_96.player._tf.rotation)
		arg0_96.player:SetActiveByLayer(false)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook)):SetPosAndRotationByTargetDir(arg0_96.player._tf.forward)
	elseif arg0_96.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_96.thirdTakePhotoItem:Enable()

		arg0_96.player._tf.position = arg0_96.firstTakePhotoItem._tf.position
		arg0_96.player._tf.rotation = arg0_96.firstTakePhotoItem._tf.rotation

		arg0_96.player:SetTargetRotation(arg0_96.firstTakePhotoItem._tf.rotation)
		arg0_96.player:SetActiveByLayer(true)

		arg0_96.thirdTakePhotoItem._tf.position = arg0_96.firstTakePhotoItem._tf:TransformPoint(Vector3(0, 0, -5))
		arg0_96.thirdTakePhotoItem._tf.rotation = arg0_96.firstTakePhotoItem._tf.rotation

		arg0_96.thirdTakePhotoItem:SetTargetRotation(arg0_96.firstTakePhotoItem._tf.rotation)

		local var0_96 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook))
		local var1_96 = arg0_96.player._tf.position + Vector3(0, 0.5, 0)
		local var2_96 = arg0_96.thirdTakePhotoItem._tf.position + Vector3(0, 1, 0)

		var0_96:SetPosAndRotationByTargetDir((var1_96 - var2_96).normalized)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	else
		arg0_96.firstTakePhotoItem:Disable()
		arg0_96.thirdTakePhotoItem:Disable()

		arg0_96.player._tf.position = arg0_96.firstTakePhotoItem._tf.position
		arg0_96.player._tf.rotation = arg0_96.firstTakePhotoItem._tf.rotation

		arg0_96.player:SetTargetRotation(arg0_96.firstTakePhotoItem._tf.rotation)
		arg0_96.player:SetActiveByLayer(true)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraLook)):ResetCameraPos()
	end

	arg0_96:GetSubView(IslandOpView):ChangeTakePhotoModel(arg1_96, arg2_96)
end

function var0_0.OnNpcDetectorSelected(arg0_97, arg1_97)
	if arg0_97.selectedNpcId then
		return
	end

	local var0_97 = arg1_97.node

	if not var0_97 then
		return
	end

	local var1_97 = var0_97:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_97.selectedNpcId = var1_97

	arg0_97:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_97, true)
	arg0_97:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_97, true)
end

function var0_0.GetSelectedNpcId(arg0_98)
	return arg0_98.selectedNpcId
end

function var0_0.OnNpcDetectorUnSelected(arg0_99, arg1_99)
	local var0_99 = arg1_99.node

	if not var0_99 then
		return
	end

	local var1_99 = var0_99:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_99:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_99)
	arg0_99:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_99)

	if arg0_99.selectedNpcId ~= var1_99 then
		return
	end

	arg0_99.selectedNpcId = nil
end

function var0_0.OnDetectorChanged(arg0_100, arg1_100)
	local var0_100 = arg1_100.node

	if not var0_100 then
		return
	end

	local var1_100 = var0_100:GetBlackboardVariable("DetectorList")

	for iter0_100 = 1, var1_100.Count do
		local var2_100 = var1_100[iter0_100 - 1]
		local var3_100, var4_100 = IslandCalcUtil.GetTypeAndIdByUniqueId(var2_100)

		if var3_100 == IslandConst.UNIT_LIST_OBJ then
			local var5_100 = arg0_100:GetUnitModuleWithType(var3_100, var4_100)

			if var5_100 then
				arg0_100:Op("NotifiyIsland", ISLAND_EX_EVT.APPROACH_OBJECT, var5_100.id)
			end
		end
	end
end

function var0_0.OnDetectorSelected(arg0_101, arg1_101)
	local var0_101 = arg1_101.node

	if not var0_101 then
		return
	end

	local var1_101 = var0_101:GetBlackboardVariable("AnyOne")

	if not var1_101 or var1_101 == "" then
		arg0_101:OnClearSelectedUnit()
	else
		local var2_101, var3_101 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_101)
		local var4_101 = arg0_101:GetUnitModuleWithType(var2_101, var3_101)

		if var4_101 then
			arg0_101:OnSelectedUnit(var4_101)
		end
	end
end

function var0_0.OnClearSelectedUnit(arg0_102)
	return
end

function var0_0.OnSelectedUnit(arg0_103, arg1_103)
	return
end

function var0_0.OnPlayChatBubble(arg0_104, arg1_104)
	local var0_104 = arg0_104:GetAllUnits()

	arg0_104:GetSubView(IslandTopHeadHudView):PlayBubble(arg1_104.name, var0_104, arg1_104.callback)
end

function var0_0.OnRawPlayChatBubble(arg0_105, arg1_105)
	local var0_105 = arg0_105:GetAllUnits()

	arg0_105:GetSubView(IslandTopHeadHudView):RawPlayBubble(arg1_105.info, var0_105, arg1_105.callback)
end

function var0_0.OnRawStopChatBubble(arg0_106, arg1_106)
	arg0_106:GetSubView(IslandTopHeadHudView):RawStopBubble(arg1_106.info)
end

function var0_0.OnChangeVisterDress(arg0_107, arg1_107)
	local var0_107 = arg1_107.id

	if arg0_107:IsPlayer(var0_107) then
		return
	end

	local var1_107 = arg0_107:GetPlayerUnitModule(var0_107)

	if var1_107 then
		var1_107:OnChangeDress(arg1_107.changeDressData)
	end
end

function var0_0.OnSystemUnlock(arg0_108, arg1_108)
	if arg1_108 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_108:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.OnSceneInited(arg0_109, arg1_109)
	IslandCameraMgr.instance:LookAt(arg0_109.player._tf)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraZoom)):SetMaxMinZoom(arg1_109.min, arg1_109.max, arg1_109.value)
	arg0_109:InitFocusCamera()
	arg0_109:InitTakePhotoCamera()
	arg0_109:GetSubView(IslandOpView):LaterInit()
end

function var0_0.OnGenUnit(arg0_110, arg1_110, arg2_110)
	local var0_110 = arg0_110.unitBuilders[arg1_110:GetType()]:Build(arg1_110, arg2_110)

	arg0_110:AddUnit(var0_110)

	if arg1_110:IsPlayer() then
		arg0_110.player = var0_110
	end

	if arg1_110:IsFirstTakePhoto() then
		arg0_110.firstTakePhotoItem = var0_110
	end

	if arg1_110:IsThirdTakePhoto() then
		arg0_110.thirdTakePhotoItem = var0_110
	end
end

function var0_0.OnGenSystem(arg0_111, arg1_111)
	local var0_111 = arg0_111.systemBuilders[arg1_111:GetType()]:Build(arg1_111)

	arg0_111:AddUnit(var0_111)
end

function var0_0.IsPlayer(arg0_112, arg1_112)
	return arg0_112.player.id == arg1_112
end

function var0_0.OnActiveOrDisactiveUnit(arg0_113, arg1_113, arg2_113, arg3_113)
	local var0_113

	if arg1_113 == 0 then
		var0_113 = arg0_113.player
	else
		var0_113 = arg0_113:GetUnitModuleWithType(arg2_113, arg1_113)
	end

	if var0_113 and arg3_113 then
		var0_113:Enable()
	end

	if var0_113 and not arg3_113 then
		var0_113:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_114, arg1_114, arg2_114, arg3_114)
	local var0_114 = arg0_114:GetUnitModuleWithType(arg2_114, arg1_114)

	if var0_114 then
		var0_114._go.transform.position = arg3_114
	end
end

function var0_0.OnResetUnitRotation(arg0_115, arg1_115, arg2_115, arg3_115)
	local var0_115 = arg0_115:GetUnitModuleWithType(arg2_115, arg1_115)

	if var0_115 then
		var0_115._go.transform.eulerAngles = arg3_115
	end
end

function var0_0.OnMoveUnit(arg0_116, arg1_116)
	assert(arg1_116.type, "type should be exist")

	local var0_116 = arg0_116:GetUnitModuleWithType(arg1_116.type, arg1_116.id)

	if var0_116 then
		var0_116:SetDestination(arg1_116.position, arg1_116.speed, nil, arg1_116.charaRadius)
	end
end

function var0_0.OnStopUnit(arg0_117, arg1_117)
	assert(arg1_117.type, "type should be exist")

	local var0_117 = arg0_117:GetUnitModuleWithType(arg1_117.type, arg1_117.id)

	if var0_117 then
		var0_117:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_118, arg1_118, arg2_118)
	local var0_118 = arg0_118:GetUnitListByKey(arg1_118)
	local var1_118 = 0

	for iter0_118, iter1_118 in ipairs(var0_118 or {}) do
		if iter1_118.id == arg2_118 then
			var1_118 = iter0_118

			break
		end
	end

	if var1_118 > 0 then
		local var2_118 = var0_118[var1_118]

		for iter2_118 = #arg0_118.pathfinders, 1, -1 do
			local var3_118 = arg0_118.pathfinders[iter2_118]

			if var3_118:IsSameUnit(var2_118) then
				var3_118:Dispose()
				table.remove(arg0_118.pathfinders, iter2_118)
			end
		end

		arg0_118:RemoveUnit(var2_118)
		var2_118:Dispose()
		arg0_118:OnHideUnitHudAndOpBtn({
			type = arg1_118,
			id = var2_118.id
		}, true)
		arg0_118:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_118,
			id = arg2_118
		})
		arg0_118:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var2_118)
		arg0_118:GetSubView(IslandInteractionView):CloseInterActionPanelByUnitIdRemove(arg2_118)
	end
end

function var0_0.GetAllUnits(arg0_119)
	table.clear(arg0_119._unitList)

	for iter0_119, iter1_119 in pairs(arg0_119:GetUnitListRegitser()) do
		for iter2_119, iter3_119 in pairs(iter1_119) do
			table.insert(arg0_119._unitList, iter3_119)
		end
	end

	return arg0_119._unitList
end

function var0_0.GetUnitModuleWithType(arg0_120, arg1_120, arg2_120)
	if arg1_120 == IslandConst.UNIT_LIST_PLAYER and arg2_120 == 0 then
		return arg0_120.player
	end

	local var0_120 = arg0_120:GetUnitListByKey(arg1_120)

	for iter0_120, iter1_120 in ipairs(var0_120) do
		if iter1_120.id == arg2_120 then
			return iter1_120
		end
	end

	return nil
end

function var0_0.GetPlayerUnitModule(arg0_121, arg1_121)
	return arg0_121:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_121)
end

function var0_0.GetUnitModule(arg0_122, arg1_122)
	return arg0_122:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_122)
end

function var0_0.GetSystemModule(arg0_123, arg1_123)
	return arg0_123:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_123)
end

function var0_0.GetProductSystemModule(arg0_124, arg1_124)
	return arg0_124:GetUnitModuleWithType(IslandConst.UNIT_LIST_PRODUCT_SYSTEM, arg1_124)
end

function var0_0.GetSystemUnitModule(arg0_125, arg1_125)
	return arg0_125:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_125)
end

function var0_0.GetStrollUnitModule(arg0_126, arg1_126)
	return arg0_126:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_126)
end

function var0_0.GetManageSystemModule(arg0_127, arg1_127)
	return arg0_127:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_127)
end

function var0_0.GetFollowerModule(arg0_128, arg1_128)
	return arg0_128:GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg1_128)
end

function var0_0.OnMovePlayerBefore(arg0_129)
	if arg0_129.player:CheckMovement() and arg0_129.isLockPlayInput then
		arg0_129.isLockPlayInput = false
	end

	arg0_129:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnLockPlayerInput(arg0_130)
	if arg0_130.playerInputing then
		arg0_130.isLockPlayInput = true

		arg0_130.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerMove(arg0_131, arg1_131)
	if arg0_131.isLockPlayInput then
		return
	end

	arg0_131.playerInputing = true

	if arg0_131.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_131.firstTakePhotoItem:MoveHandle(arg1_131.targetDir, arg1_131.force)
	elseif arg0_131.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_131.thirdTakePhotoItem:MoveHandle(arg1_131.targetDir, arg1_131.force)
	else
		arg0_131.player:MoveHandle(arg1_131.targetDir, arg1_131.force)
	end
end

function var0_0.OnPlayerStopMove(arg0_132)
	if arg0_132.isLockPlayInput then
		arg0_132.isLockPlayInput = false
	end

	arg0_132.playerInputing = true

	if arg0_132.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_132.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_132.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_132.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_132.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerStopMoveHandle(arg0_133)
	if arg0_133.isLockPlayInput then
		arg0_133.isLockPlayInput = false
	end

	arg0_133.playerInputing = true

	if arg0_133.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_133.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_133.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_133.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_133.player:StopMoveHandleByInput()
	end
end

function var0_0.OnPlayerJump(arg0_134)
	if arg0_134.takePhotoModel == IslandConst.TakePhotoModel.First or arg0_134.takePhotoModel == IslandConst.TakePhotoModel.Third then
		return
	end

	arg0_134.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_135)
	arg0_135.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_136)
	if arg0_136.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_136.firstTakePhotoItem:OnPlayerPlayerSprint()
	elseif arg0_136.takePhotoModel == IslandConst.TakePhotoModel.Third then
		-- block empty
	else
		arg0_136.player:OnPlayerPlayerSprint()
	end
end

function var0_0.OnStopPlayerSprint(arg0_137)
	if arg0_137.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_137.firstTakePhotoItem:OnStopPlayerSprint()
	elseif arg0_137.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_137.thirdTakePhotoItem:OnStopPlayerSprint()
	else
		arg0_137.player:OnStopPlayerSprint()
	end
end

function var0_0.OnPlayerWork(arg0_138, arg1_138, arg2_138)
	arg0_138.player:WorkHandle(arg1_138, arg2_138)
end

function var0_0.OnPlayerDeviceStateChange(arg0_139, arg1_139)
	arg0_139.player:DeviceStateHandle(arg1_139)
end

function var0_0.OnSetVisitorSyncData(arg0_140, arg1_140, arg2_140)
	local var0_140 = arg0_140:GetPlayerUnitModule(arg1_140)

	if var0_140 then
		var0_140:UpdateSyncData(arg2_140)
	end
end

function var0_0.OnWorldObjectStartInteraction(arg0_141, arg1_141, arg2_141, arg3_141)
	local var0_141 = arg2_141:GetHostId()
	local var1_141 = arg2_141:GetUserId()
	local var2_141 = arg0_141:GetUnitModule(var0_141)
	local var3_141 = arg0_141:GetPlayerUnitModule(var1_141)
	local var4_141 = arg0_141.player == var3_141

	if var4_141 then
		arg0_141:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_141 = arg1_141:GetTimeline()[arg3_141]
	local var6_141 = arg1_141:GetBlackboardParam()[arg3_141]

	var2_141:StartInteract(var3_141, arg2_141.id, arg3_141, var5_141, var6_141, arg1_141:AnySlotUsing(), var4_141)
end

function var0_0.OnWorldObjectEndInteraction(arg0_142, arg1_142, arg2_142)
	local var0_142 = arg2_142:GetHostId()
	local var1_142 = arg2_142:GetUserId()
	local var2_142 = arg0_142:GetUnitModule(var0_142)
	local var3_142 = arg0_142:GetPlayerUnitModule(var1_142)
	local var4_142 = arg0_142.player == var3_142

	if var4_142 then
		arg0_142:GetSubView(IslandOpView):EndInteraction()
	end

	var2_142:EndInteract(var3_142, arg2_142.id, not arg1_142:AnySlotUsing(), var4_142)
end

function var0_0.OnWorldObjectInitStatus(arg0_143, arg1_143, arg2_143)
	local var0_143 = arg0_143:GetUnitModule(arg1_143.id)
	local var1_143 = arg1_143:GetTimeline()[arg2_143]
	local var2_143 = arg1_143:GetBlackboardParam()[arg2_143]

	var0_143:InitStatus(arg2_143, var1_143, var2_143)
end

function var0_0.InitInteractionOpView(arg0_144)
	arg0_144:GetSubView(IslandOpView):EndInteraction()
end

function var0_0.OnPlayerAreaChange(arg0_145)
	arg0_145.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_146, arg1_146, arg2_146)
	arg0_146.player:OnChangeDress(arg1_146, arg2_146)
end

function var0_0.OnCharacterChangeDress(arg0_147, arg1_147, arg2_147, arg3_147, arg4_147)
	local var0_147 = arg0_147:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_147)

	if var0_147 then
		var0_147:OnCharacterChangeDress(arg2_147, arg3_147, arg4_147)
	end

	local var1_147 = arg0_147:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_147, iter1_147 in ipairs(var1_147) do
		if iter1_147:GetDataVO():IsSameShip(arg1_147) then
			iter1_147:OnCharacterChangeDress(arg2_147, arg3_147, arg4_147)
		end
	end

	local var2_147 = arg0_147:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter2_147, iter3_147 in ipairs(var2_147) do
		if iter3_147:GetDataVO():IsSameShip(arg1_147) then
			iter3_147:OnCharacterChangeDress(arg2_147, arg3_147, arg4_147)
		end
	end
end

function var0_0.OnStartDelegation(arg0_148, arg1_148, arg2_148)
	local var0_148 = arg0_148:GetSystemModule(arg1_148.build_id)

	if var0_148 then
		var0_148:StartDelegation(arg1_148)
	end

	local var1_148 = arg0_148:GetProductSystemModule(arg1_148.build_id)

	if var1_148 then
		var1_148:StartDelegation(arg2_148)
	end
end

function var0_0.OnEndDelegation(arg0_149, arg1_149, arg2_149)
	local var0_149 = arg0_149:GetSystemModule(arg1_149.build_id)

	if var0_149 then
		var0_149:EndDelegation(arg1_149)
	end
end

function var0_0.GetPlayerPosition(arg0_150)
	return arg0_150.player:GetCurrentPosition()
end

function var0_0.GetUnitPosition(arg0_151, arg1_151)
	local var0_151 = arg0_151:GetUnitModule(arg1_151)

	return var0_151 and var0_151._go.transform.position
end

function var0_0.OnShowUnitHudAndOpBtn(arg0_152, arg1_152)
	arg0_152.currentHudUnitData = arg1_152

	arg0_152:GetSubView(IslandSlotHudView):ShowHud(arg1_152.id, arg1_152.height)
	arg0_152:GetSubView(IslandOpView):UpdateOperationButton(arg1_152.operationType, arg1_152.id)

	if arg1_152.isHighLightControl then
		arg0_152.detectionSystem:HighLightUnitHandle(arg1_152.id, true)
	end
end

function var0_0.OnHideUnitHudAndOpBtn(arg0_153, arg1_153, arg2_153)
	if not arg0_153.currentHudUnitData then
		return
	end

	if arg0_153.currentHudUnitData.id ~= arg1_153.id or arg0_153.currentHudUnitData.type ~= arg1_153.type then
		return
	end

	if not arg2_153 then
		arg0_153.currentHudUnitData = nil
	end

	arg0_153:GetSubView(IslandSlotHudView):HideUnitHud(arg1_153.id)
	arg0_153:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_153.id)

	if arg1_153.isHighLightControl then
		arg0_153.detectionSystem:HighLightUnitHandle(arg1_153.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_154, arg1_154)
	if not arg0_154.currentHudUnitData then
		return
	end

	if arg1_154 ~= arg0_154.currentHudUnitData.id then
		return
	end

	arg0_154:GetSubView(IslandSlotHudView):UpdateHud(arg0_154.currentHudUnitData.id, arg0_154.currentHudUnitData.height)
	arg0_154:GetSubView(IslandOpView):UpdateOperationButton(arg0_154.currentHudUnitData.operationType, arg0_154.currentHudUnitData.id)
end

function var0_0.OnUpdateHandCollectUnit(arg0_155, arg1_155)
	local var0_155 = arg0_155:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_155)

	if var0_155 then
		var0_155:UpdateHandCollet()
		var0_155:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_156, arg1_156)
	arg0_156:GetSubView(IslandTopHeadHudView):ShowHud(arg1_156)
	arg0_156:GetSubView(IslandDistanceView):ShowHud(arg1_156.id)
end

function var0_0.OnRefreshHud(arg0_157, arg1_157)
	arg0_157:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_157)
end

function var0_0.OnHideHud(arg0_158, arg1_158)
	arg0_158:GetSubView(IslandTopHeadHudView):HideHud(arg1_158)
	arg0_158:GetSubView(IslandDistanceView):HideHud(arg1_158.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_159, arg1_159)
	local var0_159 = arg0_159:GetUnitModuleWithType(arg1_159.type, arg1_159.id)

	if var0_159 then
		var0_159:DelegateSlotStartPerform()
	end
end

function var0_0.OnRecycleAllSlotEffct(arg0_160)
	arg0_160.effectMgr:RecycleAllSlotEffct()
end

function var0_0.OnLoadDelegatePreviewRole(arg0_161, arg1_161, arg2_161)
	arg0_161.effectMgr:LoadDelegatePreviewRole(arg1_161, arg2_161)
end

function var0_0.OnUnLoadDelegatePreviewRole(arg0_162)
	arg0_162.effectMgr:UnLoadDelegatePreviewRole()
end

function var0_0.OnSelectSlotEffectShow(arg0_163, arg1_163, arg2_163, arg3_163, arg4_163)
	arg0_163.effectMgr:SelectSlotEffectShow(arg1_163, arg2_163, arg3_163, arg4_163)
end

function var0_0.OnTakePlantAttack(arg0_164, arg1_164)
	local var0_164 = arg0_164:GetUnitModuleWithType(arg1_164.type, arg1_164.id)

	if var0_164 then
		var0_164:TakeAttack()
	end
end

function var0_0.OnStartManage(arg0_165, arg1_165)
	local var0_165 = arg0_165:GetManageSystemModule(arg1_165.id)

	if var0_165 then
		var0_165:StartManage(arg1_165)
	end
end

function var0_0.OnEndManage(arg0_166, arg1_166)
	local var0_166 = arg0_166:GetManageSystemModule(arg1_166.id)

	if var0_166 then
		var0_166:EndManage(arg1_166)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_167)
	arg0_167:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnRefreshWeatherSystem(arg0_168)
	arg0_168.weatherSystem:Play()
end

function var0_0.OnDispose(arg0_169)
	arg0_169.detectionSystem:Dispose()
	arg0_169.effectMgr:Dispose()
	arg0_169.coupleActionPlayer:Dispose()
	arg0_169.coupleAction4FollowerPlayer:Dispose()
	arg0_169.npcActionPlayer:Dispose()
	arg0_169.weatherSystem:Dispose()
	arg0_169.coupleNpcWordPlayer:Dispose()
	arg0_169:GetPoolMgr():ClearFishingEffect()

	for iter0_169, iter1_169 in ipairs(arg0_169.views) do
		iter1_169:Dispose()
	end

	for iter2_169, iter3_169 in ipairs(arg0_169.pathfinders) do
		iter3_169:Dispose()
	end

	for iter4_169, iter5_169 in ipairs(arg0_169:GetAllUnits()) do
		iter5_169:Dispose()
	end

	for iter6_169, iter7_169 in pairs(arg0_169.unitBuilders) do
		iter7_169:Dispose()
	end

	for iter8_169, iter9_169 in pairs(arg0_169.systemBuilders) do
		iter9_169:Dispose()
	end

	for iter10_169, iter11_169 in pairs(arg0_169.fishingSynPlayers) do
		iter11_169:Dispose()
	end

	arg0_169.fishingSynPlayers = nil
	arg0_169.npcActionPlayer = nil
	arg0_169.coupleActionPlayer = nil
	arg0_169.coupleAction4FollowerPlayer = nil
	arg0_169.pathfinders = nil
	arg0_169.unitBuilders = nil
	arg0_169.systemBuilders = nil
	arg0_169.views = nil
	arg0_169.player = nil
	arg0_169.isInit = false
	arg0_169._unitList = nil
	arg0_169.detectionSystem = nil
	arg0_169.effectMgr = nil
	arg0_169.coupleNpcWordPlayer = nil
	arg0_169.weatherSystem = nil
end

return var0_0
