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

function var0_0.DistributeActionFeedbackAward4StrollUnits(arg0_14, arg1_14, arg2_14)
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

	for iter2_14 = 1, var1_14 do
		local var3_14 = var2_14[iter2_14]

		if var3_14 then
			local var4_14 = arg2_14[math.random(1, #arg2_14)]

			var3_14:SetActionFeedback(var4_14)
		end
	end
end

function var0_0.DistributeShipSkillAward4StrollUnits(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg1_16:GetCharacterAgency()

	for iter0_16, iter1_16 in ipairs(arg0_16) do
		local var1_16 = iter1_16:GetShipId()
		local var2_16 = var0_16:GetShipById(var1_16)

		if var2_16 and var2_16:HasGreetingSkill() and var2_16:GetSkill():CanUse4Ship(var2_16, {
			IslandBuffType.SHIP_POWER_RECOVER_BY_GREETING,
			IslandBuffType.SHIP_AWARD_BY_GREETING
		}) then
			local var3_16 = arg2_16[math.random(1, #arg2_16)]

			iter1_16:SetSkillActionFeedback(var3_16)
		end
	end
end

function var0_0.GetOwnActions(arg0_17)
	local var0_17 = pg.island_action.get_id_list_by_type[IslandConst.ANIMATION_OP_SIGNLE]
	local var1_17 = arg0_17:GetActionAgency()

	return (_.select(var0_17, function(arg0_18)
		return var1_17:ExistAction(arg0_18)
	end))
end

function var0_0.DistributeAward4StrollUnits(arg0_19, arg1_19)
	if #arg0_19 > 0 and arg1_19:IsPrivate() then
		local var0_19 = var0_0.GetOwnActions(arg1_19)

		if #var0_19 <= 0 then
			return
		end

		var0_0.DistributeActionFeedbackAward4StrollUnits(arg0_19, arg1_19, var0_19)
		var0_0.DistributeShipSkillAward4StrollUnits(arg0_19, arg1_19, var0_19)
	end
end

function var0_0.CollectFollowUnits(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20

	for iter0_20, iter1_20 in ipairs(arg0_20) do
		if iter1_20:IsPlayer() then
			var0_20 = iter1_20

			break
		end
	end

	if not var0_20 then
		return
	end

	local var1_20 = var0_20.position
	local var2_20 = var0_20.rotation
	local var3_20 = arg2_20:GetFollowerAgency()

	for iter2_20, iter3_20 in ipairs(var3_20:GetFollowers()) do
		local var4_20 = arg2_20:GetCharacterAgency():GetShipById(iter3_20)
		local var5_20 = var4_20:GetModelUnit()

		table.insert(arg1_20, IslandFollowerUnitVO.New(var4_20.id, iter3_20, var5_20, var1_20, var2_20, iter2_20 == 1))
	end
end

function var0_0.CollectSystems(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	var0_0.CollectPordunctSystem(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	var0_0.CollectManageSystem(arg0_21, arg1_21, arg2_21, arg3_21)

	local var0_21 = pg.island_map[arg3_21]

	if var0_21.minigame_id > 0 then
		table.insert(arg0_21, IslandSeekGameSystemVO.New(var0_21.minigame_id, IslandConst.SEEK_GAME_SYSTEM_ID))
	elseif arg3_21 == IslandConst.AGORA_MAP_ID then
		table.insert(arg0_21, IslandGroundSystemVO.New(IslandConst.AGORA_GROUND_SYSTEM_ID))
		table.insert(arg0_21, IslandGrassLandSystemVO.New(IslandConst.AGORA_GRASSLAND))
	end
end

function var0_0.CollectManageSystem(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg2_22:GetManageAgency():GetRestaurants()

	for iter0_22, iter1_22 in pairs(var0_22) do
		if iter1_22:getConfig("map_id") == arg3_22 then
			local var1_22 = IslandManageSystemVO.New(iter1_22.id, iter1_22)

			table.insert(arg0_22, var1_22)

			if iter1_22:GetStatus() == IslandRestaurant.STATUS.OPENING then
				for iter2_22, iter3_22 in ipairs(var1_22:GetUnits()) do
					table.insert(arg1_22, iter3_22)
				end
			end
		end
	end
end

function var0_0.CollectPordunctSystem(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	local var0_23 = pg.island_production_place.get_id_list_by_map_id[arg3_23] or {}
	local var1_23 = arg2_23:GetBuildingAgency()

	local function var2_23(arg0_24)
		local var0_24

		for iter0_24, iter1_24 in ipairs(arg4_23) do
			if iter1_24.id == arg0_24 then
				var0_24 = iter1_24
			end
		end

		return var0_24
	end

	local var3_23 = {
		IslandProductConst.PasturePlaceId,
		IslandProductConst.FarmlandPlaceId,
		IslandProductConst.OrchardPlaceId,
		IslandProductConst.GardenPlaceId
	}

	for iter0_23, iter1_23 in ipairs(IslandProductConst.FactorytPlaces) do
		table.insert(var3_23, iter1_23)
	end

	for iter2_23, iter3_23 in ipairs(var0_23) do
		local var4_23 = var2_23(iter3_23)
		local var5_23 = IslandCharacterSystemVO.New(iter3_23, var4_23, arg2_23.id)
		local var6_23 = var1_23:GetBuilding(iter3_23)
		local var7_23 = 0

		if var6_23 then
			local var8_23 = var6_23:GetShipIdAndAreaIdList()

			for iter4_23, iter5_23 in ipairs(var8_23) do
				if iter3_23 ~= IslandProductConst.MinePlaceId then
					local var9_23 = var5_23:GetUnit(iter5_23.ship_id, iter5_23.area_id, table.contains(var3_23, iter3_23))

					table.insert(arg1_23, var9_23)
				end

				var7_23 = var7_23 + 1
			end

			var5_23:SetkCurrentWorkerList(var8_23)
		end

		var5_23:SetWorkerCnt(var7_23)
		table.insert(arg0_23, var5_23)

		if var4_23 and table.contains(IslandProductConst.havePerformPlace, iter3_23) then
			if var6_23 then
				local var10_23 = var6_23:GetDelegateingSlotAndFormulaList()

				for iter6_23, iter7_23 in ipairs(var10_23) do
					local var11_23 = var4_23:GetDelegateUnitsByBuildIdAndSlotId(iter3_23, iter7_23.area_id, iter7_23.formula_id)

					for iter8_23, iter9_23 in ipairs(var11_23) do
						table.insert(arg1_23, iter9_23)
					end

					local var12_23 = var4_23:GetDelegateEffectsByCommissonId(iter7_23.area_id)

					if var12_23 then
						local var13_23 = var4_23:GenUnitByDelegateEffectId(var12_23)

						if var13_23 then
							table.insert(arg1_23, var13_23)
						end
					end
				end
			end

			table.insert(arg0_23, var4_23)
		end
	end
end

function var0_0.SceneData2IslandUnits(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25, arg5_25, arg6_25)
	local var0_25 = pg.island_world_objects.get_id_list_by_mapId[arg3_25] or {}

	for iter0_25, iter1_25 in ipairs(var0_25) do
		local var1_25 = pg.island_world_objects[iter1_25]

		if var1_25.unitId > 0 and (var1_25.gen_type == IslandConst.UNIT_GEN_TYPE_STATIC or var1_25.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC) then
			local var2_25 = var0_0.WorldObj2IslandUnit(var1_25)

			table.insert(arg0_25, var2_25)
		elseif var1_25.unitId > 0 and var1_25.gen_type == IslandConst.UNIT_GEN_TYPE_ACTIVITY then
			local var3_25 = var0_0.WorldObj2IslandUnit(var1_25)

			table.insert(arg1_25, var3_25)
		end
	end

	if arg3_25 == IslandConst.CheaterTavernMapId then
		return
	end

	for iter2_25, iter3_25 in pairs(arg2_25) do
		if iter3_25:IsSelf() then
			local var4_25 = var0_0.PlayerData2IslandUnit(iter3_25, arg3_25, arg6_25, arg4_25, arg5_25)

			table.insert(arg0_25, var4_25)
		end
	end

	local var5_25 = var0_0.TakePhotoData2IslandUnit(2)

	table.insert(arg0_25, var5_25)

	local var6_25 = var0_0.TakePhotoData2IslandUnit(3)

	table.insert(arg0_25, var6_25)
end

local function var1_0(arg0_26, arg1_26, arg2_26, arg3_26)
	if arg1_26 then
		return
	end

	if arg0_26 ~= arg2_26.mapId then
		return
	end

	arg3_26.position = {
		arg2_26.position.x,
		arg2_26.position.y,
		arg2_26.position.z
	}
	arg3_26.rotation = {
		arg2_26.rotation.x,
		arg2_26.rotation.y,
		arg2_26.rotation.z
	}
end

function var0_0.PlayerData2IslandUnit(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27)
	local var0_27
	local var1_27
	local var2_27 = pg.island_world_objects.get_id_list_by_mapId[arg1_27] or {}

	for iter0_27, iter1_27 in ipairs(var2_27) do
		local var3_27 = pg.island_world_objects[iter1_27]

		if var3_27.unitId == 0 then
			var0_27 = var3_27

			break
		end
	end

	assert(var0_27)

	if arg0_27:IsSelf() then
		local var4_27 = {
			id = arg0_27.id,
			unitId = arg0_27:GetModelId(),
			typ = IslandConst.UNIT_TYPE_PLAYER
		}
		local var5_27 = arg3_27 and pg.island_world_objects[arg3_27] or var0_27

		if var5_27.mapId ~= arg1_27 then
			var5_27 = var0_27
		end

		var1_0(arg1_27, arg3_27, arg4_27, var4_27)

		var1_27 = var0_0.WorldObj2IslandUnit(var5_27, var4_27)
	else
		local var6_27 = {
			behaviourTree = "Island/NodeCanvas/Visitor",
			id = arg0_27.id,
			unitId = arg0_27:GetModelId(),
			typ = IslandConst.UNIT_TYPE_VISITOR,
			islandId = arg2_27
		}

		var1_27 = var0_0.WorldObj2IslandUnit(var0_27, var6_27)
	end

	return var1_27
end

function var0_0.ModelId2IslandUnit(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = pg.island_world_objects[arg0_28] or {}
	local var1_28

	if var0_28.mapId == arg2_28 then
		local var2_28 = {
			unitId = arg1_28,
			typ = arg3_28
		}

		var1_28 = var0_0.WorldObj2IslandUnit(var0_28, var2_28)
	end

	return var1_28
end

function var0_0.WorldObj2IslandUnit(arg0_29, arg1_29)
	arg1_29 = arg1_29 or {}

	local var0_29 = arg1_29.typ or arg0_29.type
	local var1_29

	if var0_29 == IslandConst.UNIT_TYPE_ITEM_INTERACT then
		var1_29 = IslandInteractUnitVO
	elseif var0_29 == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM or var0_29 == IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM then
		var1_29 = IslandGatherUnitVO
	elseif var0_29 == IslandConst.UNIT_TYPE_VISITOR then
		var1_29 = IslandVistorUnitVO
	else
		var1_29 = IslandUnitVO
	end

	return (var1_29.New({
		id = arg1_29.id or arg0_29.id,
		modelId = arg1_29.unitId or arg0_29.unitId,
		type = arg1_29.typ or arg0_29.type,
		name = arg0_29.name,
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
		islandId = arg1_29.islandId
	}))
end

function var0_0.TakePhotoData2IslandUnit(arg0_30)
	local var0_30 = {
		unitId = 20024,
		id = arg0_30,
		typ = IslandConst.UNIT_TYPE_FIRST_TAKE_PHOTO_ITEM
	}

	return (IslandUnitVO.New({
		index = 0,
		behaviourTree = "",
		genType = 1,
		id = var0_30.id,
		modelId = var0_30.unitId,
		type = var0_30.typ,
		name = "TakePhoto" .. arg0_30,
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

function var0_0.IslandCheaterTavernPlayerDataToUnit(arg0_31)
	local var0_31 = CheaterTavernHelper.GetModelDataByViewData(arg0_31.user_view)
	local var1_31 = 10110000 + arg0_31.seat
	local var2_31 = pg.island_world_objects[var1_31]
	local var3_31 = {
		id = arg0_31.id,
		unitId = var0_31.unitId,
		typ = IslandConst.UNIT_TYPE_CHEATERTAVERN_PLAYER
	}

	return (IslandUnitVO.New({
		index = 0,
		behaviourTree = "",
		genType = 1,
		id = var3_31.id,
		modelId = var3_31.unitId,
		type = var3_31.typ,
		name = arg0_31.id,
		position = var3_31.position or var2_31.param.position,
		rotation = var3_31.rotation or var2_31.param.rotation,
		scale = var2_31.param.scale or {
			1,
			1,
			1
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

function var0_0.GenDelayRecycleIslandUnit(arg0_32)
	local var0_32 = pg.island_world_objects[arg0_32.id]
	local var1_32 = {
		id = arg0_32.id,
		unitId = arg0_32.unitId,
		position = {
			arg0_32.position.x,
			arg0_32.position.y,
			arg0_32.position.z
		},
		rotation = {
			arg0_32.rotation.x,
			arg0_32.rotation.y,
			arg0_32.rotation.z
		},
		behaviourTree = arg0_32.behaviourTree,
		recycleAssetType = arg0_32.recycleAssetType,
		delayRecycleTime = arg0_32.delayRecycleTime
	}

	return var0_0.WorldObj2IslandDelayRecycleUnit(var0_32, var1_32)
end

function var0_0.WorldObj2IslandDelayRecycleUnit(arg0_33, arg1_33)
	arg1_33 = arg1_33 or {}

	return (IslandDelayRecycleUnitVO.New({
		id = arg1_33.id or arg0_33.id,
		modelId = arg1_33.unitId or arg0_33.unitId,
		type = IslandConst.UNIT_TYPE_ITEM_DELAY_RECYCLE,
		name = arg0_33.name .. "delay",
		position = arg1_33.position or arg0_33.param.position,
		rotation = arg1_33.rotation or arg0_33.param.rotation,
		scale = arg0_33.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_33.behaviourTree or arg0_33.behaviourTree,
		genType = arg0_33.gen_type,
		showCondition = arg0_33.show_param or {},
		hideCondition = arg0_33.hide_param or {},
		index = arg1_33.index or 0,
		delayRecycleTime = arg1_33.delayRecycleTime,
		recycleAssetType = arg1_33.recycleAssetType
	}))
end

function var0_0.GenWildGatherUnit(arg0_34)
	local var0_34 = pg.island_world_objects[arg0_34.unitId]

	return (var0_0.WorldObj2IslandUnit(var0_34, {
		index = arg0_34.islandId,
		typ = arg0_34.gatherType
	}))
end

function var0_0.GenInteractUnitByAgoraFurniture(arg0_35)
	return (IslandVirtualInteractUnitVO.New({
		index = 0,
		id = arg0_35.id,
		modelId = arg0_35.pointId,
		type = IslandConst.UNIT_TYPE_VIRTUAL_INTERACT,
		name = "AgoraInteract" .. arg0_35.id,
		position = arg0_35.position,
		rotation = arg0_35.rotation,
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
