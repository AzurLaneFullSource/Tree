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
		arg0_2:CreateEffectView(),
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

function var0_0.CreateEffectView(arg0_7)
	return IslandEffectView.New(arg0_7)
end

function var0_0.CreateOpView(arg0_8)
	return IslandOpView.New(arg0_8)
end

function var0_0.CreateSlotHudView(arg0_9)
	return IslandSlotHudView.New(arg0_9)
end

function var0_0.CreateCancelAnimationOpView(arg0_10)
	return IslandCancelAnimationOpView.New(arg0_10)
end

function var0_0.CreateTopHeadHudView(arg0_11)
	return IslandTopHeadHudView.New(arg0_11)
end

function var0_0.CreateBottomHeadHudeView(arg0_12)
	return IslandBottomHeadHudView.New(arg0_12)
end

function var0_0.CreateAnimationOpView(arg0_13)
	return IslandAniamtionOpView.New(arg0_13)
end

function var0_0.CreateInteractionView(arg0_14)
	return IslandInteractionView.New(arg0_14)
end

function var0_0.CreateDistanceView(arg0_15)
	return IslandDistanceView.New(arg0_15)
end

function var0_0.CreateSeedOpView(arg0_16)
	return IslandSeedOpView.New(arg0_16)
end

function var0_0.IsLoaded(arg0_17)
	local var0_17 = arg0_17:GetAllUnits()

	return _.all(arg0_17.views, function(arg0_18)
		return arg0_18:IsLoaded()
	end) and #var0_17 > 0 and _.all(var0_17, function(arg0_19)
		return arg0_19:IsLoaded()
	end)
end

function var0_0.IsInit(arg0_20)
	return arg0_20.isInit
end

function var0_0.Update(arg0_21)
	if not arg0_21.isInit then
		return
	end

	for iter0_21, iter1_21 in ipairs(arg0_21:GetAllUnits()) do
		iter1_21:Update()
	end

	for iter2_21, iter3_21 in ipairs(arg0_21.views) do
		iter3_21:Update()
	end

	for iter4_21, iter5_21 in ipairs(arg0_21.pathfinders) do
		iter5_21:Update()
	end

	if arg0_21.needTryTrack then
		arg0_21:TryTrack()
	end

	if arg0_21.needTryMainTrack then
		arg0_21:TryMainTrack()
	end
end

function var0_0.LateUpdate(arg0_22)
	if not arg0_22.isInit then
		return
	end

	for iter0_22, iter1_22 in ipairs(arg0_22:GetAllUnits()) do
		iter1_22:LateUpdate()
	end

	for iter2_22, iter3_22 in ipairs(arg0_22.views) do
		iter3_22:LateUpdate()
	end

	for iter4_22, iter5_22 in ipairs(arg0_22.pathfinders) do
		iter5_22:LateUpdate()
	end
end

function var0_0.AddListeners(arg0_23)
	arg0_23:AddListener(ISLAND_EVT.GEN_UNIT, arg0_23.OnGenUnit)
	arg0_23:AddListener(ISLAND_EVT.RMOVE_UNIT, arg0_23.OnRemoveUnit)
	arg0_23:AddListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_23.OnInterActionBegin)
	arg0_23:AddListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_23.OnInterActionEnd)
	arg0_23:AddListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_23.OnStopUnit)
	arg0_23:AddListener(ISLAND_EVT.MOVE_UNIT, arg0_23.OnMoveUnit)
	arg0_23:AddListener(ISLAND_EVT.INIT_FINISH, arg0_23.OnSceneInited)
	arg0_23:AddListener(ISLAND_EVT.MOVE_PLAYER, arg0_23.OnPlayerMove)
	arg0_23:AddListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_23.OnPlayerStopMoveHandle)
	arg0_23:AddListener(ISLAND_EVT.JUMP_PLAYER, arg0_23.OnPlayerJump)
	arg0_23:AddListener(ISLAND_EVT.APPROACH_UNIT, arg0_23.OnShowInterActionPanel)
	arg0_23:AddListener(ISLAND_EVT.LEAVE_UNIT, arg0_23.OnHideInterActionPanel)
	arg0_23:AddListener(ISLAND_EVT.TRACKING, arg0_23.OnTracking)
	arg0_23:AddListener(ISLAND_EVT.UNTRACKING, arg0_23.OnUnTracking)
	arg0_23:AddListener(ISLAND_EVT.AREACHANGE, arg0_23.OnPlayerAreaChange)
	arg0_23:AddListener(ISLAND_EVT.PLAYERRUN, arg0_23.OnPlayerPlayerRun)
	arg0_23:AddListener(ISLAND_EVT.SPRINT_PLAYER, arg0_23.OnPlayerPlayerSprint)
	arg0_23:AddListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_23.OnStopPlayerSprint)
	arg0_23:AddListener(ISLAND_EVT.CHANGE_DRESS, arg0_23.OnChangeDress)
	arg0_23:AddListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_23.OnCharacterChangeDress)
	arg0_23:AddListener(ISLAND_EVT.MORPH_FORM_CHANGE, arg0_23.OnMorphFormChange)
	arg0_23:AddListener(ISLAND_EVT.RESET_UNIT_POS, arg0_23.OnResetUnitPos)
	arg0_23:AddListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_23.OnResetUnitRotation)
	arg0_23:AddListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_23.OnAnyPageOpen)
	arg0_23:AddListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_23.OnAllPageClose)
	arg0_23:AddListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_23.OnChangeTakePhotoModel)
	arg0_23:AddListener(ISLAND_EVT.Change_Photo_Height, arg0_23.OnChange_Photo_Height)
	arg0_23:AddListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_23.OnSetOpMoveBtnActve)
	arg0_23:AddListener(ISLAND_EVT.PLAY_BUBBLE, arg0_23.OnPlayChatBubble)
	arg0_23:AddListener(ISLAND_EVT.RAW_PLAY_BUBBLE, arg0_23.OnRawPlayChatBubble)
	arg0_23:AddListener(ISLAND_EVT.RAW_STOP_BUBBLE, arg0_23.OnRawStopChatBubble)
	arg0_23:AddListener(ISLAND_EVT.START_STORY, arg0_23.OnStartStory)
	arg0_23:AddListener(ISLAND_EVT.END_STORY, arg0_23.OnEndStory)
	arg0_23:AddListener(ISLAND_EVT.START_DEGATION, arg0_23.OnStartDelegation)
	arg0_23:AddListener(ISLAND_EVT.END_DEGATION, arg0_23.OnEndDelegation)
	arg0_23:AddListener(ISLAND_EVT.GEN_SYSTEM, arg0_23.OnGenSystem)
	arg0_23:AddListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_23.OnWorldObjectStartInteraction)
	arg0_23:AddListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_23.OnWorldObjectEndInteraction)
	arg0_23:AddListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_23.OnWorldObjectInitStatus)
	arg0_23:AddListener(ISLAND_EVT.INIT_INTERACTION_OP_VIEW, arg0_23.InitInteractionOpView)
	arg0_23:AddListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_23.OnRefreshInteractionBtn)
	arg0_23:AddListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_23.OnShowUnitHudAndOpBtn)
	arg0_23:AddListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_23.OnHideUnitHudAndOpBtn)
	arg0_23:AddListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_23.OnDetectorChanged)
	arg0_23:AddListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_23.OnDetectorSelected)
	arg0_23:AddListener(ISLAND_EVT.FISHPOINT_DETECTOR, arg0_23.OnFishPointSelected)
	arg0_23:AddListener(ISLAND_EVT.NPC_DETECTED, arg0_23.OnNpcDetectorSelected)
	arg0_23:AddListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_23.OnNpcDetectorUnSelected)
	arg0_23:AddListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_23.OnPlayerWork)
	arg0_23:AddListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_23.OnPlayerDeviceStateChange)
	arg0_23:AddListener(ISLAND_EVT.UPDATE_HUD, arg0_23.OnUpdateHud)
	arg0_23:AddListener(ISLAND_EVT.PLAY_EFFECT, arg0_23.OnPlayEffect)
	arg0_23:AddListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_23.OnUpdateHandCollectUnit)
	arg0_23:AddListener(ISLAND_EVT.START_DELEGATE_SLOT_PERFORM, arg0_23.OnDelegateSlotStartPerform)
	arg0_23:AddListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_23.OnRecycleAllSlotEffct)
	arg0_23:AddListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_23.OnSelectSlotEffectShow)
	arg0_23:AddListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_23.OnLoadDelegatePreviewRole)
	arg0_23:AddListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_23.OnUnLoadDelegatePreviewRole)
	arg0_23:AddListener(ISLAND_EVT.Take_Plant_Attact, arg0_23.OnTakePlantAttack)
	arg0_23:AddListener(ISLAND_EVT.START_MANAGE, arg0_23.OnStartManage)
	arg0_23:AddListener(ISLAND_EVT.END_MANAGE, arg0_23.OnEndManage)
	arg0_23:AddListener(ISLAND_EVT.SHOW_HUD, arg0_23.OnShowHud)
	arg0_23:AddListener(ISLAND_EVT.HIDE_HUD, arg0_23.OnHideHud)
	arg0_23:AddListener(ISLAND_EVT.REFRESH_HUD, arg0_23.OnRefreshHud)
	arg0_23:AddListener(ISLAND_EVT.START_GUIDE, arg0_23.OnStartGuide)
	arg0_23:AddListener(ISLAND_EVT.END_GUIDE, arg0_23.OnEndGuide)
	arg0_23:AddListener(ISLAND_EVT.START_PERFORMANCE, arg0_23.OnStartPerformance)
	arg0_23:AddListener(ISLAND_EVT.END_PERFORMANCE, arg0_23.OnEndPerformance)
	arg0_23:AddListener(ISLAND_EVT.DISABLE_INPUT, arg0_23.DisableInput)
	arg0_23:AddListener(ISLAND_EVT.ENABLE_INPUT, arg0_23.EnableInput)
	arg0_23:AddListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_23.OnGenPathFinder)
	arg0_23:AddListener(ISLAND_EVT.REMOVE_PATH_FINDER, arg0_23.OnRemovePathFinder)
	arg0_23:AddListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_23.OnActiveOrDisactiveUnit)
	arg0_23:AddListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_23.OnOpenAniamtionOpPage)
	arg0_23:AddListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_23.OnCloseAniamtionOpPage)
	arg0_23:AddListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_23.OnMovePlayerBefore)
	arg0_23:AddListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_23.OnRefreshTaskInfoHud)
	arg0_23:AddListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_23.OnResponAniamtionOp)
	arg0_23:AddListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_23.OnChangeVisterDress)
	arg0_23:AddListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_23.OnSetVisitorSyncData)
	arg0_23:AddListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_23.OnShowNpcAniamtionBubble)
	arg0_23:AddListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_23.OnHideNpcAniamtionBubble)
	arg0_23:AddListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_23.OnPlaySingleAnimationEnd)
	arg0_23:AddListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_23.OnUpdateCustomOpPositon)
	arg0_23:AddListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_23.OnChatMsgUpdate)
	arg0_23:AddListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_23.OnChatRoomChange)
	arg0_23:AddListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_23.OnShowChatMsg)
	arg0_23:AddListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_23.OnResetFollowRandomizer)
	arg0_23:AddListener(ISLAND_EVT.ADD_FOLLOWER, arg0_23.OnFollowerAdd)
	arg0_23:AddListener(ISLAND_EVT.WILL_DEL_FOLLOWER, arg0_23.OnFollowerWillDelStep1)
	arg0_23:AddListener(ISLAND_EVT.DO_DEL_FOLLOWER, arg0_23.OnFollowerWillDelStep2)
	arg0_23:AddListener(ISLAND_EVT.DEL_FOLLOWER, arg0_23.OnFollowerDel)
	arg0_23:AddListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_23.OnCoupleActionWithFollower)
	arg0_23:AddListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_23.OnLockPlayerInput)
	arg0_23:AddListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_23.OnStartCoupleAction)
	arg0_23:AddListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_23.OnEndCoupleAction)
	arg0_23:AddListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_23.OnRefreshWeatherSystem)
	arg0_23:AddListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_23.OnSystemUnlock)
	arg0_23:AddListener(ISLAND_EVT.START_DO_COUPLE_ACTION, arg0_23.OnStartDoCoupleAction)
	arg0_23:AddListener(ISLAND_EVT.END_DO_COUPLE_ACTION, arg0_23.OnEndDoCoupleAction)
	arg0_23:AddListener(ISLAND_EVT.CANCEL_COUPLE_ACTION, arg0_23.OnCancelCoupleAction)
	arg0_23:AddListener(ISLAND_EVT.BAIT_UPDATE, arg0_23.OnBaitUpdate)
	arg0_23:AddListener(ISLAND_EVT.START_FISHING, arg0_23.OnStartFishing)
	arg0_23:AddListener(ISLAND_EVT.FISHING_STATE_CHANGE, arg0_23.OnFishingStateChange)
	arg0_23:AddListener(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, arg0_23.OnAllDailyOrWeeklyFinish)
end

function var0_0.RemoveListeners(arg0_24)
	arg0_24:RemoveListener(ISLAND_EVT.GEN_UNIT, arg0_24.OnGenUnit)
	arg0_24:RemoveListener(ISLAND_EVT.RMOVE_UNIT, arg0_24.OnRemoveUnit)
	arg0_24:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_BEGIN, arg0_24.OnInterActionBegin)
	arg0_24:RemoveListener(ISLAND_EVT.INTERACTION_UNIT_END, arg0_24.OnInterActionEnd)
	arg0_24:RemoveListener(ISLAND_EVT.STOP_MOVE_UNIT, arg0_24.OnStopUnit)
	arg0_24:RemoveListener(ISLAND_EVT.MOVE_UNIT, arg0_24.OnMoveUnit)
	arg0_24:RemoveListener(ISLAND_EVT.INIT_FINISH, arg0_24.OnSceneInited)
	arg0_24:RemoveListener(ISLAND_EVT.MOVE_PLAYER, arg0_24.OnPlayerMove)
	arg0_24:RemoveListener(ISLAND_EVT.STOP_MOVE_PLAYER, arg0_24.OnPlayerStopMoveHandle)
	arg0_24:RemoveListener(ISLAND_EVT.JUMP_PLAYER, arg0_24.OnPlayerJump)
	arg0_24:RemoveListener(ISLAND_EVT.APPROACH_UNIT, arg0_24.OnShowInterActionPanel)
	arg0_24:RemoveListener(ISLAND_EVT.LEAVE_UNIT, arg0_24.OnHideInterActionPanel)
	arg0_24:RemoveListener(ISLAND_EVT.TRACKING, arg0_24.OnTracking)
	arg0_24:RemoveListener(ISLAND_EVT.UNTRACKING, arg0_24.OnUnTracking)
	arg0_24:RemoveListener(ISLAND_EVT.AREACHANGE, arg0_24.OnPlayerAreaChange)
	arg0_24:RemoveListener(ISLAND_EVT.PLAYERRUN, arg0_24.OnPlayerPlayerRun)
	arg0_24:RemoveListener(ISLAND_EVT.SPRINT_PLAYER, arg0_24.OnPlayerPlayerSprint)
	arg0_24:RemoveListener(ISLAND_EVT.STOP_SPRINT_PLAYER, arg0_24.OnStopPlayerSprint)
	arg0_24:RemoveListener(ISLAND_EVT.CHANGE_DRESS, arg0_24.OnChangeDress)
	arg0_24:RemoveListener(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg0_24.OnCharacterChangeDress)
	arg0_24:RemoveListener(ISLAND_EVT.MORPH_FORM_CHANGE, arg0_24.OnMorphFormChange)
	arg0_24:RemoveListener(ISLAND_EVT.RESET_UNIT_POS, arg0_24.OnResetUnitPos)
	arg0_24:RemoveListener(ISLAND_EVT.RESET_UNIT_ROT, arg0_24.OnResetUnitRotation)
	arg0_24:RemoveListener(ISLAND_EVT.ANY_PAGE_OPENED, arg0_24.OnAnyPageOpen)
	arg0_24:RemoveListener(ISLAND_EVT.Change_TakePhoto_Model, arg0_24.OnChangeTakePhotoModel)
	arg0_24:RemoveListener(ISLAND_EVT.Change_Photo_Height, arg0_24.OnChange_Photo_Height)
	arg0_24:RemoveListener(ISLAND_EVT.SetOpMoveBtnActve, arg0_24.OnSetOpMoveBtnActve)
	arg0_24:RemoveListener(ISLAND_EVT.ALL_PAGE_CLOSED, arg0_24.OnAllPageClose)
	arg0_24:RemoveListener(ISLAND_EVT.PLAY_BUBBLE, arg0_24.OnPlayChatBubble)
	arg0_24:RemoveListener(ISLAND_EVT.RAW_PLAY_BUBBLE, arg0_24.OnRawPlayChatBubble)
	arg0_24:RemoveListener(ISLAND_EVT.RAW_STOP_BUBBLE, arg0_24.OnRawStopChatBubble)
	arg0_24:RemoveListener(ISLAND_EVT.START_STORY, arg0_24.OnStartStory)
	arg0_24:RemoveListener(ISLAND_EVT.END_STORY, arg0_24.OnEndStory)
	arg0_24:RemoveListener(ISLAND_EVT.START_DEGATION, arg0_24.OnStartDelegation)
	arg0_24:RemoveListener(ISLAND_EVT.END_DEGATION, arg0_24.OnEndDelegation)
	arg0_24:RemoveListener(ISLAND_EVT.GEN_SYSTEM, arg0_24.OnGenSystem)
	arg0_24:RemoveListener(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, arg0_24.OnWorldObjectStartInteraction)
	arg0_24:RemoveListener(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, arg0_24.OnWorldObjectEndInteraction)
	arg0_24:RemoveListener(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, arg0_24.OnWorldObjectInitStatus)
	arg0_24:RemoveListener(ISLAND_EVT.INIT_INTERACTION_OP_VIEW, arg0_24.InitInteractionOpView)
	arg0_24:RemoveListener(ISLAND_EVT.REFRESH_INTERACTION, arg0_24.OnRefreshInteractionBtn)
	arg0_24:RemoveListener(ISLAND_EVT.SHOW_UNIT_HUD_OP, arg0_24.OnShowUnitHudAndOpBtn)
	arg0_24:RemoveListener(ISLAND_EVT.HIDE_UNIT_HUD_OP, arg0_24.OnHideUnitHudAndOpBtn)
	arg0_24:RemoveListener(ISLAND_EVT.DETECTOR_CHANGED, arg0_24.OnDetectorChanged)
	arg0_24:RemoveListener(ISLAND_EVT.SELECTED_DETECTOR, arg0_24.OnDetectorSelected)
	arg0_24:RemoveListener(ISLAND_EVT.FISHPOINT_DETECTOR, arg0_24.OnFishPointSelected)
	arg0_24:RemoveListener(ISLAND_EVT.NPC_DETECTED, arg0_24.OnNpcDetectorSelected)
	arg0_24:RemoveListener(ISLAND_EVT.NO_NPC_DETECTED, arg0_24.OnNpcDetectorUnSelected)
	arg0_24:RemoveListener(ISLAND_EVT.SET_PLAYER_WORK, arg0_24.OnPlayerWork)
	arg0_24:RemoveListener(ISLAND_EVT.DEVIEE_STATE_CHANGE, arg0_24.OnPlayerDeviceStateChange)
	arg0_24:RemoveListener(ISLAND_EVT.UPDATE_HUD, arg0_24.OnUpdateHud)
	arg0_24:RemoveListener(ISLAND_EVT.PLAY_EFFECT, arg0_24.OnPlayEffect)
	arg0_24:RemoveListener(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, arg0_24.OnUpdateHandCollectUnit)
	arg0_24:RemoveListener(ISLAND_EVT.RECYCLE_ALL_SLOTDELEEFFECT, arg0_24.OnRecycleAllSlotEffct)
	arg0_24:RemoveListener(ISLAND_EVT.SELECTDELEEFFECT_SHOW, arg0_24.OnSelectSlotEffectShow)
	arg0_24:RemoveListener(ISLAND_EVT.LOAD_DELEGATE_PREVIEW_ROLE, arg0_24.OnLoadDelegatePreviewRole)
	arg0_24:RemoveListener(ISLAND_EVT.UN_LOAD_DELEGATE_PREVIEW_ROLE, arg0_24.OnUnLoadDelegatePreviewRole)
	arg0_24:RemoveListener(ISLAND_EVT.Take_Plant_Attact, arg0_24.OnTakePlantAttack)
	arg0_24:RemoveListener(ISLAND_EVT.START_MANAGE, arg0_24.OnStartManage)
	arg0_24:RemoveListener(ISLAND_EVT.END_MANAGE, arg0_24.OnEndManage)
	arg0_24:RemoveListener(ISLAND_EVT.SHOW_HUD, arg0_24.OnShowHud)
	arg0_24:RemoveListener(ISLAND_EVT.HIDE_HUD, arg0_24.OnHideHud)
	arg0_24:RemoveListener(ISLAND_EVT.REFRESH_HUD, arg0_24.OnRefreshHud)
	arg0_24:RemoveListener(ISLAND_EVT.START_GUIDE, arg0_24.OnStartGuide)
	arg0_24:RemoveListener(ISLAND_EVT.END_GUIDE, arg0_24.OnEndGuide)
	arg0_24:RemoveListener(ISLAND_EVT.START_PERFORMANCE, arg0_24.OnStartPerformance)
	arg0_24:RemoveListener(ISLAND_EVT.END_PERFORMANCE, arg0_24.OnEndPerformance)
	arg0_24:RemoveListener(ISLAND_EVT.DISABLE_INPUT, arg0_24.DisableInput)
	arg0_24:RemoveListener(ISLAND_EVT.ENABLE_INPUT, arg0_24.EnableInput)
	arg0_24:RemoveListener(ISLAND_EVT.GEN_PATH_FINDER, arg0_24.OnGenPathFinder)
	arg0_24:RemoveListener(ISLAND_EVT.REMOVE_PATH_FINDER, arg0_24.OnRemovePathFinder)
	arg0_24:RemoveListener(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg0_24.OnActiveOrDisactiveUnit)
	arg0_24:RemoveListener(ISLAND_EVT.OPEN_ANIMATION_OP, arg0_24.OnOpenAniamtionOpPage)
	arg0_24:RemoveListener(ISLAND_EVT.CLOSE_ANIMATION_OP, arg0_24.OnCloseAniamtionOpPage)
	arg0_24:RemoveListener(ISLAND_EVT.MOVE_PLAYER_BEFORE, arg0_24.OnMovePlayerBefore)
	arg0_24:RemoveListener(ISLAND_EVT.REFRESH_TASK_HUD_INFO, arg0_24.OnRefreshTaskInfoHud)
	arg0_24:RemoveListener(ISLAND_EVT.RESPON_ANIMATION_OP, arg0_24.OnResponAniamtionOp)
	arg0_24:RemoveListener(ISLAND_EVT.CHANGE_VISTER_DRESS, arg0_24.OnChangeVisterDress)
	arg0_24:RemoveListener(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg0_24.OnSetVisitorSyncData)
	arg0_24:RemoveListener(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, arg0_24.OnShowNpcAniamtionBubble)
	arg0_24:RemoveListener(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, arg0_24.OnHideNpcAniamtionBubble)
	arg0_24:RemoveListener(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, arg0_24.OnPlaySingleAnimationEnd)
	arg0_24:RemoveListener(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON, arg0_24.OnUpdateCustomOpPositon)
	arg0_24:RemoveListener(ISLAND_EVT.CHAT_MSG_UPDATE, arg0_24.OnChatMsgUpdate)
	arg0_24:RemoveListener(ISLAND_EVT.CHAT_ROOM_UPDATE, arg0_24.OnChatRoomChange)
	arg0_24:RemoveListener(ISLAND_EVT.SHOW_CHAT_MSG, arg0_24.OnShowChatMsg)
	arg0_24:RemoveListener(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, arg0_24.OnResetFollowRandomizer)
	arg0_24:RemoveListener(ISLAND_EVT.ADD_FOLLOWER, arg0_24.OnFollowerAdd)
	arg0_24:RemoveListener(ISLAND_EVT.WILL_DEL_FOLLOWER, arg0_24.OnFollowerWillDelStep1)
	arg0_24:RemoveListener(ISLAND_EVT.DO_DEL_FOLLOWER, arg0_24.OnFollowerWillDelStep2)
	arg0_24:RemoveListener(ISLAND_EVT.DEL_FOLLOWER, arg0_24.OnFollowerDel)
	arg0_24:RemoveListener(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_24.OnCoupleActionWithFollower)
	arg0_24:RemoveListener(ISLAND_EVT.LOCK_PLAYER_INPUT, arg0_24.OnLockPlayerInput)
	arg0_24:RemoveListener(ISLAND_EVT.START_COUPLE_ACTION, arg0_24.OnStartCoupleAction)
	arg0_24:RemoveListener(ISLAND_EVT.END_COUPLE_ACTION, arg0_24.OnEndCoupleAction)
	arg0_24:RemoveListener(ISLAND_EVT.REFRESH_WEATHER_SYSTEM, arg0_24.OnRefreshWeatherSystem)
	arg0_24:RemoveListener(ISLAND_EVT.SYSTEM_UNLOCK, arg0_24.OnSystemUnlock)
	arg0_24:RemoveListener(ISLAND_EVT.START_DO_COUPLE_ACTION, arg0_24.OnStartDoCoupleAction)
	arg0_24:RemoveListener(ISLAND_EVT.END_DO_COUPLE_ACTION, arg0_24.OnEndDoCoupleAction)
	arg0_24:RemoveListener(ISLAND_EVT.CANCEL_COUPLE_ACTION, arg0_24.OnCancelCoupleAction)
	arg0_24:RemoveListener(ISLAND_EVT.BAIT_UPDATE, arg0_24.OnBaitUpdate)
	arg0_24:RemoveListener(ISLAND_EVT.START_FISHING, arg0_24.OnStartFishing)
	arg0_24:RemoveListener(ISLAND_EVT.FISHING_STATE_CHANGE, arg0_24.OnFishingStateChange)
	arg0_24:RemoveListener(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, arg0_24.OnAllDailyOrWeeklyFinish)
end

function var0_0.OnBaitUpdate(arg0_25, arg1_25)
	arg0_25:GetSubView(IslandOpView):UpdateLureBtn()
end

function var0_0.OnFishPointSelected(arg0_26, arg1_26)
	local var0_26 = arg1_26.node

	if not var0_26 then
		return
	end

	local var1_26 = var0_26:GetBlackboardVariable("FishPoint")

	if not var1_26 or var1_26 == "" then
		arg0_26:UnSelectedFishPoint()
	else
		local var2_26, var3_26 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_26)
		local var4_26 = arg0_26:GetUnitModuleWithType(var2_26, var3_26)

		if var4_26 then
			arg0_26:SelectedFishPoint(var4_26)
		end
	end
end

function var0_0.OnAllDailyOrWeeklyFinish(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_27 = {}

	for iter0_27, iter1_27 in ipairs(var0_27) do
		if not iter1_27:IsExitState() then
			table.insert(var1_27, iter1_27)
		end
	end

	if #var1_27 <= 0 then
		return
	end

	for iter2_27, iter3_27 in ipairs(var1_27) do
		iter3_27:StopMove()
		iter3_27:PlayAnimation(arg1_27)
	end
end

function var0_0.OnSystemUnlock(arg0_28, arg1_28)
	if arg1_28 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_28:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.SelectedFishPoint(arg0_29, arg1_29)
	if not arg0_29:GetSelfIsland():GetAblityAgency():IsUnlockFishing() or arg1_29:GetUnitType() ~= IslandConst.UNIT_LIST_FISH_POINT or arg0_29.player:StandOnWorldObject() or not arg0_29.player:OnGrouded() then
		return
	end

	arg0_29:UnSelectedFishPoint()

	arg0_29.selectedFishPointId = arg1_29.id

	arg0_29:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.Fishing, arg1_29.id)
end

function var0_0.UnSelectedFishPoint(arg0_30)
	if arg0_30.selectedFishPointId then
		local var0_30 = arg0_30.selectedFishPointId

		arg0_30.selectedFishPointId = nil

		arg0_30:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, var0_30)
	end
end

function var0_0.OnStartFishing(arg0_31, arg1_31)
	local var0_31 = arg1_31.unitId
	local var1_31 = arg0_31:GetPlayerUnitModule(var0_31)

	if not var1_31 then
		return
	end

	if not isa(var1_31, IslandVisitorUnit) then
		return
	end

	var1_31:Sleep()

	local var2_31 = arg1_31.fishPointId
	local var3_31 = arg1_31.rodId
	local var4_31 = arg1_31.fishId
	local var5_31 = pg.island_fish_rod[var3_31].attachment_id
	local var6_31 = IslandVistorFishingPlayer.New(arg0_31, var1_31, var2_31, var5_31, var4_31)

	var6_31:Play()

	arg0_31.fishingSynPlayers[var0_31] = var6_31
end

function var0_0.OnFishingStateChange(arg0_32, arg1_32)
	local var0_32 = arg1_32.op
	local var1_32 = arg1_32.unitId
	local var2_32 = arg0_32:GetPlayerUnitModule(var1_32)
	local var3_32 = arg0_32.fishingSynPlayers[var1_32]

	if not isa(var2_32, IslandVisitorUnit) then
		return
	end

	if not var3_32 or not var3_32:IsSameFishPoint(arg1_32.fishPointId) then
		return
	end

	local function var4_32()
		var2_32:WakeUp()
		arg0_32.fishingSynPlayers[var1_32]:Dispose()

		arg0_32.fishingSynPlayers[var1_32] = nil
	end

	if var0_32 == IslandConst.FISHING_OP_CANCEL then
		var3_32:OnCancel(var4_32)
	elseif var0_32 == IslandConst.FISHING_OP_FAILD then
		var3_32:OnFailed(var4_32)
	elseif var0_32 == IslandConst.FISHING_OP_SUCCESS then
		var3_32:OnSuccess(var4_32)
	end
end

function var0_0.OnStartCoupleAction(arg0_34)
	arg0_34:UnBlockLayer1Event(false)
	arg0_34:GetSubView(IslandAniamtionOpView):OnStartCoupleAction()
end

function var0_0.OnEndCoupleAction(arg0_35)
	arg0_35:UnBlockLayer1Event(true)
	arg0_35:GetSubView(IslandAniamtionOpView):OnEndCoupleAction()
end

function var0_0.OnCancelCoupleAction(arg0_36)
	if arg0_36.coupleActionPlayer and arg0_36.coupleActionPlayer:IsPlaying() then
		arg0_36.coupleActionPlayer:Stop()
	end

	if arg0_36.coupleAction4FollowerPlayer and arg0_36.coupleAction4FollowerPlayer:IsPlaying() then
		arg0_36.coupleAction4FollowerPlayer:Stop()
	end

	arg0_36:OnEndCoupleAction()
end

function var0_0.OnCoupleActionWithFollower(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_37 = arg0_37:GetPlayerPosition()
	local var2_37 = pg.island_set.action_bubble_range.key_value_int
	local var3_37 = _.select(var0_37, function(arg0_38)
		return not arg0_38:IsExitState() and Vector3.Distance(arg0_38:GetPosition(), var1_37) <= var2_37
	end)

	if #var3_37 <= 0 then
		return
	end

	local var4_37 = var3_37[math.random(1, #var3_37)]
	local var5_37 = pg.island_action[arg1_37]

	arg0_37.coupleAction4FollowerPlayer:Play(var4_37, arg0_37.player, var5_37)
	arg0_37:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
end

function var0_0.OnFollowerAdd(arg0_39, arg1_39)
	if arg0_39:GetSelectedNpcId() then
		local var0_39, var1_39 = IslandCalcUtil.GetTypeAndIdByUniqueId(arg0_39:GetSelectedNpcId())

		if var1_39 == arg1_39 then
			arg0_39.selectedNpcId = nil
		end
	end

	arg0_39:GetSubView(IslandOpView):FlushFollowerList()
	arg0_39.coupleNpcWordPlayer:Play(arg1_39)
end

function var0_0.OnFollowerWillDelStep1(arg0_40, arg1_40)
	local var0_40 = arg0_40:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_40

	for iter0_40, iter1_40 in ipairs(var0_40) do
		if iter1_40:GetDataVO():IsSameShip(arg1_40) then
			var1_40 = iter1_40

			break
		end
	end

	if not var1_40 or var1_40:IsExitState() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_follower_exiting_tip"))

		return
	end

	var1_40:DoExitHandle()
end

function var0_0.OnFollowerWillDelStep2(arg0_41, arg1_41)
	local var0_41 = arg1_41.node

	if not var0_41 then
		return
	end

	local var1_41 = var0_41:GetComponent(typeof(WorldObjectItem)).uniqueId
	local var2_41, var3_41 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_41)
	local var4_41 = arg0_41:GetUnitModuleWithType(var2_41, var3_41)

	if not var4_41 then
		return
	end

	arg0_41:NotifiyMeditor(IslandMediator.DEL_FOLLOWER, var4_41:GetDataVO():GetShipId())
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

function var0_0.OnShowChatMsg(arg0_44, arg1_44)
	local var0_44 = arg1_44.player.id
	local var1_44 = arg0_44:GetPlayerUnitModule(var0_44)

	if not var1_44 then
		return
	end

	arg0_44:GetSubView(IslandTopHeadHudView):PlayChat(var1_44, arg1_44.emojiId, arg1_44.content, nil)
end

function var0_0.OnChatRoomChange(arg0_45)
	arg0_45:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_46)
	arg0_46:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnPlaySingleAnimationEnd(arg0_47, arg1_47)
	if not arg0_47:GetSelectedNpcId() then
		arg0_47.npcActionPlayer:ResoponByRandom(arg0_47.player, arg1_47)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(1, arg1_47, 0, 0, 0, 0))

		return
	end

	local var0_47 = arg0_47:GetSelectedNpcId()
	local var1_47, var2_47 = IslandCalcUtil.GetTypeAndIdByUniqueId(var0_47)
	local var3_47 = arg0_47:GetUnitModuleWithType(var1_47, var2_47)

	if isa(var3_47, IslandStrollNpcUnit) and var3_47:GetDataVO():ExistGreetingActionFeedback() then
		arg0_47.npcActionPlayer:Resopon(var3_47, arg0_47.player, arg1_47)
	else
		arg0_47.npcActionPlayer:ResoponByRandom(arg0_47.player, arg1_47)
	end
end

function var0_0.OnShowNpcAniamtionBubble(arg0_48, arg1_48)
	local var0_48 = arg0_48:GetStrollUnitModule(arg1_48.id)

	if not var0_48 then
		return
	end

	local var1_48 = arg1_48:GetGreetingFeedback()

	arg0_48:GetSubView(IslandBottomHeadHudView):ShowAnimationOp(var0_48, var1_48)
end

function var0_0.OnHideNpcAniamtionBubble(arg0_49, arg1_49)
	local var0_49 = arg0_49:GetStrollUnitModule(arg1_49.id)

	arg0_49:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var0_49)
end

function var0_0.OnStartDoCoupleAction(arg0_50)
	arg0_50:GetSubView(IslandCancelAnimationOpView):ShowCancelableAnimationOp(arg0_50.player)
end

function var0_0.OnEndDoCoupleAction(arg0_51)
	arg0_51:GetSubView(IslandCancelAnimationOpView):HideCancelableAnimationOp(arg0_51.player)
end

function var0_0.OnResponAniamtionOp(arg0_52, arg1_52)
	local var0_52 = arg1_52.id
	local var1_52 = arg1_52.targetId
	local var2_52 = arg1_52.actionId
	local var3_52 = arg0_52:GetPlayerUnitModule(var0_52)

	if not var3_52 then
		return
	end

	if var2_52 == 0 then
		if not arg0_52:IsPlayer(var0_52) then
			arg0_52:GetSubView(IslandTopHeadHudView):HideAnimationOp(var3_52)
		else
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_52, 1, 0, 0, 0))
		end

		return
	end

	local var4_52 = pg.island_action[var2_52]

	if var1_52 == 0 and var4_52.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_52:IsPlayer(var0_52) then
		arg0_52:GetSubView(IslandTopHeadHudView):ShowAnimationOp(var3_52, var2_52)
	elseif var1_52 > 0 and var4_52.type == IslandConst.ANIMATION_OP_DOUBLE and not arg0_52:IsPlayer(var1_52) then
		local var5_52 = arg0_52:GetPlayerUnitModule(var1_52)

		arg0_52.coupleActionPlayer:Play(var3_52, var5_52, var4_52)
		arg0_52:GetSubView(IslandTopHeadHudView):HideAnimationOp(var5_52)
	elseif var1_52 > 0 and var4_52.type == IslandConst.ANIMATION_OP_DOUBLE and arg0_52:IsPlayer(var1_52) then
		local var6_52 = arg0_52:GetPlayerUnitModule(var1_52)

		arg0_52.coupleActionPlayer:Play(var3_52, var6_52, var4_52)
		arg0_52:GetSubView(IslandAniamtionOpView):RemoveWaitTimer(false)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(2, var2_52, 1, var1_52, 0, 1))
	end
end

function var0_0.OnShowChatMsg(arg0_53, arg1_53)
	local var0_53 = arg1_53.player.id
	local var1_53 = arg0_53:GetPlayerUnitModule(var0_53)

	if not var1_53 then
		return
	end

	arg0_53:GetSubView(IslandTopHeadHudView):PlayChat(var1_53, arg1_53.emojiId, arg1_53.content, nil)
end

function var0_0.OnChatRoomChange(arg0_54)
	arg0_54:GetSubView(IslandAniamtionOpView):UpdateChatRoom()
end

function var0_0.OnChatMsgUpdate(arg0_55)
	arg0_55:GetSubView(IslandAniamtionOpView):UpdateMsgList()
end

function var0_0.OnFollowerAdd(arg0_56, arg1_56)
	arg0_56:GetSubView(IslandOpView):FlushFollowerList()
	arg0_56.coupleNpcWordPlayer:Play(arg1_56)
end

function var0_0.OnFollowerDel(arg0_57, arg1_57)
	arg0_57:GetSubView(IslandOpView):FlushFollowerList()
	arg0_57.coupleNpcWordPlayer:Stop(arg1_57)
end

function var0_0.OnResetFollowRandomizer(arg0_58, arg1_58)
	local var0_58 = arg0_58:GetFollowerModule(arg1_58)

	if not var0_58 then
		return
	end

	var0_58:SetBtRandomizer()
end

function var0_0.OnGenPathFinder(arg0_59, arg1_59)
	local var0_59 = IslandPathFinder.New(arg0_59)
	local var1_59 = defaultValue(arg1_59.navData.waitUntilDone, false)

	var0_59:Start(arg1_59.navData, function()
		table.removebyvalue(arg0_59.pathfinders, var0_59)
		var0_59:Dispose()

		if arg1_59.onEndAction then
			arg1_59.onEndAction()
		end

		arg0_59:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH_DONE, arg1_59.navData.index)

		if var1_59 and arg1_59.callback then
			arg1_59.callback()
		end
	end)
	arg0_59:NotifiyIsland(ISLAND_EX_EVT.NAV_PATH, arg1_59.navData.index)

	if not var1_59 and arg1_59.callback then
		arg1_59.callback()
	end

	table.insert(arg0_59.pathfinders, var0_59)
end

function var0_0.OnRemovePathFinder(arg0_61, arg1_61)
	local var0_61 = arg0_61:GetUnitModuleWithType(arg1_61.unitType, arg1_61.unitId)
	local var1_61 = _.detect(arg0_61.pathfinders, function(arg0_62)
		return arg0_62:IsSameUnit(var0_61)
	end)

	if not var1_61 then
		return
	end

	var1_61:Stop()
	var1_61:Dispose()
	table.removebyvalue(arg0_61.pathfinders, var1_61)
end

function var0_0.OnTracking(arg0_63, arg1_63)
	local var0_63 = arg1_63.trackType

	if var0_63 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_63.mainTrackId = tonumber(arg1_63.id)
		arg0_63.needTryMainTrack = true
	elseif var0_63 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_63.trackId = tonumber(arg1_63.id)
		arg0_63.trackType = arg1_63.typ or IslandTaskType.MAIN
		arg0_63.needTryTrack = true
	end
end

function var0_0.TryTrack(arg0_64)
	arg0_64:TrySetTrack(arg0_64.trackId)
end

function var0_0.TrySetTrack(arg0_65, arg1_65)
	local var0_65 = arg0_65:GetOptTrackingTarget(arg1_65)

	if not var0_65 or not var0_65._go then
		return
	end

	arg0_65:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_65.player, var0_65, arg1_65, arg0_65.trackType, IslandTaskTrackCard.TYPES.OTHER)

	arg0_65.needTryTrack = false
end

function var0_0.TryMainTrack(arg0_66)
	arg0_66:TrySetMainTrack(arg0_66.mainTrackId)
end

function var0_0.TrySetMainTrack(arg0_67, arg1_67)
	local var0_67 = arg0_67:GetOptTrackingTarget(arg1_67)

	if not var0_67 or not var0_67._go then
		return
	end

	arg0_67:GetSubView(IslandDistanceView):SetTrackingTarget(arg0_67.player, var0_67, arg1_67, IslandTaskType.MAIN, IslandTaskTrackCard.TYPES.MAIN)

	arg0_67.needTryMainTrack = false
end

function var0_0.OnUnTracking(arg0_68, arg1_68)
	if arg1_68 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_68.mainTrackId = nil
	elseif arg1_68 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_68.trackId = nil
	end

	arg0_68:GetSubView(IslandDistanceView):CancelTracking(arg1_68)
end

local function var1_0(arg0_69, arg1_69)
	local var0_69 = pg.island_world_objects[arg0_69]

	if not var0_69 then
		return
	end

	return var0_69.mapId == arg1_69
end

local function var2_0(arg0_70, arg1_70, arg2_70)
	for iter0_70, iter1_70 in ipairs(arg0_70) do
		for iter2_70, iter3_70 in ipairs(iter1_70[2]) do
			local var0_70 = pg.island_interaction[iter3_70]

			if var0_70.type == arg2_70 and var1_0(tonumber(var0_70.param), arg1_70) then
				return iter1_70[1]
			end
		end
	end

	return nil
end

local function var3_0(arg0_71)
	local var0_71 = {}
	local var1_71 = {}

	for iter0_71, iter1_71 in ipairs(arg0_71) do
		for iter2_71, iter3_71 in ipairs(iter1_71[2]) do
			local var2_71 = pg.island_interaction[iter3_71]

			if var2_71.type == IslandInteractionUntil.TYPE_TRANSFER then
				table.insert(var0_71, iter1_71[1])
			elseif var2_71.type == IslandInteractionUntil.TYPE_SP_TRANSFER then
				table.insert(var1_71, iter1_71[1])
			end
		end
	end

	if #var1_71 > 0 then
		return var1_71[1]
	end

	if #var0_71 > 0 then
		return var0_71[1]
	end

	return nil
end

function var0_0.GetOptTrackingTarget(arg0_72, arg1_72)
	local var0_72 = arg0_72:GetUnitModule(arg1_72)

	if var0_72 then
		return var0_72
	end

	local var1_72 = pg.island_world_objects[arg1_72]

	if not var1_72 then
		return nil
	end

	local var2_72 = {}

	for iter0_72, iter1_72 in ipairs(arg0_72:GetUnitListByKey(IslandConst.UNIT_LIST_OBJ)) do
		local var3_72, var4_72 = iter1_72:IsMapTransfer()

		if var3_72 then
			table.insert(var2_72, {
				iter1_72,
				var4_72
			})
		end
	end

	local var5_72
	local var6_72 = var2_0(var2_72, var1_72.mapId, IslandInteractionUntil.TYPE_TRANSFER) or var2_0(var2_72, var1_72.mapId, IslandInteractionUntil.TYPE_SP_TRANSFER)

	var6_72 = var6_72 or var3_0(var2_72)

	return var6_72
end

function var0_0.OnOpenAniamtionOpPage(arg0_73)
	arg0_73:GetSubView(IslandAniamtionOpView):TryEnable()
	arg0_73:GetSubView(IslandOpView):TryDisable()
	arg0_73:NotifiyIsland(ISLAND_EX_EVT.OPEN_ANIMATION_OP)
end

function var0_0.OnCloseAniamtionOpPage(arg0_74)
	arg0_74:GetSubView(IslandOpView):TryEnable()
	arg0_74:NotifiyIsland(ISLAND_EX_EVT.CLOSE_ANIMATION_OP)
end

function var0_0.OnAnyPageOpen(arg0_75, arg1_75)
	arg0_75.anyPageOpen = true

	arg0_75.player:StopMoveHandle()
	arg0_75:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_75:GetSubView(IslandSlotHudView):TryDisable()
	arg0_75:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_75:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_75:GetSubView(IslandAniamtionOpView):CloseAndReset()
end

function var0_0.OnAllPageClose(arg0_76)
	arg0_76.anyPageOpen = false

	arg0_76:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_76:GetSubView(IslandSlotHudView):TryEnable()
	arg0_76:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_76:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnStartStory(arg0_77)
	arg0_77.playingStory = true

	arg0_77:DisablePlayerOp()
end

function var0_0.OnEndStory(arg0_78)
	arg0_78.playingStory = false

	arg0_78:EnablePlayerOp()
end

function var0_0.OnStartPerformance(arg0_79)
	return
end

function var0_0.OnEndPerformance(arg0_80)
	if not arg0_80.anyPageOpen then
		arg0_80:GetSubView(IslandOpView):ResetShowBalance()
	end
end

function var0_0.OnStartGuide(arg0_81)
	arg0_81.player:StopMoveHandle()
	arg0_81:GetSubView(IslandOpView):DisableInput()
end

function var0_0.OnEndGuide(arg0_82)
	if arg0_82.playingStory then
		return
	end

	arg0_82:GetSubView(IslandOpView):EnableInput()
end

function var0_0.InitFocusCamera(arg0_83)
	local var0_83 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)

	var0_83.Follow = arg0_83.player._tf
	var0_83.LookAt = arg0_83.player._tf
end

function var0_0.InitTakePhotoCamera(arg0_84)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).Follow = arg0_84.firstTakePhotoItem._tf

	local var0_84 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)

	var0_84.Follow = arg0_84.thirdTakePhotoItem._tf
	var0_84.LookAt = arg0_84.thirdTakePhotoItem._tf
end

function var0_0.DisablePlayerOp(arg0_85)
	arg0_85.player:StopMoveHandle()
	arg0_85:GetSubView(IslandTopHeadHudView):TryDisable()
	arg0_85:GetSubView(IslandBottomHeadHudView):TryDisable()
	arg0_85:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_85:GetSubView(IslandOpView):TryDisable()
end

function var0_0.EnablePlayerOp(arg0_86)
	arg0_86:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_86:GetSubView(IslandTopHeadHudView):TryEnable()
	arg0_86:GetSubView(IslandBottomHeadHudView):TryEnable()
	arg0_86:GetSubView(IslandOpView):TryEnable()
end

function var0_0.OnInterActionBegin(arg0_87)
	arg0_87.player:StopMoveHandle()
	arg0_87:GetSubView(IslandOpView):TryDisablePlayerOp()
end

function var0_0.OnInterActionEnd(arg0_88)
	arg0_88:GetSubView(IslandOpView):TryEnablePlayerOp()
end

function var0_0.OnShowInterActionPanel(arg0_89, arg1_89)
	arg0_89.showInterObjId = arg1_89.id

	arg0_89:GetSubView(IslandInteractionView):ShowInterActionPanel(arg1_89)
	arg0_89:Op("NotifiyIsland", ISLAND_EX_EVT.SHOW_INTERACTION, arg0_89.showInterObjId)
end

function var0_0.OnHideInterActionPanel(arg0_90, arg1_90)
	if arg0_90.showInterObjId ~= arg1_90.id then
		return
	end

	arg0_90.showInterObjId = nil

	arg0_90:GetSubView(IslandInteractionView):HideInterActionPanel()
end

function var0_0.OnRefreshInteractionBtn(arg0_91)
	arg0_91:GetSubView(IslandInteractionView):RefreshInteractionBtns()
end

function var0_0.OnSetOpMoveBtnActve(arg0_92, arg1_92, arg2_92)
	arg0_92:GetSubView(IslandOpView):ShowOrHideMoveBtn(arg1_92, arg2_92)
end

function var0_0.DisableInput(arg0_93)
	arg0_93.player:StopMoveHandle()
	arg0_93:GetSubView(IslandOpView):DisableInput()
end

function var0_0.EnableInput(arg0_94)
	arg0_94:GetSubView(IslandOpView):EnableInput()
end

function var0_0.OnUpdateCustomOpPositon(arg0_95)
	arg0_95:GetSubView(IslandOpView):InitOpCustumPositon()
end

function var0_0.OnChange_Photo_Height(arg0_96, arg1_96, arg2_96)
	arg0_96.takePhotoModel = arg1_96

	if arg0_96.takePhotoModel == IslandConst.TakePhotoModel.First then
		-- block empty
	elseif arg0_96.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_96.thirdTakePhotoItem:ChangeHeight(arg2_96)
	end
end

function var0_0.OnChangeTakePhotoModel(arg0_97, arg1_97, arg2_97)
	arg0_97.takePhotoModel = arg1_97

	if arg0_97.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_97.firstTakePhotoItem:Enable()

		arg0_97.firstTakePhotoItem._tf.position = arg0_97.player._tf.position
		arg0_97.firstTakePhotoItem._tf.rotation = arg0_97.player._tf.rotation

		arg0_97.firstTakePhotoItem:SetTargetRotation(arg0_97.player._tf.rotation)
		arg0_97.player:SetActiveByLayer(false)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook)):SetPosAndRotationByTargetDir(arg0_97.player._tf.forward)
	elseif arg0_97.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_97.thirdTakePhotoItem:Enable()

		arg0_97.player._tf.position = arg0_97.firstTakePhotoItem._tf.position
		arg0_97.player._tf.rotation = arg0_97.firstTakePhotoItem._tf.rotation

		arg0_97.player:SetTargetRotation(arg0_97.firstTakePhotoItem._tf.rotation)
		arg0_97.player:SetActiveByLayer(true)

		arg0_97.thirdTakePhotoItem._tf.position = arg0_97.firstTakePhotoItem._tf:TransformPoint(Vector3(0, 0, -5))
		arg0_97.thirdTakePhotoItem._tf.rotation = arg0_97.firstTakePhotoItem._tf.rotation

		arg0_97.thirdTakePhotoItem:SetTargetRotation(arg0_97.firstTakePhotoItem._tf.rotation)

		local var0_97 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME).gameObject:GetComponent(typeof(CameraPovLook))
		local var1_97 = arg0_97.player._tf.position + Vector3(0, 0.5, 0)
		local var2_97 = arg0_97.thirdTakePhotoItem._tf.position + Vector3(0, 1, 0)

		var0_97:SetPosAndRotationByTargetDir((var1_97 - var2_97).normalized)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	else
		arg0_97.firstTakePhotoItem:Disable()
		arg0_97.thirdTakePhotoItem:Disable()

		arg0_97.player._tf.position = arg0_97.firstTakePhotoItem._tf.position
		arg0_97.player._tf.rotation = arg0_97.firstTakePhotoItem._tf.rotation

		arg0_97.player:SetTargetRotation(arg0_97.firstTakePhotoItem._tf.rotation)
		arg0_97.player:SetActiveByLayer(true)
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
		IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraLook)):ResetCameraPos()
	end

	arg0_97:GetSubView(IslandOpView):ChangeTakePhotoModel(arg1_97, arg2_97)
end

function var0_0.OnNpcDetectorSelected(arg0_98, arg1_98)
	if arg0_98.selectedNpcId then
		return
	end

	local var0_98 = arg1_98.node

	if not var0_98 then
		return
	end

	local var1_98 = var0_98:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_98.selectedNpcId = var1_98

	arg0_98:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_98, true)
	arg0_98:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_98, true)
	arg0_98:GetSubView(IslandAniamtionOpView):SortForNpcAction(var1_98)
end

function var0_0.GetSelectedNpcId(arg0_99)
	return arg0_99.selectedNpcId
end

function var0_0.OnNpcDetectorUnSelected(arg0_100, arg1_100)
	local var0_100 = arg1_100.node

	if not var0_100 then
		return
	end

	local var1_100 = var0_100:GetComponent(typeof(WorldObjectItem)).uniqueId

	arg0_100:GetSubView(IslandOpView):UpdateAnimationOpEffect(var1_100)
	arg0_100:GetSubView(IslandBottomHeadHudView):UpdateAnimationOpEffect(var1_100)
	arg0_100:GetSubView(IslandAniamtionOpView):SortForNpcAction(nil)

	if arg0_100.selectedNpcId ~= var1_100 then
		return
	end

	arg0_100.selectedNpcId = nil
end

function var0_0.OnDetectorChanged(arg0_101, arg1_101)
	local var0_101 = arg1_101.node

	if not var0_101 then
		return
	end

	local var1_101 = var0_101:GetBlackboardVariable("DetectorList")

	for iter0_101 = 1, var1_101.Count do
		local var2_101 = var1_101[iter0_101 - 1]
		local var3_101, var4_101 = IslandCalcUtil.GetTypeAndIdByUniqueId(var2_101)

		if var3_101 == IslandConst.UNIT_LIST_OBJ then
			local var5_101 = arg0_101:GetUnitModuleWithType(var3_101, var4_101)

			if var5_101 then
				arg0_101:Op("NotifiyIsland", ISLAND_EX_EVT.APPROACH_OBJECT, var5_101.id)
			end
		end
	end
end

function var0_0.OnDetectorSelected(arg0_102, arg1_102)
	local var0_102 = arg1_102.node

	if not var0_102 then
		return
	end

	local var1_102 = var0_102:GetBlackboardVariable("AnyOne")

	if not var1_102 or var1_102 == "" then
		arg0_102:OnClearSelectedUnit()
	else
		local var2_102, var3_102 = IslandCalcUtil.GetTypeAndIdByUniqueId(var1_102)
		local var4_102 = arg0_102:GetUnitModuleWithType(var2_102, var3_102)

		if var4_102 then
			arg0_102:OnSelectedUnit(var4_102)
		end
	end
end

function var0_0.OnClearSelectedUnit(arg0_103)
	return
end

function var0_0.OnSelectedUnit(arg0_104, arg1_104)
	return
end

function var0_0.OnPlayChatBubble(arg0_105, arg1_105)
	local var0_105 = arg0_105:GetAllUnits()

	arg0_105:GetSubView(IslandTopHeadHudView):PlayBubble(arg1_105.name, var0_105, arg1_105.callback)
end

function var0_0.OnRawPlayChatBubble(arg0_106, arg1_106)
	local var0_106 = arg0_106:GetAllUnits()

	arg0_106:GetSubView(IslandTopHeadHudView):RawPlayBubble(arg1_106.info, var0_106, arg1_106.callback)
end

function var0_0.OnRawStopChatBubble(arg0_107, arg1_107)
	arg0_107:GetSubView(IslandTopHeadHudView):RawStopBubble(arg1_107.info)
end

function var0_0.OnChangeVisterDress(arg0_108, arg1_108)
	local var0_108 = arg1_108.id

	if arg0_108:IsPlayer(var0_108) then
		return
	end

	local var1_108 = arg0_108:GetPlayerUnitModule(var0_108)

	if var1_108 then
		var1_108:OnChangeDress(arg1_108.changeDressData)
	end
end

function var0_0.OnSystemUnlock(arg0_109, arg1_109)
	if arg1_109 == IslandAblityAgency.ANIMATION_OP_ID then
		arg0_109:GetSubView(IslandOpView):UpdateAnimationOpBtn()
	end
end

function var0_0.OnSceneInited(arg0_110, arg1_110)
	IslandCameraMgr.instance:LookAt(arg0_110.player._tf)
	IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME).gameObject:GetComponent(typeof(CameraZoom)):SetMaxMinZoom(arg1_110.min, arg1_110.max, arg1_110.value)
	arg0_110:InitFocusCamera()
	arg0_110:InitTakePhotoCamera()
	arg0_110:GetSubView(IslandOpView):LaterInit()
end

function var0_0.OnGenUnit(arg0_111, arg1_111, arg2_111)
	local var0_111 = arg0_111.unitBuilders[arg1_111:GetType()]:Build(arg1_111, arg2_111)

	arg0_111:AddUnit(var0_111)

	if arg1_111:IsPlayer() then
		arg0_111.player = var0_111
	end

	if arg1_111:IsFirstTakePhoto() then
		arg0_111.firstTakePhotoItem = var0_111
	end

	if arg1_111:IsThirdTakePhoto() then
		arg0_111.thirdTakePhotoItem = var0_111
	end
end

function var0_0.OnGenSystem(arg0_112, arg1_112)
	local var0_112 = arg0_112.systemBuilders[arg1_112:GetType()]:Build(arg1_112)

	arg0_112:AddUnit(var0_112)
end

function var0_0.IsPlayer(arg0_113, arg1_113)
	return arg0_113.player.id == arg1_113
end

function var0_0.OnActiveOrDisactiveUnit(arg0_114, arg1_114, arg2_114, arg3_114)
	local var0_114

	if arg1_114 == 0 then
		var0_114 = arg0_114.player
	else
		var0_114 = arg0_114:GetUnitModuleWithType(arg2_114, arg1_114)
	end

	if var0_114 and arg3_114 then
		var0_114:Enable()
	end

	if var0_114 and not arg3_114 then
		var0_114:Disable()
	end
end

function var0_0.OnResetUnitPos(arg0_115, arg1_115, arg2_115, arg3_115)
	local var0_115 = arg0_115:GetUnitModuleWithType(arg2_115, arg1_115)

	if var0_115 then
		var0_115._go.transform.position = arg3_115
	end
end

function var0_0.OnResetUnitRotation(arg0_116, arg1_116, arg2_116, arg3_116)
	local var0_116 = arg0_116:GetUnitModuleWithType(arg2_116, arg1_116)

	if var0_116 then
		var0_116._go.transform.eulerAngles = arg3_116
	end
end

function var0_0.OnMoveUnit(arg0_117, arg1_117)
	assert(arg1_117.type, "type should be exist")

	local var0_117 = arg0_117:GetUnitModuleWithType(arg1_117.type, arg1_117.id)

	if var0_117 then
		var0_117:SetDestination(arg1_117.position, arg1_117.speed, nil, arg1_117.charaRadius)
	end
end

function var0_0.OnStopUnit(arg0_118, arg1_118)
	assert(arg1_118.type, "type should be exist")

	local var0_118 = arg0_118:GetUnitModuleWithType(arg1_118.type, arg1_118.id)

	if var0_118 then
		var0_118:StopMove()
	end
end

function var0_0.OnRemoveUnit(arg0_119, arg1_119, arg2_119)
	local var0_119 = arg0_119:GetUnitListByKey(arg1_119)
	local var1_119 = 0

	for iter0_119, iter1_119 in ipairs(var0_119 or {}) do
		if iter1_119.id == arg2_119 then
			var1_119 = iter0_119

			break
		end
	end

	if var1_119 > 0 then
		local var2_119 = var0_119[var1_119]

		for iter2_119 = #arg0_119.pathfinders, 1, -1 do
			local var3_119 = arg0_119.pathfinders[iter2_119]

			if var3_119:IsSameUnit(var2_119) then
				var3_119:Dispose()
				table.remove(arg0_119.pathfinders, iter2_119)
			end
		end

		arg0_119:RemoveUnit(var2_119)
		var2_119:Dispose()
		arg0_119:OnHideUnitHudAndOpBtn({
			type = arg1_119,
			id = var2_119.id
		}, true)
		arg0_119:GetSubView(IslandTopHeadHudView):HideHud({
			type = arg1_119,
			id = arg2_119
		})
		arg0_119:GetSubView(IslandBottomHeadHudView):HideAnimationOp(var2_119)
		arg0_119:GetSubView(IslandInteractionView):CloseInterActionPanelByUnitIdRemove(arg2_119)
	end
end

function var0_0.GetAllUnits(arg0_120)
	table.clear(arg0_120._unitList)

	for iter0_120, iter1_120 in pairs(arg0_120:GetUnitListRegitser()) do
		for iter2_120, iter3_120 in pairs(iter1_120) do
			table.insert(arg0_120._unitList, iter3_120)
		end
	end

	return arg0_120._unitList
end

function var0_0.GetUnitModuleWithType(arg0_121, arg1_121, arg2_121)
	if arg1_121 == IslandConst.UNIT_LIST_PLAYER and arg2_121 == 0 then
		return arg0_121.player
	end

	local var0_121 = arg0_121:GetUnitListByKey(arg1_121)

	for iter0_121, iter1_121 in ipairs(var0_121) do
		if iter1_121.id == arg2_121 then
			return iter1_121
		end
	end

	return nil
end

function var0_0.GetPlayerUnitModule(arg0_122, arg1_122)
	return arg0_122:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_122)
end

function var0_0.GetUnitModule(arg0_123, arg1_123)
	return arg0_123:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_123)
end

function var0_0.GetSystemModule(arg0_124, arg1_124)
	return arg0_124:GetUnitModuleWithType(IslandConst.UNIT_LIST_SYSTEM, arg1_124)
end

function var0_0.GetProductSystemModule(arg0_125, arg1_125)
	return arg0_125:GetUnitModuleWithType(IslandConst.UNIT_LIST_PRODUCT_SYSTEM, arg1_125)
end

function var0_0.GetSystemUnitModule(arg0_126, arg1_126)
	return arg0_126:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_126)
end

function var0_0.GetStrollUnitModule(arg0_127, arg1_127)
	return arg0_127:GetUnitModuleWithType(IslandConst.UNIT_LIST_STROLL, arg1_127)
end

function var0_0.GetManageSystemModule(arg0_128, arg1_128)
	return arg0_128:GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE_SYSTEM, arg1_128)
end

function var0_0.GetFollowerModule(arg0_129, arg1_129)
	return arg0_129:GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg1_129)
end

function var0_0.OnMovePlayerBefore(arg0_130)
	if arg0_130.player:CheckMovement() and arg0_130.isLockPlayInput then
		arg0_130.isLockPlayInput = false
	end

	arg0_130:GetSubView(IslandAniamtionOpView):OnMovePlayerBefore()
end

function var0_0.OnLockPlayerInput(arg0_131)
	if arg0_131.playerInputing then
		arg0_131.isLockPlayInput = true

		arg0_131.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerMove(arg0_132, arg1_132)
	if arg0_132.isLockPlayInput then
		return
	end

	arg0_132.playerInputing = true

	if arg0_132.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_132.firstTakePhotoItem:MoveHandle(arg1_132.targetDir, arg1_132.force)
	elseif arg0_132.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_132.thirdTakePhotoItem:MoveHandle(arg1_132.targetDir, arg1_132.force)
	else
		arg0_132.player:MoveHandle(arg1_132.targetDir, arg1_132.force)
	end
end

function var0_0.OnPlayerStopMove(arg0_133)
	if arg0_133.isLockPlayInput then
		arg0_133.isLockPlayInput = false
	end

	arg0_133.playerInputing = true

	if arg0_133.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_133.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_133.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_133.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_133.player:StopMoveHandle()
	end
end

function var0_0.OnPlayerStopMoveHandle(arg0_134)
	if arg0_134.isLockPlayInput then
		arg0_134.isLockPlayInput = false
	end

	arg0_134.playerInputing = true

	if arg0_134.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_134.firstTakePhotoItem:StopMoveHandle()
	elseif arg0_134.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_134.thirdTakePhotoItem:StopMoveHandle()
	else
		arg0_134.player:StopMoveHandleByInput()
	end
end

function var0_0.OnPlayerJump(arg0_135)
	if arg0_135.takePhotoModel == IslandConst.TakePhotoModel.First or arg0_135.takePhotoModel == IslandConst.TakePhotoModel.Third then
		return
	end

	arg0_135.player:JumpHandle()
end

function var0_0.OnPlayerPlayerRun(arg0_136)
	arg0_136.player:PlayerRunHandle()
end

function var0_0.OnPlayerPlayerSprint(arg0_137)
	if arg0_137.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_137.firstTakePhotoItem:OnPlayerPlayerSprint()
	elseif arg0_137.takePhotoModel == IslandConst.TakePhotoModel.Third then
		-- block empty
	else
		arg0_137.player:OnPlayerPlayerSprint()
	end
end

function var0_0.OnStopPlayerSprint(arg0_138)
	if arg0_138.takePhotoModel == IslandConst.TakePhotoModel.First then
		arg0_138.firstTakePhotoItem:OnStopPlayerSprint()
	elseif arg0_138.takePhotoModel == IslandConst.TakePhotoModel.Third then
		arg0_138.thirdTakePhotoItem:OnStopPlayerSprint()
	else
		arg0_138.player:OnStopPlayerSprint()
	end
end

function var0_0.OnPlayerWork(arg0_139, arg1_139, arg2_139)
	arg0_139.player:WorkHandle(arg1_139, arg2_139)
end

function var0_0.OnPlayerDeviceStateChange(arg0_140, arg1_140)
	arg0_140.player:DeviceStateHandle(arg1_140)
end

function var0_0.OnSetVisitorSyncData(arg0_141, arg1_141, arg2_141)
	local var0_141 = arg0_141:GetPlayerUnitModule(arg1_141)

	if var0_141 then
		var0_141:UpdateSyncData(arg2_141)
	end
end

function var0_0.OnWorldObjectStartInteraction(arg0_142, arg1_142, arg2_142, arg3_142)
	local var0_142 = arg2_142:GetHostId()
	local var1_142 = arg2_142:GetUserId()
	local var2_142 = arg0_142:GetUnitModule(var0_142)
	local var3_142 = arg0_142:GetPlayerUnitModule(var1_142)
	local var4_142 = arg0_142.player == var3_142

	if var4_142 then
		arg0_142:GetSubView(IslandOpView):StartInteraction()
	end

	local var5_142 = arg1_142:GetTimeline()[arg3_142]
	local var6_142 = arg1_142:GetBlackboardParam()[arg3_142]

	var2_142:StartInteract(var3_142, arg2_142.id, arg3_142, var5_142, var6_142, arg1_142:AnySlotUsing(), var4_142)
end

function var0_0.OnWorldObjectEndInteraction(arg0_143, arg1_143, arg2_143)
	local var0_143 = arg2_143:GetHostId()
	local var1_143 = arg2_143:GetUserId()
	local var2_143 = arg0_143:GetUnitModule(var0_143)
	local var3_143 = arg0_143:GetPlayerUnitModule(var1_143)
	local var4_143 = arg0_143.player == var3_143

	if var4_143 then
		arg0_143:GetSubView(IslandOpView):EndInteraction()
	end

	var2_143:EndInteract(var3_143, arg2_143.id, not arg1_143:AnySlotUsing(), var4_143)
end

function var0_0.OnWorldObjectInitStatus(arg0_144, arg1_144, arg2_144)
	local var0_144 = arg0_144:GetUnitModule(arg1_144.id)
	local var1_144 = arg1_144:GetTimeline()[arg2_144]
	local var2_144 = arg1_144:GetBlackboardParam()[arg2_144]

	var0_144:InitStatus(arg2_144, var1_144, var2_144)
end

function var0_0.InitInteractionOpView(arg0_145)
	arg0_145:GetSubView(IslandOpView):EndInteraction()
end

function var0_0.OnPlayerAreaChange(arg0_146)
	arg0_146.detectionSystem:SetAreaDetection()
end

function var0_0.OnChangeDress(arg0_147, arg1_147, arg2_147)
	arg0_147.player:OnChangeDress(arg1_147, arg2_147)
end

function var0_0.OnCharacterChangeDress(arg0_148, arg1_148, arg2_148, arg3_148, arg4_148)
	local var0_148 = arg0_148:GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATION, arg1_148)

	if var0_148 then
		var0_148:OnCharacterChangeDress(arg2_148, arg3_148, arg4_148)
	end

	local var1_148 = arg0_148:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_148, iter1_148 in ipairs(var1_148) do
		if iter1_148:GetDataVO():IsSameShip(arg1_148) then
			iter1_148:OnCharacterChangeDress(arg2_148, arg3_148, arg4_148)
		end
	end

	local var2_148 = arg0_148:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter2_148, iter3_148 in ipairs(var2_148) do
		if iter3_148:GetDataVO():IsSameShip(arg1_148) then
			iter3_148:OnCharacterChangeDress(arg2_148, arg3_148, arg4_148)
		end
	end
end

function var0_0.OnMorphFormChange(arg0_149, arg1_149, arg2_149, arg3_149, arg4_149, arg5_149)
	local var0_149 = arg0_149:GetPlayerUnitModule(arg0_149.player.id)

	if not var0_149 then
		existCall(arg5_149)

		return
	end

	local var1_149 = var0_149.shipDressHelper

	if not var1_149 then
		existCall(arg5_149)

		return
	end

	var0_149:PlayAnimation(arg4_149, 0.25, function()
		var1_149:ChangeDressByType(IslandShipDressHelperNew.DressType.Body, {
			colorId = 0,
			id = arg2_149
		})
		var1_149:ChangeDressByType(IslandShipDressHelperNew.DressType.Hat, {
			colorId = 0,
			id = arg3_149
		})
		existCall(arg5_149)
	end)
end

function var0_0.OnStartDelegation(arg0_151, arg1_151, arg2_151)
	local var0_151 = arg0_151:GetSystemModule(arg1_151.build_id)

	if var0_151 then
		var0_151:StartDelegation(arg1_151)
	end

	local var1_151 = arg0_151:GetProductSystemModule(arg1_151.build_id)

	if var1_151 then
		var1_151:StartDelegation(arg2_151)
	end
end

function var0_0.OnEndDelegation(arg0_152, arg1_152, arg2_152)
	local var0_152 = arg0_152:GetSystemModule(arg1_152.build_id)

	if var0_152 then
		var0_152:EndDelegation(arg1_152)
	end
end

function var0_0.GetPlayerPosition(arg0_153)
	return arg0_153.player:GetCurrentPosition()
end

function var0_0.GetPlayerLastGroundedPosition(arg0_154)
	return arg0_154.player:LastGroundedPosition()
end

function var0_0.GetUnitPosition(arg0_155, arg1_155)
	local var0_155 = arg0_155:GetUnitModule(arg1_155)

	return var0_155 and var0_155._go.transform.position
end

function var0_0.OnShowUnitHudAndOpBtn(arg0_156, arg1_156)
	arg0_156.currentHudUnitData = arg1_156

	arg0_156:GetSubView(IslandSlotHudView):ShowHud(arg1_156.id, arg1_156.height)
	arg0_156:GetSubView(IslandOpView):UpdateOperationButton(arg1_156.operationType, arg1_156.id)

	if arg1_156.isHighLightControl then
		arg0_156.detectionSystem:HighLightUnitHandle(arg1_156.id, true)
	end
end

function var0_0.OnHideUnitHudAndOpBtn(arg0_157, arg1_157, arg2_157)
	if not arg0_157.currentHudUnitData then
		return
	end

	if arg0_157.currentHudUnitData.id ~= arg1_157.id or arg0_157.currentHudUnitData.type ~= arg1_157.type then
		return
	end

	if not arg2_157 then
		arg0_157.currentHudUnitData = nil
	end

	arg0_157:GetSubView(IslandSlotHudView):HideUnitHud(arg1_157.id)
	arg0_157:GetSubView(IslandOpView):UpdateOperationButton(IslandOpView.OperationType.None, arg1_157.id)

	if arg1_157.isHighLightControl then
		arg0_157.detectionSystem:HighLightUnitHandle(arg1_157.id, false)
	end
end

function var0_0.OnUpdateHud(arg0_158, arg1_158)
	if not arg0_158.currentHudUnitData then
		return
	end

	if arg1_158 ~= arg0_158.currentHudUnitData.id then
		return
	end

	arg0_158:GetSubView(IslandSlotHudView):UpdateHud(arg0_158.currentHudUnitData.id, arg0_158.currentHudUnitData.height)
	arg0_158:GetSubView(IslandOpView):UpdateOperationButton(arg0_158.currentHudUnitData.operationType, arg0_158.currentHudUnitData.id)
end

function var0_0.OnUpdateHandCollectUnit(arg0_159, arg1_159)
	local var0_159 = arg0_159:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_159)

	if var0_159 then
		var0_159:UpdateHandCollet()
		var0_159:ResetHp()
	end
end

function var0_0.OnShowHud(arg0_160, arg1_160)
	arg0_160:GetSubView(IslandTopHeadHudView):ShowHud(arg1_160)
	arg0_160:GetSubView(IslandDistanceView):ShowHud(arg1_160.id)
end

function var0_0.OnRefreshHud(arg0_161, arg1_161)
	arg0_161:GetSubView(IslandTopHeadHudView):RefreshHud(arg1_161)
end

function var0_0.OnHideHud(arg0_162, arg1_162)
	arg0_162:GetSubView(IslandTopHeadHudView):HideHud(arg1_162)
	arg0_162:GetSubView(IslandDistanceView):HideHud(arg1_162.id)
end

function var0_0.OnDelegateSlotStartPerform(arg0_163, arg1_163)
	local var0_163 = arg0_163:GetUnitModuleWithType(arg1_163.type, arg1_163.id)

	if var0_163 then
		var0_163:DelegateSlotStartPerform()
	end
end

function var0_0.OnPlayEffect(arg0_164, arg1_164, arg2_164, arg3_164)
	local var0_164
	local var1_164 = arg0_164:GetUnitListByKey(IslandConst.UNIT_LIST_STROLL)

	for iter0_164, iter1_164 in ipairs(var1_164) do
		if iter1_164:GetDataVO():IsSameShip(arg1_164) then
			var0_164 = iter1_164

			break
		end
	end

	local var2_164 = arg0_164:GetSubView(IslandEffectView)

	if var2_164 and var0_164 then
		var2_164:Play(var0_164, arg2_164, arg3_164)
	end
end

function var0_0.OnRecycleAllSlotEffct(arg0_165)
	arg0_165.effectMgr:RecycleAllSlotEffct()
end

function var0_0.OnLoadDelegatePreviewRole(arg0_166, arg1_166, arg2_166)
	arg0_166.effectMgr:LoadDelegatePreviewRole(arg1_166, arg2_166)
end

function var0_0.OnUnLoadDelegatePreviewRole(arg0_167)
	arg0_167.effectMgr:UnLoadDelegatePreviewRole()
end

function var0_0.OnSelectSlotEffectShow(arg0_168, arg1_168, arg2_168, arg3_168, arg4_168)
	arg0_168.effectMgr:SelectSlotEffectShow(arg1_168, arg2_168, arg3_168, arg4_168)
end

function var0_0.OnTakePlantAttack(arg0_169, arg1_169)
	local var0_169 = arg0_169:GetUnitModuleWithType(arg1_169.type, arg1_169.id)

	if var0_169 then
		var0_169:TakeAttack()
	end
end

function var0_0.OnStartManage(arg0_170, arg1_170)
	local var0_170 = arg0_170:GetManageSystemModule(arg1_170.id)

	if var0_170 then
		var0_170:StartManage(arg1_170)
	end
end

function var0_0.OnEndManage(arg0_171, arg1_171)
	local var0_171 = arg0_171:GetManageSystemModule(arg1_171.id)

	if var0_171 then
		var0_171:EndManage(arg1_171)
	end
end

function var0_0.OnRefreshTaskInfoHud(arg0_172)
	arg0_172:GetSubView(IslandTopHeadHudView):UpdateAllHud()
end

function var0_0.OnRefreshWeatherSystem(arg0_173)
	arg0_173.weatherSystem:Play()
end

function var0_0.OnDispose(arg0_174)
	arg0_174.detectionSystem:Dispose()
	arg0_174.effectMgr:Dispose()
	arg0_174.coupleActionPlayer:Dispose()
	arg0_174.coupleAction4FollowerPlayer:Dispose()
	arg0_174.npcActionPlayer:Dispose()
	arg0_174.weatherSystem:Dispose()
	arg0_174.coupleNpcWordPlayer:Dispose()
	arg0_174:GetPoolMgr():ClearFishingEffect()

	for iter0_174, iter1_174 in ipairs(arg0_174.views) do
		iter1_174:Dispose()
	end

	for iter2_174, iter3_174 in ipairs(arg0_174.pathfinders) do
		iter3_174:Dispose()
	end

	for iter4_174, iter5_174 in ipairs(arg0_174:GetAllUnits()) do
		iter5_174:Dispose()
	end

	for iter6_174, iter7_174 in pairs(arg0_174.unitBuilders) do
		iter7_174:Dispose()
	end

	for iter8_174, iter9_174 in pairs(arg0_174.systemBuilders) do
		iter9_174:Dispose()
	end

	for iter10_174, iter11_174 in pairs(arg0_174.fishingSynPlayers) do
		iter11_174:Dispose()
	end

	arg0_174.fishingSynPlayers = nil
	arg0_174.npcActionPlayer = nil
	arg0_174.coupleActionPlayer = nil
	arg0_174.coupleAction4FollowerPlayer = nil
	arg0_174.pathfinders = nil
	arg0_174.unitBuilders = nil
	arg0_174.systemBuilders = nil
	arg0_174.views = nil
	arg0_174.player = nil
	arg0_174.isInit = false
	arg0_174._unitList = nil
	arg0_174.detectionSystem = nil
	arg0_174.effectMgr = nil
	arg0_174.coupleNpcWordPlayer = nil
	arg0_174.weatherSystem = nil
end

return var0_0
