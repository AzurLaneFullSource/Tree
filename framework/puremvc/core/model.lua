local var0 = class("Model")

function var0.Ctor(arg0, arg1)
	if var0.instanceMap[arg1] then
		error(var0.MULTITON_MSG)
	end

	arg0.multitonKey = arg1
	var0.instanceMap[arg1] = arg0
	arg0.proxyMap = {}

	arg0:initializeModel()
end

function var0.initializeModel(arg0)
	return
end

function var0.getInstance(arg0)
	if arg0 == nil then
		return nil
	end

	if var0.instanceMap[arg0] == nil then
		return var0.New(arg0)
	else
		return var0.instanceMap[arg0]
	end
end

function var0.registerProxy(arg0, arg1)
	arg1:initializeNotifier(arg0.multitonKey)

	arg0.proxyMap[arg1:getProxyName()] = arg1

	arg1:onRegister()
end

function var0.retrieveProxy(arg0, arg1)
	return arg0.proxyMap[arg1]
end

function var0.hasProxy(arg0, arg1)
	return arg0.proxyMap[arg1] ~= nil
end

function var0.removeProxy(arg0, arg1)
	local var0 = arg0.proxyMap[arg1]

	if var0 ~= nil then
		arg0.proxyMap[arg1] = nil

		var0:onRemove()
	end

	return var0
end

function var0.removeModel(arg0)
	var0.instanceMap[arg0] = nil
end

var0.instanceMap = {}
var0.MULTITON_MSG = "Model instance for this Multiton key already constructed!"

return var0
