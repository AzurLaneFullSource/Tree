local var0_0 = class("ReversePacmanTaskMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_GO = "ReversePacmanTaskMediator::ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "ReversePacmanTaskMediator::ON_TASK_SUBMIT"
var0_0.ON_ACTIVITY_TASK_SUBMIT_ONESTEP = "ReversePacmanTaskMediator::ON_ACTIVITY_TASK_SUBMIT_ONESTEP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3.id)
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_TASK_SUBMIT_ONESTEP, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_4,
			task_ids = arg2_4
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_5)
	arg0_5.handleDic = {
		[GAME.SUBMIT_TASK_DONE] = function(arg0_6, arg1_6)
			arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_6:getBody().awards)
			arg0_6.viewComponent:RefreshUI()
			arg0_6:sendNotification(GAME.REVERSE_PACMAN_REFRESH_TIP)
		end,
		[GAME.SUBMIT_ACTIVITY_TASK_DONE] = function(arg0_7, arg1_7)
			arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_7:getBody().awards)
			arg0_7.viewComponent:RefreshUI()
			arg0_7:sendNotification(GAME.REVERSE_PACMAN_REFRESH_TIP)
		end,
		[GAME.TOTAL_TASK_UPDATED] = function(arg0_8, arg1_8)
			arg0_8.viewComponent:RefreshUI()
			arg0_8:sendNotification(GAME.REVERSE_PACMAN_REFRESH_TIP)
		end
	}
end

function var0_0.remove(arg0_9)
	return
end

return var0_0
