local var0_0 = class("RefreshMilitaryShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	pg.ConnectionMgr.GetInstance():Send(18102, {
		type = 0
	}, 18103, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ShopsProxy)
			local var1_2 = var0_2:getMeritorousShop()
			local var2_2 = pg.arena_data_shop[1]
			local var3_2 = var2_2.refresh_price[var1_2.refreshCount] or var2_2.refresh_price[#var2_2.refresh_price]
			local var4_2 = getProxy(PlayerProxy)
			local var5_2 = var4_2:getData()

			var5_2:consume({
				gem = var3_2
			})
			var4_2:updatePlayer(var5_2)
			var1_2:increaseRefreshCount()

			local var6_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.arena_shop_list) do
				local var7_2 = Goods.Create(iter1_2, Goods.TYPE_MILITARY)

				var6_2[var7_2.id] = var7_2
			end

			var1_2:updateAllGoods(var6_2)
			var0_2:addMeritorousShop(var1_2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("refresh_shopStreet_ok"))
			arg0_1:sendNotification(GAME.REFRESH_MILITARY_SHOP_DONE, Clone(var1_2))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
