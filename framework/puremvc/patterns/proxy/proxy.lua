local var0_0 = import("..observer.Notifier")
local var1_0 = class("Proxy", var0_0)

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	if arg1_1 ~= nil then
		arg0_1:setData(arg1_1)
	end

	arg0_1.proxyName = arg2_1 or arg0_1.__cname or var1_0.NAME
end

var1_0.NAME = "Proxy"

function var1_0.getProxyName(arg0_2)
	return arg0_2.proxyName
end

function var1_0.setData(arg0_3, arg1_3)
	arg0_3.data = arg1_3
end

function var1_0.getData(arg0_4)
	return arg0_4.data
end

function var1_0.onRegister(arg0_5)
	return
end

function var1_0.onRemove(arg0_6)
	return
end

return var1_0
