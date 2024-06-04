local var0 = require("cjson")

local function var1(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in pairs(arg0) do
		if type(iter0) == "number" then
			if var0 < iter0 then
				var0 = iter0
			end

			var1 = var1 + 1
		else
			return -1
		end
	end

	if var0 > var1 * 2 then
		return -1
	end

	return var0
end

local var2

local function var3(arg0, arg1, arg2)
	local var0
	local var1
	local var2

	if arg1 then
		var0 = "\n" .. arg1
		var1 = var0 .. "  "
		var2 = arg1 .. "  "
	else
		var0, var1, var2 = " ", " ", false
	end

	arg2 = arg2 + 1

	if arg2 > 50 then
		return "Cannot serialise any further: too many nested tables"
	end

	local var3 = var1(arg0)
	local var4 = false
	local var5 = {
		"{" .. var1
	}

	if var3 > 0 then
		for iter0 = 1, var3 do
			if var4 then
				table.insert(var5, "," .. var1)
			end

			table.insert(var5, var2(arg0[iter0], var2, arg2))

			var4 = true
		end
	elseif var3 < 0 then
		for iter1, iter2 in pairs(arg0) do
			if var4 then
				table.insert(var5, "," .. var1)
			end

			table.insert(var5, ("[%s] = %s"):format(var2(iter1, var2, arg2), var2(iter2, var2, arg2)))

			var4 = true
		end
	end

	table.insert(var5, var0 .. "}")

	return table.concat(var5)
end

function var2(arg0, arg1, arg2)
	if arg1 == nil then
		arg1 = ""
	end

	if arg2 == nil then
		arg2 = 0
	end

	if arg0 == var0.null then
		return "json.null"
	elseif type(arg0) == "string" then
		return ("%q"):format(arg0)
	elseif type(arg0) == "nil" or type(arg0) == "number" or type(arg0) == "boolean" then
		return tostring(arg0)
	elseif type(arg0) == "table" then
		return var3(arg0, arg1, arg2)
	else
		return "\"<" .. type(arg0) .. ">\""
	end
end

local function var4(arg0)
	local var0

	if arg0 == nil then
		var0 = io.stdin
	else
		local var1
		local var2

		var0, var2 = io.open(arg0, "rb")

		if var0 == nil then
			error(("Unable to read '%s': %s"):format(arg0, var2))
		end
	end

	local var3 = var0:read("*a")

	if arg0 ~= nil then
		var0:close()
	end

	if var3 == nil then
		error("Failed to read " .. arg0)
	end

	return var3
end

local function var5(arg0, arg1)
	local var0

	if arg0 == nil then
		var0 = io.stdout
	else
		local var1
		local var2

		var0, var2 = io.open(arg0, "wb")

		if var0 == nil then
			error(("Unable to write '%s': %s"):format(arg0, var2))
		end
	end

	var0:write(arg1)

	if arg0 ~= nil then
		var0:close()
	end
end

local function var6(arg0, arg1)
	local var0 = type(arg0)

	if var0 ~= type(arg1) then
		return false
	end

	if var0 == "number" and arg0 ~= arg0 and arg1 ~= arg1 then
		return true
	end

	if var0 ~= "table" then
		return arg0 == arg1
	end

	local var1 = {}

	for iter0, iter1 in pairs(arg0) do
		var1[iter0] = true
	end

	for iter2, iter3 in pairs(arg1) do
		if not var1[iter2] then
			return false
		end

		if not var6(arg0[iter2], arg1[iter2]) then
			return false
		end

		var1[iter2] = nil
	end

	for iter4, iter5 in pairs(var1) do
		return false
	end

	return true
end

local var7 = 0
local var8 = 0

local function var9()
	return var7, var8
end

local function var10(arg0, arg1, arg2, arg3, arg4)
	local function var0(arg0, arg1, arg2)
		local var0 = {
			[true] = ":success",
			[false] = ":error"
		}

		if arg1 ~= nil then
			arg0 = arg0 .. var0[arg1]
		end

		print(("[%s] %s"):format(arg0, var2(arg2, false)))
	end

	local var1 = {
		pcall(arg1, unpack(arg2))
	}
	local var2 = table.remove(var1, 1)
	local var3 = false

	if var2 == arg3 and var6(var1, arg4) then
		var3 = true
		var7 = var7 + 1
	end

	var8 = var8 + 1

	local var4 = {
		[true] = "PASS",
		[false] = "FAIL"
	}

	print(("==> Test [%d] %s: %s"):format(var8, arg0, var4[var3]))
	var0("Input", nil, arg2)

	if not var3 then
		var0("Expected", arg3, arg4)
	end

	var0("Received", var2, var1)
	print()

	return var3, var1
end

local function var11(arg0)
	local function var0(arg0, arg1, arg2)
		if type(arg0) == "string" and #arg0 > 0 then
			print("==> " .. arg0)
		end

		arg1(unpack(arg2 or {}))
		print()
	end

	for iter0, iter1 in ipairs(arg0) do
		if iter1[4] == nil then
			var0(unpack(iter1))
		else
			var10(unpack(iter1))
		end
	end
end

local function var12(arg0, arg1)
	local var0 = arg1 or {}
	local var1

	if _G.setfenv then
		var1 = loadstring(arg0)

		if var1 then
			setfenv(var1, var0)
		end
	else
		var1 = load(arg0, nil, nil, var0)
	end

	if var1 == nil then
		error("Invalid syntax.")
	end

	var1()

	return var0
end

return {
	serialise_value = var2,
	file_load = var4,
	file_save = var5,
	compare_values = var6,
	run_test_summary = var9,
	run_test = var10,
	run_test_group = var11,
	run_script = var12
}
