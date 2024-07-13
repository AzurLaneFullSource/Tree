local var0_0 = class("GetGuildBossInfoCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if not arg0_1:ExistActiveEvent() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61027, {
		type = 0
	}, 61028, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()

			var1_2:GetActiveEvent():GetBossMission():Flush(arg0_2.boss_event)
			var0_2:updateGuild(var1_2)
			var0_2:SetRefreshBossTime(pg.TimeMgr.GetInstance():GetServerTime())
			arg0_1:sendNotification(GAME.GUILD_GET_BOSS_INFO_DONE)
		elseif arg0_2.result == 20 then
			local var2_2 = getProxy(GuildProxy):getData()
			local var3_2 = var2_2:GetActiveEvent()
			local var4_2 = false

			if var3_2 then
				var3_2:Deactivate()

				var4_2 = true
			end

			getProxy(GuildProxy):updateGuild(var2_2)

			if var4_2 then
				pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildEvent")
				pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildBossEvent")
			end

			arg0_1:sendNotification(GAME.GUILD_END_BATTLE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
