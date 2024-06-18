local var0_0 = class("GuildGoods", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.id
	arg0_1.count = arg1_1.count
	arg0_1.index = arg1_1.index
	arg0_1.id = arg0_1.configId .. "_" .. arg0_1.index
end

function var0_0.UpdateCnt(arg0_2, arg1_2)
	arg0_2.count = arg0_2.count - arg1_2
end

function var0_0.bindConfigTable(arg0_3)
	return pg.guild_store
end

function var0_0.CanPurchase(arg0_4)
	return arg0_4.count > 0
end

function var0_0.GetPrice(arg0_5)
	return arg0_5:getConfig("price")
end

function var0_0.Selectable(arg0_6)
	return arg0_6:getConfig("goods_type") == 2
end

function var0_0.GetFirstDropId(arg0_7)
	return arg0_7:getConfig("goods")
end

function var0_0.GetMaxCnt(arg0_8)
	return arg0_8.count
end

function var0_0.CanPurchaseCnt(arg0_9, arg1_9)
	return arg1_9 <= arg0_9.count
end

function var0_0.GetLimit(arg0_10)
	return arg0_10:getConfig("goods_purchase_limit")
end

return var0_0
