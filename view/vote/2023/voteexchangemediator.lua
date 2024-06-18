local var0_0 = class("VoteExchangeMediator", import("view.base.ContextMediator"))

var0_0.GO_TASK = "VoteExchangeMediator:GO_TASK"
var0_0.SKIP_TASK = "VoteExchangeMediator:SKIP_TASK"
var0_0.SUBMIT_TASK = "VoteExchangeMediator:SUBMIT_TASK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_TASK, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
			page = TaskScene.PAGE_TYPE_ROUTINE
		})
	end)
	arg0_1:bind(var0_0.SKIP_TASK, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_3
		})
	end)
	arg0_1:bind(var0_0.SUBMIT_TASK, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_4)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.SUBMIT_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.SUBMIT_TASK_DONE then
		arg0_6.viewComponent:Flush()
	end
end

return var0_0
