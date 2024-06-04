local var0 = class("ShipExitCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(DormProxy)
	local var2 = var0.shipId
	local var3 = getProxy(BayProxy)
	local var4 = var3:getShipById(var2)
	local var5 = var0.callback

	if not var1:getShipById(var2) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_no_ship_tip"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(19004, {
		ship_id = var2
	}, 19005, function(arg0)
		local var0 = 0

		if arg0.result == 0 then
			local var1 = var4.state

			if var1 == Ship.STATE_REST then
				-- block empty
			elseif var1 == Ship.STATE_TRAIN then
				var4.state_info_2 = var4:getTotalExp()
			end

			var4:updateStateInfo34(0, 0)
			var1:exitYardById(var2)
			var4:updateState(Ship.STATE_NORMAL)

			var0 = arg0.exp

			var4:addExp(var0)
			var3:updateShip(var4)
			arg0:sendNotification(GAME.EXIT_SHIP_DONE, var4)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_shipExit", arg0.result))
		end

		if var5 ~= nil then
			var5(var0)
		end
	end)
end

return var0
