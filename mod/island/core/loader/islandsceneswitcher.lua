local var0_0 = class("IslandSceneSwitcher", import(".IslandSceneLoader"))

function var0_0.LoadProgressUI(arg0_1, arg1_1)
	seriesAsync({
		function(arg0_2)
			var0_0.super.LoadProgressUI(arg0_1, arg0_2)
		end,
		function(arg0_3)
			arg0_1:PlayFadeIn(arg0_3)
		end
	}, arg1_1)
end

function var0_0.PlayFadeIn(arg0_4, arg1_4)
	setActive(arg0_4.bg, false)
	setActive(arg0_4.curtain, true)

	local var0_4 = GetOrAddComponent(arg0_4.curtain, typeof(CanvasGroup))

	var0_4.alpha = 0

	LeanTween.value(go(arg0_4.curtain), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_5)
		var0_4.alpha = arg0_5
	end)):setOnComplete(System.Action(arg1_4))
end

function var0_0.PlayFadeOut(arg0_6, arg1_6)
	local var0_6 = GetOrAddComponent(arg0_6.curtain, typeof(CanvasGroup))

	var0_6.alpha = 1

	LeanTween.value(go(arg0_6.curtain), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_7)
		var0_6.alpha = arg0_7
	end)):setOnComplete(System.Action(arg1_6))
end

function var0_0.LoadScene(arg0_8, arg1_8, arg2_8)
	arg0_8:LoadSceneWithProgress(arg1_8, function(arg0_9)
		if arg0_9 == 1 then
			arg0_8:PlayFadeOut(arg2_8)
		end
	end)
end

function var0_0.UnloadProgressUI(arg0_10)
	if not arg0_10.canUnloadProgressUI then
		return
	end

	var0_0.super.UnloadProgressUI(arg0_10)
end

function var0_0.UnLoad(arg0_11, arg1_11)
	if arg1_11 then
		var0_0.super.UnLoad(arg0_11)
		arg0_11:Clear()

		return
	end

	seriesAsync({
		function(arg0_12)
			arg0_11:PlayFadeIn(arg0_12)
		end,
		function(arg0_13)
			var0_0.super.UnLoad(arg0_11)
			arg0_13()
		end,
		function(arg0_14)
			arg0_11:PlayFadeOut(arg0_14)
		end
	}, function()
		arg0_11:Clear()
	end)
end

function var0_0.Clear(arg0_16)
	arg0_16.canUnloadProgressUI = true

	if LeanTween.isTweening(go(arg0_16.curtain)) then
		LeanTween.cancel(go(arg0_16.curtain))
	end

	arg0_16:UnloadProgressUI()
end

return var0_0
