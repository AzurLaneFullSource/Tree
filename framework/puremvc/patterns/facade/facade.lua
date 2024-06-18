local var0_0 = import("...core.Controller")
local var1_0 = import("...core.Model")
local var2_0 = import("...core.View")
local var3_0 = import("..observer.Notification")
local var4_0 = class("Facade")

function var4_0.Ctor(arg0_1, arg1_1)
	if var4_0.instanceMap[arg1_1] ~= nil then
		error(var4_0.MULTITON_MSG)
	end

	arg0_1:initializeNotifier(arg1_1)

	var4_0.instanceMap[arg1_1] = arg0_1

	arg0_1:initializeFacade()
end

function var4_0.initializeFacade(arg0_2)
	arg0_2:initializeModel()
	arg0_2:initializeController()
	arg0_2:initializeView()
end

function var4_0.getInstance(arg0_3)
	if arg0_3 == nil then
		return nil
	end

	if var4_0.instanceMap[arg0_3] == nil then
		var4_0.instanceMap[arg0_3] = var4_0.New(arg0_3)
	end

	return var4_0.instanceMap[arg0_3]
end

function var4_0.initializeController(arg0_4)
	if arg0_4.controller ~= nil then
		return
	end

	arg0_4.controller = var0_0.getInstance(arg0_4.multitonKey)
end

function var4_0.initializeModel(arg0_5)
	if arg0_5.model ~= nil then
		return
	end

	arg0_5.model = var1_0.getInstance(arg0_5.multitonKey)
end

function var4_0.initializeView(arg0_6)
	if arg0_6.view ~= nil then
		return
	end

	arg0_6.view = var2_0.getInstance(arg0_6.multitonKey)
end

function var4_0.registerCommand(arg0_7, arg1_7, arg2_7)
	assert(arg2_7)
	arg0_7.controller:registerCommand(arg1_7, arg2_7)
end

function var4_0.removeCommand(arg0_8, arg1_8)
	arg0_8.controller:removeCommand(arg1_8)
end

function var4_0.hasCommand(arg0_9, arg1_9)
	return arg0_9.controller:hasCommand(arg1_9)
end

function var4_0.registerProxy(arg0_10, arg1_10)
	arg0_10.model:registerProxy(arg1_10)
end

function var4_0.retrieveProxy(arg0_11, arg1_11)
	return arg0_11.model:retrieveProxy(arg1_11)
end

function var4_0.removeProxy(arg0_12, arg1_12)
	local var0_12

	if arg0_12.model ~= nil then
		var0_12 = arg0_12.model:removeProxy(arg1_12)
	end

	return var0_12
end

function var4_0.hasProxy(arg0_13, arg1_13)
	return arg0_13.model:hasProxy(arg1_13)
end

function var4_0.registerMediator(arg0_14, arg1_14)
	if arg0_14.view ~= nil then
		arg0_14.view:registerMediator(arg1_14)
	end
end

function var4_0.retrieveMediator(arg0_15, arg1_15)
	return arg0_15.view:retrieveMediator(arg1_15)
end

function var4_0.removeMediator(arg0_16, arg1_16)
	local var0_16

	if arg0_16.view ~= nil then
		var0_16 = arg0_16.view:removeMediator(arg1_16)
	end

	return var0_16
end

function var4_0.hasMediator(arg0_17, arg1_17)
	return arg0_17.view:hasMediator(arg1_17)
end

function var4_0.sendNotification(arg0_18, arg1_18, arg2_18, arg3_18)
	arg0_18:notifyObservers(var3_0.New(arg1_18, arg2_18, arg3_18))
end

function var4_0.notifyObservers(arg0_19, arg1_19)
	if arg0_19.view ~= nil then
		arg0_19.view:notifyObservers(arg1_19)
	end
end

function var4_0.initializeNotifier(arg0_20, arg1_20)
	arg0_20.multitonKey = arg1_20
end

function var4_0.hasCore(arg0_21)
	return var4_0.instanceMap[arg0_21] ~= nil
end

function var4_0.removeCore(arg0_22)
	if var4_0.instanceMap[arg0_22] == nil then
		return
	end

	var1_0.removeModel(arg0_22)
	var2_0.removeView(arg0_22)
	var0_0.removeController(arg0_22)

	var4_0.instanceMap[arg0_22] = nil
end

var4_0.instanceMap = {}
var4_0.MULTITON_MSG = "Facade instance for this Multiton key already constructed!"

return var4_0
