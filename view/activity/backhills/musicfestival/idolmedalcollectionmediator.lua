local var0 = class("IdolMedalCollectionMediator", import("view.base.ContextMediator"))

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
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PUZZLA then
			arg0.viewComponent:UpdateActivity()
		end
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		local var2 = getProxy(ContextProxy):getContextByMediator(ActivityMediator)

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	end
end

return var0
