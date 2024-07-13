local var0_0 = class("DeXiQianShaoPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.awardTF = arg0_1:findTF("switcher/phase2/Image/award", arg0_1.bg)

	var0_0.super.OnFirstFlush(arg0_1)
	setActive(arg0_1.displayBtn, false)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)

	arg0_1.step = arg0_1:findTF("AD/switcher/phase2/Image/step")
	arg0_1.progress = arg0_1:findTF("AD/switcher/phase2/Image/progress")
	arg0_1.switchBtn = arg0_1:findTF("AD/switcher/switch_btn")
	arg0_1.bar = arg0_1:findTF("AD/switcher/phase2/Image/bar")
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
	LeanTween.moveLocal(go(arg0_4.phases[1]), var2_4, 0.4):setOnComplete(System.Action(function()
		setActive(arg0_4.phases[1]:Find("label"), true)
	end))
	LeanTween.value(go(arg0_4.phases[1]), 1, 0, 0.4):setOnUpdate(System.Action_float(function(arg0_6)
		var0_4.alpha = arg0_6
	end)):setOnComplete(System.Action(function()
		var0_4.alpha = 1

		setActive(arg0_4.phases[1]:Find("Image"), false)
	end))
	setActive(arg0_4.phases[2]:Find("Image"), true)

	local var3_4 = GetOrAddComponent(arg0_4.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0_4.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_8)
		var3_4.alpha = arg0_8
	end))
	setActive(arg0_4.phases[2]:Find("label"), false)
	LeanTween.moveLocal(go(arg0_4.phases[2]), var1_4, 0.4):setOnComplete(System.Action(function()
		arg0_4.isSwitching = nil
		arg0_4.phases[1], arg0_4.phases[2] = arg0_4.phases[2], arg0_4.phases[1]
	end))
	arg0_4:UpdateAwardGot()
end

function var0_0.UpdateAwardGot(arg0_10)
	local var0_10 = arg0_10:findTF("switcher/phase2/got", arg0_10.bg)
	local var1_10 = arg0_10.ptData:CanGetAward()
	local var2_10 = not arg0_10.ptData:CanGetNextAward() and arg0_10.inPhase2

	setActive(var0_10, var2_10)

	if var2_10 or var1_10 then
		setActive(arg0_10.battleBtn, false)
	end
end

function var0_0.OnUpdateFlush(arg0_11)
	var0_0.super.OnUpdateFlush(arg0_11)

	local var0_11 = arg0_11.activity:getConfig("config_client")
	local var1_11 = pg.TimeMgr.GetInstance():inTime(var0_11)

	setActive(arg0_11.battleBtn, var1_11)
	arg0_11:UpdateAwardGot()

	local var2_11, var3_11, var4_11 = arg0_11.ptData:GetResProgress()

	setText(arg0_11.step, var4_11 >= 1 and setColorStr(var2_11, "#487CFFFF") or var2_11)
	setText(arg0_11.progress, "/" .. var3_11)
	setFillAmount(arg0_11.bar, var2_11 / var3_11)
end

return var0_0
