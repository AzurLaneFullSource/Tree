local var0_0 = class("YingxiV3FramePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.gotTag = arg0_1:findTF("AD/switcher/phase2/got")
end

function var0_0.Switch(arg0_2, arg1_2)
	arg0_2.isSwitching = true

	local var0_2
	local var1_2

	if arg1_2 then
		var0_2, var1_2 = arg0_2.phases[1], arg0_2.phases[2]
	else
		var0_2, var1_2 = arg0_2.phases[2], arg0_2.phases[1]
	end

	local var2_2 = GetOrAddComponent(var0_2, typeof(CanvasGroup))
	local var3_2 = var0_2.localPosition
	local var4_2 = var1_2.localPosition

	var1_2:SetAsLastSibling()
	setActive(var0_2:Find("Image"), false)
	setLocalPosition(go(var0_2), var4_2)
	setActive(var0_2:Find("label"), true)
	LeanTween.value(go(var0_2), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_3)
		var2_2.alpha = arg0_3
	end))
	setActive(var1_2:Find("Image"), true)

	local var5_2 = GetOrAddComponent(var1_2, typeof(CanvasGroup))

	LeanTween.value(go(var1_2), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_4)
		var5_2.alpha = arg0_4
	end))
	setActive(var1_2:Find("label"), false)
	setLocalPosition(go(var1_2), var3_2)

	arg0_2.isSwitching = nil
end

return var0_0
