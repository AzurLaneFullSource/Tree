local var0 = class("GuildJoinMissionCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.shipIds

	if not var1 or #var2 == 0 then
		return
	end

	if not arg0:CanFormationMission(var1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61007, {
		event_tid = var1,
		ship_ids = var2
	}, 61008, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()
			local var2 = var1:GetActiveEvent():GetMissionById(var1)
			local var3 = var2:GetCanFormationIndex()

			var2:UpdateFleet(var3, var2)
			var2:UpdateFormationTime(pg.TimeMgr.GetInstance():GetServerTime())
			var0:updateGuild(var1)
			arg0:sendNotification(GAME.GUILD_JOIN_MISSION_DONE, {
				id = var1
			})
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
