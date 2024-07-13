local var0_0 = class("FranceIconTaskRePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.slider = arg0_1:findTF("slider", arg0_1.bg)
	arg0_1.step = arg0_1:findTF("step", arg0_1.bg)
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.displayBtn = arg0_1:findTF("display_btn", arg0_1.bg)
	arg0_1.awardTF = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	setActive(arg0_2.displayBtn, false)
	setActive(arg0_2.awardTF, false)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)

	arg0_2.step = arg0_2:findTF("AD/switcher/phase2/Image/step")
	arg0_2.progress = arg0_2:findTF("AD/switcher/phase2/Image/progress")
	arg0_2.switchBtn = arg0_2:findTF("AD/switcher/switch_btn")
	arg0_2.bar = arg0_2:findTF("AD/switcher/phase2/Image/barContent/bar")
	arg0_2.phases = {
		arg0_2:findTF("AD/switcher/phase1"),
		arg0_2:findTF("AD/switcher/phase2")
	}
	arg0_2.inPhase2 = false

	onToggle(arg0_2, arg0_2.switchBtn, function(arg0_4)
		if arg0_2.isSwitching then
			return
		end

		arg0_2.inPhase2 = arg0_4

		arg0_2:Switch(arg0_4)
	end, SFX_PANEL)

	local var0_2 = pg.activity_event_avatarframe[arg0_2.activity:getConfig("config_id")].start_time
	local var1_2 = pg.TimeMgr.GetInstance():Table2ServerTime({
		year = var0_2[1][1],
		month = var0_2[1][2],
		day = var0_2[1][3],
		hour = var0_2[2][1],
		min = var0_2[2][2],
		sec = var0_2[2][3]
	})

	arg0_2.inTime = pg.TimeMgr.GetInstance():GetServerTime() - var1_2 > 0

	setActive(arg0_2.battleBtn, isActive(arg0_2.battleBtn) and arg0_2.inTime)

	if arg0_2.inTime then
		triggerToggle(arg0_2.switchBtn, true)
	end
end

function var0_0.Switch(arg0_5, arg1_5)
	arg0_5.isSwitching = true

	local var0_5 = GetOrAddComponent(arg0_5.phases[1], typeof(CanvasGroup))
	local var1_5 = arg0_5.phases[1].localPosition
	local var2_5 = arg0_5.phases[2].localPosition

	arg0_5.phases[2]:SetAsLastSibling()
	setActive(arg0_5.phases[1]:Find("Image"), false)
	LeanTween.moveLocal(go(arg0_5.phases[1]), var2_5, 0.4):setOnComplete(System.Action(function()
		setActive(arg0_5.phases[1]:Find("label"), true)
	end))
	LeanTween.value(go(arg0_5.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_7)
		var0_5.alpha = arg0_7
	end))
	setActive(arg0_5.phases[2]:Find("Image"), true)

	local var3_5 = GetOrAddComponent(arg0_5.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0_5.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_8)
		var3_5.alpha = arg0_8
	end))
	setActive(arg0_5.phases[2]:Find("label"), false)
	LeanTween.moveLocal(go(arg0_5.phases[2]), var1_5, 0.4):setOnComplete(System.Action(function()
		arg0_5.isSwitching = nil
		arg0_5.phases[1], arg0_5.phases[2] = arg0_5.phases[2], arg0_5.phases[1]
	end))
	arg0_5:UpdateAwardGot()
	onButton(arg0_5, arg0_5.getBtn, function()
		arg0_5:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_5.activity.id
		})
	end, SFX_PANEL)
end

function var0_0.UpdateAwardGot(arg0_11)
	local var0_11 = arg0_11.activity.data2 >= 1
	local var1_11 = arg0_11:findTF("AD/switcher/phase2/got")

	setActive(var1_11, var0_11)
end

function var0_0.OnUpdateFlush(arg0_12)
	local var0_12 = arg0_12.activity

	setActive(arg0_12.battleBtn, isActive(arg0_12.battleBtn) and arg0_12.inTime)
	arg0_12:UpdateAwardGot()

	local var1_12 = arg0_12.activity.data1
	local var2_12 = pg.activity_event_avatarframe[arg0_12.activity:getConfig("config_id")].target

	if var2_12 < var1_12 then
		var1_12 = var2_12
	end

	local var3_12 = var1_12 / var2_12

	setText(arg0_12.step, var3_12 >= 1 and setColorStr(var1_12, "#487CFFFF") or var1_12)
	setText(arg0_12.progress, "/" .. var2_12)
	setFillAmount(arg0_12.bar, var1_12 / var2_12)

	local var4_12 = var2_12 <= var1_12
	local var5_12 = arg0_12.activity.data2 >= 1

	setActive(arg0_12.battleBtn, not var5_12 and not var4_12 and arg0_12.inTime)
	setActive(arg0_12.getBtn, var4_12 and not var5_12)
	setActive(arg0_12.gotBtn, var5_12)
end

return var0_0
