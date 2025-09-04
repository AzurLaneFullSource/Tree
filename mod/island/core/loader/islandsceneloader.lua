local var0_0 = class("IslandSceneLoader")

function var0_0.Load(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.sceneIndex = arg4_1 or 1

	pg.UIMgr.GetInstance():LoadingOn(false)

	local var0_1 = {
		function(arg0_2)
			arg0_1:LoadProgressUI(arg0_2)
		end,
		function(arg0_3)
			gcAll(true)
			onNextTick(arg0_3)
		end,
		function(arg0_4)
			arg0_1:LoadScene(arg1_1, arg0_4)
		end,
		function(arg0_5)
			arg0_1:LoadNavigationMesh(arg2_1, arg0_5)
		end,
		function(arg0_6)
			arg0_1:UnloadProgressUI()
			arg0_6()
		end
	}

	for iter0_1 = #arg3_1, 1, -1 do
		table.insert(var0_1, 5, arg3_1[iter0_1])
	end

	seriesAsync(var0_1, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.LoadProgressUI(arg0_8, arg1_8)
	pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_9)
		arg0_8.resumeCallback = arg0_9

		return arg1_8()
	end)
end

function var0_0.UnloadProgressUI(arg0_10)
	local var0_10 = arg0_10.resumeCallback

	arg0_10.resumeCallback = nil

	existCall(var0_10)
end

function var0_0.LoadSceneWithProgress(arg0_11, arg1_11, arg2_11)
	local var0_11 = string.lower(arg1_11)
	local var1_11 = string.match(var0_11, "[^/]+$")
	local var2_11 = var0_11 .. "_scene"

	arg0_11.scenePath = var2_11
	arg0_11.sceneName = var1_11

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var2_11, var1_11, LoadSceneMode.Additive, function(arg0_12)
		if arg0_12 == 1 then
			SceneOpMgr.Inst:SetActiveSceneByIndex(arg0_11.sceneIndex)
		end

		arg2_11(arg0_12)
	end)
end

function var0_0.LoadScene(arg0_13, arg1_13, arg2_13)
	arg0_13:LoadSceneWithProgress(arg1_13, function(arg0_14)
		if arg0_14 == 1 then
			existCall(arg2_13)
		end
	end)
end

function var0_0.LoadNavigationMesh(arg0_15, arg1_15, arg2_15)
	if not arg1_15 then
		arg2_15()

		return
	end

	ResourceMgr.Inst:getAssetAsync("island/Navmesh/" .. arg1_15, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_16)
		assert(arg0_16, "导航网格不能为空>>>>>" .. arg1_15)
		Object.Instantiate(arg0_16)
		arg2_15()
	end), true, true)
end

function var0_0.UnLoad(arg0_17, arg1_17)
	arg0_17:UnloadProgressUI()

	local var0_17 = arg0_17.scenePath
	local var1_17 = arg0_17.sceneName

	if not var0_17 or not var1_17 then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	SceneOpMgr.Inst:UnloadSceneAsync(var0_17, var1_17, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)

	arg0_17.scenePath = nil
	arg0_17.sceneName = nil
end

function var0_0.Dispose(arg0_19, arg1_19)
	arg0_19:UnLoad(arg1_19)
end

return var0_0
