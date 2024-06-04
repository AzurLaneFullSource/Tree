local var0 = class("UpdateShipLockCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.ship_id_list
	local var2 = var0.is_locked
	local var3 = var0.callback

	local function var4()
		pg.ConnectionMgr.GetInstance():Send(12022, {
			ship_id_list = var1,
			is_locked = var2
		}, 12023, function(arg0)
			if arg0.result == 0 then
				local var0 = getProxy(BayProxy)
				local var1

				if var2 == Ship.LOCK_STATE_LOCK then
					var1 = "ship_updateShipLock_ok_lock"
				elseif var2 == Ship.LOCK_STATE_UNLOCK then
					var1 = "ship_updateShipLock_ok_unlock"
				end

				for iter0, iter1 in ipairs(var1) do
					local var2 = var0:getShipById(iter1)

					var2:SetLockState(var2)
					var0:updateShip(var2)
					arg0:sendNotification(GAME.UPDATE_LOCK_DONE, var2)
					pg.TipsMgr.GetInstance():ShowTips(i18n(var1, var2:getName()))
				end

				if var3 then
					var3()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_updateShipLock", arg0.result))
			end
		end)
	end

	if var2 == Ship.LOCK_STATE_UNLOCK then
		local var5 = pg.SecondaryPWDMgr

		var5:LimitedOperation(var5.UNLOCK_SHIP, var0.ship_id_list, var4)
	else
		var4()
	end
end

return var0
