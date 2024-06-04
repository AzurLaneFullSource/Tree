local var0 = class("SaDingFramePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.bar = arg0:findTF("AD/switcher/phase2/barContent")
	arg0.cur = arg0:findTF("AD/switcher/phase2/progress/step")
	arg0.target = arg0:findTF("AD/switcher/phase2/progress/all")
	arg0.getTag = arg0:findTF("AD/switcher/phase2/get")
	arg0.gotTag = arg0:findTF("AD/switcher/phase2/got")
	arg0.titles = {
		arg0.switchBtn:Find("2"),
		arg0.switchBtn:Find("1")
	}
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1
	local var1 = arg0.avatarConfig.target

	var0 = var1 < var0 and var1 or var0

	local var2 = var0 / var1

	setText(arg0.cur, var2 >= 1 and setColorStr(var0, COLOR_GREEN) or var0)
	setText(arg0.target, "/" .. var1)
	setSlider(arg0.bar, 0, var1, var0)

	local var3 = var1 <= var0
	local var4 = arg0.activity.data2 >= 1

	setActive(arg0.battleBtn, arg0.inPhase2 and not var3)
	setActive(arg0.getBtn, arg0.inPhase2 and not var4 and var3)
	setActive(arg0.gotBtn, arg0.inPhase2 and var4)
	setActive(arg0.getTag, arg0.inPhase2 and not var4 and var3)
	setActive(arg0.gotTag, arg0.inPhase2 and var4)
	setActive(arg0:findTF("AD/switcher/phase2/progress"), not var4)
end

function var0.Switch(arg0, arg1)
	arg0.isSwitching = true

	setToggleEnabled(arg0.switchBtn, false)

	local var0 = {}

	for iter0, iter1 in ipairs({
		arg0.phases,
		arg0.titles
	}) do
		local var1, var2 = unpack(iter1)

		if arg1 then
			var1, var2 = var2, var1
		end

		LeanTween.cancel(go(var1))

		local var3 = GetOrAddComponent(var1, "CanvasGroup")

		var3.alpha = 0

		table.insert(var0, function(arg0)
			LeanTween.alphaCanvas(var3, 1, 0.4):setOnComplete(System.Action(arg0))
		end)
		LeanTween.cancel(go(var2))

		local var4 = GetOrAddComponent(var2, "CanvasGroup")

		var4.alpha = 1

		table.insert(var0, function(arg0)
			LeanTween.alphaCanvas(var4, 0, 0.4):setOnComplete(System.Action(arg0))
		end)
	end

	parallelAsync(var0, function()
		arg0.isSwitching = nil

		setToggleEnabled(arg0.switchBtn, true)
	end)
end

return var0
