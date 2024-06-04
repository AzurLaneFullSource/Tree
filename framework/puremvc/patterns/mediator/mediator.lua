local var0 = import("..observer.Notifier")
local var1 = class("Mediator", var0)

function var1.Ctor(arg0, arg1, arg2)
	arg0.mediatorName = arg1 or arg0.__cname or var1.NAME
	arg0.viewComponent = arg2
end

var1.NAME = "Mediator"

function var1.getMediatorName(arg0)
	return arg0.mediatorName
end

function var1.setViewComponent(arg0, arg1)
	arg0.viewComponent = arg1
end

function var1.getViewComponent(arg0)
	return arg0.viewComponent
end

function var1.listNotificationInterests(arg0)
	return {}
end

function var1.handleNotification(arg0, arg1)
	return
end

function var1.onRegister(arg0)
	return
end

function var1.onRemove(arg0)
	return
end

return var1
