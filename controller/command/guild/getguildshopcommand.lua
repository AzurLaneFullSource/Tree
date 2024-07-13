local var0_0 = class("GetGuildShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type or 1
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(PlayerProxy)
	local var4_1 = getProxy(ShopsProxy)

	if var1_1 == GuildConst.MANUAL_REFRESH and var3_1:getData():getResource(PlayerConst.ResGuildCoin) < var4_1:getGuildShop():GetResetConsume() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60033, {
		type = var1_1
	}, 60034, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = GuildShop.New(arg0_2.info)

			if var4_1.guildShop then
				var4_1:updateGuildShop(var0_2, true)
			else
				var4_1:setGuildShop(var0_2)
			end

			if var1_1 == GuildConst.MANUAL_REFRESH then
				local var1_2 = var0_2:GetResetConsume()
				local var2_2 = var3_1:getData()

				var2_2:consume({
					guildCoin = var1_2
				})
				var3_1:updatePlayer(var2_2)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_refresh_done"))
			end

			if var2_1 then
				var2_1(var0_2)
			end

			arg0_1:sendNotification(GAME.GET_GUILD_SHOP_DONE)
		else
			if var2_1 then
				var2_1()
			end

			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
