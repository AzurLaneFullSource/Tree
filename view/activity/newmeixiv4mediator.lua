local var0 = class("NewMeixiV4Mediator", import("view.base.ContextMediator"))

var0.ON_TASK_GO = "ON_TASK_GO"
var0.ON_TASK_SUBMIT = "ON_TASK_SUBMIT"
var0.GO_STORY = "GO_STORY"

function var0.register(arg0)
	arg0:bind(var0.ON_TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
	arg0:bind(var0.ON_TASK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
	end)
	arg0:bind(var0.GO_STORY, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			memoryGroup = arg1
		})
	end)

	local var0 = getProxy(PlayerProxy)

	arg0.viewComponent:setPlayer(var0:getData())
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED,
		GAME.SUBMIT_TASK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1.id == ActivityConst.NEWMEIXIV4_SKIRMISH_ID then
			arg0.viewComponent:onUpdateTask()
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:onUpdateRes(var1)
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:onUpdateTask()
		end)
	end
end

return var0
