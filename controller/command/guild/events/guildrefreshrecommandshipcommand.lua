local var0 = class("GuildRefreshRecommandShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback

	if var0.TIME and var0.TIME > pg.TimeMgr.GetInstance():GetServerTime() then
		if var0 then
			var0()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61035, {
		type = 0
	}, 61036, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.recommends or {}) do
			if not var0[iter1.user_id] then
				var0[iter1.user_id] = {}
			end

			table.insert(var0[iter1.user_id], iter1.ship_id)
		end

		local var1 = getProxy(GuildProxy)
		local var2 = var1:getData()
		local var3 = var2:GetMembers()

		for iter2, iter3 in ipairs(var3) do
			local var4 = var0[iter3.id]
			local var5 = iter3:GetAssaultFleet()

			var5:ClearAllRecommandShip()

			if var4 then
				var5:SetRecommendList(var4)
			end
		end

		var1:updateGuild(var2)
		arg0:sendNotification(GAME.REFRESH_ALL_ASSULT_SHIP_RECOMMAND_STATE_DONE)

		var0.TIME = pg.TimeMgr.GetInstance():GetServerTime() + 3

		if var0 then
			var0()
		end
	end)
end

return var0
