local var0_0 = class("IslandSceneSwitcher", import(".IslandSceneLoader"))

function var0_0.LoadProgressUI(arg0_1, arg1_1)
	seriesAsync({
		function(arg0_2)
			arg0_1:LoadProgressUI(arg0_2)
		end,
		function(arg0_3)
			arg0_1:PlayFadeIn(arg0_3)
		end
	}, arg1_1)
end

function var0_0.LoadProgressUI(arg0_4, arg1_4)
	ResourceMgr.Inst:getAssetAsync("ui/IslandSceneLoader", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_5)
		arg0_4.progressUI = Object.Instantiate(arg0_5, pg.UIMgr.GetInstance().UIMain)
		arg0_4.curtain = arg0_4.progressUI.transform:Find("curtain")

		setActive(arg0_4.progressUI, true)
		arg1_4()
	end), true, true)
end

function var0_0.PlayFadeIn(arg0_6, arg1_6)
	setActive(arg0_6.curtain, true)

	local var0_6 = GetOrAddComponent(arg0_6.curtain, typeof(CanvasGroup))

	var0_6.alpha = 0

	LeanTween.value(go(arg0_6.curtain), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_7)
		var0_6.alpha = arg0_7
	end)):setOnComplete(System.Action(arg1_6))
end

function var0_0.PlayFadeOut(arg0_8, arg1_8)
	local var0_8 = GetOrAddComponent(arg0_8.curtain, typeof(CanvasGroup))

	var0_8.alpha = 1

	LeanTween.value(go(arg0_8.curtain), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_9)
		var0_8.alpha = arg0_9
	end)):setOnComplete(System.Action(arg1_8))
end

function var0_0.LoadScene(arg0_10, arg1_10, arg2_10)
	arg0_10:LoadSceneWithProgress(arg1_10, function(arg0_11)
		if arg0_11 == 1 then
			arg0_10:PlayFadeOut(arg2_10)
		end
	end)
end

function var0_0.UnloadProgressUI(arg0_12)
	if not arg0_12.canUnloadProgressUI then
		return
	end

	if arg0_12.progressUI then
		Object.Destroy(arg0_12.progressUI)

		arg0_12.progressUI = nil
	end
end

function var0_0.UnLoad(arg0_13, arg1_13)
	if arg1_13 then
		var0_0.super.UnLoad(arg0_13)
		arg0_13:Clear()

		return
	end

	seriesAsync({
		function(arg0_14)
			arg0_13:PlayFadeIn(arg0_14)
		end,
		function(arg0_15)
			var0_0.super.UnLoad(arg0_13)
			arg0_15()
		end,
		function(arg0_16)
			arg0_13:PlayFadeOut(arg0_16)
		end
	}, function()
		arg0_13:Clear()
	end)
end

function var0_0.Clear(arg0_18)
	arg0_18.canUnloadProgressUI = true

	if LeanTween.isTweening(go(arg0_18.curtain)) then
		LeanTween.cancel(go(arg0_18.curtain))
	end

	arg0_18:UnloadProgressUI()
end

return var0_0
