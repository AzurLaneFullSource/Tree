local var0_0 = class("BritainframePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	setActive(arg0_1.displayBtn, false)
	setActive(arg0_1.awardTF, false)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)

	arg0_1.step = arg0_1:findTF("AD/switcher/phase2/background/step")
	arg0_1.progress = arg0_1:findTF("AD/switcher/phase2/background/progress")
	arg0_1.switchBtn = arg0_1:findTF("AD/switcher/switch_btn")
	arg0_1.bar = arg0_1:findTF("AD/switcher/phase2/background/barContent/bar")
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
	setActive(arg0_4.phases[1]:Find("background"), false)
	LeanTween.moveLocal(go(arg0_4.phases[1]), var2_4, 0.4)
	LeanTween.value(go(arg0_4.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_5)
		var0_4.alpha = arg0_5
	end))
	setActive(arg0_4.phases[2]:Find("background"), true)

	local var3_4 = GetOrAddComponent(arg0_4.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0_4.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_6)
		var3_4.alpha = arg0_6
	end))
	LeanTween.moveLocal(go(arg0_4.phases[2]), var1_4, 0.4):setOnComplete(System.Action(function()
		arg0_4.isSwitching = nil
		arg0_4.phases[1], arg0_4.phases[2] = arg0_4.phases[2], arg0_4.phases[1]
	end))
	arg0_4:UpdateAwardGot()
end

function var0_0.UpdateAwardGot(arg0_8)
	local var0_8 = arg0_8:findTF("switcher/phase2/background/got", arg0_8.bg)
	local var1_8 = not arg0_8.ptData:CanGetNextAward() and arg0_8.inPhase2

	setActive(var0_8, var1_8)

	local var2_8 = arg0_8.bg:Find("switcher/phase2/background")

	setActive(var2_8:Find("progress"), not var1_8)
	setActive(var2_8:Find("step"), not var1_8)
end

function var0_0.OnUpdateFlush(arg0_9)
	var0_0.super.OnUpdateFlush(arg0_9)

	local var0_9 = arg0_9.activity:getConfig("config_client")
	local var1_9 = pg.TimeMgr.GetInstance():inTime(var0_9)

	setActive(arg0_9.battleBtn, isActive(arg0_9.battleBtn) and var1_9)
	arg0_9:UpdateAwardGot()

	local var2_9, var3_9, var4_9 = arg0_9.ptData:GetResProgress()

	setText(arg0_9.step, var4_9 >= 1 and setColorStr(var2_9, "#487CFFFF") or var2_9)
	setText(arg0_9.progress, "/" .. var3_9)
	setFillAmount(arg0_9.bar, var2_9 / var3_9)
end

return var0_0
