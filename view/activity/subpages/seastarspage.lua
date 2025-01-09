local var0_0 = class("SeaStarsPage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	SetActive(arg0_1.switchBtn, fasle)

	for iter0_1, iter1_1 in ipairs(arg0_1.phases) do
		setActive(iter1_1, true)

		GetOrAddComponent(iter1_1, typeof(CanvasGroup)).alpha = 0
	end

	var0_0.super.OnFirstFlush(arg0_1)
end

function var0_0.Switch(arg0_2, arg1_2)
	local var0_2
	local var1_2
	local var2_2, var3_2 = arg0_2.phases[1], arg0_2.phases[2]
	local var4_2 = var2_2.localPosition
	local var5_2 = var3_2.localPosition

	var3_2:SetAsLastSibling()

	local var6_2 = {}

	table.insert(var6_2, function(arg0_3)
		LeanTween.moveLocal(go(var2_2), var5_2, 0.4)
		LeanTween.alphaCanvas(GetOrAddComponent(var2_2, typeof(CanvasGroup)), 0, 0.4)
		LeanTween.moveLocal(go(var3_2), var4_2, 0.4)
		LeanTween.alphaCanvas(GetOrAddComponent(var3_2, typeof(CanvasGroup)), 1, 0.4):setOnComplete(System.Action(arg0_3))
	end)
	seriesAsync(var6_2, function()
		setToggleEnabled(arg0_2.switchBtn, true)
	end)
end

return var0_0
