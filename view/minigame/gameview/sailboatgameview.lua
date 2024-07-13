local var0_0 = class("SailBoatGameView", import("..BaseMiniGameView"))

var0_0.LEVEL_GAME = "leavel game"
var0_0.PAUSE_GAME = "pause game "
var0_0.OPEN_PAUSE_UI = "open pause ui"
var0_0.OPEN_LEVEL_UI = "open leave ui"
var0_0.BACK_MENU = "back menu"
var0_0.OPEN_EQUIP_UI = "open equip ui"
var0_0.CLOSE_GAME = "close game"
var0_0.SHOW_RULE = "show rule"
var0_0.READY_START = "ready start"
var0_0.COUNT_DOWN = "count down"
var0_0.STORE_SERVER = "store server"
var0_0.SUBMIT_GAME_SUCCESS = "submit game success"
var0_0.ADD_SCORE = "add score"
var0_0.GAME_OVER = "game over"
var0_0.USE_SKILL = "use skill"
var0_0.JOYSTICK_ACTIVE_CHANGE = "joy stick active change"

local var1_0 = import("view.miniGame.gameView.SailBoatGame.SailBoatGameVo")

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
		arg0_6.handle = UpdateBeat:CreateListener(arg0_6.Update, arg0_6)

		UpdateBeat:AddListener(arg0_6.handle)
	end

	arg0_6:bind(var0_0.LEVEL_GAME, function(arg0_7, arg1_7, arg2_7)
		if arg1_7 then
			arg0_6:resumeGame()
			arg0_6:onGameOver()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(var0_0.USE_SKILL, function(arg0_8, arg1_8, arg2_8)
		arg0_6.gameScene:useSkill()
	end)
	arg0_6:bind(var0_0.COUNT_DOWN, function(arg0_9, arg1_9, arg2_9)
		arg0_6:gameStart()
	end)
	arg0_6:bind(var0_0.OPEN_EQUIP_UI, function(arg0_10, arg1_10, arg2_10)
		arg0_6.equipUI:show(true)
		arg0_6.menuUI:show(false)
	end)
	arg0_6:bind(var0_0.OPEN_PAUSE_UI, function(arg0_11, arg1_11, arg2_11)
		arg0_6.popUI:popPauseUI()
	end)
	arg0_6:bind(var0_0.OPEN_LEVEL_UI, function(arg0_12, arg1_12, arg2_12)
		arg0_6.popUI:popLeaveUI()
	end)
	arg0_6:bind(var0_0.PAUSE_GAME, function(arg0_13, arg1_13, arg2_13)
		if arg1_13 then
			arg0_6:pauseGame()
		else
			arg0_6:resumeGame()
		end
	end)
	arg0_6:bind(var0_0.BACK_MENU, function(arg0_14, arg1_14, arg2_14)
		arg0_6.menuUI:update(arg0_6:GetMGHubData())
		arg0_6.menuUI:show(true)
		arg0_6.gameUI:show(false)
		arg0_6.gameScene:showContainer(false)

		local var0_14 = arg0_6:getBGM()

		if not var0_14 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_14 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_14 = pg.voice_bgm.NewMainScene.bgm
			end
		end

		if arg0_6.bgm ~= var0_14 then
			arg0_6.bgm = var0_14

			pg.BgmMgr.GetInstance():Push(arg0_6.__cname, var0_14)
		end

		arg0_6:initBgAnimation()
	end)
	arg0_6:bind(var0_0.CLOSE_GAME, function(arg0_15, arg1_15, arg2_15)
		arg0_6:closeView()
	end)
	arg0_6:bind(var0_0.GAME_OVER, function(arg0_16, arg1_16, arg2_16)
		arg0_6:onGameOver()
	end)
	arg0_6:bind(var0_0.SHOW_RULE, function(arg0_17, arg1_17, arg2_17)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var1_0.rule_tip].tip
		})
	end)
	arg0_6:bind(var0_0.READY_START, function(arg0_18, arg1_18, arg2_18)
		arg0_6:readyStart()
	end)
	arg0_6:bind(var0_0.STORE_SERVER, function(arg0_19, arg1_19, arg2_19)
		arg0_6:StoreDataToServer({
			arg1_19
		})
	end)
	arg0_6:bind(var0_0.SUBMIT_GAME_SUCCESS, function(arg0_20, arg1_20, arg2_20)
		if not arg0_6.sendSuccessFlag then
			arg0_6.sendSuccessFlag = true

			arg0_6:SendSuccess(0)
		end
	end)
	arg0_6:bind(var0_0.ADD_SCORE, function(arg0_21, arg1_21, arg2_21)
		arg0_6:addScore(arg1_21.num)
		arg0_6.gameUI:addScore(arg1_21)
	end)
	arg0_6:bind(var0_0.JOYSTICK_ACTIVE_CHANGE, function(arg0_22, arg1_22, arg2_22)
		if arg0_6.gameStartFlag then
			arg0_6.gameScene:joystickActive(arg1_22)
		end
	end)
end

function var0_0.initUI(arg0_23)
	if IsUnityEditor then
		setActive(findTF(arg0_23._tf, "tpl"), false)
	end

	arg0_23.clickMask = findTF(arg0_23._tf, "clickMask")
	arg0_23.popUI = SailBoatGamePopUI.New(arg0_23._tf, arg0_23)

	arg0_23.popUI:clearUI()

	arg0_23.gameUI = SailBoatGamingUI.New(arg0_23._tf, arg0_23)

	arg0_23.gameUI:show(false)

	arg0_23.menuUI = SailBoatGameMenuUI.New(arg0_23._tf, arg0_23)

	arg0_23.menuUI:update(arg0_23:GetMGHubData())
	arg0_23.menuUI:show(true)

	arg0_23.equipUI = SailBoatEquipUI.New(arg0_23._tf, arg0_23)

	arg0_23.equipUI:show(false)

	arg0_23.gameScene = SailBoatGameScene.New(arg0_23._tf, arg0_23)

	arg0_23:initBgAnimation()
end

function var0_0.initBgAnimation(arg0_24)
	local var0_24 = getProxy(ActivityProxy):getActivityById(ActivityConst.BOAT_QIAN_SHAO_ZHAN)
	local var1_24 = getProxy(TaskProxy)
	local var2_24 = {
		"Phase_00",
		"Phase_01",
		"Phase_02",
		"Phase_03",
		"Phase_04",
		"Phase_05",
		"Phase_06",
		"Phase_07"
	}
	local var3_24 = var0_24:getConfig("config_data")
	local var4_24 = var0_24.data3

	if var1_24:getFinishTaskById(var3_24[var4_24][1]) ~= nil and var1_24:getFinishTaskById(var3_24[var4_24][2]) ~= nil then
		var4_24 = var4_24 + 1
	end

	GetComponent(findTF(arg0_24._tf, "sceneBg/1"), typeof(Animator)):Play(var2_24[var4_24])
end

function var0_0.Update(arg0_25)
	if arg0_25.gameStop or arg0_25.settlementFlag then
		return
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.S) then
			arg0_25.gameUI:press(KeyCode.S, true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0_25.gameUI:press(KeyCode.S, false)
		end

		if Input.GetKeyDown(KeyCode.W) then
			arg0_25.gameUI:press(KeyCode.W, true)
		end

		if Input.GetKeyUp(KeyCode.W) then
			arg0_25.gameUI:press(KeyCode.W, false)
		end

		if Input.GetKeyDown(KeyCode.A) then
			arg0_25.gameUI:press(KeyCode.A, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_25.gameUI:press(KeyCode.A, false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_25.gameUI:press(KeyCode.D, true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_25.gameUI:press(KeyCode.D, false)
		end

		if Input.GetKeyDown(KeyCode.J) then
			arg0_25.gameScene:press(KeyCode.J, true)
		end
	end
end

function var0_0.readyStart(arg0_26)
	arg0_26.readyStartFlag = true

	var1_0.Prepare()
	arg0_26.popUI:readyStart()
	arg0_26.menuUI:show(false)
	arg0_26.gameUI:show(false)
	arg0_26.equipUI:show(false)
	setActive(findTF(arg0_26._tf, "sceneBg"), false)
end

function var0_0.gameStart(arg0_27)
	arg0_27.readyStartFlag = false
	arg0_27.gameStartFlag = true
	arg0_27.sendSuccessFlag = false

	arg0_27.popUI:popCountUI(false)
	arg0_27.gameUI:start()
	arg0_27.gameUI:show(true)

	if arg0_27.bgm ~= var1_0.game_bgm then
		arg0_27.bgm = var1_0.game_bgm

		pg.BgmMgr.GetInstance():Push(arg0_27.__cname, var1_0.game_bgm)
	end

	arg0_27.gameScene:start()
	arg0_27:timerStart()
end

function var0_0.changeSpeed(arg0_28, arg1_28)
	return
end

function var0_0.onTimer(arg0_29)
	arg0_29:gameStep()
end

function var0_0.gameStep(arg0_30)
	arg0_30:stepRunTimeData()
	arg0_30.gameScene:step(var1_0.deltaTime)
	arg0_30.gameUI:step(var1_0.deltaTime)

	if var1_0.gameTime <= 0 then
		arg0_30:onGameOver()
	end
end

function var0_0.timerStart(arg0_31)
	if not arg0_31.timer.running then
		arg0_31.timer:Start()
	end
end

function var0_0.timerResume(arg0_32)
	if not arg0_32.timer.running then
		arg0_32.timer:Start()
	end

	arg0_32.gameScene:resume()
end

function var0_0.timerStop(arg0_33)
	if arg0_33.timer.running then
		arg0_33.timer:Stop()
	end

	arg0_33.gameScene:stop()
end

function var0_0.stepRunTimeData(arg0_34)
	local var0_34 = Time.deltaTime

	if var0_34 > 0.016 then
		var0_34 = 0.016
	end

	var1_0.gameTime = var1_0.gameTime - var0_34
	var1_0.gameStepTime = var1_0.gameStepTime + var0_34
	var1_0.deltaTime = var0_34

	local var1_34 = var1_0.GetSceneSpeed()

	var1_34.x = var1_0.moveAmount.x * var0_34
	var1_34.y = var1_0.moveAmount.y * var0_34

	var1_0.SetSceneSpeed(var1_34)
end

function var0_0.addScore(arg0_35, arg1_35)
	var1_0.scoreNum = var1_0.scoreNum + arg1_35
end

function var0_0.onGameOver(arg0_36)
	if arg0_36.settlementFlag then
		return
	end

	arg0_36:timerStop()
	arg0_36:clearController()

	arg0_36.settlementFlag = true

	setActive(arg0_36.clickMask, true)
	LeanTween.delayedCall(go(arg0_36._tf), 0.1, System.Action(function()
		arg0_36.settlementFlag = false
		arg0_36.gameStartFlag = false

		setActive(arg0_36.clickMask, false)
		arg0_36.popUI:updateSettlementUI()
		arg0_36.popUI:popSettlementUI(true)
	end))
	setActive(findTF(arg0_36._tf, "sceneBg"), true)
end

function var0_0.OnApplicationPaused(arg0_38)
	if not arg0_38.gameStartFlag then
		return
	end

	if arg0_38.readyStartFlag then
		return
	end

	if arg0_38.settlementFlag then
		return
	end

	arg0_38:pauseGame()
	arg0_38.popUI:popPauseUI()
end

function var0_0.clearController(arg0_39)
	arg0_39.gameScene:clear()
end

function var0_0.pauseGame(arg0_40)
	arg0_40.gameStop = true

	arg0_40:changeSpeed(0)
	arg0_40:timerStop()
end

function var0_0.resumeGame(arg0_41)
	arg0_41.gameStop = false

	arg0_41:changeSpeed(1)
	arg0_41:timerStart()
end

function var0_0.onBackPressed(arg0_42)
	if arg0_42.readyStartFlag then
		return
	end

	if not arg0_42.gameStartFlag then
		arg0_42:emit(var0_0.ON_BACK_PRESSED)

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
		UpdateBeat:RemoveListener(arg0_44.handle)
	end

	if arg0_44._tf and LeanTween.isTweening(go(arg0_44._tf)) then
		LeanTween.cancel(go(arg0_44._tf))
	end

	if arg0_44.timer and arg0_44.timer.running then
		arg0_44.timer:Stop()
	end

	Time.timeScale = 1
	arg0_44.timer = nil

	var1_0.Clear()
end

return var0_0
