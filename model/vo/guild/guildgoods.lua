local var0 = class("GuildGoods", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.id
	arg0.count = arg1.count
	arg0.index = arg1.index
	arg0.id = arg0.configId .. "_" .. arg0.index
end

function var0.UpdateCnt(arg0, arg1)
	arg0.count = arg0.count - arg1
end

function var0.bindConfigTable(arg0)
	return pg.guild_store
end

function var0.CanPurchase(arg0)
	return arg0.count > 0
end

function var0.GetPrice(arg0)
	return arg0:getConfig("price")
end

function var0.Selectable(arg0)
	return arg0:getConfig("goods_type") == 2
end

function var0.GetFirstDropId(arg0)
	return arg0:getConfig("goods")
end

function var0.GetMaxCnt(arg0)
	return arg0.count
end

function var0.CanPurchaseCnt(arg0, arg1)
	return arg1 <= arg0.count
end

function var0.GetLimit(arg0)
	return arg0:getConfig("goods_purchase_limit")
end

return var0
