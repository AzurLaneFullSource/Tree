local var0 = class("YingxiV3FramePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.gotTag = arg0:findTF("AD/switcher/phase2/got")
end

function var0.Switch(arg0, arg1)
	arg0.isSwitching = true

	local var0
	local var1

	if arg1 then
		var0, var1 = arg0.phases[1], arg0.phases[2]
	else
		var0, var1 = arg0.phases[2], arg0.phases[1]
	end

	local var2 = GetOrAddComponent(var0, typeof(CanvasGroup))
	local var3 = var0.localPosition
	local var4 = var1.localPosition

	var1:SetAsLastSibling()
	setActive(var0:Find("Image"), false)
	setLocalPosition(go(var0), var4)
	setActive(var0:Find("label"), true)
	LeanTween.value(go(var0), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var2.alpha = arg0
	end))
	setActive(var1:Find("Image"), true)

	local var5 = GetOrAddComponent(var1, typeof(CanvasGroup))

	LeanTween.value(go(var1), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var5.alpha = arg0
	end))
	setActive(var1:Find("label"), false)
	setLocalPosition(go(var1), var3)

	arg0.isSwitching = nil
end

return var0
