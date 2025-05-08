local var0_0 = class("IslandCharacterSystemVO", import(".IslandSystemVO"))
local var1_0 = 0
local var2_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.id = arg1_1
	arg0_1.name = "_system_" .. arg0_1.id
	arg0_1.slotDic = {}

	arg0_1:InitCfgData(arg0_1.id)

	arg0_1.config = pg.island_production_place[arg0_1.id]
	arg0_1.behaviourTree = arg0_1.config.behaviourTree
	arg0_1.worker = 0
end

function var0_0.InitCfgData(arg0_2, arg1_2)
	local var0_2 = pg.island_production_place[arg1_2].commission_slot

	for iter0_2, iter1_2 in ipairs(var0_2) do
		local var1_2 = pg.island_production_commission[iter1_2]

		arg0_2.slotDic[var1_2.slot] = iter1_2
	end
end

function var0_0.GetUnit(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg0_3.slotDic[arg2_3]
	local var1_3 = pg.island_production_commission[var0_3]
	local var2_3 = pg.island_world_objects[var1_3.birthplace]

	if not var2_3 then
		return nil
	end

	local var3_3

	if arg0_3.config.interactionType == var1_0 and not arg3_3 then
		local var4_3 = arg0_3:GetObjId(arg2_3)
		local var5_3 = pg.island_world_objects[var4_3]
		local var6_3 = IslandCalcUtil.GetRandomPointOnCircle(BuildVector3(var5_3.param.position), 2)

		var3_3 = {
			var6_3.x,
			var6_3.y,
			var6_3.z
		}
	else
		var3_3 = var2_3.param.position
	end

	return IslandUnitVO.New({
		behaviourTree = "Island/NodeCanvas/System/system_npc",
		id = arg1_3,
		modelId = arg1_3,
		type = IslandConst.UNIT_TYPE_SYSTEM,
		name = "system_unit" .. arg1_3,
		position = var3_3,
		rotation = Vector3.zero,
		scale = Vector3.one
	})
end

function var0_0.GetObjId(arg0_4, arg1_4)
	local var0_4 = arg0_4.slotDic[arg1_4]

	return pg.island_production_commission[var0_4].performanceObjid
end

function var0_0.SetkWorkerCnt(arg0_5, arg1_5)
	arg0_5.worker = arg1_5
end

function var0_0.GetWorkerCnt(arg0_6)
	return arg0_6.worker
end

function var0_0.GetBehaviourTree(arg0_7)
	if arg0_7.behaviourTree == "" then
		return nil
	end

	return arg0_7.behaviourTree
end

return var0_0
