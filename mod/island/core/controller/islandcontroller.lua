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
	arg0_4:InitStrollUnitsAwards()
	arg0_4:InitSyncMgr()
	arg0_4:InitVisitor()
end

function var0_0.InitVisitor(arg0_5)
	local var0_5 = arg0_5.island:GetVisitorAgency():GetMapVisitorList()

	for iter0_5, iter1_5 in pairs(var0_5) do
		if not iter1_5:IsSelf() then
			arg0_5:OnPlayerAdd({
				player = iter1_5
			})
		else
			arg0_5.islandSyncMgr:OnVisitorEnter(iter1_5.id, nil)
		end
	end
end

function var0_0.InitStrollUnitsAwards(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.sceneData.strollUnits) do
		if iter1_6:ExistActionFeedback() then
			arg0_6:NotifiyCore(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, iter1_6)
		end
	end
end

function var0_0.GetMapID(arg0_7)
	return arg0_7.mapId
end

function var0_0.AddListeners(arg0_8)
	arg0_8:AddIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_8.OnPlayerAdd)
	arg0_8:AddIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_8.OnPlayerExit)
	arg0_8:AddIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_8.OnPlayerChangeDress)
	arg0_8:AddIslandListener(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, arg0_8.OnShipChangeDress)
	arg0_8:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_8.OnSyncDataUpdate)
	arg0_8:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_8.OnSyncObjUpdate)
	arg0_8:AddIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, arg0_8.OnCollectSlotUnitInit)
	arg0_8:AddIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_UPDATE, arg0_8.OnCollectSlotUnitUpdate)
	arg0_8:AddIslandListener(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, arg0_8.OnCollectSloSlotUnitRemove)
	arg0_8:AddIslandListener(IslandStartDelegationCommand.START_DELEGATION, arg0_8.OnStartDelegation)
	arg0_8:AddIslandListener(IslandFinishDelegationCommand.END_DELEGATION, arg0_8.OnEndDelegation)
	arg0_8:AddIslandListener(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, arg0_8.OnGetAllDelegationAward)
	arg0_8:AddIslandListener(IslandTaskAgency.TASK_ADDED, arg0_8.OnTaskAdd)
	arg0_8:AddIslandListener(IslandTaskAgency.TASK_FINISH, arg0_8.OnFinishTask)
	arg0_8:AddIslandListener(IslandTaskAgency.TASK_UPDATED, arg0_8.OnUpdateTask)
	arg0_8:AddIslandListener(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, arg0_8.OnStartPlant)
	arg0_8:AddIslandListener(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, arg0_8.OnEndPlant)
	arg0_8:AddIslandListener(IslandSlotCollectCommand.START_HAND_COLLECT_DONE, arg0_8.OnStartHandCollect)
	arg0_8:AddIslandListener(IslandBuildingAgency.SLOT_HANDPLABT_SLOT_UNIT_CHANGE, arg0_8.OnHandPlantSlotChangeUnit)
	arg0_8:AddIslandListener(IslandBuildingAgency.CHANGE_PRODUCT_MODEL, arg0_8.OnProductPlaceChangeUnit)
	arg0_8:AddIslandListener(IslandGatherCollectAgency.RemoveGatherUnit, arg0_8.OnRemoveWildGatherDone)
	arg0_8:AddIslandListener(IslandGatherCollectAgency.AddGatherUnit, arg0_8.OnAddWildGatherDone)
	arg0_8:AddIslandListener(ISLAND_EVT.CHANGE_SLOT_MODEL, arg0_8.OnChangeSlotModel)
	arg0_8:AddIslandListener(IslandOpenRestaurantCommand.OPEN_RESTAURANT, arg0_8.OnOpenRestaurant)
	arg0_8:AddIslandListener(IslandCloseRestaurantCommand.CLOSE_RESTAURANT, arg0_8.OnCloseRestaurant)
	arg0_8:AddIslandListener(IslandProxy.STORY_START, arg0_8.OnStartStory)
	arg0_8:AddIslandListener(IslandProxy.STORY_END, arg0_8.OnEndStory)
	arg0_8:AddIslandListener(IslandProxy.PERFORMANCE_START, arg0_8.OnStartPerformance)
	arg0_8:AddIslandListener(IslandProxy.PERFORMANCE_END, arg0_8.OnEndPerformance)
	arg0_8:AddIslandListener(IslandProxy.START_PATHFINDER, arg0_8.OnStartPathFinder)
	arg0_8:AddIslandListener(IslandProxy.END_PATHFINDER, arg0_8.OnEndPathFinder)
	arg0_8:AddIslandListener(IslandProxy.ACTIVE_OR_DISABLE_UNIT, arg0_8.OnActiveOrDisableUnit)
	arg0_8:AddIslandListener(IslandProxy.LINK_CORE, arg0_8.OnLinkCore)
	arg0_8:AddIslandListener(IslandBuildingAgency.GEN_ANIMAL_INT, arg0_8.OnAnimalInit)
	arg0_8:AddIslandListener(IslandBuildingAgency.SLOT_DELEGATE_INIT, arg0_8.OnSlotDelegateInit)
	arg0_8:AddIslandListener(IslandNpcFeedbackAgency.NPC_ACTION_CHANGE, arg0_8.OnNpcActionFeedBackChange)
	arg0_8:AddIslandListener(IslandNpcFeedbackAgency.RESET_NPC_ACTIONS, arg0_8.OnResetNpcActionFeedback)
	arg0_8:AddIslandListener(IslandFollowerAgency.ADD_FOLLOWER, arg0_8.OnAddFollower)
	arg0_8:AddIslandListener(IslandFollowerAgency.DEL_FOLLOWER, arg0_8.OnDelFollower)
	arg0_8:AddIslandListener(ActivityProxy.ACTIVITY_UPDATED, arg0_8.OnActivityUpdate)
	arg0_8:AddIslandListener(IslandProxy.GEN_RECYCLEITEM, arg0_8.OnGenRecycleItem)
	arg0_8:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_ADD, arg0_8.OnActivityNpcAdd)
	arg0_8:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_UPDATE, arg0_8.OnActivityNpcUpdate)
	arg0_8:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_DEL, arg0_8.OnActivityNpcDel)
	arg0_8:AddIslandListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_8.OnSystemUnlock)
	arg0_8:AddIslandListener(IslandProxy.LOCK_NPC_REFRESH, arg0_8.OnLockNpcRefresh)
	arg0_8:AddIslandListener(IslandProxy.RELEASE_NPC_REFRESH, arg0_8.OnReleaseNpcRefresh)
	arg0_8:AddIslandListener(IslandProxy.RESET_SP, arg0_8.OnResetSp)
	arg0_8:AddIslandListener(IslandFishingAgency.BAIT_UPDATE, arg0_8.OnBaitUpdate)
end

function var0_0.RemoveListeners(arg0_9)
	arg0_9:RemoveIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_9.OnPlayerAdd)
	arg0_9:RemoveIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_9.OnPlayerExit)
	arg0_9:RemoveIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_9.OnPlayerChangeDress)
	arg0_9:RemoveIslandListener(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, arg0_9.OnShipChangeDress)
	arg0_9:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_9.OnSyncDataUpdate)
	arg0_9:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_9.OnSyncObjUpdate)
	arg0_9:RemoveIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, arg0_9.OnCollectSlotUnitInit)
	arg0_9:RemoveIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_UPDATE, arg0_9.OnCollectSlotUnitUpdate)
	arg0_9:RemoveIslandListener(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, arg0_9.OnCollectSloSlotUnitRemove)
	arg0_9:RemoveIslandListener(IslandStartDelegationCommand.START_DELEGATION, arg0_9.OnStartDelegation)
	arg0_9:RemoveIslandListener(IslandFinishDelegationCommand.END_DELEGATION, arg0_9.OnEndDelegation)
	arg0_9:RemoveIslandListener(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, arg0_9.OnGetAllDelegationAward)
	arg0_9:RemoveIslandListener(IslandTaskAgency.TASK_ADDED, arg0_9.OnTaskAdd)
	arg0_9:RemoveIslandListener(IslandTaskAgency.TASK_FINISH, arg0_9.OnFinishTask)
	arg0_9:RemoveIslandListener(IslandTaskAgency.TASK_UPDATED, arg0_9.OnUpdateTask)
	arg0_9:RemoveIslandListener(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, arg0_9.OnStartPlant)
	arg0_9:RemoveIslandListener(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, arg0_9.OnEndPlant)
	arg0_9:RemoveIslandListener(IslandSlotCollectCommand.START_HAND_COLLECT_DONE, arg0_9.OnStartHandCollect)
	arg0_9:RemoveIslandListener(IslandBuildingAgency.SLOT_HANDPLABT_SLOT_UNIT_CHANGE, arg0_9.OnHandPlantSlotChangeUnit)
	arg0_9:RemoveIslandListener(IslandBuildingAgency.CHANGE_PRODUCT_MODEL, arg0_9.OnProductPlaceChangeUnit)
	arg0_9:RemoveIslandListener(IslandGatherCollectAgency.RemoveGatherUnit, arg0_9.OnRemoveWildGatherDone)
	arg0_9:RemoveIslandListener(IslandGatherCollectAgency.AddGatherUnit, arg0_9.OnAddWildGatherDone)
	arg0_9:RemoveIslandListener(ISLAND_EVT.CHANGE_SLOT_MODEL, arg0_9.OnChangeSlotModel)
	arg0_9:RemoveIslandListener(IslandOpenRestaurantCommand.OPEN_RESTAURANT, arg0_9.OnOpenRestaurant)
	arg0_9:RemoveIslandListener(IslandProxy.STORY_START, arg0_9.OnStartStory)
	arg0_9:RemoveIslandListener(IslandProxy.STORY_END, arg0_9.OnEndStory)
	arg0_9:RemoveIslandListener(IslandProxy.PERFORMANCE_START, arg0_9.OnStartPerformance)
	arg0_9:RemoveIslandListener(IslandProxy.PERFORMANCE_END, arg0_9.OnEndPerformance)
	arg0_9:RemoveIslandListener(IslandProxy.START_PATHFINDER, arg0_9.OnStartPathFinder)
	arg0_9:RemoveIslandListener(IslandProxy.END_PATHFINDER, arg0_9.OnEndPathFinder)
	arg0_9:RemoveIslandListener(IslandProxy.ACTIVE_OR_DISABLE_UNIT, arg0_9.OnActiveOrDisableUnit)
	arg0_9:RemoveIslandListener(IslandProxy.LINK_CORE, arg0_9.OnLinkCore)
	arg0_9:RemoveIslandListener(IslandBuildingAgency.GEN_ANIMAL_INT, arg0_9.OnAnimalInit)
	arg0_9:RemoveIslandListener(IslandBuildingAgency.SLOT_DELEGATE_INIT, arg0_9.OnSlotDelegateInit)
	arg0_9:RemoveIslandListener(IslandNpcFeedbackAgency.NPC_ACTION_CHANGE, arg0_9.OnNpcActionFeedBackChange)
	arg0_9:RemoveIslandListener(IslandNpcFeedbackAgency.RESET_NPC_ACTIONS, arg0_9.OnResetNpcActionFeedback)
	arg0_9:RemoveIslandListener(IslandFollowerAgency.ADD_FOLLOWER, arg0_9.OnAddFollower)
	arg0_9:RemoveIslandListener(IslandFollowerAgency.DEL_FOLLOWER, arg0_9.OnDelFollower)
	arg0_9:RemoveIslandListener(ActivityProxy.ACTIVITY_UPDATED, arg0_9.OnActivityUpdate)
	arg0_9:RemoveIslandListener(IslandProxy.GEN_RECYCLEITEM, arg0_9.OnGenRecycleItem)
	arg0_9:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_ADD, arg0_9.OnActivityNpcAdd)
	arg0_9:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_UPDATE, arg0_9.OnActivityNpcUpdate)
	arg0_9:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_DEL, arg0_9.OnActivityNpcDel)
	arg0_9:RemoveIslandListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_9.OnSystemUnlock)
	arg0_9:RemoveIslandListener(IslandProxy.LOCK_NPC_REFRESH, arg0_9.OnLockNpcRefresh)
	arg0_9:RemoveIslandListener(IslandProxy.RELEASE_NPC_REFRESH, arg0_9.OnReleaseNpcRefresh)
	arg0_9:RemoveIslandListener(IslandProxy.RESET_SP, arg0_9.OnResetSp)
	arg0_9:RemoveIslandListener(IslandFishingAgency.BAIT_UPDATE, arg0_9.OnBaitUpdate)
end

function var0_0.OnBaitUpdate(arg0_10, arg1_10)
	arg0_10:NotifiyCore(ISLAND_EVT.BAIT_UPDATE, arg1_10)
end

function var0_0.OnResetSp(arg0_11)
	local var0_11 = arg0_11.mapId
	local var1_11 = pg.island_world_objects.get_id_list_by_mapId[var0_11] or {}

	for iter0_11, iter1_11 in ipairs(var1_11) do
		local var2_11 = pg.island_world_objects[iter1_11]

		if var2_11.unitId == 0 then
			spConfig = var2_11

			break
		end
	end

	if not spConfig then
		return
	end

	local var3_11 = BuildVector3(spConfig.param.position)
	local var4_11 = BuildVector3(spConfig.param.rotation)
	local var5_11 = getProxy(PlayerProxy):getRawData().id

	arg0_11:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, var5_11, IslandConst.UNIT_LIST_PLAYER, var3_11)
	arg0_11:NotifiyCore(ISLAND_EVT.RESET_UNIT_ROT, var5_11, IslandConst.UNIT_LIST_PLAYER, var4_11)
end

function var0_0.OnLockNpcRefresh(arg0_12, arg1_12, arg2_12)
	arg0_12.visibilityAllocator:LockNpc(arg1_12, arg2_12)
end

function var0_0.OnReleaseNpcRefresh(arg0_13, arg1_13, arg2_13)
	arg0_13.visibilityAllocator:ReleaseNpc(arg1_13, arg2_13)
end

function var0_0.OnSystemUnlock(arg0_14, arg1_14)
	arg0_14:NotifiyCore(ISLAND_EVT.SYSTEM_UNLOCK, arg1_14)
end

function var0_0.OnActivityNpcAdd(arg0_15, arg1_15)
	arg0_15.activityNpcAllocator:AddNpc(arg1_15)
	arg0_15.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcUpdate(arg0_16, arg1_16, arg2_16)
	arg0_16.activityNpcAllocator:DelNpc(arg1_16)
	arg0_16.activityNpcAllocator:AddNpc(arg2_16)
	arg0_16.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcDel(arg0_17, arg1_17)
	arg0_17.activityNpcAllocator:DelNpc(arg1_17)
	arg0_17.activityNpcAllocator:Flush()
end

function var0_0.OnActivityUpdate(arg0_18)
	arg0_18.activityNpcAllocator:Flush()
end

function var0_0.OnGenRecycleItem(arg0_19, arg1_19)
	local var0_19 = IslandDataConvertor.GenDelayRecycleIslandUnit(arg1_19)

	arg0_19:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_19)
end

function var0_0.OnAddFollower(arg0_20, arg1_20)
	local var0_20 = #arg0_20.sceneData.followUnits > 0
	local var1_20 = arg0_20:GetIsland():GetCharacterAgency():GetShipById(arg1_20)
	local var2_20 = var1_20:GetModelUnit()
	local var3_20 = arg0_20:GetView():GetPlayerPosition()
	local var4_20 = IslandFollowerUnitVO.New(var1_20.id, arg1_20, var2_20, var3_20, Vector3(0, 0, 0), not var0_20)

	table.insert(arg0_20.sceneData.followUnits, var4_20)
	arg0_20:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_20)

	for iter0_20, iter1_20 in ipairs(arg0_20.sceneData.strollUnits) do
		if var1_20:getConfig("unit_id") == iter1_20.config.unit_id then
			arg0_20:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_STROLL, iter1_20.id)
		end
	end

	arg0_20:NotifiyCore(ISLAND_EVT.ADD_FOLLOWER, var4_20.id)
end

function var0_0.OnDelFollower(arg0_21, arg1_21)
	local var0_21 = 0

	for iter0_21, iter1_21 in ipairs(arg0_21.sceneData.followUnits) do
		if iter1_21.id == arg1_21 then
			var0_21 = iter0_21

			break
		end
	end

	if var0_21 <= 0 then
		return
	end

	local var1_21 = table.remove(arg0_21.sceneData.followUnits, var0_21)

	arg0_21:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_FOLLOW, var1_21.id)

	if var1_21:IsRandomizer() and #arg0_21.sceneData.followUnits > 0 then
		local var2_21 = arg0_21.sceneData.followUnits[1]

		var2_21:ActiveRandomizer()
		arg0_21:NotifiyCore(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, var2_21.id)
	end

	local var3_21 = arg0_21:GetIsland():GetCharacterAgency():GetShipById(arg1_21)

	for iter2_21, iter3_21 in ipairs(arg0_21.sceneData.strollUnits) do
		if var3_21:getConfig("unit_id") == iter3_21.config.unit_id then
			arg0_21:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_21)
		end
	end

	arg0_21:NotifiyCore(ISLAND_EVT.DEL_FOLLOWER, var1_21.id)
end

function var0_0.OnResetNpcActionFeedback(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.sceneData.strollUnits) do
		if iter1_22:ExistActionFeedback() then
			iter1_22:ClearActionFeedback()
			arg0_22:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_22)
		end
	end

	IslandDataConvertor.DistributeAward4StrollUnits(arg0_22.sceneData.strollUnits, arg0_22:GetIsland())
	arg0_22:InitStrollUnitsAwards()
end

function var0_0.OnNpcActionFeedBackChange(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.sceneData.strollUnits) do
		if iter1_23.id == arg1_23 and iter1_23:ExistActionFeedback() then
			iter1_23:ClearActionFeedback()
			arg0_23:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_23)
		end
	end
end

function var0_0.OnLinkCore(arg0_24, arg1_24, ...)
	arg0_24:NotifiyCore(arg1_24, ...)
end

function var0_0.OnActiveOrDisableUnit(arg0_25, arg1_25, arg2_25, arg3_25)
	arg0_25:NotifiyCore(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg1_25, arg2_25, arg3_25)
end

function var0_0.OnStartPathFinder(arg0_26, arg1_26)
	arg0_26:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, arg1_26)
end

function var0_0.OnEndPathFinder(arg0_27)
	arg0_27.visibilityAllocator:Flush()
end

function var0_0.OnStartPerformance(arg0_28)
	arg0_28:NotifiyCore(ISLAND_EVT.START_STORY)
	arg0_28:NotifiyCore(ISLAND_EVT.START_PERFORMANCE)
end

function var0_0.OnEndPerformance(arg0_29, arg1_29)
	arg0_29:NotifiyCore(ISLAND_EVT.END_STORY)
	arg0_29:NotifiyCore(ISLAND_EVT.END_PERFORMANCE)

	if arg1_29 then
		arg0_29:OnUpdateTask()
	end
end

function var0_0.OnStartStory(arg0_30)
	arg0_30:NotifiyCore(ISLAND_EVT.START_STORY)
end

function var0_0.OnEndStory(arg0_31, arg1_31)
	arg0_31:NotifiyCore(ISLAND_EVT.END_STORY)

	if arg1_31 then
		arg0_31.visibilityAllocator:Flush()
	end
end

function var0_0.OnTaskAdd(arg0_32)
	arg0_32.visibilityAllocator:Flush()
	arg0_32:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_32:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnFinishTask(arg0_33)
	arg0_33.visibilityAllocator:Flush()
	arg0_33:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_33:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnUpdateTask(arg0_34)
	arg0_34:Debounce("RefreshTask", function()
		if not arg0_34.visibilityAllocator then
			return
		end

		arg0_34.visibilityAllocator:Flush()
		arg0_34:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
		arg0_34:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	end, 0.5, false)()
end

function var0_0.Debounce(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	if not arg0_36.__debouncers then
		arg0_36.__debouncers = {}
	end

	if not arg0_36.__debouncers[arg1_36] then
		arg0_36.__debouncers[arg1_36] = debounce(arg2_36, arg3_36, arg4_36)
	end

	return arg0_36.__debouncers[arg1_36]
end

function var0_0.OnPlayerAdd(arg0_37, arg1_37)
	local var0_37 = IslandDataConvertor.PlayerData2IslandUnit(arg1_37.player, arg0_37.mapId, arg0_37:GetIsland().id)

	arg0_37:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_37, function(arg0_38)
		arg0_37.islandSyncMgr:OnVisitorEnter(arg1_37.player.id, arg0_38)
	end)
end

function var0_0.OnPlayerExit(arg0_39, arg1_39)
	arg0_39:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_PLAYER, arg1_39.id)
	arg0_39.islandSyncMgr:OnVisitorExit(arg1_39.id)
end

function var0_0.OnPlayerChangeDress(arg0_40, arg1_40, arg2_40)
	arg0_40:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_40, arg2_40)
end

function var0_0.OnShipChangeDress(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	arg0_41:NotifiyCore(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg1_41, arg2_41, arg3_41, arg4_41)
end

function var0_0.OnStartPlant(arg0_42, arg1_42)
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

	local var2_42 = var0_42:GenHandPlantUnitBySlotData(arg1_42.area_id, arg1_42.formula_id)

	arg0_42:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_42)
	arg0_42:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_42)
end

function var0_0.OnEndPlant(arg0_43, arg1_43)
	local var0_43

	for iter0_43, iter1_43 in ipairs(arg0_43.sceneData.productSystems) do
		if iter1_43.id == arg1_43.build_id then
			var0_43 = iter1_43

			break
		end
	end

	if not var0_43 then
		return
	end

	local var1_43 = var0_43:GetUnitIdBySlotId(arg1_43.area_id)

	arg0_43:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_43)

	local var2_43 = var0_43:GenHandPlantUnitBySlotData(arg1_43.area_id)

	arg0_43:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_43)
	arg0_43:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_43)
end

function var0_0.OnStartDelegation(arg0_44, arg1_44)
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

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_44.build_id) then
		local var2_44 = pg.island_production_slot[arg1_44.area_id]

		for iter4_44, iter5_44 in ipairs(var2_44.exclusion_slot) do
			local var3_44 = var1_44:GetUnitIdBySlotId(iter5_44)
			local var4_44 = var1_44:GetUnitVOByUnitId(var3_44)

			if var4_44 then
				var4_44:ChangeSlotType(IslandProductConst.ProductSlotType.RoleDelegation)
			end
		end
	end

	local var5_44 = {}

	if table.contains(IslandProductConst.havePerformPlace, arg1_44.build_id) then
		local var6_44 = var1_44:GetDelegateUnitsByBuildIdAndSlotId(arg1_44.build_id, arg1_44.area_id, arg1_44.formula_id)

		var5_44.commissionSlotId = var1_44:GetCommissionSlotId(arg1_44.area_id)
		var5_44.unitIds = {}

		for iter6_44, iter7_44 in ipairs(var6_44) do
			table.insert(var5_44.unitIds, iter7_44.id)
		end

		for iter8_44, iter9_44 in ipairs(var6_44) do
			arg0_44:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter9_44)
		end
	end

	local var7_44 = var1_44:GetDelegateEffectsByCommissonId(arg1_44.area_id)

	if var7_44 then
		local var8_44 = var1_44:GenUnitByDelegateEffectId(var7_44)

		if var8_44 then
			arg0_44:NotifiyCore(ISLAND_EVT.GEN_UNIT, var8_44)
		end
	end

	local var9_44 = var0_44:GetUnit(arg1_44.ship_id, arg1_44.area_id, true)

	if var9_44 then
		arg0_44:NotifiyCore(ISLAND_EVT.GEN_UNIT, var9_44)
	end

	arg0_44:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_44, var5_44)
end

function var0_0.OnEndDelegation(arg0_45, arg1_45)
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

	arg0_45:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_45)

	local var1_45 = var0_45:GetUnitShipIdBySlotId(arg1_45.ship_id, arg1_45.area_id)

	if var1_45 then
		arg0_45:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATION, var1_45)
	end

	local var2_45

	for iter2_45, iter3_45 in ipairs(arg0_45.sceneData.productSystems) do
		if iter3_45.id == arg1_45.build_id then
			var2_45 = iter3_45

			break
		end
	end

	if table.contains(IslandProductConst.havePerformPlace, arg1_45.build_id) then
		local var3_45 = var2_45:GetDelegatUnitsBySlotId(arg1_45.area_id)

		for iter4_45, iter5_45 in ipairs(var3_45) do
			arg0_45:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATE_UNIT, iter5_45)
		end
	end

	local var4_45 = var2_45:GetDelegateEffectsByCommissonId(arg1_45.area_id)

	if var4_45 then
		arg0_45:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_45)
	end

	if arg1_45.remainReward then
		return
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_45.build_id) then
		local var5_45 = pg.island_production_slot[arg1_45.area_id]

		for iter6_45, iter7_45 in ipairs(var5_45.exclusion_slot) do
			local var6_45 = var2_45:GetUnitIdBySlotId(iter7_45)

			arg0_45:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var6_45)

			local var7_45 = var2_45:GenHandPlantUnitBySlotData(iter7_45)

			arg0_45:NotifiyCore(ISLAND_EVT.GEN_UNIT, var7_45)
		end
	end
end

function var0_0.OnGetAllDelegationAward(arg0_46, arg1_46)
	local var0_46

	for iter0_46, iter1_46 in ipairs(arg0_46.sceneData.systemList) do
		if isa(iter1_46, IslandCharacterSystemVO) and iter1_46.id == arg1_46.build_id then
			var0_46 = iter1_46

			break
		end
	end

	if not var0_46 then
		return
	end

	local var1_46

	for iter2_46, iter3_46 in ipairs(arg0_46.sceneData.productSystems) do
		if iter3_46.id == arg1_46.build_id then
			var1_46 = iter3_46

			break
		end
	end

	if arg1_46.build_id == IslandProductConst.FarmlandPlaceId or arg1_46.build_id == IslandProductConst.OrchardPlaceId or arg1_46.build_id == IslandProductConst.GardenPlaceId then
		local var2_46 = pg.island_production_slot[arg1_46.area_id]

		for iter4_46, iter5_46 in ipairs(var2_46.exclusion_slot) do
			local var3_46 = var1_46:GetUnitIdBySlotId(iter5_46)

			arg0_46:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_46)

			local var4_46 = var1_46:GenHandPlantUnitBySlotData(iter5_46)

			arg0_46:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_46)
		end
	end
end

function var0_0.OnChangeSlotModel(arg0_47, arg1_47)
	local var0_47

	for iter0_47, iter1_47 in ipairs(arg0_47.sceneData.productSystems) do
		if iter1_47.id == IslandProductConst.FarmlandPlaceId then
			var0_47 = iter1_47

			break
		end
	end

	if not var0_47 then
		return
	end

	arg0_47:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_47.id)

	local var1_47 = var0_47:GetUnitVOByUnitId(arg1_47.id)

	var1_47.modelId = arg1_47.modelId

	arg0_47:NotifiyCore(ISLAND_EVT.GEN_UNIT, var1_47)
end

function var0_0.OnStartHandCollect(arg0_48, arg1_48)
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

	local var1_48 = var0_48:GetUnitIdBySlotId(arg1_48.area_id)

	arg0_48:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var1_48)
	arg0_48:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_48)
end

function var0_0.OnHandPlantSlotChangeUnit(arg0_49, arg1_49)
	local var0_49

	for iter0_49, iter1_49 in ipairs(arg0_49.sceneData.productSystems) do
		if iter1_49.id == arg1_49.build_id then
			var0_49 = iter1_49

			break
		end
	end

	if not var0_49 then
		return
	end

	local var1_49 = var0_49:GetUnitIdBySlotId(arg1_49.slotId)

	arg0_49:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_49)

	local var2_49 = var0_49:GenHandPlantUnitBySlotData(arg1_49.slotId)

	arg0_49:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_49)
end

function var0_0.OnProductPlaceChangeUnit(arg0_50, arg1_50)
	local var0_50 = arg1_50.build_id
	local var1_50

	for iter0_50, iter1_50 in ipairs(arg0_50.sceneData.productSystems) do
		if iter1_50.id == var0_50 then
			var1_50 = iter1_50

			break
		end
	end

	if not var1_50 then
		return
	end

	local var2_50 = var1_50:GetPlaceModelId(false)

	arg0_50:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var2_50)

	local var3_50 = var1_50:GetPlaceModelUnit(true)

	arg0_50:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_50)
end

function var0_0.OnRemoveWildGatherDone(arg0_51, arg1_51)
	arg0_51:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_51.unitId)
	arg0_51:NotifiyCore(ISLAND_EVT.LEAVE_UNIT, {
		id = arg1_51.unitId
	})
end

function var0_0.OnAddWildGatherDone(arg0_52, arg1_52)
	local var0_52 = IslandDataConvertor.GenWildGatherUnit(arg1_52)

	arg0_52:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_52)
end

function var0_0.OnCollectSlotUnitInit(arg0_53, arg1_53)
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

	local var3_53 = var2_53:InitHandCollectSlotBySlotId(var0_53)

	if var3_53 then
		arg0_53:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_53)
	end
end

function var0_0.OnCollectSlotUnitUpdate(arg0_54, arg1_54)
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

	local var3_54 = var2_54:GetUnitIdBySlotId(arg1_54.slotId)

	if var3_54 then
		arg0_54:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var3_54)
		arg0_54:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var3_54)
	end
end

function var0_0.OnCollectSloSlotUnitRemove(arg0_55, arg1_55)
	local var0_55 = arg1_55.slotId
	local var1_55 = pg.island_production_slot[var0_55].place
	local var2_55

	for iter0_55, iter1_55 in ipairs(arg0_55.sceneData.productSystems) do
		if iter1_55.id == var1_55 then
			var2_55 = iter1_55

			break
		end
	end

	if not var2_55 then
		return
	end

	local var3_55 = var2_55:GetHandCollectSlotBySlotId(var0_55)

	arg0_55:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_55)
end

function var0_0.OnSyncDataUpdate(arg0_56, arg1_56)
	arg0_56.islandSyncMgr:HandleSyncData(arg1_56)
end

function var0_0.OnSyncObjUpdate(arg0_57, arg1_57)
	arg0_57.islandSyncMgr:HandleSyncObj(arg1_57)
end

function var0_0.Update(arg0_58)
	arg0_58.playerInputManager:Update()
	arg0_58.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_59)
	if arg0_59.playerInputManager then
		arg0_59.playerInputManager:Dispose()

		arg0_59.playerInputManager = nil
	end

	if arg0_59.islandSyncMgr then
		arg0_59.islandSyncMgr:Dispose()

		arg0_59.islandSyncMgr = nil
	end

	if arg0_59.strollAllocator then
		arg0_59.strollAllocator:Dispose()

		arg0_59.strollAllocator = nil
	end

	if arg0_59.visibilityAllocator then
		arg0_59.visibilityAllocator:Dispose()

		arg0_59.visibilityAllocator = nil
	end

	if arg0_59.giftAllocator then
		arg0_59.giftAllocator:Dispose()

		arg0_59.giftAllocator = nil
	end

	if arg0_59.timeDelayCreate then
		arg0_59.timeDelayCreate:Dispose()

		arg0_59.timeDelayCreate = nil
	end

	if arg0_59.activityNpcAllocator then
		arg0_59.activityNpcAllocator:Dispose()

		arg0_59.activityNpcAllocator = nil
	end

	arg0_59.__debouncers = nil
end

function var0_0.OnAnimalInit(arg0_60, arg1_60)
	local var0_60

	for iter0_60, iter1_60 in ipairs(arg0_60.sceneData.productSystems) do
		if iter1_60.id == IslandProductConst.PasturePlaceId then
			var0_60 = iter1_60

			break
		end
	end

	if not var0_60 then
		return
	end

	local var1_60 = arg1_60.slotId

	for iter2_60, iter3_60 in ipairs(arg1_60.aniList) do
		local var2_60 = var0_60:GenAnimalByAnialConfig(iter3_60, var1_60)

		arg0_60:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_60)
	end
end

function var0_0.OnSlotDelegateInit(arg0_61, arg1_61)
	local var0_61 = arg1_61.slotId
	local var1_61 = pg.island_production_slot[var0_61].place
	local var2_61

	for iter0_61, iter1_61 in ipairs(arg0_61.sceneData.productSystems) do
		if iter1_61.id == var1_61 then
			var2_61 = iter1_61

			break
		end
	end

	if not var2_61 then
		return
	end

	local var3_61 = var2_61:GetCommissionSlotId(var0_61)
	local var4_61 = pg.island_production_commission[var3_61].unlockObjid

	if var4_61 ~= 0 then
		arg0_61:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_61)
	end
end

function var0_0.IsPlayerInTimeline(arg0_62)
	return arg0_62.islandSyncMgr.player:InTimeline()
end

function var0_0.InitSyncMgr(arg0_63)
	arg0_63.islandSyncMgr:Init(arg0_63.sceneData.unitList)
	arg0_63:NotifiyCore(ISLAND_EVT.INIT_INTERACTION_OP_VIEW)
end

function var0_0.SetVisitorSyncData(arg0_64, arg1_64, arg2_64)
	arg0_64:NotifiyCore(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg1_64, arg2_64)
end

function var0_0.WorldObjectInterAction(arg0_65, arg1_65, arg2_65, arg3_65)
	arg3_65 = arg3_65 or 1

	local var0_65 = _.detect(arg0_65.sceneData.unitList, function(arg0_66)
		return arg0_66.id == arg1_65
	end)

	if not var0_65 or not var0_65:Interactable() then
		return
	end

	local var1_65 = var0_65:GetEmptySlot()

	if not var1_65 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_interact_point"))

		return
	end

	local function var2_65()
		var1_65:Lock(arg2_65)
		arg0_65:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_65, var1_65, arg3_65)
	end

	arg0_65.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_65, var1_65.id, arg3_65, function(arg0_68)
		if arg0_68 then
			var2_65()
		end
	end)
end

function var0_0.WorldObjectInterActionSync(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69)
	arg3_69 = arg3_69 or 1

	local var0_69 = _.detect(arg0_69.sceneData.unitList, function(arg0_70)
		return arg0_70.id == arg1_69
	end)

	if not var0_69 or not var0_69:Interactable() then
		return
	end

	local var1_69 = var0_69:GetSlotById(arg4_69)

	var1_69:Lock(arg2_69)
	arg0_69:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_69, var1_69, arg3_69)
end

function var0_0.WorldObjectInterActionEnd(arg0_71, arg1_71, arg2_71)
	local var0_71 = _.detect(arg0_71.sceneData.unitList, function(arg0_72)
		return arg0_72.id == arg1_71
	end)

	if not var0_71 or not var0_71:Interactable() then
		return
	end

	local var1_71 = var0_71:GetUsingSlot(arg2_71)

	local function var2_71()
		local var0_73 = Clone(var1_71)

		var1_71:Release()
		arg0_71:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_71, var0_73)
	end

	arg0_71.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_71, var1_71.id, function(arg0_74)
		if arg0_74 then
			var2_71()
		end
	end)
end

function var0_0.WorldObjectInterActionEndSync(arg0_75, arg1_75, arg2_75)
	local var0_75 = _.detect(arg0_75.sceneData.unitList, function(arg0_76)
		return arg0_76.id == arg1_75
	end)

	if not var0_75 or not var0_75:Interactable() then
		return
	end

	local var1_75 = var0_75:GetUsingSlot(arg2_75)
	local var2_75 = Clone(var1_75)

	var1_75:Release()
	arg0_75:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_75, var2_75)
end

function var0_0.WorldObjectInitStatus(arg0_77, arg1_77, arg2_77)
	local var0_77 = _.detect(arg0_77.sceneData.unitList, function(arg0_78)
		return arg0_78.id == arg1_77
	end)

	warning("init", arg1_77, arg2_77, var0_77)

	if not var0_77 or not var0_77:Interactable() then
		return
	end

	arg0_77:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_77, arg2_77)
end

function var0_0.OnOpenRestaurant(arg0_79, arg1_79)
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

	local var3_79 = var2_79:GetUnits(var1_79)

	for iter2_79, iter3_79 in ipairs(var3_79) do
		arg0_79:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_79)
	end

	arg0_79:NotifiyCore(ISLAND_EVT.START_MANAGE, var2_79)
end

function var0_0.OnCloseRestaurant(arg0_80, arg1_80)
	local var0_80 = arg1_80.restId
	local var1_80 = arg1_80.postList
	local var2_80

	for iter0_80, iter1_80 in ipairs(arg0_80.sceneData.systemList) do
		if isa(iter1_80, IslandManageSystemVO) and iter1_80.id == var0_80 then
			var2_80 = iter1_80

			break
		end
	end

	if not var2_80 then
		return
	end

	arg0_80:NotifiyCore(ISLAND_EVT.END_MANAGE, var2_80)

	local var3_80 = var2_80:GetUnits(var1_80)

	for iter2_80, iter3_80 in ipairs(var3_80) do
		arg0_80:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_MANAGE, iter3_80.id)
	end
end

return var0_0
