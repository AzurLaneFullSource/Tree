local var0 = class("UseTecSpeedUpItemCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.blueprintid
	local var2 = var0.itemid
	local var3 = var0.number
	local var4 = var0.taskID

	pg.ConnectionMgr.GetInstance():Send(63210, {
		blueprintid = var1,
		itemid = var2,
		number = var3,
		task_id = var4
	}, 63211, function(arg0)
		if arg0.result == 0 then
			getProxy(BagProxy):removeItemById(var2, var3)
			arg0:sendNotification(GAME.USE_TEC_SPEEDUP_ITEM_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Error Code" .. arg0.result)
		end
	end)
end

return var0
