local var0 = class("FranceIconTaskRePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.slider = arg0:findTF("slider", arg0.bg)
	arg0.step = arg0:findTF("step", arg0.bg)
	arg0.progress = arg0:findTF("progress", arg0.bg)
	arg0.displayBtn = arg0:findTF("display_btn", arg0.bg)
	arg0.awardTF = arg0:findTF("award", arg0.bg)
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
end

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
	arg0.switchBtn = arg0:findTF("AD/switcher/switch_btn")
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

	local var0 = pg.activity_event_avatarframe[arg0.activity:getConfig("config_id")].start_time
	local var1 = pg.TimeMgr.GetInstance():Table2ServerTime({
		year = var0[1][1],
		month = var0[1][2],
		day = var0[1][3],
		hour = var0[2][1],
		min = var0[2][2],
		sec = var0[2][3]
	})

	arg0.inTime = pg.TimeMgr.GetInstance():GetServerTime() - var1 > 0

	setActive(arg0.battleBtn, isActive(arg0.battleBtn) and arg0.inTime)

	if arg0.inTime then
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
	LeanTween.moveLocal(go(arg0.phases[1]), var2, 0.4):setOnComplete(System.Action(function()
		setActive(arg0.phases[1]:Find("label"), true)
	end))
	LeanTween.value(go(arg0.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end))
	setActive(arg0.phases[2]:Find("Image"), true)

	local var3 = GetOrAddComponent(arg0.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var3.alpha = arg0
	end))
	setActive(arg0.phases[2]:Find("label"), false)
	LeanTween.moveLocal(go(arg0.phases[2]), var1, 0.4):setOnComplete(System.Action(function()
		arg0.isSwitching = nil
		arg0.phases[1], arg0.phases[2] = arg0.phases[2], arg0.phases[1]
	end))
	arg0:UpdateAwardGot()
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end, SFX_PANEL)
end

function var0.UpdateAwardGot(arg0)
	local var0 = arg0.activity.data2 >= 1
	local var1 = arg0:findTF("AD/switcher/phase2/got")

	setActive(var1, var0)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity

	setActive(arg0.battleBtn, isActive(arg0.battleBtn) and arg0.inTime)
	arg0:UpdateAwardGot()

	local var1 = arg0.activity.data1
	local var2 = pg.activity_event_avatarframe[arg0.activity:getConfig("config_id")].target

	if var2 < var1 then
		var1 = var2
	end

	local var3 = var1 / var2

	setText(arg0.step, var3 >= 1 and setColorStr(var1, "#487CFFFF") or var1)
	setText(arg0.progress, "/" .. var2)
	setFillAmount(arg0.bar, var1 / var2)

	local var4 = var2 <= var1
	local var5 = arg0.activity.data2 >= 1

	setActive(arg0.battleBtn, not var5 and not var4 and arg0.inTime)
	setActive(arg0.getBtn, var4 and not var5)
	setActive(arg0.gotBtn, var5)
end

return var0
