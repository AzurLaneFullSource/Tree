local var0 = class("GuildGetAssaultFleetCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback
	local var1 = getProxy(GuildProxy)

	if not var1:ShouldRequestForamtion() then
		if var0 then
			var0()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61011, {
		type = 0
	}, 61012, function(arg0)
		if arg0.result == 0 then
			local var0 = var1:getData()
			local var1 = {}

			for iter0, iter1 in ipairs(arg0.recommends or {}) do
				if not var1[iter1.user_id] then
					var1[iter1.user_id] = {}
				end

				table.insert(var1[iter1.user_id], iter1.ship_id)
			end

			for iter2, iter3 in ipairs(arg0.ships) do
				local var2 = iter3.user_id
				local var3 = var0:getMemberById(var2)

				if var3 then
					local var4 = GuildAssaultFleet.New(iter3)
					local var5 = var1[var3.id]

					if var5 then
						var4:SetRecommendList(var5)
					end

					var3:UpdateAssaultFleet(var4)
				end
			end

			var1:updateGuild(var0)
			arg0:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")

			if var0 then
				var0()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
