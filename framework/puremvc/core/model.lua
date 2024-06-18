local var0_0 = class("Model")

function var0_0.Ctor(arg0_1, arg1_1)
	if var0_0.instanceMap[arg1_1] then
		error(var0_0.MULTITON_MSG)
	end

	arg0_1.multitonKey = arg1_1
	var0_0.instanceMap[arg1_1] = arg0_1
	arg0_1.proxyMap = {}

	arg0_1:initializeModel()
end

function var0_0.initializeModel(arg0_2)
	return
end

function var0_0.getInstance(arg0_3)
	if arg0_3 == nil then
		return nil
	end

	if var0_0.instanceMap[arg0_3] == nil then
		return var0_0.New(arg0_3)
	else
		return var0_0.instanceMap[arg0_3]
	end
end

function var0_0.registerProxy(arg0_4, arg1_4)
	arg1_4:initializeNotifier(arg0_4.multitonKey)

	arg0_4.proxyMap[arg1_4:getProxyName()] = arg1_4

	arg1_4:onRegister()
end

function var0_0.retrieveProxy(arg0_5, arg1_5)
	return arg0_5.proxyMap[arg1_5]
end

function var0_0.hasProxy(arg0_6, arg1_6)
	return arg0_6.proxyMap[arg1_6] ~= nil
end

function var0_0.removeProxy(arg0_7, arg1_7)
	local var0_7 = arg0_7.proxyMap[arg1_7]

	if var0_7 ~= nil then
		arg0_7.proxyMap[arg1_7] = nil

		var0_7:onRemove()
	end

	return var0_7
end

function var0_0.removeModel(arg0_8)
	var0_0.instanceMap[arg0_8] = nil
end

var0_0.instanceMap = {}
var0_0.MULTITON_MSG = "Model instance for this Multiton key already constructed!"

return var0_0
