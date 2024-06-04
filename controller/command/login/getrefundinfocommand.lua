local var0 = class("GetRefundInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(11023, {
		type = 1
	}, 11024, function(arg0)
		if arg0.result == 0 then
			getProxy(PlayerProxy):setRefundInfo(arg0.shop_info)
			pg.m02:sendNotification(GAME.REFUND_INFO_UPDATE)

			if arg1 and arg1:getBody() and arg1:getBody().callback then
				arg1:getBody().callback()
			end
		end
	end)
end

return var0
