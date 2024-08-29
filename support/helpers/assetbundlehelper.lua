AssetBundleHelper = {}

local var0_0 = AssetBundleHelper

var0_0.abMetatable = {
	__index = {
		LoadAssetSync = function(arg0_1, ...)
			if EDITOR_TOOL then
				return ResourceMgr.Inst:getAssetSync(arg0_1.path, ...)
			else
				return ResourceMgr.Inst:LoadAssetSync(arg0_1.ab, ...)
			end
		end,
		GetAllAssetNames = function(arg0_2, ...)
			if EDITOR_TOOL then
				return ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "GetAssetBundleAllAssetNames", ResourceMgr.Inst, {
					typeof("System.String")
				}, {
					arg0_2.path
				})
			else
				return arg0_2.ab:GetAllAssetNames(...)
			end
		end
	}
}

function var0_0.loadAssetBundleSync(arg0_3)
	local var0_3 = setmetatable({
		path = arg0_3
	}, var0_0.abMetatable)

	if EDITOR_TOOL then
		return var0_3
	else
		var0_3.ab = ResourceMgr.Inst:loadAssetBundleSync(arg0_3)

		return var0_3
	end
end

function var0_0.loadAssetBundleAsync(arg0_4, arg1_4)
	local var0_4 = setmetatable({
		path = arg0_4
	}, var0_0.abMetatable)

	if EDITOR_TOOL then
		onNextTick(function()
			arg1_4(var0_4)
		end)
	else
		ResourceMgr.Inst:loadAssetBundleAsync(arg0_4, function(arg0_6)
			var0_4.ab = arg0_6

			arg1_4(var0_4)
		end)
	end
end

function var0_0.loadAssetBundleTotallyAsync(arg0_7, arg1_7)
	local var0_7 = setmetatable({
		path = arg0_7
	}, var0_0.abMetatable)

	if EDITOR_TOOL then
		onNextTick(function()
			arg1_7(var0_7)
		end)
	else
		ResourceMgr.Inst:loadAssetBundleTotallyAsync(arg0_7, function(arg0_9)
			var0_7.ab = arg0_9

			arg1_7(var0_7)
		end)
	end
end

return var0_0
