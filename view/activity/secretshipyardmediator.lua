local var0_0 = class("SecretShipyardMediator", import("..base.ContextMediator"))

var0_0.GO_MINI_GAME = "go minigame"
var0_0.SUBMIT_TASK = "submit task"
var0_0.TASK_GO = "task go"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_MINI_GAME, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GO_MINI_GAME, arg1_2)
	end)
	arg0_1:bind(var0_0.SUBMIT_TASK, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3)
	end)
	arg0_1:bind(var0_0.TASK_GO, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.SUBMIT_TASK_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6, function()
			arg0_6.viewComponent:updateTaskLayers()
		end)
	elseif var0_6 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_6.viewComponent:updateTaskLayers()
	end
end

return var0_0
