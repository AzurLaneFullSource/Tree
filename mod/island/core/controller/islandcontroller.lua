local var0_0 = class("IslandController", import(".IslandBaseController"))

function var0_0.Init(arg0_1)
	arg0_1.sceneData = IslandDataConvertor.Island2SceneData(arg0_1.island)
	arg0_1.mapId = arg0_1.sceneData.mapId
end

function var0_0.SystemCtor(arg0_2)
	arg0_2.strollAllocator = IslandStrollAllocator.New(arg0_2)
	arg0_2.visibilityAllocator = IslandVisibilityAllocator.New(arg0_2)
	arg0_2.giftAllocator = IslandGiftAllocator.New(arg0_2)
	arg0_2.activityNpcAllocator = IslandActivityNpcAllocator.New(arg0_2)
	arg0_2.timeDelayCreate = IslandDelayCreationSystem.New(arg0_2)
	arg0_2.playerInputManager = PlayerInputManager.New(arg0_2)
	arg0_2.islandSyncMgr = IslandSyncMgr.New(arg0_2)
end

function var0_0.SetUp(arg0_3)
	arg0_3:SystemCtor()

	for iter0_3, iter1_3 in ipairs(arg0_3.sceneData.unitList) do
		if arg0_3.visibilityAllocator:IsVisible(iter1_3.id) then
			arg0_3:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter1_3)
		end
	end

	for iter2_3, iter3_3 in ipairs(arg0_3.sceneData.activityUnits) do
		if arg0_3.activityNpcAllocator:IsVisible(iter3_3.id) then
			arg0_3:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_3)
		end
	end

	for iter4_3, iter5_3 in ipairs(arg0_3.sceneData.giftUnits) do
		if arg0_3.giftAllocator:IsVisible(iter4_3) then
			arg0_3:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter5_3)
		end
	end

	for iter6_3, iter7_3 in ipairs(arg0_3.sceneData.systemList) do
		arg0_3:NotifiyCore(ISLAND_EVT.GEN_SYSTEM, iter7_3)
	end

	for iter8_3, iter9_3 in ipairs(arg0_3.sceneData.systemUnits) do
		arg0_3:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter9_3)
	end

	for iter10_3, iter11_3 in ipairs(arg0_3.sceneData.strollUnits) do
		local var0_3, var1_3 = arg0_3.strollAllocator:Allocator(iter11_3:GetDefaultPathId(arg0_3.mapId))

		iter11_3:SetPath(var0_3, var1_3)
		arg0_3:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter11_3)
	end

	for iter12_3, iter13_3 in ipairs(arg0_3.sceneData.followUnits) do
		arg0_3:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter13_3)
	end

	arg0_3.timeDelayCreate:InitUnit()
end

function var0_0.ResetPlayerPosition(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.sceneData.unitList) do
		if iter1_4:IsPlayer() then
			arg0_4:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, iter1_4.id, IslandConst.UNIT_LIST_PLAYER, iter1_4.position)
		end
	end
end

function var0_0.OnCoreInitFinish(arg0_5)
	arg0_5:NotifiyCore(ISLAND_EVT.INIT_FINISH, arg0_5.sceneData.camreaZoomData)
	arg0_5:NotifiyIsland(ISLAND_EX_EVT.INIT_FINISH)
	arg0_5.playerInputManager:Init()
	arg0_5:InitStrollUnitsAwards()
	arg0_5:InitSyncMgr()
	arg0_5:InitVisitor()
end

function var0_0.InitVisitor(arg0_6)
	local var0_6 = arg0_6.island:GetVisitorAgency():GetMapVisitorList()

	for iter0_6, iter1_6 in pairs(var0_6) do
		if not iter1_6:IsSelf() then
			arg0_6:OnPlayerAdd({
				player = iter1_6
			})
		else
			arg0_6.islandSyncMgr:OnVisitorEnter(iter1_6.id, nil)
		end
	end
end

function var0_0.InitStrollUnitsAwards(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.sceneData.strollUnits) do
		if iter1_7:ExistActionFeedback() then
			arg0_7:NotifiyCore(ISLAND_EVT.SHOW_NPC_ANIMATION_BUBBLE, iter1_7)
		end
	end
end

function var0_0.GetMapID(arg0_8)
	return arg0_8.mapId
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_9.OnPlayerAdd)
	arg0_9:AddIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_9.OnPlayerExit)
	arg0_9:AddIslandListener(IslandDressUpAgency.MORPH_PLAYER_DRESS, arg0_9.OnPlayerMorphDress)
	arg0_9:AddIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_9.OnPlayerChangeDress)
	arg0_9:AddIslandListener(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, arg0_9.OnShipChangeDress)
	arg0_9:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_9.OnSyncDataUpdate)
	arg0_9:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_9.OnSyncObjUpdate)
	arg0_9:AddIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, arg0_9.OnCollectSlotUnitInit)
	arg0_9:AddIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_UPDATE, arg0_9.OnCollectSlotUnitUpdate)
	arg0_9:AddIslandListener(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, arg0_9.OnCollectSloSlotUnitRemove)
	arg0_9:AddIslandListener(IslandStartDelegationCommand.START_DELEGATION, arg0_9.OnStartDelegation)
	arg0_9:AddIslandListener(IslandFinishDelegationCommand.END_DELEGATION, arg0_9.OnEndDelegation)
	arg0_9:AddIslandListener(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, arg0_9.OnGetAllDelegationAward)
	arg0_9:AddIslandListener(IslandTaskAgency.TASK_ADDED, arg0_9.OnTaskAdd)
	arg0_9:AddIslandListener(IslandTaskAgency.TASK_FINISH, arg0_9.OnFinishTask)
	arg0_9:AddIslandListener(IslandTaskAgency.TASK_UPDATED, arg0_9.OnUpdateTask)
	arg0_9:AddIslandListener(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, arg0_9.OnStartPlant)
	arg0_9:AddIslandListener(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, arg0_9.OnEndPlant)
	arg0_9:AddIslandListener(IslandSlotCollectCommand.START_HAND_COLLECT_DONE, arg0_9.OnStartHandCollect)
	arg0_9:AddIslandListener(IslandBuildingAgency.SLOT_HANDPLABT_SLOT_UNIT_CHANGE, arg0_9.OnHandPlantSlotChangeUnit)
	arg0_9:AddIslandListener(IslandBuildingAgency.CHANGE_PRODUCT_MODEL, arg0_9.OnProductPlaceChangeUnit)
	arg0_9:AddIslandListener(IslandGatherCollectAgency.RemoveGatherUnit, arg0_9.OnRemoveWildGatherDone)
	arg0_9:AddIslandListener(IslandGatherCollectAgency.AddGatherUnit, arg0_9.OnAddWildGatherDone)
	arg0_9:AddIslandListener(ISLAND_EVT.CHANGE_SLOT_MODEL, arg0_9.OnChangeSlotModel)
	arg0_9:AddIslandListener(IslandOpenRestaurantCommand.OPEN_RESTAURANT, arg0_9.OnOpenRestaurant)
	arg0_9:AddIslandListener(IslandCloseRestaurantCommand.CLOSE_RESTAURANT, arg0_9.OnCloseRestaurant)
	arg0_9:AddIslandListener(IslandProxy.STORY_START, arg0_9.OnStartStory)
	arg0_9:AddIslandListener(IslandProxy.STORY_END, arg0_9.OnEndStory)
	arg0_9:AddIslandListener(IslandProxy.PERFORMANCE_START, arg0_9.OnStartPerformance)
	arg0_9:AddIslandListener(IslandProxy.PERFORMANCE_END, arg0_9.OnEndPerformance)
	arg0_9:AddIslandListener(IslandProxy.START_PATHFINDER, arg0_9.OnStartPathFinder)
	arg0_9:AddIslandListener(IslandProxy.END_PATHFINDER, arg0_9.OnEndPathFinder)
	arg0_9:AddIslandListener(IslandProxy.ACTIVE_OR_DISABLE_UNIT, arg0_9.OnActiveOrDisableUnit)
	arg0_9:AddIslandListener(IslandProxy.LINK_CORE, arg0_9.OnLinkCore)
	arg0_9:AddIslandListener(IslandBuildingAgency.GEN_ANIMAL_INT, arg0_9.OnAnimalInit)
	arg0_9:AddIslandListener(IslandBuildingAgency.SLOT_DELEGATE_INIT, arg0_9.OnSlotDelegateInit)
	arg0_9:AddIslandListener(IslandNpcFeedbackAgency.NPC_ACTION_CHANGE, arg0_9.OnNpcActionFeedBackChange)
	arg0_9:AddIslandListener(IslandNpcFeedbackAgency.RESET_NPC_ACTIONS, arg0_9.OnResetNpcActionFeedback)
	arg0_9:AddIslandListener(IslandFollowerAgency.ADD_FOLLOWER, arg0_9.OnAddFollower)
	arg0_9:AddIslandListener(IslandFollowerAgency.DEL_FOLLOWER, arg0_9.OnDelFollower)
	arg0_9:AddIslandListener(ActivityProxy.ACTIVITY_UPDATED, arg0_9.OnActivityUpdate)
	arg0_9:AddIslandListener(IslandProxy.GEN_RECYCLEITEM, arg0_9.OnGenRecycleItem)
	arg0_9:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_ADD, arg0_9.OnActivityNpcAdd)
	arg0_9:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_UPDATE, arg0_9.OnActivityNpcUpdate)
	arg0_9:AddIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_DEL, arg0_9.OnActivityNpcDel)
	arg0_9:AddIslandListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_9.OnSystemUnlock)
	arg0_9:AddIslandListener(IslandProxy.LOCK_NPC_REFRESH, arg0_9.OnLockNpcRefresh)
	arg0_9:AddIslandListener(IslandProxy.RELEASE_NPC_REFRESH, arg0_9.OnReleaseNpcRefresh)
	arg0_9:AddIslandListener(IslandProxy.RESET_SP, arg0_9.OnResetSp)
	arg0_9:AddIslandListener(IslandFishingAgency.BAIT_UPDATE, arg0_9.OnBaitUpdate)
	arg0_9:AddIslandListener(ISLAND_EVT.SWITCH_MAP, arg0_9.OnSwitchMap)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_10.OnPlayerAdd)
	arg0_10:RemoveIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_10.OnPlayerExit)
	arg0_10:RemoveIslandListener(IslandDressUpAgency.MORPH_PLAYER_DRESS, arg0_10.OnPlayerMorphDress)
	arg0_10:RemoveIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_10.OnPlayerChangeDress)
	arg0_10:RemoveIslandListener(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, arg0_10.OnShipChangeDress)
	arg0_10:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_10.OnSyncDataUpdate)
	arg0_10:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_10.OnSyncObjUpdate)
	arg0_10:RemoveIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, arg0_10.OnCollectSlotUnitInit)
	arg0_10:RemoveIslandListener(IslandBuildingAgency.COLLECT_SlOT_UNIT_UPDATE, arg0_10.OnCollectSlotUnitUpdate)
	arg0_10:RemoveIslandListener(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, arg0_10.OnCollectSloSlotUnitRemove)
	arg0_10:RemoveIslandListener(IslandStartDelegationCommand.START_DELEGATION, arg0_10.OnStartDelegation)
	arg0_10:RemoveIslandListener(IslandFinishDelegationCommand.END_DELEGATION, arg0_10.OnEndDelegation)
	arg0_10:RemoveIslandListener(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, arg0_10.OnGetAllDelegationAward)
	arg0_10:RemoveIslandListener(IslandTaskAgency.TASK_ADDED, arg0_10.OnTaskAdd)
	arg0_10:RemoveIslandListener(IslandTaskAgency.TASK_FINISH, arg0_10.OnFinishTask)
	arg0_10:RemoveIslandListener(IslandTaskAgency.TASK_UPDATED, arg0_10.OnUpdateTask)
	arg0_10:RemoveIslandListener(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, arg0_10.OnStartPlant)
	arg0_10:RemoveIslandListener(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, arg0_10.OnEndPlant)
	arg0_10:RemoveIslandListener(IslandSlotCollectCommand.START_HAND_COLLECT_DONE, arg0_10.OnStartHandCollect)
	arg0_10:RemoveIslandListener(IslandBuildingAgency.SLOT_HANDPLABT_SLOT_UNIT_CHANGE, arg0_10.OnHandPlantSlotChangeUnit)
	arg0_10:RemoveIslandListener(IslandBuildingAgency.CHANGE_PRODUCT_MODEL, arg0_10.OnProductPlaceChangeUnit)
	arg0_10:RemoveIslandListener(IslandGatherCollectAgency.RemoveGatherUnit, arg0_10.OnRemoveWildGatherDone)
	arg0_10:RemoveIslandListener(IslandGatherCollectAgency.AddGatherUnit, arg0_10.OnAddWildGatherDone)
	arg0_10:RemoveIslandListener(ISLAND_EVT.CHANGE_SLOT_MODEL, arg0_10.OnChangeSlotModel)
	arg0_10:RemoveIslandListener(IslandOpenRestaurantCommand.OPEN_RESTAURANT, arg0_10.OnOpenRestaurant)
	arg0_10:RemoveIslandListener(IslandProxy.STORY_START, arg0_10.OnStartStory)
	arg0_10:RemoveIslandListener(IslandProxy.STORY_END, arg0_10.OnEndStory)
	arg0_10:RemoveIslandListener(IslandProxy.PERFORMANCE_START, arg0_10.OnStartPerformance)
	arg0_10:RemoveIslandListener(IslandProxy.PERFORMANCE_END, arg0_10.OnEndPerformance)
	arg0_10:RemoveIslandListener(IslandProxy.START_PATHFINDER, arg0_10.OnStartPathFinder)
	arg0_10:RemoveIslandListener(IslandProxy.END_PATHFINDER, arg0_10.OnEndPathFinder)
	arg0_10:RemoveIslandListener(IslandProxy.ACTIVE_OR_DISABLE_UNIT, arg0_10.OnActiveOrDisableUnit)
	arg0_10:RemoveIslandListener(IslandProxy.LINK_CORE, arg0_10.OnLinkCore)
	arg0_10:RemoveIslandListener(IslandBuildingAgency.GEN_ANIMAL_INT, arg0_10.OnAnimalInit)
	arg0_10:RemoveIslandListener(IslandBuildingAgency.SLOT_DELEGATE_INIT, arg0_10.OnSlotDelegateInit)
	arg0_10:RemoveIslandListener(IslandNpcFeedbackAgency.NPC_ACTION_CHANGE, arg0_10.OnNpcActionFeedBackChange)
	arg0_10:RemoveIslandListener(IslandNpcFeedbackAgency.RESET_NPC_ACTIONS, arg0_10.OnResetNpcActionFeedback)
	arg0_10:RemoveIslandListener(IslandFollowerAgency.ADD_FOLLOWER, arg0_10.OnAddFollower)
	arg0_10:RemoveIslandListener(IslandFollowerAgency.DEL_FOLLOWER, arg0_10.OnDelFollower)
	arg0_10:RemoveIslandListener(ActivityProxy.ACTIVITY_UPDATED, arg0_10.OnActivityUpdate)
	arg0_10:RemoveIslandListener(IslandProxy.GEN_RECYCLEITEM, arg0_10.OnGenRecycleItem)
	arg0_10:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_ADD, arg0_10.OnActivityNpcAdd)
	arg0_10:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_UPDATE, arg0_10.OnActivityNpcUpdate)
	arg0_10:RemoveIslandListener(IslandActivityNpcAgency.ACTIVITY_NPC_DEL, arg0_10.OnActivityNpcDel)
	arg0_10:RemoveIslandListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_10.OnSystemUnlock)
	arg0_10:RemoveIslandListener(IslandProxy.LOCK_NPC_REFRESH, arg0_10.OnLockNpcRefresh)
	arg0_10:RemoveIslandListener(IslandProxy.RELEASE_NPC_REFRESH, arg0_10.OnReleaseNpcRefresh)
	arg0_10:RemoveIslandListener(IslandProxy.RESET_SP, arg0_10.OnResetSp)
	arg0_10:RemoveIslandListener(IslandFishingAgency.BAIT_UPDATE, arg0_10.OnBaitUpdate)
	arg0_10:RemoveIslandListener(ISLAND_EVT.SWITCH_MAP, arg0_10.OnSwitchMap)
end

function var0_0.OnBaitUpdate(arg0_11, arg1_11)
	arg0_11:NotifiyCore(ISLAND_EVT.BAIT_UPDATE, arg1_11)
end

function var0_0.OnResetSp(arg0_12)
	local var0_12 = arg0_12.mapId
	local var1_12 = pg.island_world_objects.get_id_list_by_mapId[var0_12] or {}

	for iter0_12, iter1_12 in ipairs(var1_12) do
		local var2_12 = pg.island_world_objects[iter1_12]

		if var2_12.unitId == 0 then
			spConfig = var2_12

			break
		end
	end

	if not spConfig then
		return
	end

	local var3_12 = BuildVector3(spConfig.param.position)
	local var4_12 = BuildVector3(spConfig.param.rotation)
	local var5_12 = getProxy(PlayerProxy):getRawData().id

	arg0_12:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, var5_12, IslandConst.UNIT_LIST_PLAYER, var3_12)
	arg0_12:NotifiyCore(ISLAND_EVT.RESET_UNIT_ROT, var5_12, IslandConst.UNIT_LIST_PLAYER, var4_12)
end

function var0_0.OnLockNpcRefresh(arg0_13, arg1_13, arg2_13)
	arg0_13.visibilityAllocator:LockNpc(arg1_13, arg2_13)
end

function var0_0.OnReleaseNpcRefresh(arg0_14, arg1_14, arg2_14)
	arg0_14.visibilityAllocator:ReleaseNpc(arg1_14, arg2_14)
end

function var0_0.OnSystemUnlock(arg0_15, arg1_15)
	arg0_15:NotifiyCore(ISLAND_EVT.SYSTEM_UNLOCK, arg1_15)
end

function var0_0.OnActivityNpcAdd(arg0_16, arg1_16)
	arg0_16.activityNpcAllocator:AddNpc(arg1_16)
	arg0_16.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcUpdate(arg0_17, arg1_17, arg2_17)
	arg0_17.activityNpcAllocator:DelNpc(arg1_17)
	arg0_17.activityNpcAllocator:AddNpc(arg2_17)
	arg0_17.activityNpcAllocator:Flush()
end

function var0_0.OnActivityNpcDel(arg0_18, arg1_18)
	arg0_18.activityNpcAllocator:DelNpc(arg1_18)
	arg0_18.activityNpcAllocator:Flush()
end

function var0_0.OnActivityUpdate(arg0_19)
	arg0_19.activityNpcAllocator:Flush()
end

function var0_0.OnGenRecycleItem(arg0_20, arg1_20)
	local var0_20 = IslandDataConvertor.GenDelayRecycleIslandUnit(arg1_20)

	arg0_20:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_20)
end

function var0_0.OnAddFollower(arg0_21, arg1_21)
	local var0_21 = #arg0_21.sceneData.followUnits > 0
	local var1_21 = arg0_21:GetIsland():GetCharacterAgency():GetShipById(arg1_21)
	local var2_21 = var1_21:GetModelUnit()
	local var3_21 = arg0_21:GetView():GetPlayerLastGroundedPosition()
	local var4_21 = IslandFollowerUnitVO.New(var1_21.id, arg1_21, var2_21, var3_21, Vector3(0, 0, 0), not var0_21)

	table.insert(arg0_21.sceneData.followUnits, var4_21)
	arg0_21:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_21)

	for iter0_21, iter1_21 in ipairs(arg0_21.sceneData.strollUnits) do
		if var1_21:getConfig("unit_id") == iter1_21.config.unit_id then
			arg0_21:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_STROLL, iter1_21.id)
		end
	end

	arg0_21:NotifiyCore(ISLAND_EVT.ADD_FOLLOWER, var4_21.id)
end

function var0_0.OnDelFollower(arg0_22, arg1_22)
	local var0_22 = 0

	for iter0_22, iter1_22 in ipairs(arg0_22.sceneData.followUnits) do
		if iter1_22.id == arg1_22 then
			var0_22 = iter0_22

			break
		end
	end

	if var0_22 <= 0 then
		return
	end

	local var1_22 = table.remove(arg0_22.sceneData.followUnits, var0_22)

	arg0_22:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_FOLLOW, var1_22.id)

	if var1_22:IsRandomizer() and #arg0_22.sceneData.followUnits > 0 then
		local var2_22 = arg0_22.sceneData.followUnits[1]

		var2_22:ActiveRandomizer()
		arg0_22:NotifiyCore(ISLAND_EVT.RESET_FOLLOW_RANDOMIZER, var2_22.id)
	end

	local var3_22 = arg0_22:GetIsland():GetCharacterAgency():GetShipById(arg1_22)

	for iter2_22, iter3_22 in ipairs(arg0_22.sceneData.strollUnits) do
		if var3_22:getConfig("unit_id") == iter3_22.config.unit_id then
			arg0_22:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_22)
		end
	end

	arg0_22:NotifiyCore(ISLAND_EVT.DEL_FOLLOWER, var1_22.id)
end

function var0_0.OnResetNpcActionFeedback(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.sceneData.strollUnits) do
		if iter1_23:ExistActionFeedback() then
			iter1_23:ClearActionFeedback()
			arg0_23:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_23)
		end
	end

	IslandDataConvertor.DistributeAward4StrollUnits(arg0_23.sceneData.strollUnits, arg0_23:GetIsland())
	arg0_23:InitStrollUnitsAwards()
end

function var0_0.OnNpcActionFeedBackChange(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.sceneData.strollUnits) do
		if iter1_24.id == arg1_24 and iter1_24:ExistActionFeedback() then
			iter1_24:ClearActionFeedback()
			arg0_24:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, iter1_24)
		end
	end
end

function var0_0.OnLinkCore(arg0_25, arg1_25, ...)
	arg0_25:NotifiyCore(arg1_25, ...)
end

function var0_0.OnActiveOrDisableUnit(arg0_26, arg1_26, arg2_26, arg3_26)
	arg0_26:NotifiyCore(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg1_26, arg2_26, arg3_26)
end

function var0_0.OnStartPathFinder(arg0_27, arg1_27)
	arg0_27:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, arg1_27)
end

function var0_0.OnEndPathFinder(arg0_28)
	arg0_28.visibilityAllocator:Flush()
end

function var0_0.OnStartPerformance(arg0_29)
	arg0_29:NotifiyCore(ISLAND_EVT.START_STORY)
	arg0_29:NotifiyCore(ISLAND_EVT.START_PERFORMANCE)
end

function var0_0.OnEndPerformance(arg0_30, arg1_30)
	arg0_30:NotifiyCore(ISLAND_EVT.END_STORY)
	arg0_30:NotifiyCore(ISLAND_EVT.END_PERFORMANCE)

	if arg1_30 then
		arg0_30:OnUpdateTask()
	end
end

function var0_0.OnStartStory(arg0_31)
	arg0_31:NotifiyCore(ISLAND_EVT.START_STORY)
end

function var0_0.OnEndStory(arg0_32, arg1_32)
	arg0_32:NotifiyCore(ISLAND_EVT.END_STORY)

	if arg1_32 then
		arg0_32.visibilityAllocator:Flush()
	end
end

function var0_0.OnTaskAdd(arg0_33)
	arg0_33.visibilityAllocator:Flush()
	arg0_33:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_33:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnFinishTask(arg0_34, arg1_34)
	arg0_34.visibilityAllocator:Flush()
	arg0_34:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_34:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	arg0_34:CheckFinishTask(arg1_34, IslandTaskType.DAILY, "daily_task_follow_action")
	arg0_34:CheckFinishTask(arg1_34, IslandTaskType.WEEKLY, "weekly_task_follow_action")
end

local function var1_0(arg0_35)
	if #arg0_35 == 0 then
		return nil
	end

	return arg0_35[math.random(1, #arg0_35)]
end

function var0_0.CheckFinishTask(arg0_36, arg1_36, arg2_36, arg3_36)
	if IslandTask.New({
		id = arg1_36,
		process_list = {}
	}):GetType() ~= arg2_36 then
		return
	end

	local var0_36 = pg.island_set[arg3_36]

	if not var0_36 then
		return
	end

	local var1_36 = var0_36 and (var0_36.key_value_varchar or {}) or {}
	local var2_36 = arg0_36:GetSelfIsland():GetTaskAgency()
	local var3_36 = var2_36:GetTasks()

	for iter0_36, iter1_36 in ipairs(var3_36) do
		if iter1_36:GetType() == arg2_36 then
			return
		end
	end

	local var4_36 = false
	local var5_36 = var2_36:GetFinishedIds()

	for iter2_36, iter3_36 in ipairs(var5_36) do
		if IslandTask.New({
			id = iter3_36,
			process_list = {}
		}):GetType() == arg2_36 then
			var4_36 = true

			break
		end
	end

	if var4_36 then
		arg0_36:NotifiyCore(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, var1_0(var1_36))
	end
end

function var0_0.OnUpdateTask(arg0_37)
	arg0_37:Debounce("RefreshTask", function()
		if not arg0_37.visibilityAllocator then
			return
		end

		arg0_37.visibilityAllocator:Flush()
		arg0_37:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
		arg0_37:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	end, 0.5, false)()
end

function var0_0.Debounce(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	if not arg0_39.__debouncers then
		arg0_39.__debouncers = {}
	end

	if not arg0_39.__debouncers[arg1_39] then
		arg0_39.__debouncers[arg1_39] = debounce(arg2_39, arg3_39, arg4_39)
	end

	return arg0_39.__debouncers[arg1_39]
end

function var0_0.OnPlayerAdd(arg0_40, arg1_40)
	local var0_40 = IslandDataConvertor.PlayerData2IslandUnit(arg1_40.player, arg0_40.mapId, arg0_40:GetIsland().id)

	arg0_40:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_40, function(arg0_41)
		arg0_40.islandSyncMgr:OnVisitorEnter(arg1_40.player.id, arg0_41)
	end)
end

function var0_0.OnPlayerExit(arg0_42, arg1_42)
	arg0_42:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_PLAYER, arg1_42.id)
	arg0_42.islandSyncMgr:OnVisitorExit(arg1_42.id)
end

function var0_0.OnPlayerMorphDress(arg0_43, ...)
	arg0_43:NotifiyCore(ISLAND_EVT.MORPH_FORM_CHANGE, ...)
end

function var0_0.OnPlayerChangeDress(arg0_44, arg1_44, arg2_44)
	arg0_44:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_44, arg2_44)
end

function var0_0.OnShipChangeDress(arg0_45, arg1_45, arg2_45, arg3_45, arg4_45)
	arg0_45:NotifiyCore(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg1_45, arg2_45, arg3_45, arg4_45)
end

function var0_0.OnStartPlant(arg0_46, arg1_46)
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

	arg0_46:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_46)

	local var2_46 = var0_46:GenHandPlantUnitBySlotData(arg1_46.area_id, arg1_46.formula_id)

	arg0_46:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_46)
	arg0_46:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_46)
end

function var0_0.OnEndPlant(arg0_47, arg1_47)
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

	arg0_47:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_47)

	local var2_47 = var0_47:GenHandPlantUnitBySlotData(arg1_47.area_id)

	arg0_47:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_47)
	arg0_47:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_47)
end

function var0_0.OnStartDelegation(arg0_48, arg1_48)
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

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_48.build_id) then
		local var2_48 = pg.island_production_slot[arg1_48.area_id]

		for iter4_48, iter5_48 in ipairs(var2_48.exclusion_slot) do
			local var3_48 = var1_48:GetUnitIdBySlotId(iter5_48)
			local var4_48 = var1_48:GetUnitVOByUnitId(var3_48)

			if var4_48 then
				var4_48:ChangeSlotType(IslandProductConst.ProductSlotType.RoleDelegation)
			end
		end
	end

	local var5_48 = {}

	if table.contains(IslandProductConst.havePerformPlace, arg1_48.build_id) then
		local var6_48 = var1_48:GetDelegateUnitsByBuildIdAndSlotId(arg1_48.build_id, arg1_48.area_id, arg1_48.formula_id)

		var5_48.commissionSlotId = var1_48:GetCommissionSlotId(arg1_48.area_id)
		var5_48.unitIds = {}

		for iter6_48, iter7_48 in ipairs(var6_48) do
			table.insert(var5_48.unitIds, iter7_48.id)
		end

		for iter8_48, iter9_48 in ipairs(var6_48) do
			arg0_48:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter9_48)
		end
	end

	local var7_48 = var1_48:GetDelegateEffectsByCommissonId(arg1_48.area_id)

	if var7_48 then
		local var8_48 = var1_48:GenUnitByDelegateEffectId(var7_48)

		if var8_48 then
			arg0_48:NotifiyCore(ISLAND_EVT.GEN_UNIT, var8_48)
		end
	end

	local var9_48 = var0_48:GetUnit(arg1_48.ship_id, arg1_48.area_id, true)

	if var9_48 then
		arg0_48:NotifiyCore(ISLAND_EVT.GEN_UNIT, var9_48)
	end

	arg0_48:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_48, var5_48)
end

function var0_0.OnEndDelegation(arg0_49, arg1_49)
	local var0_49

	for iter0_49, iter1_49 in ipairs(arg0_49.sceneData.systemList) do
		if isa(iter1_49, IslandCharacterSystemVO) and iter1_49.id == arg1_49.build_id then
			var0_49 = iter1_49

			break
		end
	end

	if not var0_49 then
		return
	end

	arg0_49:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_49)

	local var1_49 = var0_49:GetUnitShipIdBySlotId(arg1_49.ship_id, arg1_49.area_id)

	if var1_49 then
		arg0_49:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATION, var1_49)
	end

	local var2_49

	for iter2_49, iter3_49 in ipairs(arg0_49.sceneData.productSystems) do
		if iter3_49.id == arg1_49.build_id then
			var2_49 = iter3_49

			break
		end
	end

	if table.contains(IslandProductConst.havePerformPlace, arg1_49.build_id) then
		local var3_49 = var2_49:GetDelegatUnitsBySlotId(arg1_49.area_id)

		for iter4_49, iter5_49 in ipairs(var3_49) do
			arg0_49:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATE_UNIT, iter5_49)
		end
	end

	local var4_49 = var2_49:GetDelegateEffectsByCommissonId(arg1_49.area_id)

	if var4_49 then
		arg0_49:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_49)
	end

	if arg1_49.remainReward then
		return
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_49.build_id) then
		local var5_49 = pg.island_production_slot[arg1_49.area_id]

		for iter6_49, iter7_49 in ipairs(var5_49.exclusion_slot) do
			local var6_49 = var2_49:GetUnitIdBySlotId(iter7_49)

			arg0_49:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var6_49)

			local var7_49 = var2_49:GenHandPlantUnitBySlotData(iter7_49)

			arg0_49:NotifiyCore(ISLAND_EVT.GEN_UNIT, var7_49)
		end
	end
end

function var0_0.OnGetAllDelegationAward(arg0_50, arg1_50)
	local var0_50

	for iter0_50, iter1_50 in ipairs(arg0_50.sceneData.systemList) do
		if isa(iter1_50, IslandCharacterSystemVO) and iter1_50.id == arg1_50.build_id then
			var0_50 = iter1_50

			break
		end
	end

	if not var0_50 then
		return
	end

	local var1_50

	for iter2_50, iter3_50 in ipairs(arg0_50.sceneData.productSystems) do
		if iter3_50.id == arg1_50.build_id then
			var1_50 = iter3_50

			break
		end
	end

	if arg1_50.build_id == IslandProductConst.FarmlandPlaceId or arg1_50.build_id == IslandProductConst.OrchardPlaceId or arg1_50.build_id == IslandProductConst.GardenPlaceId then
		local var2_50 = pg.island_production_slot[arg1_50.area_id]

		for iter4_50, iter5_50 in ipairs(var2_50.exclusion_slot) do
			local var3_50 = var1_50:GetUnitIdBySlotId(iter5_50)

			arg0_50:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_50)

			local var4_50 = var1_50:GenHandPlantUnitBySlotData(iter5_50)

			arg0_50:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_50)
		end
	end
end

function var0_0.OnChangeSlotModel(arg0_51, arg1_51)
	local var0_51

	for iter0_51, iter1_51 in ipairs(arg0_51.sceneData.productSystems) do
		if iter1_51.id == IslandProductConst.FarmlandPlaceId then
			var0_51 = iter1_51

			break
		end
	end

	if not var0_51 then
		return
	end

	arg0_51:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_51.id)

	local var1_51 = var0_51:GetUnitVOByUnitId(arg1_51.id)

	var1_51.modelId = arg1_51.modelId

	arg0_51:NotifiyCore(ISLAND_EVT.GEN_UNIT, var1_51)
end

function var0_0.OnStartHandCollect(arg0_52, arg1_52)
	local var0_52

	for iter0_52, iter1_52 in ipairs(arg0_52.sceneData.productSystems) do
		if iter1_52.id == arg1_52.build_id then
			var0_52 = iter1_52

			break
		end
	end

	if not var0_52 then
		return
	end

	local var1_52 = var0_52:GetUnitIdBySlotId(arg1_52.area_id)

	arg0_52:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var1_52)
	arg0_52:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_52)
end

function var0_0.OnHandPlantSlotChangeUnit(arg0_53, arg1_53)
	local var0_53

	for iter0_53, iter1_53 in ipairs(arg0_53.sceneData.productSystems) do
		if iter1_53.id == arg1_53.build_id then
			var0_53 = iter1_53

			break
		end
	end

	if not var0_53 then
		return
	end

	local var1_53 = var0_53:GetUnitIdBySlotId(arg1_53.slotId)

	arg0_53:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_53)

	local var2_53 = var0_53:GenHandPlantUnitBySlotData(arg1_53.slotId)

	arg0_53:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_53)
end

function var0_0.OnProductPlaceChangeUnit(arg0_54, arg1_54)
	local var0_54 = arg1_54.build_id
	local var1_54

	for iter0_54, iter1_54 in ipairs(arg0_54.sceneData.productSystems) do
		if iter1_54.id == var0_54 then
			var1_54 = iter1_54

			break
		end
	end

	if not var1_54 then
		return
	end

	local var2_54 = var1_54:GetPlaceModelId(false)

	arg0_54:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var2_54)

	local var3_54 = var1_54:GetPlaceModelUnit(true)

	arg0_54:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_54)
end

function var0_0.OnRemoveWildGatherDone(arg0_55, arg1_55)
	arg0_55:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_55.unitId)
	arg0_55:NotifiyCore(ISLAND_EVT.LEAVE_UNIT, {
		id = arg1_55.unitId
	})
end

function var0_0.OnAddWildGatherDone(arg0_56, arg1_56)
	local var0_56 = IslandDataConvertor.GenWildGatherUnit(arg1_56)

	arg0_56:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_56)
end

function var0_0.OnCollectSlotUnitInit(arg0_57, arg1_57)
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

	local var3_57 = var2_57:InitHandCollectSlotBySlotId(var0_57)

	if var3_57 then
		arg0_57:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_57)
	end
end

function var0_0.OnCollectSlotUnitUpdate(arg0_58, arg1_58)
	local var0_58 = arg1_58.slotId
	local var1_58 = pg.island_production_slot[var0_58].place
	local var2_58

	for iter0_58, iter1_58 in ipairs(arg0_58.sceneData.productSystems) do
		if iter1_58.id == var1_58 then
			var2_58 = iter1_58

			break
		end
	end

	if not var2_58 then
		return
	end

	local var3_58 = var2_58:GetUnitIdBySlotId(arg1_58.slotId)

	if var3_58 then
		arg0_58:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var3_58)
		arg0_58:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var3_58)
	end
end

function var0_0.OnCollectSloSlotUnitRemove(arg0_59, arg1_59)
	local var0_59 = arg1_59.slotId
	local var1_59 = pg.island_production_slot[var0_59].place
	local var2_59

	for iter0_59, iter1_59 in ipairs(arg0_59.sceneData.productSystems) do
		if iter1_59.id == var1_59 then
			var2_59 = iter1_59

			break
		end
	end

	if not var2_59 then
		return
	end

	local var3_59 = var2_59:GetHandCollectSlotBySlotId(var0_59)

	arg0_59:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_59)
end

function var0_0.OnSyncDataUpdate(arg0_60, arg1_60)
	arg0_60.islandSyncMgr:HandleSyncData(arg1_60)
end

function var0_0.OnSyncObjUpdate(arg0_61, arg1_61)
	arg0_61.islandSyncMgr:HandleSyncObj(arg1_61)
end

function var0_0.Update(arg0_62)
	arg0_62.playerInputManager:Update()
	arg0_62.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_63)
	if arg0_63.playerInputManager then
		arg0_63.playerInputManager:Dispose()

		arg0_63.playerInputManager = nil
	end

	if arg0_63.islandSyncMgr then
		arg0_63.islandSyncMgr:Dispose()

		arg0_63.islandSyncMgr = nil
	end

	if arg0_63.strollAllocator then
		arg0_63.strollAllocator:Dispose()

		arg0_63.strollAllocator = nil
	end

	if arg0_63.visibilityAllocator then
		arg0_63.visibilityAllocator:Dispose()

		arg0_63.visibilityAllocator = nil
	end

	if arg0_63.giftAllocator then
		arg0_63.giftAllocator:Dispose()

		arg0_63.giftAllocator = nil
	end

	if arg0_63.timeDelayCreate then
		arg0_63.timeDelayCreate:Dispose()

		arg0_63.timeDelayCreate = nil
	end

	if arg0_63.activityNpcAllocator then
		arg0_63.activityNpcAllocator:Dispose()

		arg0_63.activityNpcAllocator = nil
	end

	arg0_63.__debouncers = nil
end

function var0_0.OnAnimalInit(arg0_64, arg1_64)
	local var0_64

	for iter0_64, iter1_64 in ipairs(arg0_64.sceneData.productSystems) do
		if iter1_64.id == IslandProductConst.PasturePlaceId then
			var0_64 = iter1_64

			break
		end
	end

	if not var0_64 then
		return
	end

	local var1_64 = arg1_64.slotId

	for iter2_64, iter3_64 in ipairs(arg1_64.aniList) do
		local var2_64 = var0_64:GenAnimalByAnialConfig(iter3_64, var1_64)

		arg0_64:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_64)
	end
end

function var0_0.OnSlotDelegateInit(arg0_65, arg1_65)
	local var0_65 = arg1_65.slotId
	local var1_65 = pg.island_production_slot[var0_65].place
	local var2_65

	for iter0_65, iter1_65 in ipairs(arg0_65.sceneData.productSystems) do
		if iter1_65.id == var1_65 then
			var2_65 = iter1_65

			break
		end
	end

	if not var2_65 then
		return
	end

	local var3_65 = var2_65:GetCommissionSlotId(var0_65)
	local var4_65 = pg.island_production_commission[var3_65].unlockObjid

	if var4_65 ~= 0 then
		arg0_65:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_65)
	end
end

function var0_0.IsPlayerInTimeline(arg0_66)
	return arg0_66.islandSyncMgr.player:InTimeline()
end

function var0_0.InitSyncMgr(arg0_67)
	arg0_67.islandSyncMgr:Init(arg0_67.sceneData.unitList)
end

function var0_0.SetVisitorSyncData(arg0_68, arg1_68, arg2_68)
	arg0_68:NotifiyCore(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg1_68, arg2_68)
end

function var0_0.WorldObjectInterAction(arg0_69, arg1_69, arg2_69, arg3_69)
	arg3_69 = arg3_69 or 1

	local var0_69 = _.detect(arg0_69.sceneData.unitList, function(arg0_70)
		return arg0_70.id == arg1_69
	end)

	if not var0_69 or not var0_69:Interactable() then
		return
	end

	local var1_69 = var0_69:GetEmptySlot()

	if not var1_69 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_interact_point"))

		return
	end

	local function var2_69()
		var1_69:Lock(arg2_69)
		arg0_69:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_69, var1_69, arg3_69)
	end

	arg0_69.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_69, var1_69.id, arg3_69, function(arg0_72)
		if arg0_72 then
			var2_69()
		end
	end)
end

function var0_0.WorldObjectInterActionSync(arg0_73, arg1_73, arg2_73, arg3_73, arg4_73)
	arg3_73 = arg3_73 or 1

	local var0_73 = _.detect(arg0_73.sceneData.unitList, function(arg0_74)
		return arg0_74.id == arg1_73
	end)

	if not var0_73 or not var0_73:Interactable() then
		return
	end

	local var1_73 = var0_73:GetSlotById(arg4_73)

	var1_73:Lock(arg2_73)
	arg0_73:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_73, var1_73, arg3_73)
end

function var0_0.WorldObjectInterActionEnd(arg0_75, arg1_75, arg2_75)
	local var0_75 = _.detect(arg0_75.sceneData.unitList, function(arg0_76)
		return arg0_76.id == arg1_75
	end)

	if not var0_75 or not var0_75:Interactable() then
		return
	end

	local var1_75 = var0_75:GetUsingSlot(arg2_75)

	local function var2_75()
		local var0_77 = Clone(var1_75)

		var1_75:Release()
		arg0_75:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_75, var0_77)
	end

	arg0_75.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_75, var1_75.id, function(arg0_78)
		if arg0_78 then
			var2_75()
		end
	end)
end

function var0_0.WorldObjectInterActionEndSync(arg0_79, arg1_79, arg2_79)
	local var0_79 = _.detect(arg0_79.sceneData.unitList, function(arg0_80)
		return arg0_80.id == arg1_79
	end)

	if not var0_79 or not var0_79:Interactable() then
		return
	end

	local var1_79 = var0_79:GetUsingSlot(arg2_79)
	local var2_79 = Clone(var1_79)

	var1_79:Release()
	arg0_79:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_79, var2_79)
end

function var0_0.WorldObjectInitStatus(arg0_81, arg1_81, arg2_81)
	local var0_81 = _.detect(arg0_81.sceneData.unitList, function(arg0_82)
		return arg0_82.id == arg1_81
	end)

	warning("init", arg1_81, arg2_81, var0_81)

	if not var0_81 or not var0_81:Interactable() then
		return
	end

	arg0_81:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_81, arg2_81)
end

function var0_0.OnOpenRestaurant(arg0_83, arg1_83)
	local var0_83 = arg1_83.restId
	local var1_83 = arg1_83.postList
	local var2_83

	for iter0_83, iter1_83 in ipairs(arg0_83.sceneData.systemList) do
		if isa(iter1_83, IslandManageSystemVO) and iter1_83.id == var0_83 then
			var2_83 = iter1_83

			break
		end
	end

	if not var2_83 then
		return
	end

	local var3_83 = var2_83:GetUnits(var1_83)

	for iter2_83, iter3_83 in ipairs(var3_83) do
		arg0_83:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_83)
	end

	arg0_83:NotifiyCore(ISLAND_EVT.START_MANAGE, var2_83)
end

function var0_0.OnCloseRestaurant(arg0_84, arg1_84)
	local var0_84 = arg1_84.restId
	local var1_84 = arg1_84.postList
	local var2_84

	for iter0_84, iter1_84 in ipairs(arg0_84.sceneData.systemList) do
		if isa(iter1_84, IslandManageSystemVO) and iter1_84.id == var0_84 then
			var2_84 = iter1_84

			break
		end
	end

	if not var2_84 then
		return
	end

	arg0_84:NotifiyCore(ISLAND_EVT.END_MANAGE, var2_84)

	local var3_84 = var2_84:GetUnits(var1_84)

	for iter2_84, iter3_84 in ipairs(var3_84) do
		arg0_84:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_MANAGE, iter3_84.id)
	end
end

function var0_0.OnSwitchMap(arg0_85)
	if arg0_85.islandSyncMgr and arg0_85.islandSyncMgr:IsPlayerInTimeline() then
		arg0_85:NotifiyCore(ISLAND_EVT.INIT_INTERACTION_OP_VIEW)
	end
end

return var0_0
