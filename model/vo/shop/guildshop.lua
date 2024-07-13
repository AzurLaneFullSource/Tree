local var0_0 = class("GuildShop", import(".BaseShop"))

var0_0.AUTO_REFRESH = 1
var0_0.MANUAL_REFRESH = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id or 1
	arg0_1.configId = arg0_1.id
	arg0_1.goods = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.good_list) do
		local var0_1 = GuildGoods.New(iter1_1)

		arg0_1.goods[var0_1.id] = var0_1
	end

	arg0_1.refreshCount = arg1_1.refresh_count
	arg0_1.nextTime = arg1_1.next_refresh_time
	arg0_1.type = ShopArgs.ShopGUILD
end

function var0_0.IsSameKind(arg0_2, arg1_2)
	return isa(arg1_2, GuildShop)
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
	return arg0_6.refreshCount <= 0
end

function var0_0.getSortGoods(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.goods) do
		table.insert(var0_7, iter1_7)
	end

	table.sort(var0_7, function(arg0_8, arg1_8)
		local var0_8 = arg0_8:getConfig("order") or 0
		local var1_8 = arg1_8:getConfig("order") or 0

		if var0_8 == var1_8 then
			return arg0_8.id < arg1_8.id
		else
			return var1_8 < var0_8
		end
	end)

	return var0_7
end

function var0_0.getGoodsById(arg0_9, arg1_9)
	assert(arg0_9.goods[arg1_9], "goods should exist")

	return arg0_9.goods[arg1_9]
end

function var0_0.GetResetConsume(arg0_10)
	return pg.guildset.store_reset_cost.key_value
end

function var0_0.UpdateGoodsCnt(arg0_11, arg1_11, arg2_11)
	arg0_11:getGoodsById(arg1_11):UpdateCnt(arg2_11)
end

return var0_0
