local var0_0 = class("MeixiV5FramePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.bar = arg0_1:findTF("AD/switcher/phase2/barContent")
	arg0_1.cur = arg0_1:findTF("AD/switcher/phase2/progress/step")
	arg0_1.target = arg0_1:findTF("AD/switcher/phase2/progress/all")
	arg0_1.gotTag = arg0_1:findTF("AD/switcher/phase2/got")
	arg0_1.titles = {
		arg0_1.switchBtn:Find("2"),
		arg0_1.switchBtn:Find("1")
	}
end

function var0_0.OnUpdateFlush(arg0_2)
	local var0_2 = arg0_2.activity.data1
	local var1_2 = arg0_2.avatarConfig.target

	var0_2 = var1_2 < var0_2 and var1_2 or var0_2

	local var2_2 = var0_2 / var1_2

	setText(arg0_2.cur, var2_2 >= 1 and setColorStr(var0_2, COLOR_GREEN) or var0_2)
	setText(arg0_2.target, "/" .. var1_2)
	setSlider(arg0_2.bar, 0, var1_2, var0_2)

	local var3_2 = var1_2 <= var0_2
	local var4_2 = arg0_2.activity.data2 >= 1

	setActive(arg0_2.battleBtn, arg0_2.inPhase2 and not var3_2)
	setActive(arg0_2.getBtn, arg0_2.inPhase2 and not var4_2 and var3_2)
	setActive(arg0_2.gotBtn, arg0_2.inPhase2 and var4_2)
	setActive(arg0_2.gotTag, arg0_2.inPhase2 and var4_2)
	setActive(arg0_2:findTF("AD/switcher/phase2/progress"), not var4_2)
end

function var0_0.Switch(arg0_3, arg1_3)
	arg0_3.isSwitching = true

	setToggleEnabled(arg0_3.switchBtn, false)

	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs({
		arg0_3.phases,
		arg0_3.titles
	}) do
		local var1_3, var2_3 = unpack(iter1_3)

		if arg1_3 then
			var1_3, var2_3 = var2_3, var1_3
		end

		LeanTween.cancel(go(var1_3))

		local var3_3 = GetOrAddComponent(var1_3, "CanvasGroup")

		var3_3.alpha = 0

		table.insert(var0_3, function(arg0_4)
			LeanTween.alphaCanvas(var3_3, 1, 0.4):setOnComplete(System.Action(arg0_4))
		end)
		LeanTween.cancel(go(var2_3))

		local var4_3 = GetOrAddComponent(var2_3, "CanvasGroup")

		var4_3.alpha = 1

		table.insert(var0_3, function(arg0_5)
			LeanTween.alphaCanvas(var4_3, 0, 0.4):setOnComplete(System.Action(arg0_5))
		end)
	end

	parallelAsync(var0_3, function()
		arg0_3.isSwitching = nil

		setToggleEnabled(arg0_3.switchBtn, true)
	end)
end

return var0_0
