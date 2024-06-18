local var0_0 = class("UseTecSpeedUpItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.blueprintid
	local var2_1 = var0_1.itemid
	local var3_1 = var0_1.number
	local var4_1 = var0_1.taskID

	pg.ConnectionMgr.GetInstance():Send(63210, {
		blueprintid = var1_1,
		itemid = var2_1,
		number = var3_1,
		task_id = var4_1
	}, 63211, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(BagProxy):removeItemById(var2_1, var3_1)
			arg0_1:sendNotification(GAME.USE_TEC_SPEEDUP_ITEM_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Error Code" .. arg0_2.result)
		end
	end)
end

return var0_0
