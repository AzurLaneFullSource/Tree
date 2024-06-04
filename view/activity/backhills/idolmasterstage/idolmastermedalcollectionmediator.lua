local var0 = class("IdolMasterMedalCollectionMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:BindEvent()
end

function var0.BindEvent(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.MEMORYBOOK_UNLOCK_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.MEMORYBOOK_UNLOCK_DONE then
		arg0.viewComponent:updateAfterSubmit(var1)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		-- block empty
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getContextByMediator(ActivityMediator) then
			return
		end

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	end
end

return var0
