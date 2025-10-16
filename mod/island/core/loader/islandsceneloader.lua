local var0_0 = class("IslandSceneLoader")

function var0_0.Load(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.sceneIndex = arg4_1 or 1

	pg.UIMgr.GetInstance():LoadingOn(false)

	local var0_1 = {
		function(arg0_2)
			arg0_1:LoadProgressUI(arg2_1, arg0_2)
		end,
		function(arg0_3)
			arg0_1:LoadScene(arg1_1, arg0_3)
		end,
		function(arg0_4)
			onNextTick(arg0_4)
		end,
		function(arg0_5)
			arg0_1:LoadNavigationMesh(arg2_1, arg0_5)
		end,
		function(arg0_6)
			onNextTick(arg0_6)
		end,
		function(arg0_7)
			onNextTick(arg0_7)
		end
	}

	for iter0_1 = #arg3_1, 1, -1 do
		table.insert(var0_1, #var0_1, arg3_1[iter0_1])
	end

	seriesAsync(var0_1, function()
		gcAll(true)
		arg0_1:UnloadProgressUI()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.LoadProgressUI(arg0_9, arg1_9, arg2_9)
	local var0_9 = "Dorm3DLoading"

	if var0_0.lastMapId and arg1_9 then
		var0_9 = (pg.island_map[var0_0.lastMapId].loading == 1 or pg.island_map[arg1_9].loading == 1) and "IslandplaneLoading" or "IslandcarLoading"
	end

	var0_0.lastMapId = arg1_9

	pg.SceneAnimMgr.GetInstance():CommonSceneChange(var0_9, function(arg0_10)
		arg0_9.resumeCallback = arg0_10

		return arg2_9()
	end)
end

function var0_0.UnloadProgressUI(arg0_11)
	local var0_11 = arg0_11.resumeCallback

	arg0_11.resumeCallback = nil

	existCall(var0_11)
end

function var0_0.LoadSceneWithProgress(arg0_12, arg1_12, arg2_12)
	local var0_12 = string.lower(arg1_12)
	local var1_12 = string.match(var0_12, "[^/]+$")
	local var2_12 = var0_12 .. "_scene"

	arg0_12.scenePath = var2_12
	arg0_12.sceneName = var1_12

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var2_12, var1_12, LoadSceneMode.Additive, function(arg0_13)
		if arg0_13 == 1 then
			SceneOpMgr.Inst:SetActiveSceneByIndex(arg0_12.sceneIndex)
		end

		arg2_12(arg0_13)
	end)
end

function var0_0.LoadScene(arg0_14, arg1_14, arg2_14)
	arg0_14:LoadSceneWithProgress(arg1_14, function(arg0_15)
		if arg0_15 == 1 then
			existCall(arg2_14)
		end
	end)
end

function var0_0.LoadNavigationMesh(arg0_16, arg1_16, arg2_16)
	if not arg1_16 then
		arg2_16()

		return
	end

	arg0_16.navMeshLoadingId = IslandAssetLoadDispatcher.Instance:Enqueue("island/Navmesh/" .. arg1_16, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_17)
		assert(arg0_17, "导航网格不能为空>>>>>" .. arg1_16)

		arg0_16.navMeshInstId = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_17, function(arg0_18)
			arg2_16()
		end)
	end), true, true)
end

function var0_0.UnLoad(arg0_19, arg1_19)
	arg0_19:UnloadProgressUI()

	local var0_19 = arg0_19.scenePath
	local var1_19 = arg0_19.sceneName

	if not var0_19 or not var1_19 then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	SceneOpMgr.Inst:UnloadSceneAsync(var0_19, var1_19, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)

	arg0_19.scenePath = nil
	arg0_19.sceneName = nil
end

function var0_0.Dispose(arg0_21, arg1_21)
	arg0_21:UnLoad(arg1_21)

	if arg0_21.navMeshInstId then
		FrameAsyncInstantiateManager.Instance:Cancel(arg0_21.navMeshInstId)

		arg0_21.navMeshInstId = nil
	end

	if arg0_21.navMeshLoadingId then
		IslandAssetLoadDispatcher.Instance:Cancel(arg0_21.navMeshLoadingId)

		arg0_21.navMeshLoadingId = nil
	end
end

return var0_0
