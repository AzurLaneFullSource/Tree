local var0_0 = import("...patterns.observer.Notifier")
local var1_0 = class("FSMInjector", var0_0)
local var2_0 = import(".StateMachine")
local var3_0 = import(".State")

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1.fsm = arg1_1
end

function var1_0.inject(arg0_2)
	local var0_2 = var2_0.New()
	local var1_2 = arg0_2:getStates()

	for iter0_2, iter1_2 in ipairs(var1_2) do
		var0_2:registerState(iter1_2, arg0_2:isInitial(iter1_2.name))
	end

	arg0_2.facade:registerMediator(var0_2)
end

function var1_0.getStates(arg0_3)
	if arg0_3.stateList == nil then
		arg0_3.stateList = {}

		local var0_3 = arg0_3.fsm.state or {}

		for iter0_3, iter1_3 in ipairs(var0_3) do
			local var1_3 = arg0_3:createState(iter1_3)

			table.insert(arg0_3.stateList, var1_3)
		end
	end

	return arg0_3.stateList
end

function var1_0.createState(arg0_4, arg1_4)
	local var0_4 = arg1_4["@name"]
	local var1_4 = arg1_4["@entering"]
	local var2_4 = arg1_4["@exiting"]
	local var3_4 = arg1_4["@changed"]
	local var4_4 = var3_0.New(var0_4, var1_4, var2_4, var3_4)
	local var5_4 = arg1_4.transition or {}

	for iter0_4, iter1_4 in ipairs(var5_4) do
		var4_4:defineTrans(iter1_4["@action"], iter1_4["@target"])
	end

	return var4_4
end

function var1_0.isInitial(arg0_5, arg1_5)
	return arg1_5 == arg0_5.fsm["@initial"]
end

return var1_0
