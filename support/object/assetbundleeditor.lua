pg = pg or {}

local var0_0 = pg
local var1_0 = class("AssetBundle", var0_0.AssetBundle)

var0_0.AssetBundleEditor = var1_0

function var1_0.Load(arg0_1, arg1_1, arg2_1, arg3_1)
	assert(not arg0_1.ab)

	arg0_1.abs = {}

	if arg1_1 then
		onNextTick(function()
			existCall(arg3_1, arg0_1)
		end)
	else
		existCall(arg3_1, arg0_1)

		return arg0_1
	end
end

function var1_0.LoadAssetSync(arg0_3, arg1_3, ...)
	arg1_3 = arg0_3:ChangeAssetName(arg1_3)

	return ResourceMgr.Inst:getAssetSync(arg0_3.path, arg1_3, ...)
end

function var1_0.LoadAssetAsync(arg0_4, arg1_4, arg2_4, arg3_4, ...)
	arg1_4 = arg0_4:ChangeAssetName(arg1_4)

	return ResourceMgr.Inst:getAssetAsync(arg0_4.path, arg1_4, arg2_4, UnityEngine.Events.UnityAction_UnityEngine_Object(arg3_4), ...)
end

function var1_0.GetAllAssetNames(arg0_5)
	return table.CArrayToArray(ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "GetAssetBundleAllAssetNames", ResourceMgr.Inst, {
		typeof("System.String")
	}, {
		arg0_5.path
	}))
end
