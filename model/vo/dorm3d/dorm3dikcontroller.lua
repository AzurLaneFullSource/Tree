local var0_0 = class("Dorm3dIKController")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.triggerName = arg1_1.triggerName
	arg0_1.controllerName = arg1_1.controllerName
	arg0_1.subTargets = arg1_1.subTargets
	arg0_1.actionType = arg1_1.actionType
	arg0_1.controlRect = arg1_1.controlRect
	arg0_1.actionRect = arg1_1.actionRect
	arg0_1.backTime = arg1_1.backTime
	arg0_1.actionRevertTime = arg1_1.actionRevertTime
	arg0_1.timelineActionEvent = arg1_1.timelineActionEvent
end

function var0_0.GetTriggerName(arg0_2)
	return arg0_2.triggerName
end

function var0_0.GetControllerPath(arg0_3)
	return arg0_3.controllerName
end

function var0_0.GetSubTargets(arg0_4)
	return arg0_4.subTargets
end

function var0_0.GetActionType(arg0_5)
	return arg0_5.actionType
end

function var0_0.GetControlRect(arg0_6)
	return arg0_6.controlRect
end

function var0_0.GetActionRect(arg0_7)
	return arg0_7.actionRect
end

function var0_0.GetBackTime(arg0_8)
	return arg0_8.backTime
end

function var0_0.GetActionRevertTime(arg0_9)
	return arg0_9.actionRevertTime
end

function var0_0.GetTimelineActionEvent(arg0_10)
	return arg0_10.timelineActionEvent
end

return var0_0
