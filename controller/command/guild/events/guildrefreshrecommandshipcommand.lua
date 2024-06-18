local var0_0 = class("GuildRefreshRecommandShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	if var0_0.TIME and var0_0.TIME > pg.TimeMgr.GetInstance():GetServerTime() then
		if var0_1 then
			var0_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61035, {
		type = 0
	}, 61036, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.recommends or {}) do
			if not var0_2[iter1_2.user_id] then
				var0_2[iter1_2.user_id] = {}
			end

			table.insert(var0_2[iter1_2.user_id], iter1_2.ship_id)
		end

		local var1_2 = getProxy(GuildProxy)
		local var2_2 = var1_2:getData()
		local var3_2 = var2_2:GetMembers()

		for iter2_2, iter3_2 in ipairs(var3_2) do
			local var4_2 = var0_2[iter3_2.id]
			local var5_2 = iter3_2:GetAssaultFleet()

			var5_2:ClearAllRecommandShip()

			if var4_2 then
				var5_2:SetRecommendList(var4_2)
			end
		end

		var1_2:updateGuild(var2_2)
		arg0_1:sendNotification(GAME.REFRESH_ALL_ASSULT_SHIP_RECOMMAND_STATE_DONE)

		var0_0.TIME = pg.TimeMgr.GetInstance():GetServerTime() + 3

		if var0_1 then
			var0_1()
		end
	end)
end

return var0_0
