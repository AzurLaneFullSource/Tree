local var0_0 = class("MeixiT2FramePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	for iter0_1, iter1_1 in ipairs(arg0_1.phases) do
		setActive(iter1_1, true)

		GetOrAddComponent(iter1_1, typeof(CanvasGroup)).alpha = 0
	end

	var0_0.super.OnFirstFlush(arg0_1)
end

function var0_0.Switch(arg0_2, arg1_2)
	arg0_2.isSwitching = true

	setToggleEnabled(arg0_2.switchBtn, false)

	local var0_2
	local var1_2

	if arg1_2 then
		var0_2, var1_2 = arg0_2.phases[1], arg0_2.phases[2]
	else
		var0_2, var1_2 = arg0_2.phases[2], arg0_2.phases[1]
	end

	local var2_2 = var0_2.localPosition
	local var3_2 = var1_2.localPosition

	var1_2:SetAsLastSibling()

	local var4_2 = {}

	table.insert(var4_2, function(arg0_3)
		LeanTween.moveLocal(go(var0_2), var3_2, 0.4)
		LeanTween.alphaCanvas(GetOrAddComponent(var0_2, typeof(CanvasGroup)), 0, 0.4)
		LeanTween.moveLocal(go(var1_2), var2_2, 0.4)
		LeanTween.alphaCanvas(GetOrAddComponent(var1_2, typeof(CanvasGroup)), 1, 0.4):setOnComplete(System.Action(arg0_3))
	end)
	seriesAsync(var4_2, function()
		arg0_2.isSwitching = nil

		setToggleEnabled(arg0_2.switchBtn, true)
	end)
end

return var0_0
