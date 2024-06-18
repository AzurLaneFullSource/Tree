local var0_0 = class("UpdateShipLockCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ship_id_list
	local var2_1 = var0_1.is_locked
	local var3_1 = var0_1.callback

	local function var4_1()
		pg.ConnectionMgr.GetInstance():Send(12022, {
			ship_id_list = var1_1,
			is_locked = var2_1
		}, 12023, function(arg0_3)
			if arg0_3.result == 0 then
				local var0_3 = getProxy(BayProxy)
				local var1_3

				if var2_1 == Ship.LOCK_STATE_LOCK then
					var1_3 = "ship_updateShipLock_ok_lock"
				elseif var2_1 == Ship.LOCK_STATE_UNLOCK then
					var1_3 = "ship_updateShipLock_ok_unlock"
				end

				for iter0_3, iter1_3 in ipairs(var1_1) do
					local var2_3 = var0_3:getShipById(iter1_3)

					var2_3:SetLockState(var2_1)
					var0_3:updateShip(var2_3)
					arg0_1:sendNotification(GAME.UPDATE_LOCK_DONE, var2_3)
					pg.TipsMgr.GetInstance():ShowTips(i18n(var1_3, var2_3:getName()))
				end

				if var3_1 then
					var3_1()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_updateShipLock", arg0_3.result))
			end
		end)
	end

	if var2_1 == Ship.LOCK_STATE_UNLOCK then
		local var5_1 = pg.SecondaryPWDMgr

		var5_1:LimitedOperation(var5_1.UNLOCK_SHIP, var0_1.ship_id_list, var4_1)
	else
		var4_1()
	end
end

return var0_0
