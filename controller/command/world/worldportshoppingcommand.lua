local var0_0 = class("WorldPortShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().goods

	if var0_1.count <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return
	end

	local var1_1 = var0_1.moneyItem

	if var1_1:getOwnedCount() < var1_1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var1_1:getName()))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33403, {
		count = 1,
		shop_type = 1,
		shop_id = var0_1.id
	}, 33404, function(arg0_2)
		if arg0_2.result == 0 then
			var0_1:UpdateCount(var0_1.count - 1)
			reducePlayerOwn(var1_1)

			local var0_2 = nowWorld()
			local var1_2 = var0_2:GetActiveMap():GetPort()
			local var2_2 = underscore.filter(var1_2.goods, function(arg0_3)
				return arg0_3.count > 0
			end)

			var0_2:GetAtlas():UpdatePortMark(var1_2.id, #var2_2 > 0)

			local var3_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			arg0_1:sendNotification(GAME.WORLD_PORT_SHOPPING_DONE, {
				drops = var3_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_port_shopping_error_", arg0_2.result))
		end
	end)
end

return var0_0
