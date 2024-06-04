local var0 = class("LoadLive2dRequestPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	ResourceMgr.Inst:getAssetAsync(arg0.path, arg0.name, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.stopped then
			return
		end

		if arg0.onLoaded then
			local var0 = Object.Instantiate(arg0)

			arg0.onLoaded(var0)
		end
	end), true, true)

	return arg0
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.path = arg1
	arg0.name = arg2
	arg0.onLoaded = arg3
end

return var0
