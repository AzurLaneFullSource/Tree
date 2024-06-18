local var0_0 = class("DeXiQianShaoRePtPage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
	arg0_1.switchBtn = arg0_1:findTF("AD/switcher/switch_btn")
	arg0_1.phases = {
		arg0_1:findTF("AD/switcher/phase1"),
		arg0_1:findTF("AD/switcher/phase2")
	}
	arg0_1.bar = arg0_1:findTF("AD/switcher/phase2/Image/bar")
	arg0_1.cur = arg0_1:findTF("AD/switcher/phase2/Image/step")
	arg0_1.target = arg0_1:findTF("AD/switcher/phase2/Image/progress")
	arg0_1.gotTag = arg0_1:findTF("AD/switcher/phase2/got")
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

	if not IsNil(arg0_2.gotTag:Find("Text")) then
		setText(arg0_2.gotTag:Find("Text"), i18n("avatarframe_got"))
	end
end

return var0_0
