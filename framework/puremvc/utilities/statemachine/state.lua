local var0_0 = class("State")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.name = arg1_1

	if arg2_1 ~= nil then
		arg0_1.entering = arg2_1
	end

	if arg3_1 ~= nil then
		arg0_1.exiting = arg3_1
	end

	if arg4_1 ~= nil then
		arg0_1.changed = arg4_1
	end

	arg0_1.transitions = {}
end

function var0_0.defineTrans(arg0_2, arg1_2, arg2_2)
	assert(arg1_2, "action should not be nil at " .. arg0_2.name)
	assert(arg2_2, "target should not be nil at " .. arg0_2.name)

	if arg0_2:getTarget(arg1_2) ~= nil then
		return
	end

	arg0_2.transitions[arg1_2] = arg2_2
end

function var0_0.removeTrans(arg0_3, arg1_3)
	arg0_3.transitions[arg1_3] = nil
end

function var0_0.getTarget(arg0_4, arg1_4)
	return arg0_4.transitions[arg1_4]
end

return var0_0
