local var0 = class("GuildFireCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy)
	local var2 = getProxy(PlayerProxy):getData()
	local var3 = var1:getData()

	if var3:getDutyByMemberId(var2.id) >= var3:getDutyByMemberId(var0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_fire_duty_limit"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60014, {
		player_id = var0
	}, 60015, function(arg0)
		if arg0.result == 0 then
			local var0 = var1:getData()
			local var1 = var1:getData()

			var1:deleteMember(var0)
			var1:updateGuild(var1)
			arg0:sendNotification(GAME.GUILD_FIRE_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_fire_succeed"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_fire_erro", arg0.result))
		end
	end)
end

return var0
