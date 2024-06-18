local var0_0 = setmetatable
local var1_0 = {}

var1_0.__index = var1_0

function var1_0.new(arg0_1)
	local var0_1 = {
		_next = 0,
		length = 0,
		_prev = 0
	}

	var0_1._prev = var0_1
	var0_1._next = var0_1

	return var0_0(var0_1, var1_0)
end

function var1_0.clear(arg0_2)
	arg0_2._next = arg0_2
	arg0_2._prev = arg0_2
	arg0_2.length = 0
end

function var1_0.push(arg0_3, arg1_3)
	local var0_3 = {
		_prev = 0,
		_next = 0,
		removed = false,
		value = arg1_3
	}

	arg0_3._prev._next = var0_3
	var0_3._next = arg0_3
	var0_3._prev = arg0_3._prev
	arg0_3._prev = var0_3
	arg0_3.length = arg0_3.length + 1

	return var0_3
end

function var1_0.pushnode(arg0_4, arg1_4)
	if not arg1_4.removed then
		return
	end

	arg0_4._prev._next = arg1_4
	arg1_4._next = arg0_4
	arg1_4._prev = arg0_4._prev
	arg0_4._prev = arg1_4
	arg1_4.removed = false
	arg0_4.length = arg0_4.length + 1
end

function var1_0.pop(arg0_5)
	local var0_5 = arg0_5._prev

	arg0_5:remove(var0_5)

	return var0_5.value
end

function var1_0.unshift(arg0_6, arg1_6)
	local var0_6 = {
		_prev = 0,
		_next = 0,
		removed = false,
		value = arg1_6
	}

	arg0_6._next._prev = var0_6
	var0_6._prev = arg0_6
	var0_6._next = arg0_6._next
	arg0_6._next = var0_6
	arg0_6.length = arg0_6.length + 1

	return var0_6
end

function var1_0.shift(arg0_7)
	local var0_7 = arg0_7._next

	arg0_7:remove(var0_7)

	return var0_7.value
end

function var1_0.remove(arg0_8, arg1_8)
	if arg1_8.removed then
		return
	end

	local var0_8 = arg1_8._prev
	local var1_8 = arg1_8._next

	var1_8._prev = var0_8
	var0_8._next = var1_8
	arg0_8.length = math.max(0, arg0_8.length - 1)
	arg1_8.removed = true
end

function var1_0.find(arg0_9, arg1_9, arg2_9)
	arg2_9 = arg2_9 or arg0_9

	repeat
		if arg1_9 == arg2_9.value then
			return arg2_9
		else
			arg2_9 = arg2_9._next
		end
	until arg2_9 == arg0_9

	return nil
end

function var1_0.findlast(arg0_10, arg1_10, arg2_10)
	arg2_10 = arg2_10 or arg0_10

	repeat
		if arg1_10 == arg2_10.value then
			return arg2_10
		end

		arg2_10 = arg2_10._prev
	until arg2_10 == arg0_10

	return nil
end

function var1_0.next(arg0_11, arg1_11)
	local var0_11 = arg1_11._next

	if var0_11 ~= arg0_11 then
		return var0_11, var0_11.value
	end

	return nil
end

function var1_0.prev(arg0_12, arg1_12)
	local var0_12 = arg1_12._prev

	if var0_12 ~= arg0_12 then
		return var0_12, var0_12.value
	end

	return nil
end

function var1_0.erase(arg0_13, arg1_13)
	local var0_13 = arg0_13:find(arg1_13)

	if var0_13 then
		arg0_13:remove(var0_13)
	end
end

function var1_0.insert(arg0_14, arg1_14, arg2_14)
	if not arg2_14 then
		return arg0_14:push(arg1_14)
	end

	local var0_14 = {
		_prev = 0,
		_next = 0,
		removed = false,
		value = arg1_14
	}

	if arg2_14._next then
		arg2_14._next._prev = var0_14
		var0_14._next = arg2_14._next
	else
		arg0_14.last = var0_14
	end

	var0_14._prev = arg2_14
	arg2_14._next = var0_14
	arg0_14.length = arg0_14.length + 1

	return var0_14
end

function var1_0.head(arg0_15)
	return arg0_15._next.value
end

function var1_0.tail(arg0_16)
	return arg0_16._prev.value
end

function var1_0.clone(arg0_17)
	local var0_17 = var1_0:new()

	for iter0_17, iter1_17 in var1_0.next, arg0_17, arg0_17 do
		var0_17:push(iter1_17)
	end

	return var0_17
end

function ilist(arg0_18)
	return var1_0.next, arg0_18, arg0_18
end

function rilist(arg0_19)
	return var1_0.prev, arg0_19, arg0_19
end

var0_0(var1_0, {
	__call = var1_0.new
})

return var1_0
