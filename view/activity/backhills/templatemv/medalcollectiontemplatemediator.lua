local var0 = class("MedalCollectionTemplateMediator", import("view.base.ContextMediator"))

var0.MEMORYBOOK_UNLOCK = "MEMORYBOOK_UNLOCK"

function var0.register(arg0)
	arg0:BindEvent()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	arg0.viewComponent:UpdateActivity(var0)
end

function var0.BindEvent(arg0)
	arg0:bind(var0.MEMORYBOOK_UNLOCK, function(arg0, ...)
		arg0:sendNotification(GAME.MEMORYBOOK_UNLOCK, ...)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		GAME.MEMORYBOOK_UNLOCK_DONE,
		GAME.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_ADDED or var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PUZZLA then
			arg0.viewComponent:UpdateActivity(var1)
		end
	elseif var0 == GAME.MEMORYBOOK_UNLOCK_DONE then
		local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

		arg0.viewComponent:UpdateActivity(var2)
		arg0.viewComponent:UpdateAfterSubmit(var1)
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		local var3 = getProxy(ActivityProxy):getActivityById(var1)

		if var3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PUZZLA then
			arg0.viewComponent:UpdateActivity(var3)
			arg0.viewComponent:UpdateAfterFinalMedal()
		end
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getContextByMediator(ActivityMediator) then
			return
		end

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	end
end

return var0
