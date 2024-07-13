local var0_0 = class("MemoryBookMediator", import("...base.ContextMediator"))

var0_0.ON_UNLOCK = "MemoryBookMediator:ON_UNLOCK"
var0_0.EVENT_OPERATION = "MemoryBookMediator:EVENT_OPERATION"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_UNLOCK, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
			id = arg1_2,
			actId = arg2_2
		})
	end)
	arg0_1:bind(var0_0.EVENT_OPERATION, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_3)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	arg0_1.viewComponent:setActivity(var0_1)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.MEMORYBOOK_UNLOCK_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.MEMORYBOOK_UNLOCK_DONE then
		arg0_5.viewComponent:updateMemorys()
	elseif var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		local var2_5 = var1_5

		if var2_5.id == arg0_5.viewComponent.activity.id then
			arg0_5.viewComponent:setActivity(var2_5)
			arg0_5.viewComponent:updateProgress()
		end
	elseif var0_5 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getCurrentContext().mediator == ActivityMediator then
			return
		end

		arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards, var1_5.callback)
	end
end

return var0_0
