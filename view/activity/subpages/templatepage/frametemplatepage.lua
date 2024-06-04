local var0 = class("FrameTemplatePage", import("view.base.BaseActivityPage"))

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
	arg0.step = arg0:findTF("AD/switcher/phase2/Image/step")
	arg0.progress = arg0:findTF("AD/switcher/phase2/Image/progress")
end

function var0.OnDataSetting(arg0)
	if arg0.ptData then
		arg0.ptData:Update(arg0.activity)
	else
		arg0.ptData = ActivityPtData.New(arg0.activity)
	end
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getData()

		if var1.type == DROP_TYPE_RESOURCE and var1.id == PlayerConst.ResGold and var2:GoldMax(var1.count) then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			local var0, var1 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var1
			})
		end)
	end, SFX_PANEL)
	onToggle(arg0, arg0.switchBtn, function(arg0)
		if arg0.isSwitching then
			return
		end

		arg0.inPhase2 = arg0

		arg0:Switch(arg0)
	end, SFX_PANEL)

	local var0 = arg0.activity:getConfig("config_client")
	local var1 = pg.TimeMgr.GetInstance():inTime(var0)

	setActive(arg0.battleBtn, var1)

	arg0.inPhase2 = var1

	if var1 then
		triggerToggle(arg0.switchBtn, true)
	end
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.ptData:CanGetAward()
	local var1 = arg0.ptData:CanGetNextAward()

	setActive(arg0.getBtn, var0)
	setActive(arg0.gotBtn, not var1)

	local var2, var3, var4 = arg0.ptData:GetResProgress()

	setText(arg0.step, var4 >= 1 and setColorStr(var2, COLOR_GREEN) or var2)
	setText(arg0.progress, "/" .. var3)
	setFillAmount(arg0.bar, var2 / var3)
	arg0:UpdateAwardGot()
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
end

function var0.UpdateAwardGot(arg0)
	local var0 = arg0:findTF("switcher/phase2/got", arg0.bg)
	local var1 = not arg0.ptData:CanGetNextAward() and arg0.inPhase2

	setActive(var0, var1)

	if var1 then
		setActive(arg0.battleBtn, false)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
