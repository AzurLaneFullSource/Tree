local var0_0 = class("GetExchangeItemsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().type

	pg.ConnectionMgr.GetInstance():Send(16106, {
		type = 0
	}, 16107, function(arg0_2)
		local var0_2 = getProxy(BuildShipProxy)
		local var1_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.item_shop_id_list) do
			table.insert(var1_2, {
				isFetched = false,
				id = iter1_2
			})
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.item_fetch_list) do
			for iter4_2, iter5_2 in pairs(var1_2) do
				if iter5_2.id == iter3_2 then
					var1_2[iter4_2].isFetched = true
				end
			end
		end

		var0_2:updateExchangeItemList(arg0_2.item_flash_time, var1_2)

		if var0_1 and var0_1 == 1 then
			var0_2:addExChangeItemTimer()
		end

		arg0_1:sendNotification(GAME.GET_EXCHANGE_ITEMS_DONE)
	end)
end

return var0_0
