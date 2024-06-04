local var0 = class("BritainframePage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	setActive(arg0.displayBtn, false)
	setActive(arg0.awardTF, false)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)

	arg0.step = arg0:findTF("AD/switcher/phase2/background/step")
	arg0.progress = arg0:findTF("AD/switcher/phase2/background/progress")
	arg0.switchBtn = arg0:findTF("AD/switcher/switch_btn")
	arg0.bar = arg0:findTF("AD/switcher/phase2/background/barContent/bar")
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
	setActive(arg0.phases[1]:Find("background"), false)
	LeanTween.moveLocal(go(arg0.phases[1]), var2, 0.4)
	LeanTween.value(go(arg0.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end))
	setActive(arg0.phases[2]:Find("background"), true)

	local var3 = GetOrAddComponent(arg0.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var3.alpha = arg0
	end))
	LeanTween.moveLocal(go(arg0.phases[2]), var1, 0.4):setOnComplete(System.Action(function()
		arg0.isSwitching = nil
		arg0.phases[1], arg0.phases[2] = arg0.phases[2], arg0.phases[1]
	end))
	arg0:UpdateAwardGot()
end

function var0.UpdateAwardGot(arg0)
	local var0 = arg0:findTF("switcher/phase2/background/got", arg0.bg)
	local var1 = not arg0.ptData:CanGetNextAward() and arg0.inPhase2

	setActive(var0, var1)

	local var2 = arg0.bg:Find("switcher/phase2/background")

	setActive(var2:Find("progress"), not var1)
	setActive(var2:Find("step"), not var1)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0 = arg0.activity:getConfig("config_client")
	local var1 = pg.TimeMgr.GetInstance():inTime(var0)

	setActive(arg0.battleBtn, isActive(arg0.battleBtn) and var1)
	arg0:UpdateAwardGot()

	local var2, var3, var4 = arg0.ptData:GetResProgress()

	setText(arg0.step, var4 >= 1 and setColorStr(var2, "#487CFFFF") or var2)
	setText(arg0.progress, "/" .. var3)
	setFillAmount(arg0.bar, var2 / var3)
end

return var0
