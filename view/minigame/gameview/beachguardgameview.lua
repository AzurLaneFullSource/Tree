local var0_0 = class("BeachGuardGameView", import("..BaseMiniGameView"))

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
var0_0.RECYCLES_CHAR = "RECYCLES CHAR"
var0_0.RECYCLES_CHAR_CANCEL = "RECYCLES CHAR CANCEL"
var0_0.DRAG_CHAR = "DRAG CHAR"
var0_0.PULL_CHAR = "PULL CHAR"
var0_0.USE_SKILL = "USE SKILL"
var0_0.ADD_CRAFT = "ADD CRAFT"
var0_0.ADD_ENEMY = "ADD ENEMY"
var0_0.CREATE_CHAR_DAMAGE = "create char damage"
var0_0.REMOVE_CHAR = "REMOVE CHAR"
var0_0.BULLET_DAMAGE = "BULLET DAMAGE"
var0_0.GAME_OVER = "GAME OVER"
var0_0.ENEMY_COMMING = "enemy comming"

local var1_0 = 1920
local var2_0 = 1080
local var3_0 = "bar-soft"
local var4_0 = 6000
local var5_0 = "pvzminigame_help"
local var6_0 = Application.targetFrameRate or 60

function var0_0.getUIName(arg0_1)
	return "BeachGuardGameUI"
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
		rule_tip = var5_0,
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
			helps = pg.gametip[arg0_6.gameData.rule_tip].tip
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
	arg0_6:bind(BeachGuardGameView.RECYCLES_CHAR, function(arg0_20, arg1_20, arg2_20)
		arg0_6:changeRecycles(arg1_20)
	end)
	arg0_6:bind(BeachGuardGameView.RECYCLES_CHAR_CANCEL, function(arg0_21, arg1_21, arg2_21)
		arg0_6.gameUI:cancelRecycle()
		arg0_6:changeRecycles(false)
	end)
	arg0_6:bind(BeachGuardGameView.DRAG_CHAR, function(arg0_22, arg1_22, arg2_22)
		arg0_6.sceneMgr:setDrag(arg1_22)
	end)
	arg0_6:bind(BeachGuardGameView.PULL_CHAR, function(arg0_23, arg1_23, arg2_23)
		local var0_23 = arg1_23.card_id
		local var1_23 = arg1_23.line_index
		local var2_23 = arg1_23.grid_index
		local var3_23 = BeachGuardConst.char_card[var0_23]
		local var4_23 = var3_23.char_id
		local var5_23 = var3_23.cost
		local var6_23 = var3_23.once
		local var7_23 = arg0_6.runningData.goodsNum
		local var8_23 = arg0_6.runningData.sceneChars

		if var7_23 < var5_23 then
			return
		end

		if var6_23 and table.contains(var8_23, var4_23) then
			return
		end

		if arg0_6.sceneMgr:pullChar(var4_23, var1_23, var2_23) then
			arg0_6:goodsUpdate(-1 * math.abs(var5_23))
			arg0_6:pullSceneChar(var4_23)
		end
	end)
	arg0_6:bind(BeachGuardGameView.USE_SKILL, function(arg0_24, arg1_24, arg2_24)
		arg0_6.sceneMgr:useSkill(arg1_24)
	end)
	arg0_6:bind(BeachGuardGameView.ADD_CRAFT, function(arg0_25, arg1_25, arg2_25)
		arg0_6:goodsUpdate(arg1_25.num)
	end)
	arg0_6:bind(BeachGuardGameView.ADD_ENEMY, function(arg0_26, arg1_26, arg2_26)
		arg0_6.sceneMgr:addEnemy(arg1_26)
	end)
	arg0_6:bind(BeachGuardGameView.CREATE_CHAR_DAMAGE, function(arg0_27, arg1_27, arg2_27)
		arg0_6.sceneMgr:craeteCharDamage(arg1_27)
	end)
	arg0_6:bind(BeachGuardGameView.REMOVE_CHAR, function(arg0_28, arg1_28, arg2_28)
		arg0_6:removeSceneChar(arg1_28:getId())
		arg0_6.sceneMgr:removeChar(arg1_28)

		if arg1_28 and arg1_28:getCamp() == 2 then
			arg0_6:addScore(arg1_28:getScore())
		end
	end)
	arg0_6:bind(BeachGuardGameView.BULLET_DAMAGE, function(arg0_29, arg1_29, arg2_29)
		arg0_6.sceneMgr:bulletDamage(arg1_29)
	end)
end

function var0_0.onEventHandle(arg0_30, arg1_30)
	return
end

function var0_0.initUI(arg0_31)
	arg0_31.sceneMask = findTF(arg0_31._tf, "sceneMask")
	arg0_31.sceneContainer = findTF(arg0_31._tf, "sceneMask/sceneContainer")
	arg0_31.clickMask = findTF(arg0_31._tf, "clickMask")
	arg0_31.bg = findTF(arg0_31._tf, "bg")
	arg0_31.beachGuardUI = BeachGuardUI.New(arg0_31._tf, arg0_31.gameData, arg0_31)
	arg0_31.gameUI = BeachGuardGameUI.New(arg0_31._tf, arg0_31.gameData, arg0_31)
	arg0_31.menuUI = BeachGuardMenuUI.New(arg0_31._tf, arg0_31.gameData, arg0_31)
end

function var0_0.initController(arg0_32)
	arg0_32.sceneMgr = BeachGuardSceneMgr.New(arg0_32.sceneMask, arg0_32.gameData, arg0_32)
end

function var0_0.Update(arg0_33)
	if arg0_33.gameStop or arg0_33.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) then
		-- block empty
	end
end

function var0_0.readyStart(arg0_34)
	arg0_34.readyStartFlag = true

	arg0_34.beachGuardUI:readyStart()
	arg0_34.menuUI:show(false)
	arg0_34.gameUI:show(false)

	local var0_34 = arg0_34:getChapter()
	local var1_34 = BeachGuardConst.chapater_enemy[var0_34].init_goods
	local var2_34 = BeachGuardConst.chapter_data[var0_34]

	if var2_34.fog then
		BeachGuardConst.enemy_bullet_width = BeachGuardConst.enemy_bullet_fog
	else
		BeachGuardConst.enemy_bullet_width = BeachGuardConst.enemy_bullet_defaut
	end

	arg0_34.runningData = {
		scoreNum = 0,
		stepTime = 0,
		gameStepTime = 0,
		gameTime = arg0_34.gameData.game_time,
		chapter = var0_34,
		goodsNum = var1_34 or 0,
		sceneChars = {},
		fog = var2_34.fog
	}

	arg0_34.sceneMgr:setData(arg0_34.runningData)
end

function var0_0.getChapter(arg0_35)
	local var0_35

	if not arg0_35:GetMGHubData().usedtime or arg0_35:GetMGHubData().usedtime == 0 then
		var0_35 = 1
	elseif arg0_35:GetMGHubData().count > 0 then
		var0_35 = arg0_35:GetMGHubData().usedtime + 1
	else
		var0_35 = arg0_35:GetMGHubData().usedtime
	end

	print("return chapter is " .. var0_35)

	return var0_35
end

function var0_0.gameStart(arg0_36)
	arg0_36.readyStartFlag = false
	arg0_36.gameStartFlag = true
	arg0_36.sendSuccessFlag = false

	setActive(arg0_36.sceneContainer, true)
	setActive(arg0_36.bg, false)
	arg0_36.beachGuardUI:popCountUI(false)
	arg0_36.gameUI:firstUpdate(arg0_36.runningData)
	arg0_36.gameUI:show(true)
	arg0_36.sceneMgr:start()
	arg0_36:timerStart()
end

function var0_0.changeSpeed(arg0_37, arg1_37)
	return
end

function var0_0.onTimer(arg0_38)
	arg0_38:gameStep()
end

function var0_0.gameStep(arg0_39)
	arg0_39:stepRunTimeData()
	arg0_39.sceneMgr:step()
	arg0_39.gameUI:update(arg0_39.runningData)

	if arg0_39.runningData.gameTime <= 0 then
		arg0_39:onGameOver()
	end
end

function var0_0.timerStart(arg0_40)
	if not arg0_40.timer.running then
		arg0_40.timer:Start()
	end
end

function var0_0.timerResume(arg0_41)
	if not arg0_41.timer.running then
		arg0_41.timer:Start()
	end
end

function var0_0.timerStop(arg0_42)
	if arg0_42.timer.running then
		arg0_42.timer:Stop()
	end
end

function var0_0.stepRunTimeData(arg0_43)
	local var0_43 = Time.deltaTime

	if var0_43 > 0.016 then
		var0_43 = 0.016
	end

	arg0_43.runningData.gameTime = arg0_43.runningData.gameTime - var0_43
	arg0_43.runningData.gameStepTime = arg0_43.runningData.gameStepTime + var0_43
	arg0_43.runningData.deltaTime = var0_43
end

function var0_0.changeRecycles(arg0_44, arg1_44)
	arg0_44.runningData.recycles = arg1_44

	arg0_44.sceneMgr:changeRecycles(arg1_44)
	arg0_44:runningUpdate()
end

function var0_0.addScore(arg0_45, arg1_45)
	arg0_45.runningData.scoreNum = arg0_45.runningData.scoreNum + arg1_45
end

function var0_0.pullSceneChar(arg0_46, arg1_46)
	table.insert(arg0_46.runningData.sceneChars, arg1_46)
	arg0_46:runningUpdate()
end

function var0_0.removeSceneChar(arg0_47, arg1_47)
	for iter0_47 = #arg0_47.runningData.sceneChars, 1, -1 do
		if arg0_47.runningData.sceneChars[iter0_47] == arg1_47 then
			table.remove(arg0_47.runningData.sceneChars, iter0_47)
		end
	end
end

function var0_0.goodsUpdate(arg0_48, arg1_48)
	arg0_48.runningData.goodsNum = arg0_48.runningData.goodsNum + arg1_48

	arg0_48.gameUI:updateGoods(arg1_48)
end

function var0_0.runningUpdate(arg0_49)
	return
end

function var0_0.onGameOver(arg0_50)
	if arg0_50.settlementFlag then
		return
	end

	arg0_50:timerStop()
	arg0_50:clearGame()

	arg0_50.settlementFlag = true

	setActive(arg0_50.clickMask, true)
	LeanTween.delayedCall(go(arg0_50._tf), 0.1, System.Action(function()
		arg0_50.settlementFlag = false
		arg0_50.gameStartFlag = false

		setActive(arg0_50.clickMask, false)
		arg0_50.beachGuardUI:updateSettlementUI(arg0_50:GetMGData(), arg0_50:GetMGHubData(), arg0_50.runningData)
		arg0_50.beachGuardUI:openSettlementUI(true)
	end))
end

function var0_0.OnApplicationPaused(arg0_52)
	if not arg0_52.gameStartFlag then
		return
	end

	if arg0_52.readyStartFlag then
		return
	end

	if arg0_52.settlementFlag then
		return
	end

	arg0_52:pauseGame()
	arg0_52.beachGuardUI:popPauseUI()
end

function var0_0.clearGame(arg0_53)
	arg0_53.sceneMgr:clear()
end

function var0_0.pauseGame(arg0_54)
	arg0_54.gameStop = true

	arg0_54:changeSpeed(0)
	arg0_54:timerStop()
end

function var0_0.resumeGame(arg0_55)
	arg0_55.gameStop = false

	arg0_55:changeSpeed(1)
	arg0_55:timerStart()
end

function var0_0.onBackPressed(arg0_56)
	if arg0_56.readyStartFlag then
		return
	end

	if not arg0_56.gameStartFlag then
		arg0_56:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_56.settlementFlag then
			return
		end

		arg0_56.beachGuardUI:backPressed()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_57, arg1_57)
	return
end

function var0_0.willExit(arg0_58)
	if arg0_58.handle then
		UpdateBeat:RemoveListener(arg0_58.handle)
	end

	if arg0_58._tf and LeanTween.isTweening(go(arg0_58._tf)) then
		LeanTween.cancel(go(arg0_58._tf))
	end

	if arg0_58.timer and arg0_58.timer.running then
		arg0_58.timer:Stop()
	end

	Time.timeScale = 1
	arg0_58.timer = nil

	arg0_58:destroyController()
	BeachGuardAsset.clear()
end

function var0_0.destroyController(arg0_59)
	return
end

return var0_0
