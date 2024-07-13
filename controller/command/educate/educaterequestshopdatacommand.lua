local var0_0 = class("EducateRequestShopDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27043, {
		shop_id = var0_1.shopId,
		goods = var0_1.goods
	}, 27044, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = EducateShop.New(arg0_2.shop_data.shop_id, arg0_2.shop_data.goods)

			getProxy(EducateProxy):GetShopProxy():UpdateShop(var0_2)
			arg0_1:sendNotification(GAME.EDUCATE_REQUEST_SHOP_DATA_DONE)

			if var1_1 then
				var1_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate request shop data error: ", arg0_2.result))
		end
	end)
end

return var0_0
