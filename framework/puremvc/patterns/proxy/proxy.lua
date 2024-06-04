local var0 = import("..observer.Notifier")
local var1 = class("Proxy", var0)

function var1.Ctor(arg0, arg1, arg2)
	if arg1 ~= nil then
		arg0:setData(arg1)
	end

	arg0.proxyName = arg2 or arg0.__cname or var1.NAME
end

var1.NAME = "Proxy"

function var1.getProxyName(arg0)
	return arg0.proxyName
end

function var1.setData(arg0, arg1)
	arg0.data = arg1
end

function var1.getData(arg0)
	return arg0.data
end

function var1.onRegister(arg0)
	return
end

function var1.onRemove(arg0)
	return
end

return var1
