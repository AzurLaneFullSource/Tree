local var0 = import(".View")
local var1 = import("..patterns.observer.Observer")
local var2 = class("Controller")

function var2.Ctor(arg0, arg1)
	if var2.instanceMap[arg1] ~= nil then
		error(var2.MULTITON_MSG)
	end

	arg0.multitonKey = arg1
	var2.instanceMap[arg0.multitonKey] = arg0
	arg0.commandMap = {}

	arg0:initializeController()
end

function var2.initializeController(arg0)
	arg0.view = var0.getInstance(arg0.multitonKey)
end

function var2.getInstance(arg0)
	if arg0 == nil then
		return nil
	end

	if var2.instanceMap[arg0] == nil then
		return var2.New(arg0)
	else
		return var2.instanceMap[arg0]
	end
end

function var2.executeCommand(arg0, arg1)
	local var0 = arg0.commandMap[arg1:getName()]

	if var0 == nil then
		return
	end

	local var1 = var0.New()

	var1:initializeNotifier(arg0.multitonKey)
	var1:execute(arg1)
end

function var2.registerCommand(arg0, arg1, arg2)
	if arg0.commandMap[arg1] == nil then
		arg0.view:registerObserver(arg1, var1.New(arg0.executeCommand, arg0))
	end

	arg0.commandMap[arg1] = arg2
end

function var2.hasCommand(arg0, arg1)
	return arg0.commandMap[arg1] ~= nil
end

function var2.removeCommand(arg0, arg1)
	if arg0:hasCommand(arg1) then
		arg0.view:removeObserver(arg1, arg0)

		arg0.commandMap[arg1] = nil
	end
end

function var2.removeController(arg0)
	var2.instanceMap[arg0] = nil
end

var2.instanceMap = {}
var2.MULTITON_MSG = "controller key for this Multiton key already constructed"

return var2
