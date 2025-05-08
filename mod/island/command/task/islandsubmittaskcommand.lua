local var0_0 = class("IslandSubmitTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskId
	local var2_1 = var0_1.callback

	warning("SubmitTask", var1_1)
	pg.ConnectionMgr.GetInstance():Send(21038, {
		task_id = var1_1
	}, 21039, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
			local var1_2 = var0_2:GetTask(var1_1)
			local var2_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

			for iter0_2, iter1_2 in ipairs(var1_2:GetRecycleItemInfos()) do
				var2_2:RemoveItem(iter1_2.id, iter1_2.count)
			end

			var0_2:RemoveTask(var1_1)
			var0_2:AddFinishId(var1_1)

			local var3_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_SUBMIT_TASK_DONE, {
				taskId = var1_1,
				dropData = var3_2,
				callback = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
