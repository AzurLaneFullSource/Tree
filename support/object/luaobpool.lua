pg = pg or {}

local var0_0 = pg
local var1_0 = require("Mgr/Pool/PoolUtil")
local var2_0 = class("LuaObPool")

var0_0.LuaObPool = var2_0

function var2_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	assert(arg1_1.Init, "template should have func Init")
	assert(arg1_1.Recycle, "template should have func Recycle")
	assert(arg1_1.Dispose, "template should have func Dispose")

	arg0_1.baseClass = arg1_1
	arg0_1.info = arg2_1
	arg0_1.list = {}
	arg0_1.ob2index = {}

	for iter0_1 = 1, arg3_1 do
		arg0_1.list[iter0_1] = arg1_1.New(arg0_1, arg2_1)
	end

	arg0_1.usedEnd = 0
end

function var2_0.GetObject(arg0_2)
	local var0_2 = arg0_2.list
	local var1_2 = arg0_2.usedEnd
	local var2_2

	if var1_2 >= #var0_2 then
		var0_2[#var0_2 + 1] = arg0_2.baseClass.New(arg0_2, arg0_2.info)
	end

	local var3_2 = var1_2 + 1
	local var4_2 = var0_2[var3_2]

	arg0_2.ob2index[var4_2] = var3_2
	arg0_2.usedEnd = var3_2

	var4_2:Init()

	return var4_2
end

function var2_0.Recycle(arg0_3, arg1_3)
	local var0_3 = arg0_3.ob2index[arg1_3]
	local var1_3 = arg0_3.usedEnd
	local var2_3 = arg0_3.list

	arg1_3:Recycle()

	if var1_3 ~= var0_3 then
		local var3_3 = var2_3[var1_3]

		arg0_3.ob2index[var3_3] = var0_3
		var2_3[var1_3], var2_3[var0_3] = arg1_3, var3_3
	end

	arg0_3.ob2index[arg1_3] = nil
	arg0_3.usedEnd = var1_3 - 1
end

function var2_0.UpdateInfo(arg0_4, arg1_4, arg2_4)
	arg0_4.info[arg1_4] = arg2_4
end

function var2_0.Dispose(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.list) do
		iter1_5:Dispose()
	end

	arg0_5.ob2index = nil
end
