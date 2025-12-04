local var0_0 = class("IslandController", import(".IslandBaseController"))

function var0_0.Init(arg0_1)
	arg0_1.sceneData = IslandDataConvertor.Island2SceneData(arg0_1.island)
	arg0_1.mapId = arg0_1.sceneData.mapId
end

function var0_0.SetUp(arg0_2)
	arg0_2.strollAllocator = IslandStrollAllocator.New(arg0_2)
	arg0_2.visibilityAllocator = IslandVisibilityAllocator.New(arg0_2)
	arg0_2.giftAllocator = IslandGiftAllocator.New(arg0_2)
	arg0_2.activityNpcAllocator = IslandActivityNpcAllocator.New(arg0_2)
	arg0_2.timeDelayCreate = IslandDelayCreationSystem.New(arg0_2)
	arg0_2.playerInputManager = PlayerInputManager.New(arg0_2)
	arg0_2.islandSyncMgr = IslandSyncMgr.New(arg0_2)

	for iter0_2, iter1_2 in ipairs(arg0_2.sceneData.unitList) do
		if arg0_2.visibilityAllocator:IsVisible(iter1_2.id) then
			arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter1_2)
		end
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.sceneData.activityUnits) do
		if arg0_2.activityNpcAllocator:IsVisible(iter3_2.id) then
			arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_2)
		end
	end

	for iter4_2, iter5_2 in ipairs(arg0_2.sceneData.giftUnits) do
		if arg0_2.giftAllocator:IsVisible(iter4_2) then
			arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter5_2)
		end
	end

	for iter6_2, iter7_2 in ipairs(arg0_2.sceneData.systemList) do
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_SYSTEM, iter7_2)
	end

	for iter8_2, iter9_2 in ipairs(arg0_2.sceneData.systemUnits) do
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter9_2)
	end

	for iter10_2, iter11_2 in ipairs(arg0_2.sceneData.strollUnits) do
		local var0_2, var1_2 = arg0_2.strollAllocator:Allocator(iter11_2:GetDefaultPathId(arg0_2.mapId))

		iter11_2:SetPath(var0_2, var1_2)
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter11_2)
	end

	for iter12_2, iter13_2 in ipairs(arg0_2.sceneData.followUnits) do
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter13_2)
	end

	arg0_2.timeDelayCreate:InitUnit()
end

function var0_0.ResetPlayerPosition(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.sceneData.unitList) do
		if iter1_3:IsPlayer() then
			arg0_3:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, iter1_3.id, IslandConst.UNIT_LIST_PLAYER, iter1_3.position)
		end
	end
end

function var0_0.OnCoreInitFinish(arg0_4)
	arg0_4:NotifiyCore(ISLAND_EVT.INIT_FINISH, arg0_4.sceneData.camreaZoomData)
	arg0_4:NotifiyIsland(ISLAND_EX_EVT.INIT_FINISH)
	arg0_4.playerInputManager:Init()
	arg0_4:InitSyncMgr()
	arg0_4:InitStrollUnitsAwards()
end

function var0_0.InitStrollUnitsAwards(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.sceneData.strollUnits) do
		if iter1_5:ExistActionFeedback() then
			arg0_5:NotifiyCore(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, iter1_5)
		end
	end
end

function var0_0.GetMapID(arg0_6)
	return arg0_6.mapId
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_7.OnPlayerAdd)
	arg0_7:AddIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_7.OnPlayerExit)
	arg0_7:AddIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_7.OnPlayerChangeDress)
	arg0_7:AddIslandListener(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, arg0_7.OnShipChangeDress)
	arg0_7:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_7.OnSyncDataUpdate)
	arg0_7:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_7.OnSyncObjUpdate)
	arg0_7:AddIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, arg0_7.OnCollectSlotUnitInit)
	arg0_7:AddIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_UPDATE, arg0_7.OnCollectSlotUnitUpdate)
	arg0_7:AddIslandListener(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, arg0_7.OnCollectSloSlotUnitRemove)
	arg0_7:AddIslandListener(IslandStartDelegationCommand.START_DELEGATION, arg0_7.OnStartDelegation)
	arg0_7:AddIslandListener(IslandFinishDelegationCommand.END_DELEGATION, arg0_7.OnEndDelegation)
	arg0_7:AddIslandListener(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, arg0_7.OnGetAllDelegationAward)
	arg0_7:AddIslandListener(IslandTaskAgency.TASK_ADDED, arg0_7.OnTaskAdd)
	arg0_7:AddIslandListener(IslandTaskAgency.TASK_FINISH, arg0_7.OnFinishTask)
	arg0_7:AddIslandListener(IslandTaskAgency.TASK_UPDATED, arg0_7.OnUpdateTask)
	arg0_7:AddIslandListener(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, arg0_7.OnStartPlant)
	arg0_7:AddIslandListener(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, arg0_7.OnEndPlant)
	arg0_7:AddIslandListener(IslandSlotCollectCommand.START_HAND_COLLECT_DONE, arg0_7.OnStartHandCollect)
	arg0_7:AddIslandListener(IslandBuildingAgency.SLOT_HANDPLABT_SLOT_UNIT_CHANGE, arg0_7.OnHandPlantSlotChangeUnit)
	arg0_7:AddIslandListener(IslandBuildingAgency.CHANGE_PRODUCT_MODEL, arg0_7.OnProductPlaceChangeUnit)
	arg0_7:AddIslandListener(IslandGatherCollectAgency.RemoveGatherUnit, arg0_7.OnRemoveWildGatherDone)
	arg0_7:AddIslandListener(IslandGatherCollectAgency.AddGatherUnit, arg0_7.OnAddWildGatherDone)
	arg0_7:AddIslandListener(ISLAND_EVT.CHANGE_SLOT_MODEL, arg0_7.OnChangeSlotModel)
	arg0_7:AddIslandListener(IslandOpenRestaurantCommand.OPEN_RESTAURANT, arg0_7.OnOpenRestaurant)
	arg0_7:AddIslandListener(IslandCloseRestaurantCommand.CLOSE_RESTAURANT, arg0_7.OnCloseRestaurant)
	arg0_7:AddIslandListener(IslandProxy.STORY_START, arg0_7.OnStartStory)
	arg0_7:AddIslandListener(IslandProxy.STORY_END, arg0_7.OnEndStory)
	arg0_7:AddIslandListener(IslandProxy.PERFORMANCE_START, arg0_7.OnStartPerformance)
	arg0_7:AddIslandListener(IslandProxy.PERFORMANCE_END, arg0_7.OnEndPerformance)
	arg0_7:AddIslandListener(IslandProxy.START_PATHFINDER, arg0_7.OnStartPathFinder)
	arg0_7:AddIslandListener(IslandProxy.END_PATHFINDER, arg0_7.OnEndPathFinder)
	arg0_7:AddIslandListener(IslandProxy.ACTIVE_OR_DISABLE_UNIT, arg0_7.OnActiveOrDisableUnit)
	arg0_7:AddIslandListener(IslandProxy.LINK_CORE, arg0_7.OnLinkCore)
	arg0_7:AddIslandListener(IslandBuildingAgency.GEN_ANIMAL_INT, arg0_7.OnAnimalInit)
	arg0_7:AddIslandListener(IslandBuildingAgency.SLOT_DELEGATE_INIT, arg0_7.OnSlotDelegateInit)
	arg0_7:AddIslandListener(IslandNpcFeedbackAgency.NPC_ACTION_CHANGE, arg0_7.OnNpcActionFeedBackChange)
	arg0_7:AddIslandListener(IslandNpcFeedbackAgency.RESET_NPC_ACTIONS, arg0_7.OnResetNpcActionFeedback)
	arg0_7:AddIslandListener(IslandFollowerAgency.ADD_FOLLOWER, arg0_7.OnAddFollower)
	arg0_7:AddIslandListener(IslandFollowerAgency.DEL_FOLLOWER, arg0_7.OnDelFollower)
	arg0_7:AddIslandListener(ActivityProxy.ACTIVITY_UPDATED, arg0_7.OnActivityUpdate)
	arg0_7:AddIslandListener(IslandProxy.GEN_RECYCLEITEM, arg0_7.OnGenRecycleItem)
	arg0_7:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_ADD, arg0_7.OnActivityNpcAdd)
	arg0_7:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_UPDATE, arg0_7.OnActivityNpcUpdate)
	arg0_7:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_DEL, arg0_7.OnActivityNpcDel)
	arg0_7:AddIslandListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_7.OnSystemUnlock)
	arg0_7:AddIslandListener(IslandProxy.LOCK_NPC_REFRESH, arg0_7.OnLockNpcRefresh)
	arg0_7:AddIslandListener(IslandProxy.RELEASE_NPC_REFRESH, arg0_7.OnReleaseNpcRefresh)
	arg0_7:AddIslandListener(IslandProxy.RESET_SP, arg0_7.OnResetSp)
	arg0_7:AddIslandListener(IslandFishingAgency.BAIT_UPDATE, arg0_7.OnBaitUpdate)
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_8.OnPlayerAdd)
	arg0_8:RemoveIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_8.OnPlayerExit)
	arg0_8:RemoveIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_8.OnPlayerChangeDress)
	arg0_8:RemoveIslandListener(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, arg0_8.OnShipChangeDress)
	arg0_8:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_8.OnSyncDataUpdate)
	arg0_8:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_8.OnSyncObjUpdate)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, arg0_8.OnCollectSlotUnitInit)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_UPDATE, arg0_8.OnCollectSlotUnitUpdate)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, arg0_8.OnCollectSloSlotUnitRemove)
	arg0_8:RemoveIslandListener(IslandStartDelegationCommand.START_DELEGATION, arg0_8.OnStartDelegation)
	arg0_8:RemoveIslandListener(IslandFinishDelegationCommand.END_DELEGATION, arg0_8.OnEndDelegation)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, arg0_8.OnGetAllDelegationAward)
	arg0_8:RemoveIslandListener(IslandTaskAgency.TASK_ADDED, arg0_8.OnTaskAdd)
	arg0_8:RemoveIslandListener(IslandTaskAgency.TASK_FINISH, arg0_8.OnFinishTask)
	arg0_8:RemoveIslandListener(IslandTaskAgency.TASK_UPDATED, arg0_8.OnUpdateTask)
	arg0_8:RemoveIslandListener(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, arg0_8.OnStartPlant)
	arg0_8:RemoveIslandListener(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, arg0_8.OnEndPlant)
	arg0_8:RemoveIslandListener(IslandSlotCollectCommand.START_HAND_COLLECT_DONE, arg0_8.OnStartHandCollect)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.SLOT_HANDPLABT_SLOT_UNIT_CHANGE, arg0_8.OnHandPlantSlotChangeUnit)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.CHANGE_PRODUCT_MODEL, arg0_8.OnProductPlaceChangeUnit)
	arg0_8:RemoveIslandListener(IslandGatherCollectAgency.RemoveGatherUnit, arg0_8.OnRemoveWildGatherDone)
	arg0_8:RemoveIslandListener(IslandGatherCollectAgency.AddGatherUnit, arg0_8.OnAddWildGatherDone)
	arg0_8:RemoveIslandListener(ISLAND_EVT.CHANGE_SLOT_MODEL, arg0_8.OnChangeSlotModel)
	arg0_8:RemoveIslandListener(IslandOpenRestaurantCommand.OPEN_RESTAURANT, arg0_8.OnOpenRestaurant)
	arg0_8:RemoveIslandListener(IslandProxy.STORY_START, arg0_8.OnStartStory)
	arg0_8:RemoveIslandListener(IslandProxy.STORY_END, arg0_8.OnEndStory)
	arg0_8:RemoveIslandListener(IslandProxy.PERFORMANCE_START, arg0_8.OnStartPerformance)
	arg0_8:RemoveIslandListener(IslandProxy.PERFORMANCE_END, arg0_8.OnEndPerformance)
	arg0_8:RemoveIslandListener(IslandProxy.START_PATHFINDER, arg0_8.OnStartPathFinder)
	arg0_8:RemoveIslandListener(IslandProxy.END_PATHFINDER, arg0_8.OnEndPathFinder)
	arg0_8:RemoveIslandListener(IslandProxy.ACTIVE_OR_DISABLE_UNIT, arg0_8.OnActiveOrDisableUnit)
	arg0_8:RemoveIslandListener(IslandProxy.LINK_CORE, arg0_8.OnLinkCore)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.GEN_ANIMAL_INT, arg0_8.OnAnimalInit)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.SLOT_DELEGATE_INIT, arg0_8.OnSlotDelegateInit)
	arg0_8:RemoveIslandListener(IslandNpcFeedbackAgency.NPC_ACTION_CHANGE, arg0_8.OnNpcActionFeedBackChange)
	arg0_8:RemoveIslandListener(IslandNpcFeedbackAgency.RESET_NPC_ACTIONS, arg0_8.OnResetNpcActionFeedback)
	arg0_8:RemoveIslandListener(IslandFollowerAgency.ADD_FOLLOWER, arg0_8.OnAddFollower)
	arg0_8:RemoveIslandListener(IslandFollowerAgency.DEL_FOLLOWER, arg0_8.OnDelFollower)
	arg0_8:RemoveIslandListener(ActivityProxy.ACTIVITY_UPDATED, arg0_8.OnActivityUpdate)
	arg0_8:RemoveIslandListener(IslandProxy.GEN_RECYCLEITEM, arg0_8.OnGenRecycleItem)
	arg0_8:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_ADD, arg0_8.OnActivityNpcAdd)
	arg0_8:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_UPDATE, arg0_8.OnActivityNpcUpdate)
	arg0_8:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_DEL, arg0_8.OnActivityNpcDel)
	arg0_8:RemoveIslandListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_8.OnSystemUnlock)
	arg0_8:RemoveIslandListener(IslandProxy.LOCK_NPC_REFRESH, arg0_8.OnLockNpcRefresh)
	arg0_8:RemoveIslandListener(IslandProxy.RELEASE_NPC_REFRESH, arg0_8.OnReleaseNpcRefresh)
	arg0_8:RemoveIslandListener(IslandProxy.RESET_SP, arg0_8.OnResetSp)
	arg0_8:RemoveIslandListener(IslandFishingAgency.BAIT_UPDATE, arg0_8.OnBaitUpdate)
end

function var0_0.OnBaitUpdate(arg0_9, arg1_9)
	arg0_9:NotifiyCore(ISLAND_EVT.BAIT_UPDATE, arg1_9)
end

function var0_0.OnResetSp(arg0_10)
	local var0_10 = arg0_10.mapId
	local var1_10 = pg.island_world_objects.get_id_list_by_mapId[var0_10] or {}

	for iter0_10, iter1_10 in ipairs(var1_10) do
		local var2_10 = pg.island_world_objects[iter1_10]

		if var2_10.unitId == 0 then
			spConfig = var2_10

			break
		end
	end

	if not spConfig then
		return
	end

	local var3_10 = BuildVector3(spConfig.param.position)
	local var4_10 = BuildVector3(spConfig.param.rotation)
	local var5_10 = getProxy(PlayerProxy):getRawData().id

	arg0_10:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, var5_10, IslandConst.UNIT_LIST_PLAYER, var3_10)
	arg0_10:NotifiyCore(ISLAND_EVT.RESET_UNIT_ROT, var5_10, IslandConst.UNIT_LIST_PLAYER, var4_10)
end

function var0_0.OnLockNpcRefresh(arg0_11, arg1_11, arg2_11)
	arg0_11.visibilityAllocator:LockNpc(arg1_11, arg2_11)
end

function var0_0.OnReleaseNpcRefresh(arg0_12, arg1_12, arg2_12)
	arg0_12.visibilityAllocator:ReleaseNpc(arg1_12, arg2_12)
end

function var0_0.OnSystemUnlock(arg0_13, arg1_13)
	arg0_13:NotifiyCore(ISLAND_EVT.SYSTEM_UNLOCK, arg1_13)
end

function var0_0.OnActivityNpcAdd(arg0_14, arg1_14)
	arg0_14.activityNpcAllocator:AddNpc(arg1_14)
	arg0_14.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcUpdate(arg0_15, arg1_15, arg2_15)
	arg0_15.activityNpcAllocator:DelNpc(arg1_15)
	arg0_15.activityNpcAllocator:AddNpc(arg2_15)
	arg0_15.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcDel(arg0_16, arg1_16)
	arg0_16.activityNpcAllocator:DelNpc(arg1_16)
	arg0_16.activityNpcAllocator:Flush()
end

function var0_0.OnActivityUpdate(arg0_17)
	arg0_17.activityNpcAllocator:Flush()
end

function var0_0.OnGenRecycleItem(arg0_18, arg1_18)
	local var0_18 = IslandDataConvertor.GenDelayRecycleIslandUnit(arg1_18)

	arg0_18:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_18)
end

function var0_0.OnAddFollower(arg0_19, arg1_19)
	local var0_19 = #arg0_19.sceneData.followUnits > 0
	local var1_19 = arg0_19:GetIsland():GetCharacterAgency():GetShipById(arg1_19)
	local var2_19 = var1_19:GetModelUnit()
	local var3_19 = arg0_19:GetView():GetPlayerPosition()
	local var4_19 = IslandFollowerUnitVO.New(var1_19.id, arg1_19, var2_19, var3_19, Vector3(0, 0, 0), not var0_19)

	table.insert(arg0_19.sceneData.followUnits, var4_19)
	arg0_19:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_19)

	for iter0_19, iter1_19 in ipairs(arg0_19.sceneData.strollUnits) do
		if var1_19:getConfig("unit_id") == iter1_19.config.unit_id then
			arg0_19:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_STROLL, iter1_19.id)
		end
	end

	arg0_19:NotifiyCore(ISLAND_EVT.ADD_FOLLOWER, var4_19.id)
end

function var0_0.OnDelFollower(arg0_20, arg1_20)
	local var0_20 = 0

	for iter0_20, iter1_20 in ipairs(arg0_20.sceneData.followUnits) do
		if iter1_20.id == arg1_20 then
			var0_20 = iter0_20

			break
		end
	end

	if var0_20 <= 0 then
		return
	end

	local var1_20 = table.remove(arg0_20.sceneData.followUnits, var0_20)

	arg0_20:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_FOLLOW, var1_20.id)

	if var1_20:IsRandomizer() and #arg0_20.sceneData.followUnits > 0 then
		local var2_20 = arg0_20.sceneData.followUnits[1]

		var2_20:ActiveRandomizer()
		arg0_20:NotifiyCore(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, var2_20.id)
	end

	local var3_20 = arg0_20:GetIsland():GetCharacterAgency():GetShipById(arg1_20)

	for iter2_20, iter3_20 in ipairs(arg0_20.sceneData.strollUnits) do
		if var3_20:getConfig("unit_id") == iter3_20.config.unit_id then
			arg0_20:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_20)
		end
	end

	arg0_20:NotifiyCore(ISLAND_EVT.DEL_FOLLOWER, var1_20.id)
end

function var0_0.OnResetNpcActionFeedback(arg0_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.sceneData.strollUnits) do
		if iter1_21:ExistActionFeedback() then
			iter1_21:ClearActionFeedback()
			arg0_21:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_21)
		end
	end

	IslandDataConvertor.DistributeAward4StrollUnits(arg0_21.sceneData.strollUnits, arg0_21:GetIsland())
	arg0_21:InitStrollUnitsAwards()
end

function var0_0.OnNpcActionFeedBackChange(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.sceneData.strollUnits) do
		if iter1_22.id == arg1_22 and iter1_22:ExistActionFeedback() then
			iter1_22:ClearActionFeedback()
			arg0_22:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_22)
		end
	end
end

function var0_0.OnLinkCore(arg0_23, arg1_23, ...)
	arg0_23:NotifiyCore(arg1_23, ...)
end

function var0_0.OnActiveOrDisableUnit(arg0_24, arg1_24, arg2_24, arg3_24)
	arg0_24:NotifiyCore(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg1_24, arg2_24, arg3_24)
end

function var0_0.OnStartPathFinder(arg0_25, arg1_25)
	arg0_25:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, arg1_25)
end

function var0_0.OnEndPathFinder(arg0_26)
	arg0_26.visibilityAllocator:Flush()
end

function var0_0.OnStartPerformance(arg0_27)
	arg0_27:NotifiyCore(ISLAND_EVT.START_STORY)
	arg0_27:NotifiyCore(ISLAND_EVT.START_PERFORMANCE)
end

function var0_0.OnEndPerformance(arg0_28, arg1_28)
	arg0_28:NotifiyCore(ISLAND_EVT.END_STORY)
	arg0_28:NotifiyCore(ISLAND_EVT.END_PERFORMANCE)

	if arg1_28 then
		arg0_28:OnUpdateTask()
	end
end

function var0_0.OnStartStory(arg0_29)
	arg0_29:NotifiyCore(ISLAND_EVT.START_STORY)
end

function var0_0.OnEndStory(arg0_30, arg1_30)
	arg0_30:NotifiyCore(ISLAND_EVT.END_STORY)

	if arg1_30 then
		arg0_30.visibilityAllocator:Flush()
	end
end

function var0_0.OnTaskAdd(arg0_31)
	arg0_31.visibilityAllocator:Flush()
	arg0_31:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_31:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnFinishTask(arg0_32)
	arg0_32.visibilityAllocator:Flush()
	arg0_32:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_32:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnUpdateTask(arg0_33)
	arg0_33:Debounce("RefreshTask", function()
		if not arg0_33.visibilityAllocator then
			return
		end

		arg0_33.visibilityAllocator:Flush()
		arg0_33:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
		arg0_33:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	end, 0.5, false)()
end

function var0_0.Debounce(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	if not arg0_35.__debouncers then
		arg0_35.__debouncers = {}
	end

	if not arg0_35.__debouncers[arg1_35] then
		arg0_35.__debouncers[arg1_35] = debounce(arg2_35, arg3_35, arg4_35)
	end

	return arg0_35.__debouncers[arg1_35]
end

function var0_0.OnPlayerAdd(arg0_36, arg1_36)
	local var0_36 = IslandDataConvertor.PlayerData2IslandUnit(arg1_36.player, arg0_36.mapId, arg0_36:GetIsland().id)

	arg0_36:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_36, function(arg0_37)
		arg0_36.islandSyncMgr:OnVisitorEnter(arg1_36.player.id, arg0_37)
	end)
end

function var0_0.OnPlayerExit(arg0_38, arg1_38)
	arg0_38:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_PLAYER, arg1_38.id)
	arg0_38.islandSyncMgr:OnVisitorExit(arg1_38.id)
end

function var0_0.OnPlayerChangeDress(arg0_39, arg1_39, arg2_39)
	arg0_39:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_39, arg2_39)
end

function var0_0.OnShipChangeDress(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40)
	arg0_40:NotifiyCore(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg1_40, arg2_40, arg3_40, arg4_40)
end

function var0_0.OnStartPlant(arg0_41, arg1_41)
	local var0_41

	for iter0_41, iter1_41 in ipairs(arg0_41.sceneData.productSystems) do
		if iter1_41.id == arg1_41.build_id then
			var0_41 = iter1_41

			break
		end
	end

	if not var0_41 then
		return
	end

	local var1_41 = var0_41:GetUnitIdBySlotId(arg1_41.area_id)

	arg0_41:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_41)

	local var2_41 = var0_41:GenHandPlantUnitBySlotData(arg1_41.area_id, arg1_41.formula_id)

	arg0_41:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_41)
	arg0_41:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_41)
end

function var0_0.OnEndPlant(arg0_42, arg1_42)
	local var0_42

	for iter0_42, iter1_42 in ipairs(arg0_42.sceneData.productSystems) do
		if iter1_42.id == arg1_42.build_id then
			var0_42 = iter1_42

			break
		end
	end

	if not var0_42 then
		return
	end

	local var1_42 = var0_42:GetUnitIdBySlotId(arg1_42.area_id)

	arg0_42:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_42)

	local var2_42 = var0_42:GenHandPlantUnitBySlotData(arg1_42.area_id)

	arg0_42:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_42)
	arg0_42:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_42)
end

function var0_0.OnStartDelegation(arg0_43, arg1_43)
	local var0_43

	for iter0_43, iter1_43 in ipairs(arg0_43.sceneData.systemList) do
		if isa(iter1_43, IslandCharacterSystemVO) and iter1_43.id == arg1_43.build_id then
			var0_43 = iter1_43

			break
		end
	end

	if not var0_43 then
		return
	end

	local var1_43

	for iter2_43, iter3_43 in ipairs(arg0_43.sceneData.productSystems) do
		if iter3_43.id == arg1_43.build_id then
			var1_43 = iter3_43

			break
		end
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_43.build_id) then
		local var2_43 = pg.island_production_slot[arg1_43.area_id]

		for iter4_43, iter5_43 in ipairs(var2_43.exclusion_slot) do
			local var3_43 = var1_43:GetUnitIdBySlotId(iter5_43)
			local var4_43 = var1_43:GetUnitVOByUnitId(var3_43)

			if var4_43 then
				var4_43:ChangeSlotType(IslandProductConst.ProductSlotType.RoleDelegation)
			end
		end
	end

	local var5_43 = {}

	if table.contains(IslandProductConst.havePerformPlace, arg1_43.build_id) then
		local var6_43 = var1_43:GetDelegateUnitsByBuildIdAndSlotId(arg1_43.build_id, arg1_43.area_id, arg1_43.formula_id)

		var5_43.commissionSlotId = var1_43:GetCommissionSlotId(arg1_43.area_id)
		var5_43.unitIds = {}

		for iter6_43, iter7_43 in ipairs(var6_43) do
			table.insert(var5_43.unitIds, iter7_43.id)
		end

		for iter8_43, iter9_43 in ipairs(var6_43) do
			arg0_43:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter9_43)
		end
	end

	local var7_43 = var1_43:GetDelegateEffectsByCommissonId(arg1_43.area_id)

	if var7_43 then
		local var8_43 = var1_43:GenUnitByDelegateEffectId(var7_43)

		if var8_43 then
			arg0_43:NotifiyCore(ISLAND_EVT.GEN_UNIT, var8_43)
		end
	end

	local var9_43 = var0_43:GetUnit(arg1_43.ship_id, arg1_43.area_id, true)

	if var9_43 then
		arg0_43:NotifiyCore(ISLAND_EVT.GEN_UNIT, var9_43)
	end

	arg0_43:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_43, var5_43)
end

function var0_0.OnEndDelegation(arg0_44, arg1_44)
	local var0_44

	for iter0_44, iter1_44 in ipairs(arg0_44.sceneData.systemList) do
		if isa(iter1_44, IslandCharacterSystemVO) and iter1_44.id == arg1_44.build_id then
			var0_44 = iter1_44

			break
		end
	end

	if not var0_44 then
		return
	end

	arg0_44:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_44)

	local var1_44 = var0_44:GetUnitShipIdBySlotId(arg1_44.ship_id, arg1_44.area_id)

	if var1_44 then
		arg0_44:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATION, var1_44)
	end

	local var2_44

	for iter2_44, iter3_44 in ipairs(arg0_44.sceneData.productSystems) do
		if iter3_44.id == arg1_44.build_id then
			var2_44 = iter3_44

			break
		end
	end

	if table.contains(IslandProductConst.havePerformPlace, arg1_44.build_id) then
		local var3_44 = var2_44:GetDelegatUnitsBySlotId(arg1_44.area_id)

		for iter4_44, iter5_44 in ipairs(var3_44) do
			arg0_44:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATE_UNIT, iter5_44)
		end
	end

	local var4_44 = var2_44:GetDelegateEffectsByCommissonId(arg1_44.area_id)

	if var4_44 then
		arg0_44:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_44)
	end

	if arg1_44.remainReward then
		return
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_44.build_id) then
		local var5_44 = pg.island_production_slot[arg1_44.area_id]

		for iter6_44, iter7_44 in ipairs(var5_44.exclusion_slot) do
			local var6_44 = var2_44:GetUnitIdBySlotId(iter7_44)

			arg0_44:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var6_44)

			local var7_44 = var2_44:GenHandPlantUnitBySlotData(iter7_44)

			arg0_44:NotifiyCore(ISLAND_EVT.GEN_UNIT, var7_44)
		end
	end
end

function var0_0.OnGetAllDelegationAward(arg0_45, arg1_45)
	local var0_45

	for iter0_45, iter1_45 in ipairs(arg0_45.sceneData.systemList) do
		if isa(iter1_45, IslandCharacterSystemVO) and iter1_45.id == arg1_45.build_id then
			var0_45 = iter1_45

			break
		end
	end

	if not var0_45 then
		return
	end

	local var1_45

	for iter2_45, iter3_45 in ipairs(arg0_45.sceneData.productSystems) do
		if iter3_45.id == arg1_45.build_id then
			var1_45 = iter3_45

			break
		end
	end

	if arg1_45.build_id == IslandProductConst.FarmlandPlaceId or arg1_45.build_id == IslandProductConst.OrchardPlaceId or arg1_45.build_id == IslandProductConst.GardenPlaceId then
		local var2_45 = pg.island_production_slot[arg1_45.area_id]

		for iter4_45, iter5_45 in ipairs(var2_45.exclusion_slot) do
			local var3_45 = var1_45:GetUnitIdBySlotId(iter5_45)

			arg0_45:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_45)

			local var4_45 = var1_45:GenHandPlantUnitBySlotData(iter5_45)

			arg0_45:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_45)
		end
	end
end

function var0_0.OnChangeSlotModel(arg0_46, arg1_46)
	local var0_46

	for iter0_46, iter1_46 in ipairs(arg0_46.sceneData.productSystems) do
		if iter1_46.id == IslandProductConst.FarmlandPlaceId then
			var0_46 = iter1_46

			break
		end
	end

	if not var0_46 then
		return
	end

	arg0_46:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_46.id)

	local var1_46 = var0_46:GetUnitVOByUnitId(arg1_46.id)

	var1_46.modelId = arg1_46.modelId

	arg0_46:NotifiyCore(ISLAND_EVT.GEN_UNIT, var1_46)
end

function var0_0.OnStartHandCollect(arg0_47, arg1_47)
	local var0_47

	for iter0_47, iter1_47 in ipairs(arg0_47.sceneData.productSystems) do
		if iter1_47.id == arg1_47.build_id then
			var0_47 = iter1_47

			break
		end
	end

	if not var0_47 then
		return
	end

	local var1_47 = var0_47:GetUnitIdBySlotId(arg1_47.area_id)

	arg0_47:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var1_47)
	arg0_47:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_47)
end

function var0_0.OnHandPlantSlotChangeUnit(arg0_48, arg1_48)
	local var0_48

	for iter0_48, iter1_48 in ipairs(arg0_48.sceneData.productSystems) do
		if iter1_48.id == arg1_48.build_id then
			var0_48 = iter1_48

			break
		end
	end

	if not var0_48 then
		return
	end

	local var1_48 = var0_48:GetUnitIdBySlotId(arg1_48.slotId)

	arg0_48:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_48)

	local var2_48 = var0_48:GenHandPlantUnitBySlotData(arg1_48.slotId)

	arg0_48:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_48)
end

function var0_0.OnProductPlaceChangeUnit(arg0_49, arg1_49)
	local var0_49 = arg1_49.build_id
	local var1_49

	for iter0_49, iter1_49 in ipairs(arg0_49.sceneData.productSystems) do
		if iter1_49.id == var0_49 then
			var1_49 = iter1_49

			break
		end
	end

	if not var1_49 then
		return
	end

	local var2_49 = var1_49:GetPlaceModelId(false)

	arg0_49:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var2_49)

	local var3_49 = var1_49:GetPlaceModelUnit(true)

	arg0_49:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_49)
end

function var0_0.OnRemoveWildGatherDone(arg0_50, arg1_50)
	arg0_50:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_50.unitId)
	arg0_50:NotifiyCore(ISLAND_EVT.LEAVE_UNIT, {
		id = arg1_50.unitId
	})
end

function var0_0.OnAddWildGatherDone(arg0_51, arg1_51)
	local var0_51 = IslandDataConvertor.GenWildGatherUnit(arg1_51)

	arg0_51:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_51)
end

function var0_0.OnCollectSlotUnitInit(arg0_52, arg1_52)
	local var0_52 = arg1_52.slotId
	local var1_52 = pg.island_production_slot[var0_52].place
	local var2_52

	for iter0_52, iter1_52 in ipairs(arg0_52.sceneData.productSystems) do
		if iter1_52.id == var1_52 then
			var2_52 = iter1_52

			break
		end
	end

	if not var2_52 then
		return
	end

	local var3_52 = var2_52:InitHandCollectSlotBySlotId(var0_52)

	if var3_52 then
		arg0_52:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_52)
	end
end

function var0_0.OnCollectSlotUnitUpdate(arg0_53, arg1_53)
	local var0_53 = arg1_53.slotId
	local var1_53 = pg.island_production_slot[var0_53].place
	local var2_53

	for iter0_53, iter1_53 in ipairs(arg0_53.sceneData.productSystems) do
		if iter1_53.id == var1_53 then
			var2_53 = iter1_53

			break
		end
	end

	if not var2_53 then
		return
	end

	local var3_53 = var2_53:GetUnitIdBySlotId(arg1_53.slotId)

	if var3_53 then
		arg0_53:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var3_53)
		arg0_53:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var3_53)
	end
end

function var0_0.OnCollectSloSlotUnitRemove(arg0_54, arg1_54)
	local var0_54 = arg1_54.slotId
	local var1_54 = pg.island_production_slot[var0_54].place
	local var2_54

	for iter0_54, iter1_54 in ipairs(arg0_54.sceneData.productSystems) do
		if iter1_54.id == var1_54 then
			var2_54 = iter1_54

			break
		end
	end

	if not var2_54 then
		return
	end

	local var3_54 = var2_54:GetHandCollectSlotBySlotId(var0_54)

	arg0_54:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_54)
end

function var0_0.OnSyncDataUpdate(arg0_55, arg1_55)
	arg0_55.islandSyncMgr:HandleSyncData(arg1_55)
end

function var0_0.OnSyncObjUpdate(arg0_56, arg1_56)
	arg0_56.islandSyncMgr:HandleSyncObj(arg1_56)
end

function var0_0.Update(arg0_57)
	arg0_57.playerInputManager:Update()
	arg0_57.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_58)
	if arg0_58.playerInputManager then
		arg0_58.playerInputManager:Dispose()

		arg0_58.playerInputManager = nil
	end

	if arg0_58.islandSyncMgr then
		arg0_58.islandSyncMgr:Dispose()

		arg0_58.islandSyncMgr = nil
	end

	if arg0_58.strollAllocator then
		arg0_58.strollAllocator:Dispose()

		arg0_58.strollAllocator = nil
	end

	if arg0_58.visibilityAllocator then
		arg0_58.visibilityAllocator:Dispose()

		arg0_58.visibilityAllocator = nil
	end

	if arg0_58.giftAllocator then
		arg0_58.giftAllocator:Dispose()

		arg0_58.giftAllocator = nil
	end

	if arg0_58.timeDelayCreate then
		arg0_58.timeDelayCreate:Dispose()

		arg0_58.timeDelayCreate = nil
	end

	if arg0_58.activityNpcAllocator then
		arg0_58.activityNpcAllocator:Dispose()

		arg0_58.activityNpcAllocator = nil
	end

	arg0_58.__debouncers = nil
end

function var0_0.OnAnimalInit(arg0_59, arg1_59)
	local var0_59

	for iter0_59, iter1_59 in ipairs(arg0_59.sceneData.productSystems) do
		if iter1_59.id == IslandProductConst.PasturePlaceId then
			var0_59 = iter1_59

			break
		end
	end

	if not var0_59 then
		return
	end

	local var1_59 = arg1_59.slotId

	for iter2_59, iter3_59 in ipairs(arg1_59.aniList) do
		local var2_59 = var0_59:GenAnimalByAnialConfig(iter3_59, var1_59)

		arg0_59:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_59)
	end
end

function var0_0.OnSlotDelegateInit(arg0_60, arg1_60)
	local var0_60 = arg1_60.slotId
	local var1_60 = pg.island_production_slot[var0_60].place
	local var2_60

	for iter0_60, iter1_60 in ipairs(arg0_60.sceneData.productSystems) do
		if iter1_60.id == var1_60 then
			var2_60 = iter1_60

			break
		end
	end

	if not var2_60 then
		return
	end

	local var3_60 = var2_60:GetCommissionSlotId(var0_60)
	local var4_60 = pg.island_production_commission[var3_60].unlockObjid

	if var4_60 ~= 0 then
		arg0_60:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_60)
	end
end

function var0_0.IsPlayerInTimeline(arg0_61)
	return arg0_61.islandSyncMgr.player:InTimeline()
end

function var0_0.InitSyncMgr(arg0_62)
	arg0_62.islandSyncMgr:Init(arg0_62.sceneData.unitList)
	arg0_62:NotifiyCore(ISLAND_EVT.INIT_INTERACTION_OP_VIEW)
end

function var0_0.SetVisitorSyncData(arg0_63, arg1_63, arg2_63)
	arg0_63:NotifiyCore(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg1_63, arg2_63)
end

function var0_0.WorldObjectInterAction(arg0_64, arg1_64, arg2_64, arg3_64)
	arg3_64 = arg3_64 or 1

	local var0_64 = _.detect(arg0_64.sceneData.unitList, function(arg0_65)
		return arg0_65.id == arg1_64
	end)

	if not var0_64 or not var0_64:Interactable() then
		return
	end

	local var1_64 = var0_64:GetEmptySlot()

	if not var1_64 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_interact_point"))

		return
	end

	local function var2_64()
		var1_64:Lock(arg2_64)
		arg0_64:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_64, var1_64, arg3_64)
	end

	arg0_64.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_64, var1_64.id, arg3_64, function(arg0_67)
		if arg0_67 then
			var2_64()
		end
	end)
end

function var0_0.WorldObjectInterActionSync(arg0_68, arg1_68, arg2_68, arg3_68, arg4_68)
	arg3_68 = arg3_68 or 1

	local var0_68 = _.detect(arg0_68.sceneData.unitList, function(arg0_69)
		return arg0_69.id == arg1_68
	end)

	if not var0_68 or not var0_68:Interactable() then
		return
	end

	local var1_68 = var0_68:GetSlotById(arg4_68)

	var1_68:Lock(arg2_68)
	arg0_68:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_68, var1_68, arg3_68)
end

function var0_0.WorldObjectInterActionEnd(arg0_70, arg1_70, arg2_70)
	local var0_70 = _.detect(arg0_70.sceneData.unitList, function(arg0_71)
		return arg0_71.id == arg1_70
	end)

	if not var0_70 or not var0_70:Interactable() then
		return
	end

	local var1_70 = var0_70:GetUsingSlot(arg2_70)

	local function var2_70()
		local var0_72 = Clone(var1_70)

		var1_70:Release()
		arg0_70:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_70, var0_72)
	end

	arg0_70.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_70, var1_70.id, function(arg0_73)
		if arg0_73 then
			var2_70()
		end
	end)
end

function var0_0.WorldObjectInterActionEndSync(arg0_74, arg1_74, arg2_74)
	local var0_74 = _.detect(arg0_74.sceneData.unitList, function(arg0_75)
		return arg0_75.id == arg1_74
	end)

	if not var0_74 or not var0_74:Interactable() then
		return
	end

	local var1_74 = var0_74:GetUsingSlot(arg2_74)
	local var2_74 = Clone(var1_74)

	var1_74:Release()
	arg0_74:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_74, var2_74)
end

function var0_0.WorldObjectInitStatus(arg0_76, arg1_76, arg2_76)
	local var0_76 = _.detect(arg0_76.sceneData.unitList, function(arg0_77)
		return arg0_77.id == arg1_76
	end)

	warning("init", arg1_76, arg2_76, var0_76)

	if not var0_76 or not var0_76:Interactable() then
		return
	end

	arg0_76:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_76, arg2_76)
end

function var0_0.OnOpenRestaurant(arg0_78, arg1_78)
	local var0_78 = arg1_78.restId
	local var1_78 = arg1_78.postList
	local var2_78

	for iter0_78, iter1_78 in ipairs(arg0_78.sceneData.systemList) do
		if isa(iter1_78, IslandManageSystemVO) and iter1_78.id == var0_78 then
			var2_78 = iter1_78

			break
		end
	end

	if not var2_78 then
		return
	end

	local var3_78 = var2_78:GetUnits(var1_78)

	for iter2_78, iter3_78 in ipairs(var3_78) do
		arg0_78:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_78)
	end

	arg0_78:NotifiyCore(ISLAND_EVT.START_MANAGE, var2_78)
end

function var0_0.OnCloseRestaurant(arg0_79, arg1_79)
	local var0_79 = arg1_79.restId
	local var1_79 = arg1_79.postList
	local var2_79

	for iter0_79, iter1_79 in ipairs(arg0_79.sceneData.systemList) do
		if isa(iter1_79, IslandManageSystemVO) and iter1_79.id == var0_79 then
			var2_79 = iter1_79

			break
		end
	end

	if not var2_79 then
		return
	end

	arg0_79:NotifiyCore(ISLAND_EVT.END_MANAGE, var2_79)

	local var3_79 = var2_79:GetUnits(var1_79)

	for iter2_79, iter3_79 in ipairs(var3_79) do
		arg0_79:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_MANAGE, iter3_79.id)
	end
end

return var0_0
