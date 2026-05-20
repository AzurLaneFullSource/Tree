local var0_0 = class("SortGameView", import("..BaseMiniGameView"))
local var1_0 = 84

var0_0.WANTED_ITEM_REFRESH = "SortGameView:wanted item refresh"
var0_0.UPDATE_PLAYER = "SortGameView:update player"
var0_0.PLAYER_SPEAK = "SortGameView:player speak"
var0_0.GAME_OVER_TIME = "SortGameView:game over time"

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1._gameVo = SortGameVo.New(var1_0)
end

function var0_0.getUIName(arg0_2)
	return SortGameConst.game_ui
end

function var0_0.getBGM(arg0_3)
	return SortGameConst.menu_bgm
end

function var0_0.didEnter(arg0_4)
	arg0_4:initEvent()
	arg0_4:initUI()
	arg0_4:readyStart()
end

function var0_0.initEvent(arg0_5)
	if not arg0_5.handle then
		arg0_5.handle = UpdateBeat:CreateListener(arg0_5.OnUpdate, arg0_5)

		UpdateBeat:AddListener(arg0_5.handle)
	end

	arg0_5:bind(SimpleMGEvent.LEVEL_GAME, function(arg0_6, arg1_6, arg2_6)
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
	arg0_5:bind(SimpleMGEvent.OPEN_LEVEL_UI, function(arg0_10, arg1_10, arg2_10)
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
	arg0_5:bind(SimpleMGEvent.GAME_OVER, function(arg0_14, arg1_14, arg2_14)
		arg0_5:onGameOver(arg1_14)
	end)
	arg0_5:bind(SimpleMGEvent.SHOW_RULE, function(arg0_15, arg1_15, arg2_15)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[SortGameConst.rule_tip].tip
		})
	end)
	arg0_5:bind(SimpleMGEvent.SHOW_RANK, function(arg0_16, arg1_16, arg2_16)
		arg0_5:getRankData(arg0_5._gameVo:GetGameId(), function(arg0_17)
			arg0_5.popUI:UpdateRankData(arg0_17)
		end)
		arg0_5.popUI:PopRankUI(true)
	end)
	arg0_5:bind(SimpleMGEvent.READY_START, function(arg0_18, arg1_18, arg2_18)
		arg0_5:readyStart(arg1_18)
	end)
	arg0_5:bind(SimpleMGEvent.STORE_SERVER, function(arg0_19, arg1_19, arg2_19)
		getProxy(MiniGameProxy):UpdataHighScore(arg0_5._gameVo:GetGameId(), arg1_19)
	end)
	arg0_5:bind(SimpleMGEvent.SUBMIT_GAME_SUCCESS, function(arg0_20, arg1_20, arg2_20)
		if not arg0_5.sendSuccessFlag then
			arg0_5.sendSuccessFlag = true

			arg0_5:SendSuccess(0)
		end
	end)
	arg0_5:bind(SimpleMGEvent.ADD_SCORE, function(arg0_21, arg1_21, arg2_21)
		arg0_5._gameVo:AddScore(arg1_21.num)
		arg0_5.gameUI:AddScore(arg1_21)
	end)
	arg0_5:bind(SortGameView.WANTED_ITEM_REFRESH, function(arg0_22, arg1_22, arg2_22)
		arg0_5.gameUI:RefreshWantedItem(arg1_22.item_id, arg1_22.player_prefab)
	end)
	arg0_5:bind(SortGameView.UPDATE_PLAYER, function(arg0_23, arg1_23, arg2_23)
		arg0_5.gameUI:UpdatePlayer(arg1_23)
	end)
	arg0_5:bind(SortGameView.PLAYER_SPEAK, function(arg0_24, arg1_24, arg2_24)
		arg0_5.gameUI:SetPlayerSpeak(arg1_24)
	end)
	arg0_5:bind(SortGameView.GAME_OVER_TIME, function(arg0_25, arg1_25, arg2_25)
		arg0_5.gameStop = true

		arg0_5.gameUI:StepTimeToScore()
	end)
end

function var0_0.initUI(arg0_26)
	arg0_26.clickMask = findTF(arg0_26._tf, "clickMask")
	arg0_26.popUI = SortGamePopUI.New(arg0_26._tf, arg0_26, arg0_26._gameVo)

	arg0_26.popUI:ClearUI()

	arg0_26.gameUI = SortGamingUI.New(arg0_26._tf, arg0_26, arg0_26._gameVo)

	arg0_26.gameUI:Show(false)

	arg0_26.menuUI = SortGameMenuUI.New(arg0_26._tf, arg0_26, arg0_26._gameVo)

	arg0_26.menuUI:Update()
	arg0_26.menuUI:Show(true)

	arg0_26.gameScene = SortGameScene.New(arg0_26._tf, arg0_26, arg0_26._gameVo)
end

function var0_0.changeBgm(arg0_27, arg1_27)
	local var0_27

	if not arg1_27 then
		var0_27 = arg0_27:getBGM()

		if not var0_27 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_27 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_27 = pg.voice_bgm.NewMainScene.bgm
			end
		end
	elseif arg1_27 == SortGameConst.menu_bgm then
		var0_27 = SortGameConst.menu_bgm
	elseif arg1_27 == SortGameConst.game_bgm then
		var0_27 = SortGameConst.game_bgm
	end

	if arg0_27.bgm ~= var0_27 then
		arg0_27.bgm = var0_27

		pg.BgmMgr.GetInstance():Push(arg0_27.__cname, var0_27)
	end
end

function var0_0.OnUpdate(arg0_28)
	arg0_28:gameStep()
end

function var0_0.readyStart(arg0_29, arg1_29)
	arg0_29.readyStartFlag = true

	arg0_29._gameVo:Prepare()
	arg0_29.popUI:ReadyStart()
	arg0_29.menuUI:Show(false)
	arg0_29.gameUI:Show(false)
	arg0_29.gameScene:Prepare()
end

function var0_0.gameStart(arg0_30)
	arg0_30.readyStartFlag = false
	arg0_30.gameStartFlag = true
	arg0_30.sendSuccessFlag = false

	arg0_30.popUI:PopCountUI(false)
	arg0_30.gameUI:Start()
	arg0_30.gameUI:Show(true)
	arg0_30.gameScene:Start()
	arg0_30:timerStart()
	arg0_30:changeBgm(SortGameConst.game_bgm)
end

function var0_0.gameStep(arg0_31)
	if arg0_31.gameStartFlag and not arg0_31.gameStop and not arg0_31.settlementFlag then
		arg0_31:stepRunTimeData()
		arg0_31.gameUI:Step(arg0_31._gameVo:GetDeltaTime())
		arg0_31.gameScene:Step()

		if arg0_31._gameVo:GetTime() <= 0 then
			arg0_31:onGameOver()
		end
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.timerStart(arg0_32)
	arg0_32.gameStop = false
end

function var0_0.timerResume(arg0_33)
	arg0_33.gameStop = false

	arg0_33.gameScene:Resume()
end

function var0_0.timerStop(arg0_34)
	arg0_34.gameStop = true

	arg0_34.gameScene:Stop()
end

function var0_0.getRankData(arg0_35, arg1_35, arg2_35)
	pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
		id = arg1_35,
		callback = function(arg0_36)
			local var0_36 = {}

			for iter0_36 = 1, #arg0_36 do
				local var1_36 = {}

				for iter1_36, iter2_36 in pairs(arg0_36[iter0_36]) do
					var1_36[iter1_36] = iter2_36
				end

				table.insert(var0_36, var1_36)
			end

			table.sort(var0_36, function(arg0_37, arg1_37)
				if arg0_37.score ~= arg1_37.score then
					return arg0_37.score > arg1_37.score
				elseif arg0_37.time_data ~= arg1_37.time_data then
					return arg0_37.time_data > arg1_37.time_data
				else
					return arg0_37.player_id < arg1_37.player_id
				end
			end)

			if arg2_35 then
				arg2_35(var0_36)
			end
		end
	})
end

function var0_0.stepRunTimeData(arg0_38)
	arg0_38._gameVo:Step(Time.deltaTime)
end

function var0_0.onGameOver(arg0_39, arg1_39)
	if arg0_39.settlementFlag then
		return
	end

	arg0_39:timerStop()
	arg0_39._gameVo:SetSettlement(true)

	arg0_39.settlementFlag = true
	arg0_39.gameStartFlag = false

	setActive(arg0_39.clickMask, true)
	arg0_39.gameUI:GameOver()
	LeanTween.delayedCall(go(arg0_39._tf), 0.1, System.Action(function()
		arg0_39.settlementFlag = false

		arg0_39:clearController()
		arg0_39._gameVo:SetSettlement(false)
		setActive(arg0_39.clickMask, false)
		arg0_39.popUI:UpdateSettlementUI()
		arg0_39.popUI:PopSettlementUI(true)
	end))
end

function var0_0.OnApplicationPaused(arg0_41)
	if not arg0_41.gameStartFlag then
		return
	end

	if arg0_41.readyStartFlag then
		return
	end

	if arg0_41.settlementFlag then
		return
	end

	arg0_41:pauseGame()
	arg0_41.popUI:PopPauseUI()
end

function var0_0.clearController(arg0_42)
	arg0_42.gameScene:Clear()
end

function var0_0.pauseGame(arg0_43)
	arg0_43:timerStop()
end

function var0_0.resumeGame(arg0_44)
	arg0_44:timerResume()
end

function var0_0.onBackPressed(arg0_45)
	if arg0_45.gameStartFlag and not arg0_45.settlementFlag and not arg0_45.readyStartFlag then
		arg0_45.popUI:BackPressed()
	end

	if not arg0_45.gameStartFlag and not arg0_45.settlementFlag and not arg0_45.readyStartFlag then
		arg0_45:closeView()
	end
end

function var0_0.willExit(arg0_46)
	if arg0_46.handle then
		UpdateBeat:RemoveListener(arg0_46.handle)
	end

	if arg0_46._tf and LeanTween.isTweening(go(arg0_46._tf)) then
		LeanTween.cancel(go(arg0_46._tf))
	end

	Time.timeScale = 1

	if arg0_46._gameVo then
		arg0_46._gameVo:Clear()

		arg0_46._gameVo = nil
	end
end

return var0_0
