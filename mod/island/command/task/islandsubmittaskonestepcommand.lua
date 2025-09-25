local var0_0 = class("IslandSubmitTaskOneStepCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskIds
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21041, {
		task_ids = var1_1
	}, 21042, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
			local var1_2 = 0

			for iter0_2, iter1_2 in ipairs(var1_1) do
				local var2_2 = var0_2:GetTask(iter1_2)

				var1_2 = var1_2 + var2_2:GetExp()

				local var3_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

				for iter2_2, iter3_2 in ipairs(var2_2:GetRecycleItemInfos()) do
					var3_2:RemoveItem(iter3_2.id, iter3_2.count)
				end

				var0_2:RemoveTask(iter1_2)
				var0_2:AddFinishId(iter1_2)
			end

			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TASK)
			var0_2:TryAcceptAutoTasks()

			local var4_2 = IslandDropHelper.AddItems(arg0_2, var1_2)

			arg0_1:sendNotification(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, {
				dropData = var4_2,
				callback = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
