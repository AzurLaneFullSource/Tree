local var0_0 = {
	funcs = {}
}

var0_0.__index = var0_0

function var0_0.__call(arg0_1, arg1_1)
	return var0_0:new(arg1_1)
end

function var0_0.new(arg0_2, arg1_2, arg2_2)
	return setmetatable({
		_val = arg1_2,
		chained = arg2_2 or false
	}, arg0_2)
end

function var0_0.iter(arg0_3)
	if type(arg0_3) == "function" then
		return arg0_3
	end

	return coroutine.wrap(function()
		for iter0_4 = 1, #arg0_3 do
			coroutine.yield(arg0_3[iter0_4])
		end
	end)
end

function var0_0.range(arg0_5, arg1_5, arg2_5)
	if arg1_5 == nil then
		arg1_5 = arg0_5
		arg0_5 = 1
	end

	arg2_5 = arg2_5 or 1

	local var0_5 = coroutine.wrap(function()
		for iter0_6 = arg0_5, arg1_5, arg2_5 do
			coroutine.yield(iter0_6)
		end
	end)

	return var0_0:new(var0_5)
end

function var0_0.identity(arg0_7)
	return arg0_7
end

function var0_0.chain(arg0_8)
	arg0_8.chained = true

	return arg0_8
end

function var0_0.value(arg0_9)
	return arg0_9._val
end

function var0_0.funcs.each(arg0_10, arg1_10)
	for iter0_10 in var0_0.iter(arg0_10) do
		arg1_10(iter0_10)
	end

	return arg0_10
end

function var0_0.funcs.map(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11 in var0_0.iter(arg0_11) do
		var0_11[#var0_11 + 1] = arg1_11(iter0_11)
	end

	return var0_11
end

function var0_0.funcs.reduce(arg0_12, arg1_12, arg2_12)
	for iter0_12 in var0_0.iter(arg0_12) do
		arg1_12 = arg2_12(arg1_12, iter0_12)
	end

	return arg1_12
end

function var0_0.funcs.detect(arg0_13, arg1_13)
	for iter0_13 in var0_0.iter(arg0_13) do
		if arg1_13(iter0_13) then
			return iter0_13
		end
	end

	return nil
end

function var0_0.funcs.select(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14 in var0_0.iter(arg0_14) do
		if arg1_14(iter0_14) then
			var0_14[#var0_14 + 1] = iter0_14
		end
	end

	return var0_14
end

function var0_0.funcs.reject(arg0_15, arg1_15)
	local var0_15 = {}

	for iter0_15 in var0_0.iter(arg0_15) do
		if not arg1_15(iter0_15) then
			var0_15[#var0_15 + 1] = iter0_15
		end
	end

	return var0_15
end

function var0_0.funcs.all(arg0_16, arg1_16)
	arg1_16 = arg1_16 or var0_0.identity

	for iter0_16 in var0_0.iter(arg0_16) do
		if not arg1_16(iter0_16) then
			return false
		end
	end

	return true
end

function var0_0.funcs.any(arg0_17, arg1_17)
	arg1_17 = arg1_17 or var0_0.identity

	for iter0_17 in var0_0.iter(arg0_17) do
		if arg1_17(iter0_17) then
			return true
		end
	end

	return false
end

function var0_0.funcs.include(arg0_18, arg1_18)
	for iter0_18 in var0_0.iter(arg0_18) do
		if iter0_18 == arg1_18 then
			return true
		end
	end

	return false
end

function var0_0.funcs.invoke(arg0_19, arg1_19, ...)
	local var0_19 = packEx(...)

	var0_0.funcs.each(arg0_19, function(arg0_20)
		arg0_20[arg1_19](arg0_20, unpackEx(var0_19))
	end)

	return arg0_19
end

function var0_0.funcs.pluck(arg0_21, arg1_21)
	return var0_0.funcs.map(arg0_21, function(arg0_22)
		return arg0_22[arg1_21]
	end)
end

function var0_0.funcs.min(arg0_23, arg1_23)
	arg1_23 = arg1_23 or var0_0.identity

	return var0_0.funcs.reduce(arg0_23, {}, function(arg0_24, arg1_24)
		if arg0_24.item == nil then
			arg0_24.item = arg1_24
			arg0_24.value = arg1_23(arg1_24)
		else
			local var0_24 = arg1_23(arg1_24)

			if var0_24 < arg0_24.value then
				arg0_24.item = arg1_24
				arg0_24.value = var0_24
			end
		end

		return arg0_24
	end).item
end

function var0_0.funcs.max(arg0_25, arg1_25)
	arg1_25 = arg1_25 or var0_0.identity

	return var0_0.funcs.reduce(arg0_25, {}, function(arg0_26, arg1_26)
		if arg0_26.item == nil then
			arg0_26.item = arg1_26
			arg0_26.value = arg1_25(arg1_26)
		else
			local var0_26 = arg1_25(arg1_26)

			if var0_26 > arg0_26.value then
				arg0_26.item = arg1_26
				arg0_26.value = var0_26
			end
		end

		return arg0_26
	end).item
end

function var0_0.funcs.to_array(arg0_27)
	local var0_27 = {}

	for iter0_27 in var0_0.iter(arg0_27) do
		var0_27[#var0_27 + 1] = iter0_27
	end

	return var0_27
end

function var0_0.funcs.reverse(arg0_28)
	local var0_28 = {}

	for iter0_28 in var0_0.iter(arg0_28) do
		table.insert(var0_28, 1, iter0_28)
	end

	return var0_28
end

function var0_0.funcs.sort(arg0_29, arg1_29)
	local var0_29 = arg0_29

	if type(arg0_29) == "function" then
		var0_29 = var0_0.funcs.to_array(arg0_29)
	end

	table.sort(var0_29, arg1_29)

	return var0_29
end

function var0_0.funcs.first(arg0_30, arg1_30)
	if arg1_30 == nil then
		return arg0_30[1]
	else
		local var0_30 = {}

		arg1_30 = math.min(arg1_30, #arg0_30)

		for iter0_30 = 1, arg1_30 do
			var0_30[iter0_30] = arg0_30[iter0_30]
		end

		return var0_30
	end
end

function var0_0.funcs.rest(arg0_31, arg1_31)
	arg1_31 = arg1_31 or 2

	local var0_31 = {}

	for iter0_31 = arg1_31, #arg0_31 do
		var0_31[#var0_31 + 1] = arg0_31[iter0_31]
	end

	return var0_31
end

function var0_0.funcs.slice(arg0_32, arg1_32, arg2_32)
	local var0_32 = {}

	arg1_32 = math.max(arg1_32, 1)

	local var1_32 = math.min(arg1_32 + arg2_32 - 1, #arg0_32)

	for iter0_32 = arg1_32, var1_32 do
		var0_32[#var0_32 + 1] = arg0_32[iter0_32]
	end

	return var0_32
end

function var0_0.funcs.unfold(arg0_33, arg1_33)
	if type(arg0_33) == "table" then
		for iter0_33 in var0_0.iter(arg0_33) do
			var0_0.funcs.unfold(iter0_33, arg1_33)
		end
	else
		arg1_33(arg0_33)
	end
end

function var0_0.funcs.flatten(arg0_34)
	local var0_34 = {}

	var0_0.funcs.unfold(arg0_34, function(arg0_35)
		var0_34[#var0_34 + 1] = arg0_35
	end)

	return var0_34
end

function var0_0.funcs.push(arg0_36, arg1_36)
	table.insert(arg0_36, arg1_36)

	return arg0_36
end

function var0_0.funcs.pop(arg0_37)
	return table.remove(arg0_37)
end

function var0_0.funcs.shift(arg0_38)
	return table.remove(arg0_38, 1)
end

function var0_0.funcs.unshift(arg0_39, arg1_39)
	table.insert(arg0_39, 1, arg1_39)

	return arg0_39
end

function var0_0.funcs.join(arg0_40, arg1_40)
	return table.concat(arg0_40, arg1_40)
end

function var0_0.funcs.keys(arg0_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in pairs(arg0_41) do
		var0_41[#var0_41 + 1] = iter0_41
	end

	return var0_41
end

function var0_0.funcs.values(arg0_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in pairs(arg0_42) do
		var0_42[#var0_42 + 1] = iter1_42
	end

	return var0_42
end

function var0_0.funcs.extend(arg0_43, arg1_43)
	for iter0_43, iter1_43 in pairs(arg1_43) do
		arg0_43[iter0_43] = iter1_43
	end

	return arg0_43
end

function var0_0.funcs.is_empty(arg0_44)
	return next(arg0_44) == nil
end

function var0_0.funcs.is_equal(arg0_45, arg1_45, arg2_45)
	local var0_45 = type(arg0_45)

	if var0_45 ~= type(arg1_45) then
		return false
	end

	if var0_45 ~= "table" then
		return arg0_45 == arg1_45
	end

	local var1_45 = getmetatable(arg0_45)

	if not arg2_45 and var1_45 and var1_45.__eq then
		return arg0_45 == arg1_45
	end

	local var2_45 = var0_0.funcs.is_equal

	for iter0_45, iter1_45 in pairs(arg0_45) do
		local var3_45 = arg1_45[iter0_45]

		if var3_45 == nil or not var2_45(iter1_45, var3_45, arg2_45) then
			return false
		end
	end

	for iter2_45, iter3_45 in pairs(arg1_45) do
		if arg0_45[iter2_45] == nil then
			return false
		end
	end

	return true
end

function var0_0.funcs.compose(...)
	local function var0_46(arg0_47, ...)
		if #arg0_47 > 1 then
			return arg0_47[1](var0_46(_.rest(arg0_47), ...))
		else
			return arg0_47[1](...)
		end
	end

	local var1_46 = {
		...
	}

	return function(...)
		return var0_46(var1_46, ...)
	end
end

function var0_0.funcs.wrap(arg0_49, arg1_49)
	return function(...)
		return arg1_49(arg0_49, ...)
	end
end

function var0_0.funcs.curry(arg0_51, arg1_51)
	return function(...)
		return arg0_51(arg1_51, ...)
	end
end

function var0_0.functions()
	return var0_0.keys(var0_0.funcs)
end

var0_0.methods = var0_0.functions
var0_0.funcs.for_each = var0_0.funcs.each
var0_0.funcs.collect = var0_0.funcs.map
var0_0.funcs.inject = var0_0.funcs.reduce
var0_0.funcs.foldl = var0_0.funcs.reduce
var0_0.funcs.filter = var0_0.funcs.select
var0_0.funcs.every = var0_0.funcs.all
var0_0.funcs.some = var0_0.funcs.any
var0_0.funcs.head = var0_0.funcs.first
var0_0.funcs.tail = var0_0.funcs.rest
var0_0.funcs.contains = var0_0.funcs.include

;(function()
	local function var0_54(arg0_55)
		local var0_55 = false

		if getmetatable(arg0_55) == var0_0 then
			var0_55 = arg0_55.chained
			arg0_55 = arg0_55._val
		end

		return arg0_55, var0_55
	end

	local function var1_54(arg0_56, arg1_56)
		if arg1_56 then
			arg0_56 = var0_0:new(arg0_56, true)
		end

		return arg0_56
	end

	for iter0_54, iter1_54 in pairs(var0_0.funcs) do
		var0_0[iter0_54] = function(arg0_57, ...)
			local var0_57, var1_57 = var0_54(arg0_57)

			return var1_54(iter1_54(var0_57, ...), var1_57)
		end
	end
end)()

return var0_0:new()
