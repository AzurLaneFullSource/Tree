local var0 = class("GetExchangeItemsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().type

	pg.ConnectionMgr.GetInstance():Send(16106, {
		type = 0
	}, 16107, function(arg0)
		local var0 = getProxy(BuildShipProxy)
		local var1 = {}

		for iter0, iter1 in ipairs(arg0.item_shop_id_list) do
			table.insert(var1, {
				isFetched = false,
				id = iter1
			})
		end

		for iter2, iter3 in ipairs(arg0.item_fetch_list) do
			for iter4, iter5 in pairs(var1) do
				if iter5.id == iter3 then
					var1[iter4].isFetched = true
				end
			end
		end

		var0:updateExchangeItemList(arg0.item_flash_time, var1)

		if var0 and var0 == 1 then
			var0:addExChangeItemTimer()
		end

		arg0:sendNotification(GAME.GET_EXCHANGE_ITEMS_DONE)
	end)
end

return var0
