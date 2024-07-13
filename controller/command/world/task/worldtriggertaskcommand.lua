local var0_0 = class("WorldTriggerTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskId
	local var2_1 = var0_1.portId
	local var3_1 = nowWorld()
	local var4_1 = var3_1:GetTaskProxy()
	local var5_1, var6_1 = WorldTask.canTrigger(var1_1)

	if not var5_1 then
		pg.TipsMgr.GetInstance():ShowTips(var6_1)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33205, {
		taskId = var1_1
	}, 33206, function(arg0_2)
		if arg0_2.result == 0 then
			if var2_1 then
				local var0_2 = var3_1:GetActiveMap():GetPort()
				local var1_2 = underscore.rest(var0_2.taskIds, 1)

				table.removebyvalue(var1_2, var1_1)
				var0_2:UpdateTaskIds(var1_2)
			end

			local var2_2 = WorldTask.New(arg0_2.task)

			var2_2.new = 1

			var4_1:addTask(var2_2)

			if #var2_2.config.task_op > 0 then
				pg.NewStoryMgr.GetInstance():Play(var2_2.config.task_op, nil, true)
			end

			arg0_1:sendNotification(GAME.WORLD_TRIGGER_TASK_DONE, {
				task = var2_2
			})
		elseif arg0_2.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_refuse1"))
		else
			pg.TipsMgr.GetInstance():ShowTips("trigger task fail:" .. arg0_2.result)
		end
	end)
end

return var0_0
