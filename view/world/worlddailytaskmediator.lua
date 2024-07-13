local var0_0 = class("WorldDailyTaskMediator", import("..base.ContextMediator"))

var0_0.OnTaskGoto = "WorldDailyTaskMediator.OnTaskGoto"
var0_0.OnAccepetTask = "WorldDailyTaskMediator.OnAccepetTask"
var0_0.OnSubmitTask = "WorldDailyTaskMediator.OnSubmitTask"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnTaskGoto, function(arg0_2, arg1_2)
		arg0_1.viewComponent:closeView()
		arg0_1:sendNotification(WorldMediator.OnTriggerTaskGo, {
			taskId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.OnAccepetTask, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.WORLD_TRIGGER_DAILY_TASK, {
			taskIds = arg1_3
		})
	end)
	arg0_1:bind(var0_0.OnSubmitTask, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.WORLD_SUMBMIT_TASK, {
			taskId = arg1_4.id
		})
	end)
	arg0_1.viewComponent:SetTaskProxy(nowWorld():GetTaskProxy())
end

function var0_0.listNotificationInterests(arg0_5)
	return {}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()
end

return var0_0
