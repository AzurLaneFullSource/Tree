local var0_0 = class("GuildGetAssaultFleetCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback
	local var1_1 = getProxy(GuildProxy)

	if not var1_1:ShouldRequestForamtion() then
		if var0_1 then
			var0_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61011, {
		type = 0
	}, 61012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var1_1:getData()
			local var1_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.recommends or {}) do
				if not var1_2[iter1_2.user_id] then
					var1_2[iter1_2.user_id] = {}
				end

				table.insert(var1_2[iter1_2.user_id], iter1_2.ship_id)
			end

			for iter2_2, iter3_2 in ipairs(arg0_2.ships) do
				local var2_2 = iter3_2.user_id
				local var3_2 = var0_2:getMemberById(var2_2)

				if var3_2 then
					local var4_2 = GuildAssaultFleet.New(iter3_2)
					local var5_2 = var1_2[var3_2.id]

					if var5_2 then
						var4_2:SetRecommendList(var5_2)
					end

					var3_2:UpdateAssaultFleet(var4_2)
				end
			end

			var1_1:updateGuild(var0_2)
			arg0_1:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")

			if var0_1 then
				var0_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
