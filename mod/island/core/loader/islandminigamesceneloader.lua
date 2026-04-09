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
			-- block empty
		end

		arg2_7(arg0_8)
	end)
end

function var0_0.LoadScene(arg0_9, arg1_9, arg2_9)
	arg0_9:LoadSceneWithProgress(arg1_9, function(arg0_10)
		if arg0_10 == 1 then
			existCall(arg2_9)
		end
	end)
end

function var0_0.UnLoad(arg0_11, arg1_11)
	local var0_11 = arg0_11.scenePath
	local var1_11 = arg0_11.sceneName

	if not var0_11 or not var1_11 then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	SceneOpMgr.Inst:UnloadSceneAsync(var0_11, var1_11, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)

	arg0_11.scenePath = nil
	arg0_11.sceneName = nil
end

function var0_0.ActivatePendingScene(arg0_13)
	SceneOpBackgroundMgr.Inst:ActivatePendingScene()
end

function var0_0.Dispose(arg0_14, arg1_14)
	arg0_14:UnLoad(arg1_14)
end

return var0_0
