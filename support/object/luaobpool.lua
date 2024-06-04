pg = pg or {}

local var0 = pg
local var1 = require("Mgr/Pool/PoolUtil")
local var2 = class("LuaObPool")

var0.LuaObPool = var2

function var2.Ctor(arg0, arg1, arg2, arg3)
	assert(arg1.Init, "template should have func Init")
	assert(arg1.Recycle, "template should have func Recycle")
	assert(arg1.Dispose, "template should have func Dispose")

	arg0.baseClass = arg1
	arg0.info = arg2
	arg0.list = {}
	arg0.ob2index = {}

	for iter0 = 1, arg3 do
		arg0.list[iter0] = arg1.New(arg0, arg2)
	end

	arg0.usedEnd = 0
end

function var2.GetObject(arg0)
	local var0 = arg0.list
	local var1 = arg0.usedEnd
	local var2

	if var1 >= #var0 then
		var0[#var0 + 1] = arg0.baseClass.New(arg0, arg0.info)
	end

	local var3 = var1 + 1
	local var4 = var0[var3]

	arg0.ob2index[var4] = var3
	arg0.usedEnd = var3

	var4:Init()

	return var4
end

function var2.Recycle(arg0, arg1)
	local var0 = arg0.ob2index[arg1]
	local var1 = arg0.usedEnd
	local var2 = arg0.list

	arg1:Recycle()

	if var1 ~= var0 then
		local var3 = var2[var1]

		arg0.ob2index[var3] = var0
		var2[var1], var2[var0] = arg1, var3
	end

	arg0.ob2index[arg1] = nil
	arg0.usedEnd = var1 - 1
end

function var2.UpdateInfo(arg0, arg1, arg2)
	arg0.info[arg1] = arg2
end

function var2.Dispose(arg0)
	for iter0, iter1 in ipairs(arg0.list) do
		iter1:Dispose()
	end

	arg0.ob2index = nil
end
