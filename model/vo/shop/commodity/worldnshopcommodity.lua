local var0 = class("WorldNShopCommodity", import(".BaseCommodity"))

function var0.bindConfigTable(arg0)
	return pg.world_newshop_data
end

function var0.canPurchase(arg0)
	return arg0:GetPurchasableCnt() > 0
end

function var0.GetPurchasableCnt(arg0)
	return arg0:GetLimitGoodCount() - arg0.buyCount
end

function var0.GetLimitGoodCount(arg0)
	return arg0:getConfig("frequency")
end

function var0.GetDropInfo(arg0)
	return Drop.New({
		type = arg0:getConfig("item_type"),
		id = arg0:getConfig("item_id"),
		count = arg0:getConfig("item_num")
	})
end

function var0.GetPriceInfo(arg0)
	return Drop.New({
		type = arg0:getConfig("price_type"),
		id = arg0:getConfig("price_id"),
		count = arg0:getConfig("price_num")
	})
end

return var0
