local var0 = class("SetGuildDutyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.playerId
	local var2 = var0.dutyId

	if not var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_duty_id_is_null"))

		return
	end

	if not var1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_player_is_null"))

		return
	end

	local var3 = getProxy(GuildProxy):getData()

	if var2 == GuildConst.DUTY_DEPUTY_COMMANDER and var3:getAssistantCount() == var3:getAssistantMaxCount() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_duty_commder_max_count"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60012, {
		player_id = var1,
		duty_id = var2
	}, 60013, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()
			local var2 = var1:getMemberById(var1)

			var2:setDuty(var2)

			if var2 == GuildConst.DUTY_COMMANDER then
				local var3 = getProxy(PlayerProxy):getRawData().id

				var1:getMemberById(var3):setDuty(GuildConst.DUTY_ORDINARY)
			end

			var0:updateGuild(var1)
			arg0:sendNotification(GAME.SET_GUILD_DUTY_DONE, var2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_set_duty_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_setduty_erro", arg0.result))
		end
	end)
end

return var0
