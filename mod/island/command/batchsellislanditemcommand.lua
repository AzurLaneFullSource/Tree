local var0_0 = class("BatchSellIslandItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.list
	local var2_1 = var0_1.overflow
	local var3_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	if var2_1 then
		arg0_1:HandleOverflowBatchSell(var3_1, var1_1)
	else
		arg0_1:HandleCommonBatchSell(var3_1, var1_1)
	end
end

function var0_0.HandleOverflowBatchSell(arg0_2, arg1_2, arg2_2)
	pg.ConnectionMgr.GetInstance():Send(21014, {
		type = 2,
		item_list = arg2_2
	}, 21015, function(arg0_3)
		if arg0_3.result == 0 then
			for iter0_3, iter1_3 in ipairs(arg2_2) do
				arg1_2:RemoveOverflowItem(iter1_3.id, iter1_3.num)
			end

			local var0_3 = {}

			for iter2_3, iter3_3 in ipairs(arg0_3.item_list) do
				table.insert(var0_3, {
					type = DROP_TYPE_ISLAND_ITEM,
					id = iter3_3.id,
					number = iter3_3.num
				})
			end

			local var1_3 = IslandDropHelper.AddItems({
				drop_list = var0_3
			})

			arg0_2:sendNotification(GAME.ISLAND_SELL_ITEM_DONE, {
				dropData = var1_3
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.ret)
		end
	end)
end

function var0_0.HandleCommonBatchSell(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg2_4) do
		if arg1_4:GetOwnCount(iter1_4.id) < iter1_4.num then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(21014, {
		type = 1,
		item_list = arg2_4
	}, 21015, function(arg0_5)
		if arg0_5.result == 0 then
			for iter0_5, iter1_5 in ipairs(arg2_4) do
				arg1_4:RemoveItem(iter1_5.id, iter1_5.num)
			end

			local var0_5 = {}

			for iter2_5, iter3_5 in ipairs(arg0_5.item_list) do
				local var1_5 = {
					type = DROP_TYPE_ISLAND_ITEM,
					id = iter3_5.id,
					count = iter3_5.num
				}

				table.insert(var0_5, var1_5)
			end

			local var2_5 = IslandDropHelper.AddItems({
				drop_list = var0_5
			})

			arg0_4:sendNotification(GAME.ISLAND_SELL_ITEM_DONE, {
				dropData = var2_5
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.result] .. arg0_5.ret)
		end
	end)
end

return var0_0
