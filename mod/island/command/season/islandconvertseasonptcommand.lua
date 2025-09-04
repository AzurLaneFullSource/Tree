local var0_0 = class("IslandConvertSeasonPtCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.list

	pg.ConnectionMgr.GetInstance():Send(21014, {
		type = var1_1,
		item_list = var2_1
	}, 21015, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
			local var1_2 = 0
			local var2_2 = pg.island_item_data_template

			for iter0_2, iter1_2 in ipairs(var2_1) do
				if var1_1 == 2 then
					var0_2:RemoveOverflowItem(iter1_2.id, iter1_2.num)
				elseif var1_1 == 1 then
					var0_2:RemoveItem(iter1_2.id, iter1_2.num)
				end

				if var2_2[iter1_2.id].convert == 1 then
					var1_2 = var1_2 + var2_2[iter1_2.id].pt_num * iter1_2.num
				end
			end

			local var3_2 = {}

			for iter2_2, iter3_2 in ipairs(arg0_2.item_list) do
				table.insert(var3_2, {
					type = DROP_TYPE_ISLAND_ITEM,
					id = iter3_2.id,
					count = iter3_2.num
				})
			end

			table.insert(var3_2, {
				id = 0,
				type = VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT,
				count = var1_2
			})

			local var4_2 = IslandDropHelper.AddItems({
				drop_list = var3_2
			})

			arg0_1:sendNotification(GAME.ISLAND_CONVERT_SEASON_PT_DONE, {
				dropData = var4_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
