local var0 = require("Mgr/Pool/PoolUtil")
local var1 = class("PoolSingleton")

function var1.Ctor(arg0, arg1)
	arg0.prefab = arg1
	arg0.index = 0
end

function var1.Clear(arg0)
	var0.Destroy(arg0.prefab)

	arg0.prefab = nil
	arg0.index = 0
end

return var1
