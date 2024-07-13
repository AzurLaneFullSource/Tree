local var0_0 = class("CastleGameView", import("..BaseMiniGameView"))

var0_0.LEVEL_GAME = "leavel game"
var0_0.PAUSE_GAME = "pause game "
var0_0.OPEN_PAUSE_UI = "open pause ui"
var0_0.OPEN_LEVEL_UI = "open leave ui"
var0_0.BACK_MENU = "back menu"
var0_0.CLOSE_GAME = "close game"
var0_0.SHOW_RULE = "show rule"
var0_0.READY_START = "ready start"
var0_0.COUNT_DOWN = "count down"
var0_0.STORE_SERVER = "store server"
var0_0.SUBMIT_GAME_SUCCESS = "submit game success"
var0_0.ADD_SCORE = "add score"
var0_0.GAME_OVER = "game over"

function var0_0.getUIName(arg0_1)
	return CastleGameVo.game_ui
end

function var0_0.didEnter(arg0_2)
	arg0_2:initData()
	arg0_2:initEvent()
	arg0_2:initUI()
	arg0_2:initController()
end

function var0_0.initData(arg0_3)
	CastleGameVo.Init(arg0_3:GetMGData().id, arg0_3:GetMGHubData().id)

	local var0_3 = CastleGameVo.frameRate

	if var0_3 > 60 then
		var0_3 = 60
	end

	arg0_3.timer = Timer.New(function()
		arg0_3:onTimer()
	end, 1 / var0_3, -1)
end

function var0_0.initEvent(arg0_5)
	if not arg0_5.handle and IsUnityEditor then
		arg0_5.handle = UpdateBeat:CreateListener(arg0_5.Update, arg0_5)

		UpdateBeat:AddListener(arg0_5.handle)
	end

	arg0_5:bind(var0_0.LEVEL_GAME, function(arg0_6, arg1_6, arg2_6)
		if arg1_6 then
			arg0_5:resumeGame()
			arg0_5:onGameOver()
		else
			arg0_5:resumeGame()
		end
	end)
	arg0_5:bind(var0_0.COUNT_DOWN, function(arg0_7, arg1_7, arg2_7)
		arg0_5:gameStart()
	end)
	arg0_5:bind(var0_0.OPEN_PAUSE_UI, function(arg0_8, arg1_8, arg2_8)
		arg0_5.popUI:popPauseUI()
	end)
	arg0_5:bind(var0_0.OPEN_LEVEL_UI, function(arg0_9, arg1_9, arg2_9)
		arg0_5.popUI:popLeaveUI()
	end)
	arg0_5:bind(var0_0.PAUSE_GAME, function(arg0_10, arg1_10, arg2_10)
		if arg1_10 then
			arg0_5:pauseGame()
		else
			arg0_5:resumeGame()
		end
	end)
	arg0_5:bind(var0_0.BACK_MENU, function(arg0_11, arg1_11, arg2_11)
		arg0_5.menuUI:update(arg0_5:GetMGHubData())
		arg0_5.menuUI:show(true)
		arg0_5.gameUI:show(false)
		arg0_5.gameScene:showContainer(false)

		local var0_11 = arg0_5:getBGM()

		if not var0_11 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_11 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_11 = pg.voice_bgm.NewMainScene.bgm
			end
		end

		if arg0_5.bgm ~= var0_11 then
			arg0_5.bgm = var0_11

			pg.BgmMgr.GetInstance():Push(arg0_5.__cname, var0_11)
		end
	end)
	arg0_5:bind(var0_0.CLOSE_GAME, function(arg0_12, arg1_12, arg2_12)
		arg0_5:closeView()
	end)
	arg0_5:bind(var0_0.GAME_OVER, function(arg0_13, arg1_13, arg2_13)
		arg0_5:onGameOver()
	end)
	arg0_5:bind(var0_0.SHOW_RULE, function(arg0_14, arg1_14, arg2_14)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[CastleGameVo.rule_tip].tip
		})
	end)
	arg0_5:bind(var0_0.READY_START, function(arg0_15, arg1_15, arg2_15)
		arg0_5:readyStart()
	end)
	arg0_5:bind(var0_0.STORE_SERVER, function(arg0_16, arg1_16, arg2_16)
		arg0_5:StoreDataToServer({
			arg1_16
		})
	end)
	arg0_5:bind(var0_0.SUBMIT_GAME_SUCCESS, function(arg0_17, arg1_17, arg2_17)
		if not arg0_5.sendSuccessFlag then
			arg0_5.sendSuccessFlag = true

			arg0_5:SendSuccess(0)
		end
	end)
	arg0_5:bind(var0_0.ADD_SCORE, function(arg0_18, arg1_18, arg2_18)
		arg0_5:addScore(arg1_18.num)
		arg0_5.gameUI:addScore(arg1_18)
	end)
end

function var0_0.initUI(arg0_19)
	arg0_19.clickMask = findTF(arg0_19._tf, "clickMask")
	arg0_19.popUI = CastleGamePopUI.New(arg0_19._tf, arg0_19)

	arg0_19.popUI:clearUI()

	arg0_19.gameUI = CastleGamingUI.New(arg0_19._tf, arg0_19)
	arg0_19.menuUI = CastleGameMenuUI.New(arg0_19._tf, arg0_19)

	arg0_19.menuUI:update(arg0_19:GetMGHubData())
	arg0_19.menuUI:show(true)
end

function var0_0.initController(arg0_20)
	arg0_20.gameScene = CastleGameScene.New(arg0_20._tf, arg0_20)
end

function var0_0.Update(arg0_21)
	if arg0_21.gameStop or arg0_21.settlementFlag then
		return
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.S) then
			arg0_21.gameUI:press(KeyCode.S, true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0_21.gameUI:press(KeyCode.S, false)
		end

		if Input.GetKeyDown(KeyCode.W) then
			arg0_21.gameUI:press(KeyCode.W, true)
		end

		if Input.GetKeyUp(KeyCode.W) then
			arg0_21.gameUI:press(KeyCode.W, false)
		end

		if Input.GetKeyDown(KeyCode.A) then
			arg0_21.gameUI:press(KeyCode.A, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_21.gameUI:press(KeyCode.A, false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_21.gameUI:press(KeyCode.D, true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_21.gameUI:press(KeyCode.D, false)
		end
	end
end

function var0_0.readyStart(arg0_22)
	arg0_22.readyStartFlag = true

	CastleGameVo.Prepare()
	arg0_22.popUI:readyStart()
	arg0_22.menuUI:show(false)
	arg0_22.gameUI:show(false)
end

function var0_0.gameStart(arg0_23)
	arg0_23.readyStartFlag = false
	arg0_23.gameStartFlag = true
	arg0_23.sendSuccessFlag = false

	arg0_23.popUI:popCountUI(false)
	arg0_23.gameUI:start()
	arg0_23.gameUI:show(true)
	arg0_23.gameScene:start()
	arg0_23:timerStart()
end

function var0_0.changeSpeed(arg0_24, arg1_24)
	return
end

function var0_0.onTimer(arg0_25)
	arg0_25:gameStep()
end

function var0_0.gameStep(arg0_26)
	arg0_26:stepRunTimeData()
	arg0_26.gameScene:step()
	arg0_26.gameUI:step()

	if CastleGameVo.gameTime <= 0 then
		arg0_26:onGameOver()
	end
end

function var0_0.timerStart(arg0_27)
	if not arg0_27.timer.running then
		arg0_27.timer:Start()
	end
end

function var0_0.timerResume(arg0_28)
	if not arg0_28.timer.running then
		arg0_28.timer:Start()
	end

	arg0_28.gameScene:resume()
end

function var0_0.timerStop(arg0_29)
	if arg0_29.timer.running then
		arg0_29.timer:Stop()
	end

	arg0_29.gameScene:stop()
end

function var0_0.stepRunTimeData(arg0_30)
	local var0_30 = Time.deltaTime

	if var0_30 > 0.016 then
		var0_30 = 0.016
	end

	CastleGameVo.gameTime = CastleGameVo.gameTime - var0_30
	CastleGameVo.gameStepTime = CastleGameVo.gameStepTime + var0_30
	CastleGameVo.deltaTime = var0_30
end

function var0_0.addScore(arg0_31, arg1_31)
	CastleGameVo.scoreNum = CastleGameVo.scoreNum + arg1_31
end

function var0_0.onGameOver(arg0_32)
	if arg0_32.settlementFlag then
		return
	end

	arg0_32:timerStop()
	arg0_32:clearController()

	arg0_32.settlementFlag = true

	setActive(arg0_32.clickMask, true)
	LeanTween.delayedCall(go(arg0_32._tf), 0.1, System.Action(function()
		arg0_32.settlementFlag = false
		arg0_32.gameStartFlag = false

		setActive(arg0_32.clickMask, false)
		arg0_32.popUI:updateSettlementUI()
		arg0_32.popUI:popSettlementUI(true)
	end))
end

function var0_0.OnApplicationPaused(arg0_34)
	if not arg0_34.gameStartFlag then
		return
	end

	if arg0_34.readyStartFlag then
		return
	end

	if arg0_34.settlementFlag then
		return
	end

	arg0_34:pauseGame()
	arg0_34.popUI:popPauseUI()
end

function var0_0.clearController(arg0_35)
	arg0_35.gameScene:clear()
end

function var0_0.pauseGame(arg0_36)
	arg0_36.gameStop = true

	arg0_36:changeSpeed(0)
	arg0_36:timerStop()
end

function var0_0.resumeGame(arg0_37)
	arg0_37.gameStop = false

	arg0_37:changeSpeed(1)
	arg0_37:timerStart()
end

function var0_0.onBackPressed(arg0_38)
	if arg0_38.readyStartFlag then
		return
	end

	if not arg0_38.gameStartFlag then
		arg0_38:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_38.settlementFlag then
			return
		end

		arg0_38.popUI:backPressed()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_39, arg1_39)
	return
end

function var0_0.willExit(arg0_40)
	if arg0_40.handle then
		UpdateBeat:RemoveListener(arg0_40.handle)
	end

	if arg0_40._tf and LeanTween.isTweening(go(arg0_40._tf)) then
		LeanTween.cancel(go(arg0_40._tf))
	end

	if arg0_40.timer and arg0_40.timer.running then
		arg0_40.timer:Stop()
	end

	Time.timeScale = 1
	arg0_40.timer = nil
end

return var0_0
