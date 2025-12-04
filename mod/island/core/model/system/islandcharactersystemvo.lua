local var0_0 = class("IslandCharacterSystemVO", import(".IslandSystemVO"))
local var1_0 = 0
local var2_0 = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.isSelf = arg0_1:IsSelf(arg3_1)
	arg0_1.id = arg1_1
	arg0_1.name = "_system_" .. arg0_1.id
	arg0_1.slotDic = {}

	arg0_1:InitCfgData(arg0_1.id)

	arg0_1.config = pg.island_production_place[arg0_1.id]
	arg0_1.behaviourTree = arg0_1.config.behaviourTree
	arg0_1.worker = 0
	arg0_1.productSystem = arg2_1
	arg0_1.chickenId = arg2_1.id % 10 * 100 + 1
	arg0_1.slotShipUnitDic = {}
end

function var0_0.IsSelf(arg0_2, arg1_2)
	return getProxy(PlayerProxy):getRawData().id == arg1_2
end

function var0_0.GetType(arg0_3)
	return IslandConst.SYSTEM_TYPE_CHARACTER
end

function var0_0.InitCfgData(arg0_4, arg1_4)
	local var0_4 = pg.island_production_place[arg1_4].commission_slot

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var1_4 = pg.island_production_commission[iter1_4]

		arg0_4.slotDic[var1_4.slot] = iter1_4
	end
end

function var0_0.GetUnit(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg0_5.slotDic[arg2_5]
	local var1_5 = pg.island_production_commission[var0_5]
	local var2_5 = pg.island_world_objects[var1_5.birthplace]

	if not var2_5 then
		return nil
	end

	local var3_5
	local var4_5

	if arg0_5.config.interactionType == var1_0 and not arg3_5 then
		local var5_5 = arg0_5:GetObjId(arg2_5)
		local var6_5 = pg.island_world_objects[var5_5]
		local var7_5 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var6_5.param.position), 2)

		var3_5 = {
			var7_5.x,
			var7_5.y,
			var7_5.z
		}
	else
		var3_5 = var2_5.param.position
		var4_5 = var2_5.param.rotation
	end

	local var8_5

	if arg0_5.isSelf then
		var8_5 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_5):GetModelUnit()
	else
		var8_5 = pg.island_chara_template[arg1_5].unit_id
	end

	local var9_5 = arg1_5 == 1 and arg0_5.config.chickenbehaviourTree or arg0_5.config.npcbehaviourTree
	local var10_5 = false

	if arg1_5 == 1 then
		arg0_5.chickenId = arg0_5.chickenId + 1
		arg1_5 = arg0_5.chickenId
		arg0_5.slotShipUnitDic[arg2_5] = arg1_5
		var10_5 = true
	end

	return IslandDelegateUnitVO.New({
		id = arg1_5,
		isChicken = var10_5,
		modelId = var8_5,
		type = IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION,
		name = "system_unit" .. arg1_5,
		position = var3_5,
		rotation = var4_5 or Vector3.zero,
		scale = Vector3.one,
		behaviourTree = var9_5
	})
end

function var0_0.GetUnitShipIdBySlotId(arg0_6, arg1_6, arg2_6)
	if arg1_6 == 1 then
		return arg0_6.slotShipUnitDic[arg2_6]
	end

	return arg1_6
end

function var0_0.GetObjId(arg0_7, arg1_7)
	local var0_7 = arg0_7.slotDic[arg1_7]

	return pg.island_production_commission[var0_7].performanceObjid
end

function var0_0.GetperformanceObjidList(arg0_8, arg1_8)
	local var0_8 = {}
	local var1_8 = {
		IslandProductConst.FarmlandPlaceId,
		IslandProductConst.OrchardPlaceId,
		IslandProductConst.GardenPlaceId
	}
	local var2_8 = {
		IslandProductConst.MinePlaceId,
		IslandProductConst.FellingPlaceId,
		IslandProductConst.TechnologyPlaceId,
		IslandProductConst.FisheryPlaceId
	}

	if table.contains(var1_8, arg0_8.id) then
		local var3_8 = pg.island_production_slot[arg1_8]

		for iter0_8, iter1_8 in ipairs(var3_8.exclusion_slot) do
			local var4_8 = arg0_8.productSystem:GetUnitIdBySlotId(iter1_8)
			local var5_8 = {
				unitId = var4_8,
				unitType = IslandConst.UNIT_LIST_OBJ
			}

			table.insert(var0_8, var5_8)
		end
	elseif table.contains(var2_8, arg0_8.id) then
		local var6_8 = arg0_8.slotDic[arg1_8]
		local var7_8 = pg.island_production_commission[var6_8]
		local var8_8 = {
			unitId = var7_8.performanceObjid,
			unitType = IslandConst.UNIT_LIST_OBJ
		}

		table.insert(var0_8, var8_8)
	elseif arg0_8.id == IslandProductConst.PasturePlaceId then
		local var9_8 = pg.island_production_slot[arg1_8]

		for iter2_8, iter3_8 in ipairs(var9_8.animal) do
			local var10_8 = pg.island_ranch_animal[iter3_8]
			local var11_8 = {
				unitId = iter3_8,
				unitType = IslandConst.UNIT_LIST_DELEGATION_ANIMATION
			}

			table.insert(var0_8, var11_8)
		end
	end

	return var0_8
end

function var0_0.SetWorkerCnt(arg0_9, arg1_9)
	arg0_9.worker = arg1_9
end

function var0_0.GetWorkerCnt(arg0_10)
	return arg0_10.worker
end

function var0_0.SetkCurrentWorkerList(arg0_11, arg1_11)
	arg0_11.workerList = arg1_11
end

function var0_0.GetWorkerList(arg0_12)
	return arg0_12.workerList
end

function var0_0.GetBehaviourTree(arg0_13)
	if arg0_13.behaviourTree == "" then
		return nil
	end

	return arg0_13.behaviourTree
end

return var0_0
