local var0_0 = class("IslandCloseRestaurantCommand", pm.SimpleCommand)

var0_0.CLOSE_RESTAURANT = "IslandCloseRestaurantCommand.CLOSE_RESTAURANT"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.restId
	local var2_1 = var0_1.isPost

	pg.ConnectionMgr.GetInstance():Send(21420, {
		trade_id = var1_1
	}, 21421, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(var1_1)
			local var1_2 = arg0_1:WarpItemInfo(var0_2)
			local var2_2 = arg0_2.event_add or 0
			local var3_2 = var0_2:GetEventInfo()
			local var4_2 = var3_2 ~= 0
			local var5_2 = var0_2:GetSellCommondities()
			local var6_2 = var0_2:GetRemainCommodities()
			local var7_2 = var0_2:GetSales()
			local var8_2 = {}
			local var9_2 = 0

			for iter0_2, iter1_2 in ipairs(var0_2:GetAssistants()) do
				var9_2 = var9_2 + 1

				if iter1_2.shipId ~= 0 then
					table.insert(var8_2, iter1_2.shipId)
				end
			end

			local var10_2 = var0_2:AddSales()

			var0_2:SetCommodities({}, {})
			var0_2:ClearAssistantShips()
			var0_2:SetEndTime(0)
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandCloseRest(var2_1 and 1 or 0, arg0_2.drop_list))

			local var11_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_CLOSE_RESTAURANT_DONE, {
				restId = var1_1,
				saleList = var5_2,
				remainList = var6_2,
				isUpgrade = var10_2,
				oldShipCnt = var9_2,
				shipIds = var8_2,
				oldSale = var7_2,
				dropData = var11_2,
				isSpEvent = var4_2,
				spEventID = var3_2,
				itemList = var1_2,
				priceAdd = var2_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.WarpItemInfo(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3, var2_3 = arg1_3:GetEventInfo()
	local var3_3 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_3, iter1_3 in ipairs(arg1_3:getConfig("item_id")) do
		local var4_3 = var3_3:GetItemById(iter1_3[1])

		if var4_3 and var2_3[var4_3.id] then
			table.insert(var0_3, var4_3.id)
		end
	end

	return var0_3
end

return var0_0
