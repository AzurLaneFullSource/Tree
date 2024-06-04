local var0 = class("GetMyAssaultFleetCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(61009, {
		type = 0
	}, 61010, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()
			local var2 = getProxy(PlayerProxy):getRawData().id
			local var3 = var1:getMemberById(var2)

			assert(var3)

			local var4 = GuildAssaultFleet.New({})
			local var5 = {}
			local var6 = {}

			_.each(arg0.person_ships, function(arg0)
				local var0 = Ship.New(arg0.ship)

				var5[arg0.pos] = var0
				var6[arg0.pos] = arg0.last_time
			end)
			var4:InitShips(var2, var5)
			var3:UpdateExternalAssaultFleet(var4)
			var0:updateGuild(var1)

			var0.isFetchAssaultFleet = true

			for iter0, iter1 in ipairs(var6) do
				var0:UpdatePosCdTime(iter0, iter1)
			end

			arg0:sendNotification(GAME.GUILD_GET_MY_ASSAULT_FLEET_DONE)

			if var0 then
				var0()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
