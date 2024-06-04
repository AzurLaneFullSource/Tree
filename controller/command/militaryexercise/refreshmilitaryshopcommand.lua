local var0 = class("RefreshMilitaryShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(18102, {
		type = 0
	}, 18103, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ShopsProxy)
			local var1 = var0:getMeritorousShop()
			local var2 = pg.arena_data_shop[1]
			local var3 = var2.refresh_price[var1.refreshCount] or var2.refresh_price[#var2.refresh_price]
			local var4 = getProxy(PlayerProxy)
			local var5 = var4:getData()

			var5:consume({
				gem = var3
			})
			var4:updatePlayer(var5)
			var1:increaseRefreshCount()

			local var6 = {}

			for iter0, iter1 in ipairs(arg0.arena_shop_list) do
				local var7 = Goods.Create(iter1, Goods.TYPE_MILITARY)

				var6[var7.id] = var7
			end

			var1:updateAllGoods(var6)
			var0:addMeritorousShop(var1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("refresh_shopStreet_ok"))
			arg0:sendNotification(GAME.REFRESH_MILITARY_SHOP_DONE, Clone(var1))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
