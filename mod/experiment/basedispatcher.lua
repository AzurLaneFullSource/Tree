local var0 = class("BaseDispatcher")

function var0.Ctor(arg0)
	arg0.__callbacks = {}
	arg0.__list = {}
end

function var0.AddListener(arg0, arg1, arg2)
	assert(type(arg1) == "string" and type(arg2) == "function")

	if not arg0.__callbacks[arg1] then
		arg0.__callbacks[arg1] = {}
	end

	table.insert(arg0.__callbacks[arg1], arg2)
end

function var0.RemoveListener(arg0, arg1, arg2)
	assert(type(arg1) == "string" and type(arg2) == "function")

	local var0 = arg0.__callbacks[arg1]

	if var0 then
		for iter0 = #var0, 1, -1 do
			if var0[iter0] == arg2 then
				table.remove(var0, iter0)
			end
		end
	end
end

function var0.ClearListener(arg0, arg1)
	assert(type(arg1) == "string")

	arg0.__callbacks[arg1] = nil
end

function var0.DispatchEvent(arg0, arg1, ...)
	assert(type(arg1) == "string")

	local var0 = arg0.__callbacks[arg1]

	if var0 then
		local var1 = #var0

		for iter0 = 1, var1 do
			arg0.__list[iter0] = var0[iter0]
		end

		for iter1 = 1, var1 do
			arg0.__list[iter1](arg1, arg0, ...)
		end
	end
end

function var0.ClearListeners(arg0)
	for iter0, iter1 in pairs(arg0.__callbacks) do
		arg0.__callbacks[iter0] = nil
	end

	for iter2, iter3 in ipairs(arg0.__list) do
		arg0.__list[iter2] = nil
	end
end

return var0
