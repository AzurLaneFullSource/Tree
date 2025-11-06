local var0_0 = class("IslandExchangeShipOrderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.delegateId
	local var3_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency()
	local var4_1 = var3_1:GetDelegateSlot(var2_1)

	if not var4_1 then
		return
	end

	local var5_1 = var3_1:GetShipOrderSlot(var1_1)

	if not var5_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21431, {
		slot_id = var1_1,
		appoint_id = var2_1
	}, 21432, function(arg0_2)
		if arg0_2.result == 0 then
			if var5_1:GetOrder():IsAnyLoadUp() then
				var5_1:IncreaseFinishCnt()
			end

			var5_1:FillDelegate(var4_1)

			local var0_2 = IslandShipOrderDelegateSlot.New(arg0_2.appoint)

			var3_1:RemoveDelegateSlot(var2_1)
			var3_1:AddDelegateSlot(var0_2)
			arg0_1:sendNotification(GAME.ISLAND_EXCHANGE_SHIP_ORDER_DONE, {
				id = var1_1,
				delegateId = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
