local var0 = class("LoadReferenceRequestPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	ResourceMgr.Inst:getAssetAsync(arg0.path, arg0.name, arg0.type, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.stopped then
			return
		end

		if arg0.onLoaded then
			arg0.onLoaded(arg0)
		end
	end), true, false)

	return arg0
end

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.path = arg1
	arg0.name = arg2
	arg0.type = arg3
	arg0.onLoaded = arg4
end

return var0
