local var0_0 = pcall
local var1_0 = pairs
local var2_0 = error
local var3_0 = rawset
local var4_0 = rawget
local var5_0 = string
local var6_0 = tolua_tag
local var7_0 = getmetatable
local var8_0
local var9_0 = require("Framework.tolua.System.Injection.InjectionBridgeInfo")

local function var10_0(arg0_1)
	local var0_1 = var7_0(arg0_1)

	if var4_0(var0_1, var6_0) ~= 1 then
		var2_0("Can't Inject")
	end

	return var0_1
end

local function var11_0()
	if var8_0 == nil then
		var8_0 = LuaInterface.LuaInjectionStation
	end
end

local function var12_0(arg0_3, arg1_3)
	local var0_3 = arg0_3.__index
	local var1_3 = {}

	for iter0_3, iter1_3 in var1_0(arg1_3) do
		local var2_3, var3_3 = iter1_3()

		if var3_3 == LuaInterface.InjectType.Replace or var3_3 == LuaInterface.InjectType.ReplaceWithPostInvokeBase or var3_3 == LuaInterface.InjectType.ReplaceWithPreInvokeBase then
			var3_0(var1_3, iter0_3, var2_3)
		end
	end

	function arg0_3.__index(arg0_4, arg1_4)
		local var0_4 = var4_0(var1_3, arg1_4)

		if var0_4 ~= nil then
			return var0_4
		end

		local var1_4, var2_4 = var0_0(var0_3, arg0_4, arg1_4)

		if var1_4 then
			return var2_4
		else
			var2_0(var2_4)

			return nil
		end
	end
end

function InjectByModule(arg0_5, arg1_5)
	local var0_5 = var10_0(arg0_5)
	local var1_5 = var0_5[".name"]

	InjectByName(var1_5, arg1_5)
	var12_0(var0_5, arg1_5)
end

function InjectByName(arg0_6, arg1_6)
	var11_0()

	local var0_6 = var4_0(var9_0, arg0_6)

	if var0_6 == nil then
		var2_0(var5_0.format("Module %s Can't Inject", arg0_6))
	end

	for iter0_6, iter1_6 in var1_0(arg1_6) do
		local var1_6, var2_6 = iter1_6()
		local var3_6 = var4_0(var0_6, iter0_6)

		if var3_6 == nil then
			var2_0(var5_0.format("Function %s Doesn't Exist In Module %s", iter0_6, arg0_6))
		end

		var8_0.CacheInjectFunction(var3_6, var2_6:ToInt(), var1_6)
	end
end

require("Framework.tolua.System.Injection.LuaInjectionBus")
