local var0_0 = class("IslandOpenRestaurantCommand", pm.SimpleCommand)

var0_0.OPEN_RESTAURANT = "IslandOpenRestaurantCommand.OPEN_RESTAURANT"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.restId
	local var2_1 = {}

	for iter0_1, iter1_1 in pairs(var0_1.ships) do
		table.insert(var2_1, {
			post_id = iter0_1,
			ship_id = iter1_1
		})
	end

	local var3_1 = {}

	for iter2_1, iter3_1 in pairs(var0_1.commodities) do
		table.insert(var3_1, {
			food_id = iter2_1,
			num = iter3_1
		})
	end

	pg.ConnectionMgr.GetInstance():Send(21418, {
		trade_id = var1_1,
		post_list = var2_1,
		food_list = var3_1
	}, 21419, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland()
			local var1_2 = var0_2:GetInventoryAgency()

			for iter0_2, iter1_2 in ipairs(var3_1) do
				var1_2:RemoveItem(iter1_2.food_id, iter1_2.num)
			end

			local var2_2 = var0_2:GetManageAgency():GetRestaurant(var1_1)

			var2_2:SetCommodities(arg0_2.trade_data.sell_list, arg0_2.trade_data.rest_list)
			var2_2:SetAssistants(arg0_2.trade_data.post_list)

			local var3_2 = arg0_2.trade_data.end_time

			var2_2:SetEndTime(var3_2)
			var2_2:ReduceRemainCnt()

			local var4_2 = var0_2:GetCharacterAgency()

			for iter2_2, iter3_2 in ipairs(arg0_2.ship_power) do
				local var5_2 = var4_2:GetShipById(iter3_2.ship_id)

				var5_2:UpdateEnergy(iter3_2.power)
				var5_2:UpdateEnergyBeginRecoverTime(var3_2)
				var5_2:UpdateState(IslandShip.STATE_RESTAURANT, var1_1)
			end

			var0_2:DispatchEvent(var0_0.OPEN_RESTAURANT, {
				restId = var1_1,
				postList = var2_1
			})
			arg0_1:sendNotification(GAME.ISLAND_OPEN_RESTAURANT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
