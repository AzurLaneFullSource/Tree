local var0 = class("WorldShipRepairCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipIds
	local var2 = var0.totalCost
	local var3 = nowWorld()
	local var4 = var3:GetInventoryProxy()

	if var2 > var4:GetItemCount(WorldItem.MoneyId) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33407, {
		ship_list = var1
	}, 33408, function(arg0)
		if arg0.result == 0 then
			_.each(var1, function(arg0)
				local var0 = var3:GetShip(arg0)

				assert(var0, "ship not exist: " .. arg0)
				var0:Repair()
			end)
			var4:RemoveItem(WorldItem.MoneyId, var2)
			arg0:sendNotification(GAME.WORLD_SHIP_REPAIR_DONE, {
				shipIds = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_ship_repair_err_", arg0.result))
		end
	end)
end

return var0
