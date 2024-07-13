local var0_0 = class("FuncBuffer")

function var0_0.Ctor(arg0_1)
	arg0_1.buffers = {}
	arg0_1.notifier = false
end

function var0_0.SetNotifier(arg0_2, arg1_2)
	arg0_2.notifier = defaultValue(arg1_2, false)
end

function var0_0.IsEmpty(arg0_3)
	return #arg0_3.buffers <= 0
end

function var0_0.Pop(arg0_4)
	return table.remove(arg0_4.buffers, 1)
end

function var0_0.Push(arg0_5, arg1_5, ...)
	table.insert(arg0_5.buffers, {
		funcName = arg1_5,
		params = {
			...
		},
		paramLength = select("#", ...)
	})
	arg0_5:ExcuteAll()
end

function var0_0.ExcuteAll(arg0_6)
	if arg0_6.notifier then
		while not arg0_6:IsEmpty() do
			local var0_6 = arg0_6:Pop()

			arg0_6.notifier[var0_6.funcName](arg0_6.notifier, unpack(var0_6.params, 1, var0_6.paramLength))
		end
	end
end

function var0_0.Clear(arg0_7)
	table.clear(arg0_7.buffers)
end

function var0_0.__index(arg0_8, arg1_8)
	return rawget(arg0_8, arg1_8) or var0_0[arg1_8] or function(arg0_9, ...)
		arg0_8:Push(arg1_8, ...)
	end
end

return var0_0
