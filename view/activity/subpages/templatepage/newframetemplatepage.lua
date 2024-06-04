local var0 = class("NewFrameTemplatePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
	arg0.switchBtn = arg0:findTF("AD/switch_btn")
	arg0.phases = {
		arg0:findTF("AD/switcher/phase1"),
		arg0:findTF("AD/switcher/phase2")
	}
	arg0.bar = arg0:findTF("AD/switcher/phase2/Image/barContent/bar")
	arg0.cur = arg0:findTF("AD/switcher/phase2/Image/step")
	arg0.target = arg0:findTF("AD/switcher/phase2/Image/progress")
	arg0.gotTag = arg0:findTF("AD/switcher/phase2/Image/got")
end

function var0.OnDataSetting(arg0)
	arg0.avatarConfig = pg.activity_event_avatarframe[arg0.activity:getConfig("config_id")]

	local var0 = arg0.avatarConfig.start_time

	if var0 == "stop" then
		arg0.timeStamp = nil
	else
		arg0.timeStamp = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0)
	end
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

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1
	local var1 = arg0.avatarConfig.target

	var0 = var1 < var0 and var1 or var0

	local var2 = var0 / var1

	setText(arg0.cur, var2 >= 1 and setColorStr(var0, COLOR_GREEN) or var0)
	setText(arg0.target, "/" .. var1)
	setFillAmount(arg0.bar, var2)

	local var3 = var1 <= var0
	local var4 = arg0.activity.data2 >= 1

	setActive(arg0.battleBtn, arg0.inPhase2 and not var3)
	setActive(arg0.getBtn, arg0.inPhase2 and not var4 and var3)
	setActive(arg0.gotBtn, arg0.inPhase2 and var4)
	setActive(arg0.gotTag, arg0.inPhase2 and var4)
	setActive(arg0.cur, not var4)
	setActive(arg0.target, not var4)
end

function var0.Switch(arg0, arg1)
	arg0.isSwitching = true

	setToggleEnabled(arg0.switchBtn, false)

	local var0
	local var1

	if arg1 then
		var0, var1 = arg0.phases[1], arg0.phases[2]
	else
		var0, var1 = arg0.phases[2], arg0.phases[1]
	end

	local var2 = GetOrAddComponent(var0, typeof(CanvasGroup))
	local var3 = var0.localPosition
	local var4 = var1.localPosition

	var1:SetAsLastSibling()
	setActive(var0:Find("Image"), false)
	LeanTween.moveLocal(go(var0), var4, 0.4):setOnComplete(System.Action(function()
		setActive(var0:Find("label"), true)
	end))
	LeanTween.value(go(var0), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var2.alpha = arg0
	end))
	setActive(var1:Find("Image"), true)

	local var5 = GetOrAddComponent(var1, typeof(CanvasGroup))

	LeanTween.value(go(var1), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var5.alpha = arg0
	end))
	setActive(var1:Find("label"), false)
	LeanTween.moveLocal(go(var1), var3, 0.4):setOnComplete(System.Action(function()
		arg0.isSwitching = nil

		setToggleEnabled(arg0.switchBtn, true)
	end))
end

return var0
