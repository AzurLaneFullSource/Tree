local var0 = class("WorldTriggerTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.taskId
	local var2 = var0.portId
	local var3 = nowWorld()
	local var4 = var3:GetTaskProxy()
	local var5, var6 = WorldTask.canTrigger(var1)

	if not var5 then
		pg.TipsMgr.GetInstance():ShowTips(var6)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33205, {
		taskId = var1
	}, 33206, function(arg0)
		if arg0.result == 0 then
			if var2 then
				local var0 = var3:GetActiveMap():GetPort()
				local var1 = underscore.rest(var0.taskIds, 1)

				table.removebyvalue(var1, var1)
				var0:UpdateTaskIds(var1)
			end

			local var2 = WorldTask.New(arg0.task)

			var2.new = 1

			var4:addTask(var2)

			if #var2.config.task_op > 0 then
				pg.NewStoryMgr.GetInstance():Play(var2.config.task_op, nil, true)
			end

			arg0:sendNotification(GAME.WORLD_TRIGGER_TASK_DONE, {
				task = var2
			})
		elseif arg0.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_refuse1"))
		else
			pg.TipsMgr.GetInstance():ShowTips("trigger task fail:" .. arg0.result)
		end
	end)
end

return var0
