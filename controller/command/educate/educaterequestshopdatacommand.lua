local var0 = class("EducateRequestShopDataCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27043, {
		shop_id = var0.shopId,
		goods = var0.goods
	}, 27044, function(arg0)
		if arg0.result == 0 then
			local var0 = EducateShop.New(arg0.shop_data.shop_id, arg0.shop_data.goods)

			getProxy(EducateProxy):GetShopProxy():UpdateShop(var0)
			arg0:sendNotification(GAME.EDUCATE_REQUEST_SHOP_DATA_DONE)

			if var1 then
				var1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate request shop data error: ", arg0.result))
		end
	end)
end

return var0
