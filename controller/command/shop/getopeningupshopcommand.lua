local var0_0 = class("GetOpeningUpShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	arg0_1.shopsProxy = getProxy(ShopsProxy)
	arg0_1.shopList = {}

	parallelAsync({
		function(arg0_2)
			arg0_1:GetStressShop(arg0_2)
		end,
		function(arg0_3)
			arg0_1:GetMilitaryShop(arg0_3)
		end,
		function(arg0_4)
			arg0_1:GetShamShop(arg0_4)
		end,
		function(arg0_5)
			arg0_1:GetFragmentShop(arg0_5)
		end,
		function(arg0_6)
			arg0_1:GetActivityShops(arg0_6)
		end,
		function(arg0_7)
			arg0_1:GetGuildShop(arg0_7)
		end,
		function(arg0_8)
			arg0_1:GetMedalShops(arg0_8)
		end,
		function(arg0_9)
			arg0_1:GetMetaShops(arg0_9)
		end,
		function(arg0_10)
			arg0_1:GetMiniShops(arg0_10)
		end,
		function(arg0_11)
			arg0_1:GetQuotaShop(arg0_11)
		end
	}, function()
		if var1_1 then
			var1_1(arg0_1.shopList)
		end
	end)
end

function var0_0.GetMilitaryShop(arg0_13, arg1_13)
	local var0_13 = {}
	local var1_13 = arg0_13.shopsProxy:getMeritorousShop()

	if not var1_13 then
		table.insert(var0_13, function(arg0_14)
			arg0_13:sendNotification(GAME.GET_MILITARY_SHOP, {
				callback = arg0_14
			})
		end)
	else
		table.insert(var0_13, function(arg0_15)
			arg0_15(var1_13)
		end)
	end

	table.insert(var0_13, function(arg0_16, arg1_16)
		arg0_13.shopList[ShopConst.TYPE_MILITARY_SHOP] = {}

		table.insert(arg0_13.shopList[ShopConst.TYPE_MILITARY_SHOP], arg1_16)
		arg0_16()
	end)
	seriesAsync(var0_13, arg1_13)
end

function var0_0.GetStressShop(arg0_17, arg1_17)
	local var0_17 = {}
	local var1_17 = arg0_17.shopsProxy:getShopStreet()

	if not var1_17 then
		table.insert(var0_17, function(arg0_18)
			arg0_17:sendNotification(GAME.GET_SHOPSTREET, {
				callback = arg0_18
			})
		end)
	else
		table.insert(var0_17, function(arg0_19)
			arg0_19(var1_17)
		end)
	end

	table.insert(var0_17, function(arg0_20, arg1_20)
		arg0_17.shopList[ShopConst.TYPE_SHOP_STREET] = {}

		table.insert(arg0_17.shopList[ShopConst.TYPE_SHOP_STREET], arg1_20)
		arg0_20()
	end)
	seriesAsync(var0_17, arg1_17)
end

function var0_0.GetGuildShop(arg0_21, arg1_21)
	if LOCK_GUILD_SHOP then
		arg1_21()

		return
	end

	local var0_21 = {}
	local var1_21 = arg0_21.shopsProxy:getGuildShop()

	if not var1_21 then
		table.insert(var0_21, function(arg0_22)
			arg0_21:sendNotification(GAME.GET_GUILD_SHOP, {
				type = GuildConst.GET_SHOP,
				callback = arg0_22
			})
		end)
	else
		table.insert(var0_21, function(arg0_23)
			arg0_23(var1_21)
		end)
	end

	table.insert(var0_21, function(arg0_24, arg1_24)
		arg0_21.shopList[ShopConst.TYPE_GUILD] = {}

		table.insert(arg0_21.shopList[ShopConst.TYPE_GUILD], arg1_24)
		arg0_24()
	end)
	seriesAsync(var0_21, arg1_21)
end

function var0_0.GetShamShop(arg0_25, arg1_25)
	local var0_25 = {}
	local var1_25 = arg0_25.shopsProxy:getShamShop()

	if not LOCK_SHAM_CHAPTER and var1_25 and var1_25:isOpen() then
		table.insert(var0_25, function(arg0_26)
			arg0_25.shopList[ShopConst.TYPE_SHAM_SHOP] = {}

			table.insert(arg0_25.shopList[ShopConst.TYPE_SHAM_SHOP], var1_25)
			arg0_26()
		end)
	end

	seriesAsync(var0_25, arg1_25)
end

function var0_0.GetFragmentShop(arg0_27, arg1_27)
	local var0_27 = {}
	local var1_27 = arg0_27.shopsProxy:getFragmentShop()

	if not LOCK_FRAGMENT_SHOP and var1_27 and var1_27:isOpen() then
		table.insert(var0_27, function(arg0_28)
			arg0_27.shopList[ShopConst.TYPE_FRAGMENT] = {}

			table.insert(arg0_27.shopList[ShopConst.TYPE_FRAGMENT], var1_27)
			arg0_28()
		end)
	end

	seriesAsync(var0_27, arg1_27)
end

function var0_0.GetActivityShops(arg0_29, arg1_29)
	local var0_29 = {}
	local var1_29 = {}

	for iter0_29, iter1_29 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP)) do
		table.insert(var0_29, arg0_29.shopsProxy:getActivityShopById(iter1_29.id))

		var1_29[iter1_29.id] = iter1_29:getStartTime()
	end

	if #var0_29 > 0 then
		arg0_29.shopList[ShopConst.TYPE_ACTIVITY] = {}

		for iter2_29, iter3_29 in ipairs(var0_29) do
			table.insert(arg0_29.shopList[ShopConst.TYPE_ACTIVITY], iter3_29)
		end

		local var2_29 = getProxy(ActivityProxy):getRawData()

		table.sort(arg0_29.shopList[ShopConst.TYPE_ACTIVITY], CompareFuncs({
			function(arg0_30)
				return var1_29[arg0_30.activityId]
			end
		}))
	end

	arg1_29()
end

function var0_0.GetMetaShops(arg0_31, arg1_31)
	local var0_31 = {}
	local var1_31 = arg0_31.shopsProxy:GetMetaShop()

	if not var1_31 then
		table.insert(var0_31, function(arg0_32)
			local var0_32 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP_SELECTABLE)

			for iter0_32, iter1_32 in ipairs(var0_32) do
				if iter1_32 and not iter1_32:isEnd() and iter1_32:getConfig("config_id") == 1 then
					local var1_32 = MetaShop.New(iter1_32)

					arg0_31.shopsProxy:AddMetaShop(var1_32)

					break
				end
			end

			arg0_32(arg0_31.shopsProxy:GetMetaShop())
		end)
	else
		table.insert(var0_31, function(arg0_33)
			arg0_33(var1_31)
		end)
	end

	table.insert(var0_31, function(arg0_34, arg1_34)
		if arg1_34 then
			arg0_31.shopList[ShopConst.TYPE_META] = {}

			table.insert(arg0_31.shopList[ShopConst.TYPE_META], arg1_34)
		end

		arg0_34()
	end)
	seriesAsync(var0_31, arg1_31)
end

function var0_0.GetMedalShops(arg0_35, arg1_35)
	local var0_35 = {}
	local var1_35 = arg0_35.shopsProxy:GetMedalShop()

	if not var1_35 then
		table.insert(var0_35, function(arg0_36)
			arg0_35:sendNotification(GAME.GET_MEDALSHOP, {
				callback = arg0_36
			})
		end)
	else
		table.insert(var0_35, function(arg0_37)
			arg0_37(var1_35)
		end)
	end

	table.insert(var0_35, function(arg0_38, arg1_38)
		if arg1_38 then
			arg0_35.shopList[ShopConst.TYPE_MEDAL] = {}

			table.insert(arg0_35.shopList[ShopConst.TYPE_MEDAL], arg1_38)
		end

		arg0_38()
	end)
	seriesAsync(var0_35, arg1_35)
end

function var0_0.GetMiniShops(arg0_39, arg1_39)
	if LOCK_MINIGAME_HALL then
		if arg1_39 then
			arg1_39()
		end

		return
	end

	local var0_39 = {}
	local var1_39 = arg0_39.shopsProxy:getMiniShop()

	if not var1_39 then
		table.insert(var0_39, function(arg0_40)
			arg0_39:sendNotification(GAME.GET_MINI_GAME_SHOP, {
				callback = arg0_40
			})
		end)
	else
		table.insert(var0_39, function(arg0_41)
			if var1_39:checkShopFlash() then
				arg0_39:sendNotification(GAME.MINI_GAME_SHOP_FLUSH, {
					callback = arg0_41
				})
			else
				arg0_41(var1_39)
			end
		end)
	end

	table.insert(var0_39, function(arg0_42, arg1_42)
		arg0_39.shopList[ShopConst.TYPE_MINI_GAME] = {}

		table.insert(arg0_39.shopList[ShopConst.TYPE_MINI_GAME], arg1_42)
		arg0_42()
	end)
	seriesAsync(var0_39, arg1_39)
end

function var0_0.GetQuotaShop(arg0_43, arg1_43)
	if LOCK_QUOTA_SHOP then
		arg1_43()

		return
	end

	local var0_43 = {}
	local var1_43 = arg0_43.shopsProxy:getQuotaShop()

	if not var1_43 then
		var1_43 = QuotaShop.New()

		arg0_43.shopsProxy:setQuotaShop(var1_43)
	else
		table.insert(var0_43, function(arg0_44)
			arg0_44(var1_43)
		end)
	end

	table.insert(var0_43, function(arg0_45)
		arg0_43.shopList[ShopConst.TYPE_QUOTA] = {}

		table.insert(arg0_43.shopList[ShopConst.TYPE_QUOTA], var1_43)
		arg0_45()
	end)
	seriesAsync(var0_43, arg1_43)
end

return var0_0
