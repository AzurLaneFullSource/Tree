local var0 = class("ReturnSpineRequestPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	if arg0.callback then
		arg0.callback(arg0.model)
	end

	pg.PoolMgr.GetInstance():ReturnSpineChar(arg0.name, arg0.model)

	return arg0
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.path = "Spine"
	arg0.name = arg1
	arg0.model = arg2
	arg0.callback = arg3
end

return var0
