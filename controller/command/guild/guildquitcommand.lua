local var0 = class("GuildQuitCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(60018, {
		id = var0
	}, 60019, function(arg0)
		if arg0.result == 0 then
			getProxy(GuildProxy):exitGuild()
			arg0:sendNotification(GAME.GUILD_QUIT_DONE)

			local var0 = getProxy(PlayerProxy)
			local var1 = var0:getData()

			var1:setGuildWaitTime(pg.TimeMgr.GetInstance():GetServerTime() + 86400)
			var0:updatePlayer(var1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_quit_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_quit_erro", arg0.result))
		end
	end)
end

return var0
