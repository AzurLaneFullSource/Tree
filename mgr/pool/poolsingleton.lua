local var0_0 = require("Mgr/Pool/PoolUtil")
local var1_0 = class("PoolSingleton")

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1.prefab = arg1_1
	arg0_1.index = 0
end

function var1_0.Clear(arg0_2)
	var0_0.Destroy(arg0_2.prefab)

	arg0_2.prefab = nil
	arg0_2.index = 0
end

return var1_0
