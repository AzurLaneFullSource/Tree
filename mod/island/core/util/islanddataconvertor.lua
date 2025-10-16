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
	local var11_1 = {}
	local var12_1 = {}
	local var13_1 = {}

	var0_0.SceneData2IslandUnits(var5_1, var13_1, var3_1, var0_1, var1_1, var2_1, arg0_1.id)
	var0_0.SystemData2IslandUnits(var5_1, var11_1, var10_1, arg0_1, var0_1, var9_1)
	var0_0.CollectSystems(var6_1, var7_1, arg0_1, var0_1, var9_1)
	var0_0.CollectStrollUnits(var8_1, arg0_1, var0_1)
	var0_0.CollectFollowUnits(var5_1, var12_1, arg0_1, var0_1)

	local var14_1 = var0_0.CollectCamreaZoomData(var0_1)

	return {
		mapId = var0_1,
		unitList = var5_1,
		sceneName = var4_1.sceneName,
		systemList = var6_1,
		systemUnits = var7_1,
		strollUnits = var8_1,
		productSystems = var9_1,
		giftUnits = var10_1,
		followUnits = var12_1,
		delayInitUnits = var11_1,
		activityUnits = var13_1,
		camreaZoomData = var14_1
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

function var0_0.SystemData2IslandUnits(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	var0_0.CollectSignInSystemUnits(arg0_4, arg2_4, arg3_4, arg4_4)
	var0_0.CollectWildCollectInSystemUnits(arg0_4, arg2_4, arg3_4, arg4_4)
	var0_0.CollectBuildingSystemUnits(arg0_4, arg1_4, arg3_4, arg4_4, arg5_4)

	if arg3_4:IsPrivate() then
		var0_0.CollectOrderSystemUnits(arg0_4, arg3_4, arg4_4)
	end
end

function var0_0.CollectBuildingSystemUnits(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = arg2_5:GetBuildingAgency()
	local var1_5 = pg.island_production_place.get_id_list_by_map_id[arg3_5] or {}

	for iter0_5, iter1_5 in ipairs(var1_5) do
		if arg3_5 == pg.island_production_place[iter1_5].map_id then
			local var2_5 = var0_5:GetBuilding(iter1_5)
			local var3_5 = IslandProductSystemVO.New(iter1_5, var2_5, arg2_5.id)

			for iter2_5, iter3_5 in ipairs(var3_5:GetUnitDatas()) do
				if iter3_5 then
					if iter3_5.delayTime then
						table.insert(arg1_5, iter3_5)
					else
						table.insert(arg0_5, iter3_5)
					end
				end
			end

			table.insert(arg4_5, var3_5)
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
			local var0_10 = arg1_9:GetFollowerAgency()
			local var1_10 = _.detect(var1_9, function(arg0_11)
				return not var0_10:Following(arg0_11.id) and arg0_11:getConfig("unit_id") == arg1_10
			end)

			return var1_10 ~= nil, var1_10 and var1_10:GetModelUnit(), var1_10 and var1_10.id
		else
			return arg0_10 == 0 or var0_9:HasAbility(arg0_10), nil, 0
		end
	end

	for iter0_9, iter1_9 in ipairs(pg.island_strollnpc.all) do
		local var3_9 = pg.island_strollnpc[iter1_9]

		if _.any(var3_9.mapId, function(arg0_12)
			return arg0_12[1] == arg2_9 and IslandCalcUtil.IsHappen(arg0_12[3] or 100)
		end) then
			local var4_9, var5_9, var6_9 = var2_9(var3_9.unlock, var3_9.unit_id)

			if var4_9 then
				table.insert(arg0_9, IslandStrollUnitVO.New(var6_9, iter1_9, var5_9))
			end
		end
	end

	var0_0.DistributeAward4StrollUnits(arg0_9, arg1_9)
end

function var0_0.DistributeAward4StrollUnits(arg0_13, arg1_13)
	if #arg0_13 > 0 and arg1_13:IsPrivate() then
		local var0_13 = arg1_13:GetNpcFeedbackAgency():GetNpcList()
		local var1_13 = pg.island_set.island_feedback_award_times.key_value_int - #var0_13
		local var2_13 = {}

		for iter0_13, iter1_13 in ipairs(arg0_13) do
			if pg.island_strollnpc[iter1_13.id].action_feedback == 1 and _.all(var0_13, function(arg0_14)
				return iter1_13.id ~= arg0_14
			end) then
				table.insert(var2_13, iter1_13)
			end
		end

		if #var2_13 <= 0 then
			return
		end

		shuffle(var2_13)

		local var3_13 = pg.island_action.get_id_list_by_type[IslandConst.ANIMATION_OP_SIGNLE]
		local var4_13 = arg1_13:GetActionAgency()
		local var5_13 = _.select(var3_13, function(arg0_15)
			return var4_13:ExistAction(arg0_15)
		end)

		if #var5_13 <= 0 then
			return
		end

		for iter2_13 = 1, var1_13 do
			local var6_13 = var2_13[iter2_13]

			if var6_13 then
				local var7_13 = var5_13[math.random(1, #var5_13)]

				var6_13:SetActionFeedback(var7_13)
			end
		end
	end
end

function var0_0.CollectFollowUnits(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16

	for iter0_16, iter1_16 in ipairs(arg0_16) do
		if iter1_16:IsPlayer() then
			var0_16 = iter1_16

			break
		end
	end

	if not var0_16 then
		return
	end

	local var1_16 = var0_16.position
	local var2_16 = var0_16.rotation
	local var3_16 = arg2_16:GetFollowerAgency()

	for iter2_16, iter3_16 in ipairs(var3_16:GetFollowers()) do
		local var4_16 = arg2_16:GetCharacterAgency():GetShipById(iter3_16)
		local var5_16 = var4_16:GetModelUnit()

		table.insert(arg1_16, IslandFollowerUnitVO.New(var4_16.id, iter3_16, var5_16, var1_16, var2_16, iter2_16 == 1))
	end
end

function var0_0.CollectSystems(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	var0_0.CollectPordunctSystem(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	var0_0.CollectManageSystem(arg0_17, arg1_17, arg2_17, arg3_17)

	local var0_17 = pg.island_map[arg3_17]

	if var0_17.minigame_id > 0 then
		table.insert(arg0_17, IslandSeekGameSystemVO.New(var0_17.minigame_id, IslandConst.SEEK_GAME_SYSTEM_ID))
	elseif arg3_17 == IslandConst.AGORA_MAP_ID then
		table.insert(arg0_17, IslandGroundSystemVO.New(IslandConst.AGORA_GROUND_SYSTEM_ID))
		table.insert(arg0_17, IslandGrassLandSystemVO.New(IslandConst.AGORA_GRASSLAND))
	end
end

function var0_0.CollectManageSystem(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg2_18:GetManageAgency():GetRestaurants()

	for iter0_18, iter1_18 in pairs(var0_18) do
		if iter1_18:getConfig("map_id") == arg3_18 then
			local var1_18 = IslandManageSystemVO.New(iter1_18.id, iter1_18)

			table.insert(arg0_18, var1_18)

			if iter1_18:GetStatus() == IslandRestaurant.STATUS.OPENING then
				for iter2_18, iter3_18 in ipairs(var1_18:GetUnits()) do
					table.insert(arg1_18, iter3_18)
				end
			end
		end
	end
end

function var0_0.CollectPordunctSystem(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19 = pg.island_production_place.get_id_list_by_map_id[arg3_19] or {}
	local var1_19 = arg2_19:GetBuildingAgency()

	local function var2_19(arg0_20)
		local var0_20

		for iter0_20, iter1_20 in ipairs(arg4_19) do
			if iter1_20.id == arg0_20 then
				var0_20 = iter1_20
			end
		end

		return var0_20
	end

	local var3_19 = {
		IslandProductConst.PasturePlaceId,
		IslandProductConst.FarmlandPlaceId,
		IslandProductConst.OrchardPlaceId,
		IslandProductConst.GardenPlaceId
	}

	for iter0_19, iter1_19 in ipairs(IslandProductConst.FactorytPlaces) do
		table.insert(var3_19, iter1_19)
	end

	for iter2_19, iter3_19 in ipairs(var0_19) do
		local var4_19 = var2_19(iter3_19)
		local var5_19 = IslandCharacterSystemVO.New(iter3_19, var4_19, arg2_19.id)
		local var6_19 = var1_19:GetBuilding(iter3_19)
		local var7_19 = 0

		if var6_19 then
			local var8_19 = var6_19:GetShipIdAndAreaIdList()

			for iter4_19, iter5_19 in ipairs(var8_19) do
				if iter3_19 ~= IslandProductConst.MinePlaceId then
					local var9_19 = var5_19:GetUnit(iter5_19.ship_id, iter5_19.area_id, table.contains(var3_19, iter3_19))

					table.insert(arg1_19, var9_19)
				end

				var7_19 = var7_19 + 1
			end

			var5_19:SetkCurrentWorkerList(var8_19)
		end

		var5_19:SetWorkerCnt(var7_19)
		table.insert(arg0_19, var5_19)
	end
end

function var0_0.SceneData2IslandUnits(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21, arg5_21, arg6_21)
	local var0_21 = pg.island_world_objects.get_id_list_by_mapId[arg3_21] or {}

	for iter0_21, iter1_21 in ipairs(var0_21) do
		local var1_21 = pg.island_world_objects[iter1_21]

		if var1_21.unitId > 0 and (var1_21.gen_type == IslandConst.UNIT_GEN_TYPE_STATIC or var1_21.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC) then
			local var2_21 = var0_0.WorldObj2IslandUnit(var1_21)

			table.insert(arg0_21, var2_21)
		elseif var1_21.unitId > 0 and var1_21.gen_type == IslandConst.UNIT_GEN_TYPE_ACTIVITY then
			local var3_21 = var0_0.WorldObj2IslandUnit(var1_21)

			table.insert(arg1_21, var3_21)
		end
	end

	for iter2_21, iter3_21 in pairs(arg2_21) do
		local var4_21 = var0_0.PlayerData2IslandUnit(iter3_21, arg3_21, arg6_21, arg4_21, arg5_21)

		table.insert(arg0_21, var4_21)
	end

	local var5_21 = var0_0.TakePhotoData2IslandUnit(2)

	table.insert(arg0_21, var5_21)

	local var6_21 = var0_0.TakePhotoData2IslandUnit(3)

	table.insert(arg0_21, var6_21)
end

local function var1_0(arg0_22, arg1_22, arg2_22, arg3_22)
	if arg1_22 then
		return
	end

	if arg0_22 ~= arg2_22.mapId then
		return
	end

	arg3_22.position = {
		arg2_22.position.x,
		arg2_22.position.y,
		arg2_22.position.z
	}
	arg3_22.rotation = {
		arg2_22.rotation.x,
		arg2_22.rotation.y,
		arg2_22.rotation.z
	}
end

function var0_0.PlayerData2IslandUnit(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	local var0_23
	local var1_23
	local var2_23 = pg.island_world_objects.get_id_list_by_mapId[arg1_23] or {}

	for iter0_23, iter1_23 in ipairs(var2_23) do
		local var3_23 = pg.island_world_objects[iter1_23]

		if var3_23.unitId == 0 then
			var0_23 = var3_23

			break
		end
	end

	assert(var0_23)

	if arg0_23:IsSelf() then
		local var4_23 = {
			id = arg0_23.id,
			unitId = arg0_23:GetModelId(),
			typ = IslandConst.UNIT_TYPE_PLAYER
		}
		local var5_23 = arg3_23 and pg.island_world_objects[arg3_23] or var0_23

		if var5_23.mapId ~= arg1_23 then
			var5_23 = var0_23
		end

		var1_0(arg1_23, arg3_23, arg4_23, var4_23)

		var1_23 = var0_0.WorldObj2IslandUnit(var5_23, var4_23)
	else
		local var6_23 = {
			behaviourTree = "Island/NodeCanvas/Visitor",
			id = arg0_23.id,
			unitId = arg0_23:GetModelId(),
			typ = IslandConst.UNIT_TYPE_VISITOR,
			islandId = arg2_23
		}

		var1_23 = var0_0.WorldObj2IslandUnit(var0_23, var6_23)
	end

	return var1_23
end

function var0_0.ModelId2IslandUnit(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = pg.island_world_objects[arg0_24] or {}
	local var1_24

	if var0_24.mapId == arg2_24 then
		local var2_24 = {
			unitId = arg1_24,
			typ = arg3_24
		}

		var1_24 = var0_0.WorldObj2IslandUnit(var0_24, var2_24)
	end

	return var1_24
end

function var0_0.WorldObj2IslandUnit(arg0_25, arg1_25)
	arg1_25 = arg1_25 or {}

	local var0_25 = arg1_25.typ or arg0_25.type
	local var1_25

	if var0_25 == IslandConst.UNIT_TYPE_ITEM_INTERACT then
		var1_25 = IslandInteractUnitVO
	elseif var0_25 == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM or var0_25 == IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM then
		var1_25 = IslandGatherUnitVO
	elseif var0_25 == IslandConst.UNIT_TYPE_VISITOR then
		var1_25 = IslandVistorUnitVO
	else
		var1_25 = IslandUnitVO
	end

	return (var1_25.New({
		id = arg1_25.id or arg0_25.id,
		modelId = arg1_25.unitId or arg0_25.unitId,
		type = arg1_25.typ or arg0_25.type,
		name = arg0_25.name,
		position = arg1_25.position or arg0_25.param.position,
		rotation = arg1_25.rotation or arg0_25.param.rotation,
		scale = arg0_25.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_25.behaviourTree or arg0_25.behaviourTree,
		genType = arg0_25.gen_type,
		showCondition = arg0_25.show_param or {},
		hideCondition = arg0_25.hide_param or {},
		index = arg1_25.index or 0,
		islandId = arg1_25.islandId
	}))
end

function var0_0.TakePhotoData2IslandUnit(arg0_26)
	local var0_26 = {
		unitId = 20024,
		id = arg0_26,
		typ = IslandConst.UNIT_TYPE_FIRST_TAKE_PHOTO_ITEM
	}

	return (IslandUnitVO.New({
		index = 0,
		behaviourTree = "",
		genType = 1,
		id = var0_26.id,
		modelId = var0_26.unitId,
		type = var0_26.typ,
		name = "TakePhoto" .. arg0_26,
		position = {
			0,
			0,
			0
		},
		rotation = {
			0,
			0,
			0
		},
		scale = {
			1,
			1,
			1
		},
		showCondition = {},
		hideCondition = {}
	}))
end

function var0_0.GenDelayRecycleIslandUnit(arg0_27)
	local var0_27 = pg.island_world_objects[arg0_27.id]
	local var1_27 = {
		id = arg0_27.id,
		unitId = arg0_27.unitId,
		position = {
			arg0_27.position.x,
			arg0_27.position.y,
			arg0_27.position.z
		},
		rotation = {
			arg0_27.rotation.x,
			arg0_27.rotation.y,
			arg0_27.rotation.z
		},
		behaviourTree = arg0_27.behaviourTree,
		recycleAssetType = arg0_27.recycleAssetType,
		delayRecycleTime = arg0_27.delayRecycleTime
	}

	return var0_0.WorldObj2IslandDelayRecycleUnit(var0_27, var1_27)
end

function var0_0.WorldObj2IslandDelayRecycleUnit(arg0_28, arg1_28)
	arg1_28 = arg1_28 or {}

	return (IslandDelayRecycleUnitVO.New({
		id = arg1_28.id or arg0_28.id,
		modelId = arg1_28.unitId or arg0_28.unitId,
		type = IslandConst.UNIT_TYPE_ITEM_DELAY_RECYCLE,
		name = arg0_28.name .. "delay",
		position = arg1_28.position or arg0_28.param.position,
		rotation = arg1_28.rotation or arg0_28.param.rotation,
		scale = arg0_28.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_28.behaviourTree or arg0_28.behaviourTree,
		genType = arg0_28.gen_type,
		showCondition = arg0_28.show_param or {},
		hideCondition = arg0_28.hide_param or {},
		index = arg1_28.index or 0,
		delayRecycleTime = arg1_28.delayRecycleTime,
		recycleAssetType = arg1_28.recycleAssetType
	}))
end

function var0_0.GenWildGatherUnit(arg0_29)
	local var0_29 = pg.island_world_objects[arg0_29.unitId]

	return (var0_0.WorldObj2IslandUnit(var0_29, {
		index = arg0_29.islandId,
		typ = arg0_29.gatherType
	}))
end

function var0_0.GenInteractUnitByAgoraFurniture(arg0_30)
	return (IslandVirtualInteractUnitVO.New({
		index = 0,
		id = arg0_30.id,
		modelId = arg0_30.pointId,
		type = IslandConst.UNIT_TYPE_VIRTUAL_INTERACT,
		name = "AgoraInteract" .. arg0_30.id,
		position = arg0_30.position,
		rotation = arg0_30.rotation,
		scale = {
			1,
			1,
			1
		},
		genType = IslandConst.UNIT_GEN_TYPE_SYSTEM,
		showCondition = {},
		hideCondition = {}
	}))
end

return var0_0
