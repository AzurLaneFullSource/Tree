local var0_0 = class("IslandReplaceOrderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().slotId
	local var1_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(var0_1)

	if not var1_1:CanReplace() then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("当前不可替换"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21403, {
		slot_id = var0_1
	}, 21404, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:Flush(arg0_2.slot)
			arg0_1:sendNotification(GAME.ISLAND_REPLACE_ORDER_DONE, {
				slotId = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
