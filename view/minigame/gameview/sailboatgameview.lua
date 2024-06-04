local var0 = class("SailBoatGameView", import("..BaseMiniGameView"))

var0.LEVEL_GAME = "leavel game"
var0.PAUSE_GAME = "pause game "
var0.OPEN_PAUSE_UI = "open pause ui"
var0.OPEN_LEVEL_UI = "open leave ui"
var0.BACK_MENU = "back menu"
var0.OPEN_EQUIP_UI = "open equip ui"
var0.CLOSE_GAME = "close game"
var0.SHOW_RULE = "show rule"
var0.READY_START = "ready start"
var0.COUNT_DOWN = "count down"
var0.STORE_SERVER = "store server"
var0.SUBMIT_GAME_SUCCESS = "submit game success"
var0.ADD_SCORE = "add score"
var0.GAME_OVER = "game over"
var0.USE_SKILL = "use skill"
var0.JOYSTICK_ACTIVE_CHANGE = "joy stick active change"

local var1 = import("view.miniGame.gameView.SailBoatGame.SailBoatGameVo")

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
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)

		UpdateBeat:AddListener(arg0.handle)
	end

	arg0:bind(var0.LEVEL_GAME, function(arg0, arg1, arg2)
		if arg1 then
			arg0:resumeGame()
			arg0:onGameOver()
		else
			arg0:resumeGame()
		end
	end)
	arg0:bind(var0.USE_SKILL, function(arg0, arg1, arg2)
		arg0.gameScene:useSkill()
	end)
	arg0:bind(var0.COUNT_DOWN, function(arg0, arg1, arg2)
		arg0:gameStart()
	end)
	arg0:bind(var0.OPEN_EQUIP_UI, function(arg0, arg1, arg2)
		arg0.equipUI:show(true)
		arg0.menuUI:show(false)
	end)
	arg0:bind(var0.OPEN_PAUSE_UI, function(arg0, arg1, arg2)
		arg0.popUI:popPauseUI()
	end)
	arg0:bind(var0.OPEN_LEVEL_UI, function(arg0, arg1, arg2)
		arg0.popUI:popLeaveUI()
	end)
	arg0:bind(var0.PAUSE_GAME, function(arg0, arg1, arg2)
		if arg1 then
			arg0:pauseGame()
		else
			arg0:resumeGame()
		end
	end)
	arg0:bind(var0.BACK_MENU, function(arg0, arg1, arg2)
		arg0.menuUI:update(arg0:GetMGHubData())
		arg0.menuUI:show(true)
		arg0.gameUI:show(false)
		arg0.gameScene:showContainer(false)

		local var0 = arg0:getBGM()

		if not var0 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0 = pg.voice_bgm.NewMainScene.bgm
			end
		end

		if arg0.bgm ~= var0 then
			arg0.bgm = var0

			pg.BgmMgr.GetInstance():Push(arg0.__cname, var0)
		end

		arg0:initBgAnimation()
	end)
	arg0:bind(var0.CLOSE_GAME, function(arg0, arg1, arg2)
		arg0:closeView()
	end)
	arg0:bind(var0.GAME_OVER, function(arg0, arg1, arg2)
		arg0:onGameOver()
	end)
	arg0:bind(var0.SHOW_RULE, function(arg0, arg1, arg2)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var1.rule_tip].tip
		})
	end)
	arg0:bind(var0.READY_START, function(arg0, arg1, arg2)
		arg0:readyStart()
	end)
	arg0:bind(var0.STORE_SERVER, function(arg0, arg1, arg2)
		arg0:StoreDataToServer({
			arg1
		})
	end)
	arg0:bind(var0.SUBMIT_GAME_SUCCESS, function(arg0, arg1, arg2)
		if not arg0.sendSuccessFlag then
			arg0.sendSuccessFlag = true

			arg0:SendSuccess(0)
		end
	end)
	arg0:bind(var0.ADD_SCORE, function(arg0, arg1, arg2)
		arg0:addScore(arg1.num)
		arg0.gameUI:addScore(arg1)
	end)
	arg0:bind(var0.JOYSTICK_ACTIVE_CHANGE, function(arg0, arg1, arg2)
		if arg0.gameStartFlag then
			arg0.gameScene:joystickActive(arg1)
		end
	end)
end

function var0.initUI(arg0)
	if IsUnityEditor then
		setActive(findTF(arg0._tf, "tpl"), false)
	end

	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.popUI = SailBoatGamePopUI.New(arg0._tf, arg0)

	arg0.popUI:clearUI()

	arg0.gameUI = SailBoatGamingUI.New(arg0._tf, arg0)

	arg0.gameUI:show(false)

	arg0.menuUI = SailBoatGameMenuUI.New(arg0._tf, arg0)

	arg0.menuUI:update(arg0:GetMGHubData())
	arg0.menuUI:show(true)

	arg0.equipUI = SailBoatEquipUI.New(arg0._tf, arg0)

	arg0.equipUI:show(false)

	arg0.gameScene = SailBoatGameScene.New(arg0._tf, arg0)

	arg0:initBgAnimation()
end

function var0.initBgAnimation(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.BOAT_QIAN_SHAO_ZHAN)
	local var1 = getProxy(TaskProxy)
	local var2 = {
		"Phase_00",
		"Phase_01",
		"Phase_02",
		"Phase_03",
		"Phase_04",
		"Phase_05",
		"Phase_06",
		"Phase_07"
	}
	local var3 = var0:getConfig("config_data")
	local var4 = var0.data3

	if var1:getFinishTaskById(var3[var4][1]) ~= nil and var1:getFinishTaskById(var3[var4][2]) ~= nil then
		var4 = var4 + 1
	end

	GetComponent(findTF(arg0._tf, "sceneBg/1"), typeof(Animator)):Play(var2[var4])
end

function var0.Update(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.S) then
			arg0.gameUI:press(KeyCode.S, true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0.gameUI:press(KeyCode.S, false)
		end

		if Input.GetKeyDown(KeyCode.W) then
			arg0.gameUI:press(KeyCode.W, true)
		end

		if Input.GetKeyUp(KeyCode.W) then
			arg0.gameUI:press(KeyCode.W, false)
		end

		if Input.GetKeyDown(KeyCode.A) then
			arg0.gameUI:press(KeyCode.A, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0.gameUI:press(KeyCode.A, false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0.gameUI:press(KeyCode.D, true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0.gameUI:press(KeyCode.D, false)
		end

		if Input.GetKeyDown(KeyCode.J) then
			arg0.gameScene:press(KeyCode.J, true)
		end
	end
end

function var0.readyStart(arg0)
	arg0.readyStartFlag = true

	var1.Prepare()
	arg0.popUI:readyStart()
	arg0.menuUI:show(false)
	arg0.gameUI:show(false)
	arg0.equipUI:show(false)
	setActive(findTF(arg0._tf, "sceneBg"), false)
end

function var0.gameStart(arg0)
	arg0.readyStartFlag = false
	arg0.gameStartFlag = true
	arg0.sendSuccessFlag = false

	arg0.popUI:popCountUI(false)
	arg0.gameUI:start()
	arg0.gameUI:show(true)

	if arg0.bgm ~= var1.game_bgm then
		arg0.bgm = var1.game_bgm

		pg.BgmMgr.GetInstance():Push(arg0.__cname, var1.game_bgm)
	end

	arg0.gameScene:start()
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
	arg0.gameScene:step(var1.deltaTime)
	arg0.gameUI:step(var1.deltaTime)

	if var1.gameTime <= 0 then
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

	if var0 > 0.016 then
		var0 = 0.016
	end

	var1.gameTime = var1.gameTime - var0
	var1.gameStepTime = var1.gameStepTime + var0
	var1.deltaTime = var0

	local var1 = var1.GetSceneSpeed()

	var1.x = var1.moveAmount.x * var0
	var1.y = var1.moveAmount.y * var0

	var1.SetSceneSpeed(var1)
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
	setActive(findTF(arg0._tf, "sceneBg"), true)
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
		arg0:emit(var0.ON_BACK_PRESSED)

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
