local var0_0 = class("IslandCommodity", import("model.vo.BaseVO"))
local var1_0 = pg.pay_data_display

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.id
	arg0_1.id = arg1_1.id
	arg0_1.purchasedNum = arg1_1.num
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_shop_goods
end

function var0_0.GetName(arg0_3)
	return arg0_3:getConfig("goods_name")
end

function var0_0.GetDescription(arg0_4)
	return arg0_4:getConfig("desc")
end

function var0_0.GetIcon(arg0_5)
	return arg0_5:getConfig("icon")
end

function var0_0.GetShopIds(arg0_6)
	return arg0_6:getConfig("shop_id")
end

function var0_0.GetResourceConsume(arg0_7)
	return arg0_7:getConfig("resource_consume")
end

function var0_0.GetItems(arg0_8)
	return arg0_8:getConfig("items")
end

function var0_0.GetPayId(arg0_9)
	return arg0_9:getConfig("pay_id")
end

function var0_0.GetMaxNum(arg0_10)
	return arg0_10:getConfig("limited_num")
end

function var0_0.IsShowPurchaseLimit(arg0_11)
	return arg0_11:getConfig("limited_show") == 1
end

function var0_0.IsShowSellOut(arg0_12)
	return arg0_12:getConfig("remian_show") == 1
end

function var0_0.GetDiscount(arg0_13)
	local var0_13 = 0

	if pg.TimeMgr.GetInstance():inTime(arg0_13:getConfig("discount_time")) then
		var0_13 = arg0_13:getConfig("discount")
	end

	return var0_13
end

function var0_0.GetCommodityShowType(arg0_14)
	return arg0_14:getConfig("goods_detail_type")
end

function var0_0.GetPacketItemsShowTypes(arg0_15)
	return arg0_15:getConfig("groups_detail_type")
end

function var0_0.UpdateNum(arg0_16, arg1_16)
	arg0_16.purchasedNum = arg1_16
end

function var0_0.AddNum(arg0_17, arg1_17)
	arg0_17.purchasedNum = arg0_17.purchasedNum + arg1_17
end

function var0_0.GetPayConfig(arg0_18)
	return var1_0[arg0_18:GetPayId()]
end

function var0_0.IsTimeLimitCommodity(arg0_19)
	local var0_19 = arg0_19:getConfig("time")

	if type(var0_19) == "table" then
		return true
	end

	return false
end

return var0_0
