local var0_0
local var1_0
local var2_0 = require
local var3_0
local var4_0

if loadstring then
	var4_0 = loadstring
else
	var4_0 = load
end

local var5_0 = setfenv or function(arg0_1, arg1_1)
	local var0_1 = 1

	while true do
		local var1_1 = debug.getupvalue(arg0_1, var0_1)

		if var1_1 == "_ENV" then
			debug.upvaluejoin(arg0_1, var0_1, function()
				return arg1_1
			end, 1)

			break
		elseif not var1_1 then
			break
		end

		var0_1 = var0_1 + 1
	end

	return arg0_1
end
local var6_0 = {}
local var7_0

if LuaDebugTool then
	var7_0 = LuaDebugTool
elseif CS and CS.LuaDebugTool then
	var7_0 = CS.LuaDebugTool
end

local var8_0 = var7_0
local var9_0 = var4_0
local var10_0 = debug.getinfo

local function var11_0()
	local var0_3 = _G
	local var1_3 = require("string")
	local var2_3 = require("math")
	local var3_3 = require("socket.core")
	local var4_3 = var3_3

	function var4_3.connect4(arg0_4, arg1_4, arg2_4, arg3_4)
		return var3_3.connect(arg0_4, arg1_4, arg2_4, arg3_4, "inet")
	end

	function var4_3.connect6(arg0_5, arg1_5, arg2_5, arg3_5)
		return var3_3.connect(arg0_5, arg1_5, arg2_5, arg3_5, "inet6")
	end

	if not var4_3.connect then
		function var4_3.connect(arg0_6, arg1_6, arg2_6, arg3_6)
			local var0_6, var1_6 = var3_3.tcp()

			if not var0_6 then
				return nil, var1_6
			end

			if arg2_6 then
				local var2_6, var3_6 = var0_6:bind(arg2_6, arg3_6, -1)

				if not var2_6 then
					return nil, var3_6
				end
			end

			local var4_6, var5_6 = var0_6:connect(arg0_6, arg1_6)

			if not var4_6 then
				return nil, var5_6
			end

			return var0_6
		end
	end

	function var4_3.bind(arg0_7, arg1_7, arg2_7)
		if arg0_7 == "*" then
			arg0_7 = "0.0.0.0"
		end

		local var0_7, var1_7 = var3_3.dns.getaddrinfo(arg0_7)

		if not var0_7 then
			return nil, var1_7
		end

		local var2_7
		local var3_7
		local var4_7 = "no info on address"

		for iter0_7, iter1_7 in var0_3.ipairs(var0_7) do
			if iter1_7.family == "inet" then
				var2_7, var4_7 = var3_3.tcp4()
			else
				var2_7, var4_7 = var3_3.tcp6()
			end

			if not var2_7 then
				return nil, var4_7
			end

			var2_7:setoption("reuseaddr", true)

			local var5_7, var6_7 = var2_7:bind(iter1_7.addr, arg1_7)

			var4_7 = var6_7

			if not var5_7 then
				var2_7:close()
			else
				local var7_7, var8_7 = var2_7:listen(arg2_7)

				var4_7 = var8_7

				if not var7_7 then
					var2_7:close()
				else
					return var2_7
				end
			end
		end

		return nil, var4_7
	end

	var4_3.try = var4_3.newtry()

	function var4_3.choose(arg0_8)
		return function(arg0_9, arg1_9, arg2_9)
			if var0_3.type(arg0_9) ~= "string" then
				arg0_9, arg1_9, arg2_9 = "default", arg0_9, arg1_9
			end

			local var0_9 = arg0_8[arg0_9 or "nil"]

			if not var0_9 then
				var0_3.error("unknown key (" .. var0_3.tostring(arg0_9) .. ")", 3)
			else
				return var0_9(arg1_9, arg2_9)
			end
		end
	end

	local var5_3 = {}
	local var6_3 = {}

	var4_3.sourcet = var5_3
	var4_3.sinkt = var6_3
	var4_3.BLOCKSIZE = 2048
	var6_3["close-when-done"] = function(arg0_10)
		return var0_3.setmetatable({
			getfd = function()
				return arg0_10:getfd()
			end,
			dirty = function()
				return arg0_10:dirty()
			end
		}, {
			__call = function(arg0_13, arg1_13, arg2_13)
				if not arg1_13 then
					arg0_10:close()

					return 1
				else
					return arg0_10:send(arg1_13)
				end
			end
		})
	end
	var6_3["keep-open"] = function(arg0_14)
		return var0_3.setmetatable({
			getfd = function()
				return arg0_14:getfd()
			end,
			dirty = function()
				return arg0_14:dirty()
			end
		}, {
			__call = function(arg0_17, arg1_17, arg2_17)
				if arg1_17 then
					return arg0_14:send(arg1_17)
				else
					return 1
				end
			end
		})
	end
	var6_3.default = var6_3["keep-open"]
	var4_3.sink = var4_3.choose(var6_3)
	var5_3["by-length"] = function(arg0_18, arg1_18)
		return var0_3.setmetatable({
			getfd = function()
				return arg0_18:getfd()
			end,
			dirty = function()
				return arg0_18:dirty()
			end
		}, {
			__call = function()
				if arg1_18 <= 0 then
					return nil
				end

				local var0_21 = var2_3.min(var3_3.BLOCKSIZE, arg1_18)
				local var1_21, var2_21 = arg0_18:receive(var0_21)

				if var2_21 then
					return nil, var2_21
				end

				arg1_18 = arg1_18 - var1_3.len(var1_21)

				return var1_21
			end
		})
	end
	var5_3["until-closed"] = function(arg0_22)
		local var0_22

		return var0_3.setmetatable({
			getfd = function()
				return arg0_22:getfd()
			end,
			dirty = function()
				return arg0_22:dirty()
			end
		}, {
			__call = function()
				if var0_22 then
					return nil
				end

				local var0_25, var1_25, var2_25 = arg0_22:receive(var3_3.BLOCKSIZE)

				if not var1_25 then
					return var0_25
				elseif var1_25 == "closed" then
					arg0_22:close()

					var0_22 = 1

					return var2_25
				else
					return nil, var1_25
				end
			end
		})
	end
	var5_3.default = var5_3["until-closed"]
	var4_3.source = var4_3.choose(var5_3)

	return var4_3
end

local function var12_0()
	local var0_26 = require("math")
	local var1_26 = require("string")
	local var2_26 = require("table")
	local var3_26
	local var4_26 = {}
	local var5_26 = {}

	var4_26.EMPTY_ARRAY = {}
	var4_26.EMPTY_OBJECT = {}

	local var6_26
	local var7_26
	local var8_26
	local var9_26
	local var10_26
	local var11_26
	local var12_26
	local var13_26
	local var14_26
	local var15_26

	function var4_26.encode(arg0_27)
		if arg0_27 == nil then
			return "null"
		end

		local var0_27 = type(arg0_27)

		if var0_27 == "string" then
			return "\"" .. var5_26.encodeString(arg0_27) .. "\""
		end

		if var0_27 == "number" or var0_27 == "boolean" then
			return tostring(arg0_27)
		end

		if var0_27 == "table" then
			local var1_27 = {}
			local var2_27, var3_27 = var14_26(arg0_27)

			if var2_27 then
				for iter0_27 = 1, var3_27 do
					var2_26.insert(var1_27, var4_26.encode(arg0_27[iter0_27]))
				end
			else
				for iter1_27, iter2_27 in pairs(arg0_27) do
					if var15_26(iter1_27) and var15_26(iter2_27) then
						var2_26.insert(var1_27, "\"" .. var5_26.encodeString(iter1_27) .. "\":" .. var4_26.encode(iter2_27))
					end
				end
			end

			if var2_27 then
				return "[" .. var2_26.concat(var1_27, ",") .. "]"
			else
				return "{" .. var2_26.concat(var1_27, ",") .. "}"
			end
		end

		if var0_27 == "function" and arg0_27 == var4_26.null then
			return "null"
		end

		assert(false, "encode attempt to encode unsupported type " .. var0_27 .. ":" .. tostring(arg0_27))
	end

	function var4_26.decode(arg0_28, arg1_28)
		arg1_28 = arg1_28 and arg1_28 or 1
		arg1_28 = var12_26(arg0_28, arg1_28)

		assert(arg1_28 <= var1_26.len(arg0_28), "Unterminated JSON encoded object found at position in [" .. arg0_28 .. "]")

		local var0_28 = var1_26.sub(arg0_28, arg1_28, arg1_28)

		if var0_28 == "{" then
			return var10_26(arg0_28, arg1_28)
		end

		if var0_28 == "[" then
			return var6_26(arg0_28, arg1_28)
		end

		if var1_26.find("+-0123456789.e", var0_28, 1, true) then
			return var9_26(arg0_28, arg1_28)
		end

		if var0_28 == "\"" or var0_28 == "'" then
			return var11_26(arg0_28, arg1_28)
		end

		if var1_26.sub(arg0_28, arg1_28, arg1_28 + 1) == "/*" then
			return var4_26.decode(arg0_28, var7_26(arg0_28, arg1_28))
		end

		return var8_26(arg0_28, arg1_28)
	end

	function var4_26.null()
		return var4_26.null
	end

	function var6_26(arg0_30, arg1_30)
		local var0_30 = {}
		local var1_30 = var1_26.len(arg0_30)

		assert(var1_26.sub(arg0_30, arg1_30, arg1_30) == "[", "decode_scanArray called but array does not start at position " .. arg1_30 .. " in string:\n" .. arg0_30)

		arg1_30 = arg1_30 + 1

		repeat
			arg1_30 = var12_26(arg0_30, arg1_30)

			assert(arg1_30 <= var1_30, "JSON String ended unexpectedly scanning array.")

			local var2_30 = var1_26.sub(arg0_30, arg1_30, arg1_30)

			if var2_30 == "]" then
				return var0_30, arg1_30 + 1
			end

			if var2_30 == "," then
				arg1_30 = var12_26(arg0_30, arg1_30 + 1)
			end

			assert(arg1_30 <= var1_30, "JSON String ended unexpectedly scanning array.")

			var3_26, arg1_30 = var4_26.decode(arg0_30, arg1_30)

			var2_26.insert(var0_30, var3_26)
		until false
	end

	function var7_26(arg0_31, arg1_31)
		assert(var1_26.sub(arg0_31, arg1_31, arg1_31 + 1) == "/*", "decode_scanComment called but comment does not start at position " .. arg1_31)

		local var0_31 = var1_26.find(arg0_31, "*/", arg1_31 + 2)

		assert(var0_31 ~= nil, "Unterminated comment in string at " .. arg1_31)

		return var0_31 + 2
	end

	function var8_26(arg0_32, arg1_32)
		local var0_32 = {
			["true"] = true,
			["false"] = false
		}
		local var1_32 = {
			"true",
			"false",
			"null"
		}

		for iter0_32, iter1_32 in pairs(var1_32) do
			if var1_26.sub(arg0_32, arg1_32, arg1_32 + var1_26.len(iter1_32) - 1) == iter1_32 then
				return var0_32[iter1_32], arg1_32 + var1_26.len(iter1_32)
			end
		end

		assert(nil, "Failed to scan constant from string " .. arg0_32 .. " at starting position " .. arg1_32)
	end

	function var9_26(arg0_33, arg1_33)
		local var0_33 = arg1_33 + 1
		local var1_33 = var1_26.len(arg0_33)
		local var2_33 = "+-0123456789.e"

		while var1_26.find(var2_33, var1_26.sub(arg0_33, var0_33, var0_33), 1, true) and var0_33 <= var1_33 do
			var0_33 = var0_33 + 1
		end

		local var3_33 = "return " .. var1_26.sub(arg0_33, arg1_33, var0_33 - 1)
		local var4_33 = var9_0(var3_33)

		assert(var4_33, "Failed to scan number [ " .. var3_33 .. "] in JSON string at position " .. arg1_33 .. " : " .. var0_33)

		return var4_33(), var0_33
	end

	function var10_26(arg0_34, arg1_34)
		local var0_34 = {}
		local var1_34 = var1_26.len(arg0_34)
		local var2_34
		local var3_34

		assert(var1_26.sub(arg0_34, arg1_34, arg1_34) == "{", "decode_scanObject called but object does not start at position " .. arg1_34 .. " in string:\n" .. arg0_34)

		arg1_34 = arg1_34 + 1

		repeat
			arg1_34 = var12_26(arg0_34, arg1_34)

			assert(arg1_34 <= var1_34, "JSON string ended unexpectedly while scanning object.")

			local var4_34 = var1_26.sub(arg0_34, arg1_34, arg1_34)

			if var4_34 == "}" then
				return var0_34, arg1_34 + 1
			end

			if var4_34 == "," then
				arg1_34 = var12_26(arg0_34, arg1_34 + 1)
			end

			assert(arg1_34 <= var1_34, "JSON string ended unexpectedly scanning object.")

			local var5_34

			var5_34, arg1_34 = var4_26.decode(arg0_34, arg1_34)

			assert(arg1_34 <= var1_34, "JSON string ended unexpectedly searching for value of key " .. var5_34)

			arg1_34 = var12_26(arg0_34, arg1_34)

			assert(arg1_34 <= var1_34, "JSON string ended unexpectedly searching for value of key " .. var5_34)
			assert(var1_26.sub(arg0_34, arg1_34, arg1_34) == ":", "JSON object key-value assignment mal-formed at " .. arg1_34)

			arg1_34 = var12_26(arg0_34, arg1_34 + 1)

			assert(arg1_34 <= var1_34, "JSON string ended unexpectedly searching for value of key " .. var5_34)

			var0_34[var5_34], arg1_34 = var4_26.decode(arg0_34, arg1_34)
		until false
	end

	local var16_26 = {
		["\\n"] = "\n",
		["\\t"] = "\t",
		["\\f"] = "\f",
		["\\r"] = "\r",
		["\\b"] = "\b"
	}

	setmetatable(var16_26, {
		__index = function(arg0_35, arg1_35)
			return var1_26.sub(arg1_35, 2)
		end
	})

	function var11_26(arg0_36, arg1_36)
		assert(arg1_36, "decode_scanString(..) called without start position")

		local var0_36 = var1_26.sub(arg0_36, arg1_36, arg1_36)

		assert(var0_36 == "\"" or var0_36 == "'", "decode_scanString called for a non-string")

		local var1_36 = {}
		local var2_36 = arg1_36
		local var3_36 = arg1_36

		while var1_26.find(arg0_36, var0_36, var3_36 + 1) ~= var3_36 + 1 do
			local var4_36 = var3_36
			local var5_36

			var5_36, var3_36 = var1_26.find(arg0_36, "\\.", var3_36 + 1)

			local var6_36, var7_36 = var1_26.find(arg0_36, var0_36, var4_36 + 1)

			if not var5_36 or var6_36 < var5_36 then
				var5_36, var3_36 = var6_36, var7_36 - 1
			end

			var2_26.insert(var1_36, var1_26.sub(arg0_36, var4_36 + 1, var5_36 - 1))

			if var1_26.sub(arg0_36, var5_36, var3_36) == "\\u" then
				local var8_36 = var1_26.sub(arg0_36, var3_36 + 1, var3_36 + 4)

				var3_36 = var3_36 + 4

				local var9_36 = tonumber(var8_36, 16)

				assert(var9_36, "String decoding failed: bad Unicode escape " .. var8_36 .. " at position " .. var5_36 .. " : " .. var3_36)

				local var10_36

				if var9_36 < 128 then
					var10_36 = var1_26.char(var9_36 % 128)
				elseif var9_36 < 2048 then
					var10_36 = var1_26.char(192 + var0_26.floor(var9_36 / 64) % 32, 128 + var9_36 % 64)
				else
					var10_36 = var1_26.char(224 + var0_26.floor(var9_36 / 4096) % 16, 128 + var0_26.floor(var9_36 / 64) % 64, 128 + var9_36 % 64)
				end

				var2_26.insert(var1_36, var10_36)
			else
				var2_26.insert(var1_36, var16_26[var1_26.sub(arg0_36, var5_36, var3_36)])
			end
		end

		var2_26.insert(var1_36, var1_26.sub(var3_36, var3_36 + 1))
		assert(var1_26.find(arg0_36, var0_36, var3_36 + 1), "String decoding failed: missing closing " .. var0_36 .. " at position " .. var3_36 .. "(for string at position " .. arg1_36 .. ")")

		return var2_26.concat(var1_36, ""), var3_36 + 2
	end

	function var12_26(arg0_37, arg1_37)
		local var0_37 = " \n\r\t"
		local var1_37 = var1_26.len(arg0_37)

		while var1_26.find(var0_37, var1_26.sub(arg0_37, arg1_37, arg1_37), 1, true) and arg1_37 <= var1_37 do
			arg1_37 = arg1_37 + 1
		end

		return arg1_37
	end

	local var17_26 = {
		["\f"] = "\\f",
		["\b"] = "\\b",
		["\\"] = "\\\\",
		["/"] = "\\/",
		["\""] = "\\\"",
		["\n"] = "\\n",
		["\r"] = "\\r",
		["\t"] = "\\t"
	}

	function var5_26.encodeString(arg0_38)
		return tostring(arg0_38):gsub(".", function(arg0_39)
			return var17_26[arg0_39]
		end)
	end

	function var14_26(arg0_40)
		if arg0_40 == var4_26.EMPTY_ARRAY then
			return true, 0
		end

		if arg0_40 == var4_26.EMPTY_OBJECT then
			return false
		end

		local var0_40 = 0

		for iter0_40, iter1_40 in pairs(arg0_40) do
			if type(iter0_40) == "number" and var0_26.floor(iter0_40) == iter0_40 and iter0_40 >= 1 then
				if not var15_26(iter1_40) then
					return false
				end

				var0_40 = var0_26.max(var0_40, iter0_40)
			elseif iter0_40 == "n" then
				if iter1_40 ~= (arg0_40.n or #arg0_40) then
					return false
				end
			elseif var15_26(iter1_40) then
				return false
			end
		end

		return true, var0_40
	end

	function var15_26(arg0_41)
		local var0_41 = type(arg0_41)

		return var0_41 == "string" or var0_41 == "boolean" or var0_41 == "number" or var0_41 == "nil" or var0_41 == "table" or var0_41 == "function" and arg0_41 == var4_26.null
	end

	return var4_26
end

local var13_0 = print
local var14_0
local var15_0
local var16_0 = var12_0()
local var17_0 = {
	StepIn = false,
	StepNext = false,
	isHook = true,
	isDebugPrint = true,
	Run = true,
	StepOut = false,
	currentFileName = "",
	StepInLevel = 0,
	DebugLuaFie = "",
	hookType = "lrc",
	isFoxGloryProject = false,
	StepNextLevel = 0,
	version = "1.0.7",
	isProntToConsole = 1,
	fileMaps = {},
	breakInfos = {},
	pathCachePaths = {},
	splitFilePaths = {}
}
local var18_0
local var19_0 = coroutine.resume

function coroutine.resume(arg0_42, ...)
	if var17_0.isHook and coroutine.status(arg0_42) ~= "dead" then
		debug.sethook(arg0_42, var18_0, "lrc")
	end

	return var19_0(arg0_42, ...)
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
				type = 1,
				msg = var6_0.encode(var1_43)
			}
		}
		local var3_43 = var16_0.encode(var2_43)

		var14_0:send(var3_43 .. "__debugger_k0204__")
	end
end

function luaIdePrintWarn(...)
	if var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 3 then
		var13_0(...)
	end

	if (var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 2) and var14_0 then
		local var0_44 = {
			...
		}
		local var1_44 = ""

		if #var0_44 == 0 then
			var0_44 = {
				"nil"
			}
		end

		for iter0_44, iter1_44 in pairs(var0_44) do
			var1_44 = var1_44 .. tostring(iter1_44) .. "\t"
		end

		local var2_44 = {
			event = var17_0.event.C2S_LuaPrint,
			data = {
				type = 2,
				msg = var6_0.encode(var1_44)
			}
		}
		local var3_44 = var16_0.encode(var2_44)

		var14_0:send(var3_44 .. "__debugger_k0204__")
	end
end

function luaIdePrintErr(...)
	if var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 3 then
		var13_0(...)
	end

	if (var17_0.isProntToConsole == 1 or var17_0.isProntToConsole == 2) and var14_0 then
		local var0_45 = {
			...
		}
		local var1_45 = ""

		if #var0_45 == 0 then
			var0_45 = {
				"nil"
			}
		end

		for iter0_45, iter1_45 in pairs(var0_45) do
			var1_45 = var1_45 .. tostring(iter1_45) .. "\t"
		end

		local var2_45 = {
			event = var17_0.event.C2S_LuaPrint,
			data = {
				type = 3,
				msg = var6_0.encode(var1_45)
			}
		}
		local var3_45 = var16_0.encode(var2_45)

		var14_0:send(var3_45 .. "__debugger_k0204__")
	end
end

local function var20_0(arg0_46, arg1_46)
	local var0_46 = string.find(arg0_46, arg1_46, 1)

	while var0_46 do
		local var1_46 = string.find(arg0_46, arg1_46, var0_46 + 1)

		if not var1_46 then
			break
		else
			var0_46 = var1_46
		end
	end

	return var0_46
end

local function var21_0(arg0_47)
	local var0_47, var1_47 = string.find(arg0_47, "/%.%./")

	if var0_47 then
		local var2_47 = string.sub(arg0_47, 1, var0_47 - 1)
		local var3_47 = var20_0(var2_47, "/")
		local var4_47 = string.sub(var2_47, 1, var3_47 - 1)
		local var5_47 = string.sub(arg0_47, var1_47)

		arg0_47 = var4_47 .. var5_47
		arg0_47 = var21_0(arg0_47)

		return arg0_47
	else
		return arg0_47
	end
end

local function var22_0(arg0_48)
	local var0_48
	local var1_48

	arg0_48 = arg0_48:gsub("\\", "/")
	arg0_48 = arg0_48:gsub("//", "/")
	arg0_48 = arg0_48:gsub("/./", "/")

	if arg0_48:find("@") == 1 then
		arg0_48 = arg0_48:sub(2)
	end

	if arg0_48:find("%./") == 1 then
		arg0_48 = arg0_48:sub(3)
	end

	arg0_48 = var21_0(arg0_48)

	local var2_48 = string.len(arg0_48)
	local var3_48 = {
		".lua",
		".txt.lua",
		".txt",
		".bytes"
	}

	table.sort(var3_48, function(arg0_49, arg1_49)
		return string.len(arg0_49) > string.len(arg1_49)
	end)

	local var4_48 = {}

	for iter0_48, iter1_48 in ipairs(var3_48) do
		table.insert(var4_48, string.len(iter1_48))
	end

	local var5_48 = string.len(arg0_48)

	for iter2_48, iter3_48 in ipairs(var3_48) do
		if string.sub(arg0_48, var5_48 - var4_48[iter2_48] + 1) == iter3_48 then
			arg0_48 = string.sub(arg0_48, 1, var5_48 - var4_48[iter2_48])

			break
		end
	end

	local var6_48 = var20_0(arg0_48, "/")

	if var6_48 then
		var0_48 = string.sub(arg0_48, var6_48 + 1)
		var1_48 = string.sub(arg0_48, 1, var6_48)
		arg0_48 = var1_48 .. var0_48
	else
		local var7_48 = var20_0(arg0_48, "%.")

		if not var7_48 then
			var0_48 = arg0_48
			var1_48 = ""
		else
			var1_48 = string.sub(arg0_48, 1, var7_48)
			var1_48 = var1_48:gsub("%.", "/")
			var0_48 = string.sub(arg0_48, var7_48 + 1)
			arg0_48 = var1_48 .. var0_48
		end
	end

	return arg0_48, var1_48, var0_48
end

local function var23_0(arg0_50, arg1_50)
	arg0_50 = tostring(arg0_50)
	arg1_50 = tostring(arg1_50)

	if arg1_50 == "" then
		return false
	end

	local var0_50 = 0
	local var1_50 = {}

	for iter0_50, iter1_50 in function()
		return string.find(arg0_50, arg1_50, var0_50, true)
	end do
		table.insert(var1_50, string.sub(arg0_50, var0_50, iter0_50 - 1))

		var0_50 = iter1_50 + 1
	end

	table.insert(var1_50, string.sub(arg0_50, var0_50))

	return var1_50
end

local function var24_0(arg0_52)
	arg0_52 = string.gsub(arg0_52, "^[ \t\n\r]+", "")

	return string.gsub(arg0_52, "[ \t\n\r]+$", "")
end

local function var25_0(arg0_53, arg1_53, arg2_53)
	if type(arg2_53) ~= "number" then
		arg2_53 = 3
	end

	local var0_53 = {}
	local var1_53 = {}

	local function var2_53(arg0_54)
		if type(arg0_54) == "string" then
			arg0_54 = "\"" .. arg0_54 .. "\""
		end

		return tostring(arg0_54)
	end

	local var3_53 = var23_0(debug.traceback("", 2), "\n")

	print("dump from: " .. var24_0(var3_53[3]))

	local function var4_53(arg0_55, arg1_55, arg2_55, arg3_55, arg4_55)
		arg1_55 = arg1_55 or "<var>"

		local var0_55 = ""

		if type(arg4_55) == "number" then
			var0_55 = string.rep(" ", arg4_55 - string.len(var2_53(arg1_55)))
		end

		if type(arg0_55) ~= "table" then
			var1_53[#var1_53 + 1] = string.format("%s%s%s = %s", arg2_55, var2_53(arg1_55), var0_55, var2_53(arg0_55))
		elseif var0_53[arg0_55] then
			var1_53[#var1_53 + 1] = string.format("%s%s%s = *REF*", arg2_55, arg1_55, var0_55)
		else
			var0_53[arg0_55] = true

			if arg3_55 > arg2_53 then
				var1_53[#var1_53 + 1] = string.format("%s%s = *MAX NESTING*", arg2_55, arg1_55)
			else
				var1_53[#var1_53 + 1] = string.format("%s%s = {", arg2_55, var2_53(arg1_55))

				local var1_55 = arg2_55 .. "    "
				local var2_55 = {}
				local var3_55 = 0
				local var4_55 = {}

				for iter0_55, iter1_55 in pairs(arg0_55) do
					var2_55[#var2_55 + 1] = iter0_55

					local var5_55 = var2_53(iter0_55)
					local var6_55 = string.len(var5_55)

					if var3_55 < var6_55 then
						var3_55 = var6_55
					end

					var4_55[iter0_55] = iter1_55
				end

				table.sort(var2_55, function(arg0_56, arg1_56)
					if type(arg0_56) == "number" and type(arg1_56) == "number" then
						return arg0_56 < arg1_56
					else
						return tostring(arg0_56) < tostring(arg1_56)
					end
				end)

				for iter2_55, iter3_55 in ipairs(var2_55) do
					var4_53(var4_55[iter3_55], iter3_55, var1_55, arg3_55 + 1, var3_55)
				end

				var1_53[#var1_53 + 1] = string.format("%s}", arg2_55)
			end
		end
	end

	var4_53(arg0_53, arg1_53, "- ", 1)

	for iter0_53, iter1_53 in ipairs(var1_53) do
		print(iter1_53)
	end
end

local function var26_0(arg0_57, arg1_57)
	local var0_57 = type(arg1_57)
	local var1_57 = ""

	if var0_57 ~= "table" then
		var1_57 = tostring(arg1_57)
		var1_57 = var6_0.encode(var1_57)
	elseif var17_0.isFoxGloryProject then
		var1_57 = var6_0.encode("table")
	else
		local var2_57, var3_57 = xpcall(function()
			var1_57 = tostring(arg1_57)
			var1_57 = var6_0.encode(var1_57)
		end, function(arg0_59)
			var1_57 = var6_0.encode("table")
		end)
	end

	return {
		name = arg0_57,
		valueType = var0_57,
		valueStr = var1_57
	}
end

local function var27_0(arg0_60)
	local var0_60 = 1
	local var1_60 = {}

	while true do
		local var2_60, var3_60 = debug.getlocal(arg0_60, var0_60)

		if not var2_60 then
			break
		end

		if var2_60 ~= "(*temporary)" then
			var1_60[var2_60] = var3_60
		end

		var0_60 = var0_60 + 1
	end

	local var4_60 = var10_0(arg0_60, "f").func
	local var5_60 = 1
	local var6_60 = {}

	while var4_60 do
		local var7_60, var8_60 = debug.getupvalue(var4_60, var5_60)

		if not var7_60 then
			break
		end

		if var7_60 == "_ENV" then
			var6_60._ENV_ = var8_60
		else
			var6_60[var7_60] = var8_60
		end

		var5_60 = var5_60 + 1
	end

	return {
		locals = var1_60,
		ups = var6_60
	}
end

local function var28_0(arg0_61, arg1_61)
	local var0_61 = {}
	local var1_61 = {}
	local var2_61 = {}
	local var3_61 = {}
	local var4_61 = 0

	for iter0_61 = arg0_61, 100 do
		local var5_61 = var10_0(iter0_61)
		local var6_61 = true

		if iter0_61 == arg0_61 then
			local var7_61 = var5_61.source

			if var7_61:find(var17_0.DebugLuaFie) then
				return
			end

			if var7_61 == "=[C]" then
				var6_61 = false
			end
		end

		if not var5_61 then
			break
		end

		if var6_61 then
			local var8_61, var9_61, var10_61 = var22_0(var5_61.source)
			local var11_61 = {
				src = var8_61,
				scoreName = var5_61.name,
				currentline = var5_61.currentline,
				linedefined = var5_61.linedefined,
				what = var5_61.what,
				nameWhat = var5_61.namewhat
			}
			local var12_61 = iter0_61
			local var13_61 = var27_0(iter0_61 + 1)

			table.insert(var1_61, var11_61)
			table.insert(var2_61, var13_61)
			table.insert(var3_61, var5_61.func)
		end

		if var5_61.what == "main" then
			break
		end
	end

	local var14_61 = {
		stack = var1_61,
		vars = var2_61,
		funcs = var3_61
	}
	local var15_61 = {
		stack = var14_61.stack,
		vars = var14_61.vars,
		funcs = var14_61.funcs,
		event = arg1_61,
		funcsLength = #var14_61.funcs
	}

	var17_0.currentTempFunc = var15_61.funcs[1]

	return var15_61
end

local var29_0

local function var30_0()
	if jit and var17_0.debugLuaType ~= "jit" then
		local var0_62 = "当前luajit版本为: " .. jit.version .. " 请使用LuaDebugjit 进行调试!"

		print(var0_62)
	end

	if var15_0 then
		local var1_62, var2_62 = var15_0:receive()

		if var1_62 then
			local var3_62 = var16_0.decode(var1_62)

			if var3_62.event == var17_0.event.S2C_SetBreakPoints then
				var29_0(var3_62.data)
			elseif var3_62.event == var17_0.event.S2C_LoadLuaScript then
				var3_0(var3_62.data, false)
			end
		end
	end
end

local function var31_0(arg0_63)
	if var17_0.splitFilePaths[arg0_63] then
		return var17_0.splitFilePaths[arg0_63]
	end

	local var0_63 = 0
	local var1_63 = {}

	for iter0_63, iter1_63 in function()
		return string.find(arg0_63, "/", var0_63, true)
	end do
		local var2_63 = string.sub(arg0_63, var0_63, iter0_63 - 1)

		table.insert(var1_63, var2_63)

		var0_63 = iter1_63 + 1
	end

	local var3_63 = string.sub(arg0_63, var0_63)

	table.insert(var1_63, var3_63)

	var17_0.splitFilePaths[arg0_63] = var1_63

	return var1_63
end

function var29_0(arg0_65)
	local var0_65 = var17_0.breakInfos

	for iter0_65, iter1_65 in ipairs(arg0_65) do
		iter1_65.fileName = string.lower(iter1_65.fileName)
		iter1_65.serverPath = string.lower(iter1_65.serverPath)

		local var1_65 = var0_65[iter1_65.fileName]

		if not var1_65 then
			var0_65[iter1_65.fileName] = {}
			var1_65 = var0_65[iter1_65.fileName]
		end

		if not iter1_65.breakDatas or #iter1_65.breakDatas == 0 then
			var1_65[iter1_65.serverPath] = nil
		else
			local var2_65 = var1_65[iter1_65.serverPath]

			if not var2_65 then
				var2_65 = {
					pathNames = var31_0(iter1_65.serverPath),
					hitCounts = {}
				}
				var1_65[iter1_65.serverPath] = var2_65
			end

			local var3_65 = {}

			for iter2_65, iter3_65 in ipairs(iter1_65.breakDatas) do
				var3_65[iter3_65.line] = iter3_65

				if iter3_65.hitCondition and iter3_65.hitCondition ~= "" then
					iter3_65.hitCondition = tonumber(iter3_65.hitCondition)
				else
					iter3_65.hitCondition = 0
				end

				if not var2_65.hitCounts[iter3_65.line] then
					var2_65.hitCounts[iter3_65.line] = 0
				end
			end

			var2_65.lines = var3_65

			for iter4_65, iter5_65 in pairs(var2_65.hitCounts) do
				if not var3_65[iter4_65] then
					var2_65.hitCounts[iter4_65] = nil
				end
			end
		end

		local var4_65 = 0

		for iter6_65, iter7_65 in pairs(var1_65) do
			var4_65 = var4_65 + 1
		end

		if var4_65 == 0 then
			var0_65[iter1_65.fileName] = nil
		end
	end

	local var5_65 = false

	for iter8_65, iter9_65 in pairs(var0_65) do
		var5_65 = true

		break
	end

	if var5_65 then
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

local function var32_0(arg0_66)
	return var17_0.breakInfos[arg0_66]
end

local var33_0 = "192.168.1.102"
local var34_0 = 7003

local function var35_0(arg0_67, arg1_67, arg2_67)
	local var0_67 = {
		event = arg1_67,
		data = arg2_67
	}
	local var1_67 = var16_0.encode(var0_67)

	arg0_67:send(var1_67 .. "__debugger_k0204__")
end

function debugger_conditionStr(arg0_68, arg1_68, arg2_68)
	local function var0_68()
		local var0_69 = {}
		local var1_69 = arg1_68[1].locals
		local var2_69 = arg1_68[1].ups

		if var2_69 then
			for iter0_69, iter1_69 in pairs(var2_69) do
				var0_69[iter0_69] = iter1_69
			end
		end

		if var1_69 then
			for iter2_69, iter3_69 in pairs(var1_69) do
				var0_69[iter2_69] = iter3_69
			end
		end

		setmetatable(var0_69, {
			__index = _G
		})

		local var3_69 = var9_0("return " .. arg0_68)

		var5_0(var3_69, var0_69)

		return var3_69()
	end

	local var1_68, var2_68 = xpcall(var0_68, function(arg0_70)
		print(arg0_70)
	end)

	if var1_68 and var2_68 then
		arg2_68()
	end
end

function var3_0(arg0_71, arg1_71)
	local function var0_71()
		local var0_72 = arg0_71.luastr

		if arg1_71 then
			local var1_72 = {
				_G = _G
			}
			local var2_72 = arg0_71.frameId + 1
			local var3_72 = var17_0.currentDebuggerData.funcs[var2_72]
			local var4_72 = var17_0.currentDebuggerData.vars[var2_72]
			local var5_72 = var4_72.locals
			local var6_72 = var4_72.ups

			for iter0_72, iter1_72 in pairs(var6_72) do
				var1_72[iter0_72] = iter1_72
			end

			for iter2_72, iter3_72 in pairs(var5_72) do
				var1_72[iter2_72] = iter3_72
			end

			setmetatable(var1_72, {
				__index = _G
			})

			local var7_72 = var9_0(var0_72)

			var5_0(var7_72, var1_72)
			var7_72()
		else
			var9_0(var0_72)()
		end
	end

	local var1_71, var2_71 = xpcall(var0_71, function(arg0_73)
		print(arg0_73)
	end)

	if var1_71 then
		var35_0(var14_0, var17_0.event.C2S_LoadLuaScript, {
			msg = "执行代码成功"
		})

		if arg1_71 then
			var35_0(var14_0, var17_0.event.C2S_HITBreakPoint, var17_0.currentDebuggerData.stack)
		end
	else
		var35_0(var14_0, var17_0.event.C2S_LoadLuaScript, {
			msg = "加载代码失败"
		})
	end
end

local function var36_0(arg0_74)
	arg0_74 = string.lower(arg0_74)

	if var17_0.pathCachePaths[arg0_74] then
		var17_0.currentLineFile = var17_0.pathCachePaths[arg0_74]

		return var17_0.pathCachePaths[arg0_74]
	end

	local var0_74, var1_74, var2_74 = var22_0(arg0_74)

	var17_0.currentLineFile = var0_74
	var17_0.pathCachePaths[arg0_74] = var2_74

	return var2_74
end

local function var37_0(arg0_75, arg1_75)
	local var0_75 = var8_0.getUserDataInfo(arg1_75)
	local var1_75 = {}

	if tolua and tolua.getpeer then
		local var2_75 = tolua.getpeer(arg1_75)

		if var2_75 then
			for iter0_75, iter1_75 in pairs(var2_75) do
				local var3_75 = var26_0(iter0_75, iter1_75)

				table.insert(var1_75, var3_75)
			end
		end
	end

	for iter2_75 = 1, var0_75.Count do
		local var4_75 = var0_75[iter2_75 - 1]
		local var5_75 = {
			csharp = true,
			name = var4_75.name,
			valueType = var4_75.valueType,
			valueStr = var6_0.encode(var4_75.valueStr),
			isValue = var4_75.isValue
		}

		table.insert(var1_75, var5_75)
	end

	return var1_75
end

local function var38_0(arg0_76, arg1_76)
	local var0_76
	local var1_76, var2_76 = xpcall(function()
		local var0_77 = var9_0("return " .. arg1_76)

		var5_0(var0_77, arg0_76)

		var0_76 = var0_77()
	end, function(arg0_78)
		print(arg0_78, "====>")

		var0_76 = nil
	end)

	return var0_76
end

local function var39_0(arg0_79, arg1_79, arg2_79)
	local var0_79 = ""

	for iter0_79 = arg2_79, #arg1_79 do
		local var1_79 = arg1_79[iter0_79]

		if var1_79 == "[metatable]" then
			-- block empty
		elseif iter0_79 == arg2_79 then
			if string.find(var1_79, "%.") then
				if var0_79 == "" then
					iter0_79 = arg2_79 + 1
					arg0_79 = arg0_79[var1_79]
				end

				if iter0_79 >= #arg1_79 then
					return arg2_79, arg0_79
				end

				return var39_0(arg0_79, arg1_79, iter0_79)
			else
				var0_79 = var1_79
			end
		elseif string.find(var1_79, "%[") then
			var0_79 = var0_79 .. var1_79
		elseif type(var1_79) == "string" then
			var0_79 = var0_79 .. "[\"" .. var1_79 .. "\"]"
		else
			var0_79 = var0_79 .. "[" .. var1_79 .. "]"
		end
	end

	local var2_79 = var38_0(arg0_79, var0_79)

	return #arg1_79, var2_79
end

local function var40_0(arg0_80, arg1_80, arg2_80)
	local var0_80 = arg2_80[arg1_80]
	local var1_80 = var8_0.getCSharpValue(arg0_80, var0_80)

	if var1_80 then
		if arg1_80 == #arg2_80 then
			return #arg2_80, var1_80
		else
			local var2_80, var3_80 = var40_0(var1_80, arg1_80 + 1, arg2_80)

			if not var3_80 then
				local var4_80 = {}

				for iter0_80 = var2_80, #arg2_80 do
					table.insert(var4_80, arg2_80[iter0_80])
				end

				local var5_80, var6_80 = debugger_searchVarByKeys(arg0_80, searckKeys, 1)

				return var5_80, var6_80
			else
				return var2_80, var3_80
			end
		end
	else
		return arg1_80, var1_80
	end
end

local function var41_0(arg0_81, arg1_81, arg2_81)
	local var0_81, var1_81 = var39_0(arg0_81, arg2_81, 1)

	if not var8_0 then
		return var0_81, var1_81
	end

	if var1_81 then
		if var0_81 == #arg1_81 then
			return var0_81, var1_81
		else
			local var2_81 = ""
			local var3_81 = #arg1_81
			local var4_81 = var0_81 + 1
			local var5_81, var6_81 = var40_0(var1_81, var4_81, arg1_81)

			return var5_81, var6_81
		end
	else
		local var7_81 = {}

		for iter0_81 = 1, #arg2_81 - 1 do
			table.insert(var7_81, arg1_81[iter0_81])
		end

		if #var7_81 == 0 then
			return #arg1_81, nil
		end

		return var41_0(arg0_81, arg1_81, var7_81)
	end
end

local function var42_0(arg0_82, arg1_82, arg2_82, arg3_82, arg4_82, arg5_82, arg6_82)
	for iter0_82, iter1_82 in ipairs(arg6_82) do
		if arg1_82 == iter1_82 then
			return arg2_82
		end
	end

	table.insert(arg6_82, arg1_82)

	for iter2_82, iter3_82 in pairs(arg1_82) do
		local var0_82

		if type(iter2_82) == "string" then
			xpcall(function()
				var0_82 = arg0_82[iter2_82]
			end, function(arg0_84)
				var0_82 = nil
			end)

			if var0_82 == nil then
				xpcall(function()
					if string.find(iter2_82, "__") then
						var0_82 = iter3_82
					end
				end, function(arg0_86)
					var0_82 = nil
				end)
			end
		end

		if var0_82 then
			local var1_82 = var26_0(iter2_82, var0_82)

			table.insert(arg2_82, var1_82)

			if #arg2_82 > 10 then
				var35_0(arg3_82, var17_0.event.C2S_ReqVar, {
					isComplete = 0,
					variablesReference = arg4_82,
					debugSpeedIndex = arg5_82,
					vars = arg2_82
				})

				arg2_82 = {}
			end
		end
	end

	local var2_82 = getmetatable(arg1_82)

	if var2_82 then
		return var42_0(arg0_82, var2_82, arg2_82, arg3_82, arg4_82, arg5_82, arg6_82)
	else
		return arg2_82
	end
end

local function var43_0(arg0_87, arg1_87, arg2_87, arg3_87, arg4_87, arg5_87)
	if arg5_87 == "userdata" then
		if tolua and tolua.getpeer then
			arg0_87 = tolua.getpeer(arg0_87)
		else
			return arg1_87
		end
	end

	if arg0_87 == nil then
		return arg1_87
	end

	for iter0_87, iter1_87 in pairs(arg0_87) do
		local var0_87 = var26_0(iter0_87, iter1_87)

		table.insert(arg1_87, var0_87)

		if #arg1_87 > 10 then
			var35_0(arg2_87, var17_0.event.C2S_ReqVar, {
				isComplete = 0,
				variablesReference = arg3_87,
				debugSpeedIndex = arg4_87,
				vars = arg1_87
			})

			arg1_87 = {}
		end
	end

	return arg1_87
end

local function var44_0(arg0_88, arg1_88, arg2_88, arg3_88)
	local var0_88 = {}
	local var1_88 = {}
	local var2_88 = type(arg0_88)
	local var3_88 = {}
	local var4_88

	if var2_88 == "userdata" then
		if tolua and tolua.getpeer then
			var4_88 = getmetatable(arg0_88)
			var0_88 = var43_0(arg0_88, var0_88, arg1_88, arg2_88, arg3_88, var2_88)
		end

		if var8_0 then
			local var5_88 = var37_0(arg1_88, arg0_88, arg2_88, arg3_88)

			for iter0_88, iter1_88 in ipairs(var5_88) do
				if iter1_88.valueType == "System.Byte[]" and arg0_88[iter1_88.name] and type(arg0_88[iter1_88.name]) == "string" then
					local var6_88 = {
						valueType = "string",
						name = iter1_88.name,
						valueStr = var6_0.encode(arg0_88[iter1_88.name])
					}

					table.insert(var0_88, var6_88)
				else
					table.insert(var0_88, iter1_88)
				end

				if #var0_88 > 10 then
					var35_0(arg1_88, var17_0.event.C2S_ReqVar, {
						isComplete = 0,
						variablesReference = arg2_88,
						debugSpeedIndex = arg3_88,
						vars = var0_88
					})

					var0_88 = {}
				end
			end

			var4_88 = getmetatable(arg0_88)
		end
	else
		var4_88 = getmetatable(arg0_88)
		var0_88 = var43_0(arg0_88, var0_88, arg1_88, arg2_88, arg3_88, var2_88)
	end

	if var4_88 then
		var0_88 = var42_0(arg0_88, var4_88, var0_88, arg1_88, arg2_88, arg3_88, {})
	end

	var35_0(arg1_88, var17_0.event.C2S_ReqVar, {
		isComplete = 1,
		variablesReference = arg2_88,
		debugSpeedIndex = arg3_88,
		vars = var0_88
	})
end

local function var45_0(arg0_89, arg1_89)
	local var0_89 = arg0_89.variablesReference
	local var1_89 = arg0_89.debugSpeedIndex
	local var2_89 = {}

	local function var3_89()
		local var0_90 = arg0_89.frameId
		local var1_90 = arg0_89.type
		local var2_90 = arg0_89.keys
		local var3_90

		if var1_90 == 1 then
			var3_90 = var17_0.currentDebuggerData.vars[var0_90 + 1]
			var3_90 = var3_90.locals
		elseif var1_90 == 2 then
			var3_90 = var17_0.currentDebuggerData.vars[var0_90 + 1]
			var3_90 = var3_90.ups
		elseif var1_90 == 3 then
			var3_90 = _G
		end

		if #var2_90 == 0 then
			var44_0(var3_90, arg1_89, var0_89, var1_89)

			return
		end

		local var4_90, var5_90 = var41_0(var3_90, var2_90, var2_90)

		if var5_90 then
			local var6_90 = type(var5_90)

			if var6_90 == "table" or var6_90 == "userdata" then
				var44_0(var5_90, arg1_89, var0_89, var1_89)
			else
				if var6_90 == "function" then
					var5_90 = tostring(var5_90)
				end

				var35_0(arg1_89, var17_0.event.C2S_ReqVar, {
					isComplete = 1,
					variablesReference = var0_89,
					debugSpeedIndex = var1_89,
					vars = var6_0.encode(var5_90),
					varType = var6_90
				})
			end
		else
			var35_0(arg1_89, var17_0.event.C2S_ReqVar, {
				isComplete = 1,
				varType = "nil",
				variablesReference = var0_89,
				debugSpeedIndex = var1_89,
				vars = {}
			})
		end
	end

	xpcall(var3_89, function(arg0_91)
		var35_0(arg1_89, var17_0.event.C2S_ReqVar, {
			isComplete = 1,
			variablesReference = var0_89,
			debugSpeedIndex = var1_89,
			vars = {
				{
					isValue = false,
					name = "error",
					valueType = "string",
					valueStr = var6_0.encode("无法获取属性值:" .. arg0_91 .. "->" .. debug.traceback("", 2))
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
	var17_0.StepNextLevel = 0
end

local function var47_0(arg0_93)
	arg0_93 = var14_0

	local var0_93
	local var1_93 = {}
	local var2_93

	while true do
		local var3_93, var4_93 = arg0_93:receive()

		if var4_93 == "closed" then
			debug.sethook()
			coroutine.yield()
		end

		if var3_93 then
			local var5_93 = var16_0.decode(var3_93)
			local var6_93 = var5_93.event
			local var7_93 = var5_93.data

			if var6_93 == var17_0.event.S2C_DebugClose then
				debug.sethook()
				coroutine.yield()
			elseif var6_93 == var17_0.event.S2C_SetBreakPoints then
				local function var8_93()
					var29_0(var7_93)
				end

				xpcall(var8_93, function(arg0_95)
					print(arg0_95)
				end)
			elseif var6_93 == var17_0.event.S2C_RUN then
				var17_0.runTimeType = var7_93.runTimeType
				var17_0.isProntToConsole = var7_93.isProntToConsole
				var17_0.isFoxGloryProject = var7_93.isFoxGloryProject

				var46_0()

				var17_0.Run = true

				local var9_93 = coroutine.yield()

				var17_0.currentDebuggerData = var9_93

				var35_0(arg0_93, var9_93.event, {
					stack = var9_93.stack
				})
			elseif var6_93 == var17_0.event.S2C_ReqVar then
				var45_0(var7_93, arg0_93)
			elseif var6_93 == var17_0.event.S2C_NextRequest then
				var46_0()

				var17_0.StepNext = true
				var17_0.StepNextLevel = 0

				local var10_93 = coroutine.yield()

				var17_0.currentDebuggerData = var10_93

				var35_0(arg0_93, var10_93.event, {
					stack = var10_93.stack
				})
			elseif var6_93 == var17_0.event.S2C_StepInRequest then
				var46_0()

				var17_0.StepIn = true

				local var11_93 = coroutine.yield()

				var17_0.currentDebuggerData = var11_93

				var35_0(arg0_93, var11_93.event, {
					stack = var11_93.stack,
					eventType = var11_93.eventType
				})
			elseif var6_93 == var17_0.event.S2C_StepOutRequest then
				var46_0()

				var17_0.StepOut = true

				local var12_93 = coroutine.yield()

				var17_0.currentDebuggerData = var12_93

				var35_0(arg0_93, var12_93.event, {
					stack = var12_93.stack,
					eventType = var12_93.eventType
				})
			elseif var6_93 == var17_0.event.S2C_LoadLuaScript then
				var3_0(var7_93, true)
			end
		end
	end
end

local var48_0 = coroutine.create(var47_0)

function var18_0(arg0_96, arg1_96)
	if not var17_0.isHook then
		return
	end

	if var17_0.Run then
		if arg0_96 == "line" then
			local var0_96 = false

			for iter0_96, iter1_96 in pairs(var17_0.breakInfos) do
				for iter2_96, iter3_96 in pairs(iter1_96) do
					if iter3_96.lines and iter3_96.lines[arg1_96] then
						var0_96 = true

						break
					end
				end

				if var0_96 then
					break
				end
			end

			if not var0_96 then
				return
			end
		else
			var17_0.currentFileName = nil
			var17_0.currentTempFunc = nil

			return
		end
	end

	if var17_0.StepOut then
		if arg0_96 == "line" or arg0_96 == "call" then
			return
		end

		local var1_96 = var10_0(2, "f").func

		if var17_0.currentDebuggerData.funcsLength == 1 then
			var46_0()

			var17_0.Run = true
		elseif var17_0.currentDebuggerData.funcs[2] == var1_96 then
			local var2_96 = var28_0(3, var17_0.event.C2S_StepInResponse)

			var19_0(var48_0, var2_96)
		end

		return
	end

	local var3_96

	if arg0_96 == "call" then
		if not var17_0.Run then
			var17_0.StepNextLevel = var17_0.StepNextLevel + 1
		end

		local var4_96 = var10_0(2, "S").source

		if var4_96:find(var17_0.DebugLuaFie) or var4_96 == "=[C]" then
			return
		end

		local var5_96 = var36_0(var4_96)

		var17_0.currentFileName = var5_96
	elseif arg0_96 == "return" or arg0_96 == "tail return" then
		if not var17_0.Run then
			var17_0.StepNextLevel = var17_0.StepNextLevel - 1
		end

		var17_0.currentFileName = nil
	elseif arg0_96 == "line" then
		local var6_96 = false
		local var7_96

		if not var17_0.currentFileName then
			var7_96 = var10_0(2, "S")

			local var8_96 = var7_96.source

			if var8_96 == "=[C]" or var8_96:find(var17_0.DebugLuaFie) then
				return
			end

			local var9_96 = var36_0(var8_96)

			var17_0.currentFileName = var9_96
		end

		local var10_96 = var17_0.currentFileName
		local var11_96 = var17_0.breakInfos[var10_96]
		local var12_96

		if var11_96 then
			local var13_96 = false

			for iter4_96, iter5_96 in pairs(var11_96) do
				local var14_96 = iter5_96.lines

				if var14_96 and var14_96[arg1_96] then
					var13_96 = true

					break
				end
			end

			if var13_96 then
				if not var7_96 then
					local var15_96 = var10_0(2)
				end

				local var16_96 = var31_0(var17_0.currentLineFile)
				local var17_96 = {}
				local var18_96

				for iter6_96, iter7_96 in pairs(var11_96) do
					local var19_96 = iter7_96.lines
					local var20_96 = iter7_96.pathNames

					var18_96 = iter7_96.hitCounts

					if var19_96 and var19_96[arg1_96] then
						var12_96 = var19_96[arg1_96]
						var17_96[iter6_96] = 0

						local var21_96 = #var16_96
						local var22_96 = #var20_96

						repeat
							if var20_96[var22_96] ~= var16_96[var21_96] then
								break
							else
								var17_96[iter6_96] = var17_96[iter6_96] + 1
							end

							var22_96 = var22_96 - 1
							var21_96 = var21_96 - 1
						until var22_96 <= 0 or var21_96 <= 0
					else
						var12_96 = nil
					end
				end

				if var12_96 then
					local var23_96 = ""
					local var24_96 = 0

					for iter8_96, iter9_96 in pairs(var17_96) do
						if var24_96 < iter9_96 then
							var24_96 = iter9_96
							var23_96 = iter8_96
						end
					end

					local var25_96 = #var16_96

					if (var25_96 == 1 or var25_96 > 1 and var24_96 > 1) and var23_96 ~= "" then
						local var26_96 = var12_96.hitCondition
						local var27_96 = var18_96[var12_96.line] + 1

						var18_96[var12_96.line] = var27_96

						if var26_96 <= var27_96 then
							var6_96 = true
						end
					end
				end
			end
		end

		if var17_0.StepIn then
			local var28_96 = var28_0(3, var17_0.event.C2S_NextResponse)

			if var28_96 then
				var17_0.currentTempFunc = var28_96.funcs[1]

				var19_0(var48_0, var28_96)

				return
			end
		end

		if var17_0.StepNext and var17_0.StepNextLevel <= 0 then
			local var29_96 = var28_0(3, var17_0.event.C2S_NextResponse)

			if var29_96 then
				var17_0.currentTempFunc = var29_96.funcs[1]

				var19_0(var48_0, var29_96)

				return
			end
		end

		if var6_96 then
			local var30_96 = var28_0(3, var17_0.event.C2S_HITBreakPoint)

			if var12_96 and var12_96.condition then
				debugger_conditionStr(var12_96.condition, var30_96.vars, function()
					var19_0(var48_0, var30_96)
				end)
			else
				var19_0(var48_0, var30_96)
			end
		end
	end
end

local function var49_0()
	local var0_98 = var28_0(4, var17_0.event.C2S_HITBreakPoint)

	var19_0(var48_0, var0_98)
end

local function var50_0()
	local var0_99, var1_99, var2_99 = var22_0(var10_0(1).source)

	var17_0.DebugLuaFie = var2_99

	local var3_99 = var11_0()

	print(var33_0)
	print(var34_0)

	local var4_99 = var3_99.connect(var33_0, var34_0)

	var14_0 = var4_99

	if var4_99 then
		var15_0 = var11_0().connect(var33_0, var34_0)

		if var15_0 then
			var15_0:settimeout(0)
			var35_0(var15_0, var17_0.event.C2S_SetSocketName, {
				name = "breakPointSocket"
			})
			var35_0(var4_99, var17_0.event.C2S_SetSocketName, {
				name = "mainSocket",
				version = var17_0.version
			})
			xpcall(function()
				debug.sethook(var18_0, "lrc")
			end, function(arg0_101)
				print("error:", arg0_101)
			end)

			if jit and var17_0.debugLuaType ~= "jit" then
				print("error======================================================")

				local var5_99 = "当前luajit版本为: " .. jit.version .. " 请使用LuaDebugjit 进行调试!"

				print(var5_99)
			end

			var19_0(var48_0, var4_99)
		end
	end
end

function StartDebug(arg0_102, arg1_102)
	if not arg0_102 then
		print("error host nil")
	end

	if not arg1_102 then
		print("error prot nil")
	end

	if type(arg0_102) ~= "string" then
		print("error host not string")
	end

	if type(arg1_102) ~= "number" then
		print("error host not number")
	end

	var33_0 = arg0_102
	var34_0 = arg1_102

	xpcall(var50_0, function(arg0_103)
		print(arg0_103)
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

function var6_0.encode(arg0_104)
	local var0_104 = var51_0.len(arg0_104)
	local var1_104 = var0_104 % 3
	local var2_104 = var0_104 - var1_104
	local var3_104 = {}
	local var4_104 = 1

	for iter0_104 = 1, var2_104, 3 do
		local var5_104 = var51_0.byte(arg0_104, iter0_104)
		local var6_104 = var51_0.byte(arg0_104, iter0_104 + 1)
		local var7_104 = var51_0.byte(arg0_104, iter0_104 + 2)
		local var8_104 = var5_104 * 65536 + var6_104 * 256 + var7_104

		for iter1_104 = 1, 4 do
			local var9_104 = math.floor(var8_104 / 2^((4 - iter1_104) * 6)) % 64 + 1

			var3_104[var4_104] = var6_0.__code[var9_104]
			var4_104 = var4_104 + 1
		end
	end

	if var1_104 == 1 then
		var6_0.__left1(var3_104, var4_104, arg0_104, var2_104)
	elseif var1_104 == 2 then
		var6_0.__left2(var3_104, var4_104, arg0_104, var2_104)
	end

	return table.concat(var3_104)
end

function var6_0.__left2(arg0_105, arg1_105, arg2_105, arg3_105)
	local var0_105 = var51_0.byte(arg2_105, arg3_105 + 1) * 1024 + var51_0.byte(arg2_105, arg3_105 + 2) * 4
	local var1_105 = math.floor(var0_105 / 4096) % 64 + 1

	arg0_105[arg1_105] = var6_0.__code[var1_105]

	local var2_105 = math.floor(var0_105 / 64) % 64 + 1

	arg0_105[arg1_105 + 1] = var6_0.__code[var2_105]

	local var3_105 = var0_105 % 64 + 1

	arg0_105[arg1_105 + 2] = var6_0.__code[var3_105]
	arg0_105[arg1_105 + 3] = "="
end

function var6_0.__left1(arg0_106, arg1_106, arg2_106, arg3_106)
	local var0_106 = var51_0.byte(arg2_106, arg3_106 + 1) * 16
	local var1_106 = math.floor(var0_106 / 64) % 64 + 1

	arg0_106[arg1_106] = var6_0.__code[var1_106]

	local var2_106 = var0_106 % 64 + 1

	arg0_106[arg1_106 + 1] = var6_0.__code[var2_106]
	arg0_106[arg1_106 + 2] = "="
	arg0_106[arg1_106 + 3] = "="
end

function var6_0.decode(arg0_107)
	local var0_107 = var51_0.len(arg0_107)
	local var1_107 = 0

	if var51_0.sub(arg0_107, var0_107 - 1) == "==" then
		var1_107 = 2
		var0_107 = var0_107 - 4
	elseif var51_0.sub(arg0_107, var0_107) == "=" then
		var1_107 = 1
		var0_107 = var0_107 - 4
	end

	local var2_107 = {}
	local var3_107 = 1
	local var4_107 = var6_0.__decode

	for iter0_107 = 1, var0_107, 4 do
		local var5_107 = var4_107[var51_0.byte(arg0_107, iter0_107)]
		local var6_107 = var4_107[var51_0.byte(arg0_107, iter0_107 + 1)]
		local var7_107 = var4_107[var51_0.byte(arg0_107, iter0_107 + 2)]
		local var8_107 = var4_107[var51_0.byte(arg0_107, iter0_107 + 3)]
		local var9_107 = var5_107 * 262144 + var6_107 * 4096 + var7_107 * 64 + var8_107
		local var10_107 = var51_0.char(var9_107 % 256)
		local var11_107 = math.floor(var9_107 / 256)
		local var12_107 = var51_0.char(var11_107 % 256)
		local var13_107 = math.floor(var11_107 / 256)

		var2_107[var3_107] = var51_0.char(var13_107 % 256)
		var2_107[var3_107 + 1] = var12_107
		var2_107[var3_107 + 2] = var10_107
		var3_107 = var3_107 + 3
	end

	if var1_107 == 1 then
		var6_0.__decodeLeft1(var2_107, var3_107, arg0_107, var0_107)
	elseif var1_107 == 2 then
		var6_0.__decodeLeft2(var2_107, var3_107, arg0_107, var0_107)
	end

	return table.concat(var2_107)
end

function var6_0.__decodeLeft1(arg0_108, arg1_108, arg2_108, arg3_108)
	local var0_108 = var6_0.__decode
	local var1_108 = var0_108[var51_0.byte(arg2_108, arg3_108 + 1)]
	local var2_108 = var0_108[var51_0.byte(arg2_108, arg3_108 + 2)]
	local var3_108 = var0_108[var51_0.byte(arg2_108, arg3_108 + 3)]
	local var4_108 = var1_108 * 4096 + var2_108 * 64 + var3_108
	local var5_108 = math.floor(var4_108 / 1024) % 256
	local var6_108 = math.floor(var4_108 / 4) % 256

	arg0_108[arg1_108] = var51_0.char(var5_108)
	arg0_108[arg1_108 + 1] = var51_0.char(var6_108)
end

function var6_0.__decodeLeft2(arg0_109, arg1_109, arg2_109, arg3_109)
	local var0_109 = var6_0.__decode
	local var1_109 = var0_109[var51_0.byte(arg2_109, arg3_109 + 1)]
	local var2_109 = var0_109[var51_0.byte(arg2_109, arg3_109 + 2)]
	local var3_109 = var1_109 * 64 + var2_109
	local var4_109 = math.floor(var3_109 / 16)

	arg0_109[arg1_109] = var51_0.char(var4_109)
end

return StartDebug
