local var0 = class("BuildingUpgradeMediator", import("view.base.ContextMediator"))

var0.ACTIVITY_OPERATION = "ACTIVITY_OPERATION"

function var0.register(arg0)
	arg0:BindEvent()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	assert(var0, "Building Activity Not Found")
	arg0.viewComponent:UpdateActivity(var0)
end

function var0.BindEvent(arg0)
	arg0:bind(var0.ACTIVITY_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
		arg0.viewComponent:UpdateActivity(var1)
		arg0.viewComponent:Set(var1)
	end
end

return var0
