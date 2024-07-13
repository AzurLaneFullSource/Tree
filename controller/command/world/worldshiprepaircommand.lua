local var0_0 = class("WorldShipRepairCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipIds
	local var2_1 = var0_1.totalCost
	local var3_1 = nowWorld()
	local var4_1 = var3_1:GetInventoryProxy()

	if var2_1 > var4_1:GetItemCount(WorldItem.MoneyId) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33407, {
		ship_list = var1_1
	}, 33408, function(arg0_2)
		if arg0_2.result == 0 then
			_.each(var1_1, function(arg0_3)
				local var0_3 = var3_1:GetShip(arg0_3)

				assert(var0_3, "ship not exist: " .. arg0_3)
				var0_3:Repair()
			end)
			var4_1:RemoveItem(WorldItem.MoneyId, var2_1)
			arg0_1:sendNotification(GAME.WORLD_SHIP_REPAIR_DONE, {
				shipIds = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_ship_repair_err_", arg0_2.result))
		end
	end)
end

return var0_0
