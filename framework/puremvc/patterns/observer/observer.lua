local var0 = class("Observer")

function var0.Ctor(arg0, arg1, arg2)
	arg0:setNotifyMethod(arg1)
	arg0:setNotifyContext(arg2)
end

function var0.setNotifyMethod(arg0, arg1)
	arg0.notify = arg1
end

function var0.setNotifyContext(arg0, arg1)
	arg0.context = arg1
end

function var0.getNotifyMethod(arg0)
	return arg0.notify
end

function var0.getNotifyContext(arg0)
	return arg0.context
end

function var0.notifyObserver(arg0, arg1)
	arg0.notify(arg0.context, arg1)
end

function var0.compareNotifyContext(arg0, arg1)
	return arg1 == arg0.context
end

return var0
