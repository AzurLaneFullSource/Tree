local var0_0 = class("LoadLive2dRequestPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	ResourceMgr.Inst:getAssetAsync(arg0_1.path, arg0_1.name, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_2)
		if arg0_1.stopped then
			return
		end

		if arg0_1.onLoaded then
			local var0_2 = Object.Instantiate(arg0_2)

			arg0_1.onLoaded(var0_2)
		end
	end), true, true)

	return arg0_1
end

function var0_0.Ctor(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3.path = arg1_3
	arg0_3.name = arg2_3
	arg0_3.onLoaded = arg3_3
end

return var0_0
