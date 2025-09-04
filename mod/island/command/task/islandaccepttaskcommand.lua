local var0_0 = class("IslandAcceptTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskIds
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21032, {
		task_id_list = var1_1
	}, 21033, function(arg0_2)
		local var0_2 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
		local var1_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.task_list or {}) do
			local var2_2 = IslandTask.New(iter1_2)

			var0_2:AddTask(var2_2)
			table.insert(var1_2, iter1_2.id)
		end

		if #var1_2 > 0 then
			var0_2:TryAutoTrackTask()
		end

		arg0_1:sendNotification(GAME.ISLAND_ACCEPT_TASK_DONE, {
			taskIds = var1_2,
			callback = var2_1
		})
	end)
end

return var0_0
