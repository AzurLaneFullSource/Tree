local var0_0 = class("SellIslandItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = {
		id = var1_1,
		num = var2_1
	}
	local var4_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	if var2_1 > var4_1:GetOwnCount(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21014, {
		type = 1,
		item_list = {
			var3_1
		}
	}, 21015, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:RemoveItem(var1_1, var2_1)

			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.item_list) do
				local var1_2 = {
					type = DROP_TYPE_ISLAND_ITEM,
					id = iter1_2.id,
					count = iter1_2.num
				}

				table.insert(var0_2, var1_2)
			end

			local var2_2 = IslandDropHelper.AddItems({
				drop_list = var0_2
			})

			arg0_1:sendNotification(GAME.ISLAND_SELL_ITEM_DONE, {
				dropData = var2_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
