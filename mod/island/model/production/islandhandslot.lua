local var0_0 = class("IslandHandSlot", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:UpdateData(arg1_1)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_production_slot
end

function var0_0.UpdateData(arg0_3, arg1_3)
	arg0_3.id = arg1_3.id
	arg0_3.state = arg1_3.state
	arg0_3.formula_id = arg1_3.formula_id
	arg0_3.end_time = arg1_3.end_time
end

return var0_0
