local var0_0 = class("BuildPoolRegularExchangeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	if getProxy(BuildShipProxy):getRegularExchangeCount() < pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request then
		pg.TipsMgr:GetInstance():ShowTips("unenough")

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12047, {
		ship_tid = var0_1
	}, 12048, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(BuildShipProxy):changeRegularExchangeCount(-pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			arg0_1:sendNotification(GAME.REGULAR_BUILD_POOL_EXCHANGE_DONE, {
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
