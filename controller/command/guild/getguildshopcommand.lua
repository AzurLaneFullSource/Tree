local var0 = class("GetGuildShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type or 1
	local var2 = var0.callback
	local var3 = getProxy(PlayerProxy)
	local var4 = getProxy(ShopsProxy)

	if var1 == GuildConst.MANUAL_REFRESH and var3:getData():getResource(PlayerConst.ResGuildCoin) < var4:getGuildShop():GetResetConsume() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60033, {
		type = var1
	}, 60034, function(arg0)
		if arg0.result == 0 then
			local var0 = GuildShop.New(arg0.info)

			if var4.guildShop then
				var4:updateGuildShop(var0, true)
			else
				var4:setGuildShop(var0)
			end

			if var1 == GuildConst.MANUAL_REFRESH then
				local var1 = var0:GetResetConsume()
				local var2 = var3:getData()

				var2:consume({
					guildCoin = var1
				})
				var3:updatePlayer(var2)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_refresh_done"))
			end

			if var2 then
				var2(var0)
			end

			arg0:sendNotification(GAME.GET_GUILD_SHOP_DONE)
		else
			if var2 then
				var2()
			end

			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
