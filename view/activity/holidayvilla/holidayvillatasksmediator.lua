local var0_0 = class("HolidayVillaTasksMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_SUBMIT = "HolidayVillaTasksMediator.ON_TASK_SUBMIT"
var0_0.ON_TASK_SUBMIT_ONESTEP = "HolidayVillaTasksMediator.ON_TASK_SUBMIT_ONESTEP"
var0_0.ON_TASK_GO = "HolidayVillaTasksMediator.ON_TASK_GO"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_2:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_3,
			task_ids = arg2_3,
			callback = arg3_3
		})
	end)
	arg0_2:bind(var0_0.ON_TASK_GO, function(arg0_4, arg1_4, arg2_4)
		arg0_2:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.SUBMIT_TASK_AWARD_DOWN
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.SUBMIT_TASK_AWARD_DOWN and #var1_6.awards > 0 then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.awards, function()
			arg0_6.viewComponent:InitData()
		end)
	end
end

return var0_0
