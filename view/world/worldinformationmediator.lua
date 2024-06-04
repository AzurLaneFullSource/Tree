local var0 = class("WorldInformationMediator", import("..base.ContextMediator"))

var0.OnTriggerTask = "WorldInformationMediator.OnTriggerTask"
var0.OnSubmitTask = "WorldInformationMediator.OnSubmitTask"
var0.OnTaskGoto = "WorldInformationMediator.OnTaskGoto"
var0.OnOpenDailyTaskPanel = "WorldInformationMediator.OnOpenDailyTaskPanel"

function var0.register(arg0)
	arg0:bind(var0.OnTaskGoto, function(arg0, arg1)
		arg0:sendNotification(WorldMediator.OnTriggerTaskGo, {
			taskId = arg1
		})
	end)
	arg0:bind(var0.OnTriggerTask, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_TRIGGER_TASK, {
			taskId = arg1
		})
	end)
	arg0:bind(var0.OnSubmitTask, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_SUMBMIT_TASK, {
			taskId = arg1.id
		})
	end)
	arg0:bind(var0.OnOpenDailyTaskPanel, function(arg0)
		nowWorld():GetTaskProxy():checkDailyTask(function()
			arg0:addSubLayers(Context.New({
				mediator = WorldDailyTaskMediator,
				viewComponent = WorldDailyTaskLayer
			}))
		end)
	end)
	arg0.viewComponent:setWorldTaskProxy(nowWorld():GetTaskProxy())
end

function var0.listNotificationInterests(arg0)
	return {
		WorldCollectionMediator.ON_MAP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == WorldCollectionMediator.ON_MAP then
		arg0.viewComponent:closeView()
	end
end

return var0
