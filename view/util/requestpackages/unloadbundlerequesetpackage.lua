local var0_0 = class("UnloadBundleRequesetPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	ResourceMgr.Inst:ClearBundleRef(arg0_1.path, true, true)

	return arg0_1
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.path = arg1_2
end

return var0_0
