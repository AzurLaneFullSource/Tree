local var0 = class("ProposeExchangeRingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(BagProxy)
	local var2 = pg.gameset.vow_prop_conversion.description

	if var1:getItemCountById(var2[1]) < 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(15010, {
		id = 0
	}, 15011, function(arg0)
		if arg0.result == 0 then
			var1:removeItemById(var2[1], 1)
			var1:addItemById(var2[2], 1)
			arg0:sendNotification(GAME.PROPOSE_EXCHANGE_RING_DONE, {
				items = {
					Drop.New({
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var2[2]
					})
				}
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
