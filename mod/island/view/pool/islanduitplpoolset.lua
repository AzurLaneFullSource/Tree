local var0_0 = class("IslandUITplPoolSet", import(".IslandRootTplPool"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1.root = arg1_1
	arg0_1.pool = IslandUIPool.New(arg0_1.root, arg2_1, typeof(GameObject), arg4_1, arg5_1)
end

return var0_0
