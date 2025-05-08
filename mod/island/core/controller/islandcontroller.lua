local var0_0 = class("IslandController", import(".IslandBaseController"))

function var0_0.Init(arg0_1)
	arg0_1.sceneData = IslandDataConvertor.Island2SceneData(arg0_1.island)
	arg0_1.mapId = arg0_1.sceneData.mapId
end

function var0_0.SetUp(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.sceneData.unitList) do
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_UNIT, iter1_2)
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.sceneData.systemList) do
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_SYSTEM, iter3_2)
	end

	for iter4_2, iter5_2 in ipairs(arg0_2.sceneData.systemUnits) do
		arg0_2:NotifiyCore(ISLAND_EVT.GEN_SYSTEM_UNIT, iter5_2)
	end

	arg0_2.playerInputManager = PlayerInputManager.New(arg0_2)
	arg0_2.islandSyncMgr = IslandSyncMgr.New(arg0_2)
end

function var0_0.OnCoreInitFinish(arg0_3)
	arg0_3:NotifiyCore(ISLAND_EVT.INIT_FINISH)
	arg0_3:NotifiyIsland(ISLAND_EX_EVT.INIT_FINISH)
	arg0_3.islandSyncMgr:Init()
end

function var0_0.GetMapID(arg0_4)
	return arg0_4.mapId
end

function var0_0.AddListeners(arg0_5)
	arg0_5:AddIslandListener(IslandVisitorAgency.PLAYER_ADD, arg0_5.OnPlayerAdd)
	arg0_5:AddIslandListener(IslandVisitorAgency.PLAYER_EXIT, arg0_5.OnPlayerExit)
	arg0_5:AddIslandListener(IslandVisitorAgency.CHANGE_PLAYER_DRESS, arg0_5.OnPlayerChangeDress)
	arg0_5:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_5.OnSyncDataUpdate)
	arg0_5:AddIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_5.OnSyncObjUpdate)
	arg0_5:AddIslandListener(IslandBuildingAgency.SLOT_STATE_CHANGE, arg0_5.OnReGenUnit)
	arg0_5:AddIslandListener(IslandBuildingAgency.SLOT_UNIT_REMOVE, arg0_5.OnRemoveUnit)
	arg0_5:AddIslandListener(IslandStartDelegationCommand.START_DELEGATION, arg0_5.OnStartDelegation)
	arg0_5:AddIslandListener(IslandFinishDelegationCommand.END_DELEGATION, arg0_5.OnEndDelegation)
end

function var0_0.RemoveListeners(arg0_6)
	arg0_6:RemoveIslandListener(IslandVisitorAgency.PLAYER_ADD, arg0_6.OnPlayerAdd)
	arg0_6:RemoveIslandListener(IslandVisitorAgency.PLAYER_EXIT, arg0_6.OnPlayerExit)
	arg0_6:RemoveIslandListener(IslandVisitorAgency.CHANGE_PLAYER_DRESS, arg0_6.OnPlayerChangeDress)
	arg0_6:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, arg0_6.OnSyncDataUpdate)
	arg0_6:RemoveIslandListener(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_6.OnSyncObjUpdate)
	arg0_6:RemoveIslandListener(IslandBuildingAgency.SLOT_STATE_CHANGE, arg0_6.OnReGenUnit)
	arg0_6:RemoveIslandListener(IslandBuildingAgency.SLOT_UNIT_REMOVE, arg0_6.OnRemoveUnit)
	arg0_6:RemoveIslandListener(IslandStartDelegationCommand.START_DELEGATION, arg0_6.OnStartDelegation)
	arg0_6:RemoveIslandListener(IslandFinishDelegationCommand.END_DELEGATION, arg0_6.OnEndDelegation)
end

function var0_0.OnPlayerAdd(arg0_7, arg1_7)
	local var0_7 = IslandDataConvertor.PlayerData2IslandUnit(arg1_7.player, arg0_7.mapId)

	arg0_7:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_7)
end

function var0_0.OnPlayerExit(arg0_8, arg1_8)
	arg0_8:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, arg1_8.id)
end

function var0_0.OnPlayerChangeDress(arg0_9, arg1_9)
	arg0_9:NotifiyCore(ISLAND_EVT.CHANGE_DRESS, arg1_9)
end

function var0_0.OnReGenUnit(arg0_10, arg1_10)
	assert(arg1_10.unitId and arg1_10.modelId)

	local var0_10 = IslandDataConvertor.ModelId2IslandUnit(arg1_10.unitId, arg1_10.modelId, arg0_10.mapId)

	assert(var0_10)

	if var0_10 then
		arg0_10:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_10)
	end
end

function var0_0.OnRemoveUnit(arg0_11, arg1_11)
	assert(arg1_11.unitId)
	arg0_11:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, arg1_11.unitId)
end

function var0_0.OnSyncInteraction(arg0_12, arg1_12, arg2_12)
	arg0_12.islandSyncMgr:TryControlUnitInteraction(arg1_12, arg2_12)
end

function var0_0.OnSyncDataUpdate(arg0_13, arg1_13)
	arg0_13.islandSyncMgr:HandleSyncData(arg1_13)
end

function var0_0.OnSyncObjUpdate(arg0_14, arg1_14)
	arg0_14.islandSyncMgr:HandleSyncObj(arg1_14)
end

function var0_0.Update(arg0_15)
	arg0_15.playerInputManager:Update()
	arg0_15.islandSyncMgr:Update()
end

function var0_0.OnDispose(arg0_16)
	if arg0_16.playerInputManager then
		arg0_16.playerInputManager:Dispose()

		arg0_16.playerInputManager = nil
	end

	if arg0_16.islandSyncMgr then
		arg0_16.islandSyncMgr:Dispose()

		arg0_16.islandSyncMgr = nil
	end
end

function var0_0.OnStartDelegation(arg0_17, arg1_17)
	local var0_17

	for iter0_17, iter1_17 in ipairs(arg0_17.sceneData.systemList) do
		if iter1_17.id == arg1_17.build_id then
			var0_17 = iter1_17

			break
		end
	end

	if not var0_17 then
		return
	end

	local var1_17 = var0_17:GetUnit(arg1_17.ship_id, arg1_17.area_id, true)

	if var1_17 then
		arg0_17:NotifiyCore(ISLAND_EVT.GEN_SYSTEM_UNIT, var1_17)
	end

	arg0_17:NotifiyCore(ISLAND_EVT.START_DEGATION, arg1_17)
end

function var0_0.OnEndDelegation(arg0_18, arg1_18)
	local var0_18

	for iter0_18, iter1_18 in ipairs(arg0_18.sceneData.systemList) do
		if iter1_18.id == arg1_18.build_id then
			var0_18 = iter1_18

			break
		end
	end

	if not var0_18 then
		return
	end

	local var1_18 = var0_18:GetUnit(arg1_18.ship_id, arg1_18.area_id, true)

	if var1_18 then
		arg0_18:NotifiyCore(ISLAND_EVT.REMOVE_SYSTEM_UNIT, var1_18.id)
	end

	arg0_18:NotifiyCore(ISLAND_EVT.END_DEGATION, arg1_18)
end

return var0_0
