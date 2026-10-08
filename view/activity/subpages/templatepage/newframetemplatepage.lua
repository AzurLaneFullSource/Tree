local var0_0 = class("NewFrameTemplatePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.battleBtn = arg0_1.bg:Find("battle_btn")
	arg0_1.getBtn = arg0_1.bg:Find("get_btn")
	arg0_1.gotBtn = arg0_1.bg:Find("got_btn")
	arg0_1.switchBtn = arg0_1._tf:Find("AD/switch_btn")
	arg0_1.phases = {
		arg0_1._tf:Find("AD/switcher/phase1"),
		arg0_1._tf:Find("AD/switcher/phase2")
	}
	arg0_1.bar = arg0_1._tf:Find("AD/switcher/phase2/Image/barContent/bar")
	arg0_1.cur = arg0_1._tf:Find("AD/switcher/phase2/Image/step")
	arg0_1.target = arg0_1._tf:Find("AD/switcher/phase2/Image/progress")
	arg0_1.gotTag = arg0_1._tf:Find("AD/switcher/phase2/Image/got")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.avatarConfig = pg.activity_event_avatarframe[arg0_2.activity:getConfig("config_id")]

	local var0_2 = arg0_2.avatarConfig.start_time

	if var0_2 == "stop" then
		arg0_2.timeStamp = nil
	else
		arg0_2.timeStamp = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_2)
	end
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_3.activity.id
		})
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.switchBtn, function(arg0_6)
		if arg0_3.isSwitching then
			return
		end

		arg0_3:Switch(arg0_6)
	end, SFX_PANEL)
	arg0_3:CheckSwitch2Phase2()

	if not IsNil(arg0_3.gotTag:Find("Text")) then
		setText(arg0_3.gotTag:Find("Text"), i18n("avatarframe_got"))
	end
end

function var0_0.CheckSwitch2Phase2(arg0_7, ...)
	arg0_7.inPhase2 = arg0_7.timeStamp and pg.TimeMgr.GetInstance():GetServerTime() - arg0_7.timeStamp > 0

	triggerToggle(arg0_7.switchBtn, arg0_7.inPhase2)
end

function var0_0.OnUpdateFlush(arg0_8)
	local var0_8 = arg0_8.activity.data1
	local var1_8 = arg0_8.avatarConfig.target

	var0_8 = var1_8 < var0_8 and var1_8 or var0_8

	local var2_8 = var0_8 / var1_8

	setText(arg0_8.cur, var2_8 >= 1 and var0_8 or var0_8)
	setText(arg0_8.target, "/" .. var1_8)
	setFillAmount(arg0_8.bar, var2_8)

	local var3_8 = var1_8 <= var0_8
	local var4_8 = arg0_8.activity.data2 >= 1

	setActive(arg0_8.battleBtn, arg0_8.inPhase2 and not var3_8)
	setActive(arg0_8.getBtn, arg0_8.inPhase2 and not var4_8 and var3_8)
	setActive(arg0_8.gotBtn, arg0_8.inPhase2 and var4_8)
	setActive(arg0_8.gotTag, arg0_8.inPhase2 and var4_8)
	setActive(arg0_8.cur, not var4_8)
	setActive(arg0_8.target, not var4_8)
end

function var0_0.Switch(arg0_9, arg1_9)
	arg0_9.isSwitching = true

	setToggleEnabled(arg0_9.switchBtn, false)

	local var0_9
	local var1_9

	if arg1_9 then
		var0_9, var1_9 = arg0_9.phases[1], arg0_9.phases[2]
	else
		var0_9, var1_9 = arg0_9.phases[2], arg0_9.phases[1]
	end

	local var2_9 = GetOrAddComponent(var0_9, typeof(CanvasGroup))
	local var3_9 = var0_9.localPosition
	local var4_9 = var1_9.localPosition

	var1_9:SetAsLastSibling()
	setActive(var0_9:Find("Image"), false)
	LeanTween.moveLocal(go(var0_9), var4_9, 0.4):setOnComplete(System.Action(function()
		setActive(var0_9:Find("label"), true)
	end))
	LeanTween.value(go(var0_9), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_11)
		var2_9.alpha = arg0_11
	end))
	setActive(var1_9:Find("Image"), true)

	local var5_9 = GetOrAddComponent(var1_9, typeof(CanvasGroup))

	LeanTween.value(go(var1_9), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_12)
		var5_9.alpha = arg0_12
	end))
	setActive(var1_9:Find("label"), false)
	LeanTween.moveLocal(go(var1_9), var3_9, 0.4):setOnComplete(System.Action(function()
		arg0_9.isSwitching = nil

		setToggleEnabled(arg0_9.switchBtn, true)
	end))
end

return var0_0
