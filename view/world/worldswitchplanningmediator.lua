local var0 = class("WorldSwitchPlanningMediator", import("view.base.ContextMediator"))

var0.OnConfirm = "WorldSwitchPlanningMediator.OnConfirm"
var0.OnMove = "WorldSwitchPlanningMediator.OnMove"

function var0.register(arg0)
	arg0:bind(var0.OnConfirm, function(arg0)
		arg0:sendNotification(WorldMediator.OnStartAutoSwitch)
	end)
	arg0:bind(var0.OnMove, function(arg0, arg1)
		arg0:sendNotification(WorldMediator.OnMoveAndOpenLayer, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
