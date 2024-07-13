local var0_0 = class("TowerClimbingView")

local function var1_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = GetOrAddComponent(arg0_1, "EventTriggerListener")

	var0_1:AddPointDownFunc(function(arg0_2, arg1_2)
		if arg1_1 then
			arg1_1()
		end
	end)
	var0_1:AddPointUpFunc(function(arg0_3, arg1_3)
		if arg2_1 then
			arg2_1()
		end
	end)
end

local function var2_0(arg0_4)
	local var0_4 = GetOrAddComponent(arg0_4, "EventTriggerListener")

	var0_4:RemovePointDownFunc()
	var0_4:RemovePointUpFunc()
end

function var0_0.Ctor(arg0_5, arg1_5)
	pg.DelegateInfo.New(arg0_5)

	arg0_5.controller = arg1_5
end

function var0_0.SetUI(arg0_6, arg1_6)
	arg0_6._go = arg1_6
	arg0_6._tf = arg1_6.transform
	arg0_6.overView = findTF(arg0_6._tf, "overview")
	arg0_6.gameView = findTF(arg0_6._tf, "AD")
	arg0_6.maps = {
		findTF(arg0_6._tf, "overview/maps/1"),
		findTF(arg0_6._tf, "overview/maps/2"),
		findTF(arg0_6._tf, "overview/maps/3")
	}
	arg0_6.exitGameBtn = findTF(arg0_6.gameView, "back")
	arg0_6.jumpBtn = findTF(arg0_6.gameView, "prints/right_btn_layout/up")
	arg0_6.leftLayout = findTF(arg0_6.gameView, "prints/left_btn_layout")
	arg0_6.moveBtn = findTF(arg0_6.leftLayout, "move_btn")
	arg0_6.quitPanel = findTF(arg0_6._tf, "quit_panel")
	arg0_6.quitPanelCancelBtn = arg0_6.quitPanel:Find("frame/cancel")
	arg0_6.quitPanelCconfirmBtn = arg0_6.quitPanel:Find("frame/confirm")
	arg0_6.resultPanel = findTF(arg0_6._tf, "result_panel")
	arg0_6.resultPanelScoreTxt = arg0_6.resultPanel:Find("frame/curr/Text"):GetComponent(typeof(Text))
	arg0_6.resultPanelHScoreTxt = arg0_6.resultPanel:Find("frame/higtest/Text"):GetComponent(typeof(Text))
	arg0_6.resultPanelEndBtn = arg0_6.resultPanel:Find("frame/cancel")
	arg0_6.helpBtn = arg0_6._tf:Find("overview/logo/help")
	arg0_6.enterPanel = arg0_6._tf:Find("enter_panel")
	arg0_6.enterPanelTxt = arg0_6.enterPanel:Find("Text"):GetComponent(typeof(Text))

	arg0_6:ResetParams()
end

function var0_0.OnEnter(arg0_7, arg1_7)
	setActive(arg0_7.overView, true)
	setActive(arg0_7.gameView, false)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.towerclimbing_gametip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.exitGameBtn, function()
		arg0_7:ShowQuitPanel()
	end, SFX_PANEL)

	for iter0_7, iter1_7 in ipairs(arg0_7.maps) do
		onButton(arg0_7, iter1_7, function()
			arg0_7.controller:StartGame(iter0_7)
		end, SFX_PANEL)
	end
end

function var0_0.DoEnter(arg0_11, arg1_11)
	setActive(arg0_11.overView, false)
	setActive(arg0_11.gameView, true)

	arg0_11.inDownCnt = true

	arg0_11:ActivePanel(arg0_11.enterPanel, true)

	local var0_11 = 4

	arg0_11.timer = Timer.New(function()
		var0_11 = var0_11 - 1

		if var0_11 == 3 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_PILE_COUNTDOWN)
		end

		arg0_11.enterPanelTxt.text = var0_11

		if var0_11 == 0 then
			arg1_11()
			arg0_11:ActivePanel(arg0_11.enterPanel, false)
			arg0_11.timer:Stop()

			arg0_11.timer = nil
			arg0_11.inDownCnt = nil
		end
	end, 1, -1)

	arg0_11.timer:Start()
	arg0_11.timer.func()
end

function var0_0.OnStartGame(arg0_13)
	var1_0(arg0_13.jumpBtn, function()
		arg0_13.controller:PlayerJump()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_13:OnSlip(arg0_13.moveBtn, function()
		arg0_13.rightOffse = 0.06
		arg0_13.leftOffse = 0
	end, function()
		arg0_13.rightOffse = 0
		arg0_13.leftOffse = -0.06
	end, function()
		arg0_13.rightOffse = 0
		arg0_13.leftOffse = 0
	end, function()
		arg0_13.rightOffse = 0
		arg0_13.leftOffse = 0
	end)
end

function var0_0.OnSlip(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19)
	local var0_19 = GetOrAddComponent(arg1_19, "EventTriggerListener")
	local var1_19 = GameObject.Find("UICamera"):GetComponent("Camera"):WorldToScreenPoint(arg0_19.leftLayout.position)
	local var2_19 = 0
	local var3_19 = 10

	local function var4_19(arg0_20, arg1_20)
		var2_19 = arg1_20.position.x - var1_19.x

		if var2_19 < -var3_19 then
			if arg3_19 then
				arg3_19()
			end
		elseif var2_19 > var3_19 then
			if arg2_19 then
				arg2_19()
			end
		elseif arg5_19 then
			arg5_19()
		end
	end

	var0_19:AddPointDownFunc(function(arg0_21, arg1_21)
		var2_19 = 0

		var4_19(arg0_21, arg1_21)
	end)
	var0_19:AddDragFunc(var4_19)
	var0_19:AddPointUpFunc(function(arg0_22, arg1_22)
		var2_19 = 0

		if arg4_19 then
			arg4_19()
		end
	end)
end

function var0_0.ClearSlip(arg0_23, arg1_23)
	local var0_23 = GetOrAddComponent(arg1_23, "EventTriggerListener")

	var0_23:RemovePointDownFunc()
	var0_23:RemovePointUpFunc()
	var0_23:RemoveDragFunc()
end

function var0_0.Update(arg0_24)
	arg0_24:AddDebugInput()

	arg0_24.hrzOffse = arg0_24.leftOffse + arg0_24.rightOffse

	arg0_24.controller:OnStickChange(arg0_24.hrzOffse)
end

function var0_0.AddDebugInput(arg0_25)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_25.leftOffse = -0.06
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_25.leftOffse = 0
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_25.rightOffse = 0.06
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_25.rightOffse = 0
		end

		if Input.GetKeyDown(KeyCode.Space) then
			arg0_25.controller:PlayerJump()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end
end

function var0_0.OnCreateMap(arg0_26, arg1_26, arg2_26)
	arg0_26.map = TowerClimbingMap.New(arg0_26, arg1_26)

	arg0_26.map:Init(arg2_26)
end

function var0_0.ResetParams(arg0_27)
	arg0_27.leftOffse = 0
	arg0_27.rightOffse = 0
	arg0_27.hrzOffse = 0
end

function var0_0.OnEndGame(arg0_28, arg1_28, arg2_28, arg3_28)
	arg0_28:ResetParams()
	removeOnButton(arg0_28.jumpBtn)
	arg0_28:ShowResultPanel(arg1_28, arg2_28, arg3_28)
end

function var0_0.OnExitGame(arg0_29)
	setActive(arg0_29.overView, true)
	setActive(arg0_29.gameView, false)

	if arg0_29.map then
		arg0_29.map:Dispose()
	end
end

function var0_0.ShowQuitPanel(arg0_30)
	arg0_30:ActivePanel(arg0_30.quitPanel, true)
	onButton(arg0_30, arg0_30.quitPanelCconfirmBtn, function()
		arg0_30:ActivePanel(arg0_30.quitPanel, false)
		arg0_30.controller:EndGame()
	end, SFX_PANEL)
	onButton(arg0_30, arg0_30.quitPanelCancelBtn, function()
		arg0_30:ActivePanel(arg0_30.quitPanel, false)
	end, SFX_PANEL)
end

function var0_0.ShowResultPanel(arg0_33, arg1_33, arg2_33, arg3_33)
	arg0_33:ActivePanel(arg0_33.resultPanel, true)

	arg0_33.resultPanelScoreTxt.text = arg1_33

	if arg0_33.highScores and arg3_33 <= #arg0_33.highScores then
		arg0_33.resultPanelHScoreTxt.text = arg0_33.highScores[arg3_33]
	else
		arg0_33.resultPanelHScoreTxt.text = arg2_33
	end

	onButton(arg0_33, arg0_33.resultPanelEndBtn, function()
		arg0_33:ActivePanel(arg0_33.resultPanel, false)
		arg0_33.controller:ExitGame()
	end, SFX_PANEL)
end

function var0_0.SetHighScore(arg0_35, arg1_35)
	arg0_35.highScores = arg1_35
end

function var0_0.ActivePanel(arg0_36, arg1_36, arg2_36)
	if arg2_36 then
		pg.UIMgr.GetInstance():BlurPanel(arg1_36)
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg1_36, arg0_36._tf)
	end

	setActive(arg1_36, arg2_36)
end

function var0_0.onBackPressed(arg0_37)
	if arg0_37.inDownCnt then
		return true
	end

	if arg0_37.controller.IsStarting then
		arg0_37:ShowQuitPanel()

		return true
	end

	if isActive(arg0_37.resultPanel) then
		arg0_37:ActivePanel(arg0_37.resultPanel, false)
		arg0_37.controller:ExitGame()

		return true
	end

	return false
end

function var0_0.Dispose(arg0_38)
	if arg0_38.timer then
		arg0_38.timer:Stop()

		arg0_38.timer = nil
	end

	var2_0(arg0_38.jumpBtn)
	arg0_38:ClearSlip(arg0_38.moveBtn)
	pg.DelegateInfo.Dispose(arg0_38)

	if arg0_38.map then
		arg0_38.map:Dispose()
	end
end

return var0_0
