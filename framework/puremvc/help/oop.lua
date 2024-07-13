function string.split(arg0_1, arg1_1)
	arg0_1 = tostring(arg0_1)
	arg1_1 = tostring(arg1_1)

	if arg1_1 == "" then
		return false
	end

	local var0_1 = 0
	local var1_1 = {}

	for iter0_1, iter1_1 in function()
		return string.find(arg0_1, arg1_1, var0_1, true)
	end do
		table.insert(var1_1, string.sub(arg0_1, var0_1, iter0_1 - 1))

		var0_1 = iter1_1 + 1
	end

	table.insert(var1_1, string.sub(arg0_1, var0_1))

	return var1_1
end

function import(arg0_3, arg1_3)
	local var0_3
	local var1_3 = arg0_3
	local var2_3 = 1

	while true do
		if string.byte(arg0_3, var2_3) ~= 46 then
			var1_3 = string.sub(arg0_3, var2_3)

			if var0_3 and #var0_3 > 0 then
				var1_3 = table.concat(var0_3, ".") .. "." .. var1_3
			end

			break
		end

		var2_3 = var2_3 + 1

		if not var0_3 then
			if not arg1_3 then
				local var3_3, var4_3 = debug.getlocal(3, 1)

				arg1_3 = var4_3
			end

			var0_3 = string.split(arg1_3, ".")
		end

		table.remove(var0_3, #var0_3)
	end

	return require(var1_3)
end
