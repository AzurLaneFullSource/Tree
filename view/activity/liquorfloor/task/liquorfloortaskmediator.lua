local var0_0 = class("LiquorFloorTaskMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_GO = "LiquorFloorTaskMediator::ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "LiquorFloorTaskMediator::ON_TASK_SUBMIT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3.id)
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[GAME.SUBMIT_TASK_DONE] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_5:getBody().awards)
			arg0_5.viewComponent:RefreshUI()
		end,
		[GAME.SUBMIT_ACTIVITY_TASK_DONE] = function(arg0_6, arg1_6)
			arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_6:getBody().awards)
			arg0_6.viewComponent:RefreshUI()
		end
	}
end

function var0_0.remove(arg0_7)
	return
end

return var0_0
