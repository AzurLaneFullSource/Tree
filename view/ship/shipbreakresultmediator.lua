local var0_0 = class("ShipBreakResultMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	if arg0_1.contextData.newShip and arg0_1.contextData.oldShip then
		arg0_1.viewComponent:updateStatistics()
	end
end

function var0_0.listNotificationInterests(arg0_2)
	return {}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()
end

return var0_0
