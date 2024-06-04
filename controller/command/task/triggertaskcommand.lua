local var0 = class("TriggerTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = arg1:getType()

	pg.ConnectionMgr.GetInstance():Send(20007, {
		id = var0
	}, 20008, function(arg0)
		if arg0.result == 0 then
			getProxy(TaskProxy):addTask(Task.New({
				id = var0
			}))
			arg0:sendNotification(GAME.TRIGGER_TASK_DONE)

			if var1 then
				var1(true)
			end
		elseif var1 then
			var1(false)
		end
	end)
end

return var0
