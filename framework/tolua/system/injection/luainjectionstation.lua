local var0 = pcall
local var1 = pairs
local var2 = error
local var3 = rawset
local var4 = rawget
local var5 = string
local var6 = tolua_tag
local var7 = getmetatable
local var8
local var9 = require("Framework.tolua.System.Injection.InjectionBridgeInfo")

local function var10(arg0)
	local var0 = var7(arg0)

	if var4(var0, var6) ~= 1 then
		var2("Can't Inject")
	end

	return var0
end

local function var11()
	if var8 == nil then
		var8 = LuaInterface.LuaInjectionStation
	end
end

local function var12(arg0, arg1)
	local var0 = arg0.__index
	local var1 = {}

	for iter0, iter1 in var1(arg1) do
		local var2, var3 = iter1()

		if var3 == LuaInterface.InjectType.Replace or var3 == LuaInterface.InjectType.ReplaceWithPostInvokeBase or var3 == LuaInterface.InjectType.ReplaceWithPreInvokeBase then
			var3(var1, iter0, var2)
		end
	end

	function arg0.__index(arg0, arg1)
		local var0 = var4(var1, arg1)

		if var0 ~= nil then
			return var0
		end

		local var1, var2 = var0(var0, arg0, arg1)

		if var1 then
			return var2
		else
			var2(var2)

			return nil
		end
	end
end

function InjectByModule(arg0, arg1)
	local var0 = var10(arg0)
	local var1 = var0[".name"]

	InjectByName(var1, arg1)
	var12(var0, arg1)
end

function InjectByName(arg0, arg1)
	var11()

	local var0 = var4(var9, arg0)

	if var0 == nil then
		var2(var5.format("Module %s Can't Inject", arg0))
	end

	for iter0, iter1 in var1(arg1) do
		local var1, var2 = iter1()
		local var3 = var4(var0, iter0)

		if var3 == nil then
			var2(var5.format("Function %s Doesn't Exist In Module %s", iter0, arg0))
		end

		var8.CacheInjectFunction(var3, var2:ToInt(), var1)
	end
end

require("Framework.tolua.System.Injection.LuaInjectionBus")
