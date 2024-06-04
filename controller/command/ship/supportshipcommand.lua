local var0 = class("ExchangeShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().count
	local var1 = getProxy(BagProxy)
	local var2 = var1:getItemById(ITEM_ID_SILVER_HOOK)
	local var3 = getProxy(BuildShipProxy):getSupportShipCost() * var0
	local var4 = getProxy(BayProxy)
	local var5 = var4:getShips()

	if getProxy(PlayerProxy):getData():getMaxShipBag() < var4:getShipCount() + var0 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

		return
	end

	if var2 == nil or var3 > var2.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(16100, {
		cnt = var0
	}, 16101, function(arg0)
		if arg0.result == 0 then
			var1:removeItemById(ITEM_ID_SILVER_HOOK, var3)

			local var0 = {}

			for iter0, iter1 in ipairs(arg0.ship_list) do
				local var1 = Ship.New(iter1)

				var4:addShip(var1)
				table.insert(var0, var1)
			end

			arg0:sendNotification(GAME.SUPPORT_SHIP_DONE, {
				ships = var0
			})
		elseif arg0.result == 30 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("support_times_limited"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_exchange_erro", arg0.result))
		end
	end)
end

return var0
