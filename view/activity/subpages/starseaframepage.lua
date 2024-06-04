local var0 = class("StarSeaFramePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0.OnFirstFlush(arg0)
	for iter0, iter1 in ipairs(arg0.phases) do
		setActive(iter1, true)

		GetOrAddComponent(iter1, typeof(CanvasGroup)).alpha = 0
	end

	var0.super.OnFirstFlush(arg0)
	GetComponent(arg0:findTF("AD/switcher/phase2/Image"), typeof(Image)):SetNativeSize()
	GetComponent(arg0:findTF("AD/switcher/phase1/Image"), typeof(Image)):SetNativeSize()
end

function var0.Switch(arg0, arg1)
	arg0.isSwitching = true

	setToggleEnabled(arg0.switchBtn, false)

	local var0
	local var1

	if arg1 then
		var0, var1 = arg0.phases[1], arg0.phases[2]
	else
		var0, var1 = arg0.phases[2], arg0.phases[1]
	end

	local var2 = var0.localPosition
	local var3 = var1.localPosition

	var1:SetAsLastSibling()

	local var4 = {}

	table.insert(var4, function(arg0)
		LeanTween.moveLocal(go(var0), var3, 0.4)
		LeanTween.alphaCanvas(GetOrAddComponent(var0, typeof(CanvasGroup)), 0, 0.4)
		LeanTween.moveLocal(go(var1), var2, 0.4)
		LeanTween.alphaCanvas(GetOrAddComponent(var1, typeof(CanvasGroup)), 1, 0.4):setOnComplete(System.Action(arg0))
	end)
	seriesAsync(var4, function()
		arg0.isSwitching = nil

		setToggleEnabled(arg0.switchBtn, true)
	end)
end

return var0
