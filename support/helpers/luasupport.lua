local var0 = print

function originalPrint(...)
	if IsUnityEditor then
		var0(debug.traceback(printEx(...), 2))
	else
		var0(printEx(...))
	end
end

if IsUnityEditor then
	function print(...)
		var0(debug.traceback(printEx(...), 2))
	end
else
	function print()
		return
	end
end

local var1 = setmetatable({}, {
	__mode = "kv"
})
local var2 = getmetatable(GameObject)
local var3 = var2.__index

function var2.__index(arg0, arg1)
	if arg1 == "transform" then
		local var0 = var1[arg0]

		if var0 then
			return var0
		end

		local var1 = var3(arg0, arg1)

		var1[arg0] = var1

		return var1
	elseif arg1 == "gameObject" then
		return arg0
	else
		return var3(arg0, arg1)
	end
end

local var4 = setmetatable({}, {
	__mode = "kv"
})
local var5 = getmetatable(Transform)
local var6 = var5.__index

function var5.__index(arg0, arg1)
	if arg1 == "gameObject" then
		local var0 = var4[arg0]

		if var0 then
			return var0
		end

		local var1 = var6(arg0, arg1)

		var4[arg0] = var1

		return var1
	elseif arg1 == "transform" then
		return arg0
	else
		return var6(arg0, arg1)
	end
end

function gcAll(arg0)
	PoolMgr.GetInstance():ExcessPainting()
	ResourceMgr.Inst:unloadUnusedAssetBundles()
	GCThread.GetInstance():GC(arg0)
end

function RemoveTableItem(arg0, arg1, arg2)
	local var0 = 0

	for iter0 = 1, #arg0 do
		if arg0[iter0 - var0] == arg1 then
			table.remove(arg0, iter0 - var0)

			if arg2 then
				var0 = var0 + 1
			else
				break
			end
		end
	end
end

function IsNil(arg0)
	return arg0 == nil or arg0:Equals(nil)
end

function isnan(arg0)
	return arg0 ~= arg0
end

function GetDir(arg0)
	return string.match(arg0, ".*/")
end

function GetFileName(arg0)
	return string.match(arg0, ".*/(.*)")
end

function DumpTable(arg0)
	for iter0, iter1 in pairs(arg0) do
		if iter1 ~= nil then
			Debugger.Log("Key: {0}, Value: {1}", tostring(iter0), tostring(iter1))
		else
			Debugger.Log("Key: {0}, Value nil", tostring(iter0))
		end
	end
end

function PrintTable(arg0)
	local var0 = {}

	local function var1(arg0, arg1, arg2)
		for iter0, iter1 in pairs(arg0) do
			if type(iter1) == "table" then
				table.insert(arg1, arg2 .. tostring(iter0) .. ":\n")
				var1(iter1, arg1, arg2 .. " ")
			else
				table.insert(arg1, arg2 .. tostring(iter0) .. ": " .. tostring(iter1) .. "\n")
			end
		end
	end

	var1(arg0, var0, "")

	return table.concat(var0, "")
end

function PrintLua(arg0, arg1)
	local var0

	arg1 = arg1 or _G

	for iter0 in string.gmatch(arg0, "%w+") do
		arg1 = arg1[iter0]
	end

	local var1 = arg1

	if var1 == nil then
		Debugger.Log("Lua Module {0} not exists", arg0)

		return
	end

	Debugger.Log("-----------------Dump Table {0}-----------------", arg0)

	if type(var1) == "table" then
		for iter1, iter2 in pairs(var1) do
			Debugger.Log("Key: {0}, Value: {1}", iter1, tostring(iter2))
		end
	end

	local var2 = getmetatable(var1)

	Debugger.Log("-----------------Dump meta {0}-----------------", arg0)

	while var2 ~= nil and var2 ~= var1 do
		for iter3, iter4 in pairs(var2) do
			if iter3 ~= nil then
				Debugger.Log("Key: {0}, Value: {1}", tostring(iter3), tostring(iter4))
			end
		end

		var2 = getmetatable(var2)
	end

	Debugger.Log("-----------------Dump meta Over-----------------")
	Debugger.Log("-----------------Dump Table Over-----------------")
end

function IsString(arg0)
	return type(arg0) == "string"
end

function IsNumber(arg0)
	return type(arg0) == "number"
end

function tobool(arg0)
	return arg0 and true or false
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

function BuildVector3(arg0)
	return Vector3(arg0[1], arg0[2], arg0[3])
end

function ShowFuncInfo(arg0)
	local var0 = debug.getinfo(arg0)

	return string.format("file:%s#%d", var0.source, var0.linedefined)
end

function String2Table(arg0)
	local var0 = {}

	for iter0 in arg0:gmatch(".") do
		table.insert(var0, iter0)
	end

	return var0
end

local var7 = require("bit")

function unicode_to_utf8(arg0)
	if type(arg0) ~= "string" then
		return arg0
	end

	local var0 = ""
	local var1 = 1

	while true do
		local var2 = string.byte(arg0, var1)
		local var3

		if var2 ~= nil and string.sub(arg0, var1, var1 + 1) == "\\u" then
			var3 = tonumber("0x" .. string.sub(arg0, var1 + 2, var1 + 5))
			var1 = var1 + 6
		elseif var2 ~= nil then
			var3 = var2
			var1 = var1 + 1
		else
			break
		end

		if var3 <= 127 then
			var0 = var0 .. string.char(var7.band(var3, 127))
		elseif var3 >= 128 and var3 <= 2047 then
			var0 = var0 .. string.char(var7.bor(192, var7.band(var7.rshift(var3, 6), 31)))
			var0 = var0 .. string.char(var7.bor(128, var7.band(var3, 63)))
		elseif var3 >= 2048 and var3 <= 65535 then
			var0 = var0 .. string.char(var7.bor(224, var7.band(var7.rshift(var3, 12), 15)))
			var0 = var0 .. string.char(var7.bor(128, var7.band(var7.rshift(var3, 6), 63)))
			var0 = var0 .. string.char(var7.bor(128, var7.band(var3, 63)))
		end
	end

	return var0 .. "\x00"
end

function utf8_to_unicode(arg0)
	if type(arg0) ~= "string" then
		return arg0
	end

	local var0 = ""
	local var1 = 1
	local var2 = string.byte(arg0, var1)
	local var3 = 0

	while var2 ~= nil do
		local var4
		local var5

		if var2 >= 0 and var2 <= 127 then
			var4 = var2
			var5 = 0
		elseif var7.band(var2, 224) == 192 then
			local var6 = 0
			local var7 = 0
			local var8 = var7.band(var2, var7.rshift(255, 3))

			var1 = var1 + 1
			var2 = string.byte(arg0, var1)

			local var9 = var7.band(var2, var7.rshift(255, 2))

			var4 = var7.bor(var9, var7.lshift(var7.band(var8, var7.rshift(255, 6)), 6))
			var5 = var7.rshift(var8, 2)
		elseif var7.band(var2, 240) == 224 then
			local var10 = 0
			local var11 = 0
			local var12 = 0
			local var13 = var7.band(var2, var7.rshift(255, 3))

			var1 = var1 + 1
			var2 = string.byte(arg0, var1)

			local var14 = var7.band(var2, var7.rshift(255, 2))

			var1 = var1 + 1
			var2 = string.byte(arg0, var1)

			local var15 = var7.band(var2, var7.rshift(255, 2))

			var4 = var7.bor(var7.lshift(var7.band(var14, var7.rshift(255, 6)), 6), var15)
			var5 = var7.bor(var7.lshift(var13, 4), var7.rshift(var14, 2))
		end

		var0 = var0 .. string.format("\\u%02x%02x", var5, var4)

		if var5 == 0 then
			var3 = var3 + 1
		else
			var3 = var3 + 2
		end

		var1 = var1 + 1
		var2 = string.byte(arg0, var1)
	end

	return var0, var3
end

function utf8_size(arg0)
	if not arg0 then
		return 0
	elseif arg0 > 240 then
		return 4
	elseif arg0 > 225 then
		return 3
	elseif arg0 > 192 then
		return 2
	else
		return 1
	end
end

function utf8_len(arg0)
	local var0 = 1
	local var1 = 0
	local var2 = #arg0

	while var0 <= var2 do
		local var3 = string.byte(arg0, var0)

		var0 = var0 + utf8_size(var3)
		var1 = var1 + 1
	end

	return var1
end

function existCall(arg0, ...)
	if arg0 and type(arg0) == "function" then
		return arg0(...)
	end
end

function packEx(...)
	return {
		len = select("#", ...),
		...
	}
end

function unpackEx(arg0)
	return unpack(arg0, 1, arg0.len)
end

function printEx(...)
	local var0 = packEx(...)

	for iter0 = 1, var0.len do
		var0[iter0] = tostring(var0[iter0])
	end

	return table.concat(var0, " ")
end

function envFunc(arg0, arg1, ...)
	assert(type(arg0) == "table")

	local var0 = getfenv(arg1)

	warning(var0 == _G)
	setfenv(arg1, setmetatable({}, {
		__index = function(arg0, arg1)
			if arg0[arg1] ~= nil then
				return arg0[arg1]
			else
				return var0[arg1]
			end
		end,
		__newindex = function(arg0, arg1, arg2)
			arg0[arg1] = arg2
		end
	}))

	local var1 = packEx(arg1(...))

	setfenv(arg1, var0)

	return unpackEx(var1)
end
