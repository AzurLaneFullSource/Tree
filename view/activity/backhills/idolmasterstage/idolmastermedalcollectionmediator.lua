local var0_0 = class("IdolMasterMedalCollectionMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
end

function var0_0.BindEvent(arg0_2)
	return
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.MEMORYBOOK_UNLOCK_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.MEMORYBOOK_UNLOCK_DONE then
		arg0_4.viewComponent:updateAfterSubmit(var1_4)
	elseif var0_4 == ActivityProxy.ACTIVITY_UPDATED then
		-- block empty
	elseif var0_4 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getContextByMediator(ActivityMediator) then
			return
		end

		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards, var1_4.callback)
	end
end

return var0_0
