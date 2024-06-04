local var0 = class("MeritorousShop", import(".BaseShop"))

var0.REFRESH_TYPE_AUTO = 1
var0.REFRESH_TYPE_MANUAL = 2

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.goods = {}

	for iter0, iter1 in ipairs(arg1.good_list) do
		local var0 = Goods.Create(iter1, Goods.TYPE_MILITARY)

		arg0.goods[var0.id] = var0
	end

	arg0.nextTime = arg1.nextTime
	arg0.refreshCount = arg1.refreshCount + 1
	arg0.type = ShopArgs.MilitaryShop
end

function var0.IsSameKind(arg0, arg1)
	return isa(arg1, MeritorousShop)
end

function var0.GetCommodityById(arg0, arg1)
	return arg0:getGoodsById(arg1)
end

function var0.GetCommodities(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		table.insert(var0, iter1)
	end

	table.sort(var0, function(arg0, arg1)
		return arg0:getConfig("order") < arg1:getConfig("order")
	end)

	return var0
end

function var0.bindConfigTable(arg0)
	return pg.arena_data_shop
end

function var0.getRefreshCount(arg0)
	return arg0.refreshCount
end

function var0.resetRefreshCount(arg0)
	arg0.refreshCount = 1
end

function var0.increaseRefreshCount(arg0)
	arg0.refreshCount = arg0.refreshCount + 1
end

function var0.updateAllGoods(arg0, arg1)
	arg0.goods = arg1
end

function var0.getGoodsById(arg0, arg1)
	assert(arg0.goods[arg1], "should exist good" .. arg1)

	return Clone(arg0.goods[arg1])
end

function var0.updateGoods(arg0, arg1)
	assert(arg0.goods[arg1.id], "should exist good" .. arg1.id)

	arg0.goods[arg1.id] = arg1
end

return var0
