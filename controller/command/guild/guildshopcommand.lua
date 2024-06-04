local var0 = class("GuildShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.goodsId
	local var2 = var0.selectedId
	local var3 = #var2
	local var4 = getProxy(PlayerProxy)
	local var5 = var4:getData()
	local var6 = var5:getResource(8)
	local var7 = getProxy(ShopsProxy)
	local var8 = var7:getGuildShop():getGoodsById(var1)
	local var9 = var8:GetPrice()

	if var6 < var9 * var3 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var8:CanPurchaseCnt(var3) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_cnt_no_enough"))

		return
	end

	local var10 = {}

	for iter0, iter1 in ipairs(var2) do
		if not var10[iter1] then
			var10[iter1] = {
				count = 1,
				id = iter1
			}
		else
			var10[iter1].count = var10[iter1].count + 1
		end
	end

	pg.ConnectionMgr.GetInstance():Send(60035, {
		goodsid = var8.configId,
		index = var8.index,
		selected = _.values(var10)
	}, 60036, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)
			local var1 = var7:getGuildShop()

			var1:UpdateGoodsCnt(var1, var3)
			var7:updateGuildShop(var1)
			var5:consume({
				guildCoin = var9 * var3
			})
			var4:updatePlayer(var5)
			arg0:sendNotification(GAME.ON_GUILD_SHOP_PURCHASE_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
