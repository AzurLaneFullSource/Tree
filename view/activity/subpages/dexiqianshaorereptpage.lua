local var0 = class("DeXiQianShaoReRePtPage", import(".TemplatePage.NewFrameTemplatePage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
	arg0.switchBtn = arg0:findTF("AD/switcher/switch_btn")
	arg0.phases = {
		arg0:findTF("AD/switcher/phase1"),
		arg0:findTF("AD/switcher/phase2")
	}
	arg0.bar = arg0:findTF("AD/item/bar")
	arg0.cur = arg0:findTF("AD/item/step")
	arg0.target = arg0:findTF("AD/item/progress")
	arg0.gotTag = arg0:findTF("AD/item/got")
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end, SFX_PANEL)
	onToggle(arg0, arg0.switchBtn, function(arg0)
		if arg0.isSwitching then
			return
		end

		arg0:Switch(arg0)
	end, SFX_PANEL)

	arg0.inPhase2 = arg0.timeStamp and pg.TimeMgr.GetInstance():GetServerTime() - arg0.timeStamp > 0

	triggerToggle(arg0.switchBtn, arg0.inPhase2)

	if not IsNil(arg0.gotTag:Find("Text")) then
		setText(arg0.gotTag:Find("Text"), i18n("avatarframe_got"))
	end
end

return var0
