local var0 = class("IslandEventTriggerCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(IslandProxy):GetNode(var0.node_id)
	local var2 = IslandEvent.New({
		id = var1.eventId
	})
	local var3, var4 = var2:CheckTrigger(var0.op)

	if not var3 then
		pg.TipsMgr.GetInstance():ShowTips(var4)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0.act_id,
		arg1 = var0.node_id,
		arg2 = var0.op
	}, 11203, function(arg0)
		if arg0.result == 0 then
			var2:AfterTrigger(var0.op)

			local var0 = getProxy(IslandProxy):GetNode(var0.node_id)

			var0.eventId = arg0.number[1]

			local var1 = PlayerConst.addTranDrop(arg0.award_list)

			pg.m02:sendNotification(GAME.ISLAND_EVENT_TRIGGER_DONE, {
				awards = var1,
				node_id = var0.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Trigger island event failed:" .. arg0.result)
		end
	end)
end

return var0
