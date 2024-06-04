local var0 = class("DestroyAtlasPoolRequestPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	if arg0.callback then
		arg0.callback(arg0.path)
	end

	PoolMgr.GetInstance():DestroySprite(arg0.path)

	return arg0
end

function var0.Ctor(arg0, arg1, arg2)
	arg0.path = arg1
	arg0.name = ""
	arg0.callback = arg2
end

return var0
