local var0 = class("VoteExchangeMediator", import("view.base.ContextMediator"))

var0.GO_TASK = "VoteExchangeMediator:GO_TASK"
var0.SKIP_TASK = "VoteExchangeMediator:SKIP_TASK"
var0.SUBMIT_TASK = "VoteExchangeMediator:SUBMIT_TASK"

function var0.register(arg0)
	arg0:bind(var0.GO_TASK, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
			page = TaskScene.PAGE_TYPE_ROUTINE
		})
	end)
	arg0:bind(var0.SKIP_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
	arg0:bind(var0.SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_TASK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:Flush()
	end
end

return var0
