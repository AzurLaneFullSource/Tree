local var0 = class("YidaliV2framePage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	setActive(arg0.displayBtn, false)
	setActive(arg0.awardTF, false)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)

	arg0.step = arg0:findTF("AD/switcher/phase2/Image/step")
	arg0.progress = arg0:findTF("AD/switcher/phase2/Image/progress")
	arg0.switchBtn = arg0:findTF("AD/switch_btn")
	arg0.bar = arg0:findTF("AD/switcher/phase2/Image/barContent/bar")
	arg0.phases = {
		arg0:findTF("AD/switcher/phase1"),
		arg0:findTF("AD/switcher/phase2")
	}
	arg0.inPhase2 = false

	onToggle(arg0, arg0.switchBtn, function(arg0)
		if arg0.isSwitching then
			return
		end

		arg0.inPhase2 = arg0

		arg0:Switch(arg0)
	end, SFX_PANEL)

	local var0 = arg0.activity:getConfig("config_client")

	if pg.TimeMgr.GetInstance():inTime(var0) then
		triggerToggle(arg0.switchBtn, true)
	end
end

function var0.Switch(arg0, arg1)
	arg0.isSwitching = true

	local var0 = GetOrAddComponent(arg0.phases[1], typeof(CanvasGroup))
	local var1 = arg0.phases[1].localPosition
	local var2 = arg0.phases[2].localPosition

	arg0.phases[2]:SetAsLastSibling()
	setActive(arg0.phases[1]:Find("Image"), false)
	setLocalPosition(go(arg0.phases[1]), var2)
	setActive(arg0.phases[1]:Find("label"), true)
	LeanTween.value(go(arg0.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end))
	setActive(arg0.phases[2]:Find("Image"), true)

	local var3 = GetOrAddComponent(arg0.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var3.alpha = arg0
	end))
	setActive(arg0.phases[2]:Find("label"), false)
	setLocalPosition(go(arg0.phases[2]), var1)

	arg0.isSwitching = nil
	arg0.phases[1], arg0.phases[2] = arg0.phases[2], arg0.phases[1]

	arg0:UpdateAwardGot()
end

function var0.UpdateAwardGot(arg0)
	local var0 = arg0:findTF("switcher/phase2/got", arg0.bg)
	local var1 = not arg0.ptData:CanGetNextAward() and arg0.inPhase2

	setActive(var0, var1)
	setActive(arg0.step, not var1)
	setActive(arg0.progress, not var1)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0 = arg0.activity:getConfig("config_client")
	local var1 = pg.TimeMgr.GetInstance():inTime(var0)

	setActive(arg0.battleBtn, isActive(arg0.battleBtn) and var1)
	arg0:UpdateAwardGot()

	local var2, var3, var4 = arg0.ptData:GetResProgress()

	setText(arg0.step, var4 >= 1 and setColorStr(var2, COLOR_GREEN) or var2)
	setText(arg0.progress, "/" .. var3)
	setFillAmount(arg0.bar, var2 / var3)
end

return var0
