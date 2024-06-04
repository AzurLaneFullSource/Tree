local var0 = class("Heap")

function var0.Ctor(arg0, arg1, arg2)
	arg0.array = arg1
	arg0.func = arg2
	arg0.values = underscore.map(arg1, function(arg0)
		return arg2(arg1)
	end)

	for iter0 = math.floor(#arg0.array / 2), 1, -1 do
		arg0:Dive(iter0)
	end
end

function var0.Float(arg0, arg1)
	local var0 = math.floor(arg1 / 2)

	while var0 > 0 and arg0.values[arg1] < arg0.values[var0] do
		arg0.array[var0], arg0.array[arg1] = arg0.array[arg1], arg0.array[var0]
		arg0.values[var0], arg0.values[arg1] = arg0.values[arg1], arg0.values[var0]
		arg1, var0 = var0, math.floor(var0 / 2)
	end
end

function var0.Dive(arg0, arg1)
	local var0 = arg1 + arg1
	local var1 = var0 + (var0 < #arg0.array and arg0.values[var0 + 1] < arg0.values[var0] and 1 or 0)

	while var1 <= #arg0.array and arg0.values[var1] < arg0.values[arg1] do
		arg0.array[var1], arg0.array[arg1] = arg0.array[arg1], arg0.array[var1]
		arg0.values[var1], arg0.values[arg1] = arg0.values[arg1], arg0.values[var1]
		arg1, var1 = var1, var1 + var1
		var1 = var1 + (var1 < #arg0.array and arg0.values[var1 + 1] < arg0.values[var1] and 1 or 0)
	end
end

function var0.POP(arg0)
	assert(#arg0.array == #arg0.values)

	arg0.array[1], arg0.array[#arg0.array] = arg0.array[#arg0.array], arg0.array[1]
	arg0.values[1], arg0.values[#arg0.values] = arg0.values[#arg0.values], arg0.values[1]

	local var0 = table.remove(arg0.array)

	table.remove(arg0.values)
	arg0:Dive(1)

	return var0
end

function var0.PUSH(arg0, arg1)
	table.insert(arg0.array, arg1)
	table.insert(arg0.values, arg0.func(arg1))
	arg0:Float(#arg0.array)
end

return var0
