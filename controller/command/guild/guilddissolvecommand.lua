local var0_0 = class("GuildDissolveCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(GuildProxy)

	if not var1_1:getData() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60010, {
		id = var0_1
	}, 60011, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:exitGuild()
			arg0_1:sendNotification(GAME.GUILD_DISSOLVE_DONE)

			local var0_2 = getProxy(PlayerProxy)
			local var1_2 = var0_2:getData()

			var1_2:setGuildWaitTime(pg.TimeMgr.GetInstance():GetServerTime() + 86400)
			var0_2:updatePlayer(var1_2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_dissolve_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_dissolve_erro", arg0_2.result))
		end
	end)
end

return var0_0
