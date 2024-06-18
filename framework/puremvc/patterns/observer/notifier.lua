local var0_0 = import("..facade.Facade")
local var1_0 = class("Notifier")

function var1_0.Ctor(arg0_1)
	return
end

function var1_0.sendNotification(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg0_2:getFacade()

	if var0_2 ~= nil then
		var0_2:sendNotification(arg1_2, arg2_2, arg3_2)
	end
end

function var1_0.initializeNotifier(arg0_3, arg1_3)
	arg0_3.multitonKey = arg1_3
	arg0_3.facade = arg0_3:getFacade()
end

function var1_0.getFacade(arg0_4)
	if arg0_4.multitonKey == nil then
		error(var1_0.MULTITON_MSG)
	end

	return var0_0.getInstance(arg0_4.multitonKey)
end

var1_0.MULTITON_MSG = "multitonKey for this Notifier not yet initialized!"

return var1_0
