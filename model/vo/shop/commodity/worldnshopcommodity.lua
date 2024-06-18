local var0_0 = class("WorldNShopCommodity", import(".BaseCommodity"))

function var0_0.bindConfigTable(arg0_1)
	return pg.world_newshop_data
end

function var0_0.canPurchase(arg0_2)
	return arg0_2:GetPurchasableCnt() > 0
end

function var0_0.GetPurchasableCnt(arg0_3)
	return arg0_3:GetLimitGoodCount() - arg0_3.buyCount
end

function var0_0.GetLimitGoodCount(arg0_4)
	return arg0_4:getConfig("frequency")
end

function var0_0.GetDropInfo(arg0_5)
	return Drop.New({
		type = arg0_5:getConfig("item_type"),
		id = arg0_5:getConfig("item_id"),
		count = arg0_5:getConfig("item_num")
	})
end

function var0_0.GetPriceInfo(arg0_6)
	return Drop.New({
		type = arg0_6:getConfig("price_type"),
		id = arg0_6:getConfig("price_id"),
		count = arg0_6:getConfig("price_num")
	})
end

return var0_0
