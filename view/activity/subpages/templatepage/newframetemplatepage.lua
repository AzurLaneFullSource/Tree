local var0_0 = class("NewFrameTemplatePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
	arg0_1.switchBtn = arg0_1:findTF("AD/switch_btn")
	arg0_1.phases = {
		arg0_1:findTF("AD/switcher/phase1"),
		arg0_1:findTF("AD/switcher/phase2")
	}
	arg0_1.bar = arg0_1:findTF("AD/switcher/phase2/Image/barContent/bar")
	arg0_1.cur = arg0_1:findTF("AD/switcher/phase2/Image/step")
	arg0_1.target = arg0_1:findTF("AD/switcher/phase2/Image/progress")
	arg0_1.gotTag = arg0_1:findTF("AD/switcher/phase2/Image/got")
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

	arg0_3.inPhase2 = arg0_3.timeStamp and pg.TimeMgr.GetInstance():GetServerTime() - arg0_3.timeStamp > 0

	triggerToggle(arg0_3.switchBtn, arg0_3.inPhase2)

	if not IsNil(arg0_3.gotTag:Find("Text")) then
		setText(arg0_3.gotTag:Find("Text"), i18n("avatarframe_got"))
	end
end

function var0_0.OnUpdateFlush(arg0_7)
	local var0_7 = arg0_7.activity.data1
	local var1_7 = arg0_7.avatarConfig.target

	var0_7 = var1_7 < var0_7 and var1_7 or var0_7

	local var2_7 = var0_7 / var1_7

	setText(arg0_7.cur, var2_7 >= 1 and setColorStr(var0_7, COLOR_GREEN) or var0_7)
	setText(arg0_7.target, "/" .. var1_7)
	setFillAmount(arg0_7.bar, var2_7)

	local var3_7 = var1_7 <= var0_7
	local var4_7 = arg0_7.activity.data2 >= 1

	setActive(arg0_7.battleBtn, arg0_7.inPhase2 and not var3_7)
	setActive(arg0_7.getBtn, arg0_7.inPhase2 and not var4_7 and var3_7)
	setActive(arg0_7.gotBtn, arg0_7.inPhase2 and var4_7)
	setActive(arg0_7.gotTag, arg0_7.inPhase2 and var4_7)
	setActive(arg0_7.cur, not var4_7)
	setActive(arg0_7.target, not var4_7)
end

function var0_0.Switch(arg0_8, arg1_8)
	arg0_8.isSwitching = true

	setToggleEnabled(arg0_8.switchBtn, false)

	local var0_8
	local var1_8

	if arg1_8 then
		var0_8, var1_8 = arg0_8.phases[1], arg0_8.phases[2]
	else
		var0_8, var1_8 = arg0_8.phases[2], arg0_8.phases[1]
	end

	local var2_8 = GetOrAddComponent(var0_8, typeof(CanvasGroup))
	local var3_8 = var0_8.localPosition
	local var4_8 = var1_8.localPosition

	var1_8:SetAsLastSibling()
	setActive(var0_8:Find("Image"), false)
	LeanTween.moveLocal(go(var0_8), var4_8, 0.4):setOnComplete(System.Action(function()
		setActive(var0_8:Find("label"), true)
	end))
	LeanTween.value(go(var0_8), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_10)
		var2_8.alpha = arg0_10
	end))
	setActive(var1_8:Find("Image"), true)

	local var5_8 = GetOrAddComponent(var1_8, typeof(CanvasGroup))

	LeanTween.value(go(var1_8), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_11)
		var5_8.alpha = arg0_11
	end))
	setActive(var1_8:Find("label"), false)
	LeanTween.moveLocal(go(var1_8), var3_8, 0.4):setOnComplete(System.Action(function()
		arg0_8.isSwitching = nil

		setToggleEnabled(arg0_8.switchBtn, true)
	end))
end

return var0_0
