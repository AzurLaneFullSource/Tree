local var0_0 = class("IslandOwnedDressItem", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.num = arg1_1.num
	arg0_1.read = arg1_1.read
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_dress_template
end

function var0_0.GetRarity(arg0_3)
	return arg0_3:getConfig("quality")
end

return var0_0
