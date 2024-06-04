local var0 = class("GetGuildBossInfoCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if not arg0:ExistActiveEvent() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61027, {
		type = 0
	}, 61028, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()

			var1:GetActiveEvent():GetBossMission():Flush(arg0.boss_event)
			var0:updateGuild(var1)
			var0:SetRefreshBossTime(pg.TimeMgr.GetInstance():GetServerTime())
			arg0:sendNotification(GAME.GUILD_GET_BOSS_INFO_DONE)
		elseif arg0.result == 20 then
			local var2 = getProxy(GuildProxy):getData()
			local var3 = var2:GetActiveEvent()
			local var4 = false

			if var3 then
				var3:Deactivate()

				var4 = true
			end

			getProxy(GuildProxy):updateGuild(var2)

			if var4 then
				pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildEvent")
				pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildBossEvent")
			end

			arg0:sendNotification(GAME.GUILD_END_BATTLE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
