local var0 = class("MedalShop", import(".BaseShop"))

function var0.Ctor(arg0, arg1)
	arg0.goods = {}

	for iter0, iter1 in ipairs(arg1.good_list) do
		local var0 = MedalGoods.New(iter1)

		var0.id = iter0
		arg0.goods[iter0] = var0
	end

	arg0.nextTime = arg1.item_flash_time
	arg0.type = ShopArgs.ShopMedal
end

function var0.IsSameKind(arg0, arg1)
	return isa(arg1, MedalShop)
end

function var0.GetCommodityById(arg0, arg1)
	return arg0:getGoodsById(arg1)
end

function var0.GetCommodities(arg0)
	return arg0:getSortGoods()
end

function var0.updateNextRefreshTime(arg0, arg1)
	arg0.nextTime = arg1
end

function var0.CanRefresh(arg0)
	return false
end

function var0.getSortGoods(arg0)
	local var0 = underscore.values(arg0.goods)

	table.sort(var0, CompareFuncs({
		function(arg0)
			return arg0:CanPurchase() and 0 or 1
		end,
		function(arg0)
			return arg0:getConfig("order")
		end
	}))

	return var0
end

function var0.getGoodsById(arg0, arg1)
	assert(arg0.goods[arg1], "goods should exist")

	return arg0.goods[arg1]
end

function var0.GetResetConsume(arg0)
	return pg.guildset.store_reset_cost.key_value
end

function var0.UpdateGoodsCnt(arg0, arg1, arg2)
	arg0:getGoodsById(arg1):UpdateCnt(arg2)
end

return var0
