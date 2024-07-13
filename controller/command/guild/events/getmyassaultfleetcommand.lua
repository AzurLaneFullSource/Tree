local var0_0 = class("GetMyAssaultFleetCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(61009, {
		type = 0
	}, 61010, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()
			local var2_2 = getProxy(PlayerProxy):getRawData().id
			local var3_2 = var1_2:getMemberById(var2_2)

			assert(var3_2)

			local var4_2 = GuildAssaultFleet.New({})
			local var5_2 = {}
			local var6_2 = {}

			_.each(arg0_2.person_ships, function(arg0_3)
				local var0_3 = Ship.New(arg0_3.ship)

				var5_2[arg0_3.pos] = var0_3
				var6_2[arg0_3.pos] = arg0_3.last_time
			end)
			var4_2:InitShips(var2_2, var5_2)
			var3_2:UpdateExternalAssaultFleet(var4_2)
			var0_2:updateGuild(var1_2)

			var0_2.isFetchAssaultFleet = true

			for iter0_2, iter1_2 in ipairs(var6_2) do
				var0_2:UpdatePosCdTime(iter0_2, iter1_2)
			end

			arg0_1:sendNotification(GAME.GUILD_GET_MY_ASSAULT_FLEET_DONE)

			if var0_1 then
				var0_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
