local var0_0 = class("TouchCakeGameView", import("..BaseMiniGameView"))
local var1_0 = import("view.miniGame.gameView.TouchCakeGame.TouchCakeGameVo")
local var2_0 = import("view.miniGame.gameView.TouchCakeGame.TouchCakeGameConst")
local var3_0 = import("view.miniGame.gameView.TouchCakeGame.TouchCakeGameEvent")

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

	arg0_6:bind(var3_0.LEVEL_GAME, function(arg0_7, arg1_7, arg2_7)
		if arg1_7 then
			arg0_6:resumeGame()
			arg0_6:onGameOver()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(var3_0.COUNT_DOWN, function(arg0_8, arg1_8, arg2_8)
		arg0_6:gameStart()
	end)
	arg0_6:bind(var3_0.ON_HOME, function(arg0_9, arg1_9, arg2_9)
		arg0_6:emit(BaseUI.ON_HOME)
	end)
	arg0_6:bind(var3_0.OPEN_PAUSE_UI, function(arg0_10, arg1_10, arg2_10)
		arg0_6.popUI:popPauseUI()
	end)
	arg0_6:bind(var3_0.OPEN_LEVEL_UI, function(arg0_11, arg1_11, arg2_11)
		arg0_6.popUI:popLeaveUI()
	end)
	arg0_6:bind(var3_0.PAUSE_GAME, function(arg0_12, arg1_12, arg2_12)
		if arg1_12 then
			arg0_6:pauseGame()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(var3_0.BACK_MENU, function(arg0_13, arg1_13, arg2_13)
		arg0_6.gameStop = false

		arg0_6.gameScene:resume()
		arg0_6.menuUI:update(arg0_6:GetMGHubData())
		arg0_6.menuUI:show(true)
		arg0_6.gameUI:show(false)
		arg0_6.gameScene:showContainer(false)
		arg0_6:changeBgm(var2_0.bgm_type_default)
	end)
	arg0_6:bind(var3_0.CLOSE_GAME, function(arg0_14, arg1_14, arg2_14)
		arg0_6:closeView()
	end)
	arg0_6:bind(var3_0.GAME_OVER, function(arg0_15, arg1_15, arg2_15)
		arg0_6:onGameOver()
	end)
	arg0_6:bind(var3_0.SHOW_RULE, function(arg0_16, arg1_16, arg2_16)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var1_0.rule_tip].tip
		})
	end)
	arg0_6:bind(var3_0.SHOW_RANK, function(arg0_17, arg1_17, arg2_17)
		arg0_6:getRankData()
		arg0_6.popUI:showRank(true)
	end)
	arg0_6:bind(var3_0.READY_START, function(arg0_18, arg1_18, arg2_18)
		arg0_6:readyStart()
	end)
	arg0_6:bind(var3_0.STORE_SERVER, function(arg0_19, arg1_19, arg2_19)
		getProxy(MiniGameProxy):UpdataHighScore(var1_0.game_id, arg1_19)
	end)
	arg0_6:bind(var3_0.PRESS_DIRECT, function(arg0_20, arg1_20, arg2_20)
		if arg0_6.gameScene then
			arg0_6.gameScene:touchDirect(arg1_20, true)
		end
	end)
	arg0_6:bind(var3_0.SUBMIT_GAME_SUCCESS, function(arg0_21, arg1_21, arg2_21)
		if not arg0_6.sendSuccessFlag then
			arg0_6.sendSuccessFlag = true

			arg0_6:SendSuccess(0)
		end
	end)
	arg0_6:bind(var3_0.ADD_SCORE, function(arg0_22, arg1_22, arg2_22)
		arg0_6:addScore(arg1_22)
		arg0_6.gameUI:updateScore()
	end)
	arg0_6:bind(var3_0.ADD_COMBO, function(arg0_23, arg1_23, arg2_23)
		arg0_6:addCombo()
		arg0_6.gameUI:updateCombo()
	end)
	arg0_6:bind(var3_0.PLAYER_DIZZI, function(arg0_24, arg1_24, arg2_24)
		arg0_6:clearCombo()
		arg0_6.gameUI:updateCombo()
	end)
	arg0_6:bind(var3_0.PLAYER_BOOM, function(arg0_25, arg1_25, arg2_25)
		arg0_6:clearCombo()
		arg0_6.gameUI:updateCombo()
	end)
end

function var0_0.initUI(arg0_26)
	if IsUnityEditor then
		setActive(findTF(arg0_26._tf, "tpl"), false)
	end

	arg0_26.clickMask = findTF(arg0_26._tf, "clickMask")
	arg0_26.popUI = TouchCakePopUI.New(arg0_26._tf, arg0_26)

	arg0_26.popUI:clearUI()

	arg0_26.gameUI = TouchCakeGamingUI.New(arg0_26._tf, arg0_26)

	arg0_26.gameUI:show(false)

	arg0_26.menuUI = TouchCakeMenuUI.New(arg0_26._tf, arg0_26)

	arg0_26.menuUI:update(arg0_26:GetMGHubData())
	arg0_26.menuUI:show(true)

	arg0_26.gameScene = TouchCakeScene.New(arg0_26._tf, arg0_26)
end

function var0_0.changeBgm(arg0_27, arg1_27)
	local var0_27

	if arg1_27 == var2_0.bgm_type_default then
		var0_27 = arg0_27:getBGM()

		if not var0_27 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_27 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_27 = pg.voice_bgm.NewMainScene.bgm
			end
		end
	elseif arg1_27 == var2_0.bgm_type_menu then
		var0_27 = var1_0.menu_bgm
	elseif arg1_27 == var2_0.bgm_type_game then
		var0_27 = var1_0.game_bgm
	end

	if arg0_27.bgm ~= var0_27 then
		arg0_27.bgm = var0_27

		pg.BgmMgr.GetInstance():Push(arg0_27.__cname, var0_27)
	end
end

function var0_0.UpdateBeat(arg0_28)
	if arg0_28.gameStop or arg0_28.settlementFlag or not arg0_28.gameStartFlag then
		return
	end

	if Input.GetKeyDown(KeyCode.A) then
		arg0_28.gameScene:press(KeyCode.A, true)
	elseif Input.GetKeyDown(KeyCode.D) then
		arg0_28.gameScene:press(KeyCode.D, true)
	end
end

function var0_0.readyStart(arg0_29)
	arg0_29.readyStartFlag = true

	var1_0.Prepare()
	arg0_29.popUI:readyStart()
	arg0_29.menuUI:show(false)
	arg0_29.gameUI:show(false)
end

function var0_0.gameStart(arg0_30)
	arg0_30.readyStartFlag = false
	arg0_30.gameStartFlag = true
	arg0_30.sendSuccessFlag = false

	arg0_30.popUI:popCountUI(false)
	arg0_30.gameUI:start()
	arg0_30.gameUI:show(true)
	arg0_30.gameScene:start()
	arg0_30:timerStart()
	arg0_30:changeBgm(var2_0.bgm_type_game)
end

function var0_0.onTimer(arg0_31)
	arg0_31:gameStep()
end

function var0_0.gameStep(arg0_32)
	arg0_32:stepRunTimeData()
	arg0_32.gameScene:step(var1_0.deltaTime)
	arg0_32.gameUI:step(var1_0.deltaTime)

	if var1_0.gameTime <= 0 then
		var1_0.gameTime = 0

		arg0_32:onGameOver()
	end
end

function var0_0.timerStart(arg0_33)
	if not arg0_33.timer.running then
		arg0_33.timer:Start()
	end
end

function var0_0.timerResume(arg0_34)
	if not arg0_34.timer.running then
		arg0_34.timer:Start()
	end

	arg0_34.gameScene:resume()
end

function var0_0.timerStop(arg0_35)
	if arg0_35.timer.running then
		arg0_35.timer:Stop()
	end
end

function var0_0.stepRunTimeData(arg0_36)
	local var0_36 = Time.deltaTime

	var1_0.gameTime = var1_0.gameTime - var0_36
	var1_0.gameStepTime = var1_0.gameStepTime + var0_36
	var1_0.deltaTime = var0_36
end

function var0_0.addScore(arg0_37, arg1_37)
	var1_0.scoreNum = var1_0.scoreNum + arg1_37
end

function var0_0.addCombo(arg0_38)
	var1_0.comboNum = var1_0.comboNum + 1
end

function var0_0.clearCombo(arg0_39)
	var1_0.comboNum = 0
end

function var0_0.onGameOver(arg0_40)
	if arg0_40.settlementFlag then
		return
	end

	arg0_40:pauseGame()
	arg0_40:clearController()

	arg0_40.settlementFlag = true

	setActive(arg0_40.clickMask, true)
	LeanTween.delayedCall(go(arg0_40._tf), 0.1, System.Action(function()
		arg0_40.settlementFlag = false
		arg0_40.gameStartFlag = false

		setActive(arg0_40.clickMask, false)
		arg0_40.popUI:updateSettlementUI()
		arg0_40.popUI:popSettlementUI(true)
		arg0_40:OnApplicationPaused()
	end))
end

function var0_0.OnApplicationPaused(arg0_42)
	if not arg0_42.gameStartFlag then
		return
	end

	if arg0_42.readyStartFlag then
		return
	end

	if arg0_42.settlementFlag then
		return
	end

	arg0_42:pauseGame()
	arg0_42.popUI:popPauseUI()
end

function var0_0.clearController(arg0_43)
	arg0_43.gameScene:clear()
end

function var0_0.pauseGame(arg0_44)
	arg0_44.gameStop = true

	arg0_44.gameScene:stop()
	arg0_44:timerStop()
end

function var0_0.resumeGame(arg0_45)
	arg0_45.gameStop = false

	arg0_45.gameScene:resume()
	arg0_45:timerStart()
end

function var0_0.onBackPressed(arg0_46)
	if arg0_46.readyStartFlag then
		return
	end

	if not arg0_46.gameStartFlag then
		arg0_46:closeView()

		return
	else
		if arg0_46.settlementFlag then
			return
		end

		arg0_46.popUI:backPressed()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_47, arg1_47)
	return
end

function var0_0.getRankData(arg0_48)
	pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
		id = var1_0.game_id,
		callback = function(arg0_49)
			local var0_49 = {}

			for iter0_49 = 1, #arg0_49 do
				local var1_49 = {}

				for iter1_49, iter2_49 in pairs(arg0_49[iter0_49]) do
					var1_49[iter1_49] = iter2_49
				end

				table.insert(var0_49, var1_49)
			end

			table.sort(var0_49, function(arg0_50, arg1_50)
				if arg0_50.score ~= arg1_50.score then
					return arg0_50.score > arg1_50.score
				elseif arg0_50.time_data ~= arg1_50.time_data then
					return arg0_50.time_data > arg1_50.time_data
				else
					return arg0_50.player_id < arg1_50.player_id
				end
			end)
			arg0_48.popUI:updateRankData(var0_49)
		end
	})
end

function var0_0.willExit(arg0_51)
	if arg0_51.handle then
		UpdateBeat:RemoveListener(arg0_51.handle)
	end

	if arg0_51._tf and LeanTween.isTweening(go(arg0_51._tf)) then
		LeanTween.cancel(go(arg0_51._tf))
	end

	if arg0_51.timer and arg0_51.timer.running then
		arg0_51.timer:Stop()
	end

	Time.timeScale = 1
	arg0_51.timer = nil

	if arg0_51.gameUI then
		arg0_51.gameUI:dispose()
	end

	var1_0.Clear()
end

return var0_0
