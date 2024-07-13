local var0_0 = {
	next_raw = function(arg0_1, arg1_1)
		if not arg1_1 then
			if #arg0_1 == 0 then
				return nil
			end

			return 1, true
		end

		if arg1_1 > #arg0_1 then
			return
		end

		local var0_1 = arg0_1:byte(arg1_1)

		if var0_1 >= 0 and var0_1 <= 127 then
			arg1_1 = arg1_1 + 1
		elseif var0_1 >= 194 and var0_1 <= 223 then
			arg1_1 = arg1_1 + 2
		elseif var0_1 >= 224 and var0_1 <= 239 then
			arg1_1 = arg1_1 + 3
		elseif var0_1 >= 240 and var0_1 <= 244 then
			arg1_1 = arg1_1 + 4
		else
			return arg1_1 + 1, false
		end

		if arg1_1 > #arg0_1 then
			return
		end

		return arg1_1, true
	end
}

var0_0.next = var0_0.next_raw

function var0_0.byte_indices(arg0_2, arg1_2)
	return var0_0.next, arg0_2, arg1_2
end

function var0_0.len(arg0_3)
	assert(arg0_3, "bad argument #1 to 'len' (string expected, got nil)")

	local var0_3 = 0

	for iter0_3 in var0_0.byte_indices(arg0_3) do
		var0_3 = var0_3 + 1
	end

	return var0_3
end

function var0_0.byte_index(arg0_4, arg1_4)
	if arg1_4 < 1 then
		return
	end

	local var0_4 = 0

	for iter0_4 in var0_0.byte_indices(arg0_4) do
		var0_4 = var0_4 + 1

		if var0_4 == arg1_4 then
			return iter0_4
		end
	end

	assert(var0_4 < arg1_4, "invalid index")
end

function var0_0.char_index(arg0_5, arg1_5)
	if arg1_5 < 1 or arg1_5 > #arg0_5 then
		return
	end

	local var0_5 = 0

	for iter0_5 in var0_0.byte_indices(arg0_5) do
		var0_5 = var0_5 + 1

		if iter0_5 == arg1_5 then
			return var0_5
		end
	end

	error("invalid index")
end

function var0_0.prev(arg0_6, arg1_6)
	arg1_6 = arg1_6 or #arg0_6 + 1

	if arg1_6 <= 1 or arg1_6 > #arg0_6 + 1 then
		return
	end

	local var0_6, var1_6 = var0_0.next(arg0_6)

	for iter0_6, iter1_6 in var0_0.byte_indices(arg0_6) do
		if iter0_6 == arg1_6 then
			return var0_6, var1_6
		end

		var0_6, var1_6 = iter0_6, iter1_6
	end

	if arg1_6 == #arg0_6 + 1 then
		return var0_6, var1_6
	end

	error("invalid index")
end

function var0_0.byte_indices_reverse(arg0_7, arg1_7)
	if #arg0_7 < 200 then
		return var0_0.prev, arg0_7, arg1_7
	else
		local var0_7 = {}

		for iter0_7 in var0_0.byte_indices(arg0_7) do
			if arg1_7 and arg1_7 <= iter0_7 then
				break
			end

			table.insert(var0_7, iter0_7)
		end

		local var1_7 = #var0_7 + 1

		return function()
			var1_7 = var1_7 - 1

			return var0_7[var1_7]
		end
	end
end

function var0_0.sub(arg0_9, arg1_9, arg2_9)
	assert(arg1_9 >= 1)
	assert(not arg2_9 or arg2_9 >= 0)

	local var0_9 = 0
	local var1_9
	local var2_9

	for iter0_9 in var0_0.byte_indices(arg0_9) do
		var0_9 = var0_9 + 1

		if var0_9 == arg1_9 then
			var1_9 = iter0_9
		end

		if var0_9 == arg2_9 then
			var2_9 = iter0_9
		end
	end

	if not var1_9 then
		assert(var0_9 < arg1_9, "invalid index")

		return ""
	end

	if arg2_9 and not var2_9 then
		if arg2_9 < arg1_9 then
			return ""
		end

		assert(var0_9 < arg2_9, "invalid index")
	end

	return arg0_9:sub(var1_9, var2_9 and var2_9 - 1)
end

function var0_0.contains(arg0_10, arg1_10, arg2_10)
	if arg1_10 < 1 or arg1_10 > #arg0_10 then
		return nil
	end

	for iter0_10 = 1, #arg2_10 do
		if arg0_10:byte(arg1_10 + iter0_10 - 1) ~= arg2_10:byte(iter0_10) then
			return false
		end
	end

	return true
end

function var0_0.count(arg0_11, arg1_11)
	assert(#arg1_11 > 0)

	local var0_11 = 0
	local var1_11 = 1

	while var1_11 do
		if var0_0.contains(arg0_11, var1_11, arg1_11) then
			var0_11 = var0_11 + 1
			var1_11 = var1_11 + #arg1_11

			if var1_11 > #arg0_11 then
				break
			end
		else
			var1_11 = var0_0.next(arg0_11, var1_11)
		end
	end

	return var0_11
end

function var0_0.isvalid(arg0_12, arg1_12)
	local var0_12 = arg0_12:byte(arg1_12)

	if not var0_12 then
		return false
	elseif var0_12 >= 0 and var0_12 <= 127 then
		return true
	elseif var0_12 >= 194 and var0_12 <= 223 then
		local var1_12 = arg0_12:byte(arg1_12 + 1)

		return var1_12 and var1_12 >= 128 and var1_12 <= 191
	elseif var0_12 >= 224 and var0_12 <= 239 then
		local var2_12 = arg0_12:byte(arg1_12 + 1)
		local var3_12 = arg0_12:byte(arg1_12 + 2)

		if var0_12 == 224 then
			return var2_12 and var3_12 and var2_12 >= 160 and var2_12 <= 191 and var3_12 >= 128 and var3_12 <= 191
		elseif var0_12 >= 225 and var0_12 <= 236 then
			return var2_12 and var3_12 and var2_12 >= 128 and var2_12 <= 191 and var3_12 >= 128 and var3_12 <= 191
		elseif var0_12 == 237 then
			return var2_12 and var3_12 and var2_12 >= 128 and var2_12 <= 159 and var3_12 >= 128 and var3_12 <= 191
		elseif var0_12 >= 238 and var0_12 <= 239 then
			if var0_12 == 239 and var2_12 == 191 and (var3_12 == 190 or var3_12 == 191) then
				return false
			end

			return var2_12 and var3_12 and var2_12 >= 128 and var2_12 <= 191 and var3_12 >= 128 and var3_12 <= 191
		end
	elseif var0_12 >= 240 and var0_12 <= 244 then
		local var4_12 = arg0_12:byte(arg1_12 + 1)
		local var5_12 = arg0_12:byte(arg1_12 + 2)
		local var6_12 = arg0_12:byte(arg1_12 + 3)

		if var0_12 == 240 then
			return var4_12 and var5_12 and var6_12 and var4_12 >= 144 and var4_12 <= 191 and var5_12 >= 128 and var5_12 <= 191 and var6_12 >= 128 and var6_12 <= 191
		elseif var0_12 >= 241 and var0_12 <= 243 then
			return var4_12 and var5_12 and var6_12 and var4_12 >= 128 and var4_12 <= 191 and var5_12 >= 128 and var5_12 <= 191 and var6_12 >= 128 and var6_12 <= 191
		elseif var0_12 == 244 then
			return var4_12 and var5_12 and var6_12 and var4_12 >= 128 and var4_12 <= 143 and var5_12 >= 128 and var5_12 <= 191 and var6_12 >= 128 and var6_12 <= 191
		end
	end

	return false
end

function var0_0.next_valid(arg0_13, arg1_13)
	local var0_13
	local var1_13

	arg1_13, var1_13 = var0_0.next_raw(arg0_13, arg1_13)

	while arg1_13 and (not var1_13 or not var0_0.isvalid(arg0_13, arg1_13)) do
		arg1_13, var1_13 = var0_0.next(arg0_13, arg1_13)
	end

	return arg1_13
end

function var0_0.valid_byte_indices(arg0_14)
	return var0_0.next_valid, arg0_14
end

function var0_0.validate(arg0_15)
	for iter0_15, iter1_15 in var0_0.byte_indices(arg0_15) do
		if not iter1_15 or not var0_0.isvalid(arg0_15, iter0_15) then
			error(string.format("invalid utf8 char at #%d", iter0_15))
		end
	end
end

local function var1_0(arg0_16, arg1_16, arg2_16, arg3_16)
	return arg3_16[arg0_16:sub(arg1_16, arg2_16)]
end

function var0_0.replace(arg0_17, arg1_17, ...)
	if type(arg1_17) == "table" then
		return var0_0.replace(arg0_17, var1_0, arg1_17)
	end

	if arg0_17 == "" then
		return arg0_17
	end

	local var0_17 = {}
	local var1_17 = 1

	for iter0_17 in var0_0.byte_indices(arg0_17) do
		local var2_17 = var0_0.next(arg0_17, iter0_17) or #arg0_17 + 1
		local var3_17 = arg1_17(arg0_17, iter0_17, var2_17 - 1, ...)

		if var3_17 then
			table.insert(var0_17, arg0_17:sub(var1_17, iter0_17 - 1))
			table.insert(var0_17, var3_17)

			var1_17 = var2_17
		end
	end

	table.insert(var0_17, arg0_17:sub(var1_17))

	return table.concat(var0_17)
end

local function var2_0(arg0_18, arg1_18, arg2_18, arg3_18)
	if not var0_0.isvalid(arg0_18, arg1_18) then
		return arg3_18
	end
end

function var0_0.sanitize(arg0_19, arg1_19)
	arg1_19 = arg1_19 or "�"

	return var0_0.replace(arg0_19, var2_0, arg1_19)
end

return var0_0
