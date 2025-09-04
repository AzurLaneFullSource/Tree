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
	local var0_5 = {
		402,
		602,
		601,
		702,
		102,
		101,
		901
	}

	if not arg3_5 and not table.contains(var0_5, arg0_5.id) then
		return
	end

	local var1_5 = arg0_5.slotDic[arg2_5]
	local var2_5 = pg.island_production_commission[var1_5]
	local var3_5 = pg.island_world_objects[var2_5.birthplace]

	if not var3_5 then
		return nil
	end

	local var4_5

	if arg0_5.config.interactionType == var1_0 and not arg3_5 then
		local var5_5 = arg0_5:GetObjId(arg2_5)
		local var6_5 = pg.island_world_objects[var5_5]
		local var7_5 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var6_5.param.position), 2)

		var4_5 = {
			var7_5.x,
			var7_5.y,
			var7_5.z
		}
	else
		var4_5 = var3_5.param.position
	end

	local var8_5

	if arg0_5.isSelf then
		var8_5 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_5):GetModelUnit()
	else
		var8_5 = pg.island_chara_template[arg1_5].unit_id
	end

	local var9_5 = arg1_5 == 1 and arg0_5.config.chickenbehaviourTree or arg0_5.config.npcbehaviourTree

	return IslandUnitVO.New({
		id = arg1_5,
		modelId = var8_5,
		type = IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION,
		name = "system_unit" .. arg1_5,
		position = var4_5,
		rotation = Vector3.zero,
		scale = Vector3.one,
		behaviourTree = var9_5
	})
end

function var0_0.GetObjId(arg0_6, arg1_6)
	local var0_6 = arg0_6.slotDic[arg1_6]

	return pg.island_production_commission[var0_6].performanceObjid
end

function var0_0.GetperformanceObjidList(arg0_7, arg1_7, arg2_7)
	local var0_7 = {}

	if arg0_7.id == IslandProductSystemVO.FarmlandPlaceId then
		local var1_7 = pg.island_production_slot[arg1_7]

		for iter0_7, iter1_7 in ipairs(var1_7.exclusion_slot) do
			local var2_7 = arg0_7.productSystem:GetUnitIdBySlotId(iter1_7)
			local var3_7 = {
				unitId = var2_7,
				unitType = IslandConst.UNIT_LIST_OBJ
			}

			table.insert(var0_7, var3_7)
		end
	elseif arg0_7.id == IslandProductSystemVO.MinePlaceId or arg0_7.id == IslandProductSystemVO.FellingPlaceId or arg0_7.id == IslandProductSystemVO.TechnologyPlaceId then
		local var4_7 = arg0_7.slotDic[arg1_7]
		local var5_7 = pg.island_production_commission[var4_7]
		local var6_7 = {
			unitId = var5_7.performanceObjid,
			unitType = IslandConst.UNIT_LIST_OBJ
		}

		table.insert(var0_7, var6_7)
	elseif arg0_7.id == IslandProductSystemVO.PasturePlaceId then
		local var7_7 = pg.island_production_slot[arg1_7]

		for iter2_7, iter3_7 in ipairs(var7_7.animal) do
			local var8_7 = pg.island_ranch_animal[iter3_7]
			local var9_7 = {
				unitId = iter3_7,
				unitType = IslandConst.UNIT_LIST_DELEGATION_ANIMATION
			}

			table.insert(var0_7, var9_7)
		end
	end

	return var0_7
end

function var0_0.SetWorkerCnt(arg0_8, arg1_8)
	arg0_8.worker = arg1_8
end

function var0_0.GetWorkerCnt(arg0_9)
	return arg0_9.worker
end

function var0_0.SetkCurrentWorkerList(arg0_10, arg1_10)
	arg0_10.workerList = arg1_10
end

function var0_0.GetWorkerList(arg0_11)
	return arg0_11.workerList
end

function var0_0.GetBehaviourTree(arg0_12)
	if arg0_12.behaviourTree == "" then
		return nil
	end

	return arg0_12.behaviourTree
end

return var0_0
