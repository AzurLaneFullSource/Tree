local var0_0 = class("CourtYardDispatcher")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.host = arg1_1
	arg0_1.__callbacks = {}
	arg0_1.__list = {}
end

function var0_0.GetHost(arg0_2)
	return arg0_2.host
end

function var0_0.AddListener(arg0_3, arg1_3, arg2_3)
	assert(type(arg1_3) == "string" and type(arg2_3) == "function")

	if not arg0_3.__callbacks[arg1_3] then
		arg0_3.__callbacks[arg1_3] = {}
	end

	table.insert(arg0_3.__callbacks[arg1_3], arg2_3)
end

function var0_0.RemoveListener(arg0_4, arg1_4, arg2_4)
	assert(type(arg1_4) == "string" and type(arg2_4) == "function")

	local var0_4 = arg0_4.__callbacks[arg1_4]

	if var0_4 then
		for iter0_4 = #var0_4, 1, -1 do
			if var0_4[iter0_4] == arg2_4 then
				table.remove(var0_4, iter0_4)
			end
		end
	end
end

function var0_0.ClearListener(arg0_5, arg1_5)
	assert(type(arg1_5) == "string")

	arg0_5.__callbacks[arg1_5] = nil
end

function var0_0.DispatchEvent(arg0_6, arg1_6, ...)
	assert(type(arg1_6) == "string")

	local var0_6 = arg0_6.__callbacks[arg1_6]

	if var0_6 then
		local var1_6 = #var0_6

		for iter0_6 = 1, var1_6 do
			arg0_6.__list[iter0_6] = var0_6[iter0_6]
		end

		for iter1_6 = 1, var1_6 do
			arg0_6.__list[iter1_6](arg1_6, arg0_6, ...)
		end
	end
end

function var0_0.ClearListeners(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.__callbacks) do
		arg0_7.__callbacks[iter0_7] = nil
	end

	for iter2_7, iter3_7 in ipairs(arg0_7.__list) do
		arg0_7.__list[iter2_7] = nil
	end
end

return var0_0
