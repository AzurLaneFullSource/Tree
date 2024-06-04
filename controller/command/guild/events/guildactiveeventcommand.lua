local var0 = class("GuildActiveEventCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy)
	local var2 = var0.eventId

	if not arg0:ExistEvent(var2) then
		return
	end

	if not arg0:NotExistActiveEvent() then
		return
	end

	if not arg0:IsAnim() then
		return
	end

	local var3 = var1:getData()
	local var4 = var3:GetEventById(var2)
	local var5 = var4:GetConsume()

	if not arg0:CheckCapital(var4, var5) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61001, {
		chapter_id = var2
	}, 61002, function(arg0)
		if arg0.result == 0 then
			var3:IncActiveEventCnt()
			var3:consumeCapital(var5)
			var1:updateGuild(var3)
			arg0:sendNotification(GAME.GUILD_ACTIVE_EVENT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
