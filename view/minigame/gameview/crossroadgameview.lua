local var0_0 = class("CrossRoadGameView", import("..BaseMiniGameView"))
local var1_0 = 89

var0_0.LEAVEL_GAME = "leavel game"
var0_0.OPEN_LEAVEL_UI = "open leave ui"
var0_0.SUB_LIFE = "sub life"
var0_0.ADD_LIFE = "add life"
var0_0.AGAIN = "reGameAgain"

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1._gameVo = CrossRoadGameVo.New(var1_0)
end

function var0_0.getUIName(arg0_2)
	return CrossRoadGameConst.game_ui
end

function var0_0.getBGM(arg0_3)
	return CrossRoadGameConst.menu_bgm
end

function var0_0.didEnter(arg0_4)
	arg0_4:initEvent()
	arg0_4:initUI()
end

function var0_0.initEvent(arg0_5)
	if not arg0_5.handle then
		arg0_5.handle = UpdateBeat:CreateListener(arg0_5.OnUpdate, arg0_5)

		UpdateBeat:AddListener(arg0_5.handle)
	end

	arg0_5:bind(CrossRoadGameView.LEAVEL_GAME, function(arg0_6, arg1_6, arg2_6)
		if arg1_6 then
			arg0_5:resumeGame()
			arg0_5:onGameOver(false)
		else
			arg0_5:resumeGame()
		end
	end)
	arg0_5:bind(SimpleMGEvent.COUNT_DOWN, function(arg0_7, arg1_7, arg2_7)
		arg0_5:gameStart()
	end)
	arg0_5:bind(SimpleMGEvent.ON_HOME, function(arg0_8, arg1_8, arg2_8)
		arg0_5:emit(BaseUI.ON_HOME)
	end)
	arg0_5:bind(SimpleMGEvent.OPEN_PAUSE_UI, function(arg0_9, arg1_9, arg2_9)
		arg0_5.popUI:PopPauseUI()
	end)
	arg0_5:bind(CrossRoadGameView.OPEN_LEAVEL_UI, function(arg0_10, arg1_10, arg2_10)
		arg0_5.popUI:PopLeaveUI()
	end)
	arg0_5:bind(SimpleMGEvent.PAUSE_GAME, function(arg0_11, arg1_11, arg2_11)
		if arg1_11 then
			arg0_5:pauseGame()
		else
			arg0_5:resumeGame()
		end
	end)
	arg0_5:bind(SimpleMGEvent.BACK_MENU, function(arg0_12, arg1_12, arg2_12)
		arg0_5.gameScene:ShowContainer(false)
		arg0_5:changeBgm(SortGameConst.menu_bgm)
		arg0_5:closeView()
	end)
	arg0_5:bind(SimpleMGEvent.CLOSE_GAME, function(arg0_13, arg1_13, arg2_13)
		arg0_5:closeView()
	end)
	arg0_5:bind(SimpleMGEvent.SHOW_RULE, function(arg0_14, arg1_14, arg2_14)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.crossroad_minigame_help.tip
		})
	end)
	arg0_5:bind(SimpleMGEvent.READY_START, function(arg0_15, arg1_15, arg2_15)
		arg0_5:readyStart()
	end)
	arg0_5:bind(SimpleMGEvent.ADD_SCORE, function(arg0_16, arg1_16, arg2_16)
		arg0_5:addScore(arg1_16.score)
	end)
	arg0_5:bind(CrossRoadGameView.SUB_LIFE, function(arg0_17, arg1_17, arg2_17)
		arg0_5:changeLife(-1)
	end)
	arg0_5:bind(CrossRoadGameView.ADD_LIFE, function(arg0_18, arg1_18, arg2_18)
		arg0_5:changeLife(CrossRoadGameConst.HONGCHA_GET_LIFE)
	end)
	arg0_5:bind(CrossRoadGameView.AGAIN, function(arg0_19, arg1_19, arg2_19)
		arg0_5:readyStart()
	end)
	arg0_5:bind(SimpleMGEvent.SUBMIT_GAME_SUCCESS, function(arg0_20, arg1_20, arg2_20)
		if not arg0_5.sendSuccessFlag then
			arg0_5.sendSuccessFlag = true

			arg0_5:SendSuccess(0)
			getProxy(MiniGameProxy):UpdataHighScore(var1_0, {
				arg1_20.num,
				arg1_20.cnt
			})
		end
	end)
end

function var0_0.initUI(arg0_21)
	setActive(findTF(arg0_21._tf, "tpl"), false)

	arg0_21.clickMask = findTF(arg0_21._tf, "clickMask")
	arg0_21.menuUIbg1 = findTF(arg0_21._tf, "ui/bg")
	arg0_21.menuUIbg2 = findTF(arg0_21._tf, "ui/bg_1")
	arg0_21.popUI = CrossRoadPopUI.New(arg0_21._tf, arg0_21, arg0_21._gameVo)

	arg0_21.popUI:ClearUI()

	arg0_21.gameUI = CrossRoadGamingUI.New(arg0_21._tf, arg0_21, arg0_21._gameVo)

	arg0_21.gameUI:Show(false)

	arg0_21.menuUI = CrossRoadMenuUI.New(arg0_21._tf, arg0_21, arg0_21._gameVo)

	arg0_21.menuUI:Update()
	arg0_21.menuUI:Show(true)
	setActive(arg0_21.menuUIbg1, true)
	setActive(arg0_21.menuUIbg2, true)

	arg0_21.gameScene = CrossRoadScene.New(arg0_21._tf, arg0_21, arg0_21._gameVo)

	arg0_21.gameScene:ShowContainer(true)
end

function var0_0.changeBgm(arg0_22, arg1_22)
	local var0_22

	if arg1_22 == PipeGameConst.bgm_type_default then
		var0_22 = arg0_22:getBGM()

		if not var0_22 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_22 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_22 = pg.voice_bgm.NewMainScene.bgm
			end
		end
	elseif arg1_22 == PipeGameConst.bgm_type_menu then
		var0_22 = CrossRoadGameConst.menu_bgm
	elseif arg1_22 == PipeGameConst.bgm_type_game then
		var0_22 = CrossRoadGameConst.game_bgm
	end

	if arg0_22.bgm ~= var0_22 then
		arg0_22.bgm = var0_22

		pg.BgmMgr.GetInstance():Push(arg0_22.__cname, var0_22)
	end
end

function var0_0.OnUpdate(arg0_23)
	arg0_23:gameStep()
end

function var0_0.readyStart(arg0_24)
	arg0_24.readyStartFlag = true

	arg0_24._gameVo:Prepare()
	arg0_24.popUI:ReadyStart()
	arg0_24.menuUI:Show(false)
	arg0_24.gameUI:Show(false)
	setActive(arg0_24.menuUIbg1, false)
	setActive(arg0_24.menuUIbg2, false)
	arg0_24.gameScene:Prepare()
end

function var0_0.gameStart(arg0_25)
	arg0_25.readyStartFlag = false
	arg0_25.gameStartFlag = true
	arg0_25.sendSuccessFlag = false

	arg0_25.popUI:PopCountUI(false)
	arg0_25.gameUI:Start()
	arg0_25.gameUI:Show(true)
	arg0_25.gameScene:Start()
	arg0_25:timerStart()
	arg0_25:changeBgm(PipeGameConst.bgm_type_game)
end

function var0_0.gameStep(arg0_26)
	if arg0_26.gameStartFlag and not arg0_26.gameStop and not arg0_26.settlementFlag then
		arg0_26:stepRunTimeData()
		arg0_26.gameUI:Step()
		arg0_26.gameScene:Step()

		if arg0_26._gameVo:GetTime() <= 0 then
			arg0_26:onGameOver()
		end
	end
end

function var0_0.timerStart(arg0_27)
	arg0_27.gamestop = false
end

function var0_0.timerStop(arg0_28)
	arg0_28.gamestop = true

	arg0_28.gameScene:Stop()
end

function var0_0.stepRunTimeData(arg0_29)
	arg0_29._gameVo:Step(Time.deltaTime)
end

function var0_0.addScore(arg0_30, arg1_30)
	arg0_30._gameVo:AddScore(arg1_30)
end

function var0_0.changeLife(arg0_31, arg1_31)
	if arg0_31._gameVo:GetLife() + arg1_31 <= 0 then
		arg0_31:onGameOver()

		return
	end

	arg0_31._gameVo:changeLife(arg1_31)
end

function var0_0.onGameOver(arg0_32, arg1_32)
	if arg0_32.settlementFlag then
		return
	end

	arg0_32:timerStop()
	arg0_32._gameVo:SetSettlement(true)

	arg0_32.settlementFlag = true
	arg0_32.gameStartFlag = false

	setActive(arg0_32.clickMask, true)
	LeanTween.delayedCall(go(arg0_32._tf), 0.1, System.Action(function()
		arg0_32.settlementFlag = false

		arg0_32:clearController()
		arg0_32._gameVo:SetSettlement(false)
		setActive(arg0_32.clickMask, false)
		arg0_32.popUI:UpdateSettlementUI()
		arg0_32.popUI:PopSettlementUI(true)
	end))
end

function var0_0.OnApplicationPaused(arg0_34)
	if not arg0_34.gameStartFlag then
		return
	end

	if arg0_34.readyStartFlag then
		return
	end

	if arg0_34.settlementFlag then
		return
	end

	arg0_34:pauseGame()
	arg0_34.popUI:PopPauseUI()
end

function var0_0.clearController(arg0_35)
	arg0_35.gameScene:Clear()
end

function var0_0.pauseGame(arg0_36)
	arg0_36.gameStop = true

	arg0_36:timerStop()
end

function var0_0.resumeGame(arg0_37)
	arg0_37.gameStop = false

	arg0_37:timerStart()
end

function var0_0.onBackPressed(arg0_38)
	if arg0_38.gameStartFlag and not arg0_38.settlementFlag and not arg0_38.readyStartFlag then
		arg0_38.popUI:BackPressed()
	end

	if not arg0_38.gameStartFlag and not arg0_38.settlementFlag and not arg0_38.readyStartFlag then
		arg0_38.menuUI:Show(false)
		arg0_38:closeView()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_39, arg1_39)
	return
end

function var0_0.willExit(arg0_40)
	if arg0_40.handle then
		UpdateBeat:RemoveListener(arg0_40.handle)
	end

	if arg0_40._tf and LeanTween.isTweening(go(arg0_40._tf)) then
		LeanTween.cancel(go(arg0_40._tf))
	end

	Time.timeScale = 1

	if arg0_40._gameVo then
		arg0_40._gameVo:Clear()

		arg0_40._gameVo = nil
	end
end

return var0_0
