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
		end,
		function(arg0_8)
			IslandHelper.RunGC(true)
			onNextTick(arg0_8)
		end,
		function(arg0_9)
			onNextTick(arg0_9)
		end
	}

	for iter0_1 = 1, #arg3_1 do
		table.insert(var0_1, #var0_1, arg3_1[iter0_1])
	end

	seriesAsync(var0_1, function()
		arg0_1:UnloadProgressUI()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.LoadProgressUI(arg0_11, arg1_11, arg2_11)
	local var0_11 = "Dorm3DLoading"

	if var0_0.lastMapId and arg1_11 then
		var0_11 = (pg.island_map[var0_0.lastMapId].loading == 1 or pg.island_map[arg1_11].loading == 1) and "IslandplaneLoading" or "IslandcarLoading"
	end

	var0_0.lastMapId = arg1_11

	pg.SceneAnimMgr.GetInstance():CommonSceneChange(var0_11, function(arg0_12)
		arg0_11.resumeCallback = arg0_12

		return arg2_11()
	end)
end

function var0_0.UnloadProgressUI(arg0_13)
	local var0_13 = arg0_13.resumeCallback

	arg0_13.resumeCallback = nil

	existCall(var0_13)
end

function var0_0.LoadSceneWithProgress(arg0_14, arg1_14, arg2_14)
	local var0_14 = string.lower(arg1_14)
	local var1_14 = string.match(var0_14, "[^/]+$")
	local var2_14 = var0_14 .. "_scene"

	arg0_14.scenePath = var2_14
	arg0_14.sceneName = var1_14

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var2_14, var1_14, LoadSceneMode.Additive, function(arg0_15)
		if arg0_15 == 1 then
			SceneOpMgr.Inst:SetActiveSceneByIndex(arg0_14.sceneIndex)
		end

		arg2_14(arg0_15)
	end)
end

function var0_0.LoadScene(arg0_16, arg1_16, arg2_16)
	arg0_16:LoadSceneWithProgress(arg1_16, function(arg0_17)
		if arg0_17 == 1 then
			existCall(arg2_16)
		end
	end)
end

function var0_0.LoadNavigationMesh(arg0_18, arg1_18, arg2_18)
	if not arg1_18 then
		arg2_18()

		return
	end

	if arg1_18 == IslandConst.CheaterTavernMapId then
		arg2_18()

		return
	end

	arg0_18.navMeshLoadingId = IslandAssetLoadDispatcher.Instance:Enqueue("island/Navmesh/" .. arg1_18, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_19)
		assert(arg0_19, "导航网格不能为空>>>>>" .. arg1_18)

		arg0_18.navMeshInstId = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_19, function(arg0_20)
			arg2_18()
		end)
	end), true, true)
end

function var0_0.UnLoad(arg0_21, arg1_21)
	arg0_21:UnloadProgressUI()

	local var0_21 = arg0_21.scenePath
	local var1_21 = arg0_21.sceneName

	if not var0_21 or not var1_21 then
		return
	end

	SceneOpMgr.Inst:UnloadSceneAsync(var0_21, var1_21, function()
		return
	end)

	arg0_21.scenePath = nil
	arg0_21.sceneName = nil
end

function var0_0.Dispose(arg0_23, arg1_23)
	arg0_23:UnLoad(arg1_23)

	if arg0_23.navMeshInstId then
		FrameAsyncInstantiateManager.Instance:Cancel(arg0_23.navMeshInstId)

		arg0_23.navMeshInstId = nil
	end

	if arg0_23.navMeshLoadingId then
		IslandAssetLoadDispatcher.Instance:Cancel(arg0_23.navMeshLoadingId)

		arg0_23.navMeshLoadingId = nil
	end
end

return var0_0
