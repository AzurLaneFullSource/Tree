local var0_0 = class("FrameTemplatePage", import("view.base.BaseActivityPage"))

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
	arg0_1.step = arg0_1:findTF("AD/switcher/phase2/Image/step")
	arg0_1.progress = arg0_1:findTF("AD/switcher/phase2/Image/progress")
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.ptData then
		arg0_2.ptData:Update(arg0_2.activity)
	else
		arg0_2.ptData = ActivityPtData.New(arg0_2.activity)
	end
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		local var0_5 = {}
		local var1_5 = arg0_3.ptData:GetAward()
		local var2_5 = getProxy(PlayerProxy):getData()

		if var1_5.type == DROP_TYPE_RESOURCE and var1_5.id == PlayerConst.ResGold and var2_5:GoldMax(var1_5.count) then
			table.insert(var0_5, function(arg0_6)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0_6
				})
			end)
		end

		seriesAsync(var0_5, function()
			local var0_7, var1_7 = arg0_3.ptData:GetResProgress()

			arg0_3:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_3.ptData:GetId(),
				arg1 = var1_7
			})
		end)
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.switchBtn, function(arg0_8)
		if arg0_3.isSwitching then
			return
		end

		arg0_3.inPhase2 = arg0_8

		arg0_3:Switch(arg0_8)
	end, SFX_PANEL)

	local var0_3 = arg0_3.activity:getConfig("config_client")
	local var1_3 = pg.TimeMgr.GetInstance():inTime(var0_3)

	setActive(arg0_3.battleBtn, var1_3)

	arg0_3.inPhase2 = var1_3

	if var1_3 then
		triggerToggle(arg0_3.switchBtn, true)
	end
end

function var0_0.OnUpdateFlush(arg0_9)
	local var0_9 = arg0_9.ptData:CanGetAward()
	local var1_9 = arg0_9.ptData:CanGetNextAward()

	setActive(arg0_9.getBtn, var0_9)
	setActive(arg0_9.gotBtn, not var1_9)

	local var2_9, var3_9, var4_9 = arg0_9.ptData:GetResProgress()

	setText(arg0_9.step, var4_9 >= 1 and setColorStr(var2_9, COLOR_GREEN) or var2_9)
	setText(arg0_9.progress, "/" .. var3_9)
	setFillAmount(arg0_9.bar, var2_9 / var3_9)
	arg0_9:UpdateAwardGot()
end

function var0_0.Switch(arg0_10, arg1_10)
	arg0_10.isSwitching = true

	local var0_10 = GetOrAddComponent(arg0_10.phases[1], typeof(CanvasGroup))
	local var1_10 = arg0_10.phases[1].localPosition
	local var2_10 = arg0_10.phases[2].localPosition

	arg0_10.phases[2]:SetAsLastSibling()
	setActive(arg0_10.phases[1]:Find("Image"), false)
	LeanTween.moveLocal(go(arg0_10.phases[1]), var2_10, 0.4):setOnComplete(System.Action(function()
		setActive(arg0_10.phases[1]:Find("label"), true)
	end))
	LeanTween.value(go(arg0_10.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_12)
		var0_10.alpha = arg0_12
	end))
	setActive(arg0_10.phases[2]:Find("Image"), true)

	local var3_10 = GetOrAddComponent(arg0_10.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(arg0_10.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_13)
		var3_10.alpha = arg0_13
	end))
	setActive(arg0_10.phases[2]:Find("label"), false)
	LeanTween.moveLocal(go(arg0_10.phases[2]), var1_10, 0.4):setOnComplete(System.Action(function()
		arg0_10.isSwitching = nil
		arg0_10.phases[1], arg0_10.phases[2] = arg0_10.phases[2], arg0_10.phases[1]
	end))
	arg0_10:UpdateAwardGot()
end

function var0_0.UpdateAwardGot(arg0_15)
	local var0_15 = arg0_15:findTF("switcher/phase2/got", arg0_15.bg)
	local var1_15 = not arg0_15.ptData:CanGetNextAward() and arg0_15.inPhase2

	setActive(var0_15, var1_15)

	if var1_15 then
		setActive(arg0_15.battleBtn, false)
	end
end

function var0_0.OnDestroy(arg0_16)
	return
end

return var0_0
