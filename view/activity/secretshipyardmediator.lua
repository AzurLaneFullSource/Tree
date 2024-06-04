local var0 = class("SecretShipyardMediator", import("..base.ContextMediator"))

var0.GO_MINI_GAME = "go minigame"
var0.SUBMIT_TASK = "submit task"
var0.TASK_GO = "task go"

function var0.register(arg0)
	arg0:bind(var0.GO_MINI_GAME, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_MINI_GAME, arg1)
	end)
	arg0:bind(var0.SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
	arg0:bind(var0.TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:updateTaskLayers()
		end)
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0.viewComponent:updateTaskLayers()
	end
end

return var0
