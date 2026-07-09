local var0_0 = class("GiftActCommodity", import(".CommonCommodity"))

function var0_0.canPurchase(arg0_1)
	assert(arg0_1:getConfig("genre") == ShopArgs.GiftActPackage)

	local var0_1 = arg0_1:getBindActivity()

	if not var0_1 or var0_1:isEnd() then
		return false
	end

	return (var0_1.data1 or 0) < arg0_1:getLimitCount()
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
	local var0_4 = arg0_4:getBindActivity()

	return switch(var0_4:getConfig("type"), {
		[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
			return 1
		end,
		[ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE] = function()
			local var0_6 = pg.activity_giftpackage[var0_4:getConfig("config_id")]

			assert(var0_6)

			local var1_6 = var0_4.data1 or 0
			local var2_6 = getProxy(ShipSkinProxy)

			for iter0_6, iter1_6 in ipairs(var0_6.skin) do
				if not var2_6:hasNonLimitSkin(iter1_6) then
					var1_6 = var1_6 + 1
				end
			end

			return math.min(var1_6, var0_6.limit_count)
		end
	}, function()
		assert(false)
	end)
end

function var0_0.getBuyCount(arg0_8)
	local var0_8 = arg0_8:getBindActivity()

	return var0_8 and not var0_8:isEnd() and var0_8.data1 or 0
end

function var0_0.isFree(arg0_9)
	return arg0_9:GetPrice() == 0
end

function var0_0.CalcPrice(arg0_10)
	return switch(arg0_10:getConfig("type"), {
		[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
			local var0_11 = 0
			local var1_11 = 0

			for iter0_11, iter1_11 in ipairs(arg0_10:getConfig("config_data")[1]) do
				local var2_11 = pg.ship_skin_template[iter1_11].shop_id

				assert(var2_11 and var2_11 > 0)

				local var3_11 = Goods.Create({
					shop_id = var2_11
				}, Goods.TYPE_SKIN)

				var1_11 = var1_11 + var3_11:getConfig("resource_num")

				if not getProxy(ShipSkinProxy):hasNonLimitSkin(iter1_11) then
					var0_11 = var0_11 + var3_11:getConfig("resource_num")
				end
			end

			local var4_11 = (var1_11 - var0_11) * 100 / var1_11

			return var0_11, var4_11, var1_11
		end,
		[ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE] = function()
			local var0_12 = pg.activity_giftpackage[arg0_10:getConfig("config_id")]

			assert(var0_12)

			local var1_12 = var0_12.price

			return var1_12, 0, var1_12
		end
	}, function()
		assert(false)
	end)
end

return var0_0
