local var0_0 = class("TianYuTianYuanFramePage", import("view.activity.CorePage.CoreNewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.super.OnInit(arg0_1)

	arg0_1.switchBtn = arg0_1._tf:Find("AD/switcher/switch_btn")
end

function var0_0.OnFirstFlush(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.phases) do
		setActive(iter1_2, true)

		GetOrAddComponent(iter1_2, typeof(CanvasGroup)).alpha = 0
	end

	var0_0.super.OnFirstFlush(arg0_2)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3 = arg0_3.activity.data1
	local var1_3 = arg0_3.avatarConfig.target

	var0_3 = var1_3 < var0_3 and var1_3 or var0_3

	local var2_3 = var0_3 / var1_3

	setText(arg0_3.cur, (var2_3 >= 1 and setColorStr(var0_3, "#FCE87A") or setColorStr(var0_3, "#FCE87A")) .. setColorStr("/" .. var1_3, "#FFFFFF"))
	setActive(arg0_3.target, false)
end

function var0_0.Switch(arg0_4, arg1_4)
	arg0_4.isSwitching = true

	setToggleEnabled(arg0_4.switchBtn, false)

	local var0_4
	local var1_4

	if arg1_4 then
		var0_4, var1_4 = arg0_4.phases[1], arg0_4.phases[2]
	else
		var0_4, var1_4 = arg0_4.phases[2], arg0_4.phases[1]
	end

	local var2_4 = var0_4.localPosition
	local var3_4 = var1_4.localPosition

	var1_4:SetAsLastSibling()
	setCanvasGroupAlpha(GetOrAddComponent(var0_4, typeof(CanvasGroup)), 0)
	setCanvasGroupAlpha(GetOrAddComponent(var1_4, typeof(CanvasGroup)), 1)

	arg0_4.isSwitching = nil

	setToggleEnabled(arg0_4.switchBtn, true)
end

return var0_0
