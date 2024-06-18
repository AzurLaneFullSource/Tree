local var0_0 = require("Mgr/Pool/PoolUtil")
local var1_0 = class("PoolObjPack")

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1.type = arg1_1
	arg0_1.items = {}
end

function var1_0.Get(arg0_2, arg1_2)
	return arg0_2.items[arg1_2]
end

function var1_0.Set(arg0_3, arg1_3, arg2_3)
	arg0_3.items[arg1_3] = arg2_3
end

function var1_0.Remove(arg0_4, arg1_4)
	return table.removebykey(arg0_4.items, arg1_4)
end

function var1_0.GetAmount(arg0_5)
	return table.getCount(arg0_5.items)
end

function var1_0.Clear(arg0_6)
	arg0_6.items = nil
end

return var1_0
