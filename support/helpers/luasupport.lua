local var0_0 = print

function originalPrint(...)
	if IsUnityEditor then
		var0_0(debug.traceback(printEx(...), 2))
	else
		var0_0(printEx(...))
	end
end

if IsUnityEditor then
	function print(...)
		var0_0(debug.traceback(printEx(...), 2))
	end
else
	function print()
		return
	end
end

local var1_0 = setmetatable({}, {
	__mode = "kv"
})
local var2_0 = getmetatable(GameObject)
local var3_0 = var2_0.__index

function var2_0.__index(arg0_4, arg1_4)
	if arg1_4 == "transform" then
		local var0_4 = var1_0[arg0_4]

		if var0_4 then
			return var0_4
		end

		local var1_4 = var3_0(arg0_4, arg1_4)

		var1_0[arg0_4] = var1_4

		return var1_4
	elseif arg1_4 == "gameObject" then
		return arg0_4
	else
		return var3_0(arg0_4, arg1_4)
	end
end

local var4_0 = setmetatable({}, {
	__mode = "kv"
})
local var5_0 = getmetatable(Transform)
local var6_0 = var5_0.__index

function var5_0.__index(arg0_5, arg1_5)
	if arg1_5 == "gameObject" then
		local var0_5 = var4_0[arg0_5]

		if var0_5 then
			return var0_5
		end

		local var1_5 = var6_0(arg0_5, arg1_5)

		var4_0[arg0_5] = var1_5

		return var1_5
	elseif arg1_5 == "transform" then
		return arg0_5
	else
		return var6_0(arg0_5, arg1_5)
	end
end

function gcAll(arg0_6)
	PoolMgr.GetInstance():ExcessPainting()
	ResourceMgr.Inst:unloadUnusedAssetBundles()
	GCThread.GetInstance():GC(arg0_6)
end

function RemoveTableItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = 0

	for iter0_7 = 1, #arg0_7 do
		if arg0_7[iter0_7 - var0_7] == arg1_7 then
			table.remove(arg0_7, iter0_7 - var0_7)

			if arg2_7 then
				var0_7 = var0_7 + 1
			else
				break
			end
		end
	end
end

function IsNil(arg0_8)
	return arg0_8 == nil or arg0_8:Equals(nil)
end

function isnan(arg0_9)
	return arg0_9 ~= arg0_9
end

function GetDir(arg0_10)
	return string.match(arg0_10, ".*/")
end

function GetFileName(arg0_11)
	return string.match(arg0_11, ".*/(.*)")
end

function DumpTable(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12) do
		if iter1_12 ~= nil then
			Debugger.Log("Key: {0}, Value: {1}", tostring(iter0_12), tostring(iter1_12))
		else
			Debugger.Log("Key: {0}, Value nil", tostring(iter0_12))
		end
	end
end

function PrintTable(arg0_13)
	local var0_13 = {}

	local function var1_13(arg0_14, arg1_14, arg2_14)
		for iter0_14, iter1_14 in pairs(arg0_14) do
			if type(iter1_14) == "table" then
				table.insert(arg1_14, arg2_14 .. tostring(iter0_14) .. ":\n")
				var1_13(iter1_14, arg1_14, arg2_14 .. " ")
			else
				table.insert(arg1_14, arg2_14 .. tostring(iter0_14) .. ": " .. tostring(iter1_14) .. "\n")
			end
		end
	end

	var1_13(arg0_13, var0_13, "")

	return table.concat(var0_13, "")
end

function PrintLua(arg0_15, arg1_15)
	local var0_15

	arg1_15 = arg1_15 or _G

	for iter0_15 in string.gmatch(arg0_15, "%w+") do
		arg1_15 = arg1_15[iter0_15]
	end

	local var1_15 = arg1_15

	if var1_15 == nil then
		Debugger.Log("Lua Module {0} not exists", arg0_15)

		return
	end

	Debugger.Log("-----------------Dump Table {0}-----------------", arg0_15)

	if type(var1_15) == "table" then
		for iter1_15, iter2_15 in pairs(var1_15) do
			Debugger.Log("Key: {0}, Value: {1}", iter1_15, tostring(iter2_15))
		end
	end

	local var2_15 = getmetatable(var1_15)

	Debugger.Log("-----------------Dump meta {0}-----------------", arg0_15)

	while var2_15 ~= nil and var2_15 ~= var1_15 do
		for iter3_15, iter4_15 in pairs(var2_15) do
			if iter3_15 ~= nil then
				Debugger.Log("Key: {0}, Value: {1}", tostring(iter3_15), tostring(iter4_15))
			end
		end

		var2_15 = getmetatable(var2_15)
	end

	Debugger.Log("-----------------Dump meta Over-----------------")
	Debugger.Log("-----------------Dump Table Over-----------------")
end

function IsString(arg0_16)
	return type(arg0_16) == "string"
end

function IsNumber(arg0_17)
	return type(arg0_17) == "number"
end

function tobool(arg0_18)
	return arg0_18 and true or false
end

function warning(...)
	if IsUnityEditor then
		Debugger.LogWarning(debug.traceback(printEx(...), 2))
	else
		Debugger.LogWarning(printEx(...))
	end
end

function errorMsg(...)
	if IsUnityEditor then
		Debugger.LogError(debug.traceback(printEx(...)))
	else
		Debugger.LogError(printEx(...))
	end
end

function BuildVector3(arg0_21)
	return Vector3(arg0_21[1], arg0_21[2], arg0_21[3])
end

function ShowFuncInfo(arg0_22)
	local var0_22 = debug.getinfo(arg0_22)

	return string.format("file:%s#%d", var0_22.source, var0_22.linedefined)
end

function String2Table(arg0_23)
	local var0_23 = {}

	for iter0_23 in arg0_23:gmatch(".") do
		table.insert(var0_23, iter0_23)
	end

	return var0_23
end

local var7_0 = require("bit")

function unicode_to_utf8(arg0_24)
	if type(arg0_24) ~= "string" then
		return arg0_24
	end

	local var0_24 = ""
	local var1_24 = 1

	while true do
		local var2_24 = string.byte(arg0_24, var1_24)
		local var3_24

		if var2_24 ~= nil and string.sub(arg0_24, var1_24, var1_24 + 1) == "\\u" then
			var3_24 = tonumber("0x" .. string.sub(arg0_24, var1_24 + 2, var1_24 + 5))
			var1_24 = var1_24 + 6
		elseif var2_24 ~= nil then
			var3_24 = var2_24
			var1_24 = var1_24 + 1
		else
			break
		end

		if var3_24 <= 127 then
			var0_24 = var0_24 .. string.char(var7_0.band(var3_24, 127))
		elseif var3_24 >= 128 and var3_24 <= 2047 then
			var0_24 = var0_24 .. string.char(var7_0.bor(192, var7_0.band(var7_0.rshift(var3_24, 6), 31)))
			var0_24 = var0_24 .. string.char(var7_0.bor(128, var7_0.band(var3_24, 63)))
		elseif var3_24 >= 2048 and var3_24 <= 65535 then
			var0_24 = var0_24 .. string.char(var7_0.bor(224, var7_0.band(var7_0.rshift(var3_24, 12), 15)))
			var0_24 = var0_24 .. string.char(var7_0.bor(128, var7_0.band(var7_0.rshift(var3_24, 6), 63)))
			var0_24 = var0_24 .. string.char(var7_0.bor(128, var7_0.band(var3_24, 63)))
		end
	end

	return var0_24 .. "\x00"
end

function utf8_to_unicode(arg0_25)
	if type(arg0_25) ~= "string" then
		return arg0_25
	end

	local var0_25 = ""
	local var1_25 = 1
	local var2_25 = string.byte(arg0_25, var1_25)
	local var3_25 = 0

	while var2_25 ~= nil do
		local var4_25
		local var5_25

		if var2_25 >= 0 and var2_25 <= 127 then
			var4_25 = var2_25
			var5_25 = 0
		elseif var7_0.band(var2_25, 224) == 192 then
			local var6_25 = 0
			local var7_25 = 0
			local var8_25 = var7_0.band(var2_25, var7_0.rshift(255, 3))

			var1_25 = var1_25 + 1
			var2_25 = string.byte(arg0_25, var1_25)

			local var9_25 = var7_0.band(var2_25, var7_0.rshift(255, 2))

			var4_25 = var7_0.bor(var9_25, var7_0.lshift(var7_0.band(var8_25, var7_0.rshift(255, 6)), 6))
			var5_25 = var7_0.rshift(var8_25, 2)
		elseif var7_0.band(var2_25, 240) == 224 then
			local var10_25 = 0
			local var11_25 = 0
			local var12_25 = 0
			local var13_25 = var7_0.band(var2_25, var7_0.rshift(255, 3))

			var1_25 = var1_25 + 1
			var2_25 = string.byte(arg0_25, var1_25)

			local var14_25 = var7_0.band(var2_25, var7_0.rshift(255, 2))

			var1_25 = var1_25 + 1
			var2_25 = string.byte(arg0_25, var1_25)

			local var15_25 = var7_0.band(var2_25, var7_0.rshift(255, 2))

			var4_25 = var7_0.bor(var7_0.lshift(var7_0.band(var14_25, var7_0.rshift(255, 6)), 6), var15_25)
			var5_25 = var7_0.bor(var7_0.lshift(var13_25, 4), var7_0.rshift(var14_25, 2))
		end

		var0_25 = var0_25 .. string.format("\\u%02x%02x", var5_25, var4_25)

		if var5_25 == 0 then
			var3_25 = var3_25 + 1
		else
			var3_25 = var3_25 + 2
		end

		var1_25 = var1_25 + 1
		var2_25 = string.byte(arg0_25, var1_25)
	end

	return var0_25, var3_25
end

function utf8_size(arg0_26)
	if not arg0_26 then
		return 0
	elseif arg0_26 > 240 then
		return 4
	elseif arg0_26 > 225 then
		return 3
	elseif arg0_26 > 192 then
		return 2
	else
		return 1
	end
end

function utf8_len(arg0_27)
	local var0_27 = 1
	local var1_27 = 0
	local var2_27 = #arg0_27

	while var0_27 <= var2_27 do
		local var3_27 = string.byte(arg0_27, var0_27)

		var0_27 = var0_27 + utf8_size(var3_27)
		var1_27 = var1_27 + 1
	end

	return var1_27
end

function existCall(arg0_28, ...)
	if arg0_28 and type(arg0_28) == "function" then
		return arg0_28(...)
	end
end

function packEx(...)
	return {
		len = select("#", ...),
		...
	}
end

function unpackEx(arg0_30)
	return unpack(arg0_30, 1, arg0_30.len)
end

function printEx(...)
	local var0_31 = packEx(...)

	for iter0_31 = 1, var0_31.len do
		var0_31[iter0_31] = tostring(var0_31[iter0_31])
	end

	return table.concat(var0_31, " ")
end

function envFunc(arg0_32, arg1_32, ...)
	assert(type(arg0_32) == "table")

	local var0_32 = getfenv(arg1_32)

	setfenv(arg1_32, setmetatable({}, {
		__index = function(arg0_33, arg1_33)
			if arg0_32[arg1_33] ~= nil then
				return arg0_32[arg1_33]
			else
				return var0_32[arg1_33]
			end
		end,
		__newindex = function(arg0_34, arg1_34, arg2_34)
			arg0_32[arg1_34] = arg2_34
		end
	}))

	local var1_32 = packEx(arg1_32(...))

	setfenv(arg1_32, var0_32)

	return unpackEx(var1_32)
end
