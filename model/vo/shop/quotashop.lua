local var0_0 = class("QuotaShop", import(".BaseShop"))

function var0_0.Ctor(arg0_1)
	arg0_1.type = ShopArgs.ShopQuota

	local var0_1 = pg.quota_shop_template[1].shop_goods

	arg0_1.goods = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		local var1_1 = arg0_1:getOwnedGoodCount(iter1_1)

		arg0_1.goods[iter1_1] = Goods.Create({
			shop_id = iter1_1,
			buy_count = var1_1
		}, Goods.TYPE_QUOTA)
	end
end

function var0_0.getOwnedGoodCount(arg0_2, arg1_2)
	local var0_2 = pg.activity_shop_template[arg1_2]

	assert(var0_2, "config is missing in activity_shop_template, id: " .. arg1_2)

	return Drop.New({
		id = var0_2.commodity_id,
		type = var0_2.commodity_type,
		count = var0_2.num
	}):getOwnedCount()
end

function var0_0.IsSameKind(arg0_3, arg1_3)
	return isa(arg1_3, QuotaShop)
end

function var0_0.GetCommodityById(arg0_4, arg1_4)
	return arg0_4:getGoodsById(arg1_4)
end

function var0_0.GetCommodities(arg0_5)
	return arg0_5:getSortGoods()
end

function var0_0.getSortGoods(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.goods) do
		table.insert(var0_6, iter1_6)
	end

	table.sort(var0_6, CompareFuncs({
		function(arg0_7)
			return arg0_7:canPurchase() and 0 or 1
		end,
		function(arg0_8)
			return arg0_8:getConfig("order")
		end,
		function(arg0_9)
			return arg0_9.id
		end
	}))

	return var0_6
end

function var0_0.getGoodsCfg(arg0_10, arg1_10)
	return pg.activity_shop_template[arg1_10]
end

function var0_0.getGoodsById(arg0_11, arg1_11)
	assert(arg0_11.goods[arg1_11], "goods should exist")

	return arg0_11.goods[arg1_11]
end

function var0_0.getLimitGoodCount(arg0_12, arg1_12)
	local var0_12 = pg.activity_shop_template[arg1_12].limit_args

	if type(var0_12) == "table" then
		for iter0_12, iter1_12 in ipairs(var0_12) do
			if iter1_12[1] == "quota" then
				return iter1_12[2]
			end
		end
	end

	assert(false, "good not limit_args 'quota' with good id: " .. arg1_12)
end

return var0_0
