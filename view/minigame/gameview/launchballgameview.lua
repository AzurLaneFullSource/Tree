local var0_0 = class("LaunchBallGameView", import("..BaseMiniGameView"))

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
var0_0.JOYSTICK_ACTIVE_CHANGE = "joy stick active change"
var0_0.PRESS_SKILL = "press skill"

local var1_0 = true

function var0_0.getUIName(arg0_1)
	return LaunchBallGameVo.game_ui
end

function var0_0.getBGM(arg0_2)
	return LaunchBallGameVo.game_bgm
end

function var0_0.didEnter(arg0_3)
	if not LaunchBallGameVo.gameRoundData then
		LaunchBallGameVo.initRoundData(3, 1)
	end

	arg0_3:initData()
	arg0_3:initEvent()
	arg0_3:initUI()
	arg0_3:initController()

	if LaunchBallGameVo.gameRoundData.type == LaunchBallGameConst.round_type_zhuanshu then
		LaunchBallGameVo.SetPlayer(LaunchBallGameVo.gameRoundData.player_id)
		arg0_3:readyStart()
	end
end

function var0_0.initData(arg0_4)
	LaunchBallGameVo.Init(arg0_4:GetMGData().id, arg0_4:GetMGHubData().id)

	local var0_4 = LaunchBallGameVo.frameRate

	if var0_4 > 60 then
		var0_4 = 60
	end

	arg0_4.timer = Timer.New(function()
		arg0_4:onTimer()
	end, 1 / var0_4, -1)
end

function var0_0.initEvent(arg0_6)
	if not arg0_6.handle and IsUnityEditor then
		arg0_6.handle = UpdateBeat:CreateListener(arg0_6.Update, arg0_6)

		UpdateBeat:AddListener(arg0_6.handle)
	end

	arg0_6:bind(var0_0.LEVEL_GAME, function(arg0_7, arg1_7, arg2_7)
		if arg1_7 then
			arg0_6:resumeGame()
			arg0_6:onGameOver()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(var0_0.COUNT_DOWN, function(arg0_8, arg1_8, arg2_8)
		arg0_6:gameStart()
	end)
	arg0_6:bind(var0_0.OPEN_PAUSE_UI, function(arg0_9, arg1_9, arg2_9)
		arg0_6.popUI:popPauseUI()
	end)
	arg0_6:bind(var0_0.OPEN_LEVEL_UI, function(arg0_10, arg1_10, arg2_10)
		arg0_6.popUI:popLeaveUI()
	end)
	arg0_6:bind(var0_0.PAUSE_GAME, function(arg0_11, arg1_11, arg2_11)
		if arg1_11 then
			arg0_6:pauseGame()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(var0_0.BACK_MENU, function(arg0_12, arg1_12, arg2_12)
		if LaunchBallGameVo.gameRoundData.type ~= LaunchBallGameConst.round_type_wuxian then
			arg0_6:closeView()

			return
		end

		arg0_6.menuUI:update(arg0_6:GetMGHubData())
		arg0_6.menuUI:show(true)
		arg0_6.gameUI:show(false)
		arg0_6.gameScene:showContainer(false)

		local var0_12 = arg0_6:getBGM()

		if not var0_12 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_12 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_12 = pg.voice_bgm.NewMainScene.bgm
			end
		end

		if arg0_6.bgm ~= var0_12 then
			arg0_6.bgm = var0_12

			pg.BgmMgr.GetInstance():Push(arg0_6.__cname, var0_12)
		end
	end)
	arg0_6:bind(var0_0.CLOSE_GAME, function(arg0_13, arg1_13, arg2_13)
		arg0_6:closeView()
	end)
	arg0_6:bind(var0_0.GAME_OVER, function(arg0_14, arg1_14, arg2_14)
		arg0_6:onGameOver()
	end)
	arg0_6:bind(var0_0.SHOW_RULE, function(arg0_15, arg1_15, arg2_15)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[LaunchBallGameVo.rule_tip].tip
		})
	end)
	arg0_6:bind(var0_0.READY_START, function(arg0_16, arg1_16, arg2_16)
		arg0_6:readyStart()
	end)
	arg0_6:bind(var0_0.STORE_SERVER, function(arg0_17, arg1_17, arg2_17)
		arg0_6:StoreDataToServer({
			arg1_17
		})
	end)
	arg0_6:bind(var0_0.SUBMIT_GAME_SUCCESS, function(arg0_18, arg1_18, arg2_18)
		local var0_18 = LaunchBallGameVo.gameRoundData.type
		local var1_18 = LaunchBallGameVo.gameRoundData.type_index
		local var2_18 = LaunchBallGameVo.scoreNum

		LaunchBallGameVo.UpdateGameResultData(LaunchBallGameVo.result_player, LaunchBallGameVo.selectPlayer)
		LaunchBallGameVo.UpdateGameResultData(LaunchBallGameVo.result_round, LaunchBallGameVo.gameRoundData.id)
		LaunchBallActivityMgr.GetGameAward(ActivityConst.MINIGAME_ZUMA, var0_18, var1_18, var2_18)
		LaunchBallTaskMgr.CheckTaskUpdate(LaunchBallGameVo.gameResultData)
	end)
	arg0_6:bind(var0_0.ADD_SCORE, function(arg0_19, arg1_19, arg2_19)
		arg0_6:addScore(arg1_19.num)
		arg0_6.gameUI:addScore(arg1_19)
	end)
	arg0_6:bind(var0_0.JOYSTICK_ACTIVE_CHANGE, function(arg0_20, arg1_20, arg2_20)
		if arg0_6.gameStartFlag then
			arg0_6.gameScene:joystickActive(arg1_20)
		end
	end)
	arg0_6:bind(var0_0.PRESS_SKILL, function(arg0_21, arg1_21, arg2_21)
		arg0_6.gameScene:useSkill()
	end)
end

function var0_0.initUI(arg0_22)
	arg0_22.clickMask = findTF(arg0_22._tf, "clickMask")
	arg0_22.popUI = LaunchBallGamePopUI.New(arg0_22._tf, arg0_22)

	arg0_22.popUI:clearUI()

	arg0_22.gameUI = LaunchBallGamingUI.New(arg0_22._tf, arg0_22)

	arg0_22.gameUI:show(false)

	arg0_22.menuUI = LaunchBallGameMenuUI.New(arg0_22._tf, arg0_22)

	arg0_22.menuUI:update(arg0_22:GetMGHubData())
	arg0_22.menuUI:show(true)
end

function var0_0.initController(arg0_23)
	arg0_23.gameScene = LaunchBallGameScene.New(arg0_23._tf, arg0_23)
end

function var0_0.Update(arg0_24)
	if arg0_24.gameStop or arg0_24.settlementFlag then
		return
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.S) and arg0_24.timer then
			arg0_24:timerStop()
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0_24.gameUI:press(KeyCode.S, false)
		end

		if Input.GetKeyDown(KeyCode.W) and arg0_24.timer then
			arg0_24:timerStart()
		end

		if Input.GetKeyUp(KeyCode.W) then
			arg0_24.gameUI:press(KeyCode.W, false)
		end

		if Input.GetKeyDown(KeyCode.A) then
			arg0_24.gameUI:press(KeyCode.A, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_24.gameUI:press(KeyCode.A, false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_24.gameUI:press(KeyCode.D, true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_24.gameUI:press(KeyCode.D, false)
		end

		if Input.GetKeyDown(KeyCode.J) then
			arg0_24:onTimer()
		end
	end
end

function var0_0.readyStart(arg0_25)
	arg0_25.readyStartFlag = true

	LaunchBallGameVo.Prepare()
	arg0_25.popUI:readyStart()
	arg0_25.menuUI:show(false)
	arg0_25.gameUI:show(false)
end

function var0_0.gameStart(arg0_26)
	local var0_26 = LaunchBallGameConst.map_data[LaunchBallGameVo.gameRoundData.map].bgm

	pg.BgmMgr.GetInstance():Push(arg0_26.__cname, var0_26)

	arg0_26.bgm = var0_26
	arg0_26.readyStartFlag = false
	arg0_26.gameStartFlag = true
	arg0_26.sendSuccessFlag = false

	arg0_26.popUI:popCountUI(false)
	arg0_26.gameUI:start()
	arg0_26.gameUI:show(true)
	arg0_26.gameScene:start()
	arg0_26:timerStart()
end

function var0_0.changeSpeed(arg0_27, arg1_27)
	return
end

function var0_0.onTimer(arg0_28)
	arg0_28:gameStep()
end

function var0_0.gameStep(arg0_29)
	arg0_29:stepRunTimeData()
	arg0_29.gameScene:step()
	arg0_29.gameUI:step()

	if LaunchBallGameVo.gameTime <= 0 then
		arg0_29:onGameOver()
	end
end

function var0_0.timerStart(arg0_30)
	if not arg0_30.timer.running then
		arg0_30.timer:Start()
	end
end

function var0_0.timerResume(arg0_31)
	if not arg0_31.timer.running then
		arg0_31.timer:Start()
	end

	arg0_31.gameScene:resume()
end

function var0_0.timerStop(arg0_32)
	if arg0_32.timer.running then
		arg0_32.timer:Stop()
	end

	arg0_32.gameScene:stop()
end

function var0_0.stepRunTimeData(arg0_33)
	local var0_33 = Time.deltaTime

	if var0_33 > 0.016 then
		var0_33 = 0.016
	end

	LaunchBallGameVo.gameTime = LaunchBallGameVo.gameTime - var0_33
	LaunchBallGameVo.gameStepTime = LaunchBallGameVo.gameStepTime + var0_33
	LaunchBallGameVo.deltaTime = var0_33
end

function var0_0.addScore(arg0_34, arg1_34)
	LaunchBallGameVo.scoreNum = LaunchBallGameVo.scoreNum + arg1_34
end

function var0_0.onGameOver(arg0_35)
	if arg0_35.settlementFlag then
		return
	end

	arg0_35:timerStop()
	arg0_35:clearController()

	arg0_35.settlementFlag = true

	setActive(arg0_35.clickMask, true)
	LeanTween.delayedCall(go(arg0_35._tf), 0.1, System.Action(function()
		arg0_35.settlementFlag = false
		arg0_35.gameStartFlag = false

		setActive(arg0_35.clickMask, false)
		arg0_35.popUI:updateSettlementUI()
		arg0_35.popUI:popSettlementUI(true)
	end))
end

function var0_0.OnApplicationPaused(arg0_37)
	if not arg0_37.gameStartFlag then
		return
	end

	if arg0_37.readyStartFlag then
		return
	end

	if arg0_37.settlementFlag then
		return
	end

	arg0_37:pauseGame()
	arg0_37.popUI:popPauseUI()
end

function var0_0.clearController(arg0_38)
	arg0_38.gameScene:clear()
end

function var0_0.pauseGame(arg0_39)
	arg0_39.gameStop = true

	arg0_39:changeSpeed(0)
	arg0_39:timerStop()
end

function var0_0.resumeGame(arg0_40)
	arg0_40.gameStop = false

	arg0_40:changeSpeed(1)
	arg0_40:timerStart()
end

function var0_0.onBackPressed(arg0_41)
	if arg0_41.readyStartFlag then
		return
	end

	if not arg0_41.gameStartFlag then
		arg0_41:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_41.settlementFlag then
			return
		end

		arg0_41.popUI:backPressed()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_42, arg1_42)
	return
end

function var0_0.willExit(arg0_43)
	if arg0_43.handle then
		UpdateBeat:RemoveListener(arg0_43.handle)
	end

	if arg0_43._tf and LeanTween.isTweening(go(arg0_43._tf)) then
		LeanTween.cancel(go(arg0_43._tf))
	end

	if arg0_43.timer and arg0_43.timer.running then
		arg0_43.timer:Stop()
	end

	Time.timeScale = 1
	arg0_43.timer = nil
end

return var0_0
