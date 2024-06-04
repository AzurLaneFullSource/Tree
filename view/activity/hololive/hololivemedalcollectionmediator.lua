local var0 = class("HololiveMedalCollectionMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:BindEvent()
end

function var0.BindEvent(arg0)
	arg0:bind(ActivityMediator.ON_TASK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
	end)
	arg0:bind(ActivityMediator.ON_TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.MEMORYBOOK_UNLOCK_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.MEMORYBOOK_UNLOCK_DONE then
		arg0.viewComponent:UpdateView()
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:PlayStory(function()
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
		end)
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:UpdateView()
		end)
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0.viewComponent:UpdateView()
	end
end

return var0
