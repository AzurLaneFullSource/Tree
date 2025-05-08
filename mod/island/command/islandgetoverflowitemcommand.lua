local var0_0 = class("IslandGetOverFlowItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(21006, {
		type = 0
	}, 21007, function(arg0_2)
		if arg0_2.result == 0 then
			if #arg0_2.item_list > 0 then
				local var0_2 = {}
				local var1_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

				for iter0_2, iter1_2 in ipairs(arg0_2.item_list) do
					local var2_2 = {
						type = DROP_TYPE_ISLAND_ITEM,
						id = iter1_2.id,
						count = iter1_2.num
					}

					var1_2:RemoveOverflowItem(iter1_2.id, iter1_2.num)
					table.insert(var0_2, var2_2)
				end

				local var3_2 = IslandDropHelper.AddItems({
					drop_list = var0_2
				})

				arg0_1:sendNotification(GAME.ISLAND_GET_OVERFLOW_ITEM_DOME, {
					awards = var3_2.awards
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
