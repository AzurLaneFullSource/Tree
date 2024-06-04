function string.split(arg0, arg1)
	arg0 = tostring(arg0)
	arg1 = tostring(arg1)

	if arg1 == "" then
		return false
	end

	local var0 = 0
	local var1 = {}

	for iter0, iter1 in function()
		return string.find(arg0, arg1, var0, true)
	end do
		table.insert(var1, string.sub(arg0, var0, iter0 - 1))

		var0 = iter1 + 1
	end

	table.insert(var1, string.sub(arg0, var0))

	return var1
end

function import(arg0, arg1)
	local var0
	local var1 = arg0
	local var2 = 1

	while true do
		if string.byte(arg0, var2) ~= 46 then
			var1 = string.sub(arg0, var2)

			if var0 and #var0 > 0 then
				var1 = table.concat(var0, ".") .. "." .. var1
			end

			break
		end

		var2 = var2 + 1

		if not var0 then
			if not arg1 then
				local var3, var4 = debug.getlocal(3, 1)

				arg1 = var4
			end

			var0 = string.split(arg1, ".")
		end

		table.remove(var0, #var0)
	end

	return require(var1)
end
