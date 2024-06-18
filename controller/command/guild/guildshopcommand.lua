local var0_0 = class("GuildShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.goodsId
	local var2_1 = var0_1.selectedId
	local var3_1 = #var2_1
	local var4_1 = getProxy(PlayerProxy)
	local var5_1 = var4_1:getData()
	local var6_1 = var5_1:getResource(8)
	local var7_1 = getProxy(ShopsProxy)
	local var8_1 = var7_1:getGuildShop():getGoodsById(var1_1)
	local var9_1 = var8_1:GetPrice()

	if var6_1 < var9_1 * var3_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var8_1:CanPurchaseCnt(var3_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_cnt_no_enough"))

		return
	end

	local var10_1 = {}

	for iter0_1, iter1_1 in ipairs(var2_1) do
		if not var10_1[iter1_1] then
			var10_1[iter1_1] = {
				count = 1,
				id = iter1_1
			}
		else
			var10_1[iter1_1].count = var10_1[iter1_1].count + 1
		end
	end

	pg.ConnectionMgr.GetInstance():Send(60035, {
		goodsid = var8_1.configId,
		index = var8_1.index,
		selected = _.values(var10_1)
	}, 60036, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
			local var1_2 = var7_1:getGuildShop()

			var1_2:UpdateGoodsCnt(var1_1, var3_1)
			var7_1:updateGuildShop(var1_2)
			var5_1:consume({
				guildCoin = var9_1 * var3_1
			})
			var4_1:updatePlayer(var5_1)
			arg0_1:sendNotification(GAME.ON_GUILD_SHOP_PURCHASE_DONE, {
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
