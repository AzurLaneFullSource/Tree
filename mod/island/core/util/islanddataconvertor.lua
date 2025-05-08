local var0_0 = class("IslandDataConvertor")

function var0_0.Island2SceneData(arg0_1)
	local var0_1 = arg0_1:GetMapId()
	local var1_1 = arg0_1:GetSpawnPointId()
	local var2_1 = arg0_1:GetVisitorAgency():GetPlayerList()
	local var3_1 = pg.island_map[var0_1]
	local var4_1 = {}
	local var5_1 = {}
	local var6_1 = {}

	var0_0.SceneData2IslandUnits(var4_1, var2_1, var0_1, var1_1)
	var0_0.SystemData2IslandUnits(var4_1, arg0_1, var0_1)
	var0_0.CollectSystemData(var5_1, var6_1, arg0_1, var0_1)

	return {
		mapId = var0_1,
		unitList = var4_1,
		sceneName = var3_1.sceneName,
		systemList = var5_1,
		systemUnits = var6_1
	}
end

function var0_0.Island2SceneName(arg0_2)
	local var0_2 = arg0_2:GetMapId()

	return pg.island_map[var0_2].sceneName
end

function var0_0.SystemData2IslandUnits(arg0_3, arg1_3, arg2_3)
	var0_0.CollectBuildingSystemUnits(arg0_3, arg1_3, arg2_3)

	if arg1_3:IsPrivate() then
		var0_0.CollectOrderSystemUnits(arg0_3, arg1_3, arg2_3)
	end
end

function var0_0.CollectBuildingSystemUnits(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:GetBuildingAgency():GetBuildings()

	for iter0_4, iter1_4 in pairs(var0_4) do
		for iter2_4, iter3_4 in ipairs(iter1_4:GetSlotUnitDataByModelData()) do
			local var1_4 = iter3_4[1]
			local var2_4 = iter3_4[2]
			local var3_4 = var0_0.ModelId2IslandUnit(var1_4, var2_4, arg2_4)

			if var3_4 then
				table.insert(arg0_4, var3_4)
			end
		end
	end
end

function var0_0.CollectOrderSystemUnits(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetOrderAgency():GetShipSlotList()

	for iter0_5, iter1_5 in pairs(var0_5) do
		if not iter1_5:IsLock() and iter1_5:GetWorldObjId() > 0 then
			local var1_5 = pg.island_world_objects[iter1_5:GetWorldObjId()]

			if var1_5 and var1_5.mapId == arg2_5 then
				local var2_5 = {}
				local var3_5 = var0_0.WorldObj2IslandUnit(var1_5, var2_5)

				table.insert(arg0_5, var3_5)
			end
		end
	end
end

function var0_0.CollectSystemData(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = pg.island_production_place.get_id_list_by_map_id[arg3_6] or {}
	local var1_6 = arg2_6:GetBuildingAgency()

	for iter0_6, iter1_6 in ipairs(var0_6) do
		local var2_6 = IslandCharacterSystemVO.New(iter1_6)
		local var3_6 = var1_6:GetBuilding(iter1_6)
		local var4_6 = 0

		if var3_6 then
			local var5_6 = var3_6:GetShipIdAndAreaIdList()

			for iter2_6, iter3_6 in ipairs(var5_6) do
				local var6_6 = var2_6:GetUnit(iter3_6.ship_id, iter3_6.area_id)

				table.insert(arg1_6, var6_6)

				var4_6 = var4_6 + 1
			end
		end

		var2_6:SetkWorkerCnt(var4_6)
		table.insert(arg0_6, var2_6)
	end
end

function var0_0.SceneData2IslandUnits(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = pg.island_world_objects.get_id_list_by_mapId[arg2_7] or {}

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var1_7 = pg.island_world_objects[iter1_7]

		if var1_7.unitId > 0 and var1_7.gen_type ~= 1 then
			local var2_7 = var0_0.WorldObj2IslandUnit(var1_7)

			table.insert(arg0_7, var2_7)
		end
	end

	for iter2_7, iter3_7 in pairs(arg1_7) do
		local var3_7 = var0_0.PlayerData2IslandUnit(iter3_7, arg2_7, arg3_7)

		table.insert(arg0_7, var3_7)
	end
end

function var0_0.PlayerData2IslandUnit(arg0_8, arg1_8, arg2_8)
	local var0_8
	local var1_8
	local var2_8 = pg.island_world_objects.get_id_list_by_mapId[arg1_8] or {}

	for iter0_8, iter1_8 in ipairs(var2_8) do
		local var3_8 = pg.island_world_objects[iter1_8]

		if var3_8.unitId == 0 then
			var0_8 = var3_8

			break
		end
	end

	assert(var0_8)

	if arg0_8:IsSelf() then
		local var4_8 = {
			id = arg0_8.id,
			unitId = arg0_8:GetShipId(),
			typ = IslandConst.UNIT_TYPE_PLAYER
		}
		local var5_8 = arg2_8 and pg.island_world_objects[arg2_8] or var0_8

		var1_8 = var0_0.WorldObj2IslandUnit(var5_8, var4_8)
	else
		local var6_8 = {
			id = arg0_8.id,
			unitId = arg0_8:GetShipId(),
			typ = IslandConst.UNIT_TYPE_VISITOR
		}

		var1_8 = var0_0.WorldObj2IslandUnit(var0_8, var6_8)
	end

	return var1_8
end

function var0_0.ModelId2IslandUnit(arg0_9, arg1_9, arg2_9)
	local var0_9 = pg.island_world_objects[arg0_9] or {}
	local var1_9

	if var0_9.mapId == arg2_9 then
		local var2_9 = {
			unitId = arg1_9
		}

		var1_9 = var0_0.WorldObj2IslandUnit(var0_9, var2_9)
	end

	return var1_9
end

function var0_0.WorldObj2IslandUnit(arg0_10, arg1_10)
	arg1_10 = arg1_10 or {}

	return (IslandUnitVO.New({
		id = arg1_10.id or arg0_10.id,
		modelId = arg1_10.unitId or arg0_10.unitId,
		type = arg1_10.typ or arg0_10.type,
		name = arg0_10.name,
		position = arg0_10.param.position,
		rotation = arg0_10.param.rotation,
		scale = arg0_10.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg0_10.behaviourTree
	}))
end

return var0_0
