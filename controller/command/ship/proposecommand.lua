local var0 = class("ProposeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().shipId
	local var1 = getProxy(BayProxy)
	local var2 = var1:getShipById(var0)

	if not var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var0))

		return
	end

	local var3 = getProxy(BagProxy)
	local var4 = var2:getProposeType() == "imas" and ITEM_ID_FOR_PROPOSE_IMAS or ITEM_ID_FOR_PROPOSE

	if var3:getItemCountById(var4) < 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12032, {
		ship_id = var0
	}, 12033, function(arg0)
		if arg0.result == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_PROPOSE_SHIP, var2.groupId)
			var3:removeItemById(var4, 1)

			var2.propose = true
			var2.proposeTime = arg0.time

			if not var2:IsLocked() then
				var2:SetLockState(Ship.LOCK_STATE_LOCK)
				var1:updateShip(var2)
				arg0:sendNotification(GAME.UPDATE_LOCK_DONE, var2)
			else
				var1:updateShip(var2)
			end

			getProxy(CollectionProxy).shipGroups[var2.groupId]:updateMarriedFlag()

			local var0 = getProxy(PlayerProxy)
			local var1 = var0:getData()

			var1:SetProposeShipId(var0)
			var0:updatePlayer(var1)
			arg0:sendNotification(GAME.PROPOSE_SHIP_DONE, {
				ship = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_proposeShip", arg0.result))
		end
	end)
end

return var0
