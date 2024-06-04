local var0 = class("MemoryBookMediator", import("...base.ContextMediator"))

var0.ON_UNLOCK = "MemoryBookMediator:ON_UNLOCK"
var0.EVENT_OPERATION = "MemoryBookMediator:EVENT_OPERATION"

function var0.register(arg0)
	arg0:bind(var0.ON_UNLOCK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
			id = arg1,
			actId = arg2
		})
	end)
	arg0:bind(var0.EVENT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	arg0.viewComponent:setActivity(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.MEMORYBOOK_UNLOCK_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.MEMORYBOOK_UNLOCK_DONE then
		arg0.viewComponent:updateMemorys()
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		local var2 = var1

		if var2.id == arg0.viewComponent.activity.id then
			arg0.viewComponent:setActivity(var2)
			arg0.viewComponent:updateProgress()
		end
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getCurrentContext().mediator == ActivityMediator then
			return
		end

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	end
end

return var0
