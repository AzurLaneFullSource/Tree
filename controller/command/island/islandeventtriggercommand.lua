local var0_0 = class("IslandEventTriggerCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(IslandProxy):GetNode(var0_1.node_id)
	local var2_1 = IslandEvent.New({
		id = var1_1.eventId
	})
	local var3_1, var4_1 = var2_1:CheckTrigger(var0_1.op)

	if not var3_1 then
		pg.TipsMgr.GetInstance():ShowTips(var4_1)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0_1.act_id,
		arg1 = var0_1.node_id,
		arg2 = var0_1.op
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1:AfterTrigger(var0_1.op)

			local var0_2 = getProxy(IslandProxy):GetNode(var0_1.node_id)

			var0_2.eventId = arg0_2.number[1]

			local var1_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			pg.m02:sendNotification(GAME.ISLAND_EVENT_TRIGGER_DONE, {
				awards = var1_2,
				node_id = var0_2.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Trigger island event failed:" .. arg0_2.result)
		end
	end)
end

return var0_0
