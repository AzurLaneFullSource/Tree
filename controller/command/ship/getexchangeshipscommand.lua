local var0 = class("GetExchangeShipsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().time

	pg.ConnectionMgr.GetInstance():Send(16100, {
		time = var0
	}, 16101, function(arg0)
		local var0 = getProxy(BuildShipProxy)
		local var1 = {}

		for iter0, iter1 in ipairs(arg0.ship_id_list) do
			table.insert(var1, {
				isFetched = false,
				id = iter1
			})
		end

		for iter2, iter3 in ipairs(arg0.fetched_index_list) do
			var1[iter3].isFetched = true
		end

		var0:updateExchangeList(arg0.flag_ship_flash_time, arg0.flash_time, var1)
		arg0:sendNotification(GAME.GET_EXCHANGE_SHIPS_DONE)
	end)
end

return var0
