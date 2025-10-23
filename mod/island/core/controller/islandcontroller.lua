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
end

function var0_0.OnResetSp(arg0_9)
	local var0_9 = arg0_9.mapId
	local var1_9 = pg.island_world_objects.get_id_list_by_mapId[var0_9] or {}

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var2_9 = pg.island_world_objects[iter1_9]

		if var2_9.unitId == 0 then
			spConfig = var2_9

			break
		end
	end

	if not spConfig then
		return
	end

	local var3_9 = BuildVector3(spConfig.param.position)
	local var4_9 = BuildVector3(spConfig.param.rotation)
	local var5_9 = getProxy(PlayerProxy):getRawData().id

	arg0_9:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, var5_9, IslandConst.UNIT_LIST_PLAYER, var3_9)
	arg0_9:NotifiyCore(ISLAND_EVT.RESET_UNIT_ROT, var5_9, IslandConst.UNIT_LIST_PLAYER, var4_9)
end

function var0_0.OnLockNpcRefresh(arg0_10, arg1_10, arg2_10)
	arg0_10.visibilityAllocator:LockNpc(arg1_10, arg2_10)
end

function var0_0.OnReleaseNpcRefresh(arg0_11, arg1_11, arg2_11)
	arg0_11.visibilityAllocator:ReleaseNpc(arg1_11, arg2_11)
end

function var0_0.OnSystemUnlock(arg0_12, arg1_12)
	arg0_12:NotifiyCore(ISLAND_EVT.SYSTEM_UNLOCK, arg1_12)
end

function var0_0.OnActivityNpcAdd(arg0_13, arg1_13)
	arg0_13.activityNpcAllocator:AddNpc(arg1_13)
	arg0_13.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcUpdate(arg0_14, arg1_14, arg2_14)
	arg0_14.activityNpcAllocator:DelNpc(arg1_14)
	arg0_14.activityNpcAllocator:AddNpc(arg2_14)
	arg0_14.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcDel(arg0_15, arg1_15)
	arg0_15.activityNpcAllocator:DelNpc(arg1_15)
	arg0_15.activityNpcAllocator:Flush()
end

function var0_0.OnActivityUpdate(arg0_16)
	arg0_16.activityNpcAllocator:Flush()
end

function var0_0.OnGenRecycleItem(arg0_17, arg1_17)
	local var0_17 = IslandDataConvertor.GenDelayRecycleIslandUnit(arg1_17)

	arg0_17:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_17)
end

function var0_0.OnAddFollower(arg0_18, arg1_18)
	local var0_18 = #arg0_18.sceneData.followUnits > 0
	local var1_18 = arg0_18:GetIsland():GetCharacterAgency():GetShipById(arg1_18)
	local var2_18 = var1_18:GetModelUnit()
	local var3_18 = arg0_18:GetView():GetPlayerPosition()
	local var4_18 = IslandFollowerUnitVO.New(var1_18.id, arg1_18, var2_18, var3_18, Vector3(0, 0, 0), not var0_18)

	table.insert(arg0_18.sceneData.followUnits, var4_18)
	arg0_18:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_18)

	for iter0_18, iter1_18 in ipairs(arg0_18.sceneData.strollUnits) do
		if var1_18:getConfig("unit_id") == iter1_18.config.unit_id then
			arg0_18:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_STROLL, iter1_18.id)
		end
	end

	arg0_18:NotifiyCore(ISLAND_EVT.ADD_FOLLOWER)
end

function var0_0.OnDelFollower(arg0_19, arg1_19)
	local var0_19 = 0

	for iter0_19, iter1_19 in ipairs(arg0_19.sceneData.followUnits) do
		if iter1_19.id == arg1_19 then
			var0_19 = iter0_19

			break
		end
	end

	if var0_19 <= 0 then
		return
	end

	local var1_19 = table.remove(arg0_19.sceneData.followUnits, var0_19)

	arg0_19:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_FOLLOW, var1_19.id)

	if var1_19:IsRandomizer() and #arg0_19.sceneData.followUnits > 0 then
		local var2_19 = arg0_19.sceneData.followUnits[1]

		var2_19:ActiveRandomizer()
		arg0_19:NotifiyCore(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, var2_19.id)
	end

	local var3_19 = arg0_19:GetIsland():GetCharacterAgency():GetShipById(arg1_19)

	for iter2_19, iter3_19 in ipairs(arg0_19.sceneData.strollUnits) do
		if var3_19:getConfig("unit_id") == iter3_19.config.unit_id then
			arg0_19:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_19)
		end
	end

	arg0_19:NotifiyCore(ISLAND_EVT.DEL_FOLLOWER)
end

function var0_0.OnResetNpcActionFeedback(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.sceneData.strollUnits) do
		if iter1_20:ExistActionFeedback() then
			iter1_20:ClearActionFeedback()
			arg0_20:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_20)
		end
	end

	IslandDataConvertor.DistributeAward4StrollUnits(arg0_20.sceneData.strollUnits, arg0_20:GetIsland())
	arg0_20:InitStrollUnitsAwards()
end

function var0_0.OnNpcActionFeedBackChange(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.sceneData.strollUnits) do
		if iter1_21.id == arg1_21 and iter1_21:ExistActionFeedback() then
			iter1_21:ClearActionFeedback()
			arg0_21:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_21)
		end
	end
end

function var0_0.OnLinkCore(arg0_22, arg1_22, ...)
	arg0_22:NotifiyCore(arg1_22, ...)
end

function var0_0.OnActiveOrDisableUnit(arg0_23, arg1_23, arg2_23, arg3_23)
	arg0_23:NotifiyCore(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg1_23, arg2_23, arg3_23)
end

function var0_0.OnStartPathFinder(arg0_24, arg1_24)
	arg0_24:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, arg1_24)
end

function var0_0.OnEndPathFinder(arg0_25)
	arg0_25.visibilityAllocator:Flush()
end

function var0_0.OnStartPerformance(arg0_26)
	arg0_26:NotifiyCore(ISLAND_EVT.START_STORY)
	arg0_26:NotifiyCore(ISLAND_EVT.START_PERFORMANCE)
end

function var0_0.OnEndPerformance(arg0_27, arg1_27)
	arg0_27:NotifiyCore(ISLAND_EVT.END_STORY)
	arg0_27:NotifiyCore(ISLAND_EVT.END_PERFORMANCE)

	if arg1_27 then
		arg0_27:OnUpdateTask()
	end
end

function var0_0.OnStartStory(arg0_28)
	arg0_28:NotifiyCore(ISLAND_EVT.START_STORY)
end

function var0_0.OnEndStory(arg0_29, arg1_29)
	arg0_29:NotifiyCore(ISLAND_EVT.END_STORY)

	if arg1_29 then
		arg0_29.visibilityAllocator:Flush()
	end
end

function var0_0.OnTaskAdd(arg0_30)
	arg0_30.visibilityAllocator:Flush()
	arg0_30:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_30:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnFinishTask(arg0_31)
	arg0_31.visibilityAllocator:Flush()
	arg0_31:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_31:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnUpdateTask(arg0_32)
	arg0_32:Debounce("RefreshTask", function()
		if not arg0_32.visibilityAllocator then
			return
		end

		arg0_32.visibilityAllocator:Flush()
		arg0_32:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
		arg0_32:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	end, 0.5, false)()
end

function var0_0.Debounce(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	if not arg0_34.__debouncers then
		arg0_34.__debouncers = {}
	end

	if not arg0_34.__debouncers[arg1_34] then
		arg0_34.__debouncers[arg1_34] = debounce(arg2_34, arg3_34, arg4_34)
	end

	return arg0_34.__debouncers[arg1_34]
end

function var0_0.OnPlayerAdd(arg0_35, arg1_35)
	local var0_35 = IslandDataConvertor.PlayerData2IslandUnit(arg1_35.player, arg0_35.mapId, arg0_35:GetIsland().id)

	arg0_35:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_35, function(arg0_36)
		arg0_35.islandSyncMgr:OnVisitorEnter(arg1_35.player.id, arg0_36)
	end)
end

function var0_0.OnPlayerExit(arg0_37, arg1_37)
	arg0_37:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_PLAYER, arg1_37.id)
	arg0_37.islandSyncMgr:OnVisitorExit(arg1_37.id)
end

function var0_0.OnPlayerChangeDress(arg0_38, arg1_38, arg2_38)
	arg0_38:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_38, arg2_38)
end

function var0_0.OnShipChangeDress(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	arg0_39:NotifiyCore(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg1_39, arg2_39, arg3_39, arg4_39)
end

function var0_0.OnStartPlant(arg0_40, arg1_40)
	local var0_40

	for iter0_40, iter1_40 in ipairs(arg0_40.sceneData.productSystems) do
		if iter1_40.id == arg1_40.build_id then
			var0_40 = iter1_40

			break
		end
	end

	if not var0_40 then
		return
	end

	local var1_40 = var0_40:GetUnitIdBySlotId(arg1_40.area_id)

	arg0_40:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_40)

	local var2_40 = var0_40:GenHandPlantUnitBySlotData(arg1_40.area_id, arg1_40.formula_id)

	arg0_40:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_40)
	arg0_40:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_40)
end

function var0_0.OnEndPlant(arg0_41, arg1_41)
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

	local var2_41 = var0_41:GenHandPlantUnitBySlotData(arg1_41.area_id)

	arg0_41:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_41)
	arg0_41:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_41)
end

function var0_0.OnStartDelegation(arg0_42, arg1_42)
	local var0_42

	for iter0_42, iter1_42 in ipairs(arg0_42.sceneData.systemList) do
		if isa(iter1_42, IslandCharacterSystemVO) and iter1_42.id == arg1_42.build_id then
			var0_42 = iter1_42

			break
		end
	end

	if not var0_42 then
		return
	end

	local var1_42

	for iter2_42, iter3_42 in ipairs(arg0_42.sceneData.productSystems) do
		if iter3_42.id == arg1_42.build_id then
			var1_42 = iter3_42

			break
		end
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_42.build_id) then
		local var2_42 = pg.island_production_slot[arg1_42.area_id]

		for iter4_42, iter5_42 in ipairs(var2_42.exclusion_slot) do
			local var3_42 = var1_42:GetUnitIdBySlotId(iter5_42)
			local var4_42 = var1_42:GetUnitVOByUnitId(var3_42)

			if var4_42 then
				var4_42:ChangeSlotType(IslandProductConst.ProductSlotType.RoleDelegation)
			end
		end
	end

	local var5_42 = var0_42:GetUnit(arg1_42.ship_id, arg1_42.area_id, true)

	if var5_42 then
		arg0_42:NotifiyCore(ISLAND_EVT.GEN_UNIT, var5_42)
	end

	arg0_42:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_42, var1_42)
end

function var0_0.OnEndDelegation(arg0_43, arg1_43)
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

	arg0_43:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_43)

	local var1_43 = var0_43:GetUnitShipIdBySlotId(arg1_43.ship_id, arg1_43.area_id)

	if var1_43 then
		arg0_43:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATION, var1_43)
	end

	if arg1_43.remainReward then
		return
	end

	local var2_43

	for iter2_43, iter3_43 in ipairs(arg0_43.sceneData.productSystems) do
		if iter3_43.id == arg1_43.build_id then
			var2_43 = iter3_43

			break
		end
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_43.build_id) then
		local var3_43 = pg.island_production_slot[arg1_43.area_id]

		for iter4_43, iter5_43 in ipairs(var3_43.exclusion_slot) do
			local var4_43 = var2_43:GetUnitIdBySlotId(iter5_43)

			arg0_43:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_43)

			local var5_43 = var2_43:GenHandPlantUnitBySlotData(iter5_43)

			arg0_43:NotifiyCore(ISLAND_EVT.GEN_UNIT, var5_43)
		end
	end
end

function var0_0.OnGetAllDelegationAward(arg0_44, arg1_44)
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

	local var1_44

	for iter2_44, iter3_44 in ipairs(arg0_44.sceneData.productSystems) do
		if iter3_44.id == arg1_44.build_id then
			var1_44 = iter3_44

			break
		end
	end

	if arg1_44.build_id == IslandProductConst.FarmlandPlaceId or arg1_44.build_id == IslandProductConst.OrchardPlaceId or arg1_44.build_id == IslandProductConst.GardenPlaceId then
		local var2_44 = pg.island_production_slot[arg1_44.area_id]

		for iter4_44, iter5_44 in ipairs(var2_44.exclusion_slot) do
			local var3_44 = var1_44:GetUnitIdBySlotId(iter5_44)

			arg0_44:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_44)

			local var4_44 = var1_44:GenHandPlantUnitBySlotData(iter5_44)

			arg0_44:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_44)
		end
	end
end

function var0_0.OnChangeSlotModel(arg0_45, arg1_45)
	local var0_45

	for iter0_45, iter1_45 in ipairs(arg0_45.sceneData.productSystems) do
		if iter1_45.id == IslandProductConst.FarmlandPlaceId then
			var0_45 = iter1_45

			break
		end
	end

	if not var0_45 then
		return
	end

	arg0_45:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_45.id)

	local var1_45 = var0_45:GetUnitVOByUnitId(arg1_45.id)

	var1_45.modelId = arg1_45.modelId

	arg0_45:NotifiyCore(ISLAND_EVT.GEN_UNIT, var1_45)
end

function var0_0.OnStartHandCollect(arg0_46, arg1_46)
	local var0_46

	for iter0_46, iter1_46 in ipairs(arg0_46.sceneData.productSystems) do
		if iter1_46.id == arg1_46.build_id then
			var0_46 = iter1_46

			break
		end
	end

	if not var0_46 then
		return
	end

	local var1_46 = var0_46:GetUnitIdBySlotId(arg1_46.area_id)

	arg0_46:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var1_46)
	arg0_46:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_46)
end

function var0_0.OnHandPlantSlotChangeUnit(arg0_47, arg1_47)
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

	local var1_47 = var0_47:GetUnitIdBySlotId(arg1_47.slotId)

	arg0_47:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_47)

	local var2_47 = var0_47:GenHandPlantUnitBySlotData(arg1_47.slotId)

	arg0_47:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_47)
end

function var0_0.OnProductPlaceChangeUnit(arg0_48, arg1_48)
	local var0_48 = arg1_48.build_id
	local var1_48

	for iter0_48, iter1_48 in ipairs(arg0_48.sceneData.productSystems) do
		if iter1_48.id == var0_48 then
			var1_48 = iter1_48

			break
		end
	end

	if not var1_48 then
		return
	end

	local var2_48 = var1_48:GetPlaceModelId(false)

	arg0_48:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var2_48)

	local var3_48 = var1_48:GetPlaceModelUnit(true)

	arg0_48:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_48)
end

function var0_0.OnRemoveWildGatherDone(arg0_49, arg1_49)
	arg0_49:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_49.unitId)
	arg0_49:NotifiyCore(ISLAND_EVT.LEAVE_UNIT, {
		id = arg1_49.unitId
	})
end

function var0_0.OnAddWildGatherDone(arg0_50, arg1_50)
	local var0_50 = IslandDataConvertor.GenWildGatherUnit(arg1_50)

	arg0_50:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_50)
end

function var0_0.OnCollectSlotUnitInit(arg0_51, arg1_51)
	local var0_51 = arg1_51.slotId
	local var1_51 = pg.island_production_slot[var0_51].place
	local var2_51

	for iter0_51, iter1_51 in ipairs(arg0_51.sceneData.productSystems) do
		if iter1_51.id == var1_51 then
			var2_51 = iter1_51

			break
		end
	end

	if not var2_51 then
		return
	end

	local var3_51 = var2_51:InitHandCollectSlotBySlotId(var0_51)

	if var3_51 then
		arg0_51:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_51)
	end
end

function var0_0.OnCollectSlotUnitUpdate(arg0_52, arg1_52)
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

	local var3_52 = var2_52:GetUnitIdBySlotId(arg1_52.slotId)

	if var3_52 then
		arg0_52:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var3_52)
		arg0_52:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var3_52)
	end
end

function var0_0.OnCollectSloSlotUnitRemove(arg0_53, arg1_53)
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

	local var3_53 = var2_53:GetHandCollectSlotBySlotId(var0_53)

	arg0_53:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_53)
end

function var0_0.OnSyncDataUpdate(arg0_54, arg1_54)
	arg0_54.islandSyncMgr:HandleSyncData(arg1_54)
end

function var0_0.OnSyncObjUpdate(arg0_55, arg1_55)
	arg0_55.islandSyncMgr:HandleSyncObj(arg1_55)
end

function var0_0.Update(arg0_56)
	arg0_56.playerInputManager:Update()
	arg0_56.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_57)
	if arg0_57.playerInputManager then
		arg0_57.playerInputManager:Dispose()

		arg0_57.playerInputManager = nil
	end

	if arg0_57.islandSyncMgr then
		arg0_57.islandSyncMgr:Dispose()

		arg0_57.islandSyncMgr = nil
	end

	if arg0_57.strollAllocator then
		arg0_57.strollAllocator:Dispose()

		arg0_57.strollAllocator = nil
	end

	if arg0_57.visibilityAllocator then
		arg0_57.visibilityAllocator:Dispose()

		arg0_57.visibilityAllocator = nil
	end

	if arg0_57.giftAllocator then
		arg0_57.giftAllocator:Dispose()

		arg0_57.giftAllocator = nil
	end

	if arg0_57.timeDelayCreate then
		arg0_57.timeDelayCreate:Dispose()

		arg0_57.timeDelayCreate = nil
	end

	if arg0_57.activityNpcAllocator then
		arg0_57.activityNpcAllocator:Dispose()

		arg0_57.activityNpcAllocator = nil
	end

	arg0_57.__debouncers = nil
end

function var0_0.OnAnimalInit(arg0_58, arg1_58)
	local var0_58

	for iter0_58, iter1_58 in ipairs(arg0_58.sceneData.productSystems) do
		if iter1_58.id == IslandProductConst.PasturePlaceId then
			var0_58 = iter1_58

			break
		end
	end

	if not var0_58 then
		return
	end

	local var1_58 = arg1_58.slotId

	for iter2_58, iter3_58 in ipairs(arg1_58.aniList) do
		local var2_58 = var0_58:GenAnimalByAnialConfig(iter3_58, var1_58)

		arg0_58:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_58)
	end
end

function var0_0.IsPlayerInTimeline(arg0_59)
	return arg0_59.islandSyncMgr.player:InTimeline()
end

function var0_0.InitSyncMgr(arg0_60)
	arg0_60.islandSyncMgr:Init(arg0_60.sceneData.unitList)
end

function var0_0.SetVisitorSyncData(arg0_61, arg1_61, arg2_61)
	arg0_61:NotifiyCore(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg1_61, arg2_61)
end

function var0_0.WorldObjectInterAction(arg0_62, arg1_62, arg2_62, arg3_62)
	arg3_62 = arg3_62 or 1

	local var0_62 = _.detect(arg0_62.sceneData.unitList, function(arg0_63)
		return arg0_63.id == arg1_62
	end)

	if not var0_62 or not var0_62:Interactable() then
		return
	end

	local var1_62 = var0_62:GetEmptySlot()

	if not var1_62 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_interact_point"))

		return
	end

	local function var2_62()
		var1_62:Lock(arg2_62)
		arg0_62:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_62, var1_62, arg3_62)
	end

	arg0_62.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_62, var1_62.id, arg3_62, function(arg0_65)
		if arg0_65 then
			var2_62()
		end
	end)
end

function var0_0.WorldObjectInterActionSync(arg0_66, arg1_66, arg2_66, arg3_66, arg4_66)
	arg3_66 = arg3_66 or 1

	local var0_66 = _.detect(arg0_66.sceneData.unitList, function(arg0_67)
		return arg0_67.id == arg1_66
	end)

	if not var0_66 or not var0_66:Interactable() then
		return
	end

	local var1_66 = var0_66:GetSlotById(arg4_66)

	var1_66:Lock(arg2_66)
	arg0_66:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_66, var1_66, arg3_66)
end

function var0_0.WorldObjectInterActionEnd(arg0_68, arg1_68, arg2_68)
	local var0_68 = _.detect(arg0_68.sceneData.unitList, function(arg0_69)
		return arg0_69.id == arg1_68
	end)

	if not var0_68 or not var0_68:Interactable() then
		return
	end

	local var1_68 = var0_68:GetUsingSlot(arg2_68)

	local function var2_68()
		local var0_70 = Clone(var1_68)

		var1_68:Release()
		arg0_68:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_68, var0_70)
	end

	arg0_68.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_68, var1_68.id, function(arg0_71)
		if arg0_71 then
			var2_68()
		end
	end)
end

function var0_0.WorldObjectInterActionEndSync(arg0_72, arg1_72, arg2_72)
	local var0_72 = _.detect(arg0_72.sceneData.unitList, function(arg0_73)
		return arg0_73.id == arg1_72
	end)

	if not var0_72 or not var0_72:Interactable() then
		return
	end

	local var1_72 = var0_72:GetUsingSlot(arg2_72)
	local var2_72 = Clone(var1_72)

	var1_72:Release()
	arg0_72:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_72, var2_72)
end

function var0_0.WorldObjectInitStatus(arg0_74, arg1_74, arg2_74)
	local var0_74 = _.detect(arg0_74.sceneData.unitList, function(arg0_75)
		return arg0_75.id == arg1_74
	end)

	warning("init", arg1_74, arg2_74, var0_74)

	if not var0_74 or not var0_74:Interactable() then
		return
	end

	arg0_74:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_74, arg2_74)
end

function var0_0.OnOpenRestaurant(arg0_76, arg1_76)
	local var0_76 = arg1_76.restId
	local var1_76 = arg1_76.postList
	local var2_76

	for iter0_76, iter1_76 in ipairs(arg0_76.sceneData.systemList) do
		if isa(iter1_76, IslandManageSystemVO) and iter1_76.id == var0_76 then
			var2_76 = iter1_76

			break
		end
	end

	if not var2_76 then
		return
	end

	local var3_76 = var2_76:GetUnits(var1_76)

	for iter2_76, iter3_76 in ipairs(var3_76) do
		arg0_76:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_76)
	end

	arg0_76:NotifiyCore(ISLAND_EVT.START_MANAGE, var2_76)
end

function var0_0.OnCloseRestaurant(arg0_77, arg1_77)
	local var0_77 = arg1_77.restId
	local var1_77 = arg1_77.postList
	local var2_77

	for iter0_77, iter1_77 in ipairs(arg0_77.sceneData.systemList) do
		if isa(iter1_77, IslandManageSystemVO) and iter1_77.id == var0_77 then
			var2_77 = iter1_77

			break
		end
	end

	if not var2_77 then
		return
	end

	arg0_77:NotifiyCore(ISLAND_EVT.END_MANAGE, var2_77)

	local var3_77 = var2_77:GetUnits(var1_77)

	for iter2_77, iter3_77 in ipairs(var3_77) do
		arg0_77:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_MANAGE, iter3_77.id)
	end
end

return var0_0
