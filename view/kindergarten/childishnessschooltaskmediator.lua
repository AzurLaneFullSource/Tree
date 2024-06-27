local var0_0 = class("ChildishnessSchoolTaskMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_GO = "event on task go"
var0_0.ON_TASK_SUBMIT = "event on task submit"
var0_0.ON_TASK_SUBMIT_ONESTEP = "event on task submit one step"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3.id, arg2_3)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_4,
			task_ids = arg2_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_AVATAR_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.SUBMIT_TASK_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6)
		arg0_6.viewComponent:Show()
	elseif var0_6 == GAME.SUBMIT_AVATAR_TASK_DONE or var0_6 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.awards)
		arg0_6.viewComponent:Show()
	end
end

return var0_0
