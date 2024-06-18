local var0_0 = class("ShipExitCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(DormProxy)
	local var2_1 = var0_1.shipId
	local var3_1 = getProxy(BayProxy)
	local var4_1 = var3_1:getShipById(var2_1)
	local var5_1 = var0_1.callback

	if not var1_1:getShipById(var2_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_no_ship_tip"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(19004, {
		ship_id = var2_1
	}, 19005, function(arg0_2)
		local var0_2 = 0

		if arg0_2.result == 0 then
			local var1_2 = var4_1.state

			if var1_2 == Ship.STATE_REST then
				-- block empty
			elseif var1_2 == Ship.STATE_TRAIN then
				var4_1.state_info_2 = var4_1:getTotalExp()
			end

			var4_1:updateStateInfo34(0, 0)
			var1_1:exitYardById(var2_1)
			var4_1:updateState(Ship.STATE_NORMAL)

			var0_2 = arg0_2.exp

			var4_1:addExp(var0_2)
			var3_1:updateShip(var4_1)
			arg0_1:sendNotification(GAME.EXIT_SHIP_DONE, var4_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_shipExit", arg0_2.result))
		end

		if var5_1 ~= nil then
			var5_1(var0_2)
		end
	end)
end

return var0_0
