local var0_0 = class("IslandSceneLoader")

function var0_0.Load(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.sceneIndex = arg3_1 or 1

	pg.UIMgr.GetInstance():LoadingOn(false)
	seriesAsync({
		function(arg0_2)
			arg0_1:LoadProgressUI(arg0_2)
		end,
		function(arg0_3)
			arg0_1:LoadScene(arg1_1, arg0_3)
		end,
		arg2_1,
		function(arg0_4)
			arg0_1:UnloadProgressUI()
			arg0_4()
		end
	}, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.LoadProgressUI(arg0_6, arg1_6)
	ResourceMgr.Inst:getAssetAsync("ui/IslandSceneLoader", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
		arg0_6.progressUI = Object.Instantiate(arg0_7, pg.UIMgr.GetInstance().UIMain)
		arg0_6.bg = arg0_6.progressUI.transform:Find("bg")
		arg0_6.curtain = arg0_6.progressUI.transform:Find("curtain")

		setActive(arg0_6.progressUI, true)
		arg1_6()
	end), true, true)
end

function var0_0.UnloadProgressUI(arg0_8)
	if arg0_8.progressUI then
		Object.Destroy(arg0_8.progressUI)

		arg0_8.progressUI = nil
	end
end

function var0_0.LoadSceneWithProgress(arg0_9, arg1_9, arg2_9)
	local var0_9 = string.lower(arg1_9)
	local var1_9 = string.match(var0_9, "[^/]+$")
	local var2_9 = var0_9 .. "_scene"

	arg0_9.scenePath = var2_9
	arg0_9.sceneName = var1_9

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var2_9, var1_9, LoadSceneMode.Additive, function(arg0_10)
		arg2_9(arg0_10)

		if arg0_10 == 1 then
			SceneOpMgr.Inst:SetActiveSceneByIndex(arg0_9.sceneIndex)
		end
	end)
end

function var0_0.LoadScene(arg0_11, arg1_11, arg2_11)
	setActive(arg0_11.bg, true)
	setActive(arg0_11.curtain, false)

	local var0_11 = arg0_11.bg:Find("slider/bar"):GetComponent(typeof(Image))

	var0_11.fillAmount = 0

	arg0_11:LoadSceneWithProgress(arg1_11, function(arg0_12)
		LeanTween.cancel(var0_11.gameObject)

		local var0_12 = LeanTween.value(var0_11.gameObject, var0_11.fillAmount, arg0_12, 0.5):setOnUpdate(System.Action_float(function(arg0_13)
			var0_11.fillAmount = arg0_13
		end))

		if arg0_12 == 1 then
			var0_12:setOnComplete(System.Action(arg2_11))
		end
	end)
end

function var0_0.UnLoad(arg0_14, arg1_14)
	arg0_14:UnloadProgressUI()

	local var0_14 = arg0_14.scenePath
	local var1_14 = arg0_14.sceneName

	if not var0_14 or not var1_14 then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	SceneOpMgr.Inst:UnloadSceneAsync(var0_14, var1_14, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)

	arg0_14.scenePath = nil
	arg0_14.sceneName = nil
end

function var0_0.Dispose(arg0_16, arg1_16)
	arg0_16:UnLoad(arg1_16)
end

return var0_0
