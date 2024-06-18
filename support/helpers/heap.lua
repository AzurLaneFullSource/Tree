local var0_0 = class("Heap")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.array = arg1_1
	arg0_1.func = arg2_1
	arg0_1.values = underscore.map(arg1_1, function(arg0_2)
		return arg2_1(arg1_1)
	end)

	for iter0_1 = math.floor(#arg0_1.array / 2), 1, -1 do
		arg0_1:Dive(iter0_1)
	end
end

function var0_0.Float(arg0_3, arg1_3)
	local var0_3 = math.floor(arg1_3 / 2)

	while var0_3 > 0 and arg0_3.values[arg1_3] < arg0_3.values[var0_3] do
		arg0_3.array[var0_3], arg0_3.array[arg1_3] = arg0_3.array[arg1_3], arg0_3.array[var0_3]
		arg0_3.values[var0_3], arg0_3.values[arg1_3] = arg0_3.values[arg1_3], arg0_3.values[var0_3]
		arg1_3, var0_3 = var0_3, math.floor(var0_3 / 2)
	end
end

function var0_0.Dive(arg0_4, arg1_4)
	local var0_4 = arg1_4 + arg1_4
	local var1_4 = var0_4 + (var0_4 < #arg0_4.array and arg0_4.values[var0_4 + 1] < arg0_4.values[var0_4] and 1 or 0)

	while var1_4 <= #arg0_4.array and arg0_4.values[var1_4] < arg0_4.values[arg1_4] do
		arg0_4.array[var1_4], arg0_4.array[arg1_4] = arg0_4.array[arg1_4], arg0_4.array[var1_4]
		arg0_4.values[var1_4], arg0_4.values[arg1_4] = arg0_4.values[arg1_4], arg0_4.values[var1_4]
		arg1_4, var1_4 = var1_4, var1_4 + var1_4
		var1_4 = var1_4 + (var1_4 < #arg0_4.array and arg0_4.values[var1_4 + 1] < arg0_4.values[var1_4] and 1 or 0)
	end
end

function var0_0.POP(arg0_5)
	assert(#arg0_5.array == #arg0_5.values)

	arg0_5.array[1], arg0_5.array[#arg0_5.array] = arg0_5.array[#arg0_5.array], arg0_5.array[1]
	arg0_5.values[1], arg0_5.values[#arg0_5.values] = arg0_5.values[#arg0_5.values], arg0_5.values[1]

	local var0_5 = table.remove(arg0_5.array)

	table.remove(arg0_5.values)
	arg0_5:Dive(1)

	return var0_5
end

function var0_0.PUSH(arg0_6, arg1_6)
	table.insert(arg0_6.array, arg1_6)
	table.insert(arg0_6.values, arg0_6.func(arg1_6))
	arg0_6:Float(#arg0_6.array)
end

return var0_0
