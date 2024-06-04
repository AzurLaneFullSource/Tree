local var0 = class("DexiV4FramePage", import(".TemplatePage.FrameTemplatePage"))

function var0.Switch(arg0, arg1)
	arg0.isSwitching = true

	local var0 = GetOrAddComponent(arg0.phases[1], typeof(CanvasGroup))
	local var1 = arg0.phases[1].localPosition
	local var2 = arg0.phases[2].localPosition

	arg0.phases[2]:SetAsLastSibling()
	setActive(arg0.phases[1]:Find("Image"), false)
	setLocalPosition(go(arg0.phases[1]), var2)
	setActive(arg0.phases[1]:Find("label"), true)
	LeanTween.value(go(arg0.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end))
	setActive(arg0.phases[2]:Find("Image"), true)

	local var3 = GetOrAddComponent(arg0.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var3.alpha = arg0
	end))
	setActive(arg0.phases[2]:Find("label"), false)
	setLocalPosition(go(arg0.phases[2]), var1)

	arg0.isSwitching = nil
	arg0.phases[1], arg0.phases[2] = arg0.phases[2], arg0.phases[1]

	arg0:UpdateAwardGot()
end

return var0
