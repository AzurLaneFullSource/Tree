local var0_0 = class("HololiveMedalCollectionMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(ActivityMediator.ON_TASK_SUBMIT, function(arg0_3, arg1_3)
		arg0_2:sendNotification(GAME.SUBMIT_TASK, arg1_3.id)
	end)
	arg0_2:bind(ActivityMediator.ON_TASK_GO, function(arg0_4, arg1_4)
		arg0_2:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.MEMORYBOOK_UNLOCK_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.MEMORYBOOK_UNLOCK_DONE then
		arg0_6.viewComponent:UpdateView()
	elseif var0_6 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_6.viewComponent:PlayStory(function()
			arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.awards, var1_6.callback)
		end)
	elseif var0_6 == GAME.SUBMIT_TASK_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6, function()
			arg0_6.viewComponent:UpdateView()
		end)
	elseif var0_6 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_6.viewComponent:UpdateView()
	end
end

return var0_0
