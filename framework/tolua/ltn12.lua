local var0 = require("string")
local var1 = require("table")
local var2 = unpack or var1.unpack
local var3 = _G
local var4 = {}

if module then
	ltn12 = var4
end

local var5 = {}
local var6 = {}
local var7 = {}
local var8 = {}

var4.filter = var5
var4.source = var6
var4.sink = var7
var4.pump = var8

local var9 = var2 or var1.unpack
local var10 = var3.select

var4.BLOCKSIZE = 2048
var4._VERSION = "LTN12 1.0.3"

function var5.cycle(arg0, arg1, arg2)
	var3.assert(arg0)

	return function(arg0)
		local var0
		local var1, var2 = arg0(arg1, arg0, arg2)

		arg1 = var2

		return var1
	end
end

function var5.chain(...)
	local var0 = {
		...
	}
	local var1 = var3.select("#", ...)
	local var2 = 1
	local var3 = 1
	local var4 = ""

	return function(arg0)
		var4 = arg0 and var4

		while true do
			if var3 == var2 then
				arg0 = var0[var3](arg0)

				if arg0 == "" or var2 == var1 then
					return arg0
				elseif arg0 then
					var3 = var3 + 1
				else
					var2 = var2 + 1
					var3 = var2
				end
			else
				arg0 = var0[var3](arg0 or "")

				if arg0 == "" then
					var3 = var3 - 1
					arg0 = var4
				elseif arg0 then
					if var3 == var1 then
						return arg0
					else
						var3 = var3 + 1
					end
				else
					var3.error("filter returned inappropriate nil")
				end
			end
		end
	end
end

local function var11()
	return nil
end

function var6.empty()
	return var11
end

function var6.error(arg0)
	return function()
		return nil, arg0
	end
end

function var6.file(arg0, arg1)
	if arg0 then
		return function()
			local var0 = arg0:read(var4.BLOCKSIZE)

			if not var0 then
				arg0:close()
			end

			return var0
		end
	else
		return var6.error(arg1 or "unable to open file")
	end
end

function var6.simplify(arg0)
	var3.assert(arg0)

	return function()
		local var0, var1 = arg0()

		arg0 = var1 or arg0

		if not var0 then
			return nil, var1
		else
			return var0
		end
	end
end

function var6.string(arg0)
	if arg0 then
		local var0 = 1

		return function()
			local var0 = var0.sub(arg0, var0, var0 + var4.BLOCKSIZE - 1)

			var0 = var0 + var4.BLOCKSIZE

			if var0 ~= "" then
				return var0
			else
				return nil
			end
		end
	else
		return var6.empty()
	end
end

function var6.rewind(arg0)
	var3.assert(arg0)

	local var0 = {}

	return function(arg0)
		if not arg0 then
			arg0 = var1.remove(var0)

			if not arg0 then
				return arg0()
			else
				return arg0
			end
		else
			var1.insert(var0, arg0)
		end
	end
end

function var6.chain(arg0, arg1, ...)
	if ... then
		arg1 = var5.chain(arg1, ...)
	end

	var3.assert(arg0 and arg1)

	local var0 = ""
	local var1 = ""
	local var2 = "feeding"
	local var3

	return function()
		if not var1 then
			var3.error("source is empty!", 2)
		end

		while true do
			if var2 == "feeding" then
				var0, var3 = arg0()

				if var3 then
					return nil, var3
				end

				var1 = arg1(var0)

				if not var1 then
					if var0 then
						var3.error("filter returned inappropriate nil")
					else
						return nil
					end
				elseif var1 ~= "" then
					var2 = "eating"

					if var0 then
						var0 = ""
					end

					return var1
				end
			else
				var1 = arg1(var0)

				if var1 == "" then
					if var0 == "" then
						var2 = "feeding"
					else
						var3.error("filter returned \"\"")
					end
				elseif not var1 then
					if var0 then
						var3.error("filter returned inappropriate nil")
					else
						return nil
					end
				else
					return var1
				end
			end
		end
	end
end

function var6.cat(...)
	local var0 = {
		...
	}
	local var1 = var1.remove(var0, 1)

	return function()
		while var1 do
			local var0, var1 = var1()

			if var0 then
				return var0
			end

			if var1 then
				return nil, var1
			end

			var1 = var1.remove(var0, 1)
		end
	end
end

function var7.table(arg0)
	arg0 = arg0 or {}

	return function(arg0, arg1)
		if arg0 then
			var1.insert(arg0, arg0)
		end

		return 1
	end, arg0
end

function var7.simplify(arg0)
	var3.assert(arg0)

	return function(arg0, arg1)
		local var0, var1 = arg0(arg0, arg1)

		if not var0 then
			return nil, var1
		end

		arg0 = var1 or arg0

		return 1
	end
end

function var7.file(arg0, arg1)
	if arg0 then
		return function(arg0, arg1)
			if not arg0 then
				arg0:close()

				return 1
			else
				return arg0:write(arg0)
			end
		end
	else
		return var7.error(arg1 or "unable to open file")
	end
end

local function var12()
	return 1
end

function var7.null()
	return var12
end

function var7.error(arg0)
	return function()
		return nil, arg0
	end
end

function var7.chain(arg0, arg1, ...)
	if ... then
		local var0 = {
			arg0,
			arg1,
			...
		}

		arg1 = var1.remove(var0, #var0)
		arg0 = var5.chain(var9(var0))
	end

	var3.assert(arg0 and arg1)

	return function(arg0, arg1)
		if arg0 ~= "" then
			local var0 = arg0(arg0)
			local var1 = arg0 and ""

			while true do
				local var2, var3 = arg1(var0, arg1)

				if not var2 then
					return nil, var3
				end

				if var0 == var1 then
					return 1
				end

				var0 = arg0(var1)
			end
		else
			return 1
		end
	end
end

function var8.step(arg0, arg1)
	local var0, var1 = arg0()
	local var2, var3 = arg1(var0, var1)

	if var0 and var2 then
		return 1
	else
		return nil, var1 or var3
	end
end

function var8.all(arg0, arg1, arg2)
	var3.assert(arg0 and arg1)

	arg2 = arg2 or var8.step

	while true do
		local var0, var1 = arg2(arg0, arg1)

		if not var0 then
			if var1 then
				return nil, var1
			else
				return 1
			end
		end
	end
end

return var4
