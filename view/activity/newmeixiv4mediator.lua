local var0_0 = class("NewMeixiV4Mediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_GO = "ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "ON_TASK_SUBMIT"
var0_0.GO_STORY = "GO_STORY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3.id)
	end)
	arg0_1:bind(var0_0.GO_STORY, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			memoryGroup = arg1_4
		})
	end)

	local var0_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var0_1:getData())
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED,
		GAME.SUBMIT_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_6.id == ActivityConst.NEWMEIXIV4_SKIRMISH_ID then
			arg0_6.viewComponent:onUpdateTask()
		end
	elseif var0_6 == PlayerProxy.UPDATED then
		arg0_6.viewComponent:onUpdateRes(var1_6)
	elseif var0_6 == GAME.SUBMIT_TASK_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6, function()
			arg0_6.viewComponent:onUpdateTask()
		end)
	end
end

return var0_0
