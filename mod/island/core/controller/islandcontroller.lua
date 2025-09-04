local var0_0 = class("IslandController", import(".IslandBaseController"))

function var0_0.Init(arg0_1)
	arg0_1.sceneData = IslandDataConvertor.Island2SceneData(arg0_1.island)
	arg0_1.mapId = arg0_1.sceneData.mapId
end

function var0_0.SetUp(arg0_2)
	arg0_2.strollAllocator = IslandStrollAllocator.New(arg0_2)
	arg0_2.visibilityAllocator = IslandVisibilityAllocator.New(arg0_2)
	arg0_2.giftAllocator = IslandGiftAllocator.New(arg0_2)
	arg0_2.playerInputManager = PlayerInputManager.New(arg0_2)
	arg0_2.islandSyncMgr = IslandSyncMgr.New(arg0_2)

	for iter0_2, iter1_2 in ipairs(arg0_2.sceneData.unitList) do
		if arg0_2.visibilityAllocator:IsVisible(iter1_2.id) then
			arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter1_2)
		end
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.sceneData.giftUnits) do
		if arg0_2.giftAllocator:IsVisible(iter2_2) then
			arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_2)
		end
	end

	for iter4_2, iter5_2 in ipairs(arg0_2.sceneData.systemList) do
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_SYSTEM, iter5_2)
	end

	for iter6_2, iter7_2 in ipairs(arg0_2.sceneData.systemUnits) do
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter7_2)
	end

	for iter8_2, iter9_2 in ipairs(arg0_2.sceneData.strollUnits) do
		local var0_2, var1_2 = arg0_2.strollAllocator:Allocator(iter9_2:GetDefaultPathId(arg0_2.mapId))

		iter9_2:SetPath(var0_2, var1_2)
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter9_2)
	end
end

function var0_0.ResetPlayerPosition(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.sceneData.unitList) do
		if iter1_3:IsPlayer() then
			arg0_3:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, iter1_3.id, iter1_3.position)
		end
	end
end

function var0_0.OnCoreInitFinish(arg0_4)
	arg0_4:NotifiyCore(ISLAND_EVT.INIT_FINISH, arg0_4.sceneData.camreaZoomData)
	arg0_4:NotifiyIsland(ISLAND_EX_EVT.INIT_FINISH)
	arg0_4.playerInputManager:Init()
	arg0_4:InitSyncMgr()
end

function var0_0.InitSyncMgr(arg0_5)
	arg0_5.islandSyncMgr:Init(arg0_5.sceneData.unitList)
end

function var0_0.GetMapID(arg0_6)
	return arg0_6.mapId
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_7.OnPlayerAdd)
	arg0_7:AddIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_7.OnPlayerExit)
	arg0_7:AddIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_7.OnPlayerChangeDress)
	arg0_7:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_7.OnSyncDataUpdate)
	arg0_7:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_7.OnSyncObjUpdate)
	arg0_7:AddIslandListener(IslandBuildingAgency.SlOT_UNIT_INIT, arg0_7.OnInitSlotUnit)
	arg0_7:AddIslandListener(IslandBuildingAgency.SLOT_UNIT_REMOVE, arg0_7.OnRemoveSlotUnit)
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
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveIslandListener(IslandVisitorAgency.VISITOR_ADD, arg0_8.OnPlayerAdd)
	arg0_8:RemoveIslandListener(IslandVisitorAgency.VISITOR_EXIT, arg0_8.OnPlayerExit)
	arg0_8:RemoveIslandListener(IslandDressUpAgency.CHANGE_PLAYER_DRESS, arg0_8.OnPlayerChangeDress)
	arg0_8:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_8.OnSyncDataUpdate)
	arg0_8:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_8.OnSyncObjUpdate)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.SlOT_UNIT_INIT, arg0_8.OnInitSlotUnit)
	arg0_8:RemoveIslandListener(IslandBuildingAgency.SLOT_UNIT_REMOVE, arg0_8.OnRemoveSlotUnit)
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
end

function var0_0.OnLinkCore(arg0_9, arg1_9, ...)
	arg0_9:NotifiyCore(arg1_9, ...)
end

function var0_0.OnActiveOrDisableUnit(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10:NotifiyCore(ISLAND_EVT.ACTIVE_OR_DISACTIVE_UNIT, arg1_10, arg2_10, arg3_10)
end

function var0_0.OnStartPathFinder(arg0_11, arg1_11)
	arg0_11:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, arg1_11)
end

function var0_0.OnEndPathFinder(arg0_12)
	arg0_12.visibilityAllocator:Flush()
end

function var0_0.OnStartPerformance(arg0_13)
	arg0_13:NotifiyCore(ISLAND_EVT.START_STORY)
	arg0_13:NotifiyCore(ISLAND_EVT.START_PERFORMANCE)
end

function var0_0.OnEndPerformance(arg0_14)
	arg0_14:NotifiyCore(ISLAND_EVT.END_STORY)
	arg0_14:NotifiyCore(ISLAND_EVT.END_PERFORMANCE)
end

function var0_0.OnStartStory(arg0_15)
	arg0_15:NotifiyCore(ISLAND_EVT.START_STORY)
end

function var0_0.OnEndStory(arg0_16)
	arg0_16:NotifiyCore(ISLAND_EVT.END_STORY)
	arg0_16.visibilityAllocator:Flush()
end

function var0_0.OnTaskAdd(arg0_17)
	arg0_17.visibilityAllocator:Flush()
	arg0_17:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_17:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnFinishTask(arg0_18)
	arg0_18.visibilityAllocator:Flush()
	arg0_18:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_18:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnUpdateTask(arg0_19)
	arg0_19.visibilityAllocator:Flush()
	arg0_19:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_19:NotifiyCore(ISLAND_EVT.REFRESH_TASK_HUD_INFO)
end

function var0_0.OnPlayerAdd(arg0_20, arg1_20)
	local var0_20 = IslandDataConvertor.PlayerData2IslandUnit(arg1_20.player, arg0_20.mapId)

	arg0_20:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_20, function(arg0_21)
		arg0_20.islandSyncMgr:OnVisitorEnter(arg1_20.player.id, arg0_21)
	end)
end

function var0_0.OnPlayerExit(arg0_22, arg1_22)
	arg0_22:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_22.id)
	arg0_22.islandSyncMgr:OnVisitorExit(arg1_22.id)
end

function var0_0.OnPlayerChangeDress(arg0_23, arg1_23, arg2_23)
	arg0_23:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_23, arg2_23)
end

function var0_0.OnStartPlant(arg0_24, arg1_24)
	local var0_24

	for iter0_24, iter1_24 in ipairs(arg0_24.sceneData.productSystems) do
		if iter1_24.id == arg1_24.build_id then
			var0_24 = iter1_24

			break
		end
	end

	if not var0_24 then
		return
	end

	local var1_24 = var0_24:GetUnitIdBySlotId(arg1_24.area_id)

	arg0_24:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_24)

	local var2_24 = var0_24:GenHandPlantUnitBySlotData(arg1_24.area_id, arg1_24.formula_id)

	arg0_24:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_24)
	arg0_24:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_24)
end

function var0_0.OnStartHandCollect(arg0_25, arg1_25)
	local var0_25

	for iter0_25, iter1_25 in ipairs(arg0_25.sceneData.productSystems) do
		if iter1_25.id == arg1_25.build_id then
			var0_25 = iter1_25

			break
		end
	end

	if not var0_25 then
		return
	end

	local var1_25 = var0_25:GetUnitIdBySlotId(arg1_25.area_id)

	arg0_25:NotifiyCore(ISLAND_EVT.UPDATE_UNIT_HP, var1_25)
	arg0_25:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_25)
end

function var0_0.OnEndPlant(arg0_26, arg1_26)
	local var0_26

	for iter0_26, iter1_26 in ipairs(arg0_26.sceneData.productSystems) do
		if iter1_26.id == arg1_26.build_id then
			var0_26 = iter1_26

			break
		end
	end

	if not var0_26 then
		return
	end

	local var1_26 = var0_26:GetUnitIdBySlotId(arg1_26.area_id)

	arg0_26:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_26)

	local var2_26 = var0_26:GenHandPlantUnitBySlotData(arg1_26.area_id)

	arg0_26:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_26)
	arg0_26:NotifiyCore(ISLAND_EVT.UPDATE_HUD, var1_26)
end

function var0_0.OnHandPlantSlotChangeUnit(arg0_27, arg1_27)
	local var0_27

	for iter0_27, iter1_27 in ipairs(arg0_27.sceneData.productSystems) do
		if iter1_27.id == arg1_27.build_id then
			var0_27 = iter1_27

			break
		end
	end

	if not var0_27 then
		return
	end

	local var1_27 = var0_27:GetUnitIdBySlotId(arg1_27.slotId)

	arg0_27:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var1_27)

	local var2_27 = var0_27:GenHandPlantUnitBySlotData(arg1_27.slotId)

	arg0_27:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_27)
end

function var0_0.OnRemoveWildGatherDone(arg0_28, arg1_28)
	arg0_28:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_28.unitId)
	arg0_28:NotifiyCore(ISLAND_EVT.LEAVE_UNIT, {
		id = arg1_28.unitId
	})
end

function var0_0.OnAddWildGatherDone(arg0_29, arg1_29)
	arg0_29:NotifiyCore(ISLAND_EVT.GEN_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_29.unitId)
end

function var0_0.OnInitSlotUnit(arg0_30, arg1_30)
	assert(arg1_30.unitId and arg1_30.modelId)

	local var0_30

	for iter0_30, iter1_30 in ipairs(arg0_30.sceneData.productSystems) do
		if iter1_30.id == arg1_30.build_id then
			var0_30 = iter1_30

			break
		end
	end

	if not var0_30 then
		return
	end

	local var1_30 = pg.island_world_objects[arg1_30.unitId] or {}
	local var2_30 = {
		unitId = arg1_30.modelId,
		typ = arg1_30.unitType,
		formula_id = arg1_30.fammulaId,
		slotId = arg1_30.slotId,
		slotType = IslandProductSystemVO.SlotType.HandCollect
	}
	local var3_30 = var0_30:ProductSlotObj2IslandUnit(var1_30, var2_30)

	if var3_30 then
		arg0_30:NotifiyCore(ISLAND_EVT.GEN_UNIT, var3_30)
	end
end

function var0_0.OnRemoveSlotUnit(arg0_31, arg1_31)
	assert(arg1_31.unitId)
	arg0_31:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_31.unitId)
end

function var0_0.OnSyncDataUpdate(arg0_32, arg1_32)
	arg0_32.islandSyncMgr:HandleSyncData(arg1_32)
end

function var0_0.OnSyncObjUpdate(arg0_33, arg1_33)
	arg0_33.islandSyncMgr:HandleSyncObj(arg1_33)
end

function var0_0.Update(arg0_34)
	arg0_34.playerInputManager:Update()
	arg0_34.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_35)
	if arg0_35.playerInputManager then
		arg0_35.playerInputManager:Dispose()

		arg0_35.playerInputManager = nil
	end

	if arg0_35.islandSyncMgr then
		arg0_35.islandSyncMgr:Dispose()

		arg0_35.islandSyncMgr = nil
	end

	if arg0_35.strollAllocator then
		arg0_35.strollAllocator:Dispose()

		arg0_35.strollAllocator = nil
	end

	if arg0_35.visibilityAllocator then
		arg0_35.visibilityAllocator:Dispose()

		arg0_35.visibilityAllocator = nil
	end

	if arg0_35.giftAllocator then
		arg0_35.giftAllocator:Dispose()

		arg0_35.giftAllocator = nil
	end
end

function var0_0.OnStartDelegation(arg0_36, arg1_36)
	local var0_36

	for iter0_36, iter1_36 in ipairs(arg0_36.sceneData.systemList) do
		if isa(iter1_36, IslandCharacterSystemVO) and iter1_36.id == arg1_36.build_id then
			var0_36 = iter1_36

			break
		end
	end

	if not var0_36 then
		return
	end

	local var1_36

	for iter2_36, iter3_36 in ipairs(arg0_36.sceneData.productSystems) do
		if iter3_36.id == arg1_36.build_id then
			var1_36 = iter3_36

			break
		end
	end

	if arg1_36.build_id == IslandProductSystemVO.FarmlandPlaceId then
		local var2_36 = pg.island_production_slot[arg1_36.area_id]

		for iter4_36, iter5_36 in ipairs(var2_36.exclusion_slot) do
			local var3_36 = var1_36:GetUnitIdBySlotId(iter5_36)
			local var4_36 = var1_36:GetUnitVOByUnitId(var3_36)

			if var4_36 then
				var4_36:ChangeSlotType(IslandProductSystemVO.SlotType.RoleDelegation)
			end
		end
	end

	local var5_36 = var0_36:GetUnit(arg1_36.ship_id, arg1_36.area_id, true)

	if var5_36 then
		arg0_36:NotifiyCore(ISLAND_EVT.GEN_UNIT, var5_36)
	end

	arg0_36:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_36, var1_36)
end

function var0_0.OnEndDelegation(arg0_37, arg1_37)
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

	arg0_37:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_37)

	local var1_37 = var0_37:GetUnit(arg1_37.ship_id, arg1_37.area_id, true)

	if var1_37 then
		arg0_37:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELEGATION, var1_37.id)
	end

	if arg1_37.remainReward then
		return
	end

	local var2_37

	for iter2_37, iter3_37 in ipairs(arg0_37.sceneData.productSystems) do
		if iter3_37.id == arg1_37.build_id then
			var2_37 = iter3_37

			break
		end
	end

	if arg1_37.build_id == IslandProductSystemVO.FarmlandPlaceId then
		local var3_37 = pg.island_production_slot[arg1_37.area_id]

		for iter4_37, iter5_37 in ipairs(var3_37.exclusion_slot) do
			local var4_37 = var2_37:GetUnitIdBySlotId(iter5_37)

			arg0_37:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var4_37)

			local var5_37 = var2_37:GenHandPlantUnitBySlotData(iter5_37)

			arg0_37:NotifiyCore(ISLAND_EVT.GEN_UNIT, var5_37)
		end
	end
end

function var0_0.OnGetAllDelegationAward(arg0_38, arg1_38)
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

	local var1_38

	for iter2_38, iter3_38 in ipairs(arg0_38.sceneData.productSystems) do
		if iter3_38.id == arg1_38.build_id then
			var1_38 = iter3_38

			break
		end
	end

	if arg1_38.build_id == IslandProductSystemVO.FarmlandPlaceId then
		local var2_38 = pg.island_production_slot[arg1_38.area_id]

		for iter4_38, iter5_38 in ipairs(var2_38.exclusion_slot) do
			local var3_38 = var1_38:GetUnitIdBySlotId(iter5_38)

			arg0_38:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var3_38)

			local var4_38 = var1_38:GenHandPlantUnitBySlotData(iter5_38)

			arg0_38:NotifiyCore(ISLAND_EVT.GEN_UNIT, var4_38)
		end
	end
end

function var0_0.OnChangeSlotModel(arg0_39, arg1_39)
	local var0_39

	for iter0_39, iter1_39 in ipairs(arg0_39.sceneData.productSystems) do
		if iter1_39.id == IslandProductSystemVO.FarmlandPlaceId then
			var0_39 = iter1_39

			break
		end
	end

	if not var0_39 then
		return
	end

	arg0_39:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, arg1_39.id)

	local var1_39 = var0_39:GetUnitVOByUnitId(arg1_39.id)

	var1_39.modelId = arg1_39.modelId

	arg0_39:NotifiyCore(ISLAND_EVT.GEN_UNIT, var1_39)
end

function var0_0.OnAnimalInit(arg0_40, arg1_40)
	local var0_40

	for iter0_40, iter1_40 in ipairs(arg0_40.sceneData.productSystems) do
		if iter1_40.id == IslandProductSystemVO.PasturePlaceId then
			var0_40 = iter1_40

			break
		end
	end

	if not var0_40 then
		return
	end

	local var1_40 = arg1_40.slotId

	for iter2_40, iter3_40 in ipairs(arg1_40.aniList) do
		local var2_40 = var0_40:GenAnimalByAnialConfig(iter3_40, var1_40)

		arg0_40:NotifiyCore(ISLAND_EVT.GEN_UNIT, var2_40)
	end
end

function var0_0.WorldObjectInterAction(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	arg3_41 = arg3_41 or 1

	local var0_41 = _.detect(arg0_41.sceneData.unitList, function(arg0_42)
		return arg0_42.id == arg1_41
	end)

	if not var0_41 or not var0_41:Interactable() then
		return
	end

	local var1_41 = var0_41:GetEmptySlot()

	if not var1_41 then
		return
	end

	local function var2_41()
		var1_41:Lock(arg2_41)
		arg0_41:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_START_INTERACTION, var0_41, var1_41, arg3_41)
	end

	if arg4_41 then
		var2_41()
	else
		arg0_41.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_41, var1_41.id, arg3_41, function(arg0_44)
			if arg0_44 then
				var2_41()
			end
		end)
	end
end

function var0_0.WorldObjectInterActionEnd(arg0_45, arg1_45, arg2_45, arg3_45)
	local var0_45 = _.detect(arg0_45.sceneData.unitList, function(arg0_46)
		return arg0_46.id == arg1_45
	end)

	if not var0_45 or not var0_45:Interactable() then
		return
	end

	local var1_45 = var0_45:GetUsingSlot(arg2_45)

	if not var1_45 then
		return
	end

	local function var2_45()
		local var0_47 = Clone(var1_45)

		var1_45:Release()
		arg0_45:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_END_INTERACTION, var0_45, var0_47)
	end

	if arg3_45 then
		var2_45()
	else
		arg0_45.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_UNIT_STATIC, arg1_45, var1_45.id, function(arg0_48)
			if arg0_48 then
				var2_45()
			end
		end)
	end
end

function var0_0.WorldObjectInitStatus(arg0_49, arg1_49, arg2_49)
	local var0_49 = _.detect(arg0_49.sceneData.unitList, function(arg0_50)
		return arg0_50.id == arg1_49
	end)

	warning("init", arg1_49, arg2_49, var0_49)

	if not var0_49 or not var0_49:Interactable() then
		return
	end

	arg0_49:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_49, arg2_49)
end

function var0_0.OnOpenRestaurant(arg0_51, arg1_51)
	local var0_51 = arg1_51.restId
	local var1_51 = arg1_51.postList
	local var2_51

	for iter0_51, iter1_51 in ipairs(arg0_51.sceneData.systemList) do
		if isa(iter1_51, IslandManageSystemVO) and iter1_51.id == var0_51 then
			var2_51 = iter1_51

			break
		end
	end

	if not var2_51 then
		return
	end

	local var3_51 = var2_51:GetUnits(var1_51)

	for iter2_51, iter3_51 in ipairs(var3_51) do
		arg0_51:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter3_51)
	end

	arg0_51:NotifiyCore(ISLAND_EVT.START_MANAGE, var2_51)
end

function var0_0.OnCloseRestaurant(arg0_52, arg1_52)
	local var0_52 = arg1_52.restId
	local var1_52 = arg1_52.postList
	local var2_52

	for iter0_52, iter1_52 in ipairs(arg0_52.sceneData.systemList) do
		if isa(iter1_52, IslandManageSystemVO) and iter1_52.id == var0_52 then
			var2_52 = iter1_52

			break
		end
	end

	if not var2_52 then
		return
	end

	arg0_52:NotifiyCore(ISLAND_EVT.END_MANAGE, var2_52)

	local var3_52 = var2_52:GetUnits(var1_52)

	for iter2_52, iter3_52 in ipairs(var3_52) do
		arg0_52:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_MANAGE, iter3_52.id)
	end
end

return var0_0
