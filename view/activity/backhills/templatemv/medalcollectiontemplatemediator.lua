local var0_0 = class("MedalCollectionTemplateMediator", import("view.base.ContextMediator"))

var0_0.MEMORYBOOK_UNLOCK = "MEMORYBOOK_UNLOCK"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	arg0_1.viewComponent:UpdateActivity(var0_1)
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.MEMORYBOOK_UNLOCK, function(arg0_3, ...)
		arg0_2:sendNotification(GAME.MEMORYBOOK_UNLOCK, ...)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		GAME.MEMORYBOOK_UNLOCK_DONE,
		GAME.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_ADDED or var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PUZZLA then
			arg0_5.viewComponent:UpdateActivity(var1_5)
		end
	elseif var0_5 == GAME.MEMORYBOOK_UNLOCK_DONE then
		local var2_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

		arg0_5.viewComponent:UpdateActivity(var2_5)
		arg0_5.viewComponent:UpdateAfterSubmit(var1_5)
	elseif var0_5 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		local var3_5 = getProxy(ActivityProxy):getActivityById(var1_5)

		if var3_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PUZZLA then
			arg0_5.viewComponent:UpdateActivity(var3_5)
			arg0_5.viewComponent:UpdateAfterFinalMedal()
		end
	elseif var0_5 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getContextByMediator(ActivityMediator) then
			return
		end

		arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards, var1_5.callback)
	end
end

return var0_0
