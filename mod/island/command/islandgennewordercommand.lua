local var0_0 = class("IslandGenNewOrderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().slotId
	local var1_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(var0_1)

	pg.ConnectionMgr.GetInstance():Send(21024, {
		slotid = var0_1
	}, 21025, function(arg0_2)
		if arg0_2.ret == 0 then
			var1_1:UpdateOrder(arg0_2.slot)
			arg0_1:sendNotification(GAME.ISLAND_GEN_NEW_ORDER_DONE, {
				slotId = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.ret)
		end
	end)
end

return var0_0
