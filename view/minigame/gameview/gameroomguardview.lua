local var0_0 = class("GameRoomGuardView", import("..BaseMiniGameView"))
local var1_0 = 1920
local var2_0 = 1080
local var3_0 = "bar-soft"
local var4_0 = 120
local var5_0 = "pvzminigame_help"
local var6_0 = Application.targetFrameRate or 60

function var0_0.getUIName(arg0_1)
	return "GameRoomGuardUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2:initData()
	arg0_2:initEvent()
	arg0_2:initUI()
	arg0_2:initController()
	arg0_2.beachGuardUI:clearUI()
	setActive(arg0_2.bg, true)
	arg0_2.menuUI:show(true)
	arg0_2.menuUI:update(arg0_2:GetMGHubData())
	arg0_2:PlayGuider("NG0035")
end

function var0_0.PlayGuider(arg0_3, arg1_3)
	if not pg.NewStoryMgr.GetInstance():IsPlayed(arg1_3) then
		pg.NewGuideMgr.GetInstance():Play(arg1_3)
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_3
		})
	end
end

function var0_0.initData(arg0_4)
	if var6_0 > 60 then
		var6_0 = 60
	end

	arg0_4.timer = Timer.New(function()
		arg0_4:onTimer()
	end, 1 / var6_0, -1)
	arg0_4.gameData = {
		path = "ui/minigameui/beachguardgameui_atlas",
		game_time = var4_0,
		drop = pg.mini_game[arg0_4:GetMGData().id].simple_config_data.drop,
		total_times = arg0_4:GetMGHubData():getConfig("reward_need"),
		rule_tip = arg0_4:getGameRoomData().game_help,
		asset = BeachGuardAsset.New(arg0_4._tf)
	}
end

function var0_0.initEvent(arg0_6)
	if not arg0_6.handle and IsUnityEditor then
		arg0_6.handle = UpdateBeat:CreateListener(arg0_6.Update, arg0_6)

		UpdateBeat:AddListener(arg0_6.handle)
	end

	arg0_6:bind(BeachGuardGameView.LEVEL_GAME, function(arg0_7, arg1_7, arg2_7)
		if arg1_7 then
			arg0_6:resumeGame()
			arg0_6:onGameOver()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(BeachGuardGameView.COUNT_DOWN, function(arg0_8, arg1_8, arg2_8)
		arg0_6:gameStart()
	end)
	arg0_6:bind(BeachGuardGameView.OPEN_PAUSE_UI, function(arg0_9, arg1_9, arg2_9)
		arg0_6.beachGuardUI:popPauseUI()
	end)
	arg0_6:bind(BeachGuardGameView.OPEN_LEVEL_UI, function(arg0_10, arg1_10, arg2_10)
		arg0_6.beachGuardUI:popLeaveUI()
	end)
	arg0_6:bind(BeachGuardGameView.PAUSE_GAME, function(arg0_11, arg1_11, arg2_11)
		if arg1_11 then
			arg0_6:pauseGame()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(BeachGuardGameView.BACK_MENU, function(arg0_12, arg1_12, arg2_12)
		setActive(arg0_6.sceneContainer, false)
		arg0_6.menuUI:update(arg0_6:GetMGHubData())
		arg0_6.menuUI:show(true)
		arg0_6.gameUI:show(false)
		arg0_6:openCoinLayer(true)
	end)
	arg0_6:bind(BeachGuardGameView.CLOSE_GAME, function(arg0_13, arg1_13, arg2_13)
		arg0_6:closeView()
	end)
	arg0_6:bind(BeachGuardGameView.ENEMY_COMMING, function(arg0_14, arg1_14, arg2_14)
		arg0_6.gameUI:setEnemyComming()
	end)
	arg0_6:bind(BeachGuardGameView.GAME_OVER, function(arg0_15, arg1_15, arg2_15)
		arg0_6:onGameOver()
	end)
	arg0_6:bind(BeachGuardGameView.SHOW_RULE, function(arg0_16, arg1_16, arg2_16)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_6:getGameRoomData().game_help
		})
	end)
	arg0_6:bind(BeachGuardGameView.READY_START, function(arg0_17, arg1_17, arg2_17)
		arg0_6:readyStart()
	end)
	arg0_6:bind(BeachGuardGameView.STORE_SERVER, function(arg0_18, arg1_18, arg2_18)
		arg0_6:StoreDataToServer({
			arg1_18
		})
	end)
	arg0_6:bind(BeachGuardGameView.SUBMIT_GAME_SUCCESS, function(arg0_19, arg1_19, arg2_19)
		if not arg0_6.sendSuccessFlag then
			arg0_6.sendSuccessFlag = true

			arg0_6:SendSuccess(0)
		end
	end)
	arg0_6:bind(BeachGuardGameView.OPEN_BOOK, function(arg0_20, arg1_20, arg2_20)
		arg0_6:openCoinLayer(not arg1_20)
	end)
	arg0_6:bind(BeachGuardGameView.RECYCLES_CHAR, function(arg0_21, arg1_21, arg2_21)
		arg0_6:changeRecycles(arg1_21)
	end)
	arg0_6:bind(BeachGuardGameView.RECYCLES_CHAR_CANCEL, function(arg0_22, arg1_22, arg2_22)
		arg0_6.gameUI:cancelRecycle()
		arg0_6:changeRecycles(false)
	end)
	arg0_6:bind(BeachGuardGameView.DRAG_CHAR, function(arg0_23, arg1_23, arg2_23)
		arg0_6.sceneMgr:setDrag(arg1_23)
	end)
	arg0_6:bind(BeachGuardGameView.PULL_CHAR, function(arg0_24, arg1_24, arg2_24)
		local var0_24 = arg1_24.card_id
		local var1_24 = arg1_24.line_index
		local var2_24 = arg1_24.grid_index
		local var3_24 = BeachGuardConst.char_card[var0_24]
		local var4_24 = var3_24.char_id
		local var5_24 = var3_24.cost
		local var6_24 = var3_24.once
		local var7_24 = arg0_6.runningData.goodsNum
		local var8_24 = arg0_6.runningData.sceneChars

		if var7_24 < var5_24 then
			return
		end

		if var6_24 and table.contains(var8_24, var4_24) then
			return
		end

		if arg0_6.sceneMgr:pullChar(var4_24, var1_24, var2_24) then
			arg0_6:goodsUpdate(-1 * math.abs(var5_24))
			arg0_6:pullSceneChar(var4_24)
		end
	end)
	arg0_6:bind(BeachGuardGameView.USE_SKILL, function(arg0_25, arg1_25, arg2_25)
		arg0_6.sceneMgr:useSkill(arg1_25)
	end)
	arg0_6:bind(BeachGuardGameView.ADD_CRAFT, function(arg0_26, arg1_26, arg2_26)
		arg0_6:goodsUpdate(arg1_26.num)
	end)
	arg0_6:bind(BeachGuardGameView.ADD_ENEMY, function(arg0_27, arg1_27, arg2_27)
		arg0_6.sceneMgr:addEnemy(arg1_27)
	end)
	arg0_6:bind(BeachGuardGameView.CREATE_CHAR_DAMAGE, function(arg0_28, arg1_28, arg2_28)
		arg0_6.sceneMgr:craeteCharDamage(arg1_28)
	end)
	arg0_6:bind(BeachGuardGameView.REMOVE_CHAR, function(arg0_29, arg1_29, arg2_29)
		arg0_6:removeSceneChar(arg1_29:getId())
		arg0_6.sceneMgr:removeChar(arg1_29)

		if arg1_29 and arg1_29:getCamp() == 2 then
			arg0_6:addScore(arg1_29:getScore())
		end
	end)
	arg0_6:bind(BeachGuardGameView.BULLET_DAMAGE, function(arg0_30, arg1_30, arg2_30)
		arg0_6.sceneMgr:bulletDamage(arg1_30)
	end)
end

function var0_0.onEventHandle(arg0_31, arg1_31)
	return
end

function var0_0.initUI(arg0_32)
	arg0_32.sceneMask = findTF(arg0_32._tf, "sceneMask")
	arg0_32.sceneContainer = findTF(arg0_32._tf, "sceneMask/sceneContainer")
	arg0_32.clickMask = findTF(arg0_32._tf, "clickMask")
	arg0_32.bg = findTF(arg0_32._tf, "bg")
	arg0_32.beachGuardUI = BeachGuardUI.New(arg0_32._tf, arg0_32.gameData, arg0_32)
	arg0_32.gameUI = BeachGuardGameUI.New(arg0_32._tf, arg0_32.gameData, arg0_32)
	arg0_32.menuUI = BeachGuardMenuUI.New(arg0_32._tf, arg0_32.gameData, arg0_32)
end

function var0_0.initController(arg0_33)
	arg0_33.sceneMgr = BeachGuardSceneMgr.New(arg0_33.sceneMask, arg0_33.gameData, arg0_33)
end

function var0_0.Update(arg0_34)
	if arg0_34.gameStop or arg0_34.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) then
		-- block empty
	end
end

function var0_0.readyStart(arg0_35)
	arg0_35.readyStartFlag = true

	arg0_35:openCoinLayer(false)
	arg0_35.beachGuardUI:readyStart()
	arg0_35.menuUI:show(false)
	arg0_35.gameUI:show(false)

	local var0_35 = arg0_35:getChapter()
	local var1_35 = BeachGuardConst.chapater_enemy[var0_35].init_goods
	local var2_35 = BeachGuardConst.chapter_data[var0_35]

	if var2_35.fog then
		BeachGuardConst.enemy_bullet_width = BeachGuardConst.enemy_bullet_fog
	else
		BeachGuardConst.enemy_bullet_width = BeachGuardConst.enemy_bullet_defaut
	end

	arg0_35.runningData = {
		scoreNum = 0,
		stepTime = 0,
		gameStepTime = 0,
		gameTime = arg0_35.gameData.game_time,
		chapter = var0_35,
		goodsNum = var1_35 or 0,
		sceneChars = {},
		fog = var2_35.fog
	}

	arg0_35.sceneMgr:setData(arg0_35.runningData)
end

function var0_0.getChapter(arg0_36)
	return 9
end

function var0_0.gameStart(arg0_37)
	arg0_37.readyStartFlag = false
	arg0_37.gameStartFlag = true
	arg0_37.sendSuccessFlag = false

	setActive(arg0_37.sceneContainer, true)
	setActive(arg0_37.bg, false)
	arg0_37.beachGuardUI:popCountUI(false)
	arg0_37.gameUI:firstUpdate(arg0_37.runningData)
	arg0_37.gameUI:show(true)
	arg0_37.sceneMgr:start()
	arg0_37:timerStart()
end

function var0_0.changeSpeed(arg0_38, arg1_38)
	return
end

function var0_0.onTimer(arg0_39)
	arg0_39:gameStep()
end

function var0_0.gameStep(arg0_40)
	arg0_40:stepRunTimeData()
	arg0_40.sceneMgr:step()
	arg0_40.gameUI:update(arg0_40.runningData)

	if arg0_40.runningData.gameTime <= 0 then
		arg0_40:onGameOver()
	end
end

function var0_0.timerStart(arg0_41)
	if not arg0_41.timer.running then
		arg0_41.timer:Start()
	end
end

function var0_0.timerResume(arg0_42)
	if not arg0_42.timer.running then
		arg0_42.timer:Start()
	end
end

function var0_0.timerStop(arg0_43)
	if arg0_43.timer.running then
		arg0_43.timer:Stop()
	end
end

function var0_0.stepRunTimeData(arg0_44)
	local var0_44 = Time.deltaTime

	if var0_44 > 0.016 then
		var0_44 = 0.016
	end

	arg0_44.runningData.gameTime = arg0_44.runningData.gameTime - var0_44
	arg0_44.runningData.gameStepTime = arg0_44.runningData.gameStepTime + var0_44
	arg0_44.runningData.deltaTime = var0_44
end

function var0_0.changeRecycles(arg0_45, arg1_45)
	arg0_45.runningData.recycles = arg1_45

	arg0_45.sceneMgr:changeRecycles(arg1_45)
	arg0_45:runningUpdate()
end

function var0_0.addScore(arg0_46, arg1_46)
	arg0_46.runningData.scoreNum = arg0_46.runningData.scoreNum + arg1_46
end

function var0_0.pullSceneChar(arg0_47, arg1_47)
	table.insert(arg0_47.runningData.sceneChars, arg1_47)
	arg0_47:runningUpdate()
end

function var0_0.removeSceneChar(arg0_48, arg1_48)
	for iter0_48 = #arg0_48.runningData.sceneChars, 1, -1 do
		if arg0_48.runningData.sceneChars[iter0_48] == arg1_48 then
			table.remove(arg0_48.runningData.sceneChars, iter0_48)
		end
	end
end

function var0_0.goodsUpdate(arg0_49, arg1_49)
	arg0_49.runningData.goodsNum = arg0_49.runningData.goodsNum + arg1_49

	arg0_49.gameUI:updateGoods(arg1_49)
end

function var0_0.runningUpdate(arg0_50)
	return
end

function var0_0.onGameOver(arg0_51)
	if arg0_51.settlementFlag then
		return
	end

	arg0_51:timerStop()
	arg0_51:clearGame()

	arg0_51.settlementFlag = true

	setActive(arg0_51.clickMask, true)
	LeanTween.delayedCall(go(arg0_51._tf), 0.1, System.Action(function()
		arg0_51.settlementFlag = false
		arg0_51.gameStartFlag = false

		setActive(arg0_51.clickMask, false)
		arg0_51.beachGuardUI:updateSettlementUI(arg0_51:GetMGData(), arg0_51:GetMGHubData(), arg0_51.runningData)
		arg0_51.beachGuardUI:openSettlementUI(true)
	end))
end

function var0_0.OnApplicationPaused(arg0_53)
	if not arg0_53.gameStartFlag then
		return
	end

	if arg0_53.readyStartFlag then
		return
	end

	if arg0_53.settlementFlag then
		return
	end

	arg0_53:pauseGame()
	arg0_53.beachGuardUI:popPauseUI()
end

function var0_0.clearGame(arg0_54)
	arg0_54.sceneMgr:clear()
end

function var0_0.pauseGame(arg0_55)
	arg0_55.gameStop = true

	arg0_55:changeSpeed(0)
	arg0_55:timerStop()
end

function var0_0.resumeGame(arg0_56)
	arg0_56.gameStop = false

	arg0_56:changeSpeed(1)
	arg0_56:timerStart()
end

function var0_0.onBackPressed(arg0_57)
	if arg0_57.readyStartFlag then
		return
	end

	if not arg0_57.gameStartFlag then
		arg0_57:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_57.settlementFlag then
			return
		end

		arg0_57.beachGuardUI:backPressed()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_58, arg1_58)
	return
end

function var0_0.willExit(arg0_59)
	if arg0_59.handle then
		UpdateBeat:RemoveListener(arg0_59.handle)
	end

	if arg0_59._tf and LeanTween.isTweening(go(arg0_59._tf)) then
		LeanTween.cancel(go(arg0_59._tf))
	end

	if arg0_59.timer and arg0_59.timer.running then
		arg0_59.timer:Stop()
	end

	Time.timeScale = 1
	arg0_59.timer = nil

	arg0_59:destroyController()
	BeachGuardAsset.clear()
end

function var0_0.destroyController(arg0_60)
	return
end

return var0_0
