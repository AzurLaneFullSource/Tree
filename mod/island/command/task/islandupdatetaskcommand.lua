local var0_0 = class("IslandUpdateTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskId
	local var2_1 = var0_1.targetId
	local var3_1 = var0_1.progress
	local var4_1 = 0

	warning("Req UpdateTask", var4_1, var2_1, var3_1)
	pg.ConnectionMgr.GetInstance():Send(21036, {
		task_id = var4_1,
		target_id = var2_1,
		target_count = var3_1
	}, 21037, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

			for iter0_2, iter1_2 in ipairs(arg0_2.task_list) do
				warning("Real UpdateTask", iter1_2.id, #iter1_2.process_list)

				local var1_2 = IslandTask.New(iter1_2)

				var0_2:UpdateTask(var1_2)
			end

			arg0_1:sendNotification(GAME.ISLAND_UPDATE_TASK_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
