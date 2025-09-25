local var0_0 = class("IslandVirtualInteractUnitVO", import(".IslandInteractUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.super.Ctor(arg0_1, arg1_1)

	arg0_1.config = pg.island_interact_point[arg0_1.modelId]
	arg0_1.behaviourTree = arg0_1.config.bt
	arg0_1.slots = {}

	for iter0_1 = 1, arg0_1.config.slot_cnt do
		table.insert(arg0_1.slots, InteractSlot.New(iter0_1, arg0_1.id))
	end

	arg0_1:InitTimlineInfo()
end

function var0_0.GetAssetPath(arg0_2)
	return nil
end

return var0_0
