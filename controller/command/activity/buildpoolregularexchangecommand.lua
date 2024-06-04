local var0 = class("BuildPoolRegularExchangeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id

	if getProxy(BuildShipProxy):getRegularExchangeCount() < pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request then
		pg.TipsMgr:GetInstance():ShowTips("unenough")

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12047, {
		ship_tid = var0
	}, 12048, function(arg0)
		if arg0.result == 0 then
			getProxy(BuildShipProxy):changeRegularExchangeCount(-pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request)

			local var0 = PlayerConst.addTranDrop(arg0.drop_list)

			arg0:sendNotification(GAME.REGULAR_BUILD_POOL_EXCHANGE_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
