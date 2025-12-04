local var0_0 = class("IslandProductSystemVO", import(".IslandSystemVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.isSelf = arg0_1:IsSelf(arg3_1)
	arg0_1.productPlaceId = arg1_1
	arg0_1.building = arg2_1
	arg0_1.unitDic = {}
	arg0_1.delegateSlotUnits = {}
	arg0_1.delegateUnitsId = 1
	arg0_1.commissionEffectDic = {}

	arg0_1:InitCfgData()
end

function var0_0.GetType(arg0_2)
	return IslandConst.SYSTEM_TYPE_PRODUCT
end

function var0_0.GetBehaviourTree(arg0_3)
	return nil
end

function var0_0.IsSelf(arg0_4, arg1_4)
	return getProxy(PlayerProxy):getRawData().id == arg1_4
end

function var0_0.InitCfgData(arg0_5)
	arg0_5.slotToUnitDic = {}

	arg0_5:InitCommissionCfgData()
	arg0_5:InitHandPlantCfg()
	arg0_5:InitHandCollectCfg()
	arg0_5:InitCommissionEffectCfg()
end

function var0_0.InitCommissionEffectCfg(arg0_6)
	local var0_6 = pg.island_set.island_fishery_bubble_vfx
	local var1_6 = var0_6 and var0_6.key_value_varchar or {}

	for iter0_6, iter1_6 in ipairs(var1_6) do
		arg0_6.commissionEffectDic[iter1_6[1]] = iter1_6[2]
	end
end

function var0_0.InitHandPlantCfg(arg0_7)
	local var0_7 = {
		IslandProductConst.FarmlandPlaceId,
		IslandProductConst.OrchardPlaceId,
		IslandProductConst.GardenPlaceId
	}

	if not table.contains(var0_7, arg0_7.productPlaceId) then
		return
	end

	arg0_7.workUnitDic = {}

	for iter0_7, iter1_7 in ipairs(pg.island_production_farm.get_id_list_by_place_id[arg0_7.productPlaceId] or {}) do
		local var1_7 = pg.island_production_farm[iter1_7]
		local var2_7 = var1_7.objId
		local var3_7 = var1_7.slotId

		arg0_7.slotToUnitDic[var3_7] = var2_7

		if not arg0_7.workUnitDic[var2_7] then
			arg0_7.workUnitDic[var2_7] = {}
			arg0_7.workUnitDic[var2_7].idle_unit = var1_7.idle_unit
			arg0_7.workUnitDic[var2_7].work_unit = var1_7.work_unit
		end
	end
end

function var0_0.InitHandCollectCfg(arg0_8)
	for iter0_8, iter1_8 in ipairs(pg.island_production_mining.all) do
		local var0_8 = pg.island_production_mining[iter1_8]

		if not arg0_8.slotToUnitDic[var0_8.slotId] then
			arg0_8.slotToUnitDic[var0_8.slotId] = var0_8.objId
		end
	end
end

function var0_0.GetUnitDatas(arg0_9)
	local var0_9 = {}

	arg0_9:GenHandCollectSlot(var0_9)
	arg0_9:GenHandPlantSlot(var0_9)
	arg0_9:GenAnimalBySlot(var0_9)
	arg0_9:GenPlaceSlotModelUnit(var0_9)

	return var0_9
end

function var0_0.GenPlaceSlotModelUnit(arg0_10, arg1_10)
	local var0_10 = {
		IslandProductConst.FisheryPlaceId
	}

	if not table.contains(var0_10, arg0_10.productPlaceId) then
		return
	end

	local var1_10 = pg.island_production_slot.get_id_list_by_place[arg0_10.productPlaceId] or {}

	for iter0_10, iter1_10 in ipairs(var1_10) do
		if pg.island_production_slot[iter1_10].type == 9 then
			local var2_10 = arg0_10:GetCommissionSlotId(iter1_10)
			local var3_10 = pg.island_production_commission[var2_10].unlockObjid

			if var3_10 ~= 0 and (arg0_10.building == nil or arg0_10.building:GetDelegationSlotData(iter1_10) == nil) then
				local var4_10 = pg.island_world_objects[var3_10]
				local var5_10 = IslandDataConvertor.WorldObj2IslandUnit(var4_10)

				table.insert(arg1_10, var5_10)
			end
		end
	end
end

function var0_0.GenPlaceModelUnit(arg0_11, arg1_11)
	if not table.contains(IslandProductConst.haveModelPlaces, arg0_11.productPlaceId) then
		return
	end

	local var0_11 = arg0_11.building ~= nil
	local var1_11 = arg0_11:GetPlaceModelUnit(var0_11)

	table.insert(arg1_11, var1_11)
end

function var0_0.GetPlaceModelId(arg0_12, arg1_12)
	if arg1_12 then
		return pg.island_production_place[arg0_12.productPlaceId].unlocked_obj
	else
		return pg.island_production_place[arg0_12.productPlaceId].locked_obj
	end
end

function var0_0.GetPlaceModelUnit(arg0_13, arg1_13)
	local var0_13 = arg0_13:GetPlaceModelId(arg1_13)
	local var1_13 = pg.island_world_objects[var0_13]

	return IslandDataConvertor.WorldObj2IslandUnit(var1_13)
end

function var0_0.InitCommissionCfgData(arg0_14)
	arg0_14.slotCommissionDic = {}

	local var0_14 = pg.island_production_place[arg0_14.productPlaceId].commission_slot

	for iter0_14, iter1_14 in ipairs(var0_14) do
		local var1_14 = pg.island_production_commission[iter1_14]

		arg0_14.slotCommissionDic[var1_14.slot] = iter1_14
	end
end

function var0_0.GetCommissionSlotId(arg0_15, arg1_15)
	return arg0_15.slotCommissionDic[arg1_15]
end

function var0_0.GenHandCollectSlot(arg0_16, arg1_16)
	if not arg0_16.building or not arg0_16.isSelf then
		return
	end

	arg0_16:GenHandCollectSlotInSlotPlace(arg1_16)
end

function var0_0.GenHandCollectSlotInSlotPlace(arg0_17, arg1_17)
	local var0_17 = arg0_17.building:GetBuildingCollectData()

	if not var0_17 then
		return
	end

	local var1_17 = var0_17:GetCollectSlotDatasDic()

	for iter0_17, iter1_17 in pairs(var1_17) do
		local var2_17 = arg0_17:GenHandCollectSlotByDataNew(iter1_17)

		if var2_17 then
			table.insert(arg1_17, var2_17)
		end
	end
end

function var0_0.GetHandCollectSlotBySlotId(arg0_18, arg1_18)
	local var0_18 = (arg0_18.building or (arg0_18.isSelf and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetBuildingAgency():GetBuilding(arg0_18.productPlaceId)):GetBuildingCollectData():GetCollectSlotData(arg1_18)

	return arg0_18.slotToUnitDic[var0_18.configId]
end

function var0_0.GenHandCollectSlotByDataNew(arg0_19, arg1_19)
	local var0_19 = arg0_19.productPlaceId == IslandProductConst.FellingPlaceId
	local var1_19 = arg0_19.slotToUnitDic[arg1_19.configId]
	local var2_19 = pg.island_production_slot[arg1_19.configId].formula[1]
	local var3_19 = pg.island_formula[var2_19].unitid[1][2]

	if arg1_19:GetCanCollectTimeStamps() == 0 or var0_19 then
		local var4_19 = {
			unitId = var3_19,
			typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT,
			slotId = arg1_19.configId
		}
		local var5_19 = pg.island_world_objects[var1_19] or {}

		return (arg0_19:CollectSlotObj2IslandUnit(var5_19, var4_19))
	end
end

function var0_0.InitHandCollectSlotBySlotId(arg0_20, arg1_20)
	local var0_20 = (arg0_20.building or (arg0_20.isSelf and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetBuildingAgency():GetBuilding(arg0_20.productPlaceId)):GetCollectSlotData(arg1_20)

	return arg0_20:GenHandCollectSlotByDataNew(var0_20)
end

function var0_0.GenHandPlantSlot(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(pg.island_production_farm.get_id_list_by_place_id[arg0_21.productPlaceId] or {}) do
		local var0_21 = pg.island_production_farm[iter1_21]
		local var1_21 = var0_21.objId
		local var2_21 = var0_21.slotId
		local var3_21 = var0_21.unlock_unit
		local var4_21 = IslandProductConst.ProductSlotType.HandPlant
		local var5_21

		if arg0_21.building then
			local var6_21 = arg0_21.building.handSlotData[var2_21]

			if var6_21 then
				var3_21 = var0_21.idle_unit
				var5_21 = var6_21:GetPlantFormulaId() or nil

				if var5_21 then
					var3_21 = var0_21.work_unit
				else
					local var7_21 = pg.island_production_slot[var2_21].exclusion_slot[1]
					local var8_21 = arg0_21.building:GetDelegationSlotData(var7_21)

					if var8_21 and not var8_21:CanStartDelegation() then
						var3_21 = var0_21.work_unit
						var4_21 = IslandProductConst.ProductSlotType.RoleDelegation
						var5_21 = var8_21:GetFormulaId()
					end
				end
			end
		end

		local var9_21 = {
			unitId = var3_21,
			typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING,
			formula_id = var5_21,
			slotId = var2_21,
			slotType = var4_21
		}
		local var10_21 = pg.island_world_objects[var1_21] or {}
		local var11_21 = arg0_21:ProductSlotObj2IslandUnit(var10_21, var9_21)

		table.insert(arg1_21, var11_21)
	end
end

function var0_0.GenAnimalBySlot(arg0_22, arg1_22)
	if not arg0_22.building then
		return
	end

	if arg0_22.productPlaceId ~= IslandProductConst.PasturePlaceId then
		return
	end

	for iter0_22, iter1_22 in pairs(arg0_22.building:GetDelegationSlotDatas()) do
		local var0_22 = pg.island_production_slot[iter0_22]
		local var1_22 = arg0_22:GetCommissionSlotId(iter0_22)
		local var2_22 = pg.island_production_commission[var1_22]

		for iter2_22, iter3_22 in ipairs(iter1_22:GetPartList()) do
			local var3_22 = pg.island_ranch_animal[iter3_22]
			local var4_22 = pg.island_world_objects[var2_22.birthplace] or {}
			local var5_22 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var4_22.param.position), 5)
			local var6_22 = {
				var5_22.x,
				var5_22.y,
				var5_22.z
			}
			local var7_22 = arg0_22:ProductAniObj2IslandUnit(var3_22, var6_22)

			table.insert(arg1_22, var7_22)
		end
	end
end

function var0_0.GenAnimalByAnialConfig(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23:GetCommissionSlotId(arg2_23)
	local var1_23 = pg.island_production_commission[var0_23]
	local var2_23 = pg.island_ranch_animal[arg1_23]
	local var3_23 = pg.island_world_objects[var1_23.birthplace] or {}
	local var4_23 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var3_23.param.position), 5)
	local var5_23 = {
		var4_23.x,
		var4_23.y,
		var4_23.z
	}

	return (arg0_23:ProductAniObj2IslandUnit(var2_23, var5_23))
end

function var0_0.GenHandPlantUnitBySlotData(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24:GetUnitIdBySlotId(arg1_24)
	local var1_24 = arg0_24.workUnitDic[var0_24]
	local var2_24 = arg2_24 and var1_24.work_unit or var1_24.idle_unit
	local var3_24 = arg0_24.unitDic[var0_24]

	if var3_24 then
		var3_24.modelId = var2_24

		var3_24:ChangeSlotType(IslandProductConst.ProductSlotType.HandPlant)
		var3_24:StartPlantGrowthTime(arg2_24)
	else
		local var4_24 = {
			unitId = var2_24,
			typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING,
			formula_id = arg2_24,
			slotId = arg1_24,
			slotType = IslandProductConst.ProductSlotType.HandPlant
		}
		local var5_24 = pg.island_world_objects[var0_24] or {}

		var3_24 = arg0_24:ProductSlotObj2IslandUnit(var5_24, var4_24)
	end

	return var3_24
end

function var0_0.GetUnitIdBySlotId(arg0_25, arg1_25)
	return arg0_25.slotToUnitDic[arg1_25]
end

function var0_0.GetUnitVOByUnitId(arg0_26, arg1_26)
	return arg0_26.unitDic[arg1_26]
end

function var0_0.ProductSlotObj2IslandUnit(arg0_27, arg1_27, arg2_27)
	arg2_27 = arg2_27 or {}

	local var0_27 = IslandProductSlotUnitVO.New({
		id = arg1_27.id,
		modelId = arg2_27.unitId or arg1_27.unitId,
		type = arg2_27.typ or arg1_27.type,
		name = arg1_27.name,
		position = arg1_27.param.position,
		rotation = arg1_27.param.rotation,
		scale = arg1_27.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_27.behaviourTree,
		isDynamic = arg1_27.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC,
		showCondition = arg1_27.show_param or {},
		hideCondition = arg1_27.hide_param or {},
		formula_id = arg2_27.formula_id,
		slotId = arg2_27.slotId,
		slotType = arg2_27.slotType,
		isSelfIsland = arg0_27.isSelf
	})

	arg0_27.unitDic[var0_27.id] = var0_27

	return var0_27
end

function var0_0.CollectSlotObj2IslandUnit(arg0_28, arg1_28, arg2_28)
	arg2_28 = arg2_28 or {}

	return (IslandCollectSlotUnitVO.New({
		id = arg1_28.id,
		modelId = arg2_28.unitId or arg1_28.unitId,
		type = arg2_28.typ or arg1_28.type,
		name = arg1_28.name,
		position = arg1_28.param.position,
		rotation = arg1_28.param.rotation,
		scale = arg1_28.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_28.behaviourTree,
		isDynamic = arg1_28.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC,
		showCondition = arg1_28.show_param or {},
		hideCondition = arg1_28.hide_param or {},
		formula_id = arg2_28.formula_id,
		slotId = arg2_28.slotId,
		slotType = arg2_28.slotType,
		isSelfIsland = arg0_28.isSelf
	}))
end

function var0_0.ProductAniObj2IslandUnit(arg0_29, arg1_29, arg2_29)
	return IslandUnitVO.New({
		behaviourTree = "island/nodecanvas/system/system_npc_animal",
		id = arg1_29.id,
		modelId = arg1_29.unit_id,
		type = IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION,
		name = "system_unit" .. arg1_29.id,
		position = arg2_29,
		rotation = Vector3.zero,
		scale = Vector3.one
	})
end

function var0_0.GetDelegateUnitsByBuildIdAndSlotId(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = {}

	switch(arg1_30, {
		[IslandProductConst.FisheryPlaceId] = function()
			var0_30 = arg0_30:GetDelegateFishUnits(arg2_30, arg3_30)
		end
	})

	return var0_30
end

function var0_0.GetDelegateEffectsByCommissonId(arg0_32, arg1_32)
	local var0_32 = arg0_32:GetCommissionSlotId(arg1_32)

	return arg0_32.commissionEffectDic[var0_32]
end

function var0_0.GenUnitByDelegateEffectId(arg0_33, arg1_33)
	local var0_33 = pg.island_world_objects[arg1_33]

	if var0_33 then
		local var1_33 = {
			typ = IslandConst.UNIT_TYPE_ITEM
		}

		return (IslandDataConvertor.WorldObj2IslandUnit(var0_33, var1_33))
	end
end

function var0_0.GetDelegateFishUnits(arg0_34, arg1_34, arg2_34)
	local var0_34 = {}
	local var1_34 = arg0_34:GetCommissionSlotId(arg1_34)
	local var2_34 = pg.island_production_commission[var1_34]
	local var3_34 = pg.island_formula[arg2_34]
	local var4_34 = var3_34.unitid[1][1]
	local var5_34 = pg.island_world_objects[var2_34.performanceObjid]
	local var6_34 = math.random(var3_34.unitid[2][1], var3_34.unitid[2][2])
	local var7_34 = var3_34.unitid[2][3]

	for iter0_34 = 1, var6_34 do
		local var8_34 = arg0_34.delegateUnitsId

		arg0_34.delegateSlotUnits[var1_34] = arg0_34.delegateSlotUnits[var1_34] or {}

		table.insert(arg0_34.delegateSlotUnits[var1_34], var8_34)

		arg0_34.delegateUnitsId = arg0_34.delegateUnitsId + 1

		local var9_34 = arg0_34:GenDelegateFishUnit(var8_34, var4_34, var5_34, var7_34)

		table.insert(var0_34, var9_34)
	end

	return var0_34
end

function var0_0.GetDelegatUnitsBySlotId(arg0_35, arg1_35)
	local var0_35 = arg0_35:GetCommissionSlotId(arg1_35)

	return arg0_35.delegateSlotUnits[var0_35] or {}
end

function var0_0.GetDelegateSlotUnits(arg0_36)
	return arg0_36.delegateSlotUnits
end

function var0_0.GenDelegateFishUnit(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	return IslandDelegateFishVO.New({
		behaviourTree = "",
		id = arg1_37,
		modelId = arg2_37,
		type = IslandConst.UNIT_TYPE_DELEGATE_FISH,
		name = pg.island_unit_character[arg2_37].id,
		position = arg3_37.param.position,
		rotation = Vector3.zero,
		scale = Vector3.one,
		speed = arg4_37
	})
end

return var0_0
