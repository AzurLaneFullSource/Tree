local var0_0 = class("DexiV4FramePage", import(".TemplatePage.FrameTemplatePage"))

function var0_0.Switch(arg0_1, arg1_1)
	arg0_1.isSwitching = true

	local var0_1 = GetOrAddComponent(arg0_1.phases[1], typeof(CanvasGroup))
	local var1_1 = arg0_1.phases[1].localPosition
	local var2_1 = arg0_1.phases[2].localPosition

	arg0_1.phases[2]:SetAsLastSibling()
	setActive(arg0_1.phases[1]:Find("Image"), false)
	setLocalPosition(go(arg0_1.phases[1]), var2_1)
	setActive(arg0_1.phases[1]:Find("label"), true)
	LeanTween.value(go(arg0_1.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_2)
		var0_1.alpha = arg0_2
	end))
	setActive(arg0_1.phases[2]:Find("Image"), true)

	local var3_1 = GetOrAddComponent(arg0_1.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0_1.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_3)
		var3_1.alpha = arg0_3
	end))
	setActive(arg0_1.phases[2]:Find("label"), false)
	setLocalPosition(go(arg0_1.phases[2]), var1_1)

	arg0_1.isSwitching = nil
	arg0_1.phases[1], arg0_1.phases[2] = arg0_1.phases[2], arg0_1.phases[1]

	arg0_1:UpdateAwardGot()
end

return var0_0
