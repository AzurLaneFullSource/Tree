local var0_0 = class("TriggerTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = arg1_1:getType()

	pg.ConnectionMgr.GetInstance():Send(20007, {
		id = var0_1
	}, 20008, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(TaskProxy):addTask(Task.New({
				id = var0_1
			}))
			arg0_1:sendNotification(GAME.TRIGGER_TASK_DONE)

			if var1_1 then
				var1_1(true)
			end
		elseif var1_1 then
			var1_1(false)
		end
	end)
end

return var0_0
