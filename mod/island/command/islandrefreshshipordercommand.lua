local var0_0 = class("IslandRefreshShipOrderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipOrderSlot(var0_1)

	if not var1_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21429, {
		slot_id = var0_1
	}, 21430, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:Init(arg0_2.slot, true)
			arg0_1:sendNotification(GAME.ISLAND_REFRESH_SHIP_ORDER_DONE, {
				id = var0_1
			})
		end
	end)
end

return var0_0
