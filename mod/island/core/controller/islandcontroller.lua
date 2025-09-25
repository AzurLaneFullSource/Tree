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
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_8.OnPlayerAdd)
	arg0_8:RemoveIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_8.OnPlayerExit)
	arg0_8:RemoveIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_8.OnPlayerChangeDress)
	arg0_8:RemoveIslandListener(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, arg0_8.OnShipChangeDress)
	arg0_8:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_8.OnSyncDataUpdate)
	arg0_8:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_8.OnSyncObjUpdate)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, arg0_8.OnCollectSlotUnitInit)
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
end

function var0_0.OnSystemUnlock(arg0_9, arg1_9)
	arg0_9:NotifiyCore(ISLAND_EVT.SYSTEM_UNLOCK, arg1_9)
end

function var0_0.OnActivityNpcAdd(arg0_10, arg1_10)
	arg0_10.activityNpcAllocator:AddNpc(arg1_10)
	arg0_10.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcUpdate(arg0_11, arg1_11, arg2_11)
	arg0_11.activityNpcAllocator:DelNpc(arg1_11)
	arg0_11.activityNpcAllocator:AddNpc(arg2_11)
	arg0_11.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcDel(arg0_12, arg1_12)
	arg0_12.activityNpcAllocator:DelNpc(arg1_12)
	arg0_12.activityNpcAllocator:Flush()
end

function var0_0.OnActivityUpdate(arg0_13)
	arg0_13.activityNpcAllocator:Flush()
end

function var0_0.OnGenRecycleItem(arg0_14, arg1_14)
	local var0_14 = IslandDataConvertor.GenDelayRecycleIslandUnit(arg1_14)

	arg0_14:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_14)
end

function var0_0.OnAddFollower(arg0_15, arg1_15)
	local var0_15 = #arg0_15.sceneData.followUnits > 0
	local var1_15 = arg0_15:GetIsland():GetCharacterAgency():GetShipById(arg1_15)
	local var2_15 = var1_15:GetModelUnit()
	local var3_15 = arg0_15:GetView():GetPlayerPosition()
	local var4_15 = IslandFollowerUnitVO.New(var1_15.id, arg1_15, var2_15, var3_15, Vector3(0, 0, 0), not var0_15)

	table.insert(arg0_15.sceneData.followUnits, var4_15)
	arg0_15:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_15)

	for iter0_15, iter1_15 in ipairs(arg0_15.sceneData.strollUnits) do
		if var1_15:getConfig("unit_id") == iter1_15.config.unit_id then
			arg0_15:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_STROLL, iter1_15.id)
		end
	end

	arg0_15:NotifiyCore(ISLAND_EVT.ADD_FOLLOWER)
end

function var0_0.OnDelFollower(arg0_16, arg1_16)
	local var0_16 = 0

	for iter0_16, iter1_16 in ipairs(arg0_16.sceneData.followUnits) do
		if iter1_16.id == arg1_16 then
			var0_16 = iter0_16

			break
		end
	end

	if var0_16 <= 0 then
		return
	end

	local var1_16 = table.remove(arg0_16.sceneData.followUnits, var0_16)

	arg0_16:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_FOLLOW, var1_16.id)

	if var1_16:IsRandomizer() and #arg0_16.sceneData.followUnits > 0 then
		local var2_16 = arg0_16.sceneData.followUnits[1]

		var2_16:ActiveRandomizer()
		arg0_16:NotifiyCore(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, var2_16.id)
	end

	local var3_16 = arg0_16:GetIsland():GetCharacterAgency():GetShipById(arg1_16)

	for iter2_16, iter3_16 in ipairs(arg0_16.sceneData.strollUnits) do
		if var3_16:getConfig("unit_id") == iter3_16.config.unit_id then
			arg0_16:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_16)
		end
	end

	arg0_16:NotifiyCore(ISLAND_EVT.DEL_FOLLOWER)
end

function var0_0.OnResetNpcActionFeedback(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.sceneData.strollUnits) do
		if iter1_17:ExistActionFeedback() then
			iter1_17:ClearActionFeedback()
			arg0_17:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_17)
		end
	end

	IslandDataConvertor.DistributeAward4StrollUnits(arg0_17.sceneData.strollUnits, arg0_17:GetIsland())
	arg0_17:InitStrollUnitsAwards()
end

function var0_0.OnNpcActionFeedBackChange(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.sceneData.strollUnits) do
		if iter1_18.id == arg1_18 and iter1_18:ExistActionFeedback() then
			iter1_18:ClearActionFeedback()
			arg0_18:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_18)
		end
	end
end

function var0_0.OnLinkCore(arg0_19, arg1_19, ...)
	arg0_19:NotifiyCore(arg1_19, ...)
end

function var0_0.OnActiveOrDisableUnit(arg0_20, arg1_20, arg2_20, arg3_20)
	arg0_20:NotifiyCore(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg1_20, arg2_20, arg3_20)
end

function var0_0.OnStartPathFinder(arg0_21, arg1_21)
	arg0_21:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, arg1_21)
end

function var0_0.OnEndPathFinder(arg0_22)
	arg0_22.visibilityAllocator:Flush()
end

function var0_0.OnStartPerformance(arg0_23)
	arg0_23:NotifiyCore(ISLAND_EVT.START_STORY)
	arg0_23:NotifiyCore(ISLAND_EVT.START_PERFORMANCE)
end

function var0_0.OnEndPerformance(arg0_24)
	arg0_24:NotifiyCore(ISLAND_EVT.END_STORY)
	arg0_24:NotifiyCore(ISLAND_EVT.END_PERFORMANCE)
end

function var0_0.OnStartStory(arg0_25)
	arg0_25:NotifiyCore(ISLAND_EVT.START_STORY)
end

function var0_0.OnEndStory(arg0_26, arg1_26)
	arg0_26:NotifiyCore(ISLAND_EVT.END_STORY)

	if arg1_26 then
		arg0_26.visibilityAllocator:Flush()
	end
end

function var0_0.OnTaskAdd(arg0_27)
	arg0_27.visibilityAllocator:Flush()
	arg0_27:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_27:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnFinishTask(arg0_28)
	arg0_28.visibilityAllocator:Flush()
	arg0_28:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_28:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnUpdateTask(arg0_29)
	arg0_29.visibilityAllocator:Flush()
	arg0_29:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_29:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnPlayerAdd(arg0_30, arg1_30)
	local var0_30 = IslandDataConvertor.PlayerData2IslandUnit(arg1_30.player, arg0_30.mapId, arg0_30:GetIsland().id)

	arg0_30:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_30, function(arg0_31)
		arg0_30.islandSyncMgr:OnVisitorEnter(arg1_30.player.id, arg0_31)
	end)
end

function var0_0.OnPlayerExit(arg0_32, arg1_32)
	arg0_32:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_PLAYER, arg1_32.id)
	arg0_32.islandSyncMgr:OnVisitorExit(arg1_32.id)
end

function var0_0.OnPlayerChangeDress(arg0_33, arg1_33, arg2_33)
	arg0_33:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_33, arg2_33)
end

function var0_0.OnShipChangeDress(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	arg0_34:NotifiyCore(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg1_34, arg2_34, arg3_34, arg4_34)
end

function var0_0.OnStartPlant(arg0_35, arg1_35)
	local var0_35

	for iter0_35, iter1_35 in ipairs(arg0_35.sceneData.productSystems) do
		if iter1_35.id == arg1_35.build_id then
			var0_35 = iter1_35

			break
		end
	end

	if not var0_35 then
		return
	end

	local var1_35 = var0_35:GetUnitIdBySlotId(arg1_35.area_id)

	arg0_35:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_35)

	local var2_35 = var0_35:GenHandPlantUnitBySlotData(arg1_35.area_id, arg1_35.formula_id)

	arg0_35:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_35)
	arg0_35:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_35)
end

function var0_0.OnEndPlant(arg0_36, arg1_36)
	local var0_36

	for iter0_36, iter1_36 in ipairs(arg0_36.sceneData.productSystems) do
		if iter1_36.id == arg1_36.build_id then
			var0_36 = iter1_36

			break
		end
	end

	if not var0_36 then
		return
	end

	local var1_36 = var0_36:GetUnitIdBySlotId(arg1_36.area_id)

	arg0_36:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_36)

	local var2_36 = var0_36:GenHandPlantUnitBySlotData(arg1_36.area_id)

	arg0_36:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_36)
	arg0_36:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_36)
end

function var0_0.OnStartDelegation(arg0_37, arg1_37)
	local var0_37

	for iter0_37, iter1_37 in ipairs(arg0_37.sceneData.systemList) do
		if isa(iter1_37, IslandCharacterSystemVO) and iter1_37.id == arg1_37.build_id then
			var0_37 = iter1_37

			break
		end
	end

	if not var0_37 then
		return
	end

	local var1_37

	for iter2_37, iter3_37 in ipairs(arg0_37.sceneData.productSystems) do
		if iter3_37.id == arg1_37.build_id then
			var1_37 = iter3_37

			break
		end
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_37.build_id) then
		local var2_37 = pg.island_production_slot[arg1_37.area_id]

		for iter4_37, iter5_37 in ipairs(var2_37.exclusion_slot) do
			local var3_37 = var1_37:GetUnitIdBySlotId(iter5_37)
			local var4_37 = var1_37:GetUnitVOByUnitId(var3_37)

			if var4_37 then
				var4_37:ChangeSlotType(IslandProductConst.ProductSlotType.RoleDelegation)
			end
		end
	end

	local var5_37 = var0_37:GetUnit(arg1_37.ship_id, arg1_37.area_id, true)

	if var5_37 then
		arg0_37:NotifiyCore(ISLAND_EVT.GEN_UNIT, var5_37)
	end

	arg0_37:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_37, var1_37)
end

function var0_0.OnEndDelegation(arg0_38, arg1_38)
	local var0_38

	for iter0_38, iter1_38 in ipairs(arg0_38.sceneData.systemList) do
		if isa(iter1_38, IslandCharacterSystemVO) and iter1_38.id == arg1_38.build_id then
			var0_38 = iter1_38

			break
		end
	end

	if not var0_38 then
		return
	end

	arg0_38:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_38)

	local var1_38 = var0_38:GetUnitShipIdBySlotId(arg1_38.ship_id, arg1_38.area_id)

	if var1_38 then
		arg0_38:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATION, var1_38)
	end

	if arg1_38.remainReward then
		return
	end

	local var2_38

	for iter2_38, iter3_38 in ipairs(arg0_38.sceneData.productSystems) do
		if iter3_38.id == arg1_38.build_id then
			var2_38 = iter3_38

			break
		end
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_38.build_id) then
		local var3_38 = pg.island_production_slot[arg1_38.area_id]

		for iter4_38, iter5_38 in ipairs(var3_38.exclusion_slot) do
			local var4_38 = var2_38:GetUnitIdBySlotId(iter5_38)

			arg0_38:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_38)

			local var5_38 = var2_38:GenHandPlantUnitBySlotData(iter5_38)

			arg0_38:NotifiyCore(ISLAND_EVT.GEN_UNIT, var5_38)
		end
	end
end

function var0_0.OnGetAllDelegationAward(arg0_39, arg1_39)
	local var0_39

	for iter0_39, iter1_39 in ipairs(arg0_39.sceneData.systemList) do
		if isa(iter1_39, IslandCharacterSystemVO) and iter1_39.id == arg1_39.build_id then
			var0_39 = iter1_39

			break
		end
	end

	if not var0_39 then
		return
	end

	local var1_39

	for iter2_39, iter3_39 in ipairs(arg0_39.sceneData.productSystems) do
		if iter3_39.id == arg1_39.build_id then
			var1_39 = iter3_39

			break
		end
	end

	if arg1_39.build_id == IslandProductConst.FarmlandPlaceId then
		local var2_39 = pg.island_production_slot[arg1_39.area_id]

		for iter4_39, iter5_39 in ipairs(var2_39.exclusion_slot) do
			local var3_39 = var1_39:GetUnitIdBySlotId(iter5_39)

			arg0_39:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_39)

			local var4_39 = var1_39:GenHandPlantUnitBySlotData(iter5_39)

			arg0_39:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_39)
		end
	end
end

function var0_0.OnChangeSlotModel(arg0_40, arg1_40)
	local var0_40

	for iter0_40, iter1_40 in ipairs(arg0_40.sceneData.productSystems) do
		if iter1_40.id == IslandProductConst.FarmlandPlaceId then
			var0_40 = iter1_40

			break
		end
	end

	if not var0_40 then
		return
	end

	arg0_40:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_40.id)

	local var1_40 = var0_40:GetUnitVOByUnitId(arg1_40.id)

	var1_40.modelId = arg1_40.modelId

	arg0_40:NotifiyCore(ISLAND_EVT.GEN_UNIT, var1_40)
end

function var0_0.OnStartHandCollect(arg0_41, arg1_41)
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

	arg0_41:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var1_41)
	arg0_41:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_41)
end

function var0_0.OnHandPlantSlotChangeUnit(arg0_42, arg1_42)
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

	local var1_42 = var0_42:GetUnitIdBySlotId(arg1_42.slotId)

	arg0_42:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_42)

	local var2_42 = var0_42:GenHandPlantUnitBySlotData(arg1_42.slotId)

	arg0_42:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_42)
end

function var0_0.OnProductPlaceChangeUnit(arg0_43, arg1_43)
	local var0_43 = arg1_43.build_id
	local var1_43

	for iter0_43, iter1_43 in ipairs(arg0_43.sceneData.productSystems) do
		if iter1_43.id == var0_43 then
			var1_43 = iter1_43

			break
		end
	end

	if not var1_43 then
		return
	end

	local var2_43 = var1_43:GetPlaceModelId(var0_43)

	arg0_43:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var2_43)

	local var3_43 = var1_43:GetPlaceModelId(var0_43)

	arg0_43:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_43)
end

function var0_0.OnRemoveWildGatherDone(arg0_44, arg1_44)
	arg0_44:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_44.unitId)
	arg0_44:NotifiyCore(ISLAND_EVT.LEAVE_UNIT, {
		id = arg1_44.unitId
	})
end

function var0_0.OnAddWildGatherDone(arg0_45, arg1_45)
	local var0_45 = IslandDataConvertor.GenWildGatherUnit(arg1_45)

	arg0_45:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_45)
end

function var0_0.OnCollectSlotUnitInit(arg0_46, arg1_46)
	local var0_46 = arg1_46.slotId
	local var1_46 = pg.island_production_slot[var0_46].place
	local var2_46

	for iter0_46, iter1_46 in ipairs(arg0_46.sceneData.productSystems) do
		if iter1_46.id == var1_46 then
			var2_46 = iter1_46

			break
		end
	end

	if not var2_46 then
		return
	end

	local var3_46 = var2_46:InitHandCollectSlotBySlotId(var0_46)

	if var3_46 then
		if var3_46.delayTime then
			arg0_46.timeDelayCreate:DelayInitUnit(var3_46)
		else
			arg0_46:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_46)
		end
	end
end

function var0_0.OnCollectSloSlotUnitRemove(arg0_47, arg1_47)
	local var0_47 = arg1_47.slotId
	local var1_47 = pg.island_production_slot[var0_47].place
	local var2_47

	for iter0_47, iter1_47 in ipairs(arg0_47.sceneData.productSystems) do
		if iter1_47.id == var1_47 then
			var2_47 = iter1_47

			break
		end
	end

	if not var2_47 then
		return
	end

	local var3_47 = var2_47:GetHandCollectSlotBySlotId(var0_47)

	arg0_47:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_47)
end

function var0_0.OnSyncDataUpdate(arg0_48, arg1_48)
	arg0_48.islandSyncMgr:HandleSyncData(arg1_48)
end

function var0_0.OnSyncObjUpdate(arg0_49, arg1_49)
	arg0_49.islandSyncMgr:HandleSyncObj(arg1_49)
end

function var0_0.Update(arg0_50)
	arg0_50.playerInputManager:Update()
	arg0_50.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_51)
	if arg0_51.playerInputManager then
		arg0_51.playerInputManager:Dispose()

		arg0_51.playerInputManager = nil
	end

	if arg0_51.islandSyncMgr then
		arg0_51.islandSyncMgr:Dispose()

		arg0_51.islandSyncMgr = nil
	end

	if arg0_51.strollAllocator then
		arg0_51.strollAllocator:Dispose()

		arg0_51.strollAllocator = nil
	end

	if arg0_51.visibilityAllocator then
		arg0_51.visibilityAllocator:Dispose()

		arg0_51.visibilityAllocator = nil
	end

	if arg0_51.giftAllocator then
		arg0_51.giftAllocator:Dispose()

		arg0_51.giftAllocator = nil
	end

	if arg0_51.timeDelayCreate then
		arg0_51.timeDelayCreate:Dispose()

		arg0_51.timeDelayCreate = nil
	end

	if arg0_51.activityNpcAllocator then
		arg0_51.activityNpcAllocator:Dispose()

		arg0_51.activityNpcAllocator = nil
	end
end

function var0_0.OnAnimalInit(arg0_52, arg1_52)
	local var0_52

	for iter0_52, iter1_52 in ipairs(arg0_52.sceneData.productSystems) do
		if iter1_52.id == IslandProductConst.PasturePlaceId then
			var0_52 = iter1_52

			break
		end
	end

	if not var0_52 then
		return
	end

	local var1_52 = arg1_52.slotId

	for iter2_52, iter3_52 in ipairs(arg1_52.aniList) do
		local var2_52 = var0_52:GenAnimalByAnialConfig(iter3_52, var1_52)

		arg0_52:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_52)
	end
end

function var0_0.InitSyncMgr(arg0_53)
	arg0_53.islandSyncMgr:Init(arg0_53.sceneData.unitList)
end

function var0_0.SetVisitorSyncData(arg0_54, arg1_54, arg2_54)
	arg0_54:NotifiyCore(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg1_54, arg2_54)
end

function var0_0.WorldObjectInterAction(arg0_55, arg1_55, arg2_55, arg3_55)
	arg3_55 = arg3_55 or 1

	local var0_55 = _.detect(arg0_55.sceneData.unitList, function(arg0_56)
		return arg0_56.id == arg1_55
	end)

	if not var0_55 or not var0_55:Interactable() then
		return
	end

	local var1_55 = var0_55:GetEmptySlot()

	if not var1_55 then
		return
	end

	local function var2_55()
		var1_55:Lock(arg2_55)
		arg0_55:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_55, var1_55, arg3_55)
	end

	arg0_55.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_55, var1_55.id, arg3_55, function(arg0_58)
		if arg0_58 then
			var2_55()
		end
	end)
end

function var0_0.WorldObjectInterActionSync(arg0_59, arg1_59, arg2_59, arg3_59)
	arg3_59 = arg3_59 or 1

	local var0_59 = _.detect(arg0_59.sceneData.unitList, function(arg0_60)
		return arg0_60.id == arg1_59
	end)

	if not var0_59 or not var0_59:Interactable() then
		return
	end

	local var1_59 = var0_59:GetEmptySlot()

	if not var1_59 then
		return
	end

	var1_59:Lock(arg2_59)
	arg0_59:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_59, var1_59, arg3_59)
end

function var0_0.WorldObjectInterActionEnd(arg0_61, arg1_61, arg2_61)
	local var0_61 = _.detect(arg0_61.sceneData.unitList, function(arg0_62)
		return arg0_62.id == arg1_61
	end)

	if not var0_61 or not var0_61:Interactable() then
		return
	end

	local var1_61 = var0_61:GetUsingSlot(arg2_61)

	local function var2_61()
		local var0_63 = Clone(var1_61)

		var1_61:Release()
		arg0_61:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_61, var0_63)
	end

	arg0_61.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_61, var1_61.id, function(arg0_64)
		if arg0_64 then
			var2_61()
		end
	end)
end

function var0_0.WorldObjectInterActionEndSync(arg0_65, arg1_65, arg2_65)
	local var0_65 = _.detect(arg0_65.sceneData.unitList, function(arg0_66)
		return arg0_66.id == arg1_65
	end)

	if not var0_65 or not var0_65:Interactable() then
		return
	end

	local var1_65 = var0_65:GetUsingSlot(arg2_65)
	local var2_65 = Clone(var1_65)

	var1_65:Release()
	arg0_65:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_65, var2_65)
end

function var0_0.WorldObjectInitStatus(arg0_67, arg1_67, arg2_67)
	local var0_67 = _.detect(arg0_67.sceneData.unitList, function(arg0_68)
		return arg0_68.id == arg1_67
	end)

	warning("init", arg1_67, arg2_67, var0_67)

	if not var0_67 or not var0_67:Interactable() then
		return
	end

	arg0_67:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_67, arg2_67)
end

function var0_0.OnOpenRestaurant(arg0_69, arg1_69)
	local var0_69 = arg1_69.restId
	local var1_69 = arg1_69.postList
	local var2_69

	for iter0_69, iter1_69 in ipairs(arg0_69.sceneData.systemList) do
		if isa(iter1_69, IslandManageSystemVO) and iter1_69.id == var0_69 then
			var2_69 = iter1_69

			break
		end
	end

	if not var2_69 then
		return
	end

	local var3_69 = var2_69:GetUnits(var1_69)

	for iter2_69, iter3_69 in ipairs(var3_69) do
		arg0_69:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_69)
	end

	arg0_69:NotifiyCore(ISLAND_EVT.START_MANAGE, var2_69)
end

function var0_0.OnCloseRestaurant(arg0_70, arg1_70)
	local var0_70 = arg1_70.restId
	local var1_70 = arg1_70.postList
	local var2_70

	for iter0_70, iter1_70 in ipairs(arg0_70.sceneData.systemList) do
		if isa(iter1_70, IslandManageSystemVO) and iter1_70.id == var0_70 then
			var2_70 = iter1_70

			break
		end
	end

	if not var2_70 then
		return
	end

	arg0_70:NotifiyCore(ISLAND_EVT.END_MANAGE, var2_70)

	local var3_70 = var2_70:GetUnits(var1_70)

	for iter2_70, iter3_70 in ipairs(var3_70) do
		arg0_70:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_MANAGE, iter3_70.id)
	end
end

return var0_0
