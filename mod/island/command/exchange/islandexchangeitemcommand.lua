local var0_0 = class("IslandExchangeItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.list
	local var2_1 = var0_1.tempId
	local var3_1 = var0_1.tempCnt
	local var4_1 = {}

	for iter0_1, iter1_1 in ipairs(var1_1) do
		table.insert(var4_1, {
			make_id = iter1_1.exchangeId,
			num = iter1_1.num
		})
	end

	pg.ConnectionMgr.GetInstance():Send(21066, {
		makes = var4_1
	}, 21067, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

			for iter0_2, iter1_2 in ipairs(var1_1) do
				var0_2:RemoveItem(iter1_2.itemId, iter1_2.num)
			end

			local var1_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_EXCHANGE_ITEM_DONE, {
				dropData = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
