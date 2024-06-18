local var0_0 = class("GuildJoinMissionCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.shipIds

	if not var1_1 or #var2_1 == 0 then
		return
	end

	if not arg0_1:CanFormationMission(var1_1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61007, {
		event_tid = var1_1,
		ship_ids = var2_1
	}, 61008, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()
			local var2_2 = var1_2:GetActiveEvent():GetMissionById(var1_1)
			local var3_2 = var2_2:GetCanFormationIndex()

			var2_2:UpdateFleet(var3_2, var2_1)
			var2_2:UpdateFormationTime(pg.TimeMgr.GetInstance():GetServerTime())
			var0_2:updateGuild(var1_2)
			arg0_1:sendNotification(GAME.GUILD_JOIN_MISSION_DONE, {
				id = var1_1
			})
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
