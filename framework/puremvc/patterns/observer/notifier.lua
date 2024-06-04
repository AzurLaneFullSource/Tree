local var0 = import("..facade.Facade")
local var1 = class("Notifier")

function var1.Ctor(arg0)
	return
end

function var1.sendNotification(arg0, arg1, arg2, arg3)
	local var0 = arg0:getFacade()

	if var0 ~= nil then
		var0:sendNotification(arg1, arg2, arg3)
	end
end

function var1.initializeNotifier(arg0, arg1)
	arg0.multitonKey = arg1
	arg0.facade = arg0:getFacade()
end

function var1.getFacade(arg0)
	if arg0.multitonKey == nil then
		error(var1.MULTITON_MSG)
	end

	return var0.getInstance(arg0.multitonKey)
end

var1.MULTITON_MSG = "multitonKey for this Notifier not yet initialized!"

return var1
