local var0 = class("GetOpeningUpShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	arg0.shopsProxy = getProxy(ShopsProxy)
	arg0.shopList = {}

	parallelAsync({
		function(arg0)
			arg0:GetStressShop(arg0)
		end,
		function(arg0)
			arg0:GetMilitaryShop(arg0)
		end,
		function(arg0)
			arg0:GetShamShop(arg0)
		end,
		function(arg0)
			arg0:GetFragmentShop(arg0)
		end,
		function(arg0)
			arg0:GetActivityShops(arg0)
		end,
		function(arg0)
			arg0:GetGuildShop(arg0)
		end,
		function(arg0)
			arg0:GetMedalShops(arg0)
		end,
		function(arg0)
			arg0:GetMetaShops(arg0)
		end,
		function(arg0)
			arg0:GetMiniShops(arg0)
		end,
		function(arg0)
			arg0:GetQuotaShop(arg0)
		end
	}, function()
		if var1 then
			var1(arg0.shopList)
		end
	end)
end

function var0.GetMilitaryShop(arg0, arg1)
	local var0 = {}
	local var1 = arg0.shopsProxy:getMeritorousShop()

	if not var1 then
		table.insert(var0, function(arg0)
			arg0:sendNotification(GAME.GET_MILITARY_SHOP, {
				callback = arg0
			})
		end)
	else
		table.insert(var0, function(arg0)
			arg0(var1)
		end)
	end

	table.insert(var0, function(arg0, arg1)
		arg0.shopList[NewShopsScene.TYPE_MILITARY_SHOP] = {}

		table.insert(arg0.shopList[NewShopsScene.TYPE_MILITARY_SHOP], arg1)
		arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.GetStressShop(arg0, arg1)
	local var0 = {}
	local var1 = arg0.shopsProxy:getShopStreet()

	if not var1 then
		table.insert(var0, function(arg0)
			arg0:sendNotification(GAME.GET_SHOPSTREET, {
				callback = arg0
			})
		end)
	else
		table.insert(var0, function(arg0)
			arg0(var1)
		end)
	end

	table.insert(var0, function(arg0, arg1)
		arg0.shopList[NewShopsScene.TYPE_SHOP_STREET] = {}

		table.insert(arg0.shopList[NewShopsScene.TYPE_SHOP_STREET], arg1)
		arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.GetGuildShop(arg0, arg1)
	if LOCK_GUILD_SHOP then
		arg1()

		return
	end

	local var0 = {}
	local var1 = arg0.shopsProxy:getGuildShop()

	if not var1 then
		table.insert(var0, function(arg0)
			arg0:sendNotification(GAME.GET_GUILD_SHOP, {
				type = GuildConst.GET_SHOP,
				callback = arg0
			})
		end)
	else
		table.insert(var0, function(arg0)
			arg0(var1)
		end)
	end

	table.insert(var0, function(arg0, arg1)
		arg0.shopList[NewShopsScene.TYPE_GUILD] = {}

		table.insert(arg0.shopList[NewShopsScene.TYPE_GUILD], arg1)
		arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.GetShamShop(arg0, arg1)
	local var0 = {}
	local var1 = arg0.shopsProxy:getShamShop()

	if not LOCK_SHAM_CHAPTER and var1 and var1:isOpen() then
		table.insert(var0, function(arg0)
			arg0.shopList[NewShopsScene.TYPE_SHAM_SHOP] = {}

			table.insert(arg0.shopList[NewShopsScene.TYPE_SHAM_SHOP], var1)
			arg0()
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.GetFragmentShop(arg0, arg1)
	local var0 = {}
	local var1 = arg0.shopsProxy:getFragmentShop()

	if not LOCK_FRAGMENT_SHOP and var1 and var1:isOpen() then
		table.insert(var0, function(arg0)
			arg0.shopList[NewShopsScene.TYPE_FRAGMENT] = {}

			table.insert(arg0.shopList[NewShopsScene.TYPE_FRAGMENT], var1)
			arg0()
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.GetActivityShops(arg0, arg1)
	local var0 = {}
	local var1 = arg0.shopsProxy:getActivityShops()

	if not var1 or #var1 == 0 then
		table.insert(var0, function(arg0)
			arg0:sendNotification(GAME.GET_ACTIVITY_SHOP, {
				callback = arg0
			})
		end)
	else
		table.insert(var0, function(arg0)
			arg0(var1)
		end)
	end

	table.insert(var0, function(arg0, arg1)
		if arg1 and table.getCount(arg1) > 0 then
			arg0.shopList[NewShopsScene.TYPE_ACTIVITY] = {}

			for iter0, iter1 in pairs(arg1) do
				table.insert(arg0.shopList[NewShopsScene.TYPE_ACTIVITY], iter1)
			end

			local var0 = getProxy(ActivityProxy):getRawData()

			table.sort(arg0.shopList[NewShopsScene.TYPE_ACTIVITY], CompareFuncs({
				function(arg0)
					return var0[arg0.activityId]:getStartTime()
				end
			}))
		end

		arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.GetMetaShops(arg0, arg1)
	local var0 = {}
	local var1 = arg0.shopsProxy:GetMetaShop()

	if not var1 then
		table.insert(var0, function(arg0)
			local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP)

			for iter0, iter1 in ipairs(var0) do
				if iter1 and not iter1:isEnd() and iter1:getConfig("config_id") == 1 then
					local var1 = MetaShop.New(iter1)

					arg0.shopsProxy:AddMetaShop(var1)

					break
				end
			end

			arg0(arg0.shopsProxy:GetMetaShop())
		end)
	else
		table.insert(var0, function(arg0)
			arg0(var1)
		end)
	end

	table.insert(var0, function(arg0, arg1)
		if arg1 then
			arg0.shopList[NewShopsScene.TYPE_META] = {}

			table.insert(arg0.shopList[NewShopsScene.TYPE_META], arg1)
		end

		arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.GetMedalShops(arg0, arg1)
	local var0 = {}
	local var1 = arg0.shopsProxy:GetMedalShop()

	if not var1 then
		table.insert(var0, function(arg0)
			arg0:sendNotification(GAME.GET_MEDALSHOP, {
				callback = arg0
			})
		end)
	else
		table.insert(var0, function(arg0)
			arg0(var1)
		end)
	end

	table.insert(var0, function(arg0, arg1)
		if arg1 then
			arg0.shopList[NewShopsScene.TYPE_MEDAL] = {}

			table.insert(arg0.shopList[NewShopsScene.TYPE_MEDAL], arg1)
		end

		arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.GetMiniShops(arg0, arg1)
	if LOCK_MINIGAME_HALL then
		if arg1 then
			arg1()
		end

		return
	end

	local var0 = {}
	local var1 = arg0.shopsProxy:getMiniShop()

	if not var1 then
		table.insert(var0, function(arg0)
			arg0:sendNotification(GAME.GET_MINI_GAME_SHOP, {
				callback = arg0
			})
		end)
	else
		table.insert(var0, function(arg0)
			if var1:checkShopFlash() then
				arg0:sendNotification(GAME.MINI_GAME_SHOP_FLUSH, {
					callback = arg0
				})
			else
				arg0(var1)
			end
		end)
	end

	table.insert(var0, function(arg0, arg1)
		arg0.shopList[NewShopsScene.TYPE_MINI_GAME] = {}

		table.insert(arg0.shopList[NewShopsScene.TYPE_MINI_GAME], arg1)
		arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.GetQuotaShop(arg0, arg1)
	if LOCK_QUOTA_SHOP then
		arg1()

		return
	end

	local var0 = {}
	local var1 = arg0.shopsProxy:getQuotaShop()

	if not var1 then
		var1 = QuotaShop.New()

		arg0.shopsProxy:setQuotaShop(var1)
	else
		table.insert(var0, function(arg0)
			arg0(var1)
		end)
	end

	table.insert(var0, function(arg0)
		arg0.shopList[NewShopsScene.TYPE_QUOTA] = {}

		table.insert(arg0.shopList[NewShopsScene.TYPE_QUOTA], var1)
		arg0()
	end)
	seriesAsync(var0, arg1)
end

return var0
