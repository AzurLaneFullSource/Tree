local var0_0 = class("IslandSceneLoader")

function var0_0.Load(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.sceneIndex = arg4_1 or 1

	pg.UIMgr.GetInstance():LoadingOn(false)

	local var0_1 = {
		function(arg0_2)
			arg0_1:LoadProgressUI(arg2_1, arg0_2)
		end,
		function(arg0_3)
			gcAll(true)
			onNextTick(arg0_3)
		end,
		function(arg0_4)
			arg0_1:LoadScene(arg1_1, arg0_4)
		end,
		function(arg0_5)
			onNextTick(arg0_5)
		end,
		function(arg0_6)
			arg0_1:LoadNavigationMesh(arg2_1, arg0_6)
		end,
		function(arg0_7)
			onNextTick(arg0_7)
		end,
		function(arg0_8)
			arg0_1:UnloadProgressUI()
			arg0_8()
		end
	}

	for iter0_1 = #arg3_1, 1, -1 do
		table.insert(var0_1, #var0_1, arg3_1[iter0_1])
	end

	seriesAsync(var0_1, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.LoadProgressUI(arg0_10, arg1_10, arg2_10)
	local var0_10 = "Dorm3DLoading"

	if var0_0.lastMapId and arg1_10 then
		var0_10 = (pg.island_map[var0_0.lastMapId].loading == 1 or pg.island_map[arg1_10].loading == 1) and "IslandplaneLoading" or "IslandcarLoading"
	end

	var0_0.lastMapId = arg1_10

	pg.SceneAnimMgr.GetInstance():CommonSceneChange(var0_10, function(arg0_11)
		arg0_10.resumeCallback = arg0_11

		return arg2_10()
	end)
end

function var0_0.UnloadProgressUI(arg0_12)
	local var0_12 = arg0_12.resumeCallback

	arg0_12.resumeCallback = nil

	existCall(var0_12)
end

function var0_0.LoadSceneWithProgress(arg0_13, arg1_13, arg2_13)
	local var0_13 = string.lower(arg1_13)
	local var1_13 = string.match(var0_13, "[^/]+$")
	local var2_13 = var0_13 .. "_scene"

	arg0_13.scenePath = var2_13
	arg0_13.sceneName = var1_13

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var2_13, var1_13, LoadSceneMode.Additive, function(arg0_14)
		if arg0_14 == 1 then
			SceneOpMgr.Inst:SetActiveSceneByIndex(arg0_13.sceneIndex)
		end

		arg2_13(arg0_14)
	end)
end

function var0_0.LoadScene(arg0_15, arg1_15, arg2_15)
	arg0_15:LoadSceneWithProgress(arg1_15, function(arg0_16)
		if arg0_16 == 1 then
			existCall(arg2_15)
		end
	end)
end

function var0_0.LoadNavigationMesh(arg0_17, arg1_17, arg2_17)
	if not arg1_17 then
		arg2_17()

		return
	end

	arg0_17.navMeshLoadingId = IslandAssetLoadDispatcher.Instance:Enqueue("island/Navmesh/" .. arg1_17, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_18)
		assert(arg0_18, "导航网格不能为空>>>>>" .. arg1_17)

		arg0_17.navMeshInstId = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_18, function(arg0_19)
			arg2_17()
		end)
	end), true, true)
end

function var0_0.UnLoad(arg0_20, arg1_20)
	arg0_20:UnloadProgressUI()

	local var0_20 = arg0_20.scenePath
	local var1_20 = arg0_20.sceneName

	if not var0_20 or not var1_20 then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	SceneOpMgr.Inst:UnloadSceneAsync(var0_20, var1_20, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)

	arg0_20.scenePath = nil
	arg0_20.sceneName = nil
end

function var0_0.Dispose(arg0_22, arg1_22)
	arg0_22:UnLoad(arg1_22)

	if arg0_22.navMeshInstId then
		FrameAsyncInstantiateManager.Instance:Cancel(arg0_22.navMeshInstId)

		arg0_22.navMeshInstId = nil
	end

	if arg0_22.navMeshLoadingId then
		IslandAssetLoadDispatcher.Instance:Cancel(arg0_22.navMeshLoadingId)

		arg0_22.navMeshLoadingId = nil
	end
end

return var0_0
