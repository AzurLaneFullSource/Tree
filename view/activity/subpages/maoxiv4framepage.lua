local var0 = class("MaoxiV4FramePage", import(".TemplatePage.NewFrameTemplatePage"))

var0.COLOR = "#1895ff"

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.switchBtns = {
		arg0:findTF("switch_btn_1", arg0.switchBtn),
		arg0:findTF("switch_btn_2", arg0.switchBtn)
	}
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	setActive(arg0.switchBtns[1], false)
	setActive(arg0.switchBtns[2], true)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1
	local var1 = arg0.avatarConfig.target

	var0 = var1 < var0 and var1 or var0

	local var2 = var0 / var1

	setText(arg0.cur, var2 >= 1 and setColorStr(var0, var0.COLOR) or var0)
	setText(arg0.target, "/" .. var1)
	setFillAmount(arg0.bar, var2)

	local var3 = var1 <= var0
	local var4 = arg0.activity.data2 >= 1

	setActive(arg0.battleBtn, arg0.inPhase2 and not var3)
	setActive(arg0.getBtn, arg0.inPhase2 and not var4 and var3)
	setActive(arg0.gotBtn, arg0.inPhase2 and var4)
	setActive(arg0.gotTag, arg0.inPhase2 and var4)
	setActive(arg0.cur, not var4 and arg0.inPhase2)
	setActive(arg0.target, not var4 and arg0.inPhase2)
end

function var0.Switch(arg0, arg1)
	arg0.isSwitching = true

	setToggleEnabled(arg0.switchBtn, false)
	setActive(arg0.switchBtns[1], true)
	setActive(arg0.switchBtns[2], false)

	arg0.switchBtns[1], arg0.switchBtns[2] = arg0.switchBtns[2], arg0.switchBtns[1]

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
	LeanTween.moveLocal(go(var0), var4, 0.4):setOnComplete(System.Action(function()
		setActive(var0:Find("label"), true)
	end))
	LeanTween.value(go(var0), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var2.alpha = arg0
	end))
	setActive(var1:Find("Image"), true)

	local var5 = GetOrAddComponent(var1, typeof(CanvasGroup))

	LeanTween.value(go(var1), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var5.alpha = arg0
	end))
	setActive(var1:Find("label"), false)
	LeanTween.moveLocal(go(var1), var3, 0.4):setOnComplete(System.Action(function()
		arg0.isSwitching = nil

		setToggleEnabled(arg0.switchBtn, true)
	end))
end

return var0
