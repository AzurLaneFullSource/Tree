local var0_0 = class("BackYardRequestShipExpCommand", pm.SimpleCommand)

var0_0.isTipSettle = true

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= CourtYardMediator.__cname then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(19026, {
		type = 0
	}, 19027, function(arg0_2)
		local var0_2 = getProxy(DormProxy)
		local var1_2 = var0_2:getRawData()
		local var2_2 = var1_2:GetLastAddShipExpTime()

		var1_2:consumeFood(arg0_2.food)
		var1_2:UpdateLastAddShipExpTime(pg.TimeMgr.GetInstance():GetServerTime())
		var1_2:UpdateNextSettlementShipExpTime(arg0_2.next_timestamp)
		var0_2:updateDrom(var1_2, BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD)

		local var3_2 = arg0_2.exp

		if var3_2 > 0 then
			local var4_2 = var1_2:GetBayShipOnFloor(DormShip.FLOOR_1)
			local var5_2 = getProxy(BayProxy)
			local var6_2 = {}
			local var7_2 = {}

			for iter0_2, iter1_2 in pairs(var4_2) do
				local var8_2 = var5_2:getShipById(iter1_2.id)
				local var9_2 = var5_2:getShipById(iter1_2.id)

				if var9_2.level ~= var9_2:getMaxLevel() then
					var9_2:addExp(var3_2)
					var5_2:updateShip(var9_2)
					arg0_1:sendNotification(GAME.BACKYARD_SHIP_EXP_ADDED, {
						id = var9_2.id,
						exp = var3_2
					})
				end

				var6_2[var9_2.id] = var9_2
				var7_2[var8_2.id] = var8_2
			end

			local var10_2 = var0_0.isTipSettle

			arg0_1:sendNotification(DormProxy.SHIPS_EXP_ADDED, {
				oldShips = var7_2,
				newShips = var6_2,
				exp = var3_2,
				food = arg0_2.food,
				time = var2_2,
				isTipSettle = var10_2
			})

			var0_0.isTipSettle = false
		end

		var0_2:SettlementShipExp()
	end)
end

return var0_0
