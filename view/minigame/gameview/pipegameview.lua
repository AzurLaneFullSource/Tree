local var0 = class("PipeGameView", import("..BaseMiniGameView"))
local var1 = import("view.miniGame.gameView.PipeGame.PipeGameVo")

function var0.getUIName(arg0)
	return var1.game_ui
end

function var0.getBGM(arg0)
	return var1.menu_bgm
end

function var0.didEnter(arg0)
	arg0:initData()
	arg0:initEvent()
	arg0:initUI()
end

function var0.initData(arg0)
	var1.Init(arg0:GetMGData().id, arg0:GetMGHubData().id)
	var1.SetGameTpl(findTF(arg0._tf, "tpl"))

	local var0 = var1.frameRate

	if var0 > 60 then
		var0 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
end

function var0.initEvent(arg0)
	if not arg0.handle and IsUnityEditor then
		arg0.handle = UpdateBeat:CreateListener(arg0.UpdateBeat, arg0)

		UpdateBeat:AddListener(arg0.handle)
	end

	arg0:bind(PipeGameEvent.LEVEL_GAME, function(arg0, arg1, arg2)
		if arg1 then
			arg0:resumeGame()
			arg0.gameScene:setGameOver()
		else
			arg0:resumeGame()
		end
	end)
	arg0:bind(PipeGameEvent.COUNT_DOWN, function(arg0, arg1, arg2)
		arg0:gameStart()
	end)
	arg0:bind(PipeGameEvent.ON_HOME, function(arg0, arg1, arg2)
		arg0:emit(BaseUI.ON_HOME)
	end)
	arg0:bind(PipeGameEvent.OPEN_PAUSE_UI, function(arg0, arg1, arg2)
		arg0.popUI:popPauseUI()
	end)
	arg0:bind(PipeGameEvent.OPEN_LEVEL_UI, function(arg0, arg1, arg2)
		arg0.popUI:popLeaveUI()
	end)
	arg0:bind(PipeGameEvent.PAUSE_GAME, function(arg0, arg1, arg2)
		if arg1 then
			arg0:pauseGame()
		else
			arg0:resumeGame()
		end
	end)
	arg0:bind(PipeGameEvent.BACK_MENU, function(arg0, arg1, arg2)
		arg0.menuUI:update(arg0:GetMGHubData())
		arg0.menuUI:show(true)
		arg0.gameUI:show(false)
		arg0.gameScene:showContainer(false)
		arg0:changeBgm(PipeGameConst.bgm_type_default)
	end)
	arg0:bind(PipeGameEvent.CLOSE_GAME, function(arg0, arg1, arg2)
		arg0:closeView()
	end)
	arg0:bind(PipeGameEvent.GAME_OVER, function(arg0, arg1, arg2)
		arg0:onGameOver()
	end)
	arg0:bind(PipeGameEvent.SHOW_RULE, function(arg0, arg1, arg2)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var1.rule_tip].tip
		})
	end)
	arg0:bind(PipeGameEvent.SHOW_RANK, function(arg0, arg1, arg2)
		arg0.popUI:showRank(true)
	end)
	arg0:bind(PipeGameEvent.READY_START, function(arg0, arg1, arg2)
		arg0:readyStart()
	end)
	arg0:bind(PipeGameEvent.STORE_SERVER, function(arg0, arg1, arg2)
		getProxy(MiniGameProxy):UpdataHighScore(var1.game_id, arg1)
	end)
	arg0:bind(PipeGameEvent.SUBMIT_GAME_SUCCESS, function(arg0, arg1, arg2)
		if not arg0.sendSuccessFlag then
			arg0.sendSuccessFlag = true

			arg0:SendSuccess(0)
		end
	end)
	arg0:bind(PipeGameEvent.ADD_SCORE, function(arg0, arg1, arg2)
		arg0:addScore(arg1.num)
		arg0.gameUI:addScore(arg1)
	end)
end

function var0.initUI(arg0)
	if IsUnityEditor then
		setActive(findTF(arg0._tf, "tpl"), false)
	end

	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.popUI = PipeGamePopUI.New(arg0._tf, arg0)

	arg0.popUI:clearUI()

	arg0.gameUI = PipeGamingUI.New(arg0._tf, arg0)

	arg0.gameUI:show(false)

	arg0.menuUI = PipeGameMenuUI.New(arg0._tf, arg0)

	arg0.menuUI:update(arg0:GetMGHubData())
	arg0.menuUI:show(true)

	arg0.gameScene = PipeGameScene.New(arg0._tf, arg0)
end

function var0.changeBgm(arg0, arg1)
	local var0

	if arg1 == PipeGameConst.bgm_type_default then
		var0 = arg0:getBGM()

		if not var0 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0 = pg.voice_bgm.NewMainScene.bgm
			end
		end
	elseif arg1 == PipeGameConst.bgm_type_menu then
		var0 = var1.menu_bgm
	elseif arg1 == PipeGameConst.bgm_type_game then
		var0 = var1.game_bgm
	end

	if arg0.bgm ~= var0 then
		arg0.bgm = var0

		pg.BgmMgr.GetInstance():Push(arg0.__cname, var0)
	end
end

function var0.UpdateBeat(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end
end

function var0.readyStart(arg0)
	arg0.readyStartFlag = true

	var1.Prepare()
	arg0.popUI:readyStart()
	arg0.menuUI:show(false)
	arg0.gameUI:show(false)
end

function var0.gameStart(arg0)
	arg0.readyStartFlag = false
	arg0.gameStartFlag = true
	arg0.sendSuccessFlag = false

	arg0.popUI:popCountUI(false)
	arg0.gameUI:start()
	arg0.gameUI:show(true)
	arg0.gameScene:start()
	arg0:timerStart()
	arg0:changeBgm(PipeGameConst.bgm_type_game)
end

function var0.changeSpeed(arg0, arg1)
	return
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0:stepRunTimeData()
	arg0.gameScene:step(var1.deltaTime)
	arg0.gameUI:step(var1.deltaTime)
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerResume(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end

	arg0.gameScene:resume()
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end

	arg0.gameScene:stop()
end

function var0.stepRunTimeData(arg0)
	local var0 = Time.deltaTime

	var1.gameTime = var1.gameTime - var0

	if not var1.startSettlement then
		var1.gameDragTime = var1.gameDragTime - var0

		if var1.gameDragTime < 0 then
			var1.gameDragTime = 0
		end
	end

	var1.gameStepTime = var1.gameStepTime + var0
	var1.deltaTime = var0
end

function var0.addScore(arg0, arg1)
	var1.scoreNum = var1.scoreNum + arg1
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()
	arg0:clearController()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), 0.1, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0.popUI:updateSettlementUI()
		arg0.popUI:popSettlementUI(true)
	end))
end

function var0.OnApplicationPaused(arg0)
	if not arg0.gameStartFlag then
		return
	end

	if arg0.readyStartFlag then
		return
	end

	if arg0.settlementFlag then
		return
	end

	arg0:pauseGame()
	arg0.popUI:popPauseUI()
end

function var0.clearController(arg0)
	arg0.gameScene:clear()
end

function var0.pauseGame(arg0)
	arg0.gameStop = true

	arg0:changeSpeed(0)
	arg0:timerStop()
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	arg0:changeSpeed(1)
	arg0:timerStart()
end

function var0.onBackPressed(arg0)
	if arg0.readyStartFlag then
		return
	end

	if not arg0.gameStartFlag then
		return
	else
		if arg0.settlementFlag then
			return
		end

		arg0.popUI:backPressed()
	end
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	return
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil

	var1.Clear()
end

return var0
