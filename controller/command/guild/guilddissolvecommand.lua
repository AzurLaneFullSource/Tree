local var0 = class("GuildDissolveCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy)

	if not var1:getData() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60010, {
		id = var0
	}, 60011, function(arg0)
		if arg0.result == 0 then
			var1:exitGuild()
			arg0:sendNotification(GAME.GUILD_DISSOLVE_DONE)

			local var0 = getProxy(PlayerProxy)
			local var1 = var0:getData()

			var1:setGuildWaitTime(pg.TimeMgr.GetInstance():GetServerTime() + 86400)
			var0:updatePlayer(var1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_dissolve_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_dissolve_erro", arg0.result))
		end
	end)
end

return var0
