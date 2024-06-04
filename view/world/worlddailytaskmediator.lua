local var0 = class("WorldDailyTaskMediator", import("..base.ContextMediator"))

var0.OnTaskGoto = "WorldDailyTaskMediator.OnTaskGoto"
var0.OnAccepetTask = "WorldDailyTaskMediator.OnAccepetTask"
var0.OnSubmitTask = "WorldDailyTaskMediator.OnSubmitTask"

function var0.register(arg0)
	arg0:bind(var0.OnTaskGoto, function(arg0, arg1)
		arg0.viewComponent:closeView()
		arg0:sendNotification(WorldMediator.OnTriggerTaskGo, {
			taskId = arg1
		})
	end)
	arg0:bind(var0.OnAccepetTask, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_TRIGGER_DAILY_TASK, {
			taskIds = arg1
		})
	end)
	arg0:bind(var0.OnSubmitTask, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_SUMBMIT_TASK, {
			taskId = arg1.id
		})
	end)
	arg0.viewComponent:SetTaskProxy(nowWorld():GetTaskProxy())
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
