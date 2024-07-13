local var0_0 = class("GuildGetActivationEventCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.force
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(GuildProxy)

	if not var3_1:ShouldFetchActivationEvent() and not var1_1 then
		if var2_1 then
			var2_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61005, {
		type = 0
	}, 61006, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = arg0_2.operation.operation_id
			local var1_2 = var3_1:getData()
			local var2_2 = var1_2:GetActiveEvent()

			if var2_2 then
				var2_2:Deactivate()
			end

			var1_2:GetEventById(var0_2):Active(arg0_2.operation)
			var3_1:AddFetchActivationEventCDTime()
			var3_1:updateGuild(var1_2)
			arg0_1:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildBossEvent")

			if var2_1 then
				var2_1()
			end
		else
			local var3_2 = var3_1:getData()
			local var4_2 = var3_2:GetActiveEvent()

			if var4_2 then
				var4_2:Deactivate()
			end

			var3_1:updateGuild(var3_2)
			arg0_1:sendNotification(GAME.ON_GUILD_EVENT_END)

			if var2_1 then
				var2_1()
			end
		end
	end)
end

return var0_0
