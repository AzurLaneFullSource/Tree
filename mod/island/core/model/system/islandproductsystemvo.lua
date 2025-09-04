local var0_0 = class("IslandProductSystemVO", import(".IslandSystemVO"))

var0_0.FarmlandPlaceId = 101
var0_0.PasturePlaceId = 102
var0_0.MilkTeaPlaceId = 601
var0_0.MealPlaceId = 602
var0_0.MinePlaceId = 401
var0_0.FellingPlaceId = 402
var0_0.TechnologyPlaceId = 702
var0_0.CoffeePlaceId = 901
var0_0.SlotType = {
	HandPlant = 2,
	HandCollect = 1,
	RoleDelegation = 3
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.isSelf = arg0_1:IsSelf(arg3_1)
	arg0_1.productId = arg1_1
	arg0_1.building = arg2_1
	arg0_1.slotUnitDic = {}

	arg0_1:InitCfgData()
end

function var0_0.IsSelf(arg0_2, arg1_2)
	return getProxy(PlayerProxy):getRawData().id == arg1_2
end

function var0_0.InitCfgData(arg0_3)
	arg0_3.cfgData = {}
	arg0_3.slotDic = {}

	arg0_3:InitCommissionCfgData()
	arg0_3:InitHandPlantCfg()
	arg0_3:InitHandCollectCfg()
end

function var0_0.InitHandPlantCfg(arg0_4)
	if arg0_4.productId ~= var0_0.FarmlandPlaceId then
		return
	end

	for iter0_4, iter1_4 in ipairs(pg.island_production_farm.all) do
		local var0_4 = pg.island_production_farm[iter1_4]
		local var1_4 = var0_4.objId
		local var2_4 = var0_4.slotId

		arg0_4.cfgData[var2_4] = var1_4
	end
end

function var0_0.InitHandCollectCfg(arg0_5)
	if arg0_5.productId == var0_0.MinePlaceId then
		return
	end

	for iter0_5, iter1_5 in ipairs(pg.island_production_mining.all) do
		local var0_5 = pg.island_production_mining[iter1_5]

		if not arg0_5.cfgData[var0_5.slotId] then
			arg0_5.cfgData[var0_5.slotId] = var0_5.objId
		end
	end
end

function var0_0.GetUnitDatas(arg0_6)
	local var0_6 = {}

	arg0_6:GenHandCollectSlot(var0_6)
	arg0_6:GenHandPlantSlot(var0_6)
	arg0_6:GenAnimalBySlot(var0_6)

	return var0_6
end

function var0_0.InitCommissionCfgData(arg0_7)
	local var0_7 = pg.island_production_place[arg0_7.productId].commission_slot

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var1_7 = pg.island_production_commission[iter1_7]

		arg0_7.slotDic[var1_7.slot] = iter1_7
	end
end

function var0_0.GetCommissionSlotId(arg0_8, arg1_8)
	return arg0_8.slotDic[arg1_8]
end

function var0_0.GenHandCollectSlot(arg0_9, arg1_9)
	if not arg0_9.building then
		return
	end

	if arg0_9.productId ~= var0_0.MinePlaceId then
		for iter0_9, iter1_9 in pairs(arg0_9.building:GetCollectSlotDatas()) do
			local var0_9 = arg0_9.cfgData[iter1_9.configId]
			local var1_9 = pg.island_production_slot[iter1_9.configId].formula[1]
			local var2_9 = pg.island_formula[var1_9].unitid[1][2]
			local var3_9 = {
				unitId = var2_9,
				typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT,
				formula_id = var1_9,
				slotId = iter1_9.configId,
				slotType = var0_0.SlotType.HandCollect
			}
			local var4_9 = pg.island_world_objects[var0_9] or {}
			local var5_9 = arg0_9:ProductSlotObj2IslandUnit(var4_9, var3_9)

			table.insert(arg1_9, var5_9)
		end

		return
	end

	for iter2_9, iter3_9 in pairs(arg0_9.building:GetCollectSlotDatas()) do
		if iter3_9:GetCanCollectTime() ~= 0 then
			local var6_9 = iter3_9.pos
			local var7_9 = pg.island_production_slot[iter3_9.configId].formula[1]
			local var8_9 = pg.island_formula[var7_9].unitid[1][2]
			local var9_9 = {
				unitId = var8_9,
				typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT,
				formula_id = var7_9,
				slotId = iter3_9.configId,
				slotType = var0_0.SlotType.HandCollect
			}
			local var10_9 = pg.island_world_objects[var6_9] or {}
			local var11_9 = arg0_9:ProductSlotObj2IslandUnit(var10_9, var9_9)

			table.insert(arg1_9, var11_9)
		else
			iter3_9:SetNeedLoadModel()
		end
	end
end

function var0_0.GenHandPlantSlot(arg0_10, arg1_10)
	if arg0_10.productId == var0_0.FarmlandPlaceId then
		for iter0_10, iter1_10 in ipairs(pg.island_production_farm.all) do
			local var0_10 = pg.island_production_farm[iter1_10]
			local var1_10 = var0_10.objId
			local var2_10 = var0_10.slotId
			local var3_10
			local var4_10
			local var5_10
			local var6_10

			if not arg0_10.building then
				var3_10 = var0_10.unlock_unit
				var5_10 = var0_0.SlotType.HandPlant
			else
				local var7_10 = arg0_10.building.handSlotData[var2_10]

				if not var7_10 then
					var3_10 = var0_10.unlock_unit
					var5_10 = var0_0.SlotType.HandPlant
				else
					var6_10 = var7_10:GetPlantFormulaId() or nil

					if var6_10 then
						var3_10 = var0_10.work_unit
						var5_10 = var0_0.SlotType.HandPlant
					else
						local var8_10 = pg.island_production_slot[var2_10].exclusion_slot[1]
						local var9_10 = arg0_10.building:GetDelegationSlotData(var8_10)

						if not var9_10 then
							var3_10 = var0_10.idle_unit
							var5_10 = var0_0.SlotType.HandPlant
						elseif var9_10:CanStartDelegation() then
							var3_10 = var0_10.idle_unit
							var5_10 = var0_0.SlotType.HandPlant
						else
							var3_10 = var0_10.work_unit
							var5_10 = var0_0.SlotType.RoleDelegation
							var6_10 = var9_10:GetFormulaId()
						end
					end
				end
			end

			local var10_10 = {
				unitId = var3_10,
				typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING,
				formula_id = var6_10,
				slotId = var2_10,
				slotType = var5_10
			}
			local var11_10 = pg.island_world_objects[var1_10] or {}
			local var12_10 = arg0_10:ProductSlotObj2IslandUnit(var11_10, var10_10)

			table.insert(arg1_10, var12_10)
		end
	end
end

function var0_0.GenAnimalBySlot(arg0_11, arg1_11)
	if not arg0_11.building then
		return
	end

	if arg0_11.productId ~= var0_0.PasturePlaceId then
		return
	end

	for iter0_11, iter1_11 in pairs(arg0_11.building:GetDelegationSlotDatas()) do
		local var0_11 = pg.island_production_slot[iter0_11]
		local var1_11 = arg0_11:GetCommissionSlotId(iter0_11)
		local var2_11 = pg.island_production_commission[var1_11]

		for iter2_11, iter3_11 in ipairs(iter1_11:GetPartList()) do
			local var3_11 = pg.island_ranch_animal[iter3_11]
			local var4_11 = pg.island_world_objects[var2_11.birthplace] or {}
			local var5_11 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var4_11.param.position), 5)
			local var6_11 = {
				var5_11.x,
				var5_11.y,
				var5_11.z
			}
			local var7_11 = arg0_11:ProductAniObj2IslandUnit(var3_11, var6_11)

			table.insert(arg1_11, var7_11)
		end
	end
end

function var0_0.GenAnimalByAnialConfig(arg0_12, arg1_12, arg2_12)
	local var0_12 = pg.island_production_slot[arg2_12]
	local var1_12 = arg0_12:GetCommissionSlotId(arg2_12)
	local var2_12 = pg.island_production_commission[var1_12]
	local var3_12 = pg.island_ranch_animal[arg1_12]
	local var4_12 = pg.island_world_objects[var2_12.birthplace] or {}
	local var5_12 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var4_12.param.position), 5)
	local var6_12 = {
		var5_12.x,
		var5_12.y,
		var5_12.z
	}

	return (arg0_12:ProductAniObj2IslandUnit(var3_12, var6_12))
end

function var0_0.GenHandPlantUnitBySlotData(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg2_13 and 1002 or 1001
	local var1_13 = arg0_13:GetUnitIdBySlotId(arg1_13)
	local var2_13 = arg0_13.slotUnitDic[var1_13]

	if var2_13 then
		var2_13.modelId = var0_13

		var2_13:ChangeSlotType(var0_0.SlotType.HandPlant)
		var2_13:SetHandPlantFormulaid(arg2_13)
		var2_13:InitGrowthTime()
		var2_13:InitProductModelId()
	else
		local var3_13 = {
			unitId = var0_13,
			typ = IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING,
			formula_id = arg2_13,
			slotId = arg1_13,
			slotType = var0_0.SlotType.HandPlant
		}
		local var4_13 = pg.island_world_objects[var1_13] or {}

		var2_13 = arg0_13:ProductSlotObj2IslandUnit(var4_13, var3_13)
	end

	return var2_13
end

function var0_0.GetUnitIdBySlotId(arg0_14, arg1_14)
	return arg0_14.cfgData[arg1_14]
end

function var0_0.GetUnitVOByUnitId(arg0_15, arg1_15)
	return arg0_15.slotUnitDic[arg1_15]
end

function var0_0.ProductSlotObj2IslandUnit(arg0_16, arg1_16, arg2_16)
	arg2_16 = arg2_16 or {}

	local var0_16 = IslandSlotUnitVO.New({
		id = arg1_16.id,
		modelId = arg2_16.unitId or arg1_16.unitId,
		type = arg2_16.typ or arg1_16.type,
		name = arg1_16.name,
		position = arg1_16.param.position,
		rotation = arg1_16.param.rotation,
		scale = arg1_16.param.scale or {
			1,
			1,
			1
		},
		behaviourTree = arg1_16.behaviourTree,
		isDynamic = arg1_16.gen_type == IslandConst.UNIT_GEN_TYPE_DYNAMIC,
		showCondition = arg1_16.show_param or {},
		hideCondition = arg1_16.hide_param or {},
		formula_id = arg2_16.formula_id,
		slotId = arg2_16.slotId,
		slotType = arg2_16.slotType,
		isSelfIsland = arg0_16.isSelf
	})

	arg0_16.slotUnitDic[var0_16.id] = var0_16

	return var0_16
end

function var0_0.ProductAniObj2IslandUnit(arg0_17, arg1_17, arg2_17)
	return IslandUnitVO.New({
		behaviourTree = "island/nodecanvas/system/system_npc_animal",
		id = arg1_17.id,
		modelId = arg1_17.unit_id,
		type = IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION,
		name = "system_unit" .. arg1_17.id,
		position = arg2_17,
		rotation = Vector3.zero,
		scale = Vector3.one
	})
end

return var0_0
