local var0_0 = class("MusicBeatGameView", import("..BaseMiniGameView"))

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1._gameVo = MusicBeatGameVo.New(MusicBeatGameConst.mini_game_id)
end

function var0_0.getUIName(arg0_2)
	return MusicBeatGameConst.game_ui
end

function var0_0.getBGM(arg0_3)
	return MusicBeatGameConst.menu_bgm
end

function var0_0.didEnter(arg0_4)
	arg0_4:initEvent()
	arg0_4:initUI()

	if arg0_4.contextData.rank then
		arg0_4.menuUI:showRankUI()
	end
end

function var0_0.initEvent(arg0_5)
	if not arg0_5.handle then
		arg0_5.handle = FixedUpdateBeat:CreateListener(arg0_5.OnUpdate, arg0_5)

		FixedUpdateBeat:AddListener(arg0_5.handle)
	end

	arg0_5:bind(MusicBeatGameEvent.LEVEL_GAME, function(arg0_6, arg1_6, arg2_6)
		if arg1_6 then
			arg0_5:onGameOver(false)
		else
			arg0_5:resumeGame()
		end
	end)
	arg0_5:bind(MusicBeatGameEvent.COUNT_DOWN, function(arg0_7, arg1_7, arg2_7)
		arg0_5:gameStart()
	end)
	arg0_5:bind(MusicBeatGameEvent.ON_HOME, function(arg0_8, arg1_8, arg2_8)
		arg0_5:emit(BaseUI.ON_HOME)
	end)
	arg0_5:bind(MusicBeatGameEvent.OPEN_PAUSE_UI, function(arg0_9, arg1_9, arg2_9)
		arg0_5.popUI:popPauseUI()
	end)
	arg0_5:bind(MusicBeatGameEvent.OPEN_LEVEL_UI, function(arg0_10, arg1_10, arg2_10)
		arg0_5.popUI:popLeaveUI()
	end)
	arg0_5:bind(MusicBeatGameEvent.PAUSE_GAME, function(arg0_11, arg1_11, arg2_11)
		if arg1_11 then
			arg0_5:pauseGame()
		else
			arg0_5:resumeGame()
		end
	end)
	arg0_5:bind(MusicBeatGameEvent.BACK_MENU, function(arg0_12, arg1_12, arg2_12)
		arg0_5.menuUI:update(arg0_5:GetMGHubData())
		arg0_5.menuUI:show(true)
		arg0_5.gameUI:show(false)
		arg0_5.gameScene:showContainer(false)
		arg0_5:changeBgm(MusicBeatGameConst.bgm_type_menu)
		pg.BgmMgr.GetInstance():ContinuePlay()
		arg0_5:clearGame()
	end)
	arg0_5:bind(MusicBeatGameEvent.CLOSE_GAME, function(arg0_13, arg1_13, arg2_13)
		arg0_5:closeView()
	end)
	arg0_5:bind(MusicBeatGameEvent.GAME_OVER, function(arg0_14, arg1_14, arg2_14)
		arg0_5:onGameOver(arg1_14)
	end)
	arg0_5:bind(MusicBeatGameEvent.SHOW_RULE, function(arg0_15, arg1_15, arg2_15)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[MusicBeatGameConst.rule_tip].tip
		})
	end)
	arg0_5:bind(MusicBeatGameEvent.SHOW_RANK, function(arg0_16, arg1_16, arg2_16)
		arg0_5:getRankData()
		arg0_5.popUI:showRank(true)
	end)
	arg0_5:bind(MusicBeatGameEvent.READY_START, function(arg0_17, arg1_17, arg2_17)
		arg0_5:readyStart()
	end)
	arg0_5:bind(MusicBeatGameEvent.STORE_SERVER, function(arg0_18, arg1_18, arg2_18)
		getProxy(MiniGameProxy):UpdataHighScore(arg0_5._gameVo.gameId, arg1_18)
	end)
	arg0_5:bind(MusicBeatGameEvent.SUBMIT_GAME_SUCCESS, function(arg0_19, arg1_19, arg2_19)
		if not arg0_5.sendSuccessFlag then
			arg0_5.sendSuccessFlag = true

			arg0_5:SendSuccess(0)
		end
	end)
	arg0_5:bind(MusicBeatGameEvent.ADD_SCORE, function(arg0_20, arg1_20, arg2_20)
		arg0_5:addScore(arg1_20.num)
		arg0_5.gameUI:addScore(arg1_20)
	end)
end

function var0_0.initUI(arg0_21)
	arg0_21._gameVo:setGameTpl(findTF(arg0_21._tf, "tpl"))
	setActive(findTF(arg0_21._tf, "tpl"), false)

	arg0_21.clickMask = findTF(arg0_21._tf, "clickMask")
	arg0_21.popUI = MusicBeatGamePopUI.New(arg0_21._tf, arg0_21, arg0_21._gameVo)

	arg0_21.popUI:clearUI()

	arg0_21.gameUI = MusicBeatGamingUI.New(arg0_21._tf, arg0_21, arg0_21._gameVo)

	arg0_21.gameUI:show(false)

	arg0_21.menuUI = MusicBeatGameMenuUI.New(arg0_21._tf, arg0_21, arg0_21._gameVo)

	arg0_21.menuUI:update(arg0_21:GetMGHubData())
	arg0_21.menuUI:show(true)

	arg0_21.gameScene = MusicBeatGameScene.New(arg0_21._tf, arg0_21, arg0_21._gameVo)
end

function var0_0.changeBgm(arg0_22, arg1_22)
	local var0_22

	if arg1_22 == MusicBeatGameConst.bgm_type_default then
		var0_22 = arg0_22:getBGM()

		if not var0_22 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_22 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_22 = pg.voice_bgm.NewMainScene.bgm
			end
		end
	elseif arg1_22 == MusicBeatGameConst.bgm_type_menu then
		var0_22 = MusicBeatGameConst.menu_bgm
	elseif arg1_22 == MusicBeatGameConst.bgm_type_game then
		var0_22 = MusicBeatGameConst.game_bgm
	elseif arg1_22 == MusicBeatGameConst.bgm_type_intro then
		var0_22 = MusicBeatGameConst.intro_bgm
	end

	pg.BgmMgr.GetInstance():Push(arg0_22.__cname, var0_22)
end

function var0_0.OnUpdate(arg0_23)
	arg0_23:gameStep()
end

function var0_0.readyStart(arg0_24)
	pg.BgmMgr.GetInstance():StopPlay()

	arg0_24.readyStartFlag = true

	arg0_24._gameVo:prepare()
	arg0_24.popUI:readyStart()
	arg0_24.menuUI:show(false)
	arg0_24.gameUI:show(false)
	arg0_24.gameScene:readyStart()
end

function var0_0.gameStart(arg0_25)
	arg0_25.readyStartFlag = false
	arg0_25.gameStartFlag = true
	arg0_25.sendSuccessFlag = false

	arg0_25.popUI:popCountUI(false)
	arg0_25.gameUI:start()
	arg0_25.gameUI:show(true)
	arg0_25.gameScene:start()
	arg0_25:timerStart()
end

function var0_0.gameStep(arg0_26)
	if arg0_26.gameStartFlag and not arg0_26.gameStop then
		arg0_26:stepRunTimeData()
		arg0_26.gameUI:step(arg0_26._gameVo.deltaTime)
		arg0_26.gameScene:step(arg0_26._gameVo.deltaTime)
		Physics2D.Simulate(arg0_26._gameVo.deltaTime)
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_26:emit(MusicBeatGameEvent.KEY_CODE_DOWN, KeyCode.A)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_26:emit(MusicBeatGameEvent.KEY_CODE_DOWN, KeyCode.D)
		end
	end
end

function var0_0.timerStart(arg0_27)
	arg0_27.gameStop = false
end

function var0_0.timerResume(arg0_28)
	arg0_28.gameStop = false

	arg0_28.gameScene:resume()
end

function var0_0.timerStop(arg0_29)
	arg0_29.gameStop = true

	arg0_29.gameScene:stop()
end

function var0_0.getRankData(arg0_30)
	pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
		id = arg0_30._gameVo.gameId,
		callback = function(arg0_31)
			local var0_31 = {}

			for iter0_31 = 1, #arg0_31 do
				local var1_31 = {}

				for iter1_31, iter2_31 in pairs(arg0_31[iter0_31]) do
					var1_31[iter1_31] = iter2_31
				end

				table.insert(var0_31, var1_31)
			end

			table.sort(var0_31, function(arg0_32, arg1_32)
				if arg0_32.score ~= arg1_32.score then
					return arg0_32.score > arg1_32.score
				elseif arg0_32.time_data ~= arg1_32.time_data then
					return arg0_32.time_data > arg1_32.time_data
				else
					return arg0_32.player_id < arg1_32.player_id
				end
			end)
			arg0_30.popUI:updateRankData(var0_31)
		end
	})
end

function var0_0.stepRunTimeData(arg0_33)
	local var0_33 = Time.fixedDeltaTime

	arg0_33._gameVo.gameTime = arg0_33._gameVo.gameTime - var0_33
	arg0_33._gameVo.gameStepTime = arg0_33._gameVo.gameStepTime + var0_33
	arg0_33._gameVo.deltaTime = var0_33
end

function var0_0.addScore(arg0_34, arg1_34)
	arg0_34._gameVo.scoreNum = arg0_34._gameVo.scoreNum + arg1_34
end

function var0_0.onGameOver(arg0_35, arg1_35)
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

	local var0_35 = arg1_35 and 1 or 0

	arg0_35:emit(BaseMiniGameMediator.GAME_FINISH_TRACKING, {
		game_id = arg0_35._gameVo.gameId,
		hub_id = arg0_35._gameVo.hubId,
		isComplete = var0_35
	})
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

	arg0_39:timerStop()
end

function var0_0.resumeGame(arg0_40)
	arg0_40.gameStop = false

	arg0_40:timerStart()
	arg0_40:timerResume()
end

function var0_0.clearGame(arg0_41)
	arg0_41.gameStop = true
end

function var0_0.onBackPressed(arg0_42)
	if arg0_42.readyStartFlag then
		return
	end

	if not arg0_42.gameStartFlag then
		return
	else
		if arg0_42.settlementFlag then
			return
		end

		arg0_42.popUI:backPressed()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_43, arg1_43)
	return
end

function var0_0.willExit(arg0_44)
	if arg0_44.handle then
		FixedUpdateBeat:RemoveListener(arg0_44.handle)
	end

	if arg0_44._tf and LeanTween.isTweening(go(arg0_44._tf)) then
		LeanTween.cancel(go(arg0_44._tf))
	end

	Time.timeScale = 1

	arg0_44._gameVo:clear()
end

return var0_0
