local var0 = require("Mgr/Pool/PoolUtil")
local var1 = class("PoolObjPack")

function var1.Ctor(arg0, arg1)
	arg0.type = arg1
	arg0.items = {}
end

function var1.Get(arg0, arg1)
	return arg0.items[arg1]
end

function var1.Set(arg0, arg1, arg2)
	arg0.items[arg1] = arg2
end

function var1.Remove(arg0, arg1)
	return table.removebykey(arg0.items, arg1)
end

function var1.GetAmount(arg0)
	return table.getCount(arg0.items)
end

function var1.Clear(arg0)
	arg0.items = nil
end

return var1
