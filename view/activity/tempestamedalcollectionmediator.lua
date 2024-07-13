local var0_0 = class("TempestaMedalCollectionMediator", import("..base.ContextMediator"))

var0_0.ON_TASK_SUBMIT = "TempestaMedalCollectionMediator.ON_TASK_SUBMIT"
var0_0.ON_TASK_GO = "TempestaMedalCollectionMediator.ON_TASK_GO"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_2.id)
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_3
		})
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.PIRATE_MEDAL_ACT_ID)

	arg0_1.viewComponent:setActivity(var0_1)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[GAME.SUBMIT_TASK_DONE] = function(arg0_5, arg1_5)
			local var0_5 = arg1_5:getBody()

			arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_5, function()
				arg0_5.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.SUBMIT_ACTIVITY_TASK_DONE] = function(arg0_7, arg1_7)
			local var0_7 = arg1_7:getBody()

			arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_7.awards, function()
				arg0_7.viewComponent:updateTaskLayers()
			end)
		end
	}
end

return var0_0
