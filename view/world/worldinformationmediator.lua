local var0_0 = class("WorldInformationMediator", import("..base.ContextMediator"))

var0_0.OnTriggerTask = "WorldInformationMediator.OnTriggerTask"
var0_0.OnSubmitTask = "WorldInformationMediator.OnSubmitTask"
var0_0.OnTaskGoto = "WorldInformationMediator.OnTaskGoto"
var0_0.OnOpenDailyTaskPanel = "WorldInformationMediator.OnOpenDailyTaskPanel"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnTaskGoto, function(arg0_2, arg1_2)
		arg0_1:sendNotification(WorldMediator.OnTriggerTaskGo, {
			taskId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.OnTriggerTask, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.WORLD_TRIGGER_TASK, {
			taskId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.OnSubmitTask, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.WORLD_SUMBMIT_TASK, {
			taskId = arg1_4.id
		})
	end)
	arg0_1:bind(var0_0.OnOpenDailyTaskPanel, function(arg0_5)
		nowWorld():GetTaskProxy():checkDailyTask(function()
			arg0_1:addSubLayers(Context.New({
				mediator = WorldDailyTaskMediator,
				viewComponent = WorldDailyTaskLayer
			}))
		end)
	end)
	arg0_1.viewComponent:setWorldTaskProxy(nowWorld():GetTaskProxy())
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		WorldCollectionMediator.ON_MAP
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == WorldCollectionMediator.ON_MAP then
		arg0_8.viewComponent:closeView()
	end
end

return var0_0
