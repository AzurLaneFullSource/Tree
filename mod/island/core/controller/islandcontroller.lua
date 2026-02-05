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

function var0_0.OnFinishTask(arg0_33, arg1_33)
	arg0_33.visibilityAllocator:Flush()
	arg0_33:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_33:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	arg0_33:CheckFinishTask(arg1_33, IslandTaskType.DAILY, "daily_task_follow_action")
	arg0_33:CheckFinishTask(arg1_33, IslandTaskType.WEEKLY, "weekly_task_follow_action")
end

local function var1_0(arg0_34)
	if #arg0_34 == 0 then
		return nil
	end

	return arg0_34[math.random(1, #arg0_34)]
end

function var0_0.CheckFinishTask(arg0_35, arg1_35, arg2_35, arg3_35)
	if IslandTask.New({
		id = arg1_35,
		process_list = {}
	}):GetType() ~= arg2_35 then
		return
	end

	local var0_35 = pg.island_set[arg3_35]

	if not var0_35 then
		return
	end

	local var1_35 = var0_35 and (var0_35.key_value_varchar or {}) or {}
	local var2_35 = arg0_35:GetSelfIsland():GetTaskAgency()
	local var3_35 = var2_35:GetTasks()

	for iter0_35, iter1_35 in ipairs(var3_35) do
		if iter1_35:GetType() == arg2_35 then
			return
		end
	end

	local var4_35 = false
	local var5_35 = var2_35:GetFinishedIds()

	for iter2_35, iter3_35 in ipairs(var5_35) do
		if IslandTask.New({
			id = iter3_35,
			process_list = {}
		}):GetType() == arg2_35 then
			var4_35 = true

			break
		end
	end

	if var4_35 then
		arg0_35:NotifiyCore(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, var1_0(var1_35))
	end
end

function var0_0.OnUpdateTask(arg0_36)
	arg0_36:Debounce("RefreshTask", function()
		if not arg0_36.visibilityAllocator then
			return
		end

		arg0_36.visibilityAllocator:Flush()
		arg0_36:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
		arg0_36:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	end, 0.5, false)()
end

function var0_0.Debounce(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	if not arg0_38.__debouncers then
		arg0_38.__debouncers = {}
	end

	if not arg0_38.__debouncers[arg1_38] then
		arg0_38.__debouncers[arg1_38] = debounce(arg2_38, arg3_38, arg4_38)
	end

	return arg0_38.__debouncers[arg1_38]
end

function var0_0.OnPlayerAdd(arg0_39, arg1_39)
	local var0_39 = IslandDataConvertor.PlayerData2IslandUnit(arg1_39.player, arg0_39.mapId, arg0_39:GetIsland().id)

	arg0_39:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_39, function(arg0_40)
		arg0_39.islandSyncMgr:OnVisitorEnter(arg1_39.player.id, arg0_40)
	end)
end

function var0_0.OnPlayerExit(arg0_41, arg1_41)
	arg0_41:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_PLAYER, arg1_41.id)
	arg0_41.islandSyncMgr:OnVisitorExit(arg1_41.id)
end

function var0_0.OnPlayerChangeDress(arg0_42, arg1_42, arg2_42)
	arg0_42:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_42, arg2_42)
end

function var0_0.OnShipChangeDress(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43)
	arg0_43:NotifiyCore(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg1_43, arg2_43, arg3_43, arg4_43)
end

function var0_0.OnStartPlant(arg0_44, arg1_44)
	local var0_44

	for iter0_44, iter1_44 in ipairs(arg0_44.sceneData.productSystems) do
		if iter1_44.id == arg1_44.build_id then
			var0_44 = iter1_44

			break
		end
	end

	if not var0_44 then
		return
	end

	local var1_44 = var0_44:GetUnitIdBySlotId(arg1_44.area_id)

	arg0_44:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_44)

	local var2_44 = var0_44:GenHandPlantUnitBySlotData(arg1_44.area_id, arg1_44.formula_id)

	arg0_44:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_44)
	arg0_44:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_44)
end

function var0_0.OnEndPlant(arg0_45, arg1_45)
	local var0_45

	for iter0_45, iter1_45 in ipairs(arg0_45.sceneData.productSystems) do
		if iter1_45.id == arg1_45.build_id then
			var0_45 = iter1_45

			break
		end
	end

	if not var0_45 then
		return
	end

	local var1_45 = var0_45:GetUnitIdBySlotId(arg1_45.area_id)

	arg0_45:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_45)

	local var2_45 = var0_45:GenHandPlantUnitBySlotData(arg1_45.area_id)

	arg0_45:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_45)
	arg0_45:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_45)
end

function var0_0.OnStartDelegation(arg0_46, arg1_46)
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

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_46.build_id) then
		local var2_46 = pg.island_production_slot[arg1_46.area_id]

		for iter4_46, iter5_46 in ipairs(var2_46.exclusion_slot) do
			local var3_46 = var1_46:GetUnitIdBySlotId(iter5_46)
			local var4_46 = var1_46:GetUnitVOByUnitId(var3_46)

			if var4_46 then
				var4_46:ChangeSlotType(IslandProductConst.ProductSlotType.RoleDelegation)
			end
		end
	end

	local var5_46 = {}

	if table.contains(IslandProductConst.havePerformPlace, arg1_46.build_id) then
		local var6_46 = var1_46:GetDelegateUnitsByBuildIdAndSlotId(arg1_46.build_id, arg1_46.area_id, arg1_46.formula_id)

		var5_46.commissionSlotId = var1_46:GetCommissionSlotId(arg1_46.area_id)
		var5_46.unitIds = {}

		for iter6_46, iter7_46 in ipairs(var6_46) do
			table.insert(var5_46.unitIds, iter7_46.id)
		end

		for iter8_46, iter9_46 in ipairs(var6_46) do
			arg0_46:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter9_46)
		end
	end

	local var7_46 = var1_46:GetDelegateEffectsByCommissonId(arg1_46.area_id)

	if var7_46 then
		local var8_46 = var1_46:GenUnitByDelegateEffectId(var7_46)

		if var8_46 then
			arg0_46:NotifiyCore(ISLAND_EVT.GEN_UNIT, var8_46)
		end
	end

	local var9_46 = var0_46:GetUnit(arg1_46.ship_id, arg1_46.area_id, true)

	if var9_46 then
		arg0_46:NotifiyCore(ISLAND_EVT.GEN_UNIT, var9_46)
	end

	arg0_46:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_46, var5_46)
end

function var0_0.OnEndDelegation(arg0_47, arg1_47)
	local var0_47

	for iter0_47, iter1_47 in ipairs(arg0_47.sceneData.systemList) do
		if isa(iter1_47, IslandCharacterSystemVO) and iter1_47.id == arg1_47.build_id then
			var0_47 = iter1_47

			break
		end
	end

	if not var0_47 then
		return
	end

	arg0_47:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_47)

	local var1_47 = var0_47:GetUnitShipIdBySlotId(arg1_47.ship_id, arg1_47.area_id)

	if var1_47 then
		arg0_47:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATION, var1_47)
	end

	local var2_47

	for iter2_47, iter3_47 in ipairs(arg0_47.sceneData.productSystems) do
		if iter3_47.id == arg1_47.build_id then
			var2_47 = iter3_47

			break
		end
	end

	if table.contains(IslandProductConst.havePerformPlace, arg1_47.build_id) then
		local var3_47 = var2_47:GetDelegatUnitsBySlotId(arg1_47.area_id)

		for iter4_47, iter5_47 in ipairs(var3_47) do
			arg0_47:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATE_UNIT, iter5_47)
		end
	end

	local var4_47 = var2_47:GetDelegateEffectsByCommissonId(arg1_47.area_id)

	if var4_47 then
		arg0_47:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_47)
	end

	if arg1_47.remainReward then
		return
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_47.build_id) then
		local var5_47 = pg.island_production_slot[arg1_47.area_id]

		for iter6_47, iter7_47 in ipairs(var5_47.exclusion_slot) do
			local var6_47 = var2_47:GetUnitIdBySlotId(iter7_47)

			arg0_47:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var6_47)

			local var7_47 = var2_47:GenHandPlantUnitBySlotData(iter7_47)

			arg0_47:NotifiyCore(ISLAND_EVT.GEN_UNIT, var7_47)
		end
	end
end

function var0_0.OnGetAllDelegationAward(arg0_48, arg1_48)
	local var0_48

	for iter0_48, iter1_48 in ipairs(arg0_48.sceneData.systemList) do
		if isa(iter1_48, IslandCharacterSystemVO) and iter1_48.id == arg1_48.build_id then
			var0_48 = iter1_48

			break
		end
	end

	if not var0_48 then
		return
	end

	local var1_48

	for iter2_48, iter3_48 in ipairs(arg0_48.sceneData.productSystems) do
		if iter3_48.id == arg1_48.build_id then
			var1_48 = iter3_48

			break
		end
	end

	if arg1_48.build_id == IslandProductConst.FarmlandPlaceId or arg1_48.build_id == IslandProductConst.OrchardPlaceId or arg1_48.build_id == IslandProductConst.GardenPlaceId then
		local var2_48 = pg.island_production_slot[arg1_48.area_id]

		for iter4_48, iter5_48 in ipairs(var2_48.exclusion_slot) do
			local var3_48 = var1_48:GetUnitIdBySlotId(iter5_48)

			arg0_48:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_48)

			local var4_48 = var1_48:GenHandPlantUnitBySlotData(iter5_48)

			arg0_48:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_48)
		end
	end
end

function var0_0.OnChangeSlotModel(arg0_49, arg1_49)
	local var0_49

	for iter0_49, iter1_49 in ipairs(arg0_49.sceneData.productSystems) do
		if iter1_49.id == IslandProductConst.FarmlandPlaceId then
			var0_49 = iter1_49

			break
		end
	end

	if not var0_49 then
		return
	end

	arg0_49:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_49.id)

	local var1_49 = var0_49:GetUnitVOByUnitId(arg1_49.id)

	var1_49.modelId = arg1_49.modelId

	arg0_49:NotifiyCore(ISLAND_EVT.GEN_UNIT, var1_49)
end

function var0_0.OnStartHandCollect(arg0_50, arg1_50)
	local var0_50

	for iter0_50, iter1_50 in ipairs(arg0_50.sceneData.productSystems) do
		if iter1_50.id == arg1_50.build_id then
			var0_50 = iter1_50

			break
		end
	end

	if not var0_50 then
		return
	end

	local var1_50 = var0_50:GetUnitIdBySlotId(arg1_50.area_id)

	arg0_50:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var1_50)
	arg0_50:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_50)
end

function var0_0.OnHandPlantSlotChangeUnit(arg0_51, arg1_51)
	local var0_51

	for iter0_51, iter1_51 in ipairs(arg0_51.sceneData.productSystems) do
		if iter1_51.id == arg1_51.build_id then
			var0_51 = iter1_51

			break
		end
	end

	if not var0_51 then
		return
	end

	local var1_51 = var0_51:GetUnitIdBySlotId(arg1_51.slotId)

	arg0_51:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_51)

	local var2_51 = var0_51:GenHandPlantUnitBySlotData(arg1_51.slotId)

	arg0_51:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_51)
end

function var0_0.OnProductPlaceChangeUnit(arg0_52, arg1_52)
	local var0_52 = arg1_52.build_id
	local var1_52

	for iter0_52, iter1_52 in ipairs(arg0_52.sceneData.productSystems) do
		if iter1_52.id == var0_52 then
			var1_52 = iter1_52

			break
		end
	end

	if not var1_52 then
		return
	end

	local var2_52 = var1_52:GetPlaceModelId(false)

	arg0_52:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var2_52)

	local var3_52 = var1_52:GetPlaceModelUnit(true)

	arg0_52:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_52)
end

function var0_0.OnRemoveWildGatherDone(arg0_53, arg1_53)
	arg0_53:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_53.unitId)
	arg0_53:NotifiyCore(ISLAND_EVT.LEAVE_UNIT, {
		id = arg1_53.unitId
	})
end

function var0_0.OnAddWildGatherDone(arg0_54, arg1_54)
	local var0_54 = IslandDataConvertor.GenWildGatherUnit(arg1_54)

	arg0_54:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_54)
end

function var0_0.OnCollectSlotUnitInit(arg0_55, arg1_55)
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

	local var3_55 = var2_55:InitHandCollectSlotBySlotId(var0_55)

	if var3_55 then
		arg0_55:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_55)
	end
end

function var0_0.OnCollectSlotUnitUpdate(arg0_56, arg1_56)
	local var0_56 = arg1_56.slotId
	local var1_56 = pg.island_production_slot[var0_56].place
	local var2_56

	for iter0_56, iter1_56 in ipairs(arg0_56.sceneData.productSystems) do
		if iter1_56.id == var1_56 then
			var2_56 = iter1_56

			break
		end
	end

	if not var2_56 then
		return
	end

	local var3_56 = var2_56:GetUnitIdBySlotId(arg1_56.slotId)

	if var3_56 then
		arg0_56:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var3_56)
		arg0_56:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var3_56)
	end
end

function var0_0.OnCollectSloSlotUnitRemove(arg0_57, arg1_57)
	local var0_57 = arg1_57.slotId
	local var1_57 = pg.island_production_slot[var0_57].place
	local var2_57

	for iter0_57, iter1_57 in ipairs(arg0_57.sceneData.productSystems) do
		if iter1_57.id == var1_57 then
			var2_57 = iter1_57

			break
		end
	end

	if not var2_57 then
		return
	end

	local var3_57 = var2_57:GetHandCollectSlotBySlotId(var0_57)

	arg0_57:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_57)
end

function var0_0.OnSyncDataUpdate(arg0_58, arg1_58)
	arg0_58.islandSyncMgr:HandleSyncData(arg1_58)
end

function var0_0.OnSyncObjUpdate(arg0_59, arg1_59)
	arg0_59.islandSyncMgr:HandleSyncObj(arg1_59)
end

function var0_0.Update(arg0_60)
	arg0_60.playerInputManager:Update()
	arg0_60.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_61)
	if arg0_61.playerInputManager then
		arg0_61.playerInputManager:Dispose()

		arg0_61.playerInputManager = nil
	end

	if arg0_61.islandSyncMgr then
		arg0_61.islandSyncMgr:Dispose()

		arg0_61.islandSyncMgr = nil
	end

	if arg0_61.strollAllocator then
		arg0_61.strollAllocator:Dispose()

		arg0_61.strollAllocator = nil
	end

	if arg0_61.visibilityAllocator then
		arg0_61.visibilityAllocator:Dispose()

		arg0_61.visibilityAllocator = nil
	end

	if arg0_61.giftAllocator then
		arg0_61.giftAllocator:Dispose()

		arg0_61.giftAllocator = nil
	end

	if arg0_61.timeDelayCreate then
		arg0_61.timeDelayCreate:Dispose()

		arg0_61.timeDelayCreate = nil
	end

	if arg0_61.activityNpcAllocator then
		arg0_61.activityNpcAllocator:Dispose()

		arg0_61.activityNpcAllocator = nil
	end

	arg0_61.__debouncers = nil
end

function var0_0.OnAnimalInit(arg0_62, arg1_62)
	local var0_62

	for iter0_62, iter1_62 in ipairs(arg0_62.sceneData.productSystems) do
		if iter1_62.id == IslandProductConst.PasturePlaceId then
			var0_62 = iter1_62

			break
		end
	end

	if not var0_62 then
		return
	end

	local var1_62 = arg1_62.slotId

	for iter2_62, iter3_62 in ipairs(arg1_62.aniList) do
		local var2_62 = var0_62:GenAnimalByAnialConfig(iter3_62, var1_62)

		arg0_62:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_62)
	end
end

function var0_0.OnSlotDelegateInit(arg0_63, arg1_63)
	local var0_63 = arg1_63.slotId
	local var1_63 = pg.island_production_slot[var0_63].place
	local var2_63

	for iter0_63, iter1_63 in ipairs(arg0_63.sceneData.productSystems) do
		if iter1_63.id == var1_63 then
			var2_63 = iter1_63

			break
		end
	end

	if not var2_63 then
		return
	end

	local var3_63 = var2_63:GetCommissionSlotId(var0_63)
	local var4_63 = pg.island_production_commission[var3_63].unlockObjid

	if var4_63 ~= 0 then
		arg0_63:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_63)
	end
end

function var0_0.IsPlayerInTimeline(arg0_64)
	return arg0_64.islandSyncMgr.player:InTimeline()
end

function var0_0.InitSyncMgr(arg0_65)
	arg0_65.islandSyncMgr:Init(arg0_65.sceneData.unitList)
	arg0_65:NotifiyCore(ISLAND_EVT.INIT_INTERACTION_OP_VIEW)
end

function var0_0.SetVisitorSyncData(arg0_66, arg1_66, arg2_66)
	arg0_66:NotifiyCore(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg1_66, arg2_66)
end

function var0_0.WorldObjectInterAction(arg0_67, arg1_67, arg2_67, arg3_67)
	arg3_67 = arg3_67 or 1

	local var0_67 = _.detect(arg0_67.sceneData.unitList, function(arg0_68)
		return arg0_68.id == arg1_67
	end)

	if not var0_67 or not var0_67:Interactable() then
		return
	end

	local var1_67 = var0_67:GetEmptySlot()

	if not var1_67 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_interact_point"))

		return
	end

	local function var2_67()
		var1_67:Lock(arg2_67)
		arg0_67:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_67, var1_67, arg3_67)
	end

	arg0_67.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_67, var1_67.id, arg3_67, function(arg0_70)
		if arg0_70 then
			var2_67()
		end
	end)
end

function var0_0.WorldObjectInterActionSync(arg0_71, arg1_71, arg2_71, arg3_71, arg4_71)
	arg3_71 = arg3_71 or 1

	local var0_71 = _.detect(arg0_71.sceneData.unitList, function(arg0_72)
		return arg0_72.id == arg1_71
	end)

	if not var0_71 or not var0_71:Interactable() then
		return
	end

	local var1_71 = var0_71:GetSlotById(arg4_71)

	var1_71:Lock(arg2_71)
	arg0_71:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_71, var1_71, arg3_71)
end

function var0_0.WorldObjectInterActionEnd(arg0_73, arg1_73, arg2_73)
	local var0_73 = _.detect(arg0_73.sceneData.unitList, function(arg0_74)
		return arg0_74.id == arg1_73
	end)

	if not var0_73 or not var0_73:Interactable() then
		return
	end

	local var1_73 = var0_73:GetUsingSlot(arg2_73)

	local function var2_73()
		local var0_75 = Clone(var1_73)

		var1_73:Release()
		arg0_73:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_73, var0_75)
	end

	arg0_73.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_73, var1_73.id, function(arg0_76)
		if arg0_76 then
			var2_73()
		end
	end)
end

function var0_0.WorldObjectInterActionEndSync(arg0_77, arg1_77, arg2_77)
	local var0_77 = _.detect(arg0_77.sceneData.unitList, function(arg0_78)
		return arg0_78.id == arg1_77
	end)

	if not var0_77 or not var0_77:Interactable() then
		return
	end

	local var1_77 = var0_77:GetUsingSlot(arg2_77)
	local var2_77 = Clone(var1_77)

	var1_77:Release()
	arg0_77:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_77, var2_77)
end

function var0_0.WorldObjectInitStatus(arg0_79, arg1_79, arg2_79)
	local var0_79 = _.detect(arg0_79.sceneData.unitList, function(arg0_80)
		return arg0_80.id == arg1_79
	end)

	warning("init", arg1_79, arg2_79, var0_79)

	if not var0_79 or not var0_79:Interactable() then
		return
	end

	arg0_79:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_79, arg2_79)
end

function var0_0.OnOpenRestaurant(arg0_81, arg1_81)
	local var0_81 = arg1_81.restId
	local var1_81 = arg1_81.postList
	local var2_81

	for iter0_81, iter1_81 in ipairs(arg0_81.sceneData.systemList) do
		if isa(iter1_81, IslandManageSystemVO) and iter1_81.id == var0_81 then
			var2_81 = iter1_81

			break
		end
	end

	if not var2_81 then
		return
	end

	local var3_81 = var2_81:GetUnits(var1_81)

	for iter2_81, iter3_81 in ipairs(var3_81) do
		arg0_81:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_81)
	end

	arg0_81:NotifiyCore(ISLAND_EVT.START_MANAGE, var2_81)
end

function var0_0.OnCloseRestaurant(arg0_82, arg1_82)
	local var0_82 = arg1_82.restId
	local var1_82 = arg1_82.postList
	local var2_82

	for iter0_82, iter1_82 in ipairs(arg0_82.sceneData.systemList) do
		if isa(iter1_82, IslandManageSystemVO) and iter1_82.id == var0_82 then
			var2_82 = iter1_82

			break
		end
	end

	if not var2_82 then
		return
	end

	arg0_82:NotifiyCore(ISLAND_EVT.END_MANAGE, var2_82)

	local var3_82 = var2_82:GetUnits(var1_82)

	for iter2_82, iter3_82 in ipairs(var3_82) do
		arg0_82:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_MANAGE, iter3_82.id)
	end
end

return var0_0
