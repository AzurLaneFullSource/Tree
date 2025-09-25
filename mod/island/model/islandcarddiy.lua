local var0_0 = class("IslandCardDiy", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.count = arg1_1.num or 1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_card_diy
end

function var0_0.AddCount(arg0_3, arg1_3)
	arg0_3.count = arg0_3.count + arg1_3
end

return var0_0
