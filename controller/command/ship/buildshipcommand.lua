local var0_0 = class("BuildShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.buildId
	local var2_1 = var0_1.count or 1
	local var3_1 = var0_1.isTicket
	local var4_1, var5_1, var6_1 = BuildShip.canBuildShipByBuildId(var1_1, var2_1, var3_1)

	if not var4_1 then
		if var6_1 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, var6_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(var5_1)
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12002, {
		id = var1_1,
		count = var2_1,
		costtype = var3_1 and 1 or 0
	}, 12003, function(arg0_2)
		if arg0_2.result == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_SHIP, var2_1)

			local var0_2 = pg.ship_data_create_material[var1_1]

			if var3_1 then
				local var1_2 = getProxy(ActivityProxy)
				local var2_2 = var1_2:getBuildFreeActivityByBuildId(var1_1)

				var2_2.data1 = var2_2.data1 - var2_1

				var1_2:updateActivity(var2_2)
			else
				getProxy(BagProxy):removeItemById(var0_2.use_item, var0_2.number_1 * var2_1)

				local var3_2 = getProxy(PlayerProxy)
				local var4_2 = var3_2:getData()

				var4_2:consume({
					gold = var0_2.use_gold * var2_1
				})
				var3_2:updatePlayer(var4_2)
			end

			local var5_2 = getProxy(BuildShipProxy)

			if var0_2.exchange_count > 0 then
				var5_2:changeRegularExchangeCount(var2_1 * var0_2.exchange_count)
			end

			for iter0_2, iter1_2 in ipairs(arg0_2.build_info) do
				local var6_2 = BuildShip.New(iter1_2)

				var5_2:addBuildShip(var6_2)
			end

			arg0_1:sendNotification(GAME.BUILD_SHIP_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_buildShipMediator_startBuild"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_buildShip_error", arg0_2.result))
		end
	end)
end

return var0_0
