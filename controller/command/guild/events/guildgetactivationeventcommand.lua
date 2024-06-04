local var0 = class("GuildGetActivationEventCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.force
	local var2 = var0.callback
	local var3 = getProxy(GuildProxy)

	if not var3:ShouldFetchActivationEvent() and not var1 then
		if var2 then
			var2()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61005, {
		type = 0
	}, 61006, function(arg0)
		if arg0.result == 0 then
			local var0 = arg0.operation.operation_id
			local var1 = var3:getData()
			local var2 = var1:GetActiveEvent()

			if var2 then
				var2:Deactivate()
			end

			var1:GetEventById(var0):Active(arg0.operation)
			var3:AddFetchActivationEventCDTime()
			var3:updateGuild(var1)
			arg0:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildBossEvent")

			if var2 then
				var2()
			end
		else
			local var3 = var3:getData()
			local var4 = var3:GetActiveEvent()

			if var4 then
				var4:Deactivate()
			end

			var3:updateGuild(var3)
			arg0:sendNotification(GAME.ON_GUILD_EVENT_END)

			if var2 then
				var2()
			end
		end
	end)
end

return var0
