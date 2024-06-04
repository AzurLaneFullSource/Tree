local var0 = class("GuildFetchCapitalCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(62024, {
		type = 0
	}, 62025, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()

			var1:setRefreshCaptialTime()
			var1:updateCapital(arg0.capital)
			var0:updateGuild(var1)
			arg0:sendNotification(GAME.GUILD_REFRESH_CAPITAL_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
