local var0_0 = class("IslandMiniGameSceneLoader")

function var0_0.Load(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.sceneIndex = arg4_1 or 1

	pg.UIMgr.GetInstance():LoadingOn(false)

	local var0_1 = {
		function(arg0_2)
			arg0_1:LoadScene(arg1_1, arg0_2)
		end,
		function(arg0_3)
			onNextTick(arg0_3)
		end,
		function(arg0_4)
			onNextTick(arg0_4)
		end,
		function(arg0_5)
			onNextTick(arg0_5)
		end
	}

	for iter0_1 = 1, #arg3_1 do
		table.insert(var0_1, #var0_1, arg3_1[iter0_1])
	end

	seriesAsync(var0_1, function()
		gcAll(true)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.LoadSceneWithProgress(arg0_7, arg1_7, arg2_7)
	local var0_7 = string.lower(arg1_7)
	local var1_7 = string.match(var0_7, "[^/]+$")
	local var2_7 = var0_7 .. "_scene"

	arg0_7.scenePath = var2_7
	arg0_7.sceneName = var1_7

	SceneOpBackgroundMgr.Inst:LoadSceneAsyncWithProgress(var2_7, var1_7, LoadSceneMode.Additive, function(arg0_8)
		if arg0_8 == 1 then
			onNextTick(function()
				SceneOpBackgroundMgr.Inst:ActivatePendingScene()
				onNextTick(function()
					if CheatTavernCameraMgr.instance then
						CheatTavernCameraMgr.instance._mainCamera.enabled = false
					end
				end)
			end)
		end

		arg2_7(arg0_8)
	end)
end

function var0_0.LoadScene(arg0_11, arg1_11, arg2_11)
	arg0_11:LoadSceneWithProgress(arg1_11, function(arg0_12)
		if arg0_12 == 1 then
			existCall(arg2_11)
		end
	end)
end

function var0_0.UnLoad(arg0_13, arg1_13)
	local var0_13 = arg0_13.scenePath
	local var1_13 = arg0_13.sceneName

	if not var0_13 or not var1_13 then
		return
	end

	if not arg1_13 then
		pg.UIMgr.GetInstance():LoadingOn()
		SceneOpMgr.Inst:UnloadSceneAsync(var0_13, var1_13, function()
			pg.UIMgr.GetInstance():LoadingOff()
		end)
	else
		SceneOpMgr.Inst:UnloadSceneAsync(var0_13, var1_13, function()
			return
		end)
	end

	arg0_13.scenePath = nil
	arg0_13.sceneName = nil
end

function var0_0.ActivatePendingScene(arg0_16)
	return
end

function var0_0.Dispose(arg0_17, arg1_17)
	arg0_17:UnLoad(arg1_17)
end

return var0_0
