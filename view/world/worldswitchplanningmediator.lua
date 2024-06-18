local var0_0 = class("WorldSwitchPlanningMediator", import("view.base.ContextMediator"))

var0_0.OnConfirm = "WorldSwitchPlanningMediator.OnConfirm"
var0_0.OnMove = "WorldSwitchPlanningMediator.OnMove"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnConfirm, function(arg0_2)
		arg0_1:sendNotification(WorldMediator.OnStartAutoSwitch)
	end)
	arg0_1:bind(var0_0.OnMove, function(arg0_3, arg1_3)
		arg0_1:sendNotification(WorldMediator.OnMoveAndOpenLayer, arg1_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()
end

return var0_0
