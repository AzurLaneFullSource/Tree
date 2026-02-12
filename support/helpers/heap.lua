local var0_0 = class("Heap")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.array = arg1_1
	arg0_1.func = arg2_1

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.values = underscore.map(arg0_2.array, function(arg0_3)
		return arg0_2.func(arg0_3)
	end)
	arg0_2.length = #arg0_2.array

	for iter0_2 = math.floor(arg0_2.length / 2), 1, -1 do
		arg0_2:Dive(iter0_2)
	end
end

function var0_0.Float(arg0_4, arg1_4)
	local var0_4 = math.floor(arg1_4 / 2)

	while var0_4 > 0 and arg0_4.values[arg1_4] < arg0_4.values[var0_4] do
		arg0_4.array[var0_4], arg0_4.array[arg1_4] = arg0_4.array[arg1_4], arg0_4.array[var0_4]
		arg0_4.values[var0_4], arg0_4.values[arg1_4] = arg0_4.values[arg1_4], arg0_4.values[var0_4]
		arg1_4, var0_4 = var0_4, math.floor(var0_4 / 2)
	end

	return arg1_4
end

function var0_0.Dive(arg0_5, arg1_5)
	local var0_5 = arg1_5 + arg1_5
	local var1_5 = var0_5 + (var0_5 < arg0_5.length and arg0_5.values[var0_5 + 1] < arg0_5.values[var0_5] and 1 or 0)

	while var1_5 <= arg0_5.length and arg0_5.values[var1_5] < arg0_5.values[arg1_5] do
		arg0_5.array[var1_5], arg0_5.array[arg1_5] = arg0_5.array[arg1_5], arg0_5.array[var1_5]
		arg0_5.values[var1_5], arg0_5.values[arg1_5] = arg0_5.values[arg1_5], arg0_5.values[var1_5]
		arg1_5, var1_5 = var1_5, var1_5 + var1_5
		var1_5 = var1_5 + (var1_5 < arg0_5.length and arg0_5.values[var1_5 + 1] < arg0_5.values[var1_5] and 1 or 0)
	end

	return arg1_5
end

function var0_0.UpdateValue(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetInedex(arg1_6)

	if not var0_6 then
		return
	end

	arg0_6.values[var0_6] = arg0_6.func(arg0_6.array[var0_6])

	local var1_6 = arg0_6:Float(var0_6)
	local var2_6 = arg0_6:Dive(var1_6)
end

function var0_0.POP(arg0_7, arg1_7)
	local var0_7 = arg1_7 and arg0_7:GetInedex(arg1_7) or 1

	assert(arg0_7.length == #arg0_7.values)

	if var0_7 == arg0_7.length then
		arg0_7.length = arg0_7.length - 1
	else
		arg0_7.array[var0_7], arg0_7.array[arg0_7.length] = arg0_7.array[arg0_7.length], arg0_7.array[var0_7]
		arg0_7.values[var0_7], arg0_7.values[arg0_7.length] = arg0_7.values[arg0_7.length], arg0_7.values[var0_7]
		arg0_7.length = arg0_7.length - 1

		arg0_7:Dive(var0_7)
	end

	return table.remove(arg0_7.array), table.remove(arg0_7.values)
end

function var0_0.PUSH(arg0_8, arg1_8)
	table.insert(arg0_8.array, arg1_8)
	table.insert(arg0_8.values, arg0_8.func(arg1_8))

	arg0_8.length = arg0_8.length + 1

	arg0_8:Float(arg0_8.length)
end

function var0_0.GetLength(arg0_9)
	return arg0_9.length
end

function var0_0.GetInedex(arg0_10, arg1_10)
	return table.indexof(arg0_10.array, arg1_10)
end

function var0_0.GetTop(arg0_11)
	return {
		element = arg0_11.array[1],
		value = arg0_11.values[1]
	}
end

return var0_0
