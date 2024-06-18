local var0_0 = class("BaseDispatcher")

function var0_0.Ctor(arg0_1)
	arg0_1.__callbacks = {}
	arg0_1.__list = {}
end

function var0_0.AddListener(arg0_2, arg1_2, arg2_2)
	assert(type(arg1_2) == "string" and type(arg2_2) == "function")

	if not arg0_2.__callbacks[arg1_2] then
		arg0_2.__callbacks[arg1_2] = {}
	end

	table.insert(arg0_2.__callbacks[arg1_2], arg2_2)
end

function var0_0.RemoveListener(arg0_3, arg1_3, arg2_3)
	assert(type(arg1_3) == "string" and type(arg2_3) == "function")

	local var0_3 = arg0_3.__callbacks[arg1_3]

	if var0_3 then
		for iter0_3 = #var0_3, 1, -1 do
			if var0_3[iter0_3] == arg2_3 then
				table.remove(var0_3, iter0_3)
			end
		end
	end
end

function var0_0.ClearListener(arg0_4, arg1_4)
	assert(type(arg1_4) == "string")

	arg0_4.__callbacks[arg1_4] = nil
end

function var0_0.DispatchEvent(arg0_5, arg1_5, ...)
	assert(type(arg1_5) == "string")

	local var0_5 = arg0_5.__callbacks[arg1_5]

	if var0_5 then
		local var1_5 = #var0_5

		for iter0_5 = 1, var1_5 do
			arg0_5.__list[iter0_5] = var0_5[iter0_5]
		end

		for iter1_5 = 1, var1_5 do
			arg0_5.__list[iter1_5](arg1_5, arg0_5, ...)
		end
	end
end

function var0_0.ClearListeners(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.__callbacks) do
		arg0_6.__callbacks[iter0_6] = nil
	end

	for iter2_6, iter3_6 in ipairs(arg0_6.__list) do
		arg0_6.__list[iter2_6] = nil
	end
end

return var0_0
