local var0_0 = class("GuildFetchCapitalCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(62024, {
		type = 0
	}, 62025, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()

			var1_2:setRefreshCaptialTime()
			var1_2:updateCapital(arg0_2.capital)
			var0_2:updateGuild(var1_2)
			arg0_1:sendNotification(GAME.GUILD_REFRESH_CAPITAL_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
