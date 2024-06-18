local var0_0 = class("ProposeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().shipId
	local var1_1 = getProxy(BayProxy)
	local var2_1 = var1_1:getShipById(var0_1)

	if not var2_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var0_1))

		return
	end

	local var3_1 = getProxy(BagProxy)
	local var4_1 = var2_1:getProposeType() == "imas" and ITEM_ID_FOR_PROPOSE_IMAS or ITEM_ID_FOR_PROPOSE

	if var3_1:getItemCountById(var4_1) < 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12032, {
		ship_id = var0_1
	}, 12033, function(arg0_2)
		if arg0_2.result == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_PROPOSE_SHIP, var2_1.groupId)
			var3_1:removeItemById(var4_1, 1)

			var2_1.propose = true
			var2_1.proposeTime = arg0_2.time

			if not var2_1:IsLocked() then
				var2_1:SetLockState(Ship.LOCK_STATE_LOCK)
				var1_1:updateShip(var2_1)
				arg0_1:sendNotification(GAME.UPDATE_LOCK_DONE, var2_1)
			else
				var1_1:updateShip(var2_1)
			end

			getProxy(CollectionProxy).shipGroups[var2_1.groupId]:updateMarriedFlag()

			local var0_2 = getProxy(PlayerProxy)
			local var1_2 = var0_2:getData()

			var1_2:SetProposeShipId(var0_1)
			var0_2:updatePlayer(var1_2)
			arg0_1:sendNotification(GAME.PROPOSE_SHIP_DONE, {
				ship = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_proposeShip", arg0_2.result))
		end
	end)
end

return var0_0
