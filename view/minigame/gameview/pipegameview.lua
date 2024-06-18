local var0_0 = class("PipeGameView", import("..BaseMiniGameView"))
local var1_0 = import("view.miniGame.gameView.PipeGame.PipeGameVo")

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
end

function var0_0.initData(arg0_4)
	var1_0.Init(arg0_4:GetMGData().id, arg0_4:GetMGHubData().id)
	var1_0.SetGameTpl(findTF(arg0_4._tf, "tpl"))

	local var0_4 = var1_0.frameRate

	if var0_4 > 60 then
		var0_4 = 60
	end

	arg0_4.timer = Timer.New(function()
		arg0_4:onTimer()
	end, 1 / var0_4, -1)
end

function var0_0.initEvent(arg0_6)
	if not arg0_6.handle and IsUnityEditor then
		arg0_6.handle = UpdateBeat:CreateListener(arg0_6.UpdateBeat, arg0_6)

		UpdateBeat:AddListener(arg0_6.handle)
	end

	arg0_6:bind(PipeGameEvent.LEVEL_GAME, function(arg0_7, arg1_7, arg2_7)
		if arg1_7 then
			arg0_6:resumeGame()
			arg0_6.gameScene:setGameOver()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(PipeGameEvent.COUNT_DOWN, function(arg0_8, arg1_8, arg2_8)
		arg0_6:gameStart()
	end)
	arg0_6:bind(PipeGameEvent.ON_HOME, function(arg0_9, arg1_9, arg2_9)
		arg0_6:emit(BaseUI.ON_HOME)
	end)
	arg0_6:bind(PipeGameEvent.OPEN_PAUSE_UI, function(arg0_10, arg1_10, arg2_10)
		arg0_6.popUI:popPauseUI()
	end)
	arg0_6:bind(PipeGameEvent.OPEN_LEVEL_UI, function(arg0_11, arg1_11, arg2_11)
		arg0_6.popUI:popLeaveUI()
	end)
	arg0_6:bind(PipeGameEvent.PAUSE_GAME, function(arg0_12, arg1_12, arg2_12)
		if arg1_12 then
			arg0_6:pauseGame()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(PipeGameEvent.BACK_MENU, function(arg0_13, arg1_13, arg2_13)
		arg0_6.menuUI:update(arg0_6:GetMGHubData())
		arg0_6.menuUI:show(true)
		arg0_6.gameUI:show(false)
		arg0_6.gameScene:showContainer(false)
		arg0_6:changeBgm(PipeGameConst.bgm_type_default)
	end)
	arg0_6:bind(PipeGameEvent.CLOSE_GAME, function(arg0_14, arg1_14, arg2_14)
		arg0_6:closeView()
	end)
	arg0_6:bind(PipeGameEvent.GAME_OVER, function(arg0_15, arg1_15, arg2_15)
		arg0_6:onGameOver()
	end)
	arg0_6:bind(PipeGameEvent.SHOW_RULE, function(arg0_16, arg1_16, arg2_16)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var1_0.rule_tip].tip
		})
	end)
	arg0_6:bind(PipeGameEvent.SHOW_RANK, function(arg0_17, arg1_17, arg2_17)
		arg0_6.popUI:showRank(true)
	end)
	arg0_6:bind(PipeGameEvent.READY_START, function(arg0_18, arg1_18, arg2_18)
		arg0_6:readyStart()
	end)
	arg0_6:bind(PipeGameEvent.STORE_SERVER, function(arg0_19, arg1_19, arg2_19)
		getProxy(MiniGameProxy):UpdataHighScore(var1_0.game_id, arg1_19)
	end)
	arg0_6:bind(PipeGameEvent.SUBMIT_GAME_SUCCESS, function(arg0_20, arg1_20, arg2_20)
		if not arg0_6.sendSuccessFlag then
			arg0_6.sendSuccessFlag = true

			arg0_6:SendSuccess(0)
		end
	end)
	arg0_6:bind(PipeGameEvent.ADD_SCORE, function(arg0_21, arg1_21, arg2_21)
		arg0_6:addScore(arg1_21.num)
		arg0_6.gameUI:addScore(arg1_21)
	end)
end

function var0_0.initUI(arg0_22)
	if IsUnityEditor then
		setActive(findTF(arg0_22._tf, "tpl"), false)
	end

	arg0_22.clickMask = findTF(arg0_22._tf, "clickMask")
	arg0_22.popUI = PipeGamePopUI.New(arg0_22._tf, arg0_22)

	arg0_22.popUI:clearUI()

	arg0_22.gameUI = PipeGamingUI.New(arg0_22._tf, arg0_22)

	arg0_22.gameUI:show(false)

	arg0_22.menuUI = PipeGameMenuUI.New(arg0_22._tf, arg0_22)

	arg0_22.menuUI:update(arg0_22:GetMGHubData())
	arg0_22.menuUI:show(true)

	arg0_22.gameScene = PipeGameScene.New(arg0_22._tf, arg0_22)
end

function var0_0.changeBgm(arg0_23, arg1_23)
	local var0_23

	if arg1_23 == PipeGameConst.bgm_type_default then
		var0_23 = arg0_23:getBGM()

		if not var0_23 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_23 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_23 = pg.voice_bgm.NewMainScene.bgm
			end
		end
	elseif arg1_23 == PipeGameConst.bgm_type_menu then
		var0_23 = var1_0.menu_bgm
	elseif arg1_23 == PipeGameConst.bgm_type_game then
		var0_23 = var1_0.game_bgm
	end

	if arg0_23.bgm ~= var0_23 then
		arg0_23.bgm = var0_23

		pg.BgmMgr.GetInstance():Push(arg0_23.__cname, var0_23)
	end
end

function var0_0.UpdateBeat(arg0_24)
	if arg0_24.gameStop or arg0_24.settlementFlag then
		return
	end
end

function var0_0.readyStart(arg0_25)
	arg0_25.readyStartFlag = true

	var1_0.Prepare()
	arg0_25.popUI:readyStart()
	arg0_25.menuUI:show(false)
	arg0_25.gameUI:show(false)
end

function var0_0.gameStart(arg0_26)
	arg0_26.readyStartFlag = false
	arg0_26.gameStartFlag = true
	arg0_26.sendSuccessFlag = false

	arg0_26.popUI:popCountUI(false)
	arg0_26.gameUI:start()
	arg0_26.gameUI:show(true)
	arg0_26.gameScene:start()
	arg0_26:timerStart()
	arg0_26:changeBgm(PipeGameConst.bgm_type_game)
end

function var0_0.changeSpeed(arg0_27, arg1_27)
	return
end

function var0_0.onTimer(arg0_28)
	arg0_28:gameStep()
end

function var0_0.gameStep(arg0_29)
	arg0_29:stepRunTimeData()
	arg0_29.gameScene:step(var1_0.deltaTime)
	arg0_29.gameUI:step(var1_0.deltaTime)
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

	var1_0.gameTime = var1_0.gameTime - var0_33

	if not var1_0.startSettlement then
		var1_0.gameDragTime = var1_0.gameDragTime - var0_33

		if var1_0.gameDragTime < 0 then
			var1_0.gameDragTime = 0
		end
	end

	var1_0.gameStepTime = var1_0.gameStepTime + var0_33
	var1_0.deltaTime = var0_33
end

function var0_0.addScore(arg0_34, arg1_34)
	var1_0.scoreNum = var1_0.scoreNum + arg1_34
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
		return
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

	var1_0.Clear()
end

return var0_0
