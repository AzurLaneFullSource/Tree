local var0_0 = class("ReturnSpineRequestPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	if arg0_1.callback then
		arg0_1.callback(arg0_1.model)
	end

	pg.PoolMgr.GetInstance():ReturnSpineChar(arg0_1.name, arg0_1.model)

	return arg0_1
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.path = "Spine"
	arg0_2.name = arg1_2
	arg0_2.model = arg2_2
	arg0_2.callback = arg3_2
end

return var0_0
