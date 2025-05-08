local var0_0 = class("SetIslandTraceTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().traceId

	warning("TraceTask", var0_1)
	pg.ConnectionMgr.GetInstance():Send(21034, {
		task_id = var0_1
	}, 21035, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetTaskAgency():SetTraceId(var0_1)
			arg0_1:sendNotification(GAME.ISLAND_SET_TRACE_TASK_DONE, {
				traceId = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
