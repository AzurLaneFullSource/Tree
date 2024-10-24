local var0_0 = class("BoatAdGameView", import("..BaseMiniGameView"))
local var1_0 = import("view.miniGame.gameView.BoatAdGame.BoatAdGameVo")

function var0_0.getUIName(arg0_1)
	return var1_0.game_ui
end

function var0_0.getBGM(arg0_2)
	return var1_0.menu_bgm
end

function var0_0.didEnter(arg0_3)
	arg0_3:initData()
	arg0_3:initEvent()
	arg0_3:initUI()
	arg0_3:checkGet()
end

function var0_0.checkGet(arg0_4)
	local var0_4 = arg0_4:GetMGHubData()
	local var1_4 = var0_4.ultimate

	if var1_4 and var1_4 == 1 then
		return
	end

	if var1_0.GetGameTimes() == 0 then
		if var1_0.GetGameMaxTimes() > var1_0.GetGameUseTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_4.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.initData(arg0_5)
	var1_0.Init(arg0_5:GetMGData().id, arg0_5:GetMGHubData().id)
	var1_0.SetGameTpl(findTF(arg0_5._tf, "tpl"))

	local var0_5 = Application.targetFrameRate

	if var0_5 > 60 then
		var0_5 = 60
	end

	arg0_5.stepCount = 1 / var0_5 * 0.9
	arg0_5.realTimeStartUp = Time.realtimeSinceStartup
	arg0_5.timer = Timer.New(function()
		if Time.realtimeSinceStartup - arg0_5.realTimeStartUp > arg0_5.stepCount then
			arg0_5:onTimer()

			arg0_5.realTimeStartUp = Time.realtimeSinceStartup
		end
	end, 1 / var0_5, -1)
end

function var0_0.initEvent(arg0_7)
	if not arg0_7.handle and IsUnityEditor then
		arg0_7.handle = UpdateBeat:CreateListener(arg0_7.Update, arg0_7)

		UpdateBeat:AddListener(arg0_7.handle)
	end

	arg0_7:bind(SimpleMGEvent.LEVEL_GAME, function(arg0_8, arg1_8, arg2_8)
		if arg1_8 then
			arg0_7:resumeGame()
			arg0_7:onGameOver()
		else
			arg0_7:resumeGame()
		end
	end)
	arg0_7:bind(SimpleMGEvent.USE_SKILL, function(arg0_9, arg1_9, arg2_9)
		arg0_7.gameScene:useSkill(arg1_9)
	end)
	arg0_7:bind(SimpleMGEvent.COUNT_DOWN, function(arg0_10, arg1_10, arg2_10)
		arg0_7:gameStart()
	end)
	arg0_7:bind(SimpleMGEvent.OPEN_PAUSE_UI, function(arg0_11, arg1_11, arg2_11)
		arg0_7.popUI:popPauseUI()
	end)
	arg0_7:bind(SimpleMGEvent.OPEN_LEVEL_UI, function(arg0_12, arg1_12, arg2_12)
		arg0_7.popUI:popLeaveUI()
	end)
	arg0_7:bind(SimpleMGEvent.PAUSE_GAME, function(arg0_13, arg1_13, arg2_13)
		if arg1_13 then
			arg0_7:pauseGame()
		else
			arg0_7:resumeGame()
		end
	end)
	arg0_7:bind(SimpleMGEvent.BACK_MENU, function(arg0_14, arg1_14, arg2_14)
		arg0_7.menuUI:update(arg0_7:GetMGHubData())
		arg0_7.menuUI:show(true)
		arg0_7.gameUI:show(false)
		arg0_7.gameScene:showContainer(false)

		local var0_14 = arg0_7:getBGM()

		if not var0_14 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_14 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_14 = pg.voice_bgm.NewMainScene.bgm
			end
		end

		if arg0_7.bgm ~= var0_14 then
			arg0_7.bgm = var0_14

			pg.BgmMgr.GetInstance():Push(arg0_7.__cname, var0_14)
		end

		arg0_7:checkGet()
	end)
	arg0_7:bind(SimpleMGEvent.CLOSE_GAME, function(arg0_15, arg1_15, arg2_15)
		arg0_7:closeView()
	end)
	arg0_7:bind(SimpleMGEvent.BACK_HOME, function(arg0_16, arg1_16, arg2_16)
		arg0_7:emit(BaseUI.ON_HOME)
	end)
	arg0_7:bind(SimpleMGEvent.GAME_OVER, function(arg0_17, arg1_17, arg2_17)
		arg0_7:onGameOver(arg1_17)
	end)
	arg0_7:bind(SimpleMGEvent.SHOW_RULE, function(arg0_18, arg1_18, arg2_18)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var1_0.rule_tip].tip
		})
	end)
	arg0_7:bind(SimpleMGEvent.READY_START, function(arg0_19, arg1_19, arg2_19)
		arg0_7:readyStart()
	end)
	arg0_7:bind(SimpleMGEvent.STORE_SERVER, function(arg0_20, arg1_20, arg2_20)
		arg0_7:StoreDataToServer({
			arg1_20
		})
	end)
	arg0_7:bind(SimpleMGEvent.SUBMIT_GAME_SUCCESS, function(arg0_21, arg1_21, arg2_21)
		if not arg0_7.sendSuccessFlag then
			arg0_7.sendSuccessFlag = true

			arg0_7:SendSuccess(0)
		end

		local var0_21 = var1_0.char:getHp()
		local var1_21 = var1_0.scoreNum
		local var2_21 = var1_0.GetGameUseTimes() + 1
		local var3_21 = math.floor(var1_0.gameStepTime)

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_7:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_SUCCESS_DATA,
			args1 = {
				var1_21,
				var2_21,
				var3_21
			}
		})
	end)
	arg0_7:bind(SimpleMGEvent.ADD_SCORE, function(arg0_22, arg1_22, arg2_22)
		arg0_7:addScore(arg1_22)
	end)
	arg0_7:bind(BoatAdGameEvent.OPEN_AD_WINDOW, function(arg0_23, arg1_23, arg2_23)
		arg0_7:pauseGame()
		arg0_7.popUI:oepnAd()
	end)
	arg0_7:bind(BoatAdGameEvent.CLOSE_AD_UI, function(arg0_24, arg1_24, arg2_24)
		arg0_7:resumeGame()
	end)
end

function var0_0.initUI(arg0_25)
	if IsUnityEditor then
		setActive(findTF(arg0_25._tf, "tpl"), false)
	end

	arg0_25.clickMask = findTF(arg0_25._tf, "clickMask")
	arg0_25.popUI = BoatAdGamePopUI.New(arg0_25._tf, arg0_25)

	arg0_25.popUI:clearUI()

	arg0_25.gameUI = BoatAdGamingUI.New(arg0_25._tf, arg0_25)

	arg0_25.gameUI:show(false)

	arg0_25.menuUI = BoatAdGameMenuUI.New(arg0_25._tf, arg0_25)

	arg0_25.menuUI:update(arg0_25:GetMGHubData())
	arg0_25.menuUI:show(true)

	arg0_25.gameScene = BoatAdGameScene.New(arg0_25._tf, arg0_25)
end

function var0_0.Update(arg0_26)
	if arg0_26.gameStop or arg0_26.settlementFlag then
		return
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.S) then
			arg0_26.gameUI:press(KeyCode.S, true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0_26.gameUI:press(KeyCode.S, false)
		end

		if Input.GetKeyDown(KeyCode.W) then
			arg0_26.gameUI:press(KeyCode.W, true)
		end

		if Input.GetKeyUp(KeyCode.W) then
			arg0_26.gameUI:press(KeyCode.W, false)
		end

		if Input.GetKeyDown(KeyCode.A) then
			arg0_26.gameUI:press(KeyCode.A, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_26.gameUI:press(KeyCode.A, false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_26.gameUI:press(KeyCode.D, true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_26.gameUI:press(KeyCode.D, false)
		end

		if Input.GetKeyDown(KeyCode.J) then
			arg0_26.gameScene:press(KeyCode.J, true)
		end
	end
end

function var0_0.readyStart(arg0_27)
	arg0_27.readyStartFlag = true

	var1_0.Prepare()
	arg0_27.popUI:readyStart()
	arg0_27.menuUI:show(false)
	arg0_27.gameUI:show(false)
	setActive(findTF(arg0_27._tf, "sceneBg"), false)
end

function var0_0.gameStart(arg0_28)
	arg0_28.readyStartFlag = false
	arg0_28.gameStartFlag = true
	arg0_28.sendSuccessFlag = false

	arg0_28.popUI:popCountUI(false)
	arg0_28.gameUI:start()
	arg0_28.gameUI:show(true)

	if arg0_28.bgm ~= var1_0.game_bgm then
		arg0_28.bgm = var1_0.game_bgm

		pg.BgmMgr.GetInstance():Push(arg0_28.__cname, var1_0.game_bgm)
	end

	arg0_28.gameScene:start()
	arg0_28:timerStart()
end

function var0_0.changeSpeed(arg0_29, arg1_29)
	return
end

function var0_0.onTimer(arg0_30)
	arg0_30:gameStep()
end

function var0_0.gameStep(arg0_31)
	arg0_31:stepRunTimeData()
	arg0_31.gameScene:step(var1_0.deltaTime)
	arg0_31.gameUI:step(var1_0.deltaTime)

	if var1_0.gameTime <= 0 then
		arg0_31:onGameOver()
	end
end

function var0_0.timerStart(arg0_32)
	if not arg0_32.timer.running then
		arg0_32.realTimeStartUp = Time.realtimeSinceStartup

		arg0_32.timer:Start()
	end
end

function var0_0.timerResume(arg0_33)
	if not arg0_33.timer.running then
		arg0_33.realTimeStartUp = Time.realtimeSinceStartup

		arg0_33.timer:Start()
	end

	arg0_33.gameScene:resume()
end

function var0_0.timerStop(arg0_34)
	if arg0_34.timer.running then
		arg0_34.timer:Stop()
	end

	arg0_34.gameScene:stop()
end

function var0_0.stepRunTimeData(arg0_35)
	local var0_35 = Time.realtimeSinceStartup - arg0_35.realTimeStartUp

	var1_0.gameTime = var1_0.gameTime - var0_35
	var1_0.gameStepTime = var1_0.gameStepTime + var0_35
	var1_0.deltaTime = var0_35
end

function var0_0.addScore(arg0_36, arg1_36)
	var1_0.scoreNum = var1_0.scoreNum + arg1_36
end

function var0_0.onGameOver(arg0_37, arg1_37)
	if arg0_37.settlementFlag then
		return
	end

	arg0_37:timerStop()
	arg0_37:clearController()

	arg0_37.settlementFlag = true

	setActive(arg0_37.clickMask, true)
	LeanTween.delayedCall(go(arg0_37._tf), 0.1, System.Action(function()
		arg0_37.settlementFlag = false
		arg0_37.gameStartFlag = false

		setActive(arg0_37.clickMask, false)
		arg0_37.popUI:updateSettlementUI()
		arg0_37.popUI:popSettlementUI(true)
	end))
	setActive(findTF(arg0_37._tf, "sceneBg"), true)
end

function var0_0.OnApplicationPaused(arg0_39)
	if not arg0_39.gameStartFlag then
		return
	end

	if arg0_39.readyStartFlag then
		return
	end

	if arg0_39.settlementFlag then
		return
	end

	arg0_39:pauseGame()
	arg0_39.popUI:popPauseUI()
end

function var0_0.clearController(arg0_40)
	arg0_40.gameScene:clear()
end

function var0_0.pauseGame(arg0_41)
	arg0_41.gameStop = true

	arg0_41:changeSpeed(0)
	arg0_41:timerStop()
end

function var0_0.resumeGame(arg0_42)
	arg0_42.gameStop = false

	arg0_42:changeSpeed(1)
	arg0_42:timerResume()
end

function var0_0.onBackPressed(arg0_43)
	if arg0_43.readyStartFlag then
		return
	end

	if not arg0_43.gameStartFlag then
		arg0_43:emit(var0_0.ON_BACK_PRESSED)

		return
	else
		if arg0_43.settlementFlag then
			return
		end

		arg0_43.popUI:backPressed()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_44, arg1_44)
	return
end

function var0_0.willExit(arg0_45)
	if arg0_45.handle then
		UpdateBeat:RemoveListener(arg0_45.handle)
	end

	if arg0_45._tf and LeanTween.isTweening(go(arg0_45._tf)) then
		LeanTween.cancel(go(arg0_45._tf))
	end

	if arg0_45.timer and arg0_45.timer.running then
		arg0_45.timer:Stop()
	end

	Time.timeScale = 1
	arg0_45.timer = nil

	var1_0.Clear()
end

return var0_0
