local var0_0 = class("IslandDataConvertor")

function var0_0.Island2SceneData(arg0_1)
	local var0_1 = arg0_1:GetMapId()
	local var1_1 = arg0_1:GetSpawnPointId()
	local var2_1 = arg0_1:GetLastExitPosition()
	local var3_1 = arg0_1:GetVisitorAgency():GetMapVisitorList()
	local var4_1 = pg.island_map[var0_1]
	local var5_1 = {}
	local var6_1 = {}
	local var7_1 = {}
	local var8_1 = {}
	local var9_1 = {}
	local var10_1 = {}

	var0_0.SceneData2IslandUnits(var5_1, var3_1, var0_1, var1_1, var2_1)
	var0_0.SystemData2IslandUnits(var5_1, var10_1, arg0_1, var0_1, var9_1)
	var0_0.CollectSystems(var6_1, var7_1, arg0_1, var0_1, var9_1)
	var0_0.CollectStrollUnits(var8_1, arg0_1, var0_1)

	local var11_1 = var0_0.CollectCamreaZoomData(var0_1)

	return {
		mapId = var0_1,
		unitList = var5_1,
		sceneName = var4_1.sceneName,
		systemList = var6_1,
		systemUnits = var7_1,
		strollUnits = var8_1,
		productSystems = var9_1,
		giftUnits = var10_1,
		camreaZoomData = var11_1
	}
end

function var0_0.Island2SceneName(arg0_2)
	local var0_2 = arg0_2:GetMapId()
	local var1_2 = pg.island_map[var0_2]

	return var1_2.sceneName, var0_2, var1_2.default_bgm
end

function var0_0.CollectCamreaZoomData(arg0_3)
	local var0_3 = pg.island_map[arg0_3].camera_zoom
	local var1_3 = var0_3[1]
	local var2_3 = var0_3[2]
	local var3_3 = var0_3[3] or 0.5

	return {
		min = var1_3,
		max = var2_3,
		value = var3_3
	}
end

function var0_0.SystemData2IslandUnits(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	var0_0.CollectSignInSystemUnits(arg0_4, arg1_4, arg2_4, arg3_4)
	var0_0.CollectWildCollectInSystemUnits(arg0_4, arg1_4, arg2_4, arg3_4)
	var0_0.CollectBuildingSystemUnits(arg0_4, arg2_4, arg3_4, arg4_4)

	if arg2_4:IsPrivate() then
		var0_0.CollectOrderSystemUnits(arg0_4, arg2_4, arg3_4)
	end
end

function var0_0.CollectBuildingSystemUnits(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg1_5:GetBuildingAgency()
	local var1_5 = pg.island_production_place.get_id_list_by_map_id[arg2_5] or {}

	for iter0_5, iter1_5 in ipairs(var1_5) do
		if arg2_5 == pg.island_production_place[iter1_5].map_id then
			local var2_5 = var0_5:GetBuilding(iter1_5)
			local var3_5 = IslandProductSystemVO.New(iter1_5, var2_5, arg1_5.id)

			for iter2_5, iter3_5 in ipairs(var3_5:GetUnitDatas()) do
				if iter3_5 then
					table.insert(arg0_5, iter3_5)
				end
			end

			table.insert(arg3_5, var3_5)
		end
	end
end

function var0_0.CollectOrderSystemUnits(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetOrderAgency():GetShipSlotList()

	for iter0_6, iter1_6 in pairs(var0_6) do
		if not iter1_6:IsLock() and iter1_6:GetWorldObjId() > 0 then
			local var1_6 = pg.island_world_objects[iter1_6:GetWorldObjId()]

			if var1_6 and var1_6.mapId == arg2_6 then
				local var2_6 = {}
				local var3_6 = var0_0.WorldObj2IslandUnit(var1_6, var2_6)

				table.insert(arg0_6, var3_6)
			end
		end
	end
end

function var0_0.CollectSignInSystemUnits(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg2_7:GetSignInAgency()
	local var1_7 = pg.island_world_objects.get_id_list_by_mapId[arg3_7] or {}
	local var2_7 = 0

	for iter0_7, iter1_7 in ipairs(var1_7) do
		local var3_7 = pg.island_world_objects[iter1_7]

		if var3_7.unitId > 0 and var3_7.gen_type == IslandConst.UNIT_GEN_TYPE_GIFT then
			var2_7 = var2_7 + 1

			local var4_7 = var0_0.WorldObj2IslandUnit(var3_7, {
				index = var2_7
			})

			table.insert(arg1_7, var4_7)
		end
	end
end

function var0_0.CollectWildCollectInSystemUnits(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg2_8:GetWildCollectAgency():GetUnitList()

	for iter0_8, iter1_8 in ipairs(var0_8) do
		local var1_8 = pg.island_world_objects[iter1_8.unitId]

		if var1_8.unitId > 0 then
			local var2_8 = var0_0.WorldObj2IslandUnit(var1_8, {
				index = arg2_8.id,
				typ = iter1_8.gatherType
			})

			table.insert(arg0_8, var2_8)
		end
	end
end

function var0_0.CollectStrollUnits(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9:GetAblityAgency()
	local var1_9 = arg1_9:GetCharacterAgency():GetShips()

	local function var2_9(arg0_10, arg1_10)
		if arg0_10 == -1 then
			local var0_10 = _.detect(var1_9, function(arg0_11)
				return arg0_11:getConfig("unit_id") == arg1_10
			end)

			return var0_10 ~= nil, var0_10 and var0_10:GetModelUnit()
		else
			return arg0_10 == 0 or var0_9:HasAbility(arg0_10), nil
		end
	end

	for iter0_9, iter1_9 in ipairs(pg.island_strollnpc.all) do
		local var3_9 = pg.island_strollnpc[iter1_9]

		if _.any(var3_9.mapId, function(arg0_12)
			return arg0_12[1] == arg2_9
		end) then
			local var4_9, var5_9 = var2_9(var3_9.unlock, var3_9.unit_id)

			if var4_9 then
				table.insert(arg0_9, IslandStrollUnitVO.New(iter1_9, var5_9))
			end
		end
	end
end

function var0_0.CollectSystems(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = pg.island_production_place.get_id_list_by_map_id[arg3_13] or {}
	local var1_13 = arg2_13:GetBuildingAgency()

	local function var2_13(arg0_14)
		local var0_14

		for iter0_14, iter1_14 in ipairs(arg4_13) do
			if iter1_14.id == arg0_14 then
				var0_14 = iter1_14
			end
		end

		return var0_14
	end

	local var3_13 = {
		IslandProductSystemVO.PasturePlaceId,
		IslandProductSystemVO.FarmlandPlaceId
	}

	for iter0_13, iter1_13 in ipairs(var0_13) do
		local var4_13 = var2_13(iter1_13)
		local var5_13 = IslandCharacterSystemVO.New(iter1_13, var4_13, arg2_13.id)
		local var6_13 = var1_13:GetBuilding(iter1_13)
		local var7_13 = 0

		if var6_13 then
			local var8_13 = var6_13:GetShipIdAndAreaIdList()

			for iter2_13, iter3_13 in ipairs(var8_13) do
				local var9_13 = var5_13:GetUnit(iter3_13.ship_id, iter3_13.area_id, table.contains(var3_13, iter1_13))

				table.insert(arg1_13, var9_13)

				var7_13 = var7_13 + 1
			end

			var5_13:SetkCurrentWorkerList(var8_13)
		end

		var5_13:SetWorkerCnt(var7_13)
		table.insert(arg0_13, var5_13)
	end

	local var10_13 = pg.island_map[arg3_13]

	if var10_13.minigame_id > 0 then
		table.insert(arg0_13, IslandSeekGameSystemVO.New(var10_13.minigame_id, IslandConst.SEEK_GAME_SYSTEM_ID))
	elseif arg3_13 == IslandConst.AGORA_MAP_ID then
		table.insert(arg0_13, IslandGroundSystemVO.New(IslandConst.AGORA_GROUND_SYSTEM_ID))
	end

	local var11_13 = arg2_13:GetManageAgency():GetRestaurants()

	for iter4_13, iter5_13 in pairs(var11_13) do
		if iter5_13:getConfig("map_id") == arg3_13 then
			local var12_13 = IslandManageSystemVO.New(iter5_13.id, iter5_13)

			table.insert(arg0_13, var12_13)

			if iter5_13:GetStatus() == IslandRestaurant.STATUS.OPENING then
				for iter6_13, iter7_13 in ipairs(var12_13:GetUnits()) do
					table.insert(arg1_13, iter7_13)
				end
			end
		end
	end
end

function var0_0.SceneData2IslandUnits(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = pg.island_world_objects.get_id_list_by_mapId[arg2_15] or {}

	for iter0_15, iter1_15 in ipairs(var0_15) do
		local var1_15 = pg.island_world_objects[iter1_15]

		if var1_15.unitId > 0 and (var1_15.gen_type == IslandConst.UNIT_GEN_TYPE_STATIC or var1_15.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC) then
			local var2_15 = var0_0.WorldObj2IslandUnit(var1_15)

			table.insert(arg0_15, var2_15)
		end
	end

	for iter2_15, iter3_15 in pairs(arg1_15) do
		local var3_15 = var0_0.PlayerData2IslandUnit(iter3_15, arg2_15, arg3_15, arg4_15)

		table.insert(arg0_15, var3_15)
	end
end

local function var1_0(arg0_16, arg1_16, arg2_16, arg3_16)
	if arg1_16 then
		return
	end

	if arg0_16 ~= arg2_16.mapId then
		return
	end

	arg3_16.position = {
		arg2_16.position.x,
		arg2_16.position.y,
		arg2_16.position.z
	}
	arg3_16.rotation = {
		arg2_16.rotation.x,
		arg2_16.rotation.y,
		arg2_16.rotation.z
	}
end

function var0_0.PlayerData2IslandUnit(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17
	local var1_17
	local var2_17 = pg.island_world_objects.get_id_list_by_mapId[arg1_17] or {}

	for iter0_17, iter1_17 in ipairs(var2_17) do
		local var3_17 = pg.island_world_objects[iter1_17]

		if var3_17.unitId == 0 then
			var0_17 = var3_17

			break
		end
	end

	assert(var0_17)

	if arg0_17:IsSelf() then
		local var4_17 = {
			id = arg0_17.id,
			unitId = arg0_17:GetModelId(),
			typ = IslandConst.UNIT_TYPE_PLAYER
		}
		local var5_17 = arg2_17 and pg.island_world_objects[arg2_17] or var0_17

		if var5_17.mapId ~= arg1_17 then
			var5_17 = var0_17
		end

		var1_0(arg1_17, arg2_17, arg3_17, var4_17)

		var1_17 = var0_0.WorldObj2IslandUnit(var5_17, var4_17)
	else
		local var6_17 = {
			id = arg0_17.id,
			unitId = arg0_17:GetModelId(),
			typ = IslandConst.UNIT_TYPE_VISITOR
		}

		var1_17 = var0_0.WorldObj2IslandUnit(var0_17, var6_17)
	end

	return var1_17
end

function var0_0.ModelId2IslandUnit(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = pg.island_world_objects[arg0_18] or {}
	local var1_18

	if var0_18.mapId == arg2_18 then
		local var2_18 = {
			unitId = arg1_18,
			typ = arg3_18
		}

		var1_18 = var0_0.WorldObj2IslandUnit(var0_18, var2_18)
	end

	return var1_18
end

function var0_0.WorldObj2IslandUnit(arg0_19, arg1_19)
	arg1_19 = arg1_19 or {}

	local var0_19 = arg1_19.typ or arg0_19.type
	local var1_19

	if var0_19 == IslandConst.UNIT_TYPE_ITEM_INTERACT then
		var1_19 = IslandInteractUnitVO
	elseif var0_19 == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM or var0_19 == IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM then
		var1_19 = IslandGatherUnitVO
	else
		var1_19 = IslandUnitVO
	end

	return (var1_19.New({
		id = arg1_19.id or arg0_19.id,
		modelId = arg1_19.unitId or arg0_19.unitId,
		type = arg1_19.typ or arg0_19.type,
		name = arg0_19.name,
		position = arg1_19.position or arg0_19.param.position,
		rotation = arg1_19.rotation or arg0_19.param.rotation,
		scale = arg0_19.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg0_19.behaviourTree,
		genType = arg0_19.gen_type,
		showCondition = arg0_19.show_param or {},
		hideCondition = arg0_19.hide_param or {},
		index = arg1_19.index or 0
	}))
end

return var0_0
