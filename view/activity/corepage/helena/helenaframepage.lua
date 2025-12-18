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

	setText(arg0_1._tf:Find("AD/switcher/phase2/task_bg_2/battle_btn/Text"), i18n("other_world_task_go"))
	setText(arg0_1._tf:Find("AD/switcher/phase2/task_bg_2/get_btn/Text"), i18n("other_world_task_get"))
	setText(arg0_1._tf:Find("AD/switcher/phase2/task_bg_2/got_btn/Text"), i18n("other_world_task_got"))
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.getBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.activity.id
		})
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.switchBtn, function(arg0_5)
		if arg0_2.isSwitching then
			return
		end

		arg0_2:Switch(arg0_5)
	end, SFX_PANEL)

	arg0_2.inPhase2 = arg0_2.timeStamp and pg.TimeMgr.GetInstance():GetServerTime() - arg0_2.timeStamp > 0

	triggerToggle(arg0_2.switchBtn, arg0_2.inPhase2)
end

function var0_0.OnUpdateFlush(arg0_6)
	var0_0.super.OnUpdateFlush(arg0_6)

	local var0_6 = arg0_6.activity.data1
	local var1_6 = arg0_6.avatarConfig.target

	var0_6 = var1_6 < var0_6 and var1_6 or var0_6

	local var2_6 = var0_6 / var1_6

	setText(arg0_6.cur, (var2_6 >= 1 and setColorStr(var0_6, "#FCE87A") or setColorStr(var0_6, "#FCE87A")) .. setColorStr("/" .. var1_6, "#FFFFFF"))
	setActive(arg0_6.target, false)
end

function var0_0.Switch(arg0_7, arg1_7)
	arg0_7.isSwitching = true

	setToggleEnabled(arg0_7.switchBtn, false)

	if arg1_7 then
		quickPlayAnimation(arg0_7.bg:Find("switcher"), "anim_HelenaFramePage_switcher")
	else
		quickPlayAnimation(arg0_7.bg:Find("switcher"), "anim_HelenaFramePage_switcher2")
	end

	arg0_7.isSwitching = nil

	setToggleEnabled(arg0_7.switchBtn, true)
end

return var0_0
