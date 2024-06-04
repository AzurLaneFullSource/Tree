local var0 = class("WorldPortShoppingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().goods

	if var0.count <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return
	end

	local var1 = var0.moneyItem

	if var1:getOwnedCount() < var1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var1:getName()))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33403, {
		count = 1,
		shop_type = 1,
		shop_id = var0.id
	}, 33404, function(arg0)
		if arg0.result == 0 then
			var0:UpdateCount(var0.count - 1)
			reducePlayerOwn(var1)

			local var0 = nowWorld()
			local var1 = var0:GetActiveMap():GetPort()
			local var2 = underscore.filter(var1.goods, function(arg0)
				return arg0.count > 0
			end)

			var0:GetAtlas():UpdatePortMark(var1.id, #var2 > 0)

			local var3 = PlayerConst.addTranDrop(arg0.drop_list)

			arg0:sendNotification(GAME.WORLD_PORT_SHOPPING_DONE, {
				drops = var3
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_port_shopping_error_", arg0.result))
		end
	end)
end

return var0
