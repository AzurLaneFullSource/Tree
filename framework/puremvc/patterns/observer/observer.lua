local var0_0 = class("Observer")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:setNotifyMethod(arg1_1)
	arg0_1:setNotifyContext(arg2_1)
end

function var0_0.setNotifyMethod(arg0_2, arg1_2)
	arg0_2.notify = arg1_2
end

function var0_0.setNotifyContext(arg0_3, arg1_3)
	arg0_3.context = arg1_3
end

function var0_0.getNotifyMethod(arg0_4)
	return arg0_4.notify
end

function var0_0.getNotifyContext(arg0_5)
	return arg0_5.context
end

function var0_0.notifyObserver(arg0_6, arg1_6)
	arg0_6.notify(arg0_6.context, arg1_6)
end

function var0_0.compareNotifyContext(arg0_7, arg1_7)
	return arg1_7 == arg0_7.context
end

return var0_0
