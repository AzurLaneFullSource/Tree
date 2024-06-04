local var0 = class("FragmentShop", import(".MonthlyShop"))

var0.GoodsType = Goods.TYPE_FRAGMENT
var0.type = ShopArgs.ShopFragment

function var0.update(arg0, arg1, arg2, arg3)
	arg0.id = arg1
	arg0.configId = arg1

	local var0 = {}

	for iter0, iter1 in ipairs(arg2) do
		var0[iter1.shop_id] = iter1.pay_count
	end

	for iter2, iter3 in ipairs(arg3) do
		var0[iter3.shop_id] = iter3.pay_count
	end

	table.clear(arg0.goods)

	if arg0.id and arg0.id > 0 and arg0:getConfigTable() then
		local function var1(arg0, arg1)
			local var0 = var0[arg0] or 0

			arg0.goods[arg0] = Goods.Create({
				shop_id = arg0,
				buy_count = var0
			}, arg1)
		end

		for iter4, iter5 in ipairs(arg0:getConfig("blueprint_shop_goods")) do
			var1(iter5, Goods.TYPE_FRAGMENT)
		end

		for iter6, iter7 in ipairs(arg0:getConfig("blueprint_shop_limit_goods")) do
			var1(iter7, Goods.TYPE_FRAGMENT_NORMAL)
		end
	end
end

function var0.Reset(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:getConfig("blueprint_shop_limit_goods")) do
		local var1 = arg0.goods[iter1]

		if var1 then
			table.insert(var0, {
				shop_id = iter1,
				pay_count = var1.buyCount
			})
		end
	end

	arg0:update(arg1, {}, var0)
end

return var0
