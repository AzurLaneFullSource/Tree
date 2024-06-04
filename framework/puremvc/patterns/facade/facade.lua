local var0 = import("...core.Controller")
local var1 = import("...core.Model")
local var2 = import("...core.View")
local var3 = import("..observer.Notification")
local var4 = class("Facade")

function var4.Ctor(arg0, arg1)
	if var4.instanceMap[arg1] ~= nil then
		error(var4.MULTITON_MSG)
	end

	arg0:initializeNotifier(arg1)

	var4.instanceMap[arg1] = arg0

	arg0:initializeFacade()
end

function var4.initializeFacade(arg0)
	arg0:initializeModel()
	arg0:initializeController()
	arg0:initializeView()
end

function var4.getInstance(arg0)
	if arg0 == nil then
		return nil
	end

	if var4.instanceMap[arg0] == nil then
		var4.instanceMap[arg0] = var4.New(arg0)
	end

	return var4.instanceMap[arg0]
end

function var4.initializeController(arg0)
	if arg0.controller ~= nil then
		return
	end

	arg0.controller = var0.getInstance(arg0.multitonKey)
end

function var4.initializeModel(arg0)
	if arg0.model ~= nil then
		return
	end

	arg0.model = var1.getInstance(arg0.multitonKey)
end

function var4.initializeView(arg0)
	if arg0.view ~= nil then
		return
	end

	arg0.view = var2.getInstance(arg0.multitonKey)
end

function var4.registerCommand(arg0, arg1, arg2)
	assert(arg2)
	arg0.controller:registerCommand(arg1, arg2)
end

function var4.removeCommand(arg0, arg1)
	arg0.controller:removeCommand(arg1)
end

function var4.hasCommand(arg0, arg1)
	return arg0.controller:hasCommand(arg1)
end

function var4.registerProxy(arg0, arg1)
	arg0.model:registerProxy(arg1)
end

function var4.retrieveProxy(arg0, arg1)
	return arg0.model:retrieveProxy(arg1)
end

function var4.removeProxy(arg0, arg1)
	local var0

	if arg0.model ~= nil then
		var0 = arg0.model:removeProxy(arg1)
	end

	return var0
end

function var4.hasProxy(arg0, arg1)
	return arg0.model:hasProxy(arg1)
end

function var4.registerMediator(arg0, arg1)
	if arg0.view ~= nil then
		arg0.view:registerMediator(arg1)
	end
end

function var4.retrieveMediator(arg0, arg1)
	return arg0.view:retrieveMediator(arg1)
end

function var4.removeMediator(arg0, arg1)
	local var0

	if arg0.view ~= nil then
		var0 = arg0.view:removeMediator(arg1)
	end

	return var0
end

function var4.hasMediator(arg0, arg1)
	return arg0.view:hasMediator(arg1)
end

function var4.sendNotification(arg0, arg1, arg2, arg3)
	arg0:notifyObservers(var3.New(arg1, arg2, arg3))
end

function var4.notifyObservers(arg0, arg1)
	if arg0.view ~= nil then
		arg0.view:notifyObservers(arg1)
	end
end

function var4.initializeNotifier(arg0, arg1)
	arg0.multitonKey = arg1
end

function var4.hasCore(arg0)
	return var4.instanceMap[arg0] ~= nil
end

function var4.removeCore(arg0)
	if var4.instanceMap[arg0] == nil then
		return
	end

	var1.removeModel(arg0)
	var2.removeView(arg0)
	var0.removeController(arg0)

	var4.instanceMap[arg0] = nil
end

var4.instanceMap = {}
var4.MULTITON_MSG = "Facade instance for this Multiton key already constructed!"

return var4
