local var0_0 = class("GuildQuitCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(60018, {
		id = var0_1
	}, 60019, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(GuildProxy):exitGuild()
			arg0_1:sendNotification(GAME.GUILD_QUIT_DONE)

			local var0_2 = getProxy(PlayerProxy)
			local var1_2 = var0_2:getData()

			var1_2:setGuildWaitTime(pg.TimeMgr.GetInstance():GetServerTime() + 86400)
			var0_2:updatePlayer(var1_2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_quit_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_quit_erro", arg0_2.result))
		end
	end)
end

return var0_0
