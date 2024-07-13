local var0_0 = class("LoadReferenceRequestPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	ResourceMgr.Inst:getAssetAsync(arg0_1.path, arg0_1.name, arg0_1.type, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_2)
		if arg0_1.stopped then
			return
		end

		if arg0_1.onLoaded then
			arg0_1.onLoaded(arg0_2)
		end
	end), true, false)

	return arg0_1
end

function var0_0.Ctor(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.path = arg1_3
	arg0_3.name = arg2_3
	arg0_3.type = arg3_3
	arg0_3.onLoaded = arg4_3
end

return var0_0
