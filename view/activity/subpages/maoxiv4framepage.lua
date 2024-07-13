local var0_0 = class("MaoxiV4FramePage", import(".TemplatePage.NewFrameTemplatePage"))

var0_0.COLOR = "#1895ff"

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.switchBtns = {
		arg0_1:findTF("switch_btn_1", arg0_1.switchBtn),
		arg0_1:findTF("switch_btn_2", arg0_1.switchBtn)
	}
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	setActive(arg0_2.switchBtns[1], false)
	setActive(arg0_2.switchBtns[2], true)
end

function var0_0.OnUpdateFlush(arg0_3)
	local var0_3 = arg0_3.activity.data1
	local var1_3 = arg0_3.avatarConfig.target

	var0_3 = var1_3 < var0_3 and var1_3 or var0_3

	local var2_3 = var0_3 / var1_3

	setText(arg0_3.cur, var2_3 >= 1 and setColorStr(var0_3, var0_0.COLOR) or var0_3)
	setText(arg0_3.target, "/" .. var1_3)
	setFillAmount(arg0_3.bar, var2_3)

	local var3_3 = var1_3 <= var0_3
	local var4_3 = arg0_3.activity.data2 >= 1

	setActive(arg0_3.battleBtn, arg0_3.inPhase2 and not var3_3)
	setActive(arg0_3.getBtn, arg0_3.inPhase2 and not var4_3 and var3_3)
	setActive(arg0_3.gotBtn, arg0_3.inPhase2 and var4_3)
	setActive(arg0_3.gotTag, arg0_3.inPhase2 and var4_3)
	setActive(arg0_3.cur, not var4_3 and arg0_3.inPhase2)
	setActive(arg0_3.target, not var4_3 and arg0_3.inPhase2)
end

function var0_0.Switch(arg0_4, arg1_4)
	arg0_4.isSwitching = true

	setToggleEnabled(arg0_4.switchBtn, false)
	setActive(arg0_4.switchBtns[1], true)
	setActive(arg0_4.switchBtns[2], false)

	arg0_4.switchBtns[1], arg0_4.switchBtns[2] = arg0_4.switchBtns[2], arg0_4.switchBtns[1]

	local var0_4
	local var1_4

	if arg1_4 then
		var0_4, var1_4 = arg0_4.phases[1], arg0_4.phases[2]
	else
		var0_4, var1_4 = arg0_4.phases[2], arg0_4.phases[1]
	end

	local var2_4 = GetOrAddComponent(var0_4, typeof(CanvasGroup))
	local var3_4 = var0_4.localPosition
	local var4_4 = var1_4.localPosition

	var1_4:SetAsLastSibling()
	setActive(var0_4:Find("Image"), false)
	LeanTween.moveLocal(go(var0_4), var4_4, 0.4):setOnComplete(System.Action(function()
		setActive(var0_4:Find("label"), true)
	end))
	LeanTween.value(go(var0_4), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_6)
		var2_4.alpha = arg0_6
	end))
	setActive(var1_4:Find("Image"), true)

	local var5_4 = GetOrAddComponent(var1_4, typeof(CanvasGroup))

	LeanTween.value(go(var1_4), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_7)
		var5_4.alpha = arg0_7
	end))
	setActive(var1_4:Find("label"), false)
	LeanTween.moveLocal(go(var1_4), var3_4, 0.4):setOnComplete(System.Action(function()
		arg0_4.isSwitching = nil

		setToggleEnabled(arg0_4.switchBtn, true)
	end))
end

return var0_0
