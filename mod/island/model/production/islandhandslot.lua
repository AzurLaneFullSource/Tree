local var0_0 = class("IslandHandSlot", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.placeId = arg1_1

	arg0_1:UpdateData(arg2_1)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_production_slot
end

function var0_0.UpdateData(arg0_3, arg1_3)
	arg0_3.configId = arg1_3.id
	arg0_3.state = arg1_3.state
	arg0_3.formula_id = arg1_3.formula_id
	arg0_3.end_time = arg1_3.end_time
	arg0_3.start_time = arg1_3.start_time
end

function var0_0.GetPlantFormulaId(arg0_4)
	if arg0_4.state == 0 then
		return false
	end

	return arg0_4.formula_id
end

return var0_0
