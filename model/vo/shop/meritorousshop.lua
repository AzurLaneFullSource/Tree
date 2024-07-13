local var0_0 = class("MeritorousShop", import(".BaseShop"))

var0_0.REFRESH_TYPE_AUTO = 1
var0_0.REFRESH_TYPE_MANUAL = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.goods = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.good_list) do
		local var0_1 = Goods.Create(iter1_1, Goods.TYPE_MILITARY)

		arg0_1.goods[var0_1.id] = var0_1
	end

	arg0_1.nextTime = arg1_1.nextTime
	arg0_1.refreshCount = arg1_1.refreshCount + 1
	arg0_1.type = ShopArgs.MilitaryShop
end

function var0_0.IsSameKind(arg0_2, arg1_2)
	return isa(arg1_2, MeritorousShop)
end

function var0_0.GetCommodityById(arg0_3, arg1_3)
	return arg0_3:getGoodsById(arg1_3)
end

function var0_0.GetCommodities(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(arg0_4.goods) do
		table.insert(var0_4, iter1_4)
	end

	table.sort(var0_4, function(arg0_5, arg1_5)
		return arg0_5:getConfig("order") < arg1_5:getConfig("order")
	end)

	return var0_4
end

function var0_0.bindConfigTable(arg0_6)
	return pg.arena_data_shop
end

function var0_0.getRefreshCount(arg0_7)
	return arg0_7.refreshCount
end

function var0_0.resetRefreshCount(arg0_8)
	arg0_8.refreshCount = 1
end

function var0_0.increaseRefreshCount(arg0_9)
	arg0_9.refreshCount = arg0_9.refreshCount + 1
end

function var0_0.updateAllGoods(arg0_10, arg1_10)
	arg0_10.goods = arg1_10
end

function var0_0.getGoodsById(arg0_11, arg1_11)
	assert(arg0_11.goods[arg1_11], "should exist good" .. arg1_11)

	return Clone(arg0_11.goods[arg1_11])
end

function var0_0.updateGoods(arg0_12, arg1_12)
	assert(arg0_12.goods[arg1_12.id], "should exist good" .. arg1_12.id)

	arg0_12.goods[arg1_12.id] = arg1_12
end

return var0_0
