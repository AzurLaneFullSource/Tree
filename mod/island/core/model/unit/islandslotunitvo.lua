local var0_0 = class("IslandSlotUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.formula_id = arg1_1.formula_id
	arg0_1.slotType = arg1_1.slotType
	arg0_1.slotId = arg1_1.slotId
	arg0_1.isSelfIsland = arg1_1.isSelfIsland
end

function var0_0.SetHighLight(arg0_2, arg1_2)
	arg0_2.isHighLight = arg1_2
end

function var0_0.GetHighLight(arg0_3, arg1_3)
	return arg0_3.isHighLight
end

return var0_0
