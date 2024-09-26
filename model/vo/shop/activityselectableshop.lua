local var0_0 = class("ActivitySelectableShop", import(".ActivityShop"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.activityId = arg1_1.id

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.data1_list) do
		var0_1[iter1_1] = arg1_1.data2_list[iter0_1]
	end

	arg0_1.goods = {}

	local var1_1 = arg0_1:bindConfigTable()

	for iter2_1, iter3_1 in ipairs(var1_1.all) do
		if arg1_1.id == var1_1[iter3_1].activity then
			local var2_1 = var0_1[iter3_1] or 0

			arg0_1.goods[iter3_1] = Goods.Create({
				shop_id = iter3_1,
				buy_count = var2_1
			}, Goods.TYPE_ACTIVITY_SELECTABLE)
		end
	end

	arg0_1.type = ShopArgs.ShopActivity
	arg0_1.config = pg.activity_template[arg0_1.activityId]
end

function var0_0.IsSameKind(arg0_2, arg1_2)
	return isa(arg1_2, ActivitySelectableShop) and arg1_2.activityId and arg1_2.activityId == arg0_2.activityId
end

return var0_0
