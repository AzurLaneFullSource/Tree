local var0_0 = class("LanternRiddlesView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controller = arg1_1

	pg.DelegateInfo.New(arg0_1)
end

function var0_0.SetUI(arg0_2, arg1_2)
	arg0_2._tf = arg1_2
	arg0_2.questioneTFs = {}

	for iter0_2, iter1_2 in ipairs(pg.activity_event_question.all) do
		local var0_2 = arg0_2:findTF("labels/label" .. iter0_2)

		arg0_2.questioneTFs[iter1_2] = var0_2
	end

	arg0_2.mainPanel = arg0_2:findTF("main")
	arg0_2.day = arg0_2:findTF("time/Text"):GetComponent(typeof(Text))
	arg0_2:findTF("frame/time", arg0_2.mainPanel):GetComponent(typeof(Text)).text = i18n("LanternRiddle_wait_time_tip")

	setActive(arg0_2.mainPanel, false)
	onButton(arg0_2, arg0_2.mainPanel, function()
		arg0_2:HideMainPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2:findTF("back"), function()
		arg0_2.controller:ExitGame()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2:findTF("back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.lanternRiddles_gametip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2:findTF("option"), function()
		arg0_2.controller:ExitGameAndGoHome()
	end, SFX_PANEL)
end

function var0_0.UpdateDay(arg0_7, arg1_7)
	local var0_7 = math.min(arg1_7, 7)

	arg0_7.day.text = var0_7
end

function var0_0.InitLanternRiddles(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var0_8 = arg0_8.questioneTFs[iter1_8.id]
		local var1_8 = iter1_8.isUnlock

		onButton(arg0_8, var0_8, function()
			if not var1_8 then
				return
			end

			arg0_8:ShowMainPanel(iter1_8)
		end, SFX_PANEL)
		setActive(var0_8:Find("finish"), iter1_8.isFinish)

		if LeanTween.isTweening(go(var0_8)) then
			LeanTween.cancel(go(var0_8))
		end

		local var2_8 = var0_8:Find("image")

		if var1_8 and not iter1_8.isFinish then
			LeanTween.rotateZ(go(var0_8), 10, 2):setLoopPingPong(0):setFrom(0)
		end

		setActive(var2_8, var1_8)
	end
end

function var0_0.RefreshLanterRiddles(arg0_10, arg1_10)
	arg0_10:InitLanternRiddles(arg1_10)
end

function var0_0.ShowMainPanel(arg0_11, arg1_11)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11.mainPanel)
	setActive(arg0_11.mainPanel, true)
	setActive(arg0_11:findTF("frame/label_game", arg0_11.mainPanel), arg1_11.type == 2)
	setActive(arg0_11:findTF("frame/label_his", arg0_11.mainPanel), arg1_11.type == 1)
	setText(arg0_11:findTF("frame/Text", arg0_11.mainPanel), arg1_11.text)
	arg0_11:UpdateMainPanelTime()

	local var0_11 = arg1_11.answers
	local var1_11 = arg0_11:findTF("frame/answers", arg0_11.mainPanel)
	local var2_11 = arg1_11.isFinish

	for iter0_11 = 1, 4 do
		local var3_11 = var0_11[iter0_11][1]
		local var4_11 = var0_11[iter0_11][2]
		local var5_11 = var1_11:GetChild(iter0_11 - 1)

		setText(var5_11:Find("Text"), var3_11)
		setActive(var5_11:Find("right"), var2_11 and iter0_11 == arg1_11.rightIndex)
		setActive(var5_11:Find("false"), var4_11)
		onButton(arg0_11, var5_11, function()
			if arg1_11.isFinish then
				return
			end

			if var4_11 then
				return
			end

			if pg.TimeMgr.GetInstance():GetServerTime() < arg0_11.controller:GetLockTime() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_wait_for_reanswer"))

				return
			end

			arg0_11.controller:SelectAnswer(arg1_11.id, iter0_11)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateMainPanelTime(arg0_13)
	arg0_13:RemoveTimer()

	local var0_13 = pg.TimeMgr.GetInstance():GetServerTime() <= arg0_13.controller:GetLockTime()

	setActive(arg0_13:findTF("frame/time", arg0_13.mainPanel), var0_13)

	if var0_13 then
		arg0_13:AddTimer()
	end
end

function var0_0.OnUpdateAnswer(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg0_14:findTF("frame/answers", arg0_14.mainPanel):GetChild(arg2_14 - 1)

	setActive(var0_14:Find("right"), arg3_14)
	setActive(var0_14:Find("false"), not arg3_14)

	if not arg3_14 then
		arg0_14:UpdateMainPanelTime()
		pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_answer_is_wrong"))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_answer_is_right"))

		local var1_14 = arg0_14.questioneTFs[arg1_14.id]

		setActive(var1_14:Find("finish"), arg1_14.isFinish)

		if LeanTween.isTweening(go(var1_14)) then
			LeanTween.cancel(go(var1_14))
		end
	end
end

function var0_0.HideMainPanel(arg0_15)
	arg0_15:RemoveTimer()
	setActive(arg0_15.mainPanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_15.mainPanel, arg0_15._tf)
end

function var0_0.AddTimer(arg0_16)
	local var0_16 = arg0_16.controller:GetLockTime()
	local var1_16 = arg0_16:findTF("frame/time/Text", arg0_16.mainPanel):GetComponent(typeof(Text))

	arg0_16.timer = Timer.New(function()
		local var0_17 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_17 = var0_16 - var0_17

		if var1_17 <= 0 then
			arg0_16:RemoveTimer()
			setActive(arg0_16:findTF("frame/time", arg0_16.mainPanel), false)
		else
			var1_16.text = pg.TimeMgr.GetInstance():DescCDTime(var1_17)
		end
	end, 1, -1)

	arg0_16.timer:Start()
	arg0_16.timer.func()
end

function var0_0.RemoveTimer(arg0_18)
	if arg0_18.timer then
		arg0_18.timer:Stop()

		arg0_18.timer = nil
	end
end

function var0_0.Dispose(arg0_19)
	arg0_19:RemoveTimer()
	arg0_19:HideMainPanel()
	pg.DelegateInfo.Dispose(arg0_19)
end

function var0_0.findTF(arg0_20, arg1_20, arg2_20)
	assert(arg0_20._tf, "transform should exist")

	return findTF(arg2_20 or arg0_20._tf, arg1_20)
end

return var0_0
