local var0_0 = class("IslandShipDressItem", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.ship_id = arg1_1.ship_id
	arg0_1.dress_id = arg1_1.dress_id
	arg0_1.configId = arg0_1.dress_id
end

function var0_0.CheckIsEqualByShipDressItem(arg0_2, arg1_2)
	return arg0_2.ship_id == arg1_2.ship_id and arg0_2.dress_id == arg1_2.dress_id
end

function var0_0.CheckIsEqualByShipIdAndDressId(arg0_3, arg1_3, arg2_3)
	return arg0_3.ship_id == arg1_3 and arg0_3.dress_id == arg2_3
end

function var0_0.SetShipAndDressId(arg0_4, arg1_4, arg2_4)
	arg0_4.ship_id = arg1_4
	arg0_4.dress_id = arg2_4
end

function var0_0.bindConfigTable(arg0_5)
	return pg.island_dress_template
end

return var0_0
