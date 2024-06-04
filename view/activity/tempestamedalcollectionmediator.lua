local var0 = class("TempestaMedalCollectionMediator", import("..base.ContextMediator"))

var0.ON_TASK_SUBMIT = "TempestaMedalCollectionMediator.ON_TASK_SUBMIT"
var0.ON_TASK_GO = "TempestaMedalCollectionMediator.ON_TASK_GO"

function var0.register(arg0)
	arg0:bind(var0.ON_TASK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
	end)
	arg0:bind(var0.ON_TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.PIRATE_MEDAL_ACT_ID)

	arg0.viewComponent:setActivity(var0)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.SUBMIT_TASK_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, function()
				arg0.viewComponent:updateTaskLayers()
			end)
		end
	}
end

return var0
