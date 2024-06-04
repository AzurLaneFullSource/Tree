local var0 = {
	next_raw = function(arg0, arg1)
		if not arg1 then
			if #arg0 == 0 then
				return nil
			end

			return 1, true
		end

		if arg1 > #arg0 then
			return
		end

		local var0 = arg0:byte(arg1)

		if var0 >= 0 and var0 <= 127 then
			arg1 = arg1 + 1
		elseif var0 >= 194 and var0 <= 223 then
			arg1 = arg1 + 2
		elseif var0 >= 224 and var0 <= 239 then
			arg1 = arg1 + 3
		elseif var0 >= 240 and var0 <= 244 then
			arg1 = arg1 + 4
		else
			return arg1 + 1, false
		end

		if arg1 > #arg0 then
			return
		end

		return arg1, true
	end
}

var0.next = var0.next_raw

function var0.byte_indices(arg0, arg1)
	return var0.next, arg0, arg1
end

function var0.len(arg0)
	assert(arg0, "bad argument #1 to 'len' (string expected, got nil)")

	local var0 = 0

	for iter0 in var0.byte_indices(arg0) do
		var0 = var0 + 1
	end

	return var0
end

function var0.byte_index(arg0, arg1)
	if arg1 < 1 then
		return
	end

	local var0 = 0

	for iter0 in var0.byte_indices(arg0) do
		var0 = var0 + 1

		if var0 == arg1 then
			return iter0
		end
	end

	assert(var0 < arg1, "invalid index")
end

function var0.char_index(arg0, arg1)
	if arg1 < 1 or arg1 > #arg0 then
		return
	end

	local var0 = 0

	for iter0 in var0.byte_indices(arg0) do
		var0 = var0 + 1

		if iter0 == arg1 then
			return var0
		end
	end

	error("invalid index")
end

function var0.prev(arg0, arg1)
	arg1 = arg1 or #arg0 + 1

	if arg1 <= 1 or arg1 > #arg0 + 1 then
		return
	end

	local var0, var1 = var0.next(arg0)

	for iter0, iter1 in var0.byte_indices(arg0) do
		if iter0 == arg1 then
			return var0, var1
		end

		var0, var1 = iter0, iter1
	end

	if arg1 == #arg0 + 1 then
		return var0, var1
	end

	error("invalid index")
end

function var0.byte_indices_reverse(arg0, arg1)
	if #arg0 < 200 then
		return var0.prev, arg0, arg1
	else
		local var0 = {}

		for iter0 in var0.byte_indices(arg0) do
			if arg1 and arg1 <= iter0 then
				break
			end

			table.insert(var0, iter0)
		end

		local var1 = #var0 + 1

		return function()
			var1 = var1 - 1

			return var0[var1]
		end
	end
end

function var0.sub(arg0, arg1, arg2)
	assert(arg1 >= 1)
	assert(not arg2 or arg2 >= 0)

	local var0 = 0
	local var1
	local var2

	for iter0 in var0.byte_indices(arg0) do
		var0 = var0 + 1

		if var0 == arg1 then
			var1 = iter0
		end

		if var0 == arg2 then
			var2 = iter0
		end
	end

	if not var1 then
		assert(var0 < arg1, "invalid index")

		return ""
	end

	if arg2 and not var2 then
		if arg2 < arg1 then
			return ""
		end

		assert(var0 < arg2, "invalid index")
	end

	return arg0:sub(var1, var2 and var2 - 1)
end

function var0.contains(arg0, arg1, arg2)
	if arg1 < 1 or arg1 > #arg0 then
		return nil
	end

	for iter0 = 1, #arg2 do
		if arg0:byte(arg1 + iter0 - 1) ~= arg2:byte(iter0) then
			return false
		end
	end

	return true
end

function var0.count(arg0, arg1)
	assert(#arg1 > 0)

	local var0 = 0
	local var1 = 1

	while var1 do
		if var0.contains(arg0, var1, arg1) then
			var0 = var0 + 1
			var1 = var1 + #arg1

			if var1 > #arg0 then
				break
			end
		else
			var1 = var0.next(arg0, var1)
		end
	end

	return var0
end

function var0.isvalid(arg0, arg1)
	local var0 = arg0:byte(arg1)

	if not var0 then
		return false
	elseif var0 >= 0 and var0 <= 127 then
		return true
	elseif var0 >= 194 and var0 <= 223 then
		local var1 = arg0:byte(arg1 + 1)

		return var1 and var1 >= 128 and var1 <= 191
	elseif var0 >= 224 and var0 <= 239 then
		local var2 = arg0:byte(arg1 + 1)
		local var3 = arg0:byte(arg1 + 2)

		if var0 == 224 then
			return var2 and var3 and var2 >= 160 and var2 <= 191 and var3 >= 128 and var3 <= 191
		elseif var0 >= 225 and var0 <= 236 then
			return var2 and var3 and var2 >= 128 and var2 <= 191 and var3 >= 128 and var3 <= 191
		elseif var0 == 237 then
			return var2 and var3 and var2 >= 128 and var2 <= 159 and var3 >= 128 and var3 <= 191
		elseif var0 >= 238 and var0 <= 239 then
			if var0 == 239 and var2 == 191 and (var3 == 190 or var3 == 191) then
				return false
			end

			return var2 and var3 and var2 >= 128 and var2 <= 191 and var3 >= 128 and var3 <= 191
		end
	elseif var0 >= 240 and var0 <= 244 then
		local var4 = arg0:byte(arg1 + 1)
		local var5 = arg0:byte(arg1 + 2)
		local var6 = arg0:byte(arg1 + 3)

		if var0 == 240 then
			return var4 and var5 and var6 and var4 >= 144 and var4 <= 191 and var5 >= 128 and var5 <= 191 and var6 >= 128 and var6 <= 191
		elseif var0 >= 241 and var0 <= 243 then
			return var4 and var5 and var6 and var4 >= 128 and var4 <= 191 and var5 >= 128 and var5 <= 191 and var6 >= 128 and var6 <= 191
		elseif var0 == 244 then
			return var4 and var5 and var6 and var4 >= 128 and var4 <= 143 and var5 >= 128 and var5 <= 191 and var6 >= 128 and var6 <= 191
		end
	end

	return false
end

function var0.next_valid(arg0, arg1)
	local var0
	local var1

	arg1, var1 = var0.next_raw(arg0, arg1)

	while arg1 and (not var1 or not var0.isvalid(arg0, arg1)) do
		arg1, var1 = var0.next(arg0, arg1)
	end

	return arg1
end

function var0.valid_byte_indices(arg0)
	return var0.next_valid, arg0
end

function var0.validate(arg0)
	for iter0, iter1 in var0.byte_indices(arg0) do
		if not iter1 or not var0.isvalid(arg0, iter0) then
			error(string.format("invalid utf8 char at #%d", iter0))
		end
	end
end

local function var1(arg0, arg1, arg2, arg3)
	return arg3[arg0:sub(arg1, arg2)]
end

function var0.replace(arg0, arg1, ...)
	if type(arg1) == "table" then
		return var0.replace(arg0, var1, arg1)
	end

	if arg0 == "" then
		return arg0
	end

	local var0 = {}
	local var1 = 1

	for iter0 in var0.byte_indices(arg0) do
		local var2 = var0.next(arg0, iter0) or #arg0 + 1
		local var3 = arg1(arg0, iter0, var2 - 1, ...)

		if var3 then
			table.insert(var0, arg0:sub(var1, iter0 - 1))
			table.insert(var0, var3)

			var1 = var2
		end
	end

	table.insert(var0, arg0:sub(var1))

	return table.concat(var0)
end

local function var2(arg0, arg1, arg2, arg3)
	if not var0.isvalid(arg0, arg1) then
		return arg3
	end
end

function var0.sanitize(arg0, arg1)
	arg1 = arg1 or "�"

	return var0.replace(arg0, var2, arg1)
end

return var0
