local var0_0 = class("GameRoomWatermelonView", import("..BaseMiniGameView"))
local var1_0

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)
end

function var0_0.getUIName(arg0_2)
	return WatermelonGameConst.game_room_ui
end

function var0_0.getBGM(arg0_3)
	return WatermelonGameConst.menu_bgm
end

function var0_0.didEnter(arg0_4)
	arg0_4._gameVo = WatermelonGameVo.New(arg0_4:GetMGData().id)
	var1_0 = arg0_4._gameVo

	arg0_4:initEvent()
	arg0_4:initUI()
end

function var0_0.initEvent(arg0_5)
	if not arg0_5.handle then
		arg0_5.handle = FixedUpdateBeat:CreateListener(arg0_5.OnUpdate, arg0_5)

		FixedUpdateBeat:AddListener(arg0_5.handle)
	end

	arg0_5:bind(WatermelonGameEvent.LEVEL_GAME, function(arg0_6, arg1_6, arg2_6)
		if arg1_6 then
			arg0_5:resumeGame()
			arg0_5:onGameOver(false)
		else
			arg0_5:resumeGame()
		end
	end)
	arg0_5:bind(WatermelonGameEvent.COUNT_DOWN, function(arg0_7, arg1_7, arg2_7)
		arg0_5:gameStart()
	end)
	arg0_5:bind(WatermelonGameEvent.ON_HOME, function(arg0_8, arg1_8, arg2_8)
		arg0_5:emit(BaseUI.ON_HOME)
	end)
	arg0_5:bind(WatermelonGameEvent.OPEN_PAUSE_UI, function(arg0_9, arg1_9, arg2_9)
		arg0_5.popUI:popPauseUI()
	end)
	arg0_5:bind(WatermelonGameEvent.OPEN_LEVEL_UI, function(arg0_10, arg1_10, arg2_10)
		arg0_5.popUI:popLeaveUI()
	end)
	arg0_5:bind(WatermelonGameEvent.PAUSE_GAME, function(arg0_11, arg1_11, arg2_11)
		if arg1_11 then
			arg0_5:pauseGame()
		else
			arg0_5:resumeGame()
		end
	end)
	arg0_5:bind(WatermelonGameEvent.BACK_MENU, function(arg0_12, arg1_12, arg2_12)
		arg0_5.menuUI:update(arg0_5:GetMGHubData())
		arg0_5.menuUI:show(true)
		arg0_5.gameUI:show(false)
		arg0_5.gameScene:showContainer(false)
		arg0_5:changeBgm(PipeGameConst.bgm_type_default)
		arg0_5:openCoinLayer(true)
	end)
	arg0_5:bind(WatermelonGameEvent.CLOSE_GAME, function(arg0_13, arg1_13, arg2_13)
		arg0_5:closeView()
	end)
	arg0_5:bind(WatermelonGameEvent.GAME_OVER, function(arg0_14, arg1_14, arg2_14)
		arg0_5:onGameOver(arg1_14)
	end)
	arg0_5:bind(WatermelonGameEvent.SHOW_RULE, function(arg0_15, arg1_15, arg2_15)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[WatermelonGameConst.rule_tip].tip
		})
	end)
	arg0_5:bind(WatermelonGameEvent.SHOW_RANK, function(arg0_16, arg1_16, arg2_16)
		arg0_5:getRankData()
		arg0_5.popUI:showRank(true)
	end)
	arg0_5:bind(WatermelonGameEvent.READY_START, function(arg0_17, arg1_17, arg2_17)
		arg0_5:readyStart()
	end)
	arg0_5:bind(WatermelonGameEvent.STORE_SERVER, function(arg0_18, arg1_18, arg2_18)
		arg0_5:StoreDataToServer({
			arg1_18[1]
		})
	end)
	arg0_5:bind(WatermelonGameEvent.SUBMIT_GAME_SUCCESS, function(arg0_19, arg1_19, arg2_19)
		if not arg0_5.sendSuccessFlag then
			arg0_5.sendSuccessFlag = true

			arg0_5:SendSuccess(arg1_19)
		end
	end)
	arg0_5:bind(WatermelonGameEvent.ADD_SCORE, function(arg0_20, arg1_20, arg2_20)
		arg0_5:addScore(arg1_20.num)
		arg0_5.gameUI:addScore(arg1_20)
	end)
	arg0_5:bind(WatermelonGameEvent.UPDATE_NEXT_BALL, function(arg0_21, arg1_21, arg2_21)
		arg0_5.gameUI:updateBallId(arg1_21)
	end)
end

function var0_0.initUI(arg0_22)
	var1_0:setGameTpl(findTF(arg0_22._tf, "tpl"))
	setActive(findTF(arg0_22._tf, "tpl"), false)

	arg0_22.clickMask = findTF(arg0_22._tf, "clickMask")
	arg0_22.popUI = WatermelonGamePopUI.New(arg0_22._tf, arg0_22, arg0_22._gameVo)

	arg0_22.popUI:clearUI()

	arg0_22.gameUI = WatermelonGamingUI.New(arg0_22._tf, arg0_22, arg0_22._gameVo)

	arg0_22.gameUI:show(false)

	arg0_22.menuUI = WatermelonGameMenuUI.New(arg0_22._tf, arg0_22, arg0_22._gameVo)

	arg0_22.menuUI:update(arg0_22:GetMGHubData())
	arg0_22.menuUI:show(true)

	arg0_22.gameScene = WatermelonGameScene.New(arg0_22._tf, arg0_22, arg0_22._gameVo)
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
		var0_23 = WatermelonGameConst.menu_bgm
	elseif arg1_23 == PipeGameConst.bgm_type_game then
		var0_23 = WatermelonGameConst.game_bgm
	end

	if arg0_23.bgm ~= var0_23 then
		arg0_23.bgm = var0_23

		pg.BgmMgr.GetInstance():Push(arg0_23.__cname, var0_23)
	end
end

function var0_0.OnUpdate(arg0_24)
	arg0_24:gameStep()
end

function var0_0.readyStart(arg0_25)
	arg0_25.readyStartFlag = true

	var1_0:prepare()
	arg0_25.popUI:readyStart()
	arg0_25.menuUI:show(false)
	arg0_25.gameUI:show(false)
	arg0_25:openCoinLayer(false)
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

function var0_0.gameStep(arg0_28)
	if arg0_28.gameStartFlag and not arg0_28.gameStop then
		arg0_28:stepRunTimeData()
		arg0_28.gameUI:step(var1_0.deltaTime)
		arg0_28.gameScene:step(var1_0.deltaTime)
		Physics2D.Simulate(var1_0.deltaTime)
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_28.gameUI:press(KeyCode.A, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_28.gameUI:press(KeyCode.A, false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_28.gameUI:press(KeyCode.D, true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_28.gameUI:press(KeyCode.D, false)
		end

		if Input.GetKeyDown(KeyCode.J) then
			arg0_28.gameUI:press(KeyCode.J, true)
		end
	end
end

function var0_0.timerStart(arg0_29)
	arg0_29.gamestop = false
end

function var0_0.timerResume(arg0_30)
	arg0_30.gamestop = false

	arg0_30.gameScene:resume()
end

function var0_0.timerStop(arg0_31)
	arg0_31.gamestop = true

	arg0_31.gameScene:stop()
end

function var0_0.getRankData(arg0_32)
	pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
		id = var1_0.gameId,
		callback = function(arg0_33)
			local var0_33 = {}

			for iter0_33 = 1, #arg0_33 do
				local var1_33 = {}

				for iter1_33, iter2_33 in pairs(arg0_33[iter0_33]) do
					var1_33[iter1_33] = iter2_33
				end

				table.insert(var0_33, var1_33)
			end

			table.sort(var0_33, function(arg0_34, arg1_34)
				if arg0_34.score ~= arg1_34.score then
					return arg0_34.score > arg1_34.score
				elseif arg0_34.time_data ~= arg1_34.time_data then
					return arg0_34.time_data > arg1_34.time_data
				else
					return arg0_34.player_id < arg1_34.player_id
				end
			end)
			arg0_32.popUI:updateRankData(var0_33)
		end
	})
end

function var0_0.stepRunTimeData(arg0_35)
	local var0_35 = Time.fixedDeltaTime

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

	local var0_37

	var0_37 = arg1_37 and 1 or 0
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
	arg0_42:timerStart()
end

function var0_0.onBackPressed(arg0_43)
	if arg0_43.readyStartFlag then
		return
	end

	if not arg0_43.gameStartFlag then
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
		FixedUpdateBeat:RemoveListener(arg0_45.handle)
	end

	if arg0_45._tf and LeanTween.isTweening(go(arg0_45._tf)) then
		LeanTween.cancel(go(arg0_45._tf))
	end

	Time.timeScale = 1

	var1_0:clear()
end

return var0_0
