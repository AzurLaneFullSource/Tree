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
		if iter1_7:ExistGreetingActionFeedback() then
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
	arg0_9:AddIslandListener(IslandCharacterAgency.SHIP_SKILL_STATE_CHANGE, arg0_9.OnShipSkillStateChange)
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
	arg0_10:RemoveIslandListener(IslandCharacterAgency.SHIP_SKILL_STATE_CHANGE, arg0_10.OnShipSkillStateChange)
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
		if iter1_23:ExistGreetingActionFeedback() then
			iter1_23:ClearGreetingActionFeedback()
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

function var0_0.OnShipSkillStateChange(arg0_25, arg1_25, arg2_25)
	local var0_25

	for iter0_25, iter1_25 in ipairs(arg0_25.sceneData.strollUnits) do
		if iter1_25:IsSameShip(arg1_25) then
			var0_25 = iter1_25

			break
		end
	end

	if var0_25 then
		if not arg2_25 then
			var0_25:ClearSkillActionFeedback()
			arg0_25:NotifiyCore(ISLAND_EVT.HIDE_NPC_ANIMATION_BUBBLE, var0_25)
		else
			local var1_25 = arg0_25:GetIsland()
			local var2_25 = IslandDataConvertor.GetOwnActions(var1_25)

			IslandDataConvertor.DistributeShipSkillAward4StrollUnits(arg0_25.sceneData.strollUnits, var1_25, var2_25)
			arg0_25:InitStrollUnitsAwards()
		end
	end
end

function var0_0.OnLinkCore(arg0_26, arg1_26, ...)
	arg0_26:NotifiyCore(arg1_26, ...)
end

function var0_0.OnActiveOrDisableUnit(arg0_27, arg1_27, arg2_27, arg3_27)
	arg0_27:NotifiyCore(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg1_27, arg2_27, arg3_27)
end

function var0_0.OnStartPathFinder(arg0_28, arg1_28)
	arg0_28:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, arg1_28)
end

function var0_0.OnEndPathFinder(arg0_29)
	arg0_29.visibilityAllocator:Flush()
end

function var0_0.OnStartPerformance(arg0_30)
	arg0_30:NotifiyCore(ISLAND_EVT.START_STORY)
	arg0_30:NotifiyCore(ISLAND_EVT.START_PERFORMANCE)
end

function var0_0.OnEndPerformance(arg0_31, arg1_31)
	arg0_31:NotifiyCore(ISLAND_EVT.END_STORY)
	arg0_31:NotifiyCore(ISLAND_EVT.END_PERFORMANCE)

	if arg1_31 then
		arg0_31:OnUpdateTask()
	end
end

function var0_0.OnStartStory(arg0_32)
	arg0_32:NotifiyCore(ISLAND_EVT.START_STORY)
end

function var0_0.OnEndStory(arg0_33, arg1_33)
	arg0_33:NotifiyCore(ISLAND_EVT.END_STORY)

	if arg1_33 then
		arg0_33.visibilityAllocator:Flush()
	end
end

function var0_0.OnTaskAdd(arg0_34)
	arg0_34.visibilityAllocator:Flush()
	arg0_34:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_34:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnFinishTask(arg0_35, arg1_35)
	arg0_35.visibilityAllocator:Flush()
	arg0_35:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_35:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	arg0_35:CheckFinishTask(arg1_35, IslandTaskType.DAILY, "daily_task_follow_action")
	arg0_35:CheckFinishTask(arg1_35, IslandTaskType.WEEKLY, "weekly_task_follow_action")
end

local function var1_0(arg0_36)
	if #arg0_36 == 0 then
		return nil
	end

	return arg0_36[math.random(1, #arg0_36)]
end

function var0_0.CheckFinishTask(arg0_37, arg1_37, arg2_37, arg3_37)
	if IslandTask.New({
		id = arg1_37,
		process_list = {}
	}):GetType() ~= arg2_37 then
		return
	end

	local var0_37 = pg.island_set[arg3_37]

	if not var0_37 then
		return
	end

	local var1_37 = var0_37 and (var0_37.key_value_varchar or {}) or {}
	local var2_37 = arg0_37:GetSelfIsland():GetTaskAgency()
	local var3_37 = var2_37:GetTasks()

	for iter0_37, iter1_37 in ipairs(var3_37) do
		if iter1_37:GetType() == arg2_37 then
			return
		end
	end

	local var4_37 = false
	local var5_37 = var2_37:GetFinishedIds()

	for iter2_37, iter3_37 in ipairs(var5_37) do
		if IslandTask.New({
			id = iter3_37,
			process_list = {}
		}):GetType() == arg2_37 then
			var4_37 = true

			break
		end
	end

	if var4_37 then
		arg0_37:NotifiyCore(ISLAND_EVT.ALL_DAILY_OR_WEEKLY_FINISH, var1_0(var1_37))
	end
end

function var0_0.OnUpdateTask(arg0_38)
	arg0_38:Debounce("RefreshTask", function()
		if not arg0_38.visibilityAllocator then
			return
		end

		arg0_38.visibilityAllocator:Flush()
		arg0_38:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
		arg0_38:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
	end, 0.5, false)()
end

function var0_0.Debounce(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40)
	if not arg0_40.__debouncers then
		arg0_40.__debouncers = {}
	end

	if not arg0_40.__debouncers[arg1_40] then
		arg0_40.__debouncers[arg1_40] = debounce(arg2_40, arg3_40, arg4_40)
	end

	return arg0_40.__debouncers[arg1_40]
end

function var0_0.OnPlayerAdd(arg0_41, arg1_41)
	local var0_41 = IslandDataConvertor.PlayerData2IslandUnit(arg1_41.player, arg0_41.mapId, arg0_41:GetIsland().id)

	arg0_41:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_41, function(arg0_42)
		arg0_41.islandSyncMgr:OnVisitorEnter(arg1_41.player.id, arg0_42)
	end)
end

function var0_0.OnPlayerExit(arg0_43, arg1_43)
	arg0_43:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_PLAYER, arg1_43.id)
	arg0_43.islandSyncMgr:OnVisitorExit(arg1_43.id)
end

function var0_0.OnPlayerMorphDress(arg0_44, ...)
	arg0_44:NotifiyCore(ISLAND_EVT.MORPH_FORM_CHANGE, ...)
end

function var0_0.OnPlayerChangeDress(arg0_45, arg1_45, arg2_45)
	arg0_45:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_45, arg2_45)
end

function var0_0.OnShipChangeDress(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46)
	arg0_46:NotifiyCore(ISLAND_EVT.CHANGE_CHARACTER_DRESS, arg1_46, arg2_46, arg3_46, arg4_46)
end

function var0_0.OnStartPlant(arg0_47, arg1_47)
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

	local var2_47 = var0_47:GenHandPlantUnitBySlotData(arg1_47.area_id, arg1_47.formula_id)

	arg0_47:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_47)
	arg0_47:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_47)
end

function var0_0.OnEndPlant(arg0_48, arg1_48)
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

	arg0_48:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_48)

	local var2_48 = var0_48:GenHandPlantUnitBySlotData(arg1_48.area_id)

	arg0_48:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_48)
	arg0_48:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_48)
end

function var0_0.OnStartDelegation(arg0_49, arg1_49)
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

	local var1_49

	for iter2_49, iter3_49 in ipairs(arg0_49.sceneData.productSystems) do
		if iter3_49.id == arg1_49.build_id then
			var1_49 = iter3_49

			break
		end
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_49.build_id) then
		local var2_49 = pg.island_production_slot[arg1_49.area_id]

		for iter4_49, iter5_49 in ipairs(var2_49.exclusion_slot) do
			local var3_49 = var1_49:GetUnitIdBySlotId(iter5_49)
			local var4_49 = var1_49:GetUnitVOByUnitId(var3_49)

			if var4_49 then
				var4_49:ChangeSlotType(IslandProductConst.ProductSlotType.RoleDelegation)
			end
		end
	end

	local var5_49 = {}

	if table.contains(IslandProductConst.havePerformPlace, arg1_49.build_id) then
		local var6_49 = var1_49:GetDelegateUnitsByBuildIdAndSlotId(arg1_49.build_id, arg1_49.area_id, arg1_49.formula_id)

		var5_49.commissionSlotId = var1_49:GetCommissionSlotId(arg1_49.area_id)
		var5_49.unitIds = {}

		for iter6_49, iter7_49 in ipairs(var6_49) do
			table.insert(var5_49.unitIds, iter7_49.id)
		end

		for iter8_49, iter9_49 in ipairs(var6_49) do
			arg0_49:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter9_49)
		end
	end

	local var7_49 = var1_49:GetDelegateEffectsByCommissonId(arg1_49.area_id)

	if var7_49 then
		local var8_49 = var1_49:GenUnitByDelegateEffectId(var7_49)

		if var8_49 then
			arg0_49:NotifiyCore(ISLAND_EVT.GEN_UNIT, var8_49)
		end
	end

	local var9_49 = var0_49:GetUnit(arg1_49.ship_id, arg1_49.area_id, true)

	if var9_49 then
		arg0_49:NotifiyCore(ISLAND_EVT.GEN_UNIT, var9_49)
	end

	arg0_49:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_49, var5_49)
end

function var0_0.OnEndDelegation(arg0_50, arg1_50)
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

	arg0_50:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_50)

	local var1_50 = var0_50:GetUnitShipIdBySlotId(arg1_50.ship_id, arg1_50.area_id)

	if var1_50 then
		arg0_50:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATION, var1_50)
	end

	local var2_50

	for iter2_50, iter3_50 in ipairs(arg0_50.sceneData.productSystems) do
		if iter3_50.id == arg1_50.build_id then
			var2_50 = iter3_50

			break
		end
	end

	if table.contains(IslandProductConst.havePerformPlace, arg1_50.build_id) then
		local var3_50 = var2_50:GetDelegatUnitsBySlotId(arg1_50.area_id)

		for iter4_50, iter5_50 in ipairs(var3_50) do
			arg0_50:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATE_UNIT, iter5_50)
		end
	end

	local var4_50 = var2_50:GetDelegateEffectsByCommissonId(arg1_50.area_id)

	if var4_50 then
		arg0_50:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_50)
	end

	if arg1_50.remainReward then
		return
	end

	if table.contains(IslandProductConst.PlantPlaceIdLists, arg1_50.build_id) then
		local var5_50 = pg.island_production_slot[arg1_50.area_id]

		for iter6_50, iter7_50 in ipairs(var5_50.exclusion_slot) do
			local var6_50 = var2_50:GetUnitIdBySlotId(iter7_50)

			arg0_50:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var6_50)

			local var7_50 = var2_50:GenHandPlantUnitBySlotData(iter7_50)

			arg0_50:NotifiyCore(ISLAND_EVT.GEN_UNIT, var7_50)
		end
	end
end

function var0_0.OnGetAllDelegationAward(arg0_51, arg1_51)
	local var0_51

	for iter0_51, iter1_51 in ipairs(arg0_51.sceneData.systemList) do
		if isa(iter1_51, IslandCharacterSystemVO) and iter1_51.id == arg1_51.build_id then
			var0_51 = iter1_51

			break
		end
	end

	if not var0_51 then
		return
	end

	local var1_51

	for iter2_51, iter3_51 in ipairs(arg0_51.sceneData.productSystems) do
		if iter3_51.id == arg1_51.build_id then
			var1_51 = iter3_51

			break
		end
	end

	if arg1_51.build_id == IslandProductConst.FarmlandPlaceId or arg1_51.build_id == IslandProductConst.OrchardPlaceId or arg1_51.build_id == IslandProductConst.GardenPlaceId then
		local var2_51 = pg.island_production_slot[arg1_51.area_id]

		for iter4_51, iter5_51 in ipairs(var2_51.exclusion_slot) do
			local var3_51 = var1_51:GetUnitIdBySlotId(iter5_51)

			arg0_51:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_51)

			local var4_51 = var1_51:GenHandPlantUnitBySlotData(iter5_51)

			arg0_51:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_51)
		end
	end
end

function var0_0.OnChangeSlotModel(arg0_52, arg1_52)
	local var0_52

	for iter0_52, iter1_52 in ipairs(arg0_52.sceneData.productSystems) do
		if iter1_52.id == IslandProductConst.FarmlandPlaceId then
			var0_52 = iter1_52

			break
		end
	end

	if not var0_52 then
		return
	end

	arg0_52:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_52.id)

	local var1_52 = var0_52:GetUnitVOByUnitId(arg1_52.id)

	var1_52.modelId = arg1_52.modelId

	arg0_52:NotifiyCore(ISLAND_EVT.GEN_UNIT, var1_52)
end

function var0_0.OnStartHandCollect(arg0_53, arg1_53)
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

	local var1_53 = var0_53:GetUnitIdBySlotId(arg1_53.area_id)

	arg0_53:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var1_53)
	arg0_53:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_53)
end

function var0_0.OnHandPlantSlotChangeUnit(arg0_54, arg1_54)
	local var0_54

	for iter0_54, iter1_54 in ipairs(arg0_54.sceneData.productSystems) do
		if iter1_54.id == arg1_54.build_id then
			var0_54 = iter1_54

			break
		end
	end

	if not var0_54 then
		return
	end

	local var1_54 = var0_54:GetUnitIdBySlotId(arg1_54.slotId)

	arg0_54:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_54)

	local var2_54 = var0_54:GenHandPlantUnitBySlotData(arg1_54.slotId)

	arg0_54:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_54)
end

function var0_0.OnProductPlaceChangeUnit(arg0_55, arg1_55)
	local var0_55 = arg1_55.build_id
	local var1_55

	for iter0_55, iter1_55 in ipairs(arg0_55.sceneData.productSystems) do
		if iter1_55.id == var0_55 then
			var1_55 = iter1_55

			break
		end
	end

	if not var1_55 then
		return
	end

	local var2_55 = var1_55:GetPlaceModelId(false)

	arg0_55:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var2_55)

	local var3_55 = var1_55:GetPlaceModelUnit(true)

	arg0_55:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_55)
end

function var0_0.OnRemoveWildGatherDone(arg0_56, arg1_56)
	arg0_56:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_56.unitId)
	arg0_56:NotifiyCore(ISLAND_EVT.LEAVE_UNIT, {
		id = arg1_56.unitId
	})
end

function var0_0.OnAddWildGatherDone(arg0_57, arg1_57)
	local var0_57 = IslandDataConvertor.GenWildGatherUnit(arg1_57)

	arg0_57:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_57)
end

function var0_0.OnCollectSlotUnitInit(arg0_58, arg1_58)
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

	local var3_58 = var2_58:InitHandCollectSlotBySlotId(var0_58)

	if var3_58 then
		arg0_58:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_58)
	end
end

function var0_0.OnCollectSlotUnitUpdate(arg0_59, arg1_59)
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

	local var3_59 = var2_59:GetUnitIdBySlotId(arg1_59.slotId)

	if var3_59 then
		arg0_59:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HAND_COLLECT, var3_59)
		arg0_59:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var3_59)
	end
end

function var0_0.OnCollectSloSlotUnitRemove(arg0_60, arg1_60)
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

	local var3_60 = var2_60:GetHandCollectSlotBySlotId(var0_60)

	arg0_60:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_60)
end

function var0_0.OnSyncDataUpdate(arg0_61, arg1_61)
	arg0_61.islandSyncMgr:HandleSyncData(arg1_61)
end

function var0_0.OnSyncObjUpdate(arg0_62, arg1_62)
	arg0_62.islandSyncMgr:HandleSyncObj(arg1_62)
end

function var0_0.Update(arg0_63)
	arg0_63.playerInputManager:Update()
	arg0_63.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_64)
	if arg0_64.playerInputManager then
		arg0_64.playerInputManager:Dispose()

		arg0_64.playerInputManager = nil
	end

	if arg0_64.islandSyncMgr then
		arg0_64.islandSyncMgr:Dispose()

		arg0_64.islandSyncMgr = nil
	end

	if arg0_64.strollAllocator then
		arg0_64.strollAllocator:Dispose()

		arg0_64.strollAllocator = nil
	end

	if arg0_64.visibilityAllocator then
		arg0_64.visibilityAllocator:Dispose()

		arg0_64.visibilityAllocator = nil
	end

	if arg0_64.giftAllocator then
		arg0_64.giftAllocator:Dispose()

		arg0_64.giftAllocator = nil
	end

	if arg0_64.timeDelayCreate then
		arg0_64.timeDelayCreate:Dispose()

		arg0_64.timeDelayCreate = nil
	end

	if arg0_64.activityNpcAllocator then
		arg0_64.activityNpcAllocator:Dispose()

		arg0_64.activityNpcAllocator = nil
	end

	arg0_64.__debouncers = nil
end

function var0_0.OnAnimalInit(arg0_65, arg1_65)
	local var0_65

	for iter0_65, iter1_65 in ipairs(arg0_65.sceneData.productSystems) do
		if iter1_65.id == IslandProductConst.PasturePlaceId then
			var0_65 = iter1_65

			break
		end
	end

	if not var0_65 then
		return
	end

	local var1_65 = arg1_65.slotId

	for iter2_65, iter3_65 in ipairs(arg1_65.aniList) do
		local var2_65 = var0_65:GenAnimalByAnialConfig(iter3_65, var1_65)

		arg0_65:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_65)
	end
end

function var0_0.OnSlotDelegateInit(arg0_66, arg1_66)
	local var0_66 = arg1_66.slotId
	local var1_66 = pg.island_production_slot[var0_66].place
	local var2_66

	for iter0_66, iter1_66 in ipairs(arg0_66.sceneData.productSystems) do
		if iter1_66.id == var1_66 then
			var2_66 = iter1_66

			break
		end
	end

	if not var2_66 then
		return
	end

	local var3_66 = var2_66:GetCommissionSlotId(var0_66)
	local var4_66 = pg.island_production_commission[var3_66].unlockObjid

	if var4_66 ~= 0 then
		arg0_66:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_66)
	end
end

function var0_0.IsPlayerInTimeline(arg0_67)
	return arg0_67.islandSyncMgr.player:InTimeline()
end

function var0_0.InitSyncMgr(arg0_68)
	arg0_68.islandSyncMgr:Init(arg0_68.sceneData.unitList)
end

function var0_0.SetVisitorSyncData(arg0_69, arg1_69, arg2_69)
	arg0_69:NotifiyCore(ISLAND_EVT.SET_VISITOR_SYNC_DATA, arg1_69, arg2_69)
end

function var0_0.WorldObjectInterAction(arg0_70, arg1_70, arg2_70, arg3_70)
	arg3_70 = arg3_70 or 1

	local var0_70 = _.detect(arg0_70.sceneData.unitList, function(arg0_71)
		return arg0_71.id == arg1_70
	end)

	if not var0_70 or not var0_70:Interactable() then
		return
	end

	local var1_70 = var0_70:GetEmptySlot()

	if not var1_70 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_interact_point"))

		return
	end

	local function var2_70()
		var1_70:Lock(arg2_70)
		arg0_70:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_70, var1_70, arg3_70)
	end

	arg0_70.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_70, var1_70.id, arg3_70, function(arg0_73)
		if arg0_73 then
			var2_70()
		end
	end)
end

function var0_0.WorldObjectInterActionSync(arg0_74, arg1_74, arg2_74, arg3_74, arg4_74)
	arg3_74 = arg3_74 or 1

	local var0_74 = _.detect(arg0_74.sceneData.unitList, function(arg0_75)
		return arg0_75.id == arg1_74
	end)

	if not var0_74 or not var0_74:Interactable() then
		return
	end

	local var1_74 = var0_74:GetSlotById(arg4_74)

	var1_74:Lock(arg2_74)
	arg0_74:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_74, var1_74, arg3_74)
end

function var0_0.WorldObjectInterActionEnd(arg0_76, arg1_76, arg2_76)
	local var0_76 = _.detect(arg0_76.sceneData.unitList, function(arg0_77)
		return arg0_77.id == arg1_76
	end)

	if not var0_76 or not var0_76:Interactable() then
		return
	end

	local var1_76 = var0_76:GetUsingSlot(arg2_76)

	local function var2_76()
		local var0_78 = Clone(var1_76)

		var1_76:Release()
		arg0_76:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_76, var0_78)
	end

	arg0_76.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_76, var1_76.id, function(arg0_79)
		if arg0_79 then
			var2_76()
		end
	end)
end

function var0_0.WorldObjectInterActionEndSync(arg0_80, arg1_80, arg2_80)
	local var0_80 = _.detect(arg0_80.sceneData.unitList, function(arg0_81)
		return arg0_81.id == arg1_80
	end)

	if not var0_80 or not var0_80:Interactable() then
		return
	end

	local var1_80 = var0_80:GetUsingSlot(arg2_80)
	local var2_80 = Clone(var1_80)

	var1_80:Release()
	arg0_80:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_80, var2_80)
end

function var0_0.WorldObjectInitStatus(arg0_82, arg1_82, arg2_82)
	local var0_82 = _.detect(arg0_82.sceneData.unitList, function(arg0_83)
		return arg0_83.id == arg1_82
	end)

	warning("init", arg1_82, arg2_82, var0_82)

	if not var0_82 or not var0_82:Interactable() then
		return
	end

	arg0_82:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_82, arg2_82)
end

function var0_0.OnOpenRestaurant(arg0_84, arg1_84)
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

	local var3_84 = var2_84:GetUnits(var1_84)

	for iter2_84, iter3_84 in ipairs(var3_84) do
		arg0_84:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_84)
	end

	arg0_84:NotifiyCore(ISLAND_EVT.START_MANAGE, var2_84)
end

function var0_0.OnCloseRestaurant(arg0_85, arg1_85)
	local var0_85 = arg1_85.restId
	local var1_85 = arg1_85.postList
	local var2_85

	for iter0_85, iter1_85 in ipairs(arg0_85.sceneData.systemList) do
		if isa(iter1_85, IslandManageSystemVO) and iter1_85.id == var0_85 then
			var2_85 = iter1_85

			break
		end
	end

	if not var2_85 then
		return
	end

	arg0_85:NotifiyCore(ISLAND_EVT.END_MANAGE, var2_85)

	local var3_85 = var2_85:GetUnits(var1_85)

	for iter2_85, iter3_85 in ipairs(var3_85) do
		arg0_85:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_MANAGE, iter3_85.id)
	end
end

function var0_0.OnSwitchMap(arg0_86)
	if arg0_86.islandSyncMgr and arg0_86.islandSyncMgr:IsPlayerInTimeline() then
		arg0_86:NotifiyCore(ISLAND_EVT.INIT_INTERACTION_OP_VIEW)
	end
end

return var0_0
