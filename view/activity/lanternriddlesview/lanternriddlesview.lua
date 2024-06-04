local var0 = class("LanternRiddlesView")

function var0.Ctor(arg0, arg1)
	arg0.controller = arg1

	pg.DelegateInfo.New(arg0)
end

function var0.SetUI(arg0, arg1)
	arg0._tf = arg1
	arg0.questioneTFs = {}

	for iter0, iter1 in ipairs(pg.activity_event_question.all) do
		local var0 = arg0:findTF("labels/label" .. iter0)

		arg0.questioneTFs[iter1] = var0
	end

	arg0.mainPanel = arg0:findTF("main")
	arg0.day = arg0:findTF("time/Text"):GetComponent(typeof(Text))
	arg0:findTF("frame/time", arg0.mainPanel):GetComponent(typeof(Text)).text = i18n("LanternRiddle_wait_time_tip")

	setActive(arg0.mainPanel, false)
	onButton(arg0, arg0.mainPanel, function()
		arg0:HideMainPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("back"), function()
		arg0.controller:ExitGame()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.lanternRiddles_gametip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("option"), function()
		arg0.controller:ExitGameAndGoHome()
	end, SFX_PANEL)
end

function var0.UpdateDay(arg0, arg1)
	local var0 = math.min(arg1, 7)

	arg0.day.text = var0
end

function var0.InitLanternRiddles(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = arg0.questioneTFs[iter1.id]
		local var1 = iter1.isUnlock

		onButton(arg0, var0, function()
			if not var1 then
				return
			end

			arg0:ShowMainPanel(iter1)
		end, SFX_PANEL)
		setActive(var0:Find("finish"), iter1.isFinish)

		if LeanTween.isTweening(go(var0)) then
			LeanTween.cancel(go(var0))
		end

		local var2 = var0:Find("image")

		if var1 and not iter1.isFinish then
			LeanTween.rotateZ(go(var0), 10, 2):setLoopPingPong(0):setFrom(0)
		end

		setActive(var2, var1)
	end
end

function var0.RefreshLanterRiddles(arg0, arg1)
	arg0:InitLanternRiddles(arg1)
end

function var0.ShowMainPanel(arg0, arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0.mainPanel)
	setActive(arg0.mainPanel, true)
	setActive(arg0:findTF("frame/label_game", arg0.mainPanel), arg1.type == 2)
	setActive(arg0:findTF("frame/label_his", arg0.mainPanel), arg1.type == 1)
	setText(arg0:findTF("frame/Text", arg0.mainPanel), arg1.text)
	arg0:UpdateMainPanelTime()

	local var0 = arg1.answers
	local var1 = arg0:findTF("frame/answers", arg0.mainPanel)
	local var2 = arg1.isFinish

	for iter0 = 1, 4 do
		local var3 = var0[iter0][1]
		local var4 = var0[iter0][2]
		local var5 = var1:GetChild(iter0 - 1)

		setText(var5:Find("Text"), var3)
		setActive(var5:Find("right"), var2 and iter0 == arg1.rightIndex)
		setActive(var5:Find("false"), var4)
		onButton(arg0, var5, function()
			if arg1.isFinish then
				return
			end

			if var4 then
				return
			end

			if pg.TimeMgr.GetInstance():GetServerTime() < arg0.controller:GetLockTime() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_wait_for_reanswer"))

				return
			end

			arg0.controller:SelectAnswer(arg1.id, iter0)
		end, SFX_PANEL)
	end
end

function var0.UpdateMainPanelTime(arg0)
	arg0:RemoveTimer()

	local var0 = pg.TimeMgr.GetInstance():GetServerTime() <= arg0.controller:GetLockTime()

	setActive(arg0:findTF("frame/time", arg0.mainPanel), var0)

	if var0 then
		arg0:AddTimer()
	end
end

function var0.OnUpdateAnswer(arg0, arg1, arg2, arg3)
	local var0 = arg0:findTF("frame/answers", arg0.mainPanel):GetChild(arg2 - 1)

	setActive(var0:Find("right"), arg3)
	setActive(var0:Find("false"), not arg3)

	if not arg3 then
		arg0:UpdateMainPanelTime()
		pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_answer_is_wrong"))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_answer_is_right"))

		local var1 = arg0.questioneTFs[arg1.id]

		setActive(var1:Find("finish"), arg1.isFinish)

		if LeanTween.isTweening(go(var1)) then
			LeanTween.cancel(go(var1))
		end
	end
end

function var0.HideMainPanel(arg0)
	arg0:RemoveTimer()
	setActive(arg0.mainPanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.mainPanel, arg0._tf)
end

function var0.AddTimer(arg0)
	local var0 = arg0.controller:GetLockTime()
	local var1 = arg0:findTF("frame/time/Text", arg0.mainPanel):GetComponent(typeof(Text))

	arg0.timer = Timer.New(function()
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1 = var0 - var0

		if var1 <= 0 then
			arg0:RemoveTimer()
			setActive(arg0:findTF("frame/time", arg0.mainPanel), false)
		else
			var1.text = pg.TimeMgr.GetInstance():DescCDTime(var1)
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0:RemoveTimer()
	arg0:HideMainPanel()
	pg.DelegateInfo.Dispose(arg0)
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

return var0
