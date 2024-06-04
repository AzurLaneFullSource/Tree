local var0 = class("FuncBuffer")

function var0.Ctor(arg0)
	arg0.buffers = {}
	arg0.notifier = false
end

function var0.SetNotifier(arg0, arg1)
	arg0.notifier = defaultValue(arg1, false)
end

function var0.IsEmpty(arg0)
	return #arg0.buffers <= 0
end

function var0.Pop(arg0)
	return table.remove(arg0.buffers, 1)
end

function var0.Push(arg0, arg1, ...)
	table.insert(arg0.buffers, {
		funcName = arg1,
		params = {
			...
		},
		paramLength = select("#", ...)
	})
	arg0:ExcuteAll()
end

function var0.ExcuteAll(arg0)
	if arg0.notifier then
		while not arg0:IsEmpty() do
			local var0 = arg0:Pop()

			arg0.notifier[var0.funcName](arg0.notifier, unpack(var0.params, 1, var0.paramLength))
		end
	end
end

function var0.Clear(arg0)
	table.clear(arg0.buffers)
end

function var0.__index(arg0, arg1)
	return rawget(arg0, arg1) or var0[arg1] or function(arg0, ...)
		arg0:Push(arg1, ...)
	end
end

return var0
