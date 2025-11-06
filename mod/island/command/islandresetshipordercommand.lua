local var0_0 = class("IslandResetShipOrderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	pg.ConnectionMgr.GetInstance():Send(21429, {
		slot_id = 0
	}, 21430, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:UpdateNextManualReloadDelegateTime(arg0_2.next_time)

			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.appoint_list or {}) do
				local var1_2 = IslandShipOrderDelegateSlot.New(iter1_2)

				var0_2[var1_2.id] = var1_2
			end

			var1_1:AddDelegateSlotList(var0_2)

			local var2_2 = var1_1:GetShipSlotList()

			for iter2_2, iter3_2 in pairs(var2_2) do
				if iter3_2:IsEmpty() then
					iter3_2:Reset()
				end
			end

			arg0_1:sendNotification(GAME.ISLAND_RESET_SHIP_ORDER_DONE)
		end
	end)
end

return var0_0
