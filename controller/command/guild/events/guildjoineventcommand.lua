local var0_0 = class("GuildJoinEventCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(61031, {
		type = 0
	}, 61032, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()

			var1_2:GetActiveEvent():IncreaseJoinCnt()

			local var2_2 = pg.guildset.operation_event_guild_active.key_value
			local var3_2 = getProxy(PlayerProxy):getRawData().id

			var1_2:getMemberById(var3_2):AddLiveness(var2_2)
			var0_2:updateGuild(var1_2)
			arg0_1:sendNotification(GAME.ON_GUILD_JOIN_EVENT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
