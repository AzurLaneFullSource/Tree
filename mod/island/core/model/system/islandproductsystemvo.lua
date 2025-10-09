local var0_0 = class("IslandProductSystemVO", import(".IslandSystemVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.isSelf = arg0_1:IsSelf(arg3_1)
	arg0_1.productPlaceId = arg1_1
	arg0_1.building = arg2_1
	arg0_1.unitDic = {}

	arg0_1:InitCfgData()
end

function var0_0.IsSelf(arg0_2, arg1_2)
	return getProxy(PlayerProxy):getRawData().id == arg1_2
end

function var0_0.InitCfgData(arg0_3)
	arg0_3.slotToUnitDic = {}

	arg0_3:InitCommissionCfgData()
	arg0_3:InitHandPlantCfg()
	arg0_3:InitHandCollectCfg()
end

function var0_0.InitHandPlantCfg(arg0_4)
	local var0_4 = {
		IslandProductConst.FarmlandPlaceId,
		IslandProductConst.OrchardPlaceId,
		IslandProductConst.GardenPlaceId
	}

	if not table.contains(var0_4, arg0_4.productPlaceId) then
		return
	end

	arg0_4.workUnitDic = {}

	for iter0_4, iter1_4 in ipairs(pg.island_production_farm.get_id_list_by_place_id[arg0_4.productPlaceId] or {}) do
		local var1_4 = pg.island_production_farm[iter1_4]
		local var2_4 = var1_4.objId
		local var3_4 = var1_4.slotId

		arg0_4.slotToUnitDic[var3_4] = var2_4

		if not arg0_4.workUnitDic[var2_4] then
			arg0_4.workUnitDic[var2_4] = {}
			arg0_4.workUnitDic[var2_4].idle_unit = var1_4.idle_unit
			arg0_4.workUnitDic[var2_4].work_unit = var1_4.work_unit
		end
	end
end

function var0_0.InitHandCollectCfg(arg0_5)
	if arg0_5.productPlaceId == IslandProductConst.MinePlaceId then
		return
	end

	for iter0_5, iter1_5 in ipairs(pg.island_production_mining.all) do
		local var0_5 = pg.island_production_mining[iter1_5]

		if not arg0_5.slotToUnitDic[var0_5.slotId] then
			arg0_5.slotToUnitDic[var0_5.slotId] = var0_5.objId
		end
	end
end

function var0_0.GetUnitDatas(arg0_6)
	local var0_6 = {}

	arg0_6:GenHandCollectSlot(var0_6)
	arg0_6:GenHandPlantSlot(var0_6)
	arg0_6:GenAnimalBySlot(var0_6)
	arg0_6:GenPlaceModelUnit(var0_6)

	return var0_6
end

function var0_0.GenPlaceModelUnit(arg0_7, arg1_7)
	if not table.contains(IslandProductConst.haveModelPlaces, arg0_7.productPlaceId) then
		return
	end

	local var0_7 = arg0_7.building ~= nil
	local var1_7 = arg0_7:GetPlaceModelUnit(var0_7)

	table.insert(arg1_7, var1_7)
end

function var0_0.GetPlaceModelId(arg0_8, arg1_8)
	if arg1_8 then
		return pg.island_production_place[arg0_8.productPlaceId].unlocked_obj
	else
		return pg.island_production_place[arg0_8.productPlaceId].locked_obj
	end
end

function var0_0.GetPlaceModelUnit(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetPlaceModelId(arg1_9)
	local var1_9 = pg.island_world_objects[var0_9]

	return IslandDataConvertor.WorldObj2IslandUnit(var1_9)
end

function var0_0.InitCommissionCfgData(arg0_10)
	arg0_10.slotCommissionDic = {}

	local var0_10 = pg.island_production_place[arg0_10.productPlaceId].commission_slot

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var1_10 = pg.island_production_commission[iter1_10]

		arg0_10.slotCommissionDic[var1_10.slot] = iter1_10
	end
end

function var0_0.GetCommissionSlotId(arg0_11, arg1_11)
	return arg0_11.slotCommissionDic[arg1_11]
end

function var0_0.GenHandCollectSlot(arg0_12, arg1_12)
	if not arg0_12.building or not arg0_12.isSelf then
		return
	end

	arg0_12:GenHandCollectSlotInSlotPlace(arg1_12)
end

function var0_0.GenHandCollectSlotInSlotPlace(arg0_13, arg1_13)
	local var0_13 = arg0_13.building:GetBuildingCollectData()

	if not var0_13 then
		return
	end

	local var1_13 = var0_13:GetCollectSlotDatasDic()

	for iter0_13, iter1_13 in pairs(var1_13) do
		local var2_13 = arg0_13:GenHandCollectSlotByDataNew(iter1_13)

		table.insert(arg1_13, var2_13)
	end
end

function var0_0.GetHandCollectSlotBySlotId(arg0_14, arg1_14)
	local var0_14 = (arg0_14.building or (arg0_14.isSelf and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetBuildingAgency():GetBuilding(arg0_14.productPlaceId)):GetBuildingCollectData():GetCollectSlotData(arg1_14)

	return arg0_14.productPlaceId == IslandProductConst.MinePlaceId and var0_14.pos or arg0_14.slotToUnitDic[var0_14.configId]
end

function var0_0.GenHandCollectSlotByDataNew(arg0_15, arg1_15)
	local var0_15 = arg0_15.productPlaceId == IslandProductConst.MinePlaceId
	local var1_15 = var0_15 and arg1_15.pos or arg0_15.slotToUnitDic[arg1_15.configId]
	local var2_15 = pg.island_production_slot[arg1_15.configId].formula[1]
	local var3_15 = pg.island_formula[var2_15].unitid[1][2]
	local var4_15
	local var5_15 = arg1_15:GetCanCollectTimeStamps()

	if var5_15 ~= 0 and var0_15 then
		var4_15 = var5_15 - pg.TimeMgr.GetInstance():GetServerTime()
	end

	local var6_15 = {
		unitId = var3_15,
		typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT,
		slotId = arg1_15.configId,
		delayTime = var4_15
	}
	local var7_15 = pg.island_world_objects[var1_15] or {}

	return (arg0_15:CollectSlotObj2IslandUnit(var7_15, var6_15))
end

function var0_0.InitHandCollectSlotBySlotId(arg0_16, arg1_16)
	local var0_16 = (arg0_16.building or (arg0_16.isSelf and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetBuildingAgency():GetBuilding(arg0_16.productPlaceId)):GetCollectSlotData(arg1_16)

	return arg0_16:GenHandCollectSlotByDataNew(var0_16)
end

function var0_0.GenHandPlantSlot(arg0_17, arg1_17)
	for iter0_17, iter1_17 in ipairs(pg.island_production_farm.get_id_list_by_place_id[arg0_17.productPlaceId] or {}) do
		local var0_17 = pg.island_production_farm[iter1_17]
		local var1_17 = var0_17.objId
		local var2_17 = var0_17.slotId
		local var3_17 = var0_17.unlock_unit
		local var4_17 = IslandProductConst.ProductSlotType.HandPlant
		local var5_17

		if arg0_17.building then
			local var6_17 = arg0_17.building.handSlotData[var2_17]

			if var6_17 then
				var3_17 = var0_17.idle_unit
				var5_17 = var6_17:GetPlantFormulaId() or nil

				if var5_17 then
					var3_17 = var0_17.work_unit
				else
					local var7_17 = pg.island_production_slot[var2_17].exclusion_slot[1]
					local var8_17 = arg0_17.building:GetDelegationSlotData(var7_17)

					if var8_17 and not var8_17:CanStartDelegation() then
						var3_17 = var0_17.work_unit
						var4_17 = IslandProductConst.ProductSlotType.RoleDelegation
						var5_17 = var8_17:GetFormulaId()
					end
				end
			end
		end

		local var9_17 = {
			unitId = var3_17,
			typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING,
			formula_id = var5_17,
			slotId = var2_17,
			slotType = var4_17
		}
		local var10_17 = pg.island_world_objects[var1_17] or {}
		local var11_17 = arg0_17:ProductSlotObj2IslandUnit(var10_17, var9_17)

		table.insert(arg1_17, var11_17)
	end
end

function var0_0.GenAnimalBySlot(arg0_18, arg1_18)
	if not arg0_18.building then
		return
	end

	if arg0_18.productPlaceId ~= IslandProductConst.PasturePlaceId then
		return
	end

	for iter0_18, iter1_18 in pairs(arg0_18.building:GetDelegationSlotDatas()) do
		local var0_18 = pg.island_production_slot[iter0_18]
		local var1_18 = arg0_18:GetCommissionSlotId(iter0_18)
		local var2_18 = pg.island_production_commission[var1_18]

		for iter2_18, iter3_18 in ipairs(iter1_18:GetPartList()) do
			local var3_18 = pg.island_ranch_animal[iter3_18]
			local var4_18 = pg.island_world_objects[var2_18.birthplace] or {}
			local var5_18 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var4_18.param.position), 5)
			local var6_18 = {
				var5_18.x,
				var5_18.y,
				var5_18.z
			}
			local var7_18 = arg0_18:ProductAniObj2IslandUnit(var3_18, var6_18)

			table.insert(arg1_18, var7_18)
		end
	end
end

function var0_0.GenAnimalByAnialConfig(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19:GetCommissionSlotId(arg2_19)
	local var1_19 = pg.island_production_commission[var0_19]
	local var2_19 = pg.island_ranch_animal[arg1_19]
	local var3_19 = pg.island_world_objects[var1_19.birthplace] or {}
	local var4_19 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var3_19.param.position), 5)
	local var5_19 = {
		var4_19.x,
		var4_19.y,
		var4_19.z
	}

	return (arg0_19:ProductAniObj2IslandUnit(var2_19, var5_19))
end

function var0_0.GenHandPlantUnitBySlotData(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20:GetUnitIdBySlotId(arg1_20)
	local var1_20 = arg0_20.workUnitDic[var0_20]
	local var2_20 = arg2_20 and var1_20.work_unit or var1_20.idle_unit
	local var3_20 = arg0_20.unitDic[var0_20]

	if var3_20 then
		var3_20.modelId = var2_20

		var3_20:ChangeSlotType(IslandProductConst.ProductSlotType.HandPlant)
		var3_20:StartPlantGrowthTime(arg2_20)
	else
		local var4_20 = {
			unitId = var2_20,
			typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING,
			formula_id = arg2_20,
			slotId = arg1_20,
			slotType = IslandProductConst.ProductSlotType.HandPlant
		}
		local var5_20 = pg.island_world_objects[var0_20] or {}

		var3_20 = arg0_20:ProductSlotObj2IslandUnit(var5_20, var4_20)
	end

	return var3_20
end

function var0_0.GetUnitIdBySlotId(arg0_21, arg1_21)
	return arg0_21.slotToUnitDic[arg1_21]
end

function var0_0.GetUnitVOByUnitId(arg0_22, arg1_22)
	return arg0_22.unitDic[arg1_22]
end

function var0_0.ProductSlotObj2IslandUnit(arg0_23, arg1_23, arg2_23)
	arg2_23 = arg2_23 or {}

	local var0_23 = IslandProductSlotUnitVO.New({
		id = arg1_23.id,
		modelId = arg2_23.unitId or arg1_23.unitId,
		type = arg2_23.typ or arg1_23.type,
		name = arg1_23.name,
		position = arg1_23.param.position,
		rotation = arg1_23.param.rotation,
		scale = arg1_23.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_23.behaviourTree,
		isDynamic = arg1_23.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC,
		showCondition = arg1_23.show_param or {},
		hideCondition = arg1_23.hide_param or {},
		formula_id = arg2_23.formula_id,
		slotId = arg2_23.slotId,
		slotType = arg2_23.slotType,
		isSelfIsland = arg0_23.isSelf
	})

	arg0_23.unitDic[var0_23.id] = var0_23

	return var0_23
end

function var0_0.CollectSlotObj2IslandUnit(arg0_24, arg1_24, arg2_24)
	arg2_24 = arg2_24 or {}

	return (IslandCollectSlotUnitVO.New({
		id = arg1_24.id,
		modelId = arg2_24.unitId or arg1_24.unitId,
		type = arg2_24.typ or arg1_24.type,
		name = arg1_24.name,
		position = arg1_24.param.position,
		rotation = arg1_24.param.rotation,
		scale = arg1_24.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_24.behaviourTree,
		isDynamic = arg1_24.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC,
		showCondition = arg1_24.show_param or {},
		hideCondition = arg1_24.hide_param or {},
		formula_id = arg2_24.formula_id,
		slotId = arg2_24.slotId,
		slotType = arg2_24.slotType,
		isSelfIsland = arg0_24.isSelf,
		delayTime = arg2_24.delayTime
	}))
end

function var0_0.ProductAniObj2IslandUnit(arg0_25, arg1_25, arg2_25)
	return IslandUnitVO.New({
		behaviourTree = "island/nodecanvas/system/system_npc_animal",
		id = arg1_25.id,
		modelId = arg1_25.unit_id,
		type = IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION,
		name = "system_unit" .. arg1_25.id,
		position = arg2_25,
		rotation = Vector3.zero,
		scale = Vector3.one
	})
end

return var0_0
