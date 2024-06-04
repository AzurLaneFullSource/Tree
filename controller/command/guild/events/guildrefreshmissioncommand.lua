local var0 = class("GuildRefreshMissionCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.callback
	local var3 = var0.force

	if not arg0:ExistMission(var1) then
		return
	end

	if not arg0:GetMissionById(var1):ShouldRefresh() and not var3 then
		if var2 then
			var2()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61023, {
		event_tid = var1
	}, 61024, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()
			local var2 = var1:GetActiveEvent():GetMissionById(var1)
			local var3 = arg0.event_info

			if not var3 or var3.event_id == 0 then
				var3 = GuildMission.CompleteData2FullData(arg0.completed_info)
			end

			var2:Flush(var3, GuildConst.REFRESH_MISSION_TIME)
			var0:updateGuild(var1)
			arg0:sendNotification(GAME.GUILD_REFRESH_MISSION_DONE, {
				id = var2.id
			})
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")

			if var2 then
				var2()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
