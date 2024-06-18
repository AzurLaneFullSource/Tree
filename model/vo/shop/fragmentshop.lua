local var0_0 = class("FragmentShop", import(".MonthlyShop"))

var0_0.GoodsType = Goods.TYPE_FRAGMENT
var0_0.type = ShopArgs.ShopFragment

function var0_0.update(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg1_1

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg2_1) do
		var0_1[iter1_1.shop_id] = iter1_1.pay_count
	end

	for iter2_1, iter3_1 in ipairs(arg3_1) do
		var0_1[iter3_1.shop_id] = iter3_1.pay_count
	end

	table.clear(arg0_1.goods)

	if arg0_1.id and arg0_1.id > 0 and arg0_1:getConfigTable() then
		local function var1_1(arg0_2, arg1_2)
			local var0_2 = var0_1[arg0_2] or 0

			arg0_1.goods[arg0_2] = Goods.Create({
				shop_id = arg0_2,
				buy_count = var0_2
			}, arg1_2)
		end

		for iter4_1, iter5_1 in ipairs(arg0_1:getConfig("blueprint_shop_goods")) do
			var1_1(iter5_1, Goods.TYPE_FRAGMENT)
		end

		for iter6_1, iter7_1 in ipairs(arg0_1:getConfig("blueprint_shop_limit_goods")) do
			var1_1(iter7_1, Goods.TYPE_FRAGMENT_NORMAL)
		end
	end
end

function var0_0.Reset(arg0_3, arg1_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3:getConfig("blueprint_shop_limit_goods")) do
		local var1_3 = arg0_3.goods[iter1_3]

		if var1_3 then
			table.insert(var0_3, {
				shop_id = iter1_3,
				pay_count = var1_3.buyCount
			})
		end
	end

	arg0_3:update(arg1_3, {}, var0_3)
end

return var0_0
