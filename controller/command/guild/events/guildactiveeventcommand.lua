local var0_0 = class("GuildActiveEventCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(GuildProxy)
	local var2_1 = var0_1.eventId

	if not arg0_1:ExistEvent(var2_1) then
		return
	end

	if not arg0_1:NotExistActiveEvent() then
		return
	end

	if not arg0_1:IsAnim() then
		return
	end

	local var3_1 = var1_1:getData()
	local var4_1 = var3_1:GetEventById(var2_1)
	local var5_1 = var4_1:GetConsume()

	if not arg0_1:CheckCapital(var4_1, var5_1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61001, {
		chapter_id = var2_1
	}, 61002, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:IncActiveEventCnt()
			var3_1:consumeCapital(var5_1)
			var1_1:updateGuild(var3_1)
			arg0_1:sendNotification(GAME.GUILD_ACTIVE_EVENT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
