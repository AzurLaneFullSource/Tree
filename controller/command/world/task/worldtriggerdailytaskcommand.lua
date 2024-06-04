local var0 = class("WorldTriggerDailyTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().taskIds
	local var1 = nowWorld():GetTaskProxy()

	pg.ConnectionMgr.GetInstance():Send(33415, {
		task_list = var0
	}, 33416, function(arg0)
		if arg0.result == 0 then
			local var0 = var1:getDailyTaskIds()

			for iter0, iter1 in ipairs(arg0.task_list) do
				local var1 = WorldTask.New(iter1)

				var1.new = 1

				table.removebyvalue(var0, var1.id)
				var1:addTask(var1)

				if #var1.config.task_op > 0 then
					pg.NewStoryMgr.GetInstance():Play(var1.config.task_op, nil, true)
				end

				arg0:sendNotification(GAME.WORLD_TRIGGER_TASK_DONE, {
					task = var1
				})
			end

			var1:UpdateDailyTaskIds(var0)
			arg0:sendNotification(GAME.WORLD_TRIGGER_DAILY_TASK_DONE)
		elseif arg0.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_refuse1"))
		elseif arg0.result == 20 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_sametask_tip"))
		else
			pg.TipsMgr.GetInstance():ShowTips("trigger task fail:" .. arg0.result)
		end
	end)
end

return var0
