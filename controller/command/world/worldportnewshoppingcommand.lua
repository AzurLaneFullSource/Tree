local var0 = class("WorldPortNewShoppingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.goods
	local var2 = var0.count

	if not var1:canPurchase() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return
	end

	local var3 = var1:GetPriceInfo()

	var3.count = var3.count * var2

	if var3:getOwnedCount() < var3.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var3:getName()))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33403, {
		shop_type = 2,
		shop_id = var1.id,
		count = var2
	}, 33404, function(arg0)
		if arg0.result == 0 then
			reducePlayerOwn(var3)
			nowWorld():GetAtlas():UpdateNShopGoodsCount(var1.id, var2)

			local var0 = PlayerConst.addTranDrop(arg0.drop_list)

			arg0:sendNotification(GAME.WORLD_PORT_NEW_SHOPPING_DONE, {
				drops = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_port_shopping_error_", arg0.result))
		end
	end)
end

return var0
