local var0_0 = require("string")
local var1_0 = require("table")
local var2_0 = unpack or var1_0.unpack
local var3_0 = _G
local var4_0 = {}

if module then
	ltn12 = var4_0
end

local var5_0 = {}
local var6_0 = {}
local var7_0 = {}
local var8_0 = {}

var4_0.filter = var5_0
var4_0.source = var6_0
var4_0.sink = var7_0
var4_0.pump = var8_0

local var9_0 = var2_0 or var1_0.unpack
local var10_0 = var3_0.select

var4_0.BLOCKSIZE = 2048
var4_0._VERSION = "LTN12 1.0.3"

function var5_0.cycle(arg0_1, arg1_1, arg2_1)
	var3_0.assert(arg0_1)

	return function(arg0_2)
		local var0_2
		local var1_2, var2_2 = arg0_1(arg1_1, arg0_2, arg2_1)

		arg1_1 = var2_2

		return var1_2
	end
end

function var5_0.chain(...)
	local var0_3 = {
		...
	}
	local var1_3 = var3_0.select("#", ...)
	local var2_3 = 1
	local var3_3 = 1
	local var4_3 = ""

	return function(arg0_4)
		var4_3 = arg0_4 and var4_3

		while true do
			if var3_3 == var2_3 then
				arg0_4 = var0_3[var3_3](arg0_4)

				if arg0_4 == "" or var2_3 == var1_3 then
					return arg0_4
				elseif arg0_4 then
					var3_3 = var3_3 + 1
				else
					var2_3 = var2_3 + 1
					var3_3 = var2_3
				end
			else
				arg0_4 = var0_3[var3_3](arg0_4 or "")

				if arg0_4 == "" then
					var3_3 = var3_3 - 1
					arg0_4 = var4_3
				elseif arg0_4 then
					if var3_3 == var1_3 then
						return arg0_4
					else
						var3_3 = var3_3 + 1
					end
				else
					var3_0.error("filter returned inappropriate nil")
				end
			end
		end
	end
end

local function var11_0()
	return nil
end

function var6_0.empty()
	return var11_0
end

function var6_0.error(arg0_7)
	return function()
		return nil, arg0_7
	end
end

function var6_0.file(arg0_9, arg1_9)
	if arg0_9 then
		return function()
			local var0_10 = arg0_9:read(var4_0.BLOCKSIZE)

			if not var0_10 then
				arg0_9:close()
			end

			return var0_10
		end
	else
		return var6_0.error(arg1_9 or "unable to open file")
	end
end

function var6_0.simplify(arg0_11)
	var3_0.assert(arg0_11)

	return function()
		local var0_12, var1_12 = arg0_11()

		arg0_11 = var1_12 or arg0_11

		if not var0_12 then
			return nil, var1_12
		else
			return var0_12
		end
	end
end

function var6_0.string(arg0_13)
	if arg0_13 then
		local var0_13 = 1

		return function()
			local var0_14 = var0_0.sub(arg0_13, var0_13, var0_13 + var4_0.BLOCKSIZE - 1)

			var0_13 = var0_13 + var4_0.BLOCKSIZE

			if var0_14 ~= "" then
				return var0_14
			else
				return nil
			end
		end
	else
		return var6_0.empty()
	end
end

function var6_0.rewind(arg0_15)
	var3_0.assert(arg0_15)

	local var0_15 = {}

	return function(arg0_16)
		if not arg0_16 then
			arg0_16 = var1_0.remove(var0_15)

			if not arg0_16 then
				return arg0_15()
			else
				return arg0_16
			end
		else
			var1_0.insert(var0_15, arg0_16)
		end
	end
end

function var6_0.chain(arg0_17, arg1_17, ...)
	if ... then
		arg1_17 = var5_0.chain(arg1_17, ...)
	end

	var3_0.assert(arg0_17 and arg1_17)

	local var0_17 = ""
	local var1_17 = ""
	local var2_17 = "feeding"
	local var3_17

	return function()
		if not var1_17 then
			var3_0.error("source is empty!", 2)
		end

		while true do
			if var2_17 == "feeding" then
				var0_17, var3_17 = arg0_17()

				if var3_17 then
					return nil, var3_17
				end

				var1_17 = arg1_17(var0_17)

				if not var1_17 then
					if var0_17 then
						var3_0.error("filter returned inappropriate nil")
					else
						return nil
					end
				elseif var1_17 ~= "" then
					var2_17 = "eating"

					if var0_17 then
						var0_17 = ""
					end

					return var1_17
				end
			else
				var1_17 = arg1_17(var0_17)

				if var1_17 == "" then
					if var0_17 == "" then
						var2_17 = "feeding"
					else
						var3_0.error("filter returned \"\"")
					end
				elseif not var1_17 then
					if var0_17 then
						var3_0.error("filter returned inappropriate nil")
					else
						return nil
					end
				else
					return var1_17
				end
			end
		end
	end
end

function var6_0.cat(...)
	local var0_19 = {
		...
	}
	local var1_19 = var1_0.remove(var0_19, 1)

	return function()
		while var1_19 do
			local var0_20, var1_20 = var1_19()

			if var0_20 then
				return var0_20
			end

			if var1_20 then
				return nil, var1_20
			end

			var1_19 = var1_0.remove(var0_19, 1)
		end
	end
end

function var7_0.table(arg0_21)
	arg0_21 = arg0_21 or {}

	return function(arg0_22, arg1_22)
		if arg0_22 then
			var1_0.insert(arg0_21, arg0_22)
		end

		return 1
	end, arg0_21
end

function var7_0.simplify(arg0_23)
	var3_0.assert(arg0_23)

	return function(arg0_24, arg1_24)
		local var0_24, var1_24 = arg0_23(arg0_24, arg1_24)

		if not var0_24 then
			return nil, var1_24
		end

		arg0_23 = var1_24 or arg0_23

		return 1
	end
end

function var7_0.file(arg0_25, arg1_25)
	if arg0_25 then
		return function(arg0_26, arg1_26)
			if not arg0_26 then
				arg0_25:close()

				return 1
			else
				return arg0_25:write(arg0_26)
			end
		end
	else
		return var7_0.error(arg1_25 or "unable to open file")
	end
end

local function var12_0()
	return 1
end

function var7_0.null()
	return var12_0
end

function var7_0.error(arg0_29)
	return function()
		return nil, arg0_29
	end
end

function var7_0.chain(arg0_31, arg1_31, ...)
	if ... then
		local var0_31 = {
			arg0_31,
			arg1_31,
			...
		}

		arg1_31 = var1_0.remove(var0_31, #var0_31)
		arg0_31 = var5_0.chain(var9_0(var0_31))
	end

	var3_0.assert(arg0_31 and arg1_31)

	return function(arg0_32, arg1_32)
		if arg0_32 ~= "" then
			local var0_32 = arg0_31(arg0_32)
			local var1_32 = arg0_32 and ""

			while true do
				local var2_32, var3_32 = arg1_31(var0_32, arg1_32)

				if not var2_32 then
					return nil, var3_32
				end

				if var0_32 == var1_32 then
					return 1
				end

				var0_32 = arg0_31(var1_32)
			end
		else
			return 1
		end
	end
end

function var8_0.step(arg0_33, arg1_33)
	local var0_33, var1_33 = arg0_33()
	local var2_33, var3_33 = arg1_33(var0_33, var1_33)

	if var0_33 and var2_33 then
		return 1
	else
		return nil, var1_33 or var3_33
	end
end

function var8_0.all(arg0_34, arg1_34, arg2_34)
	var3_0.assert(arg0_34 and arg1_34)

	arg2_34 = arg2_34 or var8_0.step

	while true do
		local var0_34, var1_34 = arg2_34(arg0_34, arg1_34)

		if not var0_34 then
			if var1_34 then
				return nil, var1_34
			else
				return 1
			end
		end
	end
end

return var4_0
