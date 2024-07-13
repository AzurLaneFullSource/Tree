local var0_0 = class("DestroyAtlasPoolRequestPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	if arg0_1.callback then
		arg0_1.callback(arg0_1.path)
	end

	PoolMgr.GetInstance():DestroySprite(arg0_1.path)

	return arg0_1
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2.path = arg1_2
	arg0_2.name = ""
	arg0_2.callback = arg2_2
end

return var0_0
