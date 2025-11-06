local var0_0 = class("SetIslandTraceTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.traceId or 0
	local var2_1 = var0_1.type

	if var2_1 == IslandTaskTrackCard.TYPES.MAIN then
		getProxy(IslandProxy):GetIsland():GetTaskAgency():SetMainTraceId(var1_1)
		arg0_1:sendNotification(GAME.ISLAND_SET_TRACE_TASK_DONE, {
			traceId = var1_1,
			type = var2_1
		})

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21034, {
		task_id = var1_1
	}, 21035, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetTaskAgency():SetTraceId(var1_1)
			arg0_1:sendNotification(GAME.ISLAND_SET_TRACE_TASK_DONE, {
				traceId = var1_1,
				type = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
