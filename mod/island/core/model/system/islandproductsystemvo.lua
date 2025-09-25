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
	local var1_7 = arg0_7:GetPlaceModelId(var0_7)
	local var2_7 = pg.island_world_objects[var1_7]

	table.insert(arg1_7, IslandDataConvertor.WorldObj2IslandUnit(var2_7))
end

function var0_0.GetPlaceModelId(arg0_8, arg1_8)
	if arg1_8 then
		return pg.island_production_place[arg0_8.productPlaceId].unlocked_obj
	else
		return pg.island_production_place[arg0_8.productPlaceId].locked_obj
	end
end

function var0_0.InitCommissionCfgData(arg0_9)
	arg0_9.slotCommissionDic = {}

	local var0_9 = pg.island_production_place[arg0_9.productPlaceId].commission_slot

	for iter0_9, iter1_9 in ipairs(var0_9) do
		local var1_9 = pg.island_production_commission[iter1_9]

		arg0_9.slotCommissionDic[var1_9.slot] = iter1_9
	end
end

function var0_0.GetCommissionSlotId(arg0_10, arg1_10)
	return arg0_10.slotCommissionDic[arg1_10]
end

function var0_0.GenHandCollectSlot(arg0_11, arg1_11)
	if not arg0_11.building then
		return
	end

	arg0_11:GenHandCollectSlotInSlotPlace(arg1_11)
end

function var0_0.GenHandCollectSlotInSlotPlace(arg0_12, arg1_12)
	local var0_12 = arg0_12.building:GetBuildingCollectData()

	if not var0_12 then
		return
	end

	local var1_12 = var0_12:GetCollectSlotDatasDic()

	for iter0_12, iter1_12 in pairs(var1_12) do
		local var2_12 = arg0_12:GenHandCollectSlotByDataNew(iter1_12)

		table.insert(arg1_12, var2_12)
	end
end

function var0_0.GetHandCollectSlotBySlotId(arg0_13, arg1_13)
	local var0_13 = (arg0_13.building or (arg0_13.isSelf and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetBuildingAgency():GetBuilding(arg0_13.productPlaceId)):GetBuildingCollectData():GetCollectSlotData(arg1_13)

	return arg0_13.productPlaceId == IslandProductConst.MinePlaceId and var0_13.pos or arg0_13.slotToUnitDic[var0_13.configId]
end

function var0_0.GenHandCollectSlotByDataNew(arg0_14, arg1_14)
	local var0_14 = arg0_14.productPlaceId == IslandProductConst.MinePlaceId
	local var1_14 = var0_14 and arg1_14.pos or arg0_14.slotToUnitDic[arg1_14.configId]
	local var2_14 = pg.island_production_slot[arg1_14.configId].formula[1]
	local var3_14 = pg.island_formula[var2_14].unitid[1][2]
	local var4_14
	local var5_14 = arg1_14:GetCanCollectTimeStamps()

	if var5_14 ~= 0 and var0_14 then
		var4_14 = var5_14 - pg.TimeMgr.GetInstance():GetServerTime()
	end

	local var6_14 = {
		unitId = var3_14,
		typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT,
		slotId = arg1_14.configId,
		delayTime = var4_14
	}
	local var7_14 = pg.island_world_objects[var1_14] or {}

	return (arg0_14:CollectSlotObj2IslandUnit(var7_14, var6_14))
end

function var0_0.InitHandCollectSlotBySlotId(arg0_15, arg1_15)
	local var0_15 = (arg0_15.building or (arg0_15.isSelf and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetBuildingAgency():GetBuilding(arg0_15.productPlaceId)):GetCollectSlotData(arg1_15)

	return arg0_15:GenHandCollectSlotByDataNew(var0_15)
end

function var0_0.GenHandPlantSlot(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(pg.island_production_farm.get_id_list_by_place_id[arg0_16.productPlaceId] or {}) do
		local var0_16 = pg.island_production_farm[iter1_16]
		local var1_16 = var0_16.objId
		local var2_16 = var0_16.slotId
		local var3_16 = var0_16.unlock_unit
		local var4_16 = IslandProductConst.ProductSlotType.HandPlant
		local var5_16

		if arg0_16.building then
			local var6_16 = arg0_16.building.handSlotData[var2_16]

			if var6_16 then
				var3_16 = var0_16.idle_unit
				var5_16 = var6_16:GetPlantFormulaId() or nil

				if var5_16 then
					var3_16 = var0_16.work_unit
				else
					local var7_16 = pg.island_production_slot[var2_16].exclusion_slot[1]
					local var8_16 = arg0_16.building:GetDelegationSlotData(var7_16)

					if var8_16 and not var8_16:CanStartDelegation() then
						var3_16 = var0_16.work_unit
						var4_16 = IslandProductConst.ProductSlotType.RoleDelegation
						var5_16 = var8_16:GetFormulaId()
					end
				end
			end
		end

		local var9_16 = {
			unitId = var3_16,
			typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING,
			formula_id = var5_16,
			slotId = var2_16,
			slotType = var4_16
		}
		local var10_16 = pg.island_world_objects[var1_16] or {}
		local var11_16 = arg0_16:ProductSlotObj2IslandUnit(var10_16, var9_16)

		table.insert(arg1_16, var11_16)
	end
end

function var0_0.GenAnimalBySlot(arg0_17, arg1_17)
	if not arg0_17.building then
		return
	end

	if arg0_17.productPlaceId ~= IslandProductConst.PasturePlaceId then
		return
	end

	for iter0_17, iter1_17 in pairs(arg0_17.building:GetDelegationSlotDatas()) do
		local var0_17 = pg.island_production_slot[iter0_17]
		local var1_17 = arg0_17:GetCommissionSlotId(iter0_17)
		local var2_17 = pg.island_production_commission[var1_17]

		for iter2_17, iter3_17 in ipairs(iter1_17:GetPartList()) do
			local var3_17 = pg.island_ranch_animal[iter3_17]
			local var4_17 = pg.island_world_objects[var2_17.birthplace] or {}
			local var5_17 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var4_17.param.position), 5)
			local var6_17 = {
				var5_17.x,
				var5_17.y,
				var5_17.z
			}
			local var7_17 = arg0_17:ProductAniObj2IslandUnit(var3_17, var6_17)

			table.insert(arg1_17, var7_17)
		end
	end
end

function var0_0.GenAnimalByAnialConfig(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18:GetCommissionSlotId(arg2_18)
	local var1_18 = pg.island_production_commission[var0_18]
	local var2_18 = pg.island_ranch_animal[arg1_18]
	local var3_18 = pg.island_world_objects[var1_18.birthplace] or {}
	local var4_18 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var3_18.param.position), 5)
	local var5_18 = {
		var4_18.x,
		var4_18.y,
		var4_18.z
	}

	return (arg0_18:ProductAniObj2IslandUnit(var2_18, var5_18))
end

function var0_0.GenHandPlantUnitBySlotData(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19:GetUnitIdBySlotId(arg1_19)
	local var1_19 = arg0_19.workUnitDic[var0_19]
	local var2_19 = arg2_19 and var1_19.work_unit or var1_19.idle_unit
	local var3_19 = arg0_19.unitDic[var0_19]

	if var3_19 then
		var3_19.modelId = var2_19

		var3_19:ChangeSlotType(IslandProductConst.ProductSlotType.HandPlant)
		var3_19:StartPlantGrowthTime(arg2_19)
	else
		local var4_19 = {
			unitId = var2_19,
			typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING,
			formula_id = arg2_19,
			slotId = arg1_19,
			slotType = IslandProductConst.ProductSlotType.HandPlant
		}
		local var5_19 = pg.island_world_objects[var0_19] or {}

		var3_19 = arg0_19:ProductSlotObj2IslandUnit(var5_19, var4_19)
	end

	return var3_19
end

function var0_0.GetUnitIdBySlotId(arg0_20, arg1_20)
	return arg0_20.slotToUnitDic[arg1_20]
end

function var0_0.GetUnitVOByUnitId(arg0_21, arg1_21)
	return arg0_21.unitDic[arg1_21]
end

function var0_0.ProductSlotObj2IslandUnit(arg0_22, arg1_22, arg2_22)
	arg2_22 = arg2_22 or {}

	local var0_22 = IslandProductSlotUnitVO.New({
		id = arg1_22.id,
		modelId = arg2_22.unitId or arg1_22.unitId,
		type = arg2_22.typ or arg1_22.type,
		name = arg1_22.name,
		position = arg1_22.param.position,
		rotation = arg1_22.param.rotation,
		scale = arg1_22.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_22.behaviourTree,
		isDynamic = arg1_22.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC,
		showCondition = arg1_22.show_param or {},
		hideCondition = arg1_22.hide_param or {},
		formula_id = arg2_22.formula_id,
		slotId = arg2_22.slotId,
		slotType = arg2_22.slotType,
		isSelfIsland = arg0_22.isSelf
	})

	arg0_22.unitDic[var0_22.id] = var0_22

	return var0_22
end

function var0_0.CollectSlotObj2IslandUnit(arg0_23, arg1_23, arg2_23)
	arg2_23 = arg2_23 or {}

	return (IslandCollectSlotUnitVO.New({
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
		isSelfIsland = arg0_23.isSelf,
		delayTime = arg2_23.delayTime
	}))
end

function var0_0.ProductAniObj2IslandUnit(arg0_24, arg1_24, arg2_24)
	return IslandUnitVO.New({
		behaviourTree = "island/nodecanvas/system/system_npc_animal",
		id = arg1_24.id,
		modelId = arg1_24.unit_id,
		type = IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION,
		name = "system_unit" .. arg1_24.id,
		position = arg2_24,
		rotation = Vector3.zero,
		scale = Vector3.one
	})
end

return var0_0
