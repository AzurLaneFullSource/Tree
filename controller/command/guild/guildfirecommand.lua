local var0_0 = class("GuildFireCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(GuildProxy)
	local var2_1 = getProxy(PlayerProxy):getData()
	local var3_1 = var1_1:getData()

	if var3_1:getDutyByMemberId(var2_1.id) >= var3_1:getDutyByMemberId(var0_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_fire_duty_limit"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60014, {
		player_id = var0_1
	}, 60015, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var1_1:getData()
			local var1_2 = var1_1:getData()

			var1_2:deleteMember(var0_1)
			var1_1:updateGuild(var1_2)
			arg0_1:sendNotification(GAME.GUILD_FIRE_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_fire_succeed"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_fire_erro", arg0_2.result))
		end
	end)
end

return var0_0
