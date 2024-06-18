local var0_0 = import("..observer.Notifier")
local var1_0 = class("Mediator", var0_0)

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.mediatorName = arg1_1 or arg0_1.__cname or var1_0.NAME
	arg0_1.viewComponent = arg2_1
end

var1_0.NAME = "Mediator"

function var1_0.getMediatorName(arg0_2)
	return arg0_2.mediatorName
end

function var1_0.setViewComponent(arg0_3, arg1_3)
	arg0_3.viewComponent = arg1_3
end

function var1_0.getViewComponent(arg0_4)
	return arg0_4.viewComponent
end

function var1_0.listNotificationInterests(arg0_5)
	return {}
end

function var1_0.handleNotification(arg0_6, arg1_6)
	return
end

function var1_0.onRegister(arg0_7)
	return
end

function var1_0.onRemove(arg0_8)
	return
end

return var1_0
