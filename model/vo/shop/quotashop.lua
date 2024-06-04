local var0 = class("QuotaShop", import(".BaseShop"))

function var0.Ctor(arg0)
	arg0.type = ShopArgs.ShopQuota

	local var0 = pg.quota_shop_template[1].shop_goods

	arg0.goods = {}

	for iter0, iter1 in ipairs(var0) do
		local var1 = arg0:getOwnedGoodCount(iter1)

		arg0.goods[iter1] = Goods.Create({
			shop_id = iter1,
			buy_count = var1
		}, Goods.TYPE_QUOTA)
	end
end

function var0.getOwnedGoodCount(arg0, arg1)
	local var0 = pg.activity_shop_template[arg1]

	assert(var0, "config is missing in activity_shop_template, id: " .. arg1)

	return Drop.New({
		id = var0.commodity_id,
		type = var0.commodity_type,
		count = var0.num
	}):getOwnedCount()
end

function var0.IsSameKind(arg0, arg1)
	return isa(arg1, QuotaShop)
end

function var0.GetCommodityById(arg0, arg1)
	return arg0:getGoodsById(arg1)
end

function var0.GetCommodities(arg0)
	return arg0:getSortGoods()
end

function var0.getSortGoods(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		table.insert(var0, iter1)
	end

	table.sort(var0, CompareFuncs({
		function(arg0)
			return arg0:canPurchase() and 0 or 1
		end,
		function(arg0)
			return arg0:getConfig("order")
		end,
		function(arg0)
			return arg0.id
		end
	}))

	return var0
end

function var0.getGoodsCfg(arg0, arg1)
	return pg.activity_shop_template[arg1]
end

function var0.getGoodsById(arg0, arg1)
	assert(arg0.goods[arg1], "goods should exist")

	return arg0.goods[arg1]
end

function var0.getLimitGoodCount(arg0, arg1)
	local var0 = pg.activity_shop_template[arg1].limit_args

	if type(var0) == "table" then
		for iter0, iter1 in ipairs(var0) do
			if iter1[1] == "quota" then
				return iter1[2]
			end
		end
	end

	assert(false, "good not limit_args 'quota' with good id: " .. arg1)
end

return var0
