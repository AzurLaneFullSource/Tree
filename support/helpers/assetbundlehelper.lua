AssetBundleHelper = {}

local var0_0 = AssetBundleHelper

var0_0.abMetatable = {
	__index = {
		LoadAssetSync = function(arg0_1, arg1_1, ...)
			arg1_1 = arg0_1:ChangeAssetName(arg1_1)

			if EDITOR_TOOL then
				return ResourceMgr.Inst:getAssetSync(arg0_1.path, arg1_1, ...)
			else
				return ResourceMgr.Inst:LoadAssetSync(arg0_1.ab, arg1_1, ...)
			end
		end,
		LoadAssetAsync = function(arg0_2, arg1_2, arg2_2, arg3_2, ...)
			arg1_2 = arg0_2:ChangeAssetName(arg1_2)

			if EDITOR_TOOL then
				return ResourceMgr.Inst:getAssetAsync(arg0_2.path, arg1_2, arg2_2, UnityEngine.Events.UnityAction_UnityEngine_Object(arg3_2), ...)
			else
				return ResourceMgr.Inst:LoadAssetAsync(arg0_2.ab, arg1_2, arg2_2, UnityEngine.Events.UnityAction_UnityEngine_Object(arg3_2), ...)
			end
		end,
		GetAllAssetNames = function(arg0_3)
			if EDITOR_TOOL then
				return table.CArrayToArray(ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "GetAssetBundleAllAssetNames", ResourceMgr.Inst, {
					typeof("System.String")
				}, {
					arg0_3.path
				}))
			else
				return table.CArrayToArray(arg0_3.ab:GetAllAssetNames())
			end
		end,
		ChangeAssetName = function(arg0_4, arg1_4)
			if arg1_4 == nil or arg1_4 == "" or string.find(arg1_4, "/") then
				return arg1_4 or ""
			elseif not var0_0.bundleDic[arg0_4.path] then
				arg0_4:BuildAssetNameDic()
			end

			return var0_0.bundleDic[arg0_4.path][string.lower(arg1_4)] or arg1_4
		end,
		BuildAssetNameDic = function(arg0_5)
			if var0_0.bundleDic[arg0_5.path] then
				return
			end

			var0_0.BuildAssetNameDic(arg0_5.path, arg0_5:GetAllAssetNames())
		end
	}
}

function var0_0.loadAssetBundleSync(arg0_6)
	local var0_6 = setmetatable({
		path = string.lower(arg0_6)
	}, var0_0.abMetatable)

	if EDITOR_TOOL then
		return var0_6
	else
		var0_6.ab = ResourceMgr.Inst:loadAssetBundleSync(arg0_6)

		return var0_6
	end
end

function var0_0.loadAssetBundleAsync(arg0_7, arg1_7)
	local var0_7 = setmetatable({
		path = string.lower(arg0_7)
	}, var0_0.abMetatable)

	if EDITOR_TOOL then
		onNextTick(function()
			arg1_7(var0_7)
		end)
	else
		ResourceMgr.Inst:loadAssetBundleAsync(arg0_7, function(arg0_9)
			var0_7.ab = arg0_9

			arg1_7(var0_7)
		end)
	end
end

function var0_0.loadAssetBundle(arg0_10, arg1_10, arg2_10)
	local var0_10 = setmetatable({
		path = string.lower(arg0_10)
	}, var0_0.abMetatable)

	if arg1_10 then
		if EDITOR_TOOL then
			onNextTick(function()
				arg2_10(var0_10)
			end)
		else
			ResourceMgr.Inst:loadAssetBundleAsync(arg0_10, function(arg0_12)
				var0_10.ab = arg0_12

				arg2_10(var0_10)
			end)
		end
	elseif EDITOR_TOOL then
		return var0_10
	else
		var0_10.ab = ResourceMgr.Inst:loadAssetBundleSync(arg0_10)

		existCall(arg2_10, var0_10)

		return var0_10
	end
end

function var0_0.LoadAsset(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13, arg5_13)
	if EDITOR_TOOL then
		if arg3_13 then
			AssetBundleHelper.loadAssetBundleAsync(arg0_13, function(arg0_14)
				arg0_14:LoadAssetAsync(arg1_13, arg2_13, arg4_13, arg5_13, false)
			end)
		else
			local var0_13 = AssetBundleHelper.loadAssetBundleSync(arg0_13):LoadAssetSync(arg1_13, arg2_13, arg5_13, false)

			existCall(arg4_13, var0_13)

			return var0_13
		end
	elseif arg3_13 then
		local var1_13 = table.CArrayToArray(ResourceMgr.Inst:GetAllDependencies(arg0_13))

		parallelAsync(underscore.map(var1_13, function(arg0_15)
			return function(arg0_16)
				AssetBundleHelper.loadAssetBundleAsync(arg0_15, arg0_16)
			end
		end), function()
			AssetBundleHelper.loadAssetBundleAsync(arg0_13, function(arg0_18)
				arg0_18:LoadAssetAsync(arg1_13, arg2_13, arg4_13, arg5_13, false)
				onNextTick(function()
					for iter0_19, iter1_19 in ipairs(var1_13) do
						ResourceMgr.Inst:ClearBundleRef(iter1_19, false)
					end
				end)
			end)
		end)
	else
		local var2_13 = table.CArrayToArray(ResourceMgr.Inst:GetAllDependencies(arg0_13))

		for iter0_13, iter1_13 in ipairs(var2_13) do
			AssetBundleHelper.loadAssetBundleSync(iter1_13)
		end

		local var3_13 = AssetBundleHelper.loadAssetBundleSync(arg0_13):LoadAssetSync(arg1_13, arg2_13, arg5_13, false)

		existCall(arg4_13, var3_13)
		onNextTick(function()
			for iter0_20, iter1_20 in ipairs(var2_13) do
				ResourceMgr.Inst:ClearBundleRef(iter1_20, false)
			end
		end)

		return var3_13
	end
end

var0_0.bundleDic = {}
var0_0.bundleCount = 0

function var0_0.BuildAssetNameDic(arg0_21, arg1_21)
	if var0_0.bundleDic[arg0_21] then
		return
	end

	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg1_21) do
		local var1_21 = string.lower(iter1_21)

		var0_21[var1_21] = iter1_21

		local var2_21 = GetFileName(var1_21)

		var0_21[var2_21] = iter1_21

		local var3_21 = string.split(var2_21, ".")[1]

		if var3_21 then
			var0_21[var3_21] = iter1_21
		end
	end

	if var0_0.bundleCount > 500 then
		var0_0.bundleCount = 0
		var0_0.bundleDic = {}
	end

	var0_0.bundleCount = var0_0.bundleCount + 1
	var0_0.bundleDic[arg0_21] = var0_21
end

return var0_0
