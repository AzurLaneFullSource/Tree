local var0_0 = class("GetExchangeShipsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().time

	pg.ConnectionMgr.GetInstance():Send(16100, {
		time = var0_1
	}, 16101, function(arg0_2)
		local var0_2 = getProxy(BuildShipProxy)
		local var1_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.ship_id_list) do
			table.insert(var1_2, {
				isFetched = false,
				id = iter1_2
			})
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.fetched_index_list) do
			var1_2[iter3_2].isFetched = true
		end

		var0_2:updateExchangeList(arg0_2.flag_ship_flash_time, arg0_2.flash_time, var1_2)
		arg0_1:sendNotification(GAME.GET_EXCHANGE_SHIPS_DONE)
	end)
end

return var0_0
