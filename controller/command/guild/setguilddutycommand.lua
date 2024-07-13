local var0_0 = class("SetGuildDutyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.playerId
	local var2_1 = var0_1.dutyId

	if not var2_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_duty_id_is_null"))

		return
	end

	if not var1_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_player_is_null"))

		return
	end

	local var3_1 = getProxy(GuildProxy):getData()

	if var2_1 == GuildConst.DUTY_DEPUTY_COMMANDER and var3_1:getAssistantCount() == var3_1:getAssistantMaxCount() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_duty_commder_max_count"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60012, {
		player_id = var1_1,
		duty_id = var2_1
	}, 60013, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()
			local var2_2 = var1_2:getMemberById(var1_1)

			var2_2:setDuty(var2_1)

			if var2_1 == GuildConst.DUTY_COMMANDER then
				local var3_2 = getProxy(PlayerProxy):getRawData().id

				var1_2:getMemberById(var3_2):setDuty(GuildConst.DUTY_ORDINARY)
			end

			var0_2:updateGuild(var1_2)
			arg0_1:sendNotification(GAME.SET_GUILD_DUTY_DONE, var2_2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_set_duty_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_setduty_erro", arg0_2.result))
		end
	end)
end

return var0_0
