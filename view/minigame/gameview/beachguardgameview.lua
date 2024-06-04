local var0 = class("BeachGuardGameView", import("..BaseMiniGameView"))

var0.LEVEL_GAME = "leavel game"
var0.PAUSE_GAME = "pause game "
var0.OPEN_PAUSE_UI = "open pause ui"
var0.OPEN_LEVEL_UI = "open leave ui"
var0.BACK_MENU = "back menu"
var0.CLOSE_GAME = "close game"
var0.SHOW_RULE = "show rule"
var0.READY_START = "ready start"
var0.COUNT_DOWN = "count down"
var0.STORE_SERVER = "store server"
var0.SUBMIT_GAME_SUCCESS = "submit game success"
var0.RECYCLES_CHAR = "RECYCLES CHAR"
var0.RECYCLES_CHAR_CANCEL = "RECYCLES CHAR CANCEL"
var0.DRAG_CHAR = "DRAG CHAR"
var0.PULL_CHAR = "PULL CHAR"
var0.USE_SKILL = "USE SKILL"
var0.ADD_CRAFT = "ADD CRAFT"
var0.ADD_ENEMY = "ADD ENEMY"
var0.CREATE_CHAR_DAMAGE = "create char damage"
var0.REMOVE_CHAR = "REMOVE CHAR"
var0.BULLET_DAMAGE = "BULLET DAMAGE"
var0.GAME_OVER = "GAME OVER"
var0.ENEMY_COMMING = "enemy comming"

local var1 = 1920
local var2 = 1080
local var3 = "bar-soft"
local var4 = 6000
local var5 = "pvzminigame_help"
local var6 = Application.targetFrameRate or 60

function var0.getUIName(arg0)
	return "BeachGuardGameUI"
end

function var0.didEnter(arg0)
	arg0:initData()
	arg0:initEvent()
	arg0:initUI()
	arg0:initController()
	arg0.beachGuardUI:clearUI()
	setActive(arg0.bg, true)
	arg0.menuUI:show(true)
	arg0.menuUI:update(arg0:GetMGHubData())
	arg0:PlayGuider("NG0035")
end

function var0.PlayGuider(arg0, arg1)
	if not pg.NewStoryMgr.GetInstance():IsPlayed(arg1) then
		pg.NewGuideMgr.GetInstance():Play(arg1)
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1
		})
	end
end

function var0.initData(arg0)
	if var6 > 60 then
		var6 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var6, -1)
	arg0.gameData = {
		path = "ui/minigameui/beachguardgameui_atlas",
		game_time = var4,
		drop = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop,
		total_times = arg0:GetMGHubData():getConfig("reward_need"),
		rule_tip = var5,
		asset = BeachGuardAsset.New(arg0._tf)
	}
end

function var0.initEvent(arg0)
	if not arg0.handle and IsUnityEditor then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)

		UpdateBeat:AddListener(arg0.handle)
	end

	arg0:bind(BeachGuardGameView.LEVEL_GAME, function(arg0, arg1, arg2)
		if arg1 then
			arg0:resumeGame()
			arg0:onGameOver()
		else
			arg0:resumeGame()
		end
	end)
	arg0:bind(BeachGuardGameView.COUNT_DOWN, function(arg0, arg1, arg2)
		arg0:gameStart()
	end)
	arg0:bind(BeachGuardGameView.OPEN_PAUSE_UI, function(arg0, arg1, arg2)
		arg0.beachGuardUI:popPauseUI()
	end)
	arg0:bind(BeachGuardGameView.OPEN_LEVEL_UI, function(arg0, arg1, arg2)
		arg0.beachGuardUI:popLeaveUI()
	end)
	arg0:bind(BeachGuardGameView.PAUSE_GAME, function(arg0, arg1, arg2)
		if arg1 then
			arg0:pauseGame()
		else
			arg0:resumeGame()
		end
	end)
	arg0:bind(BeachGuardGameView.BACK_MENU, function(arg0, arg1, arg2)
		setActive(arg0.sceneContainer, false)
		arg0.menuUI:update(arg0:GetMGHubData())
		arg0.menuUI:show(true)
		arg0.gameUI:show(false)
	end)
	arg0:bind(BeachGuardGameView.CLOSE_GAME, function(arg0, arg1, arg2)
		arg0:closeView()
	end)
	arg0:bind(BeachGuardGameView.ENEMY_COMMING, function(arg0, arg1, arg2)
		arg0.gameUI:setEnemyComming()
	end)
	arg0:bind(BeachGuardGameView.GAME_OVER, function(arg0, arg1, arg2)
		arg0:onGameOver()
	end)
	arg0:bind(BeachGuardGameView.SHOW_RULE, function(arg0, arg1, arg2)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0.gameData.rule_tip].tip
		})
	end)
	arg0:bind(BeachGuardGameView.READY_START, function(arg0, arg1, arg2)
		arg0:readyStart()
	end)
	arg0:bind(BeachGuardGameView.STORE_SERVER, function(arg0, arg1, arg2)
		arg0:StoreDataToServer({
			arg1
		})
	end)
	arg0:bind(BeachGuardGameView.SUBMIT_GAME_SUCCESS, function(arg0, arg1, arg2)
		if not arg0.sendSuccessFlag then
			arg0.sendSuccessFlag = true

			arg0:SendSuccess(0)
		end
	end)
	arg0:bind(BeachGuardGameView.RECYCLES_CHAR, function(arg0, arg1, arg2)
		arg0:changeRecycles(arg1)
	end)
	arg0:bind(BeachGuardGameView.RECYCLES_CHAR_CANCEL, function(arg0, arg1, arg2)
		arg0.gameUI:cancelRecycle()
		arg0:changeRecycles(false)
	end)
	arg0:bind(BeachGuardGameView.DRAG_CHAR, function(arg0, arg1, arg2)
		arg0.sceneMgr:setDrag(arg1)
	end)
	arg0:bind(BeachGuardGameView.PULL_CHAR, function(arg0, arg1, arg2)
		local var0 = arg1.card_id
		local var1 = arg1.line_index
		local var2 = arg1.grid_index
		local var3 = BeachGuardConst.char_card[var0]
		local var4 = var3.char_id
		local var5 = var3.cost
		local var6 = var3.once
		local var7 = arg0.runningData.goodsNum
		local var8 = arg0.runningData.sceneChars

		if var7 < var5 then
			return
		end

		if var6 and table.contains(var8, var4) then
			return
		end

		if arg0.sceneMgr:pullChar(var4, var1, var2) then
			arg0:goodsUpdate(-1 * math.abs(var5))
			arg0:pullSceneChar(var4)
		end
	end)
	arg0:bind(BeachGuardGameView.USE_SKILL, function(arg0, arg1, arg2)
		arg0.sceneMgr:useSkill(arg1)
	end)
	arg0:bind(BeachGuardGameView.ADD_CRAFT, function(arg0, arg1, arg2)
		arg0:goodsUpdate(arg1.num)
	end)
	arg0:bind(BeachGuardGameView.ADD_ENEMY, function(arg0, arg1, arg2)
		arg0.sceneMgr:addEnemy(arg1)
	end)
	arg0:bind(BeachGuardGameView.CREATE_CHAR_DAMAGE, function(arg0, arg1, arg2)
		arg0.sceneMgr:craeteCharDamage(arg1)
	end)
	arg0:bind(BeachGuardGameView.REMOVE_CHAR, function(arg0, arg1, arg2)
		arg0:removeSceneChar(arg1:getId())
		arg0.sceneMgr:removeChar(arg1)

		if arg1 and arg1:getCamp() == 2 then
			arg0:addScore(arg1:getScore())
		end
	end)
	arg0:bind(BeachGuardGameView.BULLET_DAMAGE, function(arg0, arg1, arg2)
		arg0.sceneMgr:bulletDamage(arg1)
	end)
end

function var0.onEventHandle(arg0, arg1)
	return
end

function var0.initUI(arg0)
	arg0.sceneMask = findTF(arg0._tf, "sceneMask")
	arg0.sceneContainer = findTF(arg0._tf, "sceneMask/sceneContainer")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.bg = findTF(arg0._tf, "bg")
	arg0.beachGuardUI = BeachGuardUI.New(arg0._tf, arg0.gameData, arg0)
	arg0.gameUI = BeachGuardGameUI.New(arg0._tf, arg0.gameData, arg0)
	arg0.menuUI = BeachGuardMenuUI.New(arg0._tf, arg0.gameData, arg0)
end

function var0.initController(arg0)
	arg0.sceneMgr = BeachGuardSceneMgr.New(arg0.sceneMask, arg0.gameData, arg0)
end

function var0.Update(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) then
		-- block empty
	end
end

function var0.readyStart(arg0)
	arg0.readyStartFlag = true

	arg0.beachGuardUI:readyStart()
	arg0.menuUI:show(false)
	arg0.gameUI:show(false)

	local var0 = arg0:getChapter()
	local var1 = BeachGuardConst.chapater_enemy[var0].init_goods
	local var2 = BeachGuardConst.chapter_data[var0]

	if var2.fog then
		BeachGuardConst.enemy_bullet_width = BeachGuardConst.enemy_bullet_fog
	else
		BeachGuardConst.enemy_bullet_width = BeachGuardConst.enemy_bullet_defaut
	end

	arg0.runningData = {
		scoreNum = 0,
		stepTime = 0,
		gameStepTime = 0,
		gameTime = arg0.gameData.game_time,
		chapter = var0,
		goodsNum = var1 or 0,
		sceneChars = {},
		fog = var2.fog
	}

	arg0.sceneMgr:setData(arg0.runningData)
end

function var0.getChapter(arg0)
	local var0

	if not arg0:GetMGHubData().usedtime or arg0:GetMGHubData().usedtime == 0 then
		var0 = 1
	elseif arg0:GetMGHubData().count > 0 then
		var0 = arg0:GetMGHubData().usedtime + 1
	else
		var0 = arg0:GetMGHubData().usedtime
	end

	print("return chapter is " .. var0)

	return var0
end

function var0.gameStart(arg0)
	arg0.readyStartFlag = false
	arg0.gameStartFlag = true
	arg0.sendSuccessFlag = false

	setActive(arg0.sceneContainer, true)
	setActive(arg0.bg, false)
	arg0.beachGuardUI:popCountUI(false)
	arg0.gameUI:firstUpdate(arg0.runningData)
	arg0.gameUI:show(true)
	arg0.sceneMgr:start()
	arg0:timerStart()
end

function var0.changeSpeed(arg0, arg1)
	return
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0:stepRunTimeData()
	arg0.sceneMgr:step()
	arg0.gameUI:update(arg0.runningData)

	if arg0.runningData.gameTime <= 0 then
		arg0:onGameOver()
	end
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
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.stepRunTimeData(arg0)
	local var0 = Time.deltaTime

	if var0 > 0.016 then
		var0 = 0.016
	end

	arg0.runningData.gameTime = arg0.runningData.gameTime - var0
	arg0.runningData.gameStepTime = arg0.runningData.gameStepTime + var0
	arg0.runningData.deltaTime = var0
end

function var0.changeRecycles(arg0, arg1)
	arg0.runningData.recycles = arg1

	arg0.sceneMgr:changeRecycles(arg1)
	arg0:runningUpdate()
end

function var0.addScore(arg0, arg1)
	arg0.runningData.scoreNum = arg0.runningData.scoreNum + arg1
end

function var0.pullSceneChar(arg0, arg1)
	table.insert(arg0.runningData.sceneChars, arg1)
	arg0:runningUpdate()
end

function var0.removeSceneChar(arg0, arg1)
	for iter0 = #arg0.runningData.sceneChars, 1, -1 do
		if arg0.runningData.sceneChars[iter0] == arg1 then
			table.remove(arg0.runningData.sceneChars, iter0)
		end
	end
end

function var0.goodsUpdate(arg0, arg1)
	arg0.runningData.goodsNum = arg0.runningData.goodsNum + arg1

	arg0.gameUI:updateGoods(arg1)
end

function var0.runningUpdate(arg0)
	return
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()
	arg0:clearGame()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), 0.1, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0.beachGuardUI:updateSettlementUI(arg0:GetMGData(), arg0:GetMGHubData(), arg0.runningData)
		arg0.beachGuardUI:openSettlementUI(true)
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
	arg0.beachGuardUI:popPauseUI()
end

function var0.clearGame(arg0)
	arg0.sceneMgr:clear()
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
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		arg0.beachGuardUI:backPressed()
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

	arg0:destroyController()
	BeachGuardAsset.clear()
end

function var0.destroyController(arg0)
	return
end

return var0
