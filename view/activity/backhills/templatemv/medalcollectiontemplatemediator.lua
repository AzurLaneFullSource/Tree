local var0_0 = class("MedalCollectionTemplateMediator", import("view.base.ContextMediator"))

var0_0.MEMORYBOOK_UNLOCK = "MEMORYBOOK_UNLOCK"
var0_0.MEMORYBOOK_GO = "MEMORYBOOK_GO"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	arg0_1.viewComponent:UpdateActivity(var0_1)
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.MEMORYBOOK_UNLOCK, function(arg0_3, ...)
		arg0_2:sendNotification(GAME.MEMORYBOOK_UNLOCK, ...)
	end)
	arg0_2:bind(var0_0.MEMORYBOOK_GO, function(arg0_4, arg1_4)
		arg0_2:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		GAME.MEMORYBOOK_UNLOCK_DONE,
		GAME.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ActivityProxy.ACTIVITY_ADDED or var0_6 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_6:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PUZZLA then
			arg0_6.viewComponent:UpdateActivity(var1_6)
		end
	elseif var0_6 == GAME.MEMORYBOOK_UNLOCK_DONE then
		local var2_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

		arg0_6.viewComponent:UpdateActivity(var2_6)
		arg0_6.viewComponent:UpdateAfterSubmit(var1_6)
	elseif var0_6 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		local var3_6 = getProxy(ActivityProxy):getActivityById(var1_6)

		if var3_6:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PUZZLA then
			arg0_6.viewComponent:UpdateActivity(var3_6)
			arg0_6.viewComponent:UpdateAfterFinalMedal()
		end
	elseif var0_6 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getContextByMediator(ActivityMediator) then
			return
		end

		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.awards, var1_6.callback)
	end
end

return var0_0
