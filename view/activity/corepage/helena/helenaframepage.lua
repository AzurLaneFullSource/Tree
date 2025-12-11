local var0_0 = class("HelenaFramePage", import("view.activity.CorePage.CoreNewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.super.OnInit(arg0_1)

	arg0_1.battleBtn = arg0_1.bg:Find("switcher/phase2/task_bg_2/battle_btn")
	arg0_1.getBtn = arg0_1.bg:Find("switcher/phase2/task_bg_2/get_btn")
	arg0_1.gotBtn = arg0_1.bg:Find("switcher/phase2/task_bg_2/got_btn")
	arg0_1.switchBtn = arg0_1._tf:Find("AD/switcher/switch_btn")
	arg0_1.gotTag = arg0_1._tf:Find("AD/switcher/phase2/task_bg_2/Image/got")
	arg0_1.bar = arg0_1._tf:Find("AD/switcher/phase2/task_bg_2/Image/barContent/bar")
	arg0_1.cur = arg0_1._tf:Find("AD/switcher/phase2/task_bg_2/Image/step")
	arg0_1.target = arg0_1._tf:Find("AD/switcher/phase2/task_bg_2/Image/progress")
end

function var0_0.OnFirstFlush(arg0_2)
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

	if arg1_4 then
		quickPlayAnimation(arg0_4.bg:Find("switcher"), "anim_HelenaFramePage_switcher")
	else
		quickPlayAnimation(arg0_4.bg:Find("switcher"), "anim_HelenaFramePage_switcher2")
	end

	arg0_4.isSwitching = nil

	setToggleEnabled(arg0_4.switchBtn, true)
end

return var0_0
