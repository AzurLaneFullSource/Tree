local var0 = class("GuildJoinEventCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(61031, {
		type = 0
	}, 61032, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()

			var1:GetActiveEvent():IncreaseJoinCnt()

			local var2 = pg.guildset.operation_event_guild_active.key_value
			local var3 = getProxy(PlayerProxy):getRawData().id

			var1:getMemberById(var3):AddLiveness(var2)
			var0:updateGuild(var1)
			arg0:sendNotification(GAME.ON_GUILD_JOIN_EVENT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
