pg = pg or {}

local var0_0 = pg
local var1_0 = class("AssetBundle")

var0_0.AssetBundle = var1_0

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1.path = arg1_1
end

function var1_0.Load(arg0_2, arg1_2, arg2_2, arg3_2)
	assert(not arg0_2.ab)

	arg0_2.abs = {}

	if arg1_2 then
		seriesAsync({
			function(arg0_3)
				if not arg2_2 then
					return arg0_3()
				end

				local var0_3 = table.CArrayToArray(ResourceMgr.Inst:GetAllDependencies(arg0_2.path))

				parallelAsync(underscore.map(var0_3, function(arg0_4)
					return function(arg0_5)
						AssetBundleHelper.LoadAssetBundle(arg0_4, arg1_2, false, function(arg0_6)
							table.insert(arg0_2.abs, arg0_6)
							arg0_5()
						end)
					end
				end), arg0_3)
			end
		}, function()
			ResourceMgr.Inst:loadAssetBundleAsync(arg0_2.path, function(arg0_8)
				arg0_2.ab = arg0_8

				existCall(arg3_2, arg0_2)
			end)
		end)
	else
		if arg2_2 then
			local var0_2 = table.CArrayToArray(ResourceMgr.Inst:GetAllDependencies(arg0_2.path))

			for iter0_2, iter1_2 in ipairs(var0_2) do
				table.insert(arg0_2.abs, AssetBundleHelper.LoadAssetBundle(iter1_2, arg1_2, false, nil))
			end
		end

		arg0_2.ab = ResourceMgr.Inst:loadAssetBundleSync(arg0_2.path)

		existCall(arg3_2, arg0_2)

		return arg0_2
	end
end

function var1_0.LoadAssetSync(arg0_9, arg1_9, ...)
	arg1_9 = arg0_9:ChangeAssetName(arg1_9)

	if not arg0_9.ab then
		warning(string.format("without assetbundle:%s", arg0_9.path))

		return nil
	end

	return ResourceMgr.Inst:LoadAssetSync(arg0_9.ab, arg1_9, ...)
end

function var1_0.LoadAssetAsync(arg0_10, arg1_10, arg2_10, arg3_10, ...)
	arg1_10 = arg0_10:ChangeAssetName(arg1_10)

	if not arg0_10.ab then
		warning(string.format("without assetbundle:%s", arg0_10.path))

		return nil
	end

	return ResourceMgr.Inst:LoadAssetAsync(arg0_10.ab, arg1_10, arg2_10, UnityEngine.Events.UnityAction_UnityEngine_Object(arg3_10), ...)
end

function var1_0.GetAllAssetNames(arg0_11)
	return table.CArrayToArray(arg0_11.ab:GetAllAssetNames())
end

function var1_0.ChangeAssetName(arg0_12, arg1_12)
	if arg1_12 == nil or arg1_12 == "" or string.find(arg1_12, "/") then
		return string.lower(arg1_12 or "")
	elseif not AssetBundleHelper.bundleDic[arg0_12.path] then
		arg0_12:BuildAssetNameDic()
	end

	return AssetBundleHelper.bundleDic[arg0_12.path][string.lower(arg1_12)] or arg1_12
end

function var1_0.BuildAssetNameDic(arg0_13)
	if AssetBundleHelper.bundleDic[arg0_13.path] then
		return
	end

	AssetBundleHelper.BuildAssetNameDic(arg0_13.path, arg0_13:GetAllAssetNames())
end

function var1_0.ClearDependenciesBundle(arg0_14)
	for iter0_14, iter1_14 in ipairs(arg0_14.abs) do
		iter1_14:Dispose()
	end

	arg0_14.abs = {}
end

function var1_0.ForceClearRef(arg0_15, arg1_15)
	arg0_15:ClearDependenciesBundle()
	AssetBundleHelper.UnloadAssetBundle(arg0_15.path, arg1_15)

	arg0_15.ab = nil
end

function var1_0.Dispose(arg0_16, arg1_16)
	if arg0_16.ab then
		arg0_16:ForceClearRef(arg1_16)
	end
end
