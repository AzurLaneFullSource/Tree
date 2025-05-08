local var0_0 = class("IslandAcceptTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().taskIds

	for iter0_1, iter1_1 in ipairs(var0_1) do
		warning("Req AcceptTask", iter1_1)
	end

	pg.ConnectionMgr.GetInstance():Send(21032, {
		task_id_list = var0_1
	}, 21033, function(arg0_2)
		local var0_2 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
		local var1_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.task_list or {}) do
			warning("Real AcceptTask", iter1_2.id)

			local var2_2 = IslandTask.New(iter1_2)

			var0_2:AddTask(var2_2)
			table.insert(var1_2, iter1_2.id)
		end

		if #var0_1 ~= #var1_2 then
			pg.TipsMgr.GetInstance():ShowTips("!!!部分任务接取失败,请检查配置!!!")
		end

		arg0_1:sendNotification(GAME.ISLAND_ACCEPT_TASK_DONE, {
			taskIds = var1_2
		})
	end)
end

return var0_0
