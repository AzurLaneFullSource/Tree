local var0 = class("TowerClimbingView")

local function var1(arg0, arg1, arg2)
	local var0 = GetOrAddComponent(arg0, "EventTriggerListener")

	var0:AddPointDownFunc(function(arg0, arg1)
		if arg1 then
			arg1()
		end
	end)
	var0:AddPointUpFunc(function(arg0, arg1)
		if arg2 then
			arg2()
		end
	end)
end

local function var2(arg0)
	local var0 = GetOrAddComponent(arg0, "EventTriggerListener")

	var0:RemovePointDownFunc()
	var0:RemovePointUpFunc()
end

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.controller = arg1
end

function var0.SetUI(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.overView = findTF(arg0._tf, "overview")
	arg0.gameView = findTF(arg0._tf, "AD")
	arg0.maps = {
		findTF(arg0._tf, "overview/maps/1"),
		findTF(arg0._tf, "overview/maps/2"),
		findTF(arg0._tf, "overview/maps/3")
	}
	arg0.exitGameBtn = findTF(arg0.gameView, "back")
	arg0.jumpBtn = findTF(arg0.gameView, "prints/right_btn_layout/up")
	arg0.leftLayout = findTF(arg0.gameView, "prints/left_btn_layout")
	arg0.moveBtn = findTF(arg0.leftLayout, "move_btn")
	arg0.quitPanel = findTF(arg0._tf, "quit_panel")
	arg0.quitPanelCancelBtn = arg0.quitPanel:Find("frame/cancel")
	arg0.quitPanelCconfirmBtn = arg0.quitPanel:Find("frame/confirm")
	arg0.resultPanel = findTF(arg0._tf, "result_panel")
	arg0.resultPanelScoreTxt = arg0.resultPanel:Find("frame/curr/Text"):GetComponent(typeof(Text))
	arg0.resultPanelHScoreTxt = arg0.resultPanel:Find("frame/higtest/Text"):GetComponent(typeof(Text))
	arg0.resultPanelEndBtn = arg0.resultPanel:Find("frame/cancel")
	arg0.helpBtn = arg0._tf:Find("overview/logo/help")
	arg0.enterPanel = arg0._tf:Find("enter_panel")
	arg0.enterPanelTxt = arg0.enterPanel:Find("Text"):GetComponent(typeof(Text))

	arg0:ResetParams()
end

function var0.OnEnter(arg0, arg1)
	setActive(arg0.overView, true)
	setActive(arg0.gameView, false)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.towerclimbing_gametip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.exitGameBtn, function()
		arg0:ShowQuitPanel()
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.maps) do
		onButton(arg0, iter1, function()
			arg0.controller:StartGame(iter0)
		end, SFX_PANEL)
	end
end

function var0.DoEnter(arg0, arg1)
	setActive(arg0.overView, false)
	setActive(arg0.gameView, true)

	arg0.inDownCnt = true

	arg0:ActivePanel(arg0.enterPanel, true)

	local var0 = 4

	arg0.timer = Timer.New(function()
		var0 = var0 - 1

		if var0 == 3 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_PILE_COUNTDOWN)
		end

		arg0.enterPanelTxt.text = var0

		if var0 == 0 then
			arg1()
			arg0:ActivePanel(arg0.enterPanel, false)
			arg0.timer:Stop()

			arg0.timer = nil
			arg0.inDownCnt = nil
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.OnStartGame(arg0)
	var1(arg0.jumpBtn, function()
		arg0.controller:PlayerJump()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0:OnSlip(arg0.moveBtn, function()
		arg0.rightOffse = 0.06
		arg0.leftOffse = 0
	end, function()
		arg0.rightOffse = 0
		arg0.leftOffse = -0.06
	end, function()
		arg0.rightOffse = 0
		arg0.leftOffse = 0
	end, function()
		arg0.rightOffse = 0
		arg0.leftOffse = 0
	end)
end

function var0.OnSlip(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = GetOrAddComponent(arg1, "EventTriggerListener")
	local var1 = GameObject.Find("UICamera"):GetComponent("Camera"):WorldToScreenPoint(arg0.leftLayout.position)
	local var2 = 0
	local var3 = 10

	local function var4(arg0, arg1)
		var2 = arg1.position.x - var1.x

		if var2 < -var3 then
			if arg3 then
				arg3()
			end
		elseif var2 > var3 then
			if arg2 then
				arg2()
			end
		elseif arg5 then
			arg5()
		end
	end

	var0:AddPointDownFunc(function(arg0, arg1)
		var2 = 0

		var4(arg0, arg1)
	end)
	var0:AddDragFunc(var4)
	var0:AddPointUpFunc(function(arg0, arg1)
		var2 = 0

		if arg4 then
			arg4()
		end
	end)
end

function var0.ClearSlip(arg0, arg1)
	local var0 = GetOrAddComponent(arg1, "EventTriggerListener")

	var0:RemovePointDownFunc()
	var0:RemovePointUpFunc()
	var0:RemoveDragFunc()
end

function var0.Update(arg0)
	arg0:AddDebugInput()

	arg0.hrzOffse = arg0.leftOffse + arg0.rightOffse

	arg0.controller:OnStickChange(arg0.hrzOffse)
end

function var0.AddDebugInput(arg0)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0.leftOffse = -0.06
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0.leftOffse = 0
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0.rightOffse = 0.06
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0.rightOffse = 0
		end

		if Input.GetKeyDown(KeyCode.Space) then
			arg0.controller:PlayerJump()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end
end

function var0.OnCreateMap(arg0, arg1, arg2)
	arg0.map = TowerClimbingMap.New(arg0, arg1)

	arg0.map:Init(arg2)
end

function var0.ResetParams(arg0)
	arg0.leftOffse = 0
	arg0.rightOffse = 0
	arg0.hrzOffse = 0
end

function var0.OnEndGame(arg0, arg1, arg2, arg3)
	arg0:ResetParams()
	removeOnButton(arg0.jumpBtn)
	arg0:ShowResultPanel(arg1, arg2, arg3)
end

function var0.OnExitGame(arg0)
	setActive(arg0.overView, true)
	setActive(arg0.gameView, false)

	if arg0.map then
		arg0.map:Dispose()
	end
end

function var0.ShowQuitPanel(arg0)
	arg0:ActivePanel(arg0.quitPanel, true)
	onButton(arg0, arg0.quitPanelCconfirmBtn, function()
		arg0:ActivePanel(arg0.quitPanel, false)
		arg0.controller:EndGame()
	end, SFX_PANEL)
	onButton(arg0, arg0.quitPanelCancelBtn, function()
		arg0:ActivePanel(arg0.quitPanel, false)
	end, SFX_PANEL)
end

function var0.ShowResultPanel(arg0, arg1, arg2, arg3)
	arg0:ActivePanel(arg0.resultPanel, true)

	arg0.resultPanelScoreTxt.text = arg1

	if arg0.highScores and arg3 <= #arg0.highScores then
		arg0.resultPanelHScoreTxt.text = arg0.highScores[arg3]
	else
		arg0.resultPanelHScoreTxt.text = arg2
	end

	onButton(arg0, arg0.resultPanelEndBtn, function()
		arg0:ActivePanel(arg0.resultPanel, false)
		arg0.controller:ExitGame()
	end, SFX_PANEL)
end

function var0.SetHighScore(arg0, arg1)
	arg0.highScores = arg1
end

function var0.ActivePanel(arg0, arg1, arg2)
	if arg2 then
		pg.UIMgr.GetInstance():BlurPanel(arg1)
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg1, arg0._tf)
	end

	setActive(arg1, arg2)
end

function var0.onBackPressed(arg0)
	if arg0.inDownCnt then
		return true
	end

	if arg0.controller.IsStarting then
		arg0:ShowQuitPanel()

		return true
	end

	if isActive(arg0.resultPanel) then
		arg0:ActivePanel(arg0.resultPanel, false)
		arg0.controller:ExitGame()

		return true
	end

	return false
end

function var0.Dispose(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	var2(arg0.jumpBtn)
	arg0:ClearSlip(arg0.moveBtn)
	pg.DelegateInfo.Dispose(arg0)

	if arg0.map then
		arg0.map:Dispose()
	end
end

return var0
