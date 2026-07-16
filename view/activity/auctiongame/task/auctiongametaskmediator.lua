local var0_0 = class("AuctionGameTaskMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_GO = "AuctionGameTaskMediator::ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "AuctionGameTaskMediator::ON_TASK_SUBMIT"
var0_0.ON_ACTIVITY_TASK_SUBMIT_ONESTEP = "AuctionGameTaskMediator::ON_ACTIVITY_TASK_SUBMIT_ONESTEP"

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
			if not (getProxy(ContextProxy):GetPrevContext(0).mediator == ActivityMediator) and #arg1_6:getBody().awards > 0 then
				arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_6:getBody().awards)
			end

			arg0_6.viewComponent:RefreshUI()
		end,
		[GAME.SUBMIT_ACTIVITY_TASK_DONE] = function(arg0_7, arg1_7)
			if not (getProxy(ContextProxy):GetPrevContext(0).mediator == CoreActivityMainMediator) and #arg1_7:getBody().awards > 0 then
				arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_7:getBody().awards)
			end

			arg0_7.viewComponent:RefreshUI()
		end,
		[GAME.TOTAL_TASK_UPDATED] = function(arg0_8, arg1_8)
			arg0_8.viewComponent:RefreshUI()
		end
	}
end

function var0_0.remove(arg0_9)
	return
end

return var0_0
