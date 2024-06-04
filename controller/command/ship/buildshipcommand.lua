local var0 = class("BuildShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.buildId
	local var2 = var0.count or 1
	local var3 = var0.isTicket
	local var4, var5, var6 = BuildShip.canBuildShipByBuildId(var1, var2, var3)

	if not var4 then
		if var6 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, var6)
		else
			pg.TipsMgr.GetInstance():ShowTips(var5)
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12002, {
		id = var1,
		count = var2,
		costtype = var3 and 1 or 0
	}, 12003, function(arg0)
		if arg0.result == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_SHIP, var2)

			local var0 = pg.ship_data_create_material[var1]

			if var3 then
				local var1 = getProxy(ActivityProxy)
				local var2 = var1:getBuildFreeActivityByBuildId(var1)

				var2.data1 = var2.data1 - var2

				var1:updateActivity(var2)
			else
				getProxy(BagProxy):removeItemById(var0.use_item, var0.number_1 * var2)

				local var3 = getProxy(PlayerProxy)
				local var4 = var3:getData()

				var4:consume({
					gold = var0.use_gold * var2
				})
				var3:updatePlayer(var4)
			end

			local var5 = getProxy(BuildShipProxy)

			if var0.exchange_count > 0 then
				var5:changeRegularExchangeCount(var2 * var0.exchange_count)
			end

			for iter0, iter1 in ipairs(arg0.build_info) do
				local var6 = BuildShip.New(iter1)

				var5:addBuildShip(var6)
			end

			arg0:sendNotification(GAME.BUILD_SHIP_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_buildShipMediator_startBuild"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_buildShip_error", arg0.result))
		end
	end)
end

return var0
