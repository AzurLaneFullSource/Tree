local var0_0 = class("GiftActCommodity", import(".CommonCommodity"))

function var0_0.canPurchase(arg0_1)
	assert(arg0_1:getConfig("genre") == ShopArgs.GiftActPackage)

	local var0_1 = arg0_1:getBindActivity()

	return var0_1 and not var0_1:isEnd() and var0_1.data1 < arg0_1:getLimitCount()
end

function var0_0.getBindActivity(arg0_2)
	assert(arg0_2:getConfig("genre") == ShopArgs.GiftActPackage)

	local var0_2 = arg0_2:getDropInfo():getConfig("link_id")

	return getProxy(ActivityProxy):getActivityById(var0_2)
end

function var0_0.GetPrice(arg0_3)
	local var0_3 = arg0_3:getBindActivity()

	return var0_0.CalcPrice(var0_3)
end

function var0_0.getLimitCount(arg0_4)
	return 1
end

function var0_0.getBuyCount(arg0_5)
	local var0_5 = arg0_5:getBindActivity()

	return var0_5 and not var0_5:isEnd() and var0_5.data1 or 0
end

function var0_0.isFree(arg0_6)
	return arg0_6:GetPrice() == 0
end

function var0_0.CalcPrice(arg0_7)
	local var0_7 = 0
	local var1_7 = 0

	for iter0_7, iter1_7 in ipairs(arg0_7:getConfig("config_data")[1]) do
		local var2_7 = pg.ship_skin_template[iter1_7].shop_id

		assert(var2_7 and var2_7 > 0)

		local var3_7 = Goods.Create({
			shop_id = var2_7
		}, Goods.TYPE_SKIN)

		var1_7 = var1_7 + var3_7:getConfig("resource_num")

		if not getProxy(ShipSkinProxy):hasNonLimitSkin(iter1_7) then
			var0_7 = var0_7 + var3_7:getConfig("resource_num")
		end
	end

	local var4_7 = (var1_7 - var0_7) * 100 / var1_7

	return var0_7, var4_7, var1_7
end

return var0_0
