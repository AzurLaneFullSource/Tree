local var0 = class("State")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.name = arg1

	if arg2 ~= nil then
		arg0.entering = arg2
	end

	if arg3 ~= nil then
		arg0.exiting = arg3
	end

	if arg4 ~= nil then
		arg0.changed = arg4
	end

	arg0.transitions = {}
end

function var0.defineTrans(arg0, arg1, arg2)
	assert(arg1, "action should not be nil at " .. arg0.name)
	assert(arg2, "target should not be nil at " .. arg0.name)

	if arg0:getTarget(arg1) ~= nil then
		return
	end

	arg0.transitions[arg1] = arg2
end

function var0.removeTrans(arg0, arg1)
	arg0.transitions[arg1] = nil
end

function var0.getTarget(arg0, arg1)
	return arg0.transitions[arg1]
end

return var0
