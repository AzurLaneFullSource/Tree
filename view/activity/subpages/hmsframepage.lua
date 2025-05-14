local var0_0 = class("HMSFramePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.Switch(arg0_1, arg1_1)
	local var0_1
	local var1_1

	if arg1_1 then
		var0_1, var1_1 = arg0_1.phases[1], arg0_1.phases[2]
	else
		var0_1, var1_1 = arg0_1.phases[2], arg0_1.phases[1]
	end

	local var2_1 = GetOrAddComponent(var0_1, typeof(CanvasGroup))
	local var3_1 = var0_1.localPosition
	local var4_1 = var1_1.localPosition

	var1_1:SetAsLastSibling()
	setActive(var0_1:Find("Image"), false)
	setActive(var0_1:Find("label"), true)
	setActive(var1_1:Find("Image"), true)
	setActive(var1_1:Find("label"), false)
end

return var0_0
