local var0_0 = class("GetRefundInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	pg.ConnectionMgr.GetInstance():Send(11023, {
		type = 1
	}, 11024, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(PlayerProxy):setRefundInfo(arg0_2.shop_info)
			pg.m02:sendNotification(GAME.REFUND_INFO_UPDATE)

			if arg1_1 and arg1_1:getBody() and arg1_1:getBody().callback then
				arg1_1:getBody().callback()
			end
		end
	end)
end

return var0_0
