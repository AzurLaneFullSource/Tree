local var0_0 = class("MedalShop", import(".BaseShop"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.goods = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.good_list) do
		local var0_1 = MedalGoods.New(iter1_1)

		var0_1.id = iter0_1
		arg0_1.goods[iter0_1] = var0_1
	end

	arg0_1.nextTime = arg1_1.item_flash_time
	arg0_1.type = ShopArgs.ShopMedal
end

function var0_0.IsSameKind(arg0_2, arg1_2)
	return isa(arg1_2, MedalShop)
end

function var0_0.GetCommodityById(arg0_3, arg1_3)
	return arg0_3:getGoodsById(arg1_3)
end

function var0_0.GetCommodities(arg0_4)
	return arg0_4:getSortGoods()
end

function var0_0.updateNextRefreshTime(arg0_5, arg1_5)
	arg0_5.nextTime = arg1_5
end

function var0_0.CanRefresh(arg0_6)
	return false
end

function var0_0.getSortGoods(arg0_7)
	local var0_7 = underscore.values(arg0_7.goods)

	table.sort(var0_7, CompareFuncs({
		function(arg0_8)
			return arg0_8:CanPurchase() and 0 or 1
		end,
		function(arg0_9)
			return arg0_9:getConfig("order")
		end
	}))

	return var0_7
end

function var0_0.getGoodsById(arg0_10, arg1_10)
	assert(arg0_10.goods[arg1_10], "goods should exist")

	return arg0_10.goods[arg1_10]
end

function var0_0.GetResetConsume(arg0_11)
	return pg.guildset.store_reset_cost.key_value
end

function var0_0.UpdateGoodsCnt(arg0_12, arg1_12, arg2_12)
	arg0_12:getGoodsById(arg1_12):UpdateCnt(arg2_12)
end

return var0_0
