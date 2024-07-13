local var0_0 = class("BuildingUpgradeMediator", import("view.base.ContextMediator"))

var0_0.ACTIVITY_OPERATION = "ACTIVITY_OPERATION"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	assert(var0_1, "Building Activity Not Found")
	arg0_1.viewComponent:UpdateActivity(var0_1)
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.ACTIVITY_OPERATION, function(arg0_3, arg1_3)
		arg0_2:sendNotification(GAME.ACTIVITY_OPERATION, arg1_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_UPDATED and var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
		arg0_5.viewComponent:UpdateActivity(var1_5)
		arg0_5.viewComponent:Set(var1_5)
	end
end

return var0_0
