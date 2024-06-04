local var0 = class("ReturnPrefabRequestPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	if arg0.callback then
		arg0.callback(arg0.go)
	end

	PoolMgr.GetInstance():ReturnPrefab(arg0.path, arg0.name, arg0.go, true)

	return arg0
end

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.path = arg1
	arg0.name = arg2
	arg0.go = arg3
	arg0.callback = arg4
end

return var0
