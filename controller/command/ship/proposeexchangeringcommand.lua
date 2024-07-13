local var0_0 = class("ProposeExchangeRingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(BagProxy)
	local var2_1 = pg.gameset.vow_prop_conversion.description

	if var1_1:getItemCountById(var2_1[1]) < 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(15010, {
		id = 0
	}, 15011, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:removeItemById(var2_1[1], 1)
			var1_1:addItemById(var2_1[2], 1)
			arg0_1:sendNotification(GAME.PROPOSE_EXCHANGE_RING_DONE, {
				items = {
					Drop.New({
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var2_1[2]
					})
				}
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
