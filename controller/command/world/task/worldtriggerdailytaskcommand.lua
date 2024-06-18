local var0_0 = class("WorldTriggerDailyTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().taskIds
	local var1_1 = nowWorld():GetTaskProxy()

	pg.ConnectionMgr.GetInstance():Send(33415, {
		task_list = var0_1
	}, 33416, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var1_1:getDailyTaskIds()

			for iter0_2, iter1_2 in ipairs(arg0_2.task_list) do
				local var1_2 = WorldTask.New(iter1_2)

				var1_2.new = 1

				table.removebyvalue(var0_2, var1_2.id)
				var1_1:addTask(var1_2)

				if #var1_2.config.task_op > 0 then
					pg.NewStoryMgr.GetInstance():Play(var1_2.config.task_op, nil, true)
				end

				arg0_1:sendNotification(GAME.WORLD_TRIGGER_TASK_DONE, {
					task = var1_2
				})
			end

			var1_1:UpdateDailyTaskIds(var0_2)
			arg0_1:sendNotification(GAME.WORLD_TRIGGER_DAILY_TASK_DONE)
		elseif arg0_2.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_refuse1"))
		elseif arg0_2.result == 20 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_sametask_tip"))
		else
			pg.TipsMgr.GetInstance():ShowTips("trigger task fail:" .. arg0_2.result)
		end
	end)
end

return var0_0
