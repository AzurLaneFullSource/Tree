local var0_0 = class("IslandCloseRestaurantCommand", pm.SimpleCommand)

var0_0.CLOSE_RESTAURANT = "IslandCloseRestaurantCommand.CLOSE_RESTAURANT"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().restId

	pg.ConnectionMgr.GetInstance():Send(21420, {
		trade_id = var0_1
	}, 21421, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(var0_1)
			local var1_2 = var0_2:GetSellCommondities()
			local var2_2 = var0_2:GetRemainCommodities()
			local var3_2 = var0_2:GetSales()
			local var4_2 = {}
			local var5_2 = 0

			for iter0_2, iter1_2 in ipairs(var0_2:GetAssistants()) do
				var5_2 = var5_2 + 1

				if iter1_2.shipId ~= 0 then
					table.insert(var4_2, iter1_2.shipId)
				end
			end

			local var6_2 = var0_2:AddSales()

			var0_2:SetCommodities({}, {})
			var0_2:ClearAssistantShips()
			var0_2:SetEndTime(0)

			local var7_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_CLOSE_RESTAURANT_DONE, {
				restId = var0_1,
				saleList = var1_2,
				remainList = var2_2,
				isUpgrade = var6_2,
				oldShipCnt = var5_2,
				shipIds = var4_2,
				oldSale = var3_2,
				dropData = var7_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
