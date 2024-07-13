local var0_0 = class("DexiV3framePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	setActive(arg0_1.displayBtn, false)
	setActive(arg0_1.awardTF, false)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)

	arg0_1.step = arg0_1:findTF("AD/switcher/phase2/Image/step")
	arg0_1.progress = arg0_1:findTF("AD/switcher/phase2/Image/progress")
	arg0_1.switchBtn = arg0_1:findTF("AD/switch_btn")
	arg0_1.bar = arg0_1:findTF("AD/switcher/phase2/Image/barContent/bar")
	arg0_1.phases = {
		arg0_1:findTF("AD/switcher/phase1"),
		arg0_1:findTF("AD/switcher/phase2")
	}
	arg0_1.inPhase2 = false

	onToggle(arg0_1, arg0_1.switchBtn, function(arg0_3)
		if arg0_1.isSwitching then
			return
		end

		arg0_1.inPhase2 = arg0_3

		arg0_1:Switch(arg0_3)
	end, SFX_PANEL)

	local var0_1 = arg0_1.activity:getConfig("config_client")

	if pg.TimeMgr.GetInstance():inTime(var0_1) then
		triggerToggle(arg0_1.switchBtn, true)
	end
end

function var0_0.Switch(arg0_4, arg1_4)
	arg0_4.isSwitching = true

	local var0_4 = GetOrAddComponent(arg0_4.phases[1], typeof(CanvasGroup))
	local var1_4 = arg0_4.phases[1].localPosition
	local var2_4 = arg0_4.phases[2].localPosition

	arg0_4.phases[2]:SetAsLastSibling()
	setActive(arg0_4.phases[1]:Find("Image"), false)
	LeanTween.moveLocal(go(arg0_4.phases[1]), var2_4, 0.4):setOnComplete(System.Action(function()
		setActive(arg0_4.phases[1]:Find("label"), true)
	end))
	LeanTween.value(go(arg0_4.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_6)
		var0_4.alpha = arg0_6
	end))
	setActive(arg0_4.phases[2]:Find("Image"), true)

	local var3_4 = GetOrAddComponent(arg0_4.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0_4.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_7)
		var3_4.alpha = arg0_7
	end))
	setActive(arg0_4.phases[2]:Find("label"), false)
	LeanTween.moveLocal(go(arg0_4.phases[2]), var1_4, 0.4):setOnComplete(System.Action(function()
		arg0_4.isSwitching = nil
		arg0_4.phases[1], arg0_4.phases[2] = arg0_4.phases[2], arg0_4.phases[1]
	end))
	arg0_4:UpdateAwardGot()
end

function var0_0.UpdateAwardGot(arg0_9)
	local var0_9 = arg0_9:findTF("switcher/phase2/got", arg0_9.bg)
	local var1_9 = not arg0_9.ptData:CanGetNextAward() and arg0_9.inPhase2

	setActive(var0_9, var1_9)
end

function var0_0.OnUpdateFlush(arg0_10)
	var0_0.super.OnUpdateFlush(arg0_10)

	local var0_10 = arg0_10.activity:getConfig("config_client")
	local var1_10 = pg.TimeMgr.GetInstance():inTime(var0_10)

	setActive(arg0_10.battleBtn, isActive(arg0_10.battleBtn) and var1_10)
	arg0_10:UpdateAwardGot()

	local var2_10, var3_10, var4_10 = arg0_10.ptData:GetResProgress()

	setText(arg0_10.step, var4_10 >= 1 and setColorStr(var2_10, "#FFA76CFF") or var2_10)
	setText(arg0_10.progress, "/" .. var3_10)
	setFillAmount(arg0_10.bar, var2_10 / var3_10)
end

return var0_0
