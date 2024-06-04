local var0 = class("GuildImpeachCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if getProxy(GuildProxy):getData():inKickTime() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_commder_in_impeach_time"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60016, {
		player_id = var0
	}, 60017, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()
			local var2 = pg.TimeMgr.GetInstance():GetServerTime() + 86400

			var1:setkickLeaderTime(var2)
			var0:updateGuild(var1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_impeach_sucess"))
			arg0:sendNotification(GAME.GUILD_IMPEACH_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_impeach_erro", arg0.result))
		end
	end)
end

return var0
