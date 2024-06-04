local var0 = setmetatable
local var1 = {}

var1.__index = var1

function var1.new(arg0)
	local var0 = {
		_next = 0,
		length = 0,
		_prev = 0
	}

	var0._prev = var0
	var0._next = var0

	return var0(var0, var1)
end

function var1.clear(arg0)
	arg0._next = arg0
	arg0._prev = arg0
	arg0.length = 0
end

function var1.push(arg0, arg1)
	local var0 = {
		_prev = 0,
		_next = 0,
		removed = false,
		value = arg1
	}

	arg0._prev._next = var0
	var0._next = arg0
	var0._prev = arg0._prev
	arg0._prev = var0
	arg0.length = arg0.length + 1

	return var0
end

function var1.pushnode(arg0, arg1)
	if not arg1.removed then
		return
	end

	arg0._prev._next = arg1
	arg1._next = arg0
	arg1._prev = arg0._prev
	arg0._prev = arg1
	arg1.removed = false
	arg0.length = arg0.length + 1
end

function var1.pop(arg0)
	local var0 = arg0._prev

	arg0:remove(var0)

	return var0.value
end

function var1.unshift(arg0, arg1)
	local var0 = {
		_prev = 0,
		_next = 0,
		removed = false,
		value = arg1
	}

	arg0._next._prev = var0
	var0._prev = arg0
	var0._next = arg0._next
	arg0._next = var0
	arg0.length = arg0.length + 1

	return var0
end

function var1.shift(arg0)
	local var0 = arg0._next

	arg0:remove(var0)

	return var0.value
end

function var1.remove(arg0, arg1)
	if arg1.removed then
		return
	end

	local var0 = arg1._prev
	local var1 = arg1._next

	var1._prev = var0
	var0._next = var1
	arg0.length = math.max(0, arg0.length - 1)
	arg1.removed = true
end

function var1.find(arg0, arg1, arg2)
	arg2 = arg2 or arg0

	repeat
		if arg1 == arg2.value then
			return arg2
		else
			arg2 = arg2._next
		end
	until arg2 == arg0

	return nil
end

function var1.findlast(arg0, arg1, arg2)
	arg2 = arg2 or arg0

	repeat
		if arg1 == arg2.value then
			return arg2
		end

		arg2 = arg2._prev
	until arg2 == arg0

	return nil
end

function var1.next(arg0, arg1)
	local var0 = arg1._next

	if var0 ~= arg0 then
		return var0, var0.value
	end

	return nil
end

function var1.prev(arg0, arg1)
	local var0 = arg1._prev

	if var0 ~= arg0 then
		return var0, var0.value
	end

	return nil
end

function var1.erase(arg0, arg1)
	local var0 = arg0:find(arg1)

	if var0 then
		arg0:remove(var0)
	end
end

function var1.insert(arg0, arg1, arg2)
	if not arg2 then
		return arg0:push(arg1)
	end

	local var0 = {
		_prev = 0,
		_next = 0,
		removed = false,
		value = arg1
	}

	if arg2._next then
		arg2._next._prev = var0
		var0._next = arg2._next
	else
		arg0.last = var0
	end

	var0._prev = arg2
	arg2._next = var0
	arg0.length = arg0.length + 1

	return var0
end

function var1.head(arg0)
	return arg0._next.value
end

function var1.tail(arg0)
	return arg0._prev.value
end

function var1.clone(arg0)
	local var0 = var1:new()

	for iter0, iter1 in var1.next, arg0, arg0 do
		var0:push(iter1)
	end

	return var0
end

function ilist(arg0)
	return var1.next, arg0, arg0
end

function rilist(arg0)
	return var1.prev, arg0, arg0
end

var0(var1, {
	__call = var1.new
})

return var1
