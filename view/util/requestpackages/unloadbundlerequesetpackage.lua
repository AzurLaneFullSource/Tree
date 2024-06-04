local var0 = class("UnloadBundleRequesetPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	ResourceMgr.Inst:ClearBundleRef(arg0.path, true, true)

	return arg0
end

function var0.Ctor(arg0, arg1)
	arg0.path = arg1
end

return var0
