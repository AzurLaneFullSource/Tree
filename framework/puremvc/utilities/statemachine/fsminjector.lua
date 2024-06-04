local var0 = import("...patterns.observer.Notifier")
local var1 = class("FSMInjector", var0)
local var2 = import(".StateMachine")
local var3 = import(".State")

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0)

	arg0.fsm = arg1
end

function var1.inject(arg0)
	local var0 = var2.New()
	local var1 = arg0:getStates()

	for iter0, iter1 in ipairs(var1) do
		var0:registerState(iter1, arg0:isInitial(iter1.name))
	end

	arg0.facade:registerMediator(var0)
end

function var1.getStates(arg0)
	if arg0.stateList == nil then
		arg0.stateList = {}

		local var0 = arg0.fsm.state or {}

		for iter0, iter1 in ipairs(var0) do
			local var1 = arg0:createState(iter1)

			table.insert(arg0.stateList, var1)
		end
	end

	return arg0.stateList
end

function var1.createState(arg0, arg1)
	local var0 = arg1["@name"]
	local var1 = arg1["@entering"]
	local var2 = arg1["@exiting"]
	local var3 = arg1["@changed"]
	local var4 = var3.New(var0, var1, var2, var3)
	local var5 = arg1.transition or {}

	for iter0, iter1 in ipairs(var5) do
		var4:defineTrans(iter1["@action"], iter1["@target"])
	end

	return var4
end

function var1.isInitial(arg0, arg1)
	return arg1 == arg0.fsm["@initial"]
end

return var1
