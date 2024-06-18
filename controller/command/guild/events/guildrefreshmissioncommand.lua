local var0_0 = class("GuildRefreshMissionCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback
	local var3_1 = var0_1.force

	if not arg0_1:ExistMission(var1_1) then
		return
	end

	if not arg0_1:GetMissionById(var1_1):ShouldRefresh() and not var3_1 then
		if var2_1 then
			var2_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61023, {
		event_tid = var1_1
	}, 61024, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()
			local var2_2 = var1_2:GetActiveEvent():GetMissionById(var1_1)
			local var3_2 = arg0_2.event_info

			if not var3_2 or var3_2.event_id == 0 then
				var3_2 = GuildMission.CompleteData2FullData(arg0_2.completed_info)
			end

			var2_2:Flush(var3_2, GuildConst.REFRESH_MISSION_TIME)
			var0_2:updateGuild(var1_2)
			arg0_1:sendNotification(GAME.GUILD_REFRESH_MISSION_DONE, {
				id = var2_2.id
			})
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")

			if var2_1 then
				var2_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
