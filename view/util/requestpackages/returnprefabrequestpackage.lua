local var0_0 = class("ReturnPrefabRequestPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	if arg0_1.callback then
		arg0_1.callback(arg0_1.go)
	end

	PoolMgr.GetInstance():ReturnPrefab(arg0_1.path, arg0_1.name, arg0_1.go, true)

	return arg0_1
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.path = arg1_2
	arg0_2.name = arg2_2
	arg0_2.go = arg3_2
	arg0_2.callback = arg4_2
end

return var0_0
