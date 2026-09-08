local var0_0 = class("QuotaShop", import(".BaseShop"))

function var0_0.Ctor(arg0_1)
	arg0_1.type = ShopArgs.ShopQuota

	local var0_1 = pg.quota_shop_template[1].shop_goods

	arg0_1.goods = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		arg0_1.goods[iter1_1] = Goods.Create({
			shop_id = iter1_1
		}, Goods.TYPE_QUOTA)
	end
end

function var0_0.IsSameKind(arg0_2, arg1_2)
	return isa(arg1_2, QuotaShop)
end

function var0_0.GetCommodityById(arg0_3, arg1_3)
	return arg0_3:getGoodsById(arg1_3)
end

function var0_0.GetCommodities(arg0_4)
	return arg0_4:getSortGoods()
end

function var0_0.getSortGoods(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.goods) do
		table.insert(var0_5, iter1_5)
	end

	table.sort(var0_5, CompareFuncs({
		function(arg0_6)
			return arg0_6:canPurchase() and 0 or 1
		end,
		function(arg0_7)
			return arg0_7:getConfig("order")
		end,
		function(arg0_8)
			return arg0_8.id
		end
	}))

	return var0_5
end

function var0_0.getGoodsCfg(arg0_9, arg1_9)
	return pg.activity_shop_template[arg1_9]
end

function var0_0.getGoodsById(arg0_10, arg1_10)
	assert(arg0_10.goods[arg1_10], "goods should exist")

	return arg0_10.goods[arg1_10]
end

function var0_0.getLimitGoodCount(arg0_11, arg1_11)
	local var0_11 = pg.activity_shop_template[arg1_11].limit_args

	if type(var0_11) == "table" then
		for iter0_11, iter1_11 in ipairs(var0_11) do
			if iter1_11[1] == "quota" then
				return iter1_11[2]
			end
		end
	end

	assert(false, "good not limit_args 'quota' with good id: " .. arg1_11)
end

function var0_0.GetResList(arg0_12)
	return {
		59900
	}
end

return var0_0
