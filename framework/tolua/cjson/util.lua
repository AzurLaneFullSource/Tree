local var0_0 = require("cjson")

local function var1_0(arg0_1)
	local var0_1 = 0
	local var1_1 = 0

	for iter0_1, iter1_1 in pairs(arg0_1) do
		if type(iter0_1) == "number" then
			if var0_1 < iter0_1 then
				var0_1 = iter0_1
			end

			var1_1 = var1_1 + 1
		else
			return -1
		end
	end

	if var0_1 > var1_1 * 2 then
		return -1
	end

	return var0_1
end

local var2_0

local function var3_0(arg0_2, arg1_2, arg2_2)
	local var0_2
	local var1_2
	local var2_2

	if arg1_2 then
		var0_2 = "\n" .. arg1_2
		var1_2 = var0_2 .. "  "
		var2_2 = arg1_2 .. "  "
	else
		var0_2, var1_2, var2_2 = " ", " ", false
	end

	arg2_2 = arg2_2 + 1

	if arg2_2 > 50 then
		return "Cannot serialise any further: too many nested tables"
	end

	local var3_2 = var1_0(arg0_2)
	local var4_2 = false
	local var5_2 = {
		"{" .. var1_2
	}

	if var3_2 > 0 then
		for iter0_2 = 1, var3_2 do
			if var4_2 then
				table.insert(var5_2, "," .. var1_2)
			end

			table.insert(var5_2, var2_0(arg0_2[iter0_2], var2_2, arg2_2))

			var4_2 = true
		end
	elseif var3_2 < 0 then
		for iter1_2, iter2_2 in pairs(arg0_2) do
			if var4_2 then
				table.insert(var5_2, "," .. var1_2)
			end

			table.insert(var5_2, ("[%s] = %s"):format(var2_0(iter1_2, var2_2, arg2_2), var2_0(iter2_2, var2_2, arg2_2)))

			var4_2 = true
		end
	end

	table.insert(var5_2, var0_2 .. "}")

	return table.concat(var5_2)
end

function var2_0(arg0_3, arg1_3, arg2_3)
	if arg1_3 == nil then
		arg1_3 = ""
	end

	if arg2_3 == nil then
		arg2_3 = 0
	end

	if arg0_3 == var0_0.null then
		return "json.null"
	elseif type(arg0_3) == "string" then
		return ("%q"):format(arg0_3)
	elseif type(arg0_3) == "nil" or type(arg0_3) == "number" or type(arg0_3) == "boolean" then
		return tostring(arg0_3)
	elseif type(arg0_3) == "table" then
		return var3_0(arg0_3, arg1_3, arg2_3)
	else
		return "\"<" .. type(arg0_3) .. ">\""
	end
end

local function var4_0(arg0_4)
	local var0_4

	if arg0_4 == nil then
		var0_4 = io.stdin
	else
		local var1_4
		local var2_4

		var0_4, var2_4 = io.open(arg0_4, "rb")

		if var0_4 == nil then
			error(("Unable to read '%s': %s"):format(arg0_4, var2_4))
		end
	end

	local var3_4 = var0_4:read("*a")

	if arg0_4 ~= nil then
		var0_4:close()
	end

	if var3_4 == nil then
		error("Failed to read " .. arg0_4)
	end

	return var3_4
end

local function var5_0(arg0_5, arg1_5)
	local var0_5

	if arg0_5 == nil then
		var0_5 = io.stdout
	else
		local var1_5
		local var2_5

		var0_5, var2_5 = io.open(arg0_5, "wb")

		if var0_5 == nil then
			error(("Unable to write '%s': %s"):format(arg0_5, var2_5))
		end
	end

	var0_5:write(arg1_5)

	if arg0_5 ~= nil then
		var0_5:close()
	end
end

local function var6_0(arg0_6, arg1_6)
	local var0_6 = type(arg0_6)

	if var0_6 ~= type(arg1_6) then
		return false
	end

	if var0_6 == "number" and arg0_6 ~= arg0_6 and arg1_6 ~= arg1_6 then
		return true
	end

	if var0_6 ~= "table" then
		return arg0_6 == arg1_6
	end

	local var1_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6) do
		var1_6[iter0_6] = true
	end

	for iter2_6, iter3_6 in pairs(arg1_6) do
		if not var1_6[iter2_6] then
			return false
		end

		if not var6_0(arg0_6[iter2_6], arg1_6[iter2_6]) then
			return false
		end

		var1_6[iter2_6] = nil
	end

	for iter4_6, iter5_6 in pairs(var1_6) do
		return false
	end

	return true
end

local var7_0 = 0
local var8_0 = 0

local function var9_0()
	return var7_0, var8_0
end

local function var10_0(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	local function var0_8(arg0_9, arg1_9, arg2_9)
		local var0_9 = {
			[true] = ":success",
			[false] = ":error"
		}

		if arg1_9 ~= nil then
			arg0_9 = arg0_9 .. var0_9[arg1_9]
		end

		print(("[%s] %s"):format(arg0_9, var2_0(arg2_9, false)))
	end

	local var1_8 = {
		pcall(arg1_8, unpack(arg2_8))
	}
	local var2_8 = table.remove(var1_8, 1)
	local var3_8 = false

	if var2_8 == arg3_8 and var6_0(var1_8, arg4_8) then
		var3_8 = true
		var7_0 = var7_0 + 1
	end

	var8_0 = var8_0 + 1

	local var4_8 = {
		[true] = "PASS",
		[false] = "FAIL"
	}

	print(("==> Test [%d] %s: %s"):format(var8_0, arg0_8, var4_8[var3_8]))
	var0_8("Input", nil, arg2_8)

	if not var3_8 then
		var0_8("Expected", arg3_8, arg4_8)
	end

	var0_8("Received", var2_8, var1_8)
	print()

	return var3_8, var1_8
end

local function var11_0(arg0_10)
	local function var0_10(arg0_11, arg1_11, arg2_11)
		if type(arg0_11) == "string" and #arg0_11 > 0 then
			print("==> " .. arg0_11)
		end

		arg1_11(unpack(arg2_11 or {}))
		print()
	end

	for iter0_10, iter1_10 in ipairs(arg0_10) do
		if iter1_10[4] == nil then
			var0_10(unpack(iter1_10))
		else
			var10_0(unpack(iter1_10))
		end
	end
end

local function var12_0(arg0_12, arg1_12)
	local var0_12 = arg1_12 or {}
	local var1_12

	if _G.setfenv then
		var1_12 = loadstring(arg0_12)

		if var1_12 then
			setfenv(var1_12, var0_12)
		end
	else
		var1_12 = load(arg0_12, nil, nil, var0_12)
	end

	if var1_12 == nil then
		error("Invalid syntax.")
	end

	var1_12()

	return var0_12
end

return {
	serialise_value = var2_0,
	file_load = var4_0,
	file_save = var5_0,
	compare_values = var6_0,
	run_test_summary = var9_0,
	run_test = var10_0,
	run_test_group = var11_0,
	run_script = var12_0
}
