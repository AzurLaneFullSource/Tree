function hotfix(arg0_1)
	local var0_1

	if package.loaded[arg0_1] then
		var0_1 = package.loaded[arg0_1]
		package.loaded[arg0_1] = nil
	else
		return
	end

	local var1_1, var2_1 = pcall(require, arg0_1)

	if not var1_1 then
		package.loaded[arg0_1] = var0_1

		assert(false, "<color=red>Reload lua file failed.</color>" .. var2_1)

		return
	end

	local var3_1 = package.loaded[arg0_1]
	local var4_1 = {}

	update_table(var3_1, var0_1, var4_1)

	if type(var0_1) == "table" and var0_1.OnReload ~= nil then
		var0_1:OnReload()
	end

	print("<color=green>Reload succeed : </color>" .. arg0_1)

	package.loaded[arg0_1] = var0_1
end

function update_func(arg0_2, arg1_2)
	local var0_2 = {}

	if type(arg1_2) == "function" then
		for iter0_2 = 1, math.huge do
			local var1_2, var2_2 = debug.getupvalue(arg1_2, iter0_2)

			if not var1_2 then
				break
			end

			var0_2[var1_2] = var2_2
		end
	end

	for iter1_2 = 1, math.huge do
		local var3_2, var4_2 = debug.getupvalue(arg0_2, iter1_2)

		if not var3_2 then
			break
		end

		local var5_2 = var0_2[var3_2]

		if var5_2 then
			debug.setupvalue(arg0_2, iter1_2, var5_2)
		end
	end
end

function update_table(arg0_3, arg1_3, arg2_3)
	if type(arg0_3) ~= "table" or type(arg1_3) ~= "table" then
		return
	end

	for iter0_3, iter1_3 in pairs(arg0_3) do
		local var0_3 = arg1_3[iter0_3]
		local var1_3 = type(iter1_3)

		if var1_3 == "function" then
			update_func(iter1_3, var0_3)

			arg1_3[iter0_3] = iter1_3
		elseif var1_3 == "table" and arg2_3[iter1_3] == nil then
			arg2_3[iter1_3] = true

			update_table(iter1_3, var0_3, arg2_3)
		end
	end

	local var2_3 = debug.getmetatable(arg1_3)
	local var3_3 = debug.getmetatable(arg0_3)

	if type(var2_3) == "table" and type(var3_3) == "table" then
		update_table(var3_3, var2_3, arg2_3)
	end
end
