local var0 = {
	funcs = {}
}

var0.__index = var0

function var0.__call(arg0, arg1)
	return var0:new(arg1)
end

function var0.new(arg0, arg1, arg2)
	return setmetatable({
		_val = arg1,
		chained = arg2 or false
	}, arg0)
end

function var0.iter(arg0)
	if type(arg0) == "function" then
		return arg0
	end

	return coroutine.wrap(function()
		for iter0 = 1, #arg0 do
			coroutine.yield(arg0[iter0])
		end
	end)
end

function var0.range(arg0, arg1, arg2)
	if arg1 == nil then
		arg1 = arg0
		arg0 = 1
	end

	arg2 = arg2 or 1

	local var0 = coroutine.wrap(function()
		for iter0 = arg0, arg1, arg2 do
			coroutine.yield(iter0)
		end
	end)

	return var0:new(var0)
end

function var0.identity(arg0)
	return arg0
end

function var0.chain(arg0)
	arg0.chained = true

	return arg0
end

function var0.value(arg0)
	return arg0._val
end

function var0.funcs.each(arg0, arg1)
	for iter0 in var0.iter(arg0) do
		arg1(iter0)
	end

	return arg0
end

function var0.funcs.map(arg0, arg1)
	local var0 = {}

	for iter0 in var0.iter(arg0) do
		var0[#var0 + 1] = arg1(iter0)
	end

	return var0
end

function var0.funcs.reduce(arg0, arg1, arg2)
	for iter0 in var0.iter(arg0) do
		arg1 = arg2(arg1, iter0)
	end

	return arg1
end

function var0.funcs.detect(arg0, arg1)
	for iter0 in var0.iter(arg0) do
		if arg1(iter0) then
			return iter0
		end
	end

	return nil
end

function var0.funcs.select(arg0, arg1)
	local var0 = {}

	for iter0 in var0.iter(arg0) do
		if arg1(iter0) then
			var0[#var0 + 1] = iter0
		end
	end

	return var0
end

function var0.funcs.reject(arg0, arg1)
	local var0 = {}

	for iter0 in var0.iter(arg0) do
		if not arg1(iter0) then
			var0[#var0 + 1] = iter0
		end
	end

	return var0
end

function var0.funcs.all(arg0, arg1)
	arg1 = arg1 or var0.identity

	for iter0 in var0.iter(arg0) do
		if not arg1(iter0) then
			return false
		end
	end

	return true
end

function var0.funcs.any(arg0, arg1)
	arg1 = arg1 or var0.identity

	for iter0 in var0.iter(arg0) do
		if arg1(iter0) then
			return true
		end
	end

	return false
end

function var0.funcs.include(arg0, arg1)
	for iter0 in var0.iter(arg0) do
		if iter0 == arg1 then
			return true
		end
	end

	return false
end

function var0.funcs.invoke(arg0, arg1, ...)
	local var0 = packEx(...)

	var0.funcs.each(arg0, function(arg0)
		arg0[arg1](arg0, unpackEx(var0))
	end)

	return arg0
end

function var0.funcs.pluck(arg0, arg1)
	return var0.funcs.map(arg0, function(arg0)
		return arg0[arg1]
	end)
end

function var0.funcs.min(arg0, arg1)
	arg1 = arg1 or var0.identity

	return var0.funcs.reduce(arg0, {}, function(arg0, arg1)
		if arg0.item == nil then
			arg0.item = arg1
			arg0.value = arg1(arg1)
		else
			local var0 = arg1(arg1)

			if var0 < arg0.value then
				arg0.item = arg1
				arg0.value = var0
			end
		end

		return arg0
	end).item
end

function var0.funcs.max(arg0, arg1)
	arg1 = arg1 or var0.identity

	return var0.funcs.reduce(arg0, {}, function(arg0, arg1)
		if arg0.item == nil then
			arg0.item = arg1
			arg0.value = arg1(arg1)
		else
			local var0 = arg1(arg1)

			if var0 > arg0.value then
				arg0.item = arg1
				arg0.value = var0
			end
		end

		return arg0
	end).item
end

function var0.funcs.to_array(arg0)
	local var0 = {}

	for iter0 in var0.iter(arg0) do
		var0[#var0 + 1] = iter0
	end

	return var0
end

function var0.funcs.reverse(arg0)
	local var0 = {}

	for iter0 in var0.iter(arg0) do
		table.insert(var0, 1, iter0)
	end

	return var0
end

function var0.funcs.sort(arg0, arg1)
	local var0 = arg0

	if type(arg0) == "function" then
		var0 = var0.funcs.to_array(arg0)
	end

	table.sort(var0, arg1)

	return var0
end

function var0.funcs.first(arg0, arg1)
	if arg1 == nil then
		return arg0[1]
	else
		local var0 = {}

		arg1 = math.min(arg1, #arg0)

		for iter0 = 1, arg1 do
			var0[iter0] = arg0[iter0]
		end

		return var0
	end
end

function var0.funcs.rest(arg0, arg1)
	arg1 = arg1 or 2

	local var0 = {}

	for iter0 = arg1, #arg0 do
		var0[#var0 + 1] = arg0[iter0]
	end

	return var0
end

function var0.funcs.slice(arg0, arg1, arg2)
	local var0 = {}

	arg1 = math.max(arg1, 1)

	local var1 = math.min(arg1 + arg2 - 1, #arg0)

	for iter0 = arg1, var1 do
		var0[#var0 + 1] = arg0[iter0]
	end

	return var0
end

function var0.funcs.unfold(arg0, arg1)
	if type(arg0) == "table" then
		for iter0 in var0.iter(arg0) do
			var0.funcs.unfold(iter0, arg1)
		end
	else
		arg1(arg0)
	end
end

function var0.funcs.flatten(arg0)
	local var0 = {}

	var0.funcs.unfold(arg0, function(arg0)
		var0[#var0 + 1] = arg0
	end)

	return var0
end

function var0.funcs.push(arg0, arg1)
	table.insert(arg0, arg1)

	return arg0
end

function var0.funcs.pop(arg0)
	return table.remove(arg0)
end

function var0.funcs.shift(arg0)
	return table.remove(arg0, 1)
end

function var0.funcs.unshift(arg0, arg1)
	table.insert(arg0, 1, arg1)

	return arg0
end

function var0.funcs.join(arg0, arg1)
	return table.concat(arg0, arg1)
end

function var0.funcs.keys(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0) do
		var0[#var0 + 1] = iter0
	end

	return var0
end

function var0.funcs.values(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0) do
		var0[#var0 + 1] = iter1
	end

	return var0
end

function var0.funcs.extend(arg0, arg1)
	for iter0, iter1 in pairs(arg1) do
		arg0[iter0] = iter1
	end

	return arg0
end

function var0.funcs.is_empty(arg0)
	return next(arg0) == nil
end

function var0.funcs.is_equal(arg0, arg1, arg2)
	local var0 = type(arg0)

	if var0 ~= type(arg1) then
		return false
	end

	if var0 ~= "table" then
		return arg0 == arg1
	end

	local var1 = getmetatable(arg0)

	if not arg2 and var1 and var1.__eq then
		return arg0 == arg1
	end

	local var2 = var0.funcs.is_equal

	for iter0, iter1 in pairs(arg0) do
		local var3 = arg1[iter0]

		if var3 == nil or not var2(iter1, var3, arg2) then
			return false
		end
	end

	for iter2, iter3 in pairs(arg1) do
		if arg0[iter2] == nil then
			return false
		end
	end

	return true
end

function var0.funcs.compose(...)
	local function var0(arg0, ...)
		if #arg0 > 1 then
			return arg0[1](var0(_.rest(arg0), ...))
		else
			return arg0[1](...)
		end
	end

	local var1 = {
		...
	}

	return function(...)
		return var0(var1, ...)
	end
end

function var0.funcs.wrap(arg0, arg1)
	return function(...)
		return arg1(arg0, ...)
	end
end

function var0.funcs.curry(arg0, arg1)
	return function(...)
		return arg0(arg1, ...)
	end
end

function var0.functions()
	return var0.keys(var0.funcs)
end

var0.methods = var0.functions
var0.funcs.for_each = var0.funcs.each
var0.funcs.collect = var0.funcs.map
var0.funcs.inject = var0.funcs.reduce
var0.funcs.foldl = var0.funcs.reduce
var0.funcs.filter = var0.funcs.select
var0.funcs.every = var0.funcs.all
var0.funcs.some = var0.funcs.any
var0.funcs.head = var0.funcs.first
var0.funcs.tail = var0.funcs.rest
var0.funcs.contains = var0.funcs.include

;(function()
	local var0 = function(arg0)
		local var0 = false

		if getmetatable(arg0) == var0 then
			var0 = arg0.chained
			arg0 = arg0._val
		end

		return arg0, var0
	end

	local function var1(arg0, arg1)
		if arg1 then
			arg0 = var0:new(arg0, true)
		end

		return arg0
	end

	for iter0, iter1 in pairs(var0.funcs) do
		var0[iter0] = function(arg0, ...)
			local var0, var1 = var0(arg0)

			return var1(iter1(var0, ...), var1)
		end
	end
end)()

return var0:new()
