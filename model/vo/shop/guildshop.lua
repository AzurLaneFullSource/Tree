local var0 = class("GuildShop", import(".BaseShop"))

var0.AUTO_REFRESH = 1
var0.MANUAL_REFRESH = 2

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id or 1
	arg0.configId = arg0.id
	arg0.goods = {}

	for iter0, iter1 in ipairs(arg1.good_list) do
		local var0 = GuildGoods.New(iter1)

		arg0.goods[var0.id] = var0
	end

	arg0.refreshCount = arg1.refresh_count
	arg0.nextTime = arg1.next_refresh_time
	arg0.type = ShopArgs.ShopGUILD
end

function var0.IsSameKind(arg0, arg1)
	return isa(arg1, GuildShop)
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
	return arg0.refreshCount <= 0
end

function var0.getSortGoods(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		table.insert(var0, iter1)
	end

	table.sort(var0, function(arg0, arg1)
		local var0 = arg0:getConfig("order") or 0
		local var1 = arg1:getConfig("order") or 0

		if var0 == var1 then
			return arg0.id < arg1.id
		else
			return var1 < var0
		end
	end)

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
