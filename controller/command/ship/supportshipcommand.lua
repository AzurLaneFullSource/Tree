local var0_0 = class("ExchangeShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().count
	local var1_1 = getProxy(BagProxy)
	local var2_1 = var1_1:getItemById(ITEM_ID_SILVER_HOOK)
	local var3_1 = getProxy(BuildShipProxy):getSupportShipCost() * var0_1
	local var4_1 = getProxy(BayProxy)
	local var5_1 = var4_1:getShips()

	if getProxy(PlayerProxy):getData():getMaxShipBag() < var4_1:getShipCount() + var0_1 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

		return
	end

	if var2_1 == nil or var3_1 > var2_1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(16100, {
		cnt = var0_1
	}, 16101, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:removeItemById(ITEM_ID_SILVER_HOOK, var3_1)

			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.ship_list) do
				local var1_2 = Ship.New(iter1_2)

				var4_1:addShip(var1_2)
				table.insert(var0_2, var1_2)
			end

			arg0_1:sendNotification(GAME.SUPPORT_SHIP_DONE, {
				ships = var0_2
			})
		elseif arg0_2.result == 30 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("support_times_limited"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_exchange_erro", arg0_2.result))
		end
	end)
end

return var0_0
