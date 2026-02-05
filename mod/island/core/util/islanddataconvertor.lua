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
	var0_0.CollectFishPointUnits(arg0_4, arg3_4, arg4_4)

	if arg3_4:IsPrivate() then
		var0_0.CollectOrderSystemUnits(arg0_4, arg3_4, arg4_4)
	end
end

function var0_0.CollectFishPointUnits(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in ipairs(pg.island_fish_point.all) do
		local var0_5 = pg.island_fish_point[iter1_5]

		if pg.island_world_objects[var0_5.objId].mapId == arg2_5 then
			table.insert(arg0_5, IslandFishPointVO.New(iter1_5, var0_5.objId))
		end
	end
end

function var0_0.CollectBuildingSystemUnits(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6 = arg2_6:GetBuildingAgency()
	local var1_6 = pg.island_production_place.get_id_list_by_map_id[arg3_6] or {}

	for iter0_6, iter1_6 in ipairs(var1_6) do
		if arg3_6 == pg.island_production_place[iter1_6].map_id then
			local var2_6 = var0_6:GetBuilding(iter1_6)
			local var3_6 = IslandProductSystemVO.New(iter1_6, var2_6, arg2_6.id)

			for iter2_6, iter3_6 in ipairs(var3_6:GetUnitDatas()) do
				if iter3_6 then
					if iter3_6.delayTime then
						table.insert(arg1_6, iter3_6)
					else
						table.insert(arg0_6, iter3_6)
					end
				end
			end

			table.insert(arg4_6, var3_6)
		end
	end
end

function var0_0.CollectOrderSystemUnits(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7:GetOrderAgency():GetShipSlotList()

	for iter0_7, iter1_7 in pairs(var0_7) do
		if not iter1_7:IsLock() and iter1_7:GetWorldObjId() > 0 then
			local var1_7 = pg.island_world_objects[iter1_7:GetWorldObjId()]

			if var1_7 and var1_7.mapId == arg2_7 then
				local var2_7 = {}
				local var3_7 = var0_0.WorldObj2IslandUnit(var1_7, var2_7)

				table.insert(arg0_7, var3_7)
			end
		end
	end
end

function var0_0.CollectSignInSystemUnits(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg2_8:GetSignInAgency()
	local var1_8 = pg.island_world_objects.get_id_list_by_mapId[arg3_8] or {}
	local var2_8 = 0

	for iter0_8, iter1_8 in ipairs(var1_8) do
		local var3_8 = pg.island_world_objects[iter1_8]

		if var3_8.unitId > 0 and var3_8.gen_type == IslandConst.UNIT_GEN_TYPE_GIFT then
			var2_8 = var2_8 + 1

			local var4_8 = var0_0.WorldObj2IslandUnit(var3_8, {
				index = var2_8
			})

			table.insert(arg1_8, var4_8)
		end
	end
end

function var0_0.CollectWildCollectInSystemUnits(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg2_9:GetWildCollectAgency():GetUnitList()

	for iter0_9, iter1_9 in ipairs(var0_9) do
		local var1_9 = pg.island_world_objects[iter1_9.unitId]

		if var1_9.unitId > 0 then
			local var2_9 = var0_0.WorldObj2IslandUnit(var1_9, {
				index = arg2_9.id,
				typ = iter1_9.gatherType
			})

			table.insert(arg0_9, var2_9)
		end
	end
end

function var0_0.CollectStrollUnits(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10:GetAblityAgency()
	local var1_10 = arg1_10:GetCharacterAgency():GetShips()

	local function var2_10(arg0_11, arg1_11)
		if arg0_11 == -1 then
			local var0_11 = arg1_10:GetFollowerAgency()
			local var1_11 = _.detect(var1_10, function(arg0_12)
				return not var0_11:Following(arg0_12.id) and arg0_12:getConfig("unit_id") == arg1_11
			end)

			return var1_11 ~= nil, var1_11 and var1_11:GetModelUnit(), var1_11 and var1_11.id
		else
			return arg0_11 == 0 or var0_10:HasAbility(arg0_11), nil, 0
		end
	end

	for iter0_10, iter1_10 in ipairs(pg.island_strollnpc.all) do
		local var3_10 = pg.island_strollnpc[iter1_10]

		if _.any(var3_10.mapId, function(arg0_13)
			return arg0_13[1] == arg2_10 and IslandCalcUtil.IsHappen(arg0_13[3] or 100)
		end) then
			local var4_10, var5_10, var6_10 = var2_10(var3_10.unlock, var3_10.unit_id)

			if var4_10 then
				table.insert(arg0_10, IslandStrollUnitVO.New(var6_10, iter1_10, var5_10))
			end
		end
	end

	var0_0.DistributeAward4StrollUnits(arg0_10, arg1_10)
end

function var0_0.DistributeAward4StrollUnits(arg0_14, arg1_14)
	if #arg0_14 > 0 and arg1_14:IsPrivate() then
		local var0_14 = arg1_14:GetNpcFeedbackAgency():GetNpcList()
		local var1_14 = pg.island_set.island_feedback_award_times.key_value_int - #var0_14
		local var2_14 = {}

		for iter0_14, iter1_14 in ipairs(arg0_14) do
			if pg.island_strollnpc[iter1_14.id].action_feedback == 1 and _.all(var0_14, function(arg0_15)
				return iter1_14.id ~= arg0_15
			end) then
				table.insert(var2_14, iter1_14)
			end
		end

		if #var2_14 <= 0 then
			return
		end

		shuffle(var2_14)

		local var3_14 = pg.island_action.get_id_list_by_type[IslandConst.ANIMATION_OP_SIGNLE]
		local var4_14 = arg1_14:GetActionAgency()
		local var5_14 = _.select(var3_14, function(arg0_16)
			return var4_14:ExistAction(arg0_16)
		end)

		if #var5_14 <= 0 then
			return
		end

		for iter2_14 = 1, var1_14 do
			local var6_14 = var2_14[iter2_14]

			if var6_14 then
				local var7_14 = var5_14[math.random(1, #var5_14)]

				var6_14:SetActionFeedback(var7_14)
			end
		end
	end
end

function var0_0.CollectFollowUnits(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17

	for iter0_17, iter1_17 in ipairs(arg0_17) do
		if iter1_17:IsPlayer() then
			var0_17 = iter1_17

			break
		end
	end

	if not var0_17 then
		return
	end

	local var1_17 = var0_17.position
	local var2_17 = var0_17.rotation
	local var3_17 = arg2_17:GetFollowerAgency()

	for iter2_17, iter3_17 in ipairs(var3_17:GetFollowers()) do
		local var4_17 = arg2_17:GetCharacterAgency():GetShipById(iter3_17)
		local var5_17 = var4_17:GetModelUnit()

		table.insert(arg1_17, IslandFollowerUnitVO.New(var4_17.id, iter3_17, var5_17, var1_17, var2_17, iter2_17 == 1))
	end
end

function var0_0.CollectSystems(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	var0_0.CollectPordunctSystem(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	var0_0.CollectManageSystem(arg0_18, arg1_18, arg2_18, arg3_18)

	local var0_18 = pg.island_map[arg3_18]

	if var0_18.minigame_id > 0 then
		table.insert(arg0_18, IslandSeekGameSystemVO.New(var0_18.minigame_id, IslandConst.SEEK_GAME_SYSTEM_ID))
	elseif arg3_18 == IslandConst.AGORA_MAP_ID then
		table.insert(arg0_18, IslandGroundSystemVO.New(IslandConst.AGORA_GROUND_SYSTEM_ID))
		table.insert(arg0_18, IslandGrassLandSystemVO.New(IslandConst.AGORA_GRASSLAND))
	end
end

function var0_0.CollectManageSystem(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg2_19:GetManageAgency():GetRestaurants()

	for iter0_19, iter1_19 in pairs(var0_19) do
		if iter1_19:getConfig("map_id") == arg3_19 then
			local var1_19 = IslandManageSystemVO.New(iter1_19.id, iter1_19)

			table.insert(arg0_19, var1_19)

			if iter1_19:GetStatus() == IslandRestaurant.STATUS.OPENING then
				for iter2_19, iter3_19 in ipairs(var1_19:GetUnits()) do
					table.insert(arg1_19, iter3_19)
				end
			end
		end
	end
end

function var0_0.CollectPordunctSystem(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	local var0_20 = pg.island_production_place.get_id_list_by_map_id[arg3_20] or {}
	local var1_20 = arg2_20:GetBuildingAgency()

	local function var2_20(arg0_21)
		local var0_21

		for iter0_21, iter1_21 in ipairs(arg4_20) do
			if iter1_21.id == arg0_21 then
				var0_21 = iter1_21
			end
		end

		return var0_21
	end

	local var3_20 = {
		IslandProductConst.PasturePlaceId,
		IslandProductConst.FarmlandPlaceId,
		IslandProductConst.OrchardPlaceId,
		IslandProductConst.GardenPlaceId
	}

	for iter0_20, iter1_20 in ipairs(IslandProductConst.FactorytPlaces) do
		table.insert(var3_20, iter1_20)
	end

	for iter2_20, iter3_20 in ipairs(var0_20) do
		local var4_20 = var2_20(iter3_20)
		local var5_20 = IslandCharacterSystemVO.New(iter3_20, var4_20, arg2_20.id)
		local var6_20 = var1_20:GetBuilding(iter3_20)
		local var7_20 = 0

		if var6_20 then
			local var8_20 = var6_20:GetShipIdAndAreaIdList()

			for iter4_20, iter5_20 in ipairs(var8_20) do
				if iter3_20 ~= IslandProductConst.MinePlaceId then
					local var9_20 = var5_20:GetUnit(iter5_20.ship_id, iter5_20.area_id, table.contains(var3_20, iter3_20))

					table.insert(arg1_20, var9_20)
				end

				var7_20 = var7_20 + 1
			end

			var5_20:SetkCurrentWorkerList(var8_20)
		end

		var5_20:SetWorkerCnt(var7_20)
		table.insert(arg0_20, var5_20)

		if var4_20 and table.contains(IslandProductConst.havePerformPlace, iter3_20) then
			if var6_20 then
				local var10_20 = var6_20:GetDelegateingSlotAndFormulaList()

				for iter6_20, iter7_20 in ipairs(var10_20) do
					local var11_20 = var4_20:GetDelegateUnitsByBuildIdAndSlotId(iter3_20, iter7_20.area_id, iter7_20.formula_id)

					for iter8_20, iter9_20 in ipairs(var11_20) do
						table.insert(arg1_20, iter9_20)
					end

					local var12_20 = var4_20:GetDelegateEffectsByCommissonId(iter7_20.area_id)

					if var12_20 then
						local var13_20 = var4_20:GenUnitByDelegateEffectId(var12_20)

						if var13_20 then
							table.insert(arg1_20, var13_20)
						end
					end
				end
			end

			table.insert(arg0_20, var4_20)
		end
	end
end

function var0_0.SceneData2IslandUnits(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22, arg5_22, arg6_22)
	local var0_22 = pg.island_world_objects.get_id_list_by_mapId[arg3_22] or {}

	for iter0_22, iter1_22 in ipairs(var0_22) do
		local var1_22 = pg.island_world_objects[iter1_22]

		if var1_22.unitId > 0 and (var1_22.gen_type == IslandConst.UNIT_GEN_TYPE_STATIC or var1_22.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC) then
			local var2_22 = var0_0.WorldObj2IslandUnit(var1_22)

			table.insert(arg0_22, var2_22)
		elseif var1_22.unitId > 0 and var1_22.gen_type == IslandConst.UNIT_GEN_TYPE_ACTIVITY then
			local var3_22 = var0_0.WorldObj2IslandUnit(var1_22)

			table.insert(arg1_22, var3_22)
		end
	end

	for iter2_22, iter3_22 in pairs(arg2_22) do
		if iter3_22:IsSelf() then
			local var4_22 = var0_0.PlayerData2IslandUnit(iter3_22, arg3_22, arg6_22, arg4_22, arg5_22)

			table.insert(arg0_22, var4_22)
		end
	end

	local var5_22 = var0_0.TakePhotoData2IslandUnit(2)

	table.insert(arg0_22, var5_22)

	local var6_22 = var0_0.TakePhotoData2IslandUnit(3)

	table.insert(arg0_22, var6_22)
end

local function var1_0(arg0_23, arg1_23, arg2_23, arg3_23)
	if arg1_23 then
		return
	end

	if arg0_23 ~= arg2_23.mapId then
		return
	end

	arg3_23.position = {
		arg2_23.position.x,
		arg2_23.position.y,
		arg2_23.position.z
	}
	arg3_23.rotation = {
		arg2_23.rotation.x,
		arg2_23.rotation.y,
		arg2_23.rotation.z
	}
end

function var0_0.PlayerData2IslandUnit(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	local var0_24
	local var1_24
	local var2_24 = pg.island_world_objects.get_id_list_by_mapId[arg1_24] or {}

	for iter0_24, iter1_24 in ipairs(var2_24) do
		local var3_24 = pg.island_world_objects[iter1_24]

		if var3_24.unitId == 0 then
			var0_24 = var3_24

			break
		end
	end

	assert(var0_24)

	if arg0_24:IsSelf() then
		local var4_24 = {
			id = arg0_24.id,
			unitId = arg0_24:GetModelId(),
			typ = IslandConst.UNIT_TYPE_PLAYER
		}
		local var5_24 = arg3_24 and pg.island_world_objects[arg3_24] or var0_24

		if var5_24.mapId ~= arg1_24 then
			var5_24 = var0_24
		end

		var1_0(arg1_24, arg3_24, arg4_24, var4_24)

		var1_24 = var0_0.WorldObj2IslandUnit(var5_24, var4_24)
	else
		local var6_24 = {
			behaviourTree = "Island/NodeCanvas/Visitor",
			id = arg0_24.id,
			unitId = arg0_24:GetModelId(),
			typ = IslandConst.UNIT_TYPE_VISITOR,
			islandId = arg2_24
		}

		var1_24 = var0_0.WorldObj2IslandUnit(var0_24, var6_24)
	end

	return var1_24
end

function var0_0.ModelId2IslandUnit(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = pg.island_world_objects[arg0_25] or {}
	local var1_25

	if var0_25.mapId == arg2_25 then
		local var2_25 = {
			unitId = arg1_25,
			typ = arg3_25
		}

		var1_25 = var0_0.WorldObj2IslandUnit(var0_25, var2_25)
	end

	return var1_25
end

function var0_0.WorldObj2IslandUnit(arg0_26, arg1_26)
	arg1_26 = arg1_26 or {}

	local var0_26 = arg1_26.typ or arg0_26.type
	local var1_26

	if var0_26 == IslandConst.UNIT_TYPE_ITEM_INTERACT then
		var1_26 = IslandInteractUnitVO
	elseif var0_26 == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM or var0_26 == IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM then
		var1_26 = IslandGatherUnitVO
	elseif var0_26 == IslandConst.UNIT_TYPE_VISITOR then
		var1_26 = IslandVistorUnitVO
	else
		var1_26 = IslandUnitVO
	end

	return (var1_26.New({
		id = arg1_26.id or arg0_26.id,
		modelId = arg1_26.unitId or arg0_26.unitId,
		type = arg1_26.typ or arg0_26.type,
		name = arg0_26.name,
		position = arg1_26.position or arg0_26.param.position,
		rotation = arg1_26.rotation or arg0_26.param.rotation,
		scale = arg0_26.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_26.behaviourTree or arg0_26.behaviourTree,
		genType = arg0_26.gen_type,
		showCondition = arg0_26.show_param or {},
		hideCondition = arg0_26.hide_param or {},
		index = arg1_26.index or 0,
		islandId = arg1_26.islandId
	}))
end

function var0_0.TakePhotoData2IslandUnit(arg0_27)
	local var0_27 = {
		unitId = 20024,
		id = arg0_27,
		typ = IslandConst.UNIT_TYPE_FIRST_TAKE_PHOTO_ITEM
	}

	return (IslandUnitVO.New({
		index = 0,
		behaviourTree = "",
		genType = 1,
		id = var0_27.id,
		modelId = var0_27.unitId,
		type = var0_27.typ,
		name = "TakePhoto" .. arg0_27,
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

function var0_0.GenDelayRecycleIslandUnit(arg0_28)
	local var0_28 = pg.island_world_objects[arg0_28.id]
	local var1_28 = {
		id = arg0_28.id,
		unitId = arg0_28.unitId,
		position = {
			arg0_28.position.x,
			arg0_28.position.y,
			arg0_28.position.z
		},
		rotation = {
			arg0_28.rotation.x,
			arg0_28.rotation.y,
			arg0_28.rotation.z
		},
		behaviourTree = arg0_28.behaviourTree,
		recycleAssetType = arg0_28.recycleAssetType,
		delayRecycleTime = arg0_28.delayRecycleTime
	}

	return var0_0.WorldObj2IslandDelayRecycleUnit(var0_28, var1_28)
end

function var0_0.WorldObj2IslandDelayRecycleUnit(arg0_29, arg1_29)
	arg1_29 = arg1_29 or {}

	return (IslandDelayRecycleUnitVO.New({
		id = arg1_29.id or arg0_29.id,
		modelId = arg1_29.unitId or arg0_29.unitId,
		type = IslandConst.UNIT_TYPE_ITEM_DELAY_RECYCLE,
		name = arg0_29.name .. "delay",
		position = arg1_29.position or arg0_29.param.position,
		rotation = arg1_29.rotation or arg0_29.param.rotation,
		scale = arg0_29.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_29.behaviourTree or arg0_29.behaviourTree,
		genType = arg0_29.gen_type,
		showCondition = arg0_29.show_param or {},
		hideCondition = arg0_29.hide_param or {},
		index = arg1_29.index or 0,
		delayRecycleTime = arg1_29.delayRecycleTime,
		recycleAssetType = arg1_29.recycleAssetType
	}))
end

function var0_0.GenWildGatherUnit(arg0_30)
	local var0_30 = pg.island_world_objects[arg0_30.unitId]

	return (var0_0.WorldObj2IslandUnit(var0_30, {
		index = arg0_30.islandId,
		typ = arg0_30.gatherType
	}))
end

function var0_0.GenInteractUnitByAgoraFurniture(arg0_31)
	return (IslandVirtualInteractUnitVO.New({
		index = 0,
		id = arg0_31.id,
		modelId = arg0_31.pointId,
		type = IslandConst.UNIT_TYPE_VIRTUAL_INTERACT,
		name = "AgoraInteract" .. arg0_31.id,
		position = arg0_31.position,
		rotation = arg0_31.rotation,
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
