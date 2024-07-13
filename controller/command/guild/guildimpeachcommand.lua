local var0_0 = class("GuildImpeachCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if getProxy(GuildProxy):getData():inKickTime() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_commder_in_impeach_time"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60016, {
		player_id = var0_1
	}, 60017, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()
			local var2_2 = pg.TimeMgr.GetInstance():GetServerTime() + 86400

			var1_2:setkickLeaderTime(var2_2)
			var0_2:updateGuild(var1_2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_impeach_sucess"))
			arg0_1:sendNotification(GAME.GUILD_IMPEACH_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_impeach_erro", arg0_2.result))
		end
	end)
end

return var0_0
