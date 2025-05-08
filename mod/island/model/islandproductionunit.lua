local var0_0 = class("IslandProductionUnit", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.area_id or arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.status = arg1_1.status
	arg0_1.formulaId = arg1_1.formula_id
	arg0_1.startTime = arg1_1.start_time
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_production_point
end

function var0_0.IsUnlock(arg0_3)
	return getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_3:getConfig("place_group")):GetLevel() >= arg0_3:getConfig("unlock_place_level")
end

function var0_0.GetFormulaId(arg0_4)
	return arg0_4.formulaId
end

function var0_0.Clear(arg0_5)
	arg0_5.formulaId = 0
	arg0_5.startTime = 0
end

return var0_0
