local var0_0 = class("WorldPortNewShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.goods
	local var2_1 = var0_1.count

	if not var1_1:canPurchase() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return
	end

	local var3_1 = var1_1:GetPriceInfo()

	var3_1.count = var3_1.count * var2_1

	if var3_1:getOwnedCount() < var3_1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var3_1:getName()))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33403, {
		shop_type = 2,
		shop_id = var1_1.id,
		count = var2_1
	}, 33404, function(arg0_2)
		if arg0_2.result == 0 then
			reducePlayerOwn(var3_1)
			nowWorld():GetAtlas():UpdateNShopGoodsCount(var1_1.id, var2_1)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			arg0_1:sendNotification(GAME.WORLD_PORT_NEW_SHOPPING_DONE, {
				drops = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_port_shopping_error_", arg0_2.result))
		end
	end)
end

return var0_0
