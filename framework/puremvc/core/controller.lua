local var0_0 = import(".View")
local var1_0 = import("..patterns.observer.Observer")
local var2_0 = class("Controller")

function var2_0.Ctor(arg0_1, arg1_1)
	if var2_0.instanceMap[arg1_1] ~= nil then
		error(var2_0.MULTITON_MSG)
	end

	arg0_1.multitonKey = arg1_1
	var2_0.instanceMap[arg0_1.multitonKey] = arg0_1
	arg0_1.commandMap = {}

	arg0_1:initializeController()
end

function var2_0.initializeController(arg0_2)
	arg0_2.view = var0_0.getInstance(arg0_2.multitonKey)
end

function var2_0.getInstance(arg0_3)
	if arg0_3 == nil then
		return nil
	end

	if var2_0.instanceMap[arg0_3] == nil then
		return var2_0.New(arg0_3)
	else
		return var2_0.instanceMap[arg0_3]
	end
end

function var2_0.executeCommand(arg0_4, arg1_4)
	local var0_4 = arg0_4.commandMap[arg1_4:getName()]

	if var0_4 == nil then
		return
	end

	local var1_4 = var0_4.New()

	var1_4:initializeNotifier(arg0_4.multitonKey)
	var1_4:execute(arg1_4)
end

function var2_0.registerCommand(arg0_5, arg1_5, arg2_5)
	if arg0_5.commandMap[arg1_5] == nil then
		arg0_5.view:registerObserver(arg1_5, var1_0.New(arg0_5.executeCommand, arg0_5))
	end

	arg0_5.commandMap[arg1_5] = arg2_5
end

function var2_0.hasCommand(arg0_6, arg1_6)
	return arg0_6.commandMap[arg1_6] ~= nil
end

function var2_0.removeCommand(arg0_7, arg1_7)
	if arg0_7:hasCommand(arg1_7) then
		arg0_7.view:removeObserver(arg1_7, arg0_7)

		arg0_7.commandMap[arg1_7] = nil
	end
end

function var2_0.removeController(arg0_8)
	var2_0.instanceMap[arg0_8] = nil
end

var2_0.instanceMap = {}
var2_0.MULTITON_MSG = "controller key for this Multiton key already constructed"

return var2_0
