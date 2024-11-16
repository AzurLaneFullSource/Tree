AssetBundleHelper = {}

local var0_0 = AssetBundleHelper

function var0_0.GetClass()
	if EDITOR_TOOL then
		return pg.AssetBundleEditor
	else
		return pg.AssetBundle
	end
end

function var0_0.LoadAssetBundle(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = var0_0.GetClass().New(string.lower(arg0_2))

	var0_2:Load(arg1_2, arg2_2, arg3_2)

	return var0_2
end

function var0_0.UnloadAssetBundle(arg0_3, arg1_3, arg2_3)
	if EDITOR_TOOL then
		-- block empty
	else
		ResourceMgr.Inst:ClearBundleRef(arg0_3, defaultValue(arg1_3, false), defaultValue(arg2_3, false))
	end
end

function var0_0.AutoUnloadAssetBundle(arg0_4, arg1_4)
	onNextTick(function()
		if arg1_4 then
			arg0_4:ClearDependenciesBundle()
		else
			arg0_4:Dispose()
		end
	end)
end

function var0_0.LoadAsset(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6, arg5_6)
	if arg3_6 then
		AssetBundleHelper.LoadAssetBundle(arg0_6, arg3_6, true, function(arg0_7)
			arg0_7:LoadAssetAsync(arg1_6, arg2_6, function(arg0_8)
				arg4_6(arg0_8)
				var0_0.AutoUnloadAssetBundle(arg0_7, arg5_6)
			end, false, false)
		end)
	else
		local var0_6 = AssetBundleHelper.LoadAssetBundle(arg0_6, arg3_6, true)
		local var1_6 = var0_6:LoadAssetSync(arg1_6, arg2_6, false, false)

		existCall(arg4_6, var1_6)
		var0_0.AutoUnloadAssetBundle(var0_6, arg5_6)

		return var1_6
	end
end

function var0_0.LoadManyAssets(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9)
	local var0_9 = {}

	if arg3_9 then
		AssetBundleHelper.LoadAssetBundle(arg0_9, arg3_9, true, function(arg0_10)
			parallelAsync(underscore.map(arg1_9, function(arg0_11)
				return function(arg0_12)
					arg0_10:LoadAssetAsync(arg0_11, arg2_9, function(arg0_13)
						var0_9[arg0_11] = arg0_13

						arg0_12()
					end, false, false)
				end
			end), function()
				arg4_9(var0_9)
				var0_0.AutoUnloadAssetBundle(arg0_10, arg5_9)
			end)
		end)
	else
		local var1_9 = AssetBundleHelper.LoadAssetBundle(arg0_9, arg3_9, true)

		for iter0_9, iter1_9 in ipairs(arg1_9) do
			var0_9[iter1_9] = var1_9:LoadAssetSync(iter1_9, arg2_9, false, false)
		end

		existCall(arg4_9, var0_9)
		var0_0.AutoUnloadAssetBundle(var1_9, arg5_9)

		return var0_9
	end
end

local var1_0 = {}

function var0_0.StoreAssetBundle(arg0_15, arg1_15, arg2_15, arg3_15)
	var1_0[arg0_15] = var1_0[arg0_15] or {}

	table.insert(var1_0[arg0_15], var0_0.LoadAssetBundle(arg0_15, arg1_15, arg2_15, arg3_15))
end

function var0_0.UnstoreAssetBundle(arg0_16, arg1_16)
	table.remove(var1_0[arg0_16]):Dispose(arg1_16)
end

var0_0.bundleDic = {}
var0_0.bundleCount = 0

function var0_0.BuildAssetNameDic(arg0_17, arg1_17)
	if var0_0.bundleDic[arg0_17] then
		return
	end

	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(arg1_17) do
		local var1_17 = string.lower(iter1_17)

		var0_17[var1_17] = iter1_17

		local var2_17 = GetFileName(var1_17)

		var0_17[var2_17] = iter1_17

		local var3_17 = string.split(var2_17, ".")[1]

		if var3_17 then
			var0_17[var3_17] = iter1_17
		end
	end

	if var0_0.bundleCount > 500 then
		var0_0.bundleCount = 0
		var0_0.bundleDic = {}
	end

	var0_0.bundleCount = var0_0.bundleCount + 1
	var0_0.bundleDic[arg0_17] = var0_17
end

return var0_0
