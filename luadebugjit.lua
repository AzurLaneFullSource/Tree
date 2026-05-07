local var0_0 = debug.sethook
local var1_0
local var2_0
local var3_0 = require
local var4_0
local var5_0

if loadstring then
	var5_0 = loadstring
else
	var5_0 = load
end

local var6_0 = {}
local var7_0

if LuaDebugTool then
	var7_0 = LuaDebugTool
elseif CS and CS.LuaDebugTool then
	var7_0 = CS.LuaDebugTool
end

local var8_0 = var7_0
local var9_0 = var5_0
local var10_0 = debug.getinfo

local function var11_0()
	local var0_1 = _G
	local var1_1 = require("string")
	local var2_1 = require("math")
	local var3_1 = require("socket.core")
	local var4_1 = var3_1

	function var4_1.connect4(arg0_2, arg1_2, arg2_2, arg3_2)
		return var3_1.connect(arg0_2, arg1_2, arg2_2, arg3_2, "inet")
	end

	function var4_1.connect6(arg0_3, arg1_3, arg2_3, arg3_3)
		return var3_1.connect(arg0_3, arg1_3, arg2_3, arg3_3, "inet6")
	end

	if not var4_1.connect then
		function var4_1.connect(arg0_4, arg1_4, arg2_4, arg3_4)
			local var0_4, var1_4 = var3_1.tcp()

			if not var0_4 then
				return nil, var1_4
			end

			if arg2_4 then
				local var2_4, var3_4 = var0_4:bind(arg2_4, arg3_4, -1)

				if not var2_4 then
					return nil, var3_4
				end
			end

			local var4_4, var5_4 = var0_4:connect(arg0_4, arg1_4)

			if not var4_4 then
				return nil, var5_4
			end

			return var0_4
		end
	end

	function var4_1.bind(arg0_5, arg1_5, arg2_5)
		if arg0_5 == "*" then
			arg0_5 = "0.0.0.0"
		end

		local var0_5, var1_5 = var3_1.dns.getaddrinfo(arg0_5)

		if not var0_5 then
			return nil, var1_5
		end

		local var2_5
		local var3_5
		local var4_5 = "no info on address"

		for iter0_5, iter1_5 in var0_1.ipairs(var0_5) do
			if iter1_5.family == "inet" then
				var2_5, var4_5 = var3_1.tcp4()
			else
				var2_5, var4_5 = var3_1.tcp6()
			end

			if not var2_5 then
				return nil, var4_5
			end

			var2_5:setoption("reuseaddr", true)

			local var5_5, var6_5 = var2_5:bind(iter1_5.addr, arg1_5)

			var4_5 = var6_5

			if not var5_5 then
				var2_5:close()
			else
				local var7_5, var8_5 = var2_5:listen(arg2_5)

				var4_5 = var8_5

				if not var7_5 then
					var2_5:close()
				else
					return var2_5
				end
			end
		end

		return nil, var4_5
	end

	var4_1.try = var4_1.newtry()

	function var4_1.choose(arg0_6)
		return function(arg0_7, arg1_7, arg2_7)
			if var0_1.type(arg0_7) ~= "string" then
				arg0_7, arg1_7, arg2_7 = "default", arg0_7, arg1_7
			end

			local var0_7 = arg0_6[arg0_7 or "nil"]

			if not var0_7 then
				var0_1.error("unknown key (" .. var0_1.tostring(arg0_7) .. ")", 3)
			else
				return var0_7(arg1_7, arg2_7)
			end
		end
	end

	local var5_1 = {}
	local var6_1 = {}

	var4_1.sourcet = var5_1
	var4_1.sinkt = var6_1
	var4_1.BLOCKSIZE = 2048
	var6_1["close-when-done"] = function(arg0_8)
		return var0_1.setmetatable({
			getfd = function()
				return arg0_8:getfd()
			end,
			dirty = function()
				return arg0_8:dirty()
			end
		}, {
			__call = function(arg0_11, arg1_11, arg2_11)
				if not arg1_11 then
					arg0_8:close()

					return 1
				else
					return arg0_8:send(arg1_11)
				end
			end
		})
	end
	var6_1["keep-open"] = function(arg0_12)
		return var0_1.setmetatable({
			getfd = function()
				return arg0_12:getfd()
			end,
			dirty = function()
				return arg0_12:dirty()
			end
		}, {
			__call = function(arg0_15, arg1_15, arg2_15)
				if arg1_15 then
					return arg0_12:send(arg1_15)
				else
					return 1
				end
			end
		})
	end
	var6_1.default = var6_1["keep-open"]
	var4_1.sink = var4_1.choose(var6_1)
	var5_1["by-length"] = function(arg0_16, arg1_16)
		return var0_1.setmetatable({
			getfd = function()
				return arg0_16:getfd()
			end,
			dirty = function()
				return arg0_16:dirty()
			end
		}, {
			__call = function()
				if arg1_16 <= 0 then
					return nil
				end

				local var0_19 = var2_1.min(var3_1.BLOCKSIZE, arg1_16)
				local var1_19, var2_19 = arg0_16:receive(var0_19)

				if var2_19 then
					return nil, var2_19
				end

				arg1_16 = arg1_16 - var1_1.len(var1_19)

				return var1_19
			end
		})
	end
	var5_1["until-closed"] = function(arg0_20)
		local var0_20

		return var0_1.setmetatable({
			getfd = function()
				return arg0_20:getfd()
			end,
			dirty = function()
				return arg0_20:dirty()
			end
		}, {
			__call = function()
				if var0_20 then
					return nil
				end

				local var0_23, var1_23, var2_23 = arg0_20:receive(var3_1.BLOCKSIZE)

				if not var1_23 then
					return var0_23
				elseif var1_23 == "closed" then
					arg0_20:close()

					var0_20 = 1

					return var2_23
				else
					return nil, var1_23
				end
			end
		})
	end
	var5_1.default = var5_1["until-closed"]
	var4_1.source = var4_1.choose(var5_1)

	return var4_1
end

local function var12_0()
	local var0_24 = require("math")
	local var1_24 = require("string")
	local var2_24 = require("table")
	local var3_24
	local var4_24 = {}
	local var5_24 = {}

	var4_24.EMPTY_ARRAY = {}
	var4_24.EMPTY_OBJECT = {}

	local var6_24
	local var7_24
	local var8_24
	local var9_24
	local var10_24
	local var11_24
	local var12_24
	local var13_24
	local var14_24
	local var15_24

	function var4_24.encode(arg0_25)
		if arg0_25 == nil then
			return "null"
		end

		local var0_25 = type(arg0_25)

		if var0_25 == "string" then
			return "\"" .. var5_24.encodeString(arg0_25) .. "\""
		end

		if var0_25 == "number" or var0_25 == "boolean" then
			return tostring(arg0_25)
		end

		if var0_25 == "table" then
			local var1_25 = {}
			local var2_25, var3_25 = var14_24(arg0_25)

			if var2_25 then
				for iter0_25 = 1, var3_25 do
					var2_24.insert(var1_25, var4_24.encode(arg0_25[iter0_25]))
				end
			else
				for iter1_25, iter2_25 in pairs(arg0_25) do
					if var15_24(iter1_25) and var15_24(iter2_25) then
						var2_24.insert(var1_25, "\"" .. var5_24.encodeString(iter1_25) .. "\":" .. var4_24.encode(iter2_25))
					end
				end
			end

			if var2_25 then
				return "[" .. var2_24.concat(var1_25, ",") .. "]"
			else
				return "{" .. var2_24.concat(var1_25, ",") .. "}"
			end
		end

		if var0_25 == "function" and arg0_25 == var4_24.null then
			return "null"
		end

		assert(false, "encode attempt to encode unsupported type " .. var0_25 .. ":" .. tostring(arg0_25))
	end

	function var4_24.decode(arg0_26, arg1_26)
		arg1_26 = arg1_26 and arg1_26 or 1
		arg1_26 = var12_24(arg0_26, arg1_26)

		assert(arg1_26 <= var1_24.len(arg0_26), "Unterminated JSON encoded object found at position in [" .. arg0_26 .. "]")

		local var0_26 = var1_24.sub(arg0_26, arg1_26, arg1_26)

		if var0_26 == "{" then
			return var10_24(arg0_26, arg1_26)
		end

		if var0_26 == "[" then
			return var6_24(arg0_26, arg1_26)
		end

		if var1_24.find("+-0123456789.e", var0_26, 1, true) then
			return var9_24(arg0_26, arg1_26)
		end

		if var0_26 == "\"" or var0_26 == "'" then
			return var11_24(arg0_26, arg1_26)
		end

		if var1_24.sub(arg0_26, arg1_26, arg1_26 + 1) == "/*" then
			return var4_24.decode(arg0_26, var7_24(arg0_26, arg1_26))
		end

		return var8_24(arg0_26, arg1_26)
	end

	function var4_24.null()
		return var4_24.null
	end

	function var6_24(arg0_28, arg1_28)
		local var0_28 = {}
		local var1_28 = var1_24.len(arg0_28)

		assert(var1_24.sub(arg0_28, arg1_28, arg1_28) == "[", "decode_scanArray called but array does not start at position " .. arg1_28 .. " in string:\n" .. arg0_28)

		arg1_28 = arg1_28 + 1

		repeat
			arg1_28 = var12_24(arg0_28, arg1_28)

			assert(arg1_28 <= var1_28, "JSON String ended unexpectedly scanning array.")

			local var2_28 = var1_24.sub(arg0_28, arg1_28, arg1_28)

			if var2_28 == "]" then
				return var0_28, arg1_28 + 1
			end

			if var2_28 == "," then
				arg1_28 = var12_24(arg0_28, arg1_28 + 1)
			end

			assert(arg1_28 <= var1_28, "JSON String ended unexpectedly scanning array.")

			var3_24, arg1_28 = var4_24.decode(arg0_28, arg1_28)

			var2_24.insert(var0_28, var3_24)
		until false
	end

	function var7_24(arg0_29, arg1_29)
		assert(var1_24.sub(arg0_29, arg1_29, arg1_29 + 1) == "/*", "decode_scanComment called but comment does not start at position " .. arg1_29)

		local var0_29 = var1_24.find(arg0_29, "*/", arg1_29 + 2)

		assert(var0_29 ~= nil, "Unterminated comment in string at " .. arg1_29)

		return var0_29 + 2
	end

	function var8_24(arg0_30, arg1_30)
		local var0_30 = {
			["true"] = true,
			["false"] = false
		}
		local var1_30 = {
			"true",
			"false",
			"null"
		}

		for iter0_30, iter1_30 in pairs(var1_30) do
			if var1_24.sub(arg0_30, arg1_30, arg1_30 + var1_24.len(iter1_30) - 1) == iter1_30 then
				return var0_30[iter1_30], arg1_30 + var1_24.len(iter1_30)
			end
		end

		assert(nil, "Failed to scan constant from string " .. arg0_30 .. " at starting position " .. arg1_30)
	end

	function var9_24(arg0_31, arg1_31)
		local var0_31 = arg1_31 + 1
		local var1_31 = var1_24.len(arg0_31)
		local var2_31 = "+-0123456789.e"

		while var1_24.find(var2_31, var1_24.sub(arg0_31, var0_31, var0_31), 1, true) and var0_31 <= var1_31 do
			var0_31 = var0_31 + 1
		end

		local var3_31 = "return " .. var1_24.sub(arg0_31, arg1_31, var0_31 - 1)
		local var4_31 = var9_0(var3_31)

		assert(var4_31, "Failed to scan number [ " .. var3_31 .. "] in JSON string at position " .. arg1_31 .. " : " .. var0_31)

		return var4_31(), var0_31
	end

	function var10_24(arg0_32, arg1_32)
		local var0_32 = {}
		local var1_32 = var1_24.len(arg0_32)
		local var2_32
		local var3_32

		assert(var1_24.sub(arg0_32, arg1_32, arg1_32) == "{", "decode_scanObject called but object does not start at position " .. arg1_32 .. " in string:\n" .. arg0_32)

		arg1_32 = arg1_32 + 1

		repeat
			arg1_32 = var12_24(arg0_32, arg1_32)

			assert(arg1_32 <= var1_32, "JSON string ended unexpectedly while scanning object.")

			local var4_32 = var1_24.sub(arg0_32, arg1_32, arg1_32)

			if var4_32 == "}" then
				return var0_32, arg1_32 + 1
			end

			if var4_32 == "," then
				arg1_32 = var12_24(arg0_32, arg1_32 + 1)
			end

			assert(arg1_32 <= var1_32, "JSON string ended unexpectedly scanning object.")

			local var5_32

			var5_32, arg1_32 = var4_24.decode(arg0_32, arg1_32)

			assert(arg1_32 <= var1_32, "JSON string ended unexpectedly searching for value of key " .. var5_32)

			arg1_32 = var12_24(arg0_32, arg1_32)

			assert(arg1_32 <= var1_32, "JSON string ended unexpectedly searching for value of key " .. var5_32)
			assert(var1_24.sub(arg0_32, arg1_32, arg1_32) == ":", "JSON object key-value assignment mal-formed at " .. arg1_32)

			arg1_32 = var12_24(arg0_32, arg1_32 + 1)

			assert(arg1_32 <= var1_32, "JSON string ended unexpectedly searching for value of key " .. var5_32)

			var0_32[var5_32], arg1_32 = var4_24.decode(arg0_32, arg1_32)
		until false
	end

	local var16_24 = {
		["\\n"] = "\n",
		["\\t"] = "\t",
		["\\f"] = "\f",
		["\\r"] = "\r",
		["\\b"] = "\b"
	}

	setmetatable(var16_24, {
		__index = function(arg0_33, arg1_33)
			return var1_24.sub(arg1_33, 2)
		end
	})

	function var11_24(arg0_34, arg1_34)
		assert(arg1_34, "decode_scanString(..) called without start position")

		local var0_34 = var1_24.sub(arg0_34, arg1_34, arg1_34)

		assert(var0_34 == "\"" or var0_34 == "'", "decode_scanString called for a non-string")

		local var1_34 = {}
		local var2_34 = arg1_34
		local var3_34 = arg1_34

		while var1_24.find(arg0_34, var0_34, var3_34 + 1) ~= var3_34 + 1 do
			local var4_34 = var3_34
			local var5_34

			var5_34, var3_34 = var1_24.find(arg0_34, "\\.", var3_34 + 1)

			local var6_34, var7_34 = var1_24.find(arg0_34, var0_34, var4_34 + 1)

			if not var5_34 or var6_34 < var5_34 then
				var5_34, var3_34 = var6_34, var7_34 - 1
			end

			var2_24.insert(var1_34, var1_24.sub(arg0_34, var4_34 + 1, var5_34 - 1))

			if var1_24.sub(arg0_34, var5_34, var3_34) == "\\u" then
				local var8_34 = var1_24.sub(arg0_34, var3_34 + 1, var3_34 + 4)

				var3_34 = var3_34 + 4

				local var9_34 = tonumber(var8_34, 16)

				assert(var9_34, "String decoding failed: bad Unicode escape " .. var8_34 .. " at position " .. var5_34 .. " : " .. var3_34)

				local var10_34

				if var9_34 < 128 then
					var10_34 = var1_24.char(var9_34 % 128)
				elseif var9_34 < 2048 then
					var10_34 = var1_24.char(192 + var0_24.floor(var9_34 / 64) % 32, 128 + var9_34 % 64)
				else
					var10_34 = var1_24.char(224 + var0_24.floor(var9_34 / 4096) % 16, 128 + var0_24.floor(var9_34 / 64) % 64, 128 + var9_34 % 64)
				end

				var2_24.insert(var1_34, var10_34)
			else
				var2_24.insert(var1_34, var16_24[var1_24.sub(arg0_34, var5_34, var3_34)])
			end
		end

		var2_24.insert(var1_34, var1_24.sub(var3_34, var3_34 + 1))
		assert(var1_24.find(arg0_34, var0_34, var3_34 + 1), "String decoding failed: missing closing " .. var0_34 .. " at position " .. var3_34 .. "(for string at position " .. arg1_34 .. ")")

		return var2_24.concat(var1_34, ""), var3_34 + 2
	end

	function var12_24(arg0_35, arg1_35)
		local var0_35 = " \n\r\t"
		local var1_35 = var1_24.len(arg0_35)

		while var1_24.find(var0_35, var1_24.sub(arg0_35, arg1_35, arg1_35), 1, true) and arg1_35 <= var1_35 do
			arg1_35 = arg1_35 + 1
		end

		return arg1_35
	end

	local var17_24 = {
		["\f"] = "\\f",
		["\b"] = "\\b",
		["\\"] = "\\\\",
		["/"] = "\\/",
		["\""] = "\\\"",
		["\n"] = "\\n",
		["\r"] = "\\r",
		["\t"] = "\\t"
	}

	function var5_24.encodeString(arg0_36)
		return tostring(arg0_36):gsub(".", function(arg0_37)
			return var17_24[arg0_37]
		end)
	end

	function var14_24(arg0_38)
		if arg0_38 == var4_24.EMPTY_ARRAY then
			return true, 0
		end

		if arg0_38 == var4_24.EMPTY_OBJECT then
			return false
		end

		local var0_38 = 0

		for iter0_38, iter1_38 in pairs(arg0_38) do
			if type(iter0_38) == "number" and var0_24.floor(iter0_38) == iter0_38 and iter0_38 >= 1 then
				if not var15_24(iter1_38) then
					return false
				end

				var0_38 = var0_24.max(var0_38, iter0_38)
			elseif iter0_38 == "n" then
				if iter1_38 ~= (arg0_38.n or #arg0_38) then
					return false
				end
			elseif var15_24(iter1_38) then
				return false
			end
		end

		return true, var0_38
	end

	function var15_24(arg0_39)
		local var0_39 = type(arg0_39)

		return var0_39 == "string" or var0_39 == "boolean" or var0_39 == "number" or var0_39 == "nil" or var0_39 == "table" or var0_39 == "function" and arg0_39 == var4_24.null
	end

	return var4_24
end

local var13_0 = print
local var14_0
local var15_0
local var16_0 = var12_0()
local var17_0 = {
	StepIn = false,
	Run = true,
	runLineCount = 0,
	StepNext = false,
	isProntToConsole = 1,
	version = "1.0.7",
	isHook = true,
	DebugLuaFie = "",
	isDebugPrint = true,
	StepOut = false,
	hookType = "lrc",
	fileMaps = {},
	breakInfos = {},
	pathCachePaths = {},
	splitFilePaths = {}
}
local var18_0
local var19_0 = coroutine.resume

function coroutine.resume(arg0_40, ...)
	if var17_0.isHook and coroutine.status(arg0_40) ~= "dead" then
		debug.sethook(arg0_40, var18_0, "lrc")
	end

	return var19_0(arg0_40, ...)
end

var17_0.event = {
	C2S_StepOutResponse = 13,
	C2S_NextResponseOver = 9,
	S2C_SetBreakPoints = 1,
	C2S_NextResponse = 8,
	S2C_ReqVar = 5,
	C2S_DebugXpCall = 20,
	C2S_LuaPrint = 14,
	C2S_ReqVar = 6,
	C2S_LoadLuaScript = 18,
	S2C_DebugClose = 21,
	S2C_LoadLuaScript = 16,
	S2C_NextRequest = 7,
	C2S_HITBreakPoint = 4,
	C2S_SetBreakPoints = 2,
	S2C_StepOutRequest = 12,
	S2C_StepInRequest = 10,
	C2S_StepInResponse = 11,
	S2C_RUN = 3,
	C2S_SetSocketName = 17
}

function print(...)
	if var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 3 then
		var13_0(...)
	end

	if (var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 2) and var14_0 then
		local var0_41 = {
			...
		}
		local var1_41 = ""

		if #var0_41 == 0 then
			var0_41 = {
				"nil"
			}
		end

		for iter0_41, iter1_41 in pairs(var0_41) do
			var1_41 = var1_41 .. tostring(iter1_41) .. "\t"
		end

		local var2_41 = {
			event = var17_0.event.C2S_LuaPrint,
			data = {
				type = 1,
				msg = var6_0.encode(var1_41)
			}
		}
		local var3_41 = var16_0.encode(var2_41)

		var14_0:send(var3_41 .. "__debugger_k0204__")
	end
end

function luaIdePrintWarn(...)
	if var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 3 then
		var13_0(...)
	end

	if (var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 2) and var14_0 then
		local var0_42 = {
			...
		}
		local var1_42 = ""

		if #var0_42 == 0 then
			var0_42 = {
				"nil"
			}
		end

		for iter0_42, iter1_42 in pairs(var0_42) do
			var1_42 = var1_42 .. tostring(iter1_42) .. "\t"
		end

		local var2_42 = {
			event = var17_0.event.C2S_LuaPrint,
			data = {
				type = 2,
				msg = var6_0.encode(var1_42)
			}
		}
		local var3_42 = var16_0.encode(var2_42)

		var14_0:send(var3_42 .. "__debugger_k0204__")
	end
end

function luaIdePrintErr(...)
	if var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 3 then
		var13_0(...)
	end

	if (var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 2) and var14_0 then
		local var0_43 = {
			...
		}
		local var1_43 = ""

		if #var0_43 == 0 then
			var0_43 = {
				"nil"
			}
		end

		for iter0_43, iter1_43 in pairs(var0_43) do
			var1_43 = var1_43 .. tostring(iter1_43) .. "\t"
		end

		local var2_43 = {
			event = var17_0.event.C2S_LuaPrint,
			data = {
				type = 3,
				msg = var6_0.encode(var1_43)
			}
		}
		local var3_43 = var16_0.encode(var2_43)

		var14_0:send(var3_43 .. "__debugger_k0204__")
	end
end

local function var20_0(arg0_44, arg1_44)
	local var0_44 = string.find(arg0_44, arg1_44, 1)

	while var0_44 do
		local var1_44 = string.find(arg0_44, arg1_44, var0_44 + 1)

		if not var1_44 then
			break
		else
			var0_44 = var1_44
		end
	end

	return var0_44
end

local function var21_0(arg0_45)
	local var0_45, var1_45 = string.find(arg0_45, "/%.%./")

	if var0_45 then
		local var2_45 = string.sub(arg0_45, 1, var0_45 - 1)
		local var3_45 = var20_0(var2_45, "/")
		local var4_45 = string.sub(var2_45, 1, var3_45 - 1)
		local var5_45 = string.sub(arg0_45, var1_45)

		arg0_45 = var4_45 .. var5_45
		arg0_45 = var21_0(arg0_45)

		return arg0_45
	else
		return arg0_45
	end
end

local function var22_0(arg0_46)
	local var0_46
	local var1_46

	arg0_46 = arg0_46:gsub("\\", "/")
	arg0_46 = arg0_46:gsub("//", "/")
	arg0_46 = arg0_46:gsub("/./", "/")

	if arg0_46:find("@") == 1 then
		arg0_46 = arg0_46:sub(2)
	end

	if arg0_46:find("%./") == 1 then
		arg0_46 = arg0_46:sub(3)
	end

	arg0_46 = var21_0(arg0_46)

	local var2_46 = string.len(arg0_46)
	local var3_46 = {
		".lua",
		".txt.lua",
		".txt",
		".bytes"
	}

	table.sort(var3_46, function(arg0_47, arg1_47)
		return string.len(arg0_47) > string.len(arg1_47)
	end)

	local var4_46 = {}

	for iter0_46, iter1_46 in ipairs(var3_46) do
		table.insert(var4_46, string.len(iter1_46))
	end

	local var5_46 = string.len(arg0_46)

	for iter2_46, iter3_46 in ipairs(var3_46) do
		if string.sub(arg0_46, var5_46 - var4_46[iter2_46] + 1) == iter3_46 then
			arg0_46 = string.sub(arg0_46, 1, var5_46 - var4_46[iter2_46])

			break
		end
	end

	local var6_46 = var20_0(arg0_46, "/")

	if var6_46 then
		var0_46 = string.sub(arg0_46, var6_46 + 1)
		var1_46 = string.sub(arg0_46, 1, var6_46)
		arg0_46 = var1_46 .. var0_46
	else
		local var7_46 = var20_0(arg0_46, "%.")

		if not var7_46 then
			var0_46 = arg0_46
			var1_46 = ""
		else
			var1_46 = string.sub(arg0_46, 1, var7_46)
			var1_46 = var1_46:gsub("%.", "/")
			var0_46 = string.sub(arg0_46, var7_46 + 1)
			arg0_46 = var1_46 .. var0_46
		end
	end

	return arg0_46, var1_46, var0_46
end

local function var23_0(arg0_48, arg1_48)
	arg0_48 = tostring(arg0_48)
	arg1_48 = tostring(arg1_48)

	if arg1_48 == "" then
		return false
	end

	local var0_48 = 0
	local var1_48 = {}

	for iter0_48, iter1_48 in function()
		return string.find(arg0_48, arg1_48, var0_48, true)
	end do
		table.insert(var1_48, string.sub(arg0_48, var0_48, iter0_48 - 1))

		var0_48 = iter1_48 + 1
	end

	table.insert(var1_48, string.sub(arg0_48, var0_48))

	return var1_48
end

local function var24_0(arg0_50)
	arg0_50 = string.gsub(arg0_50, "^[ \t\n\r]+", "")

	return string.gsub(arg0_50, "[ \t\n\r]+$", "")
end

local function var25_0(arg0_51, arg1_51, arg2_51)
	if type(arg2_51) ~= "number" then
		arg2_51 = 3
	end

	local var0_51 = {}
	local var1_51 = {}

	local function var2_51(arg0_52)
		if type(arg0_52) == "string" then
			arg0_52 = "\"" .. arg0_52 .. "\""
		end

		return tostring(arg0_52)
	end

	local var3_51 = var23_0(debug.traceback("", 2), "\n")

	print("dump from: " .. var24_0(var3_51[3]))

	local function var4_51(arg0_53, arg1_53, arg2_53, arg3_53, arg4_53)
		arg1_53 = arg1_53 or "<var>"

		local var0_53 = ""

		if type(arg4_53) == "number" then
			var0_53 = string.rep(" ", arg4_53 - string.len(var2_51(arg1_53)))
		end

		if type(arg0_53) ~= "table" then
			var1_51[#var1_51 + 1] = string.format("%s%s%s = %s", arg2_53, var2_51(arg1_53), var0_53, var2_51(arg0_53))
		elseif var0_51[arg0_53] then
			var1_51[#var1_51 + 1] = string.format("%s%s%s = *REF*", arg2_53, arg1_53, var0_53)
		else
			var0_51[arg0_53] = true

			if arg3_53 > arg2_51 then
				var1_51[#var1_51 + 1] = string.format("%s%s = *MAX NESTING*", arg2_53, arg1_53)
			else
				var1_51[#var1_51 + 1] = string.format("%s%s = {", arg2_53, var2_51(arg1_53))

				local var1_53 = arg2_53 .. "    "
				local var2_53 = {}
				local var3_53 = 0
				local var4_53 = {}

				for iter0_53, iter1_53 in pairs(arg0_53) do
					var2_53[#var2_53 + 1] = iter0_53

					local var5_53 = var2_51(iter0_53)
					local var6_53 = string.len(var5_53)

					if var3_53 < var6_53 then
						var3_53 = var6_53
					end

					var4_53[iter0_53] = iter1_53
				end

				table.sort(var2_53, function(arg0_54, arg1_54)
					if type(arg0_54) == "number" and type(arg1_54) == "number" then
						return arg0_54 < arg1_54
					else
						return tostring(arg0_54) < tostring(arg1_54)
					end
				end)

				for iter2_53, iter3_53 in ipairs(var2_53) do
					var4_51(var4_53[iter3_53], iter3_53, var1_53, arg3_53 + 1, var3_53)
				end

				var1_51[#var1_51 + 1] = string.format("%s}", arg2_53)
			end
		end
	end

	var4_51(arg0_51, arg1_51, "- ", 1)

	for iter0_51, iter1_51 in ipairs(var1_51) do
		print(iter1_51)
	end
end

local function var26_0(arg0_55, arg1_55)
	local var0_55 = type(arg1_55)
	local var1_55 = ""

	if var0_55 ~= "table" then
		var1_55 = tostring(arg1_55)
		var1_55 = var6_0.encode(var1_55)
	elseif var17_0.isFoxGloryProject then
		var1_55 = var6_0.encode("table")
	else
		local var2_55, var3_55 = xpcall(function()
			var1_55 = tostring(arg1_55)
			var1_55 = var6_0.encode(var1_55)
		end, function(arg0_57)
			var1_55 = var6_0.encode("table")
		end)
	end

	return {
		name = arg0_55,
		valueType = var0_55,
		valueStr = var1_55
	}
end

local function var27_0(arg0_58)
	local var0_58 = 1
	local var1_58 = {}

	while true do
		local var2_58, var3_58 = debug.getlocal(arg0_58, var0_58)

		if not var2_58 then
			break
		end

		if var2_58 ~= "(*temporary)" then
			var1_58[var2_58] = var3_58
		end

		var0_58 = var0_58 + 1
	end

	local var4_58 = var10_0(arg0_58, "f").func
	local var5_58 = 1
	local var6_58 = {}

	while var4_58 do
		local var7_58, var8_58 = debug.getupvalue(var4_58, var5_58)

		if not var7_58 then
			break
		end

		if var7_58 == "_ENV" then
			var6_58._ENV_ = var8_58
		else
			var6_58[var7_58] = var8_58
		end

		var5_58 = var5_58 + 1
	end

	return {
		locals = var1_58,
		ups = var6_58
	}
end

local function var28_0(arg0_59, arg1_59)
	local var0_59 = {}
	local var1_59 = {}
	local var2_59 = {}
	local var3_59 = {}
	local var4_59 = 0

	for iter0_59 = arg0_59, 100 do
		local var5_59 = var10_0(iter0_59)
		local var6_59 = true

		if iter0_59 == arg0_59 then
			local var7_59 = var5_59.source

			if var7_59:find(var17_0.DebugLuaFie) then
				return
			end

			if var7_59 == "=[C]" then
				var6_59 = false
			end
		end

		if not var5_59 then
			break
		end

		if var6_59 then
			local var8_59, var9_59, var10_59 = var22_0(var5_59.source)
			local var11_59 = {
				src = var8_59,
				scoreName = var5_59.name,
				currentline = var5_59.currentline,
				linedefined = var5_59.linedefined,
				what = var5_59.what,
				nameWhat = var5_59.namewhat
			}
			local var12_59 = iter0_59
			local var13_59 = var27_0(iter0_59 + 1)

			table.insert(var1_59, var11_59)
			table.insert(var2_59, var13_59)
			table.insert(var3_59, var5_59.func)
		end

		if var5_59.what == "main" then
			break
		end
	end

	local var14_59 = {
		stack = var1_59,
		vars = var2_59,
		funcs = var3_59
	}

	return {
		stack = var14_59.stack,
		vars = var14_59.vars,
		funcs = var14_59.funcs,
		event = arg1_59,
		funcsLength = #var14_59.funcs
	}
end

local var29_0

local function var30_0()
	if not jit then
		if _VERSION then
			print("当前lua版本为: " .. _VERSION .. " 请使用 -----LuaDebug.lua----- 进行调试!")
		else
			print("当前为lua版本,请使用-----LuaDebug.lua-----进行调试!")
		end
	end

	if var15_0 then
		local var0_60, var1_60 = var15_0:receive()

		if var0_60 then
			local var2_60 = var16_0.decode(var0_60)

			if var2_60.event == var17_0.event.S2C_SetBreakPoints then
				var29_0(var2_60.data)
			elseif var2_60.event == var17_0.event.S2C_LoadLuaScript then
				var4_0(var2_60.data, false)
			end
		end
	end
end

local function var31_0(arg0_61)
	if var17_0.splitFilePaths[arg0_61] then
		return var17_0.splitFilePaths[arg0_61]
	end

	local var0_61 = 0
	local var1_61 = {}

	for iter0_61, iter1_61 in function()
		return string.find(arg0_61, "/", var0_61, true)
	end do
		local var2_61 = string.sub(arg0_61, var0_61, iter0_61 - 1)

		table.insert(var1_61, var2_61)

		var0_61 = iter1_61 + 1
	end

	local var3_61 = string.sub(arg0_61, var0_61)

	table.insert(var1_61, var3_61)

	var17_0.splitFilePaths[arg0_61] = var1_61

	return var1_61
end

function var29_0(arg0_63)
	local var0_63 = var17_0.breakInfos

	for iter0_63, iter1_63 in ipairs(arg0_63) do
		iter1_63.fileName = string.lower(iter1_63.fileName)
		iter1_63.serverPath = string.lower(iter1_63.serverPath)

		local var1_63 = var0_63[iter1_63.fileName]

		if not var1_63 then
			var0_63[iter1_63.fileName] = {}
			var1_63 = var0_63[iter1_63.fileName]
		end

		if not iter1_63.breakDatas or #iter1_63.breakDatas == 0 then
			var1_63[iter1_63.serverPath] = nil
		else
			local var2_63 = var1_63[iter1_63.serverPath]

			if not var2_63 then
				var2_63 = {
					pathNames = var31_0(iter1_63.serverPath),
					hitCounts = {}
				}
				var1_63[iter1_63.serverPath] = var2_63
			end

			local var3_63 = {}

			for iter2_63, iter3_63 in ipairs(iter1_63.breakDatas) do
				var3_63[iter3_63.line] = iter3_63

				if iter3_63.hitCondition and iter3_63.hitCondition ~= "" then
					iter3_63.hitCondition = tonumber(iter3_63.hitCondition)
				else
					iter3_63.hitCondition = 0
				end

				if not var2_63.hitCounts[iter3_63.line] then
					var2_63.hitCounts[iter3_63.line] = 0
				end
			end

			var2_63.lines = var3_63

			for iter4_63, iter5_63 in pairs(var2_63.hitCounts) do
				if not var3_63[iter4_63] then
					var2_63.hitCounts[iter4_63] = nil
				end
			end
		end

		local var4_63 = 0

		for iter6_63, iter7_63 in pairs(var1_63) do
			var4_63 = var4_63 + 1
		end

		if var4_63 == 0 then
			var0_63[iter1_63.fileName] = nil
		end
	end

	local var5_63 = false

	for iter8_63, iter9_63 in pairs(var0_63) do
		var5_63 = true

		break
	end

	if var5_63 then
		if not var17_0.isHook then
			debug.sethook(var18_0, "lrc")
		end

		var17_0.isHook = true
	else
		if var17_0.isHook then
			debug.sethook()
		end

		var17_0.isHook = false
	end
end

local function var32_0(arg0_64)
	return var17_0.breakInfos[arg0_64]
end

local var33_0 = "192.168.1.102"
local var34_0 = 7003

local function var35_0(arg0_65, arg1_65, arg2_65)
	local var0_65 = {
		event = arg1_65,
		data = arg2_65
	}
	local var1_65 = var16_0.encode(var0_65)

	arg0_65:send(var1_65 .. "__debugger_k0204__")
end

function debugger_conditionStr(arg0_66, arg1_66, arg2_66)
	local function var0_66()
		local var0_67 = {}
		local var1_67 = arg1_66[1].locals
		local var2_67 = arg1_66[1].ups

		if var2_67 then
			for iter0_67, iter1_67 in pairs(var2_67) do
				var0_67[iter0_67] = iter1_67
			end
		end

		if var1_67 then
			for iter2_67, iter3_67 in pairs(var1_67) do
				var0_67[iter2_67] = iter3_67
			end
		end

		setmetatable(var0_67, {
			__index = _G
		})

		local var3_67 = var9_0("return " .. arg0_66)

		setfenv(var3_67, var0_67)

		return var3_67()
	end

	local var1_66, var2_66 = xpcall(var0_66, function(arg0_68)
		print(arg0_68)
	end)

	if var1_66 and var2_66 then
		arg2_66()
	end
end

function var4_0(arg0_69, arg1_69)
	local function var0_69()
		local var0_70 = arg0_69.luastr

		if arg1_69 then
			local var1_70 = {
				_G = _G
			}
			local var2_70 = arg0_69.frameId + 1
			local var3_70 = var17_0.currentDebuggerData.funcs[var2_70]
			local var4_70 = var17_0.currentDebuggerData.vars[var2_70]
			local var5_70 = var4_70.locals
			local var6_70 = var4_70.ups

			for iter0_70, iter1_70 in pairs(var6_70) do
				var1_70[iter0_70] = iter1_70
			end

			for iter2_70, iter3_70 in pairs(var5_70) do
				var1_70[iter2_70] = iter3_70
			end

			setmetatable(var1_70, {
				__index = _G
			})

			local var7_70 = var9_0(var0_70)

			setfenv(var7_70, var1_70)
			var7_70()
		else
			var9_0(var0_70)()
		end
	end

	local var1_69, var2_69 = xpcall(var0_69, function(arg0_71)
		print(arg0_71)
	end)

	if var1_69 then
		var35_0(var14_0, var17_0.event.C2S_LoadLuaScript, {
			msg = "执行代码成功"
		})

		if arg1_69 then
			var35_0(var14_0, var17_0.event.C2S_HITBreakPoint, var17_0.currentDebuggerData.stack)
		end
	else
		var35_0(var14_0, var17_0.event.C2S_LoadLuaScript, {
			msg = "加载代码失败"
		})
	end
end

local function var36_0(arg0_72)
	arg0_72 = string.lower(arg0_72)

	if var17_0.pathCachePaths[arg0_72] then
		var17_0.currentLineFile = var17_0.pathCachePaths[arg0_72]

		return var17_0.pathCachePaths[arg0_72]
	end

	local var0_72, var1_72, var2_72 = var22_0(arg0_72)

	var17_0.currentLineFile = var0_72
	var17_0.pathCachePaths[arg0_72] = var2_72

	return var2_72
end

local function var37_0(arg0_73, arg1_73)
	local var0_73 = var8_0.getUserDataInfo(arg1_73)
	local var1_73 = {}

	if tolua and tolua.getpeer then
		local var2_73 = tolua.getpeer(arg1_73)

		if var2_73 then
			for iter0_73, iter1_73 in pairs(var2_73) do
				local var3_73 = var26_0(iter0_73, iter1_73)

				table.insert(var1_73, var3_73)
			end
		end
	end

	for iter2_73 = 1, var0_73.Count do
		local var4_73 = var0_73[iter2_73 - 1]
		local var5_73 = {
			csharp = true,
			name = var4_73.name,
			valueType = var4_73.valueType,
			valueStr = var6_0.encode(var4_73.valueStr),
			isValue = var4_73.isValue
		}

		table.insert(var1_73, var5_73)
	end

	return var1_73
end

local function var38_0(arg0_74, arg1_74)
	local var0_74
	local var1_74, var2_74 = xpcall(function()
		local var0_75 = var9_0("return " .. arg1_74)

		setfenv(var0_75, arg0_74)

		var0_74 = var0_75()
	end, function(arg0_76)
		print(arg0_76, "====>")

		var0_74 = nil
	end)

	return var0_74
end

local function var39_0(arg0_77, arg1_77, arg2_77)
	local var0_77 = ""

	for iter0_77 = arg2_77, #arg1_77 do
		local var1_77 = arg1_77[iter0_77]

		if var1_77 == "[metatable]" then
			-- block empty
		elseif iter0_77 == arg2_77 then
			if string.find(var1_77, "%.") then
				if var0_77 == "" then
					iter0_77 = arg2_77 + 1
					arg0_77 = arg0_77[var1_77]
				end

				if iter0_77 >= #arg1_77 then
					return arg2_77, arg0_77
				end

				return var39_0(arg0_77, arg1_77, iter0_77)
			else
				var0_77 = var1_77
			end
		elseif string.find(var1_77, "%[") then
			var0_77 = var0_77 .. var1_77
		elseif type(var1_77) == "string" then
			var0_77 = var0_77 .. "[\"" .. var1_77 .. "\"]"
		else
			var0_77 = var0_77 .. "[" .. var1_77 .. "]"
		end
	end

	local var2_77 = var38_0(arg0_77, var0_77)

	return #arg1_77, var2_77
end

local function var40_0(arg0_78, arg1_78, arg2_78)
	local var0_78 = arg2_78[arg1_78]
	local var1_78 = var8_0.getCSharpValue(arg0_78, var0_78)

	if var1_78 then
		if arg1_78 == #arg2_78 then
			return #arg2_78, var1_78
		else
			local var2_78, var3_78 = var40_0(var1_78, arg1_78 + 1, arg2_78)

			if not var3_78 then
				local var4_78 = {}

				for iter0_78 = var2_78, #arg2_78 do
					table.insert(var4_78, arg2_78[iter0_78])
				end

				local var5_78, var6_78 = debugger_searchVarByKeys(arg0_78, searckKeys, 1)

				return var5_78, var6_78
			else
				return var2_78, var3_78
			end
		end
	else
		return arg1_78, var1_78
	end
end

local function var41_0(arg0_79, arg1_79, arg2_79)
	local var0_79, var1_79 = var39_0(arg0_79, arg2_79, 1)

	if not var8_0 then
		return var0_79, var1_79
	end

	if var1_79 then
		if var0_79 == #arg1_79 then
			return var0_79, var1_79
		else
			local var2_79 = ""
			local var3_79 = #arg1_79
			local var4_79 = var0_79 + 1
			local var5_79, var6_79 = var40_0(var1_79, var4_79, arg1_79)

			return var5_79, var6_79
		end
	else
		local var7_79 = {}

		for iter0_79 = 1, #arg2_79 - 1 do
			table.insert(var7_79, arg1_79[iter0_79])
		end

		if #var7_79 == 0 then
			return #arg1_79, nil
		end

		return var41_0(arg0_79, arg1_79, var7_79)
	end
end

local function var42_0(arg0_80, arg1_80, arg2_80, arg3_80, arg4_80, arg5_80, arg6_80)
	for iter0_80, iter1_80 in ipairs(arg6_80) do
		if arg1_80 == iter1_80 then
			return arg2_80
		end
	end

	table.insert(arg6_80, arg1_80)

	for iter2_80, iter3_80 in pairs(arg1_80) do
		local var0_80

		if type(iter2_80) == "string" then
			xpcall(function()
				var0_80 = arg0_80[iter2_80]
			end, function(arg0_82)
				var0_80 = nil
			end)

			if var0_80 == nil then
				xpcall(function()
					if string.find(iter2_80, "__") then
						var0_80 = iter3_80
					end
				end, function(arg0_84)
					var0_80 = nil
				end)
			end
		end

		if var0_80 then
			local var1_80 = var26_0(iter2_80, var0_80)

			table.insert(arg2_80, var1_80)

			if #arg2_80 > 10 then
				var35_0(arg3_80, var17_0.event.C2S_ReqVar, {
					isComplete = 0,
					variablesReference = arg4_80,
					debugSpeedIndex = arg5_80,
					vars = arg2_80
				})

				arg2_80 = {}
			end
		end
	end

	local var2_80 = getmetatable(arg1_80)

	if var2_80 then
		return var42_0(arg0_80, var2_80, arg2_80, arg3_80, arg4_80, arg5_80, arg6_80)
	else
		return arg2_80
	end
end

local function var43_0(arg0_85, arg1_85, arg2_85, arg3_85, arg4_85, arg5_85)
	if arg5_85 == "userdata" then
		if tolua and tolua.getpeer then
			arg0_85 = tolua.getpeer(arg0_85)
		else
			return arg1_85
		end
	end

	if arg0_85 == nil then
		return arg1_85
	end

	for iter0_85, iter1_85 in pairs(arg0_85) do
		local var0_85 = var26_0(iter0_85, iter1_85)

		table.insert(arg1_85, var0_85)

		if #arg1_85 > 10 then
			var35_0(arg2_85, var17_0.event.C2S_ReqVar, {
				isComplete = 0,
				variablesReference = arg3_85,
				debugSpeedIndex = arg4_85,
				vars = arg1_85
			})

			arg1_85 = {}
		end
	end

	return arg1_85
end

local function var44_0(arg0_86, arg1_86, arg2_86, arg3_86)
	local var0_86 = {}
	local var1_86 = {}
	local var2_86 = type(arg0_86)
	local var3_86 = {}
	local var4_86

	if var2_86 == "userdata" then
		if tolua and tolua.getpeer then
			var4_86 = getmetatable(arg0_86)
			var0_86 = var43_0(arg0_86, var0_86, arg1_86, arg2_86, arg3_86, var2_86)
		end

		if var8_0 then
			local var5_86 = var37_0(arg1_86, arg0_86, arg2_86, arg3_86)

			for iter0_86, iter1_86 in ipairs(var5_86) do
				if iter1_86.valueType == "System.Byte[]" and arg0_86[iter1_86.name] and type(arg0_86[iter1_86.name]) == "string" then
					local var6_86 = {
						valueType = "string",
						name = iter1_86.name,
						valueStr = var6_0.encode(arg0_86[iter1_86.name])
					}

					table.insert(var0_86, var6_86)
				else
					table.insert(var0_86, iter1_86)
				end

				if #var0_86 > 10 then
					var35_0(arg1_86, var17_0.event.C2S_ReqVar, {
						isComplete = 0,
						variablesReference = arg2_86,
						debugSpeedIndex = arg3_86,
						vars = var0_86
					})

					var0_86 = {}
				end
			end

			var4_86 = getmetatable(arg0_86)
		end
	else
		var4_86 = getmetatable(arg0_86)
		var0_86 = var43_0(arg0_86, var0_86, arg1_86, arg2_86, arg3_86, var2_86)
	end

	if var4_86 then
		var0_86 = var42_0(arg0_86, var4_86, var0_86, arg1_86, arg2_86, arg3_86, {})
	end

	var35_0(arg1_86, var17_0.event.C2S_ReqVar, {
		isComplete = 1,
		variablesReference = arg2_86,
		debugSpeedIndex = arg3_86,
		vars = var0_86
	})
end

local function var45_0(arg0_87, arg1_87)
	local var0_87 = arg0_87.variablesReference
	local var1_87 = arg0_87.debugSpeedIndex
	local var2_87 = {}

	local function var3_87()
		local var0_88 = arg0_87.frameId
		local var1_88 = arg0_87.type
		local var2_88 = arg0_87.keys
		local var3_88

		if var1_88 == 1 then
			var3_88 = var17_0.currentDebuggerData.vars[var0_88 + 1]
			var3_88 = var3_88.locals
		elseif var1_88 == 2 then
			var3_88 = var17_0.currentDebuggerData.vars[var0_88 + 1]
			var3_88 = var3_88.ups
		elseif var1_88 == 3 then
			var3_88 = _G
		end

		if #var2_88 == 0 then
			var44_0(var3_88, arg1_87, var0_87, var1_87)

			return
		end

		local var4_88, var5_88 = var41_0(var3_88, var2_88, var2_88)

		if var5_88 then
			local var6_88 = type(var5_88)

			if var6_88 == "table" or var6_88 == "userdata" then
				var44_0(var5_88, arg1_87, var0_87, var1_87)
			else
				if var6_88 == "function" then
					var5_88 = tostring(var5_88)
				end

				var35_0(arg1_87, var17_0.event.C2S_ReqVar, {
					isComplete = 1,
					variablesReference = var0_87,
					debugSpeedIndex = var1_87,
					vars = var6_0.encode(var5_88),
					varType = var6_88
				})
			end
		else
			var35_0(arg1_87, var17_0.event.C2S_ReqVar, {
				isComplete = 1,
				varType = "nil",
				variablesReference = var0_87,
				debugSpeedIndex = var1_87,
				vars = {}
			})
		end
	end

	xpcall(var3_87, function(arg0_89)
		var35_0(arg1_87, var17_0.event.C2S_ReqVar, {
			isComplete = 1,
			variablesReference = var0_87,
			debugSpeedIndex = var1_87,
			vars = {
				{
					isValue = false,
					name = "error",
					valueType = "string",
					valueStr = var6_0.encode("无法获取属性值:" .. arg0_89 .. "->" .. debug.traceback("", 2))
				}
			}
		})
	end)
end

local function var46_0()
	var17_0.Run = false
	var17_0.StepIn = false
	var17_0.StepNext = false
	var17_0.StepOut = false
end

local function var47_0(arg0_91)
	arg0_91 = var14_0

	local var0_91
	local var1_91 = {}
	local var2_91

	while true do
		local var3_91, var4_91 = arg0_91:receive()

		if var4_91 == "closed" then
			debug.sethook()
			coroutine.yield()
		end

		if var3_91 then
			local var5_91 = var16_0.decode(var3_91)
			local var6_91 = var5_91.event
			local var7_91 = var5_91.data

			if var6_91 == var17_0.event.S2C_DebugClose then
				debug.sethook()
				coroutine.yield()
			elseif var6_91 == var17_0.event.S2C_SetBreakPoints then
				local function var8_91()
					var29_0(var7_91)
				end

				xpcall(var8_91, function(arg0_93)
					print(arg0_93)
				end)
			elseif var6_91 == var17_0.event.S2C_RUN then
				var17_0.runTimeType = var7_91.runTimeType
				var17_0.isProntToConsole = var7_91.isProntToConsole
				var17_0.isFoxGloryProject = var7_91.isFoxGloryProject

				var46_0()

				var17_0.currentDebuggerData = nil
				var17_0.Run = true
				var17_0.tempRunFlag = true

				local var9_91 = coroutine.yield()

				var17_0.currentDebuggerData = var9_91

				var35_0(arg0_91, var9_91.event, {
					stack = var9_91.stack
				})
			elseif var6_91 == var17_0.event.S2C_ReqVar then
				var45_0(var7_91, arg0_91)
			elseif var6_91 == var17_0.event.S2C_NextRequest then
				var46_0()

				var17_0.StepNext = true

				local var10_91 = coroutine.yield()

				var17_0.currentDebuggerData = var10_91

				var35_0(arg0_91, var10_91.event, {
					stack = var10_91.stack
				})
			elseif var6_91 == var17_0.event.S2C_StepInRequest then
				var46_0()

				var17_0.StepIn = true

				local var11_91 = coroutine.yield()

				var17_0.currentDebuggerData = var11_91

				var35_0(arg0_91, var11_91.event, {
					stack = var11_91.stack,
					eventType = var11_91.eventType
				})
			elseif var6_91 == var17_0.event.S2C_StepOutRequest then
				var46_0()

				var17_0.StepOut = true

				local var12_91 = coroutine.yield()

				var17_0.currentDebuggerData = var12_91

				var35_0(arg0_91, var12_91.event, {
					stack = var12_91.stack,
					eventType = var12_91.eventType
				})
			elseif var6_91 == var17_0.event.S2C_LoadLuaScript then
				var4_0(var7_91, true)
			end
		end
	end
end

local var48_0 = coroutine.create(var47_0)

function var18_0(arg0_94, arg1_94)
	if not var17_0.isHook then
		return
	end

	if var17_0.Run and arg0_94 == "line" then
		local var0_94 = false

		for iter0_94, iter1_94 in pairs(var17_0.breakInfos) do
			for iter2_94, iter3_94 in pairs(iter1_94) do
				if iter3_94.lines and iter3_94.lines[arg1_94] then
					var0_94 = true

					break
				end
			end

			if var0_94 then
				break
			end
		end

		if not var0_94 then
			return
		end
	end

	local var1_94

	if arg0_94 == "line" then
		local var2_94
		local var3_94 = 0

		if var17_0.currentDebuggerData then
			var2_94 = var17_0.currentDebuggerData.funcs
			var3_94 = #var2_94
		end

		local var4_94 = var10_0(2)
		local var5_94 = var4_94.func
		local var6_94 = var4_94.source
		local var7_94 = var36_0(var6_94)

		if var6_94 == "=[C]" or var6_94:find(var17_0.DebugLuaFie) then
			return
		end

		if var3_94 > 0 and var2_94[1] == var5_94 and var17_0.currentLine ~= arg1_94 then
			var17_0.runLineCount = var17_0.runLineCount + 1
		end

		local var8_94 = var17_0.breakInfos[var7_94]
		local var9_94
		local var10_94 = false

		if var8_94 then
			for iter4_94, iter5_94 in pairs(var8_94) do
				local var11_94 = iter5_94.lines

				if var11_94 and var11_94[arg1_94] then
					var10_94 = true

					break
				end
			end
		end

		local var12_94 = false

		if var10_94 then
			local var13_94 = var4_94
			local var14_94 = string.lower(var13_94.source)
			local var15_94, var16_94, var17_94 = var22_0(var14_94)
			local var18_94 = var31_0(var15_94)
			local var19_94 = {}
			local var20_94

			for iter6_94, iter7_94 in pairs(var8_94) do
				local var21_94 = iter7_94.lines
				local var22_94 = iter7_94.pathNames

				var20_94 = iter7_94.hitCounts

				if var21_94 and var21_94[arg1_94] then
					var9_94 = var21_94[arg1_94]
					var19_94[iter6_94] = 0

					local var23_94 = #var18_94
					local var24_94 = #var22_94

					repeat
						if var22_94[var24_94] ~= var18_94[var23_94] then
							break
						else
							var19_94[iter6_94] = var19_94[iter6_94] + 1
						end

						var24_94 = var24_94 - 1
						var23_94 = var23_94 - 1
					until var24_94 <= 0 or var23_94 <= 0
				else
					var9_94 = nil
				end
			end

			if var9_94 then
				local var25_94 = ""
				local var26_94 = 0

				for iter8_94, iter9_94 in pairs(var19_94) do
					if var26_94 < iter9_94 then
						var26_94 = iter9_94
						var25_94 = iter8_94
					end
				end

				if (#var18_94 == 1 or #var18_94 > 1 and var26_94 > 1) and var25_94 ~= "" then
					local var27_94 = var9_94.hitCondition
					local var28_94 = var20_94[var9_94.line] + 1

					var20_94[var9_94.line] = var28_94

					if var2_94 and var2_94[1] == var5_94 and var17_0.runLineCount == 0 then
						var17_0.runLineCount = 0
					elseif var17_0.tempRunFlag and var17_0.currentLine == arg1_94 then
						var17_0.runLineCount = 0
						var17_0.tempRunFlag = nil
					elseif var27_94 <= var28_94 then
						var12_94 = true
					end
				end
			end
		end

		if var17_0.StepOut then
			if var3_94 == 1 then
				var46_0()

				var17_0.Run = true

				return
			elseif var2_94[2] == var5_94 then
				local var29_94 = var28_0(3, var17_0.event.C2S_StepInResponse)

				var19_0(var48_0, var29_94)

				return
			end
		end

		if var17_0.StepIn then
			if var2_94[1] == var5_94 and var17_0.runLineCount == 0 then
				return
			end

			local var30_94 = var28_0(3, var17_0.event.C2S_StepInResponse)

			var19_0(var48_0, var30_94)

			return
		end

		if var17_0.StepNext then
			local var31_94 = false

			if var2_94 then
				for iter10_94, iter11_94 in ipairs(var2_94) do
					if var5_94 == iter11_94 then
						if var17_0.currentLine == arg1_94 then
							return
						end

						var31_94 = true

						break
					end
				end
			else
				var31_94 = true
			end

			if var31_94 then
				local var32_94 = var28_0(3, var17_0.event.C2S_NextResponse)

				var17_0.runLineCount = 0
				var17_0.currentLine = arg1_94

				var19_0(var48_0, var32_94)

				return
			end
		end

		local var33_94

		if var12_94 then
			var17_0.runLineCount = 0
			var17_0.currentLine = arg1_94

			local var34_94 = var17_0.event.C2S_HITBreakPoint
			local var35_94 = var28_0(3, var34_94)

			if var9_94 and var9_94.condition then
				debugger_conditionStr(var9_94.condition, var35_94.vars, function()
					var19_0(var48_0, var35_94)
				end)
			else
				var19_0(var48_0, var35_94)
			end
		end
	end
end

local function var49_0()
	local var0_96 = var28_0(4, var17_0.event.C2S_HITBreakPoint)

	var19_0(var48_0, var0_96)
end

local function var50_0()
	local var0_97 = var11_0()

	print(var33_0)
	print(var34_0)

	local var1_97, var2_97, var3_97 = var22_0(var10_0(1).source)

	var17_0.DebugLuaFie = var3_97

	local var4_97 = var0_97.connect(var33_0, var34_0)

	var14_0 = var4_97

	if var4_97 then
		var15_0 = var11_0().connect(var33_0, var34_0)

		if var15_0 then
			var15_0:settimeout(0)
			var35_0(var15_0, var17_0.event.C2S_SetSocketName, {
				name = "breakPointSocket"
			})
			var35_0(var4_97, var17_0.event.C2S_SetSocketName, {
				name = "mainSocket",
				version = var17_0.version
			})
			xpcall(function()
				var0_0(var18_0, "lrc")
			end, function(arg0_99)
				print("error:", arg0_99)
			end)

			if not jit then
				if _VERSION then
					print("当前lua版本为: " .. _VERSION .. " 请使用LuaDebug 进行调试!")
				else
					print("当前为lua版本,请使用LuaDebug 进行调试!")
				end
			end

			var19_0(var48_0, var4_97)
		end
	end
end

function StartDebug(arg0_100, arg1_100)
	if not arg0_100 then
		print("error host nil")
	end

	if not arg1_100 then
		print("error prot nil")
	end

	if type(arg0_100) ~= "string" then
		print("error host not string")
	end

	if type(arg1_100) ~= "number" then
		print("error host not number")
	end

	var33_0 = arg0_100
	var34_0 = arg1_100

	xpcall(var50_0, function(arg0_101)
		print(arg0_101)
	end)

	return var30_0, var49_0
end

local var51_0 = string

var6_0.__code = {
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"+",
	"/"
}
var6_0.__decode = {}

for iter0_0, iter1_0 in pairs(var6_0.__code) do
	var6_0.__decode[var51_0.byte(iter1_0, 1)] = iter0_0 - 1
end

function var6_0.encode(arg0_102)
	local var0_102 = var51_0.len(arg0_102)
	local var1_102 = var0_102 % 3
	local var2_102 = var0_102 - var1_102
	local var3_102 = {}
	local var4_102 = 1

	for iter0_102 = 1, var2_102, 3 do
		local var5_102 = var51_0.byte(arg0_102, iter0_102)
		local var6_102 = var51_0.byte(arg0_102, iter0_102 + 1)
		local var7_102 = var51_0.byte(arg0_102, iter0_102 + 2)
		local var8_102 = var5_102 * 65536 + var6_102 * 256 + var7_102

		for iter1_102 = 1, 4 do
			local var9_102 = math.floor(var8_102 / 2^((4 - iter1_102) * 6)) % 64 + 1

			var3_102[var4_102] = var6_0.__code[var9_102]
			var4_102 = var4_102 + 1
		end
	end

	if var1_102 == 1 then
		var6_0.__left1(var3_102, var4_102, arg0_102, var2_102)
	elseif var1_102 == 2 then
		var6_0.__left2(var3_102, var4_102, arg0_102, var2_102)
	end

	return table.concat(var3_102)
end

function var6_0.__left2(arg0_103, arg1_103, arg2_103, arg3_103)
	local var0_103 = var51_0.byte(arg2_103, arg3_103 + 1) * 1024 + var51_0.byte(arg2_103, arg3_103 + 2) * 4
	local var1_103 = math.floor(var0_103 / 4096) % 64 + 1

	arg0_103[arg1_103] = var6_0.__code[var1_103]

	local var2_103 = math.floor(var0_103 / 64) % 64 + 1

	arg0_103[arg1_103 + 1] = var6_0.__code[var2_103]

	local var3_103 = var0_103 % 64 + 1

	arg0_103[arg1_103 + 2] = var6_0.__code[var3_103]
	arg0_103[arg1_103 + 3] = "="
end

function var6_0.__left1(arg0_104, arg1_104, arg2_104, arg3_104)
	local var0_104 = var51_0.byte(arg2_104, arg3_104 + 1) * 16
	local var1_104 = math.floor(var0_104 / 64) % 64 + 1

	arg0_104[arg1_104] = var6_0.__code[var1_104]

	local var2_104 = var0_104 % 64 + 1

	arg0_104[arg1_104 + 1] = var6_0.__code[var2_104]
	arg0_104[arg1_104 + 2] = "="
	arg0_104[arg1_104 + 3] = "="
end

function var6_0.decode(arg0_105)
	local var0_105 = var51_0.len(arg0_105)
	local var1_105 = 0

	if var51_0.sub(arg0_105, var0_105 - 1) == "==" then
		var1_105 = 2
		var0_105 = var0_105 - 4
	elseif var51_0.sub(arg0_105, var0_105) == "=" then
		var1_105 = 1
		var0_105 = var0_105 - 4
	end

	local var2_105 = {}
	local var3_105 = 1
	local var4_105 = var6_0.__decode

	for iter0_105 = 1, var0_105, 4 do
		local var5_105 = var4_105[var51_0.byte(arg0_105, iter0_105)]
		local var6_105 = var4_105[var51_0.byte(arg0_105, iter0_105 + 1)]
		local var7_105 = var4_105[var51_0.byte(arg0_105, iter0_105 + 2)]
		local var8_105 = var4_105[var51_0.byte(arg0_105, iter0_105 + 3)]
		local var9_105 = var5_105 * 262144 + var6_105 * 4096 + var7_105 * 64 + var8_105
		local var10_105 = var51_0.char(var9_105 % 256)
		local var11_105 = math.floor(var9_105 / 256)
		local var12_105 = var51_0.char(var11_105 % 256)
		local var13_105 = math.floor(var11_105 / 256)

		var2_105[var3_105] = var51_0.char(var13_105 % 256)
		var2_105[var3_105 + 1] = var12_105
		var2_105[var3_105 + 2] = var10_105
		var3_105 = var3_105 + 3
	end

	if var1_105 == 1 then
		var6_0.__decodeLeft1(var2_105, var3_105, arg0_105, var0_105)
	elseif var1_105 == 2 then
		var6_0.__decodeLeft2(var2_105, var3_105, arg0_105, var0_105)
	end

	return table.concat(var2_105)
end

function var6_0.__decodeLeft1(arg0_106, arg1_106, arg2_106, arg3_106)
	local var0_106 = var6_0.__decode
	local var1_106 = var0_106[var51_0.byte(arg2_106, arg3_106 + 1)]
	local var2_106 = var0_106[var51_0.byte(arg2_106, arg3_106 + 2)]
	local var3_106 = var0_106[var51_0.byte(arg2_106, arg3_106 + 3)]
	local var4_106 = var1_106 * 4096 + var2_106 * 64 + var3_106
	local var5_106 = math.floor(var4_106 / 1024) % 256
	local var6_106 = math.floor(var4_106 / 4) % 256

	arg0_106[arg1_106] = var51_0.char(var5_106)
	arg0_106[arg1_106 + 1] = var51_0.char(var6_106)
end

function var6_0.__decodeLeft2(arg0_107, arg1_107, arg2_107, arg3_107)
	local var0_107 = var6_0.__decode
	local var1_107 = var0_107[var51_0.byte(arg2_107, arg3_107 + 1)]
	local var2_107 = var0_107[var51_0.byte(arg2_107, arg3_107 + 2)]
	local var3_107 = var1_107 * 64 + var2_107
	local var4_107 = math.floor(var3_107 / 16)

	arg0_107[arg1_107] = var51_0.char(var4_107)
end

return StartDebug
