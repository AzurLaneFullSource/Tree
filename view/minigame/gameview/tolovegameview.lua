local var0_0 = class("ToLoveGameView", import("..BaseMiniGameView"))
local var1_0 = import("view.miniGame.gameView.ToLoveGame.ToLoveGameVo")

function var0_0.getUIName(arg0_1)
	return "ToLoveGameUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:initEvent()
	arg0_2:changeBgm(ToLoveGameConst.bgm_type_menu)
end

function var0_0.initData(arg0_3)
	var1_0.Init(arg0_3:GetMGData().id, arg0_3:GetMGHubData().id)

	local var0_3 = var1_0.frameRate

	if var0_3 > 60 then
		var0_3 = 60
	end

	arg0_3.timer = Timer.New(function()
		arg0_3:onTimer()
	end, 1 / var0_3, -1)

	arg0_3:GetTaskData()
end

function var0_0.initUI(arg0_5)
	arg0_5:initMenuUI()
	arg0_5:initGamingUI()
	arg0_5:initPopUI()

	arg0_5.clickMask = arg0_5:findTF("clickMask")
end

function var0_0.initMenuUI(arg0_6)
	arg0_6.menuUI = arg0_6:findTF("ui/menuUI")
	arg0_6.menuBack = arg0_6:findTF("btnBack", arg0_6.menuUI)
	arg0_6.menuHome = arg0_6:findTF("btnHome", arg0_6.menuUI)
	arg0_6.menuHighestScoreText = arg0_6:findTF("highestScore/Text", arg0_6.menuUI)
	arg0_6.menuRule = arg0_6:findTF("btnRule", arg0_6.menuUI)
	arg0_6.menuStart = arg0_6:findTF("btnStart", arg0_6.menuUI)
	arg0_6.menuRank = arg0_6:findTF("btnRank", arg0_6.menuUI)
	arg0_6.menuBuff = arg0_6:findTF("btnBuff", arg0_6.menuUI)
	arg0_6.menuTask = arg0_6:findTF("btnTask", arg0_6.menuUI)
	arg0_6.menuLastTimesText = arg0_6:findTF("lastTimes/desc", arg0_6.menuUI)
	arg0_6.menuAwardList = UIItemList.New(arg0_6:findTF("awardsScrollView/Viewport/Content", arg0_6.menuUI), arg0_6:findTF("awardsScrollView/Viewport/Content/award", arg0_6.menuUI))
	arg0_6.menuStartTip = arg0_6:findTF("tip", arg0_6.menuStart)
	arg0_6.menuBuffTip = arg0_6:findTF("tip", arg0_6.menuBuff)
	arg0_6.menuTaskTip = arg0_6:findTF("tip", arg0_6.menuTask)

	setText(arg0_6:findTF("awards/Text", arg0_6.menuUI), i18n("tolovegame_join_reward"))
	arg0_6:findTF("title", arg0_6.menuUI):GetComponent(typeof(Image)):SetNativeSize()
	arg0_6:findTF("desc", arg0_6.menuUI):GetComponent(typeof(Image)):SetNativeSize()
	setActive(arg0_6.menuUI, true)
	onButton(arg0_6, arg0_6.menuBack, function()
		arg0_6:closeView()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.menuHome, function()
		arg0_6:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)

	if arg0_6:GetMGHubData().highScores[var1_0.game_id] and arg0_6:GetMGHubData().highScores[var1_0.game_id][1] then
		var1_0.highestScore = arg0_6:GetMGHubData().highScores[var1_0.game_id][1]
	end

	setText(arg0_6.menuHighestScoreText, var1_0.highestScore)
	onButton(arg0_6, arg0_6.menuRule, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[ToLoveGameConst.rule_tip].tip
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.menuStart, function()
		arg0_6:readyStart()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.menuRank, function()
		setActive(arg0_6.menuUI, false)
		arg0_6:ShowRank()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.menuBuff, function()
		setActive(arg0_6.menuUI, false)
		arg0_6:ShowBuff()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.menuTask, function()
		setActive(arg0_6.menuUI, false)
		arg0_6:ShowTask()
	end, SFX_PANEL)
	setText(arg0_6.menuLastTimesText, arg0_6:GetMGHubData().count)
	arg0_6:UpdateMenuAwardList()
	setActive(arg0_6.menuStartTip, arg0_6:GetMGHubData().count > 0)
	setActive(arg0_6.menuBuffTip, arg0_6:ShouldShowBuffTip())
	setActive(arg0_6.menuTaskTip, arg0_6.canGetAward)
end

function var0_0.UpdateMenuAwardList(arg0_14)
	arg0_14.menuAwardList:make(function(arg0_15, arg1_15, arg2_15)
		local var0_15 = var1_0.drop[arg1_15 + 1]
		local var1_15 = {
			type = var0_15[1],
			id = var0_15[2],
			count = var0_15[3]
		}

		updateDrop(arg2_15, var1_15)
		onButton(arg0_14, arg2_15, function()
			arg0_14:emit(BaseUI.ON_DROP, var1_15)
		end, SFX_PANEL)

		local var2_15 = arg0_14:GetMGHubData().count
		local var3_15 = arg0_14:GetMGHubData().usedtime

		setActive(arg2_15:Find("lock"), arg1_15 + 1 > var2_15 + var3_15)
		setActive(arg2_15:Find("got"), var3_15 >= arg1_15 + 1)
	end)
	arg0_14.menuAwardList:align(#var1_0.drop)
end

function var0_0.ShouldShowBuffTip(arg0_17)
	arg0_17.unlockBuffCount = 0

	local var0_17 = var1_0.GetBuffList(arg0_17:GetMGHubData())

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if iter1_17[3] == "" then
			arg0_17.unlockBuffCount = arg0_17.unlockBuffCount + 1
		end
	end

	local var1_17 = PlayerPrefs.GetInt("toLoveGameBuffCount", 0)

	if arg0_17.unlockBuffCount ~= var1_17 then
		return true
	end

	return false
end

function var0_0.initGamingUI(arg0_18)
	arg0_18.gamingUI = arg0_18:findTF("ui/gamingUI")
	arg0_18.gamingBack = arg0_18:findTF("back", arg0_18.gamingUI)
	arg0_18.gamingPause = arg0_18:findTF("pause", arg0_18.gamingUI)
	arg0_18.gamingScoreText = arg0_18:findTF("bgScore/score", arg0_18.gamingUI)
	arg0_18.gamingTimeText = arg0_18:findTF("bgTime/time", arg0_18.gamingUI)
	arg0_18.gamingBuff = arg0_18:findTF("buff", arg0_18.gamingUI)
	arg0_18.gamingOperationArea = arg0_18:findTF("operationArea", arg0_18.gamingUI)
	arg0_18.gamingUp = arg0_18:findTF("operationArea/up", arg0_18.gamingUI)
	arg0_18.gamingDown = arg0_18:findTF("operationArea/down", arg0_18.gamingUI)
	arg0_18.gamingLeft = arg0_18:findTF("operationArea/left", arg0_18.gamingUI)
	arg0_18.gamingRight = arg0_18:findTF("operationArea/right", arg0_18.gamingUI)
	arg0_18.gamingMap = arg0_18:findTF("map", arg0_18.gamingUI)

	setActive(arg0_18.gamingUI, false)
	setActive(arg0_18.gamingOperationArea, false)
	onButton(arg0_18, arg0_18.gamingBack, function()
		if not var1_0.startSettlement then
			arg0_18:pauseGame()
			setActive(arg0_18.leaveUI, true)
			setActive(arg0_18.gamingBack, false)
			setActive(arg0_18.gamingPause, false)
			setActive(arg0_18.gamingOperationArea, false)
			setActive(arg0_18.gamingBuff, false)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.gamingPause, function()
		if not var1_0.startSettlement then
			arg0_18:pauseGame()
			setActive(arg0_18.pauseUI, true)
			setActive(arg0_18.gamingBack, false)
			setActive(arg0_18.gamingPause, false)
			setActive(arg0_18.gamingOperationArea, false)
			setActive(arg0_18.gamingBuff, false)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.gamingUp, function()
		if var1_0.canMove then
			var1_0.canMove = false

			local function var0_21(arg0_22)
				local var0_22 = arg0_18:findTF("player", arg0_22):GetComponent(typeof(Animator))
				local var1_22 = arg0_18:findTF("player", arg0_22):GetComponent(typeof(DftAniEvent))

				arg0_18:findTF("player", arg0_22):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(0, 0)

				local var2_22 = var1_0.currentPlayerPosition[1] - 1

				if var2_22 == 0 then
					var2_22 = 5
				end

				local var3_22 = ToLoveGameConst.map[var2_22][var1_0.currentPlayerPosition[2]]

				local function var4_22(arg0_23)
					arg0_18:findTF("player", arg0_23):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(0, -86)
				end

				arg0_18:OperateMap(var3_22, var4_22)
				var1_22:SetEndEvent(function()
					var1_22:SetEndEvent(nil)

					local function var0_24(arg0_25)
						setActive(arg0_18:findTF("player", arg0_25), false)
					end

					arg0_18:OperateMapPlayer(var0_24)

					var1_0.currentPlayerPosition[1] = var2_22

					local function var1_24(arg0_26)
						setActive(arg0_18:findTF("player", arg0_26), true)
						setActive(arg0_18:findTF("player/arrow", arg0_26), false)
						setActive(arg0_18:findTF("player/happy", arg0_26), false)
						setActive(arg0_18:findTF("player/sad", arg0_26), false)

						if var1_0.shieldCount > 0 then
							setActive(arg0_18:findTF("player/shield", arg0_26), true)
						else
							setActive(arg0_18:findTF("player/shield", arg0_26), false)
						end

						arg0_18:findTF("player", arg0_26):GetComponent(typeof(Animator)):Play("playerDownBack")
					end

					arg0_18:OperateMapPlayer(var1_24)
				end)
				var0_22:Play("playerUp")
			end

			arg0_18:OperateMapPlayer(var0_21)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.gamingDown, function()
		if var1_0.canMove then
			var1_0.canMove = false

			local function var0_27(arg0_28)
				local var0_28 = arg0_18:findTF("player", arg0_28):GetComponent(typeof(Animator))
				local var1_28 = arg0_18:findTF("player", arg0_28):GetComponent(typeof(DftAniEvent))

				arg0_18:findTF("player", arg0_28):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(0, 0)

				local var2_28 = var1_0.currentPlayerPosition[1] + 1

				if var2_28 == 6 then
					var2_28 = 1
				end

				local var3_28 = ToLoveGameConst.map[var2_28][var1_0.currentPlayerPosition[2]]

				local function var4_28(arg0_29)
					arg0_18:findTF("player", arg0_29):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(0, 86)
				end

				arg0_18:OperateMap(var3_28, var4_28)
				var1_28:SetEndEvent(function()
					var1_28:SetEndEvent(nil)

					local function var0_30(arg0_31)
						setActive(arg0_18:findTF("player", arg0_31), false)
					end

					arg0_18:OperateMapPlayer(var0_30)

					var1_0.currentPlayerPosition[1] = var2_28

					local function var1_30(arg0_32)
						setActive(arg0_18:findTF("player", arg0_32), true)
						setActive(arg0_18:findTF("player/arrow", arg0_32), false)
						setActive(arg0_18:findTF("player/happy", arg0_32), false)
						setActive(arg0_18:findTF("player/sad", arg0_32), false)

						if var1_0.shieldCount > 0 then
							setActive(arg0_18:findTF("player/shield", arg0_32), true)
						else
							setActive(arg0_18:findTF("player/shield", arg0_32), false)
						end

						arg0_18:findTF("player", arg0_32):GetComponent(typeof(Animator)):Play("playerUpBack")
					end

					arg0_18:OperateMapPlayer(var1_30)
				end)
				var0_28:Play("playerDown")
			end

			arg0_18:OperateMapPlayer(var0_27)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.gamingLeft, function()
		if var1_0.canMove then
			var1_0.canMove = false

			local function var0_33(arg0_34)
				local var0_34 = arg0_18:findTF("player", arg0_34):GetComponent(typeof(Animator))
				local var1_34 = arg0_18:findTF("player", arg0_34):GetComponent(typeof(DftAniEvent))

				arg0_18:findTF("player", arg0_34):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(0, 0)

				local var2_34 = var1_0.currentPlayerPosition[2] - 1

				if var2_34 == 0 then
					var2_34 = 5
				end

				local var3_34 = ToLoveGameConst.map[var1_0.currentPlayerPosition[1]][var2_34]

				local function var4_34(arg0_35)
					arg0_18:findTF("player", arg0_35):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(82.5, 0)
				end

				arg0_18:OperateMap(var3_34, var4_34)
				var1_34:SetEndEvent(function()
					var1_34:SetEndEvent(nil)

					local function var0_36(arg0_37)
						setActive(arg0_18:findTF("player", arg0_37), false)
					end

					arg0_18:OperateMapPlayer(var0_36)

					var1_0.currentPlayerPosition[2] = var2_34

					local function var1_36(arg0_38)
						setActive(arg0_18:findTF("player", arg0_38), true)
						setActive(arg0_18:findTF("player/arrow", arg0_38), false)
						setActive(arg0_18:findTF("player/happy", arg0_38), false)
						setActive(arg0_18:findTF("player/sad", arg0_38), false)

						if var1_0.shieldCount > 0 then
							setActive(arg0_18:findTF("player/shield", arg0_38), true)
						else
							setActive(arg0_18:findTF("player/shield", arg0_38), false)
						end

						arg0_18:findTF("player", arg0_38):GetComponent(typeof(Animator)):Play("playerRightBack")
					end

					arg0_18:OperateMapPlayer(var1_36)
				end)
				var0_34:Play("playerLeft")
			end

			arg0_18:OperateMapPlayer(var0_33)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.gamingRight, function()
		if var1_0.canMove then
			var1_0.canMove = false

			local function var0_39(arg0_40)
				local var0_40 = arg0_18:findTF("player", arg0_40):GetComponent(typeof(Animator))
				local var1_40 = arg0_18:findTF("player", arg0_40):GetComponent(typeof(DftAniEvent))

				arg0_18:findTF("player", arg0_40):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(0, 0)

				local var2_40 = var1_0.currentPlayerPosition[2] + 1

				if var2_40 == 6 then
					var2_40 = 1
				end

				local var3_40 = ToLoveGameConst.map[var1_0.currentPlayerPosition[1]][var2_40]

				local function var4_40(arg0_41)
					arg0_18:findTF("player", arg0_41):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(-82.5, 0)
				end

				arg0_18:OperateMap(var3_40, var4_40)
				var1_40:SetEndEvent(function()
					var1_40:SetEndEvent(nil)

					local function var0_42(arg0_43)
						setActive(arg0_18:findTF("player", arg0_43), false)
					end

					arg0_18:OperateMapPlayer(var0_42)

					var1_0.currentPlayerPosition[2] = var2_40

					local function var1_42(arg0_44)
						setActive(arg0_18:findTF("player", arg0_44), true)
						setActive(arg0_18:findTF("player/arrow", arg0_44), false)
						setActive(arg0_18:findTF("player/happy", arg0_44), false)
						setActive(arg0_18:findTF("player/sad", arg0_44), false)

						if var1_0.shieldCount > 0 then
							setActive(arg0_18:findTF("player/shield", arg0_44), true)
						else
							setActive(arg0_18:findTF("player/shield", arg0_44), false)
						end

						arg0_18:findTF("player", arg0_44):GetComponent(typeof(Animator)):Play("playerLeftBack")
					end

					arg0_18:OperateMapPlayer(var1_42)
				end)
				var0_40:Play("playerRight")
			end

			arg0_18:OperateMapPlayer(var0_39)
		end
	end, SFX_PANEL)
end

function var0_0.initPopUI(arg0_45)
	arg0_45.popUI = arg0_45:findTF("ui/popUI")

	arg0_45:initCountUI()
	arg0_45:initSettlementUI()
	arg0_45:initLeavelUI()
	arg0_45:initPauseUI()
	arg0_45:initRankUI()
	arg0_45:initBuffUI()
	arg0_45:initTaskUI()
end

function var0_0.initCountUI(arg0_46)
	arg0_46.countUI = arg0_46:findTF("countUI", arg0_46.popUI)
	arg0_46.count = arg0_46:findTF("count", arg0_46.countUI)
	arg0_46.countAnimator = arg0_46.count:GetComponent(typeof(Animator))
	arg0_46.countDft = arg0_46.count:GetComponent(typeof(DftAniEvent))

	setActive(arg0_46.countUI, false)
	arg0_46.countDft:SetEndEvent(function()
		arg0_46:gameStart()
	end)
end

function var0_0.initSettlementUI(arg0_48)
	arg0_48.settlementUI = arg0_48:findTF("settleMentUI", arg0_48.popUI)
	arg0_48.settlementCurrentText = arg0_48:findTF("ad/currentText", arg0_48.settlementUI)
	arg0_48.settlementHighText = arg0_48:findTF("ad/highText", arg0_48.settlementUI)
	arg0_48.settlementOverBtn = arg0_48:findTF("ad/btnOver", arg0_48.settlementUI)
	arg0_48.settlementNew = arg0_48:findTF("ad/new", arg0_48.settlementUI)
	arg0_48.settlementClose = arg0_48:findTF("ad/btnClose", arg0_48.settlementUI)

	arg0_48:findTF("ad/CurImg", arg0_48.settlementUI):GetComponent(typeof(Image)):SetNativeSize()
	arg0_48:findTF("ad/HighImg", arg0_48.settlementUI):GetComponent(typeof(Image)):SetNativeSize()
	setActive(arg0_48.settlementUI, false)
	onButton(arg0_48, arg0_48.settlementOverBtn, function()
		if not arg0_48.sendSuccessFlag then
			arg0_48.sendSuccessFlag = true

			arg0_48:SendSuccess(0)
		end

		setActive(arg0_48.settlementUI, false)
		setActive(arg0_48.menuUI, true)
		setActive(arg0_48.gamingUI, false)
		setText(arg0_48.menuHighestScoreText, var1_0.highestScore)
		arg0_48:GetTaskData()
		setActive(arg0_48.menuTaskTip, arg0_48.canGetAward)
		arg0_48:changeBgm(ToLoveGameConst.bgm_type_menu)
	end, SFX_PANEL)
	onButton(arg0_48, arg0_48.settlementClose, function()
		triggerButton(arg0_48.settlementOverBtn)
	end, SFX_PANEL)
end

function var0_0.initLeavelUI(arg0_51)
	arg0_51.leaveUI = arg0_51:findTF("leaveUI", arg0_51.popUI)
	arg0_51.leaveOkBtn = arg0_51:findTF("ad/btnOk", arg0_51.leaveUI)
	arg0_51.leaveCancelBtn = arg0_51:findTF("ad/btnCancel", arg0_51.leaveUI)
	arg0_51.leaveClose = arg0_51:findTF("ad/btnClose", arg0_51.leaveUI)

	arg0_51:findTF("ad/desc", arg0_51.leaveUI):GetComponent(typeof(Image)):SetNativeSize()
	arg0_51:findTF("ad/desc2", arg0_51.leaveUI):GetComponent(typeof(Image)):SetNativeSize()
	setActive(arg0_51.leaveUI, false)
	onButton(arg0_51, arg0_51.leaveOkBtn, function()
		setActive(arg0_51.leaveUI, false)
		arg0_51:resumeGame()
		arg0_51:onGameOver()
	end, SFX_PANEL)
	onButton(arg0_51, arg0_51.leaveCancelBtn, function()
		setActive(arg0_51.leaveUI, false)
		setActive(arg0_51.gamingBack, true)
		setActive(arg0_51.gamingPause, true)

		if var1_0.playerMoveFlag then
			setActive(arg0_51.gamingOperationArea, true)
		end

		setActive(arg0_51.gamingBuff, true)
		arg0_51:resumeGame()
	end, SFX_PANEL)
	onButton(arg0_51, arg0_51.leaveClose, function()
		triggerButton(arg0_51.leaveCancelBtn)
	end, SFX_PANEL)
end

function var0_0.initPauseUI(arg0_55)
	arg0_55.pauseUI = arg0_55:findTF("pauseUI", arg0_55.popUI)
	arg0_55.pauseOkBtn = arg0_55:findTF("ad/btnOk", arg0_55.pauseUI)
	arg0_55.pauseClose = arg0_55:findTF("ad/btnClose", arg0_55.pauseUI)

	arg0_55:findTF("ad/desc", arg0_55.pauseUI):GetComponent(typeof(Image)):SetNativeSize()
	setActive(arg0_55.pauseUI, false)
	onButton(arg0_55, arg0_55.pauseOkBtn, function()
		setActive(arg0_55.pauseUI, false)
		setActive(arg0_55.gamingBack, true)
		setActive(arg0_55.gamingPause, true)

		if var1_0.playerMoveFlag then
			setActive(arg0_55.gamingOperationArea, true)
		end

		setActive(arg0_55.gamingBuff, true)
		arg0_55:resumeGame()
	end, SFX_PANEL)
	onButton(arg0_55, arg0_55.pauseClose, function()
		triggerButton(arg0_55.pauseOkBtn)
	end, SFX_PANEL)
end

function var0_0.initRankUI(arg0_58)
	arg0_58.rankUI = arg0_58:findTF("rankUI", arg0_58.popUI)
	arg0_58.rankCloseBtn = arg0_58:findTF("ad/btnClose", arg0_58.rankUI)
	arg0_58.rankPlayerList = UIItemList.New(arg0_58:findTF("ad/Scroll View/Viewport/Content", arg0_58.rankUI), arg0_58:findTF("ad/Scroll View/Viewport/Content/playerTpl", arg0_58.rankUI))
	arg0_58.rankMyself = arg0_58:findTF("ad/myself", arg0_58.rankUI)
	arg0_58.rankDesc = arg0_58:findTF("ad/desc", arg0_58.rankUI)

	setText(arg0_58:findTF("ad/score", arg0_58.rankUI), i18n("tolovegame_score"))
	setText(arg0_58:findTF("ad/desc", arg0_58.rankUI), i18n("tolovegame_rank_tip"))
	arg0_58:findTF("ad/bg/titleBg/title", arg0_58.rankUI):GetComponent(typeof(Image)):SetNativeSize()
	setActive(arg0_58.rankUI, false)
	onButton(arg0_58, arg0_58.rankCloseBtn, function()
		setActive(arg0_58.rankUI, false)
		setActive(arg0_58.menuUI, true)
	end, SFX_PANEL)
end

function var0_0.initBuffUI(arg0_60)
	arg0_60.buffUI = arg0_60:findTF("buffUI", arg0_60.popUI)
	arg0_60.buffCloseBtn = arg0_60:findTF("ad/btnClose", arg0_60.buffUI)
	arg0_60.buffList = UIItemList.New(arg0_60:findTF("ad/Scroll View/Viewport/Content", arg0_60.buffUI), arg0_60:findTF("ad/Scroll View/Viewport/Content/buff", arg0_60.buffUI))

	arg0_60:findTF("ad/bg/titleBg/title", arg0_60.buffUI):GetComponent(typeof(Image)):SetNativeSize()
	setActive(arg0_60.buffUI, false)
	onButton(arg0_60, arg0_60.buffCloseBtn, function()
		setActive(arg0_60.buffUI, false)
		setActive(arg0_60.menuUI, true)
	end, SFX_PANEL)
end

function var0_0.initTaskUI(arg0_62)
	arg0_62.taskUI = arg0_62:findTF("taskUI", arg0_62.popUI)
	arg0_62.taskCloseBtn = arg0_62:findTF("ad/btnClose", arg0_62.taskUI)
	arg0_62.taskTasklist = UIItemList.New(arg0_62:findTF("ad/Scroll View/Viewport/Content", arg0_62.taskUI), arg0_62:findTF("ad/Scroll View/Viewport/Content/Tasktpl", arg0_62.taskUI))

	arg0_62:findTF("ad/bg/titleBg/title", arg0_62.taskUI):GetComponent(typeof(Image)):SetNativeSize()
	setActive(arg0_62.taskUI, false)
	onButton(arg0_62, arg0_62.taskCloseBtn, function()
		setActive(arg0_62.taskUI, false)
		setActive(arg0_62.menuUI, true)
		arg0_62:GetTaskData()
		setActive(arg0_62.menuTaskTip, arg0_62.canGetAward)
	end, SFX_PANEL)
end

function var0_0.onTimer(arg0_64)
	arg0_64:stepRunTimeData()
	arg0_64:TimeStep(var1_0.deltaTime)
	arg0_64:ShowArrowAndPlayerMove()

	if var1_0.gameTime <= 0 then
		if var1_0.buffIndex == 6 then
			if math.random() >= 0.5 then
				var1_0.gameTime = var1_0.gameTime + ToLoveGameConst.addTime
			else
				arg0_64:onGameOver()
			end
		else
			arg0_64:onGameOver()
		end
	end
end

function var0_0.stepRunTimeData(arg0_65)
	local var0_65 = Time.deltaTime

	if not var1_0.startSettlement then
		var1_0.gameTime = var1_0.gameTime - var0_65

		if var1_0.gameTime < 0 then
			var1_0.gameTime = 0
		end

		var1_0.gameStepTime = var1_0.gameStepTime + var0_65

		if (var1_0.showArrowFlag or var1_0.playerMoveFlag) and var1_0.gameStepTime >= ToLoveGameConst.motionTime then
			var1_0.gameStepTime = var1_0.gameStepTime - ToLoveGameConst.motionTime

			var1_0.ChangeMotion()
		end

		if var1_0.waitingFlag and var1_0.gameStepTime >= ToLoveGameConst.waitingTime then
			var1_0.gameStepTime = var1_0.gameStepTime - ToLoveGameConst.waitingTime

			var1_0.ChangeMotion()
		end

		var1_0.gameArrowTime = var1_0.gameArrowTime + var0_65
		var1_0.gameMoveTime = var1_0.gameMoveTime + var0_65
		var1_0.gameBombTime = var1_0.gameBombTime + var0_65

		if var1_0.bombBlast then
			var1_0.gameBombBlastTime = var1_0.gameBombBlastTime + var0_65
		end
	end

	var1_0.deltaTime = var0_65
end

function var0_0.TimeStep(arg0_66, arg1_66)
	local var0_66 = math.floor(var1_0.gameTime)
	local var1_66 = math.floor(var0_66 / 60)
	local var2_66 = var0_66 % 60

	setText(arg0_66.gamingTimeText, string.format("%02d", var1_66) .. "  :  " .. string.format("%02d", var2_66))
end

function var0_0.ShowArrowAndPlayerMove(arg0_67)
	if var1_0.showArrowFlag then
		if not var1_0.hasDone then
			var1_0.hasDone = true

			setActive(arg0_67.gamingOperationArea, false)
		end

		if var1_0.gameArrowTime >= var1_0.doTime then
			var1_0.gameArrowTime = var1_0.gameArrowTime - var1_0.doTime

			local function var0_67(arg0_68)
				setActive(arg0_67:findTF("player/arrow", arg0_68), true)
				arg0_67:ShowArraw(arg0_67:findTF("player/arrow", arg0_68), var1_0.arrowList[var1_0.nowArrowIndex])

				var1_0.nowArrowIndex = var1_0.nowArrowIndex + 1
			end

			arg0_67:OperateMapPlayer(var0_67)
		end
	elseif var1_0.playerMoveFlag then
		if not var1_0.hasDone then
			var1_0.hasDone = true

			setActive(arg0_67.gamingOperationArea, true)

			local function var1_67(arg0_69)
				setActive(arg0_67:findTF("player/arrow", arg0_69), false)
			end

			arg0_67:OperateMapPlayer(var1_67)
		end

		if var1_0.gameMoveTime >= var1_0.doTime and var1_0.moveCount > 0 then
			var1_0.moveCount = var1_0.moveCount - 1
			var1_0.gameMoveTime = var1_0.gameMoveTime - var1_0.doTime
			var1_0.canMove = true
		end
	end

	arg0_67:BombBlast()
end

function var0_0.ShowArraw(arg0_70, arg1_70, arg2_70)
	arg1_70:GetComponent(typeof(Animation)):Play("arrowUp")

	if arg2_70 == ToLoveGameConst.arrowUp then
		setActive(arg0_70:findTF("up", arg1_70), true)
		setActive(arg0_70:findTF("down", arg1_70), false)
		setActive(arg0_70:findTF("left", arg1_70), false)
		setActive(arg0_70:findTF("right", arg1_70), false)
	elseif arg2_70 == ToLoveGameConst.arrowDown then
		setActive(arg0_70:findTF("up", arg1_70), false)
		setActive(arg0_70:findTF("down", arg1_70), true)
		setActive(arg0_70:findTF("left", arg1_70), false)
		setActive(arg0_70:findTF("right", arg1_70), false)
	elseif arg2_70 == ToLoveGameConst.arrowLeft then
		setActive(arg0_70:findTF("up", arg1_70), false)
		setActive(arg0_70:findTF("down", arg1_70), false)
		setActive(arg0_70:findTF("left", arg1_70), true)
		setActive(arg0_70:findTF("right", arg1_70), false)
	elseif arg2_70 == ToLoveGameConst.arrowRight then
		setActive(arg0_70:findTF("up", arg1_70), false)
		setActive(arg0_70:findTF("down", arg1_70), false)
		setActive(arg0_70:findTF("left", arg1_70), false)
		setActive(arg0_70:findTF("right", arg1_70), true)
	end

	if var1_0.arrowVideoCount > 0 then
		var1_0.arrowVideoCount = var1_0.arrowVideoCount - 1

		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-di")
	end
end

function var0_0.BombBlast(arg0_71)
	if var1_0.nowBombIndex <= #var1_0.safeList and var1_0.gameBombTime >= var1_0.doTime then
		var1_0.gameBombTime = var1_0.gameBombTime - var1_0.doTime
		var1_0.safeCellPosition = var1_0.GetSafeCellPosition(var1_0.safeList[var1_0.nowBombIndex])
		var1_0.previousPlayerPosition = Clone(var1_0.currentPlayerPosition)
		var1_0.nowBombIndex = var1_0.nowBombIndex + 1
		arg0_71.isOk = true

		local function var0_71(arg0_72)
			setActive(arg0_71:findTF("bomb", arg0_72), true)

			if isActive(arg0_71:findTF("player", arg0_72)) then
				arg0_71.isOk = false
			end
		end

		arg0_71:OperateMapOthers(var0_71, var1_0.safeCellPosition)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-bomb")

		if arg0_71.isOk then
			arg0_71:AddScore()
			setText(arg0_71.gamingScoreText, var1_0.score)

			if var1_0.buffIndex == 4 then
				var1_0.shieldGetCombo = var1_0.shieldGetCombo + 1

				if var1_0.shieldGetCombo == 5 then
					var1_0.shieldGetCombo = 0

					if var1_0.shieldCount < 2 then
						var1_0.shieldCount = var1_0.shieldCount + 1

						local function var1_71(arg0_73)
							setActive(arg0_71:findTF("player/shield", arg0_73), true)
						end

						arg0_71:OperateMapPlayer(var1_71)
					end
				end
			end

			local function var2_71(arg0_74)
				setActive(arg0_71:findTF("player/happy", arg0_74), true)
			end

			arg0_71:OperateMapPlayer(var2_71)
		else
			if var1_0.shieldCount > 0 then
				var1_0.combo = 0
				var1_0.shieldCount = var1_0.shieldCount - 1

				local function var3_71(arg0_75)
					if var1_0.shieldCount > 0 then
						setActive(arg0_71:findTF("player/shield", arg0_75), true)
					else
						setActive(arg0_71:findTF("player/shield", arg0_75), false)
					end
				end

				arg0_71:OperateMapPlayer(var3_71)
			else
				arg0_71:onGameOver()
			end

			local function var4_71(arg0_76)
				setActive(arg0_71:findTF("player/sad", arg0_76), true)
			end

			arg0_71:OperateMapPlayer(var4_71)
		end

		var1_0.bombBlast = true
	end

	if var1_0.bombBlast and var1_0.gameBombBlastTime >= ToLoveGameConst.bombBlastTime then
		var1_0.bombBlast = false
		var1_0.gameBombBlastTime = 0

		local function var5_71(arg0_77)
			setActive(arg0_71:findTF("bomb", arg0_77), false)
		end

		arg0_71:OperateMapOthers(var5_71, var1_0.safeCellPosition)
	end
end

function var0_0.readyStart(arg0_78)
	arg0_78.readyStartFlag = true

	var1_0.Prepare()
	setActive(arg0_78.countUI, true)
	setActive(arg0_78.menuUI, false)
	setActive(arg0_78.gamingUI, false)
	arg0_78.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_COUNT_DOWN)

	local function var0_78(arg0_79)
		setActive(arg0_78:findTF("bomb", arg0_79), false)
	end

	arg0_78:OperateMapAll(var0_78)
end

function var0_0.gameStart(arg0_80)
	arg0_80.readyStartFlag = false
	arg0_80.gameStartFlag = true
	arg0_80.sendSuccessFlag = false

	setActive(arg0_80.countUI, false)
	setActive(arg0_80.gamingUI, true)
	arg0_80:ResetMapAndPlayer()
	arg0_80:timerStart()
	arg0_80:changeBgm(ToLoveGameConst.bgm_type_game)
	setText(arg0_80.gamingScoreText, var1_0.score)
	arg0_80:SetGamingBuff()
	setActive(arg0_80.gamingBack, true)
	setActive(arg0_80.gamingPause, true)
	setActive(arg0_80.gamingBuff, true)
end

function var0_0.ResetMapAndPlayer(arg0_81)
	local var0_81 = ToLoveGameConst.map[var1_0.currentPlayerPosition[1]][var1_0.currentPlayerPosition[2]]

	for iter0_81 = 0, arg0_81.gamingMap.childCount - 1 do
		local var1_81 = arg0_81.gamingMap:GetChild(iter0_81)

		setActive(arg0_81:findTF("player/happy", var1_81), false)
		setActive(arg0_81:findTF("player/sad", var1_81), false)

		arg0_81:findTF("player", var1_81):GetComponent(typeof(RectTransform)).anchoredPosition = Vector2(0, 0)

		if iter0_81 == var0_81 then
			setActive(arg0_81:findTF("player", var1_81), true)
			setActive(arg0_81:findTF("player/arrow", var1_81), false)

			if var1_0.shieldCount > 0 then
				setActive(arg0_81:findTF("player/shield", var1_81), true)
			else
				setActive(arg0_81:findTF("player/shield", var1_81), false)
			end
		else
			setActive(arg0_81:findTF("player", var1_81), false)
		end
	end
end

function var0_0.OperateMapAll(arg0_82, arg1_82)
	for iter0_82 = 0, arg0_82.gamingMap.childCount - 1 do
		local var0_82 = arg0_82.gamingMap:GetChild(iter0_82)

		arg1_82(var0_82)
	end
end

function var0_0.OperateMapPlayer(arg0_83, arg1_83)
	local var0_83 = ToLoveGameConst.map[var1_0.currentPlayerPosition[1]][var1_0.currentPlayerPosition[2]]

	for iter0_83 = 0, arg0_83.gamingMap.childCount - 1 do
		local var1_83 = arg0_83.gamingMap:GetChild(iter0_83)

		if iter0_83 == var0_83 then
			arg1_83(var1_83)

			break
		end
	end
end

function var0_0.OperateMapOthers(arg0_84, arg1_84, arg2_84)
	local var0_84 = ToLoveGameConst.map[arg2_84[1]][arg2_84[2]]

	for iter0_84 = 0, arg0_84.gamingMap.childCount - 1 do
		local var1_84 = arg0_84.gamingMap:GetChild(iter0_84)

		if iter0_84 ~= var0_84 then
			arg1_84(var1_84)
		end
	end
end

function var0_0.OperateMap(arg0_85, arg1_85, arg2_85)
	for iter0_85 = 0, arg0_85.gamingMap.childCount - 1 do
		local var0_85 = arg0_85.gamingMap:GetChild(iter0_85)

		if iter0_85 == arg1_85 then
			arg2_85(var0_85)

			break
		end
	end
end

function var0_0.SetGamingBuff(arg0_86)
	for iter0_86 = 1, 7 do
		setActive(arg0_86.gamingBuff:GetChild(iter0_86 - 1), var1_0.buffIndex == iter0_86)
	end
end

function var0_0.timerStart(arg0_87)
	if not arg0_87.timer.running then
		arg0_87.timer:Start()
	end
end

function var0_0.timerStop(arg0_88)
	if arg0_88.timer.running then
		arg0_88.timer:Stop()
	end
end

function var0_0.AddScore(arg0_89)
	var1_0.combo = var1_0.combo + 1

	local var0_89 = 100

	for iter0_89 = #ToLoveGameConst.comboNum, 1, -1 do
		if var1_0.combo >= ToLoveGameConst.comboNum[iter0_89] then
			var0_89 = var0_89 + ToLoveGameConst.comboAdd[iter0_89]

			break
		end
	end

	local var1_89 = var1_0.GetScoreMultiplyRate()
	local var2_89 = 1

	if var1_0.buffIndex == 2 or var1_0.buffIndex == 7 then
		var2_89 = 1.2
	elseif var1_0.buffIndex == 5 then
		var2_89 = 1.2 + 0.01 * math.floor(var1_0.combo / 5)
	end

	local var3_89 = math.ceil(var0_89 * var1_89 * var2_89)

	var1_0.score = var1_0.score + var3_89
end

function var0_0.onGameOver(arg0_90)
	if arg0_90.settlementFlag then
		return
	end

	arg0_90.settlementFlag = true

	arg0_90:timerStop()

	var1_0.startSettlement = true

	setActive(arg0_90.clickMask, true)
	LeanTween.delayedCall(go(arg0_90._tf), 0.2, System.Action(function()
		arg0_90.settlementFlag = false
		arg0_90.gameStartFlag = false

		setActive(arg0_90.clickMask, false)
		arg0_90:ShowSettlementUI()
	end))
	arg0_90:UpdateTaskProgress()
end

function var0_0.ShowSettlementUI(arg0_92)
	setActive(arg0_92.settlementUI, true)
	setActive(arg0_92.gamingBack, false)
	setActive(arg0_92.gamingPause, false)
	setActive(arg0_92.gamingOperationArea, false)
	setActive(arg0_92.gamingBuff, false)
	setText(arg0_92.settlementCurrentText, var1_0.score)
	setActive(arg0_92.settlementNew, false)

	if var1_0.score > var1_0.highestScore then
		var1_0.highestScore = var1_0.score

		setActive(arg0_92.settlementNew, true)
		getProxy(MiniGameProxy):UpdataHighScore(var1_0.game_id, {
			var1_0.highestScore,
			var1_0.gameTime
		})
	end

	setText(arg0_92.settlementHighText, var1_0.highestScore)
end

function var0_0.OnSendMiniGameOPDone(arg0_93, arg1_93)
	if arg1_93.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0_93 = checkExist(var1_0.story, {
			arg0_93:GetMGHubData().usedtime
		}, {
			1
		})

		if var0_93 then
			pg.NewStoryMgr.GetInstance():Play(var0_93)
		end

		setText(arg0_93.menuLastTimesText, arg0_93:GetMGHubData().count)
		setActive(arg0_93.menuStartTip, arg0_93:GetMGHubData().count > 0)
		arg0_93:UpdateMenuAwardList()
	end
end

function var0_0.ShowRank(arg0_94)
	pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
		id = var1_0.game_id,
		callback = function(arg0_95)
			local var0_95 = {}

			for iter0_95 = 1, #arg0_95 do
				local var1_95 = {}

				for iter1_95, iter2_95 in pairs(arg0_95[iter0_95]) do
					var1_95[iter1_95] = iter2_95
				end

				table.insert(var0_95, var1_95)
			end

			table.sort(var0_95, function(arg0_96, arg1_96)
				if arg0_96.score ~= arg1_96.score then
					return arg0_96.score > arg1_96.score
				elseif arg0_96.time_data ~= arg1_96.time_data then
					return arg0_96.time_data > arg1_96.time_data
				else
					return arg0_96.player_id < arg1_96.player_id
				end
			end)
			arg0_94:SetRankUI(var0_95)
		end
	})
end

function var0_0.SetRankUI(arg0_97, arg1_97)
	setActive(arg0_97.rankUI, true)

	local var0_97
	local var1_97 = 0

	arg0_97.rankPlayerList:make(function(arg0_98, arg1_98, arg2_98)
		local var0_98 = arg1_97[arg1_98 + 1]

		setText(arg2_98:Find("rank/count"), arg1_98 + 1)

		if arg1_98 + 1 == 1 then
			arg0_97:SetRankColor(arg2_98, "ea69fd", var0_98.name, var0_98.score)
		elseif arg1_98 + 1 == 2 then
			arg0_97:SetRankColor(arg2_98, "11bfff", var0_98.name, var0_98.score)
		elseif arg1_98 + 1 == 3 then
			arg0_97:SetRankColor(arg2_98, "51edca", var0_98.name, var0_98.score)
		else
			arg0_97:SetRankColor(arg2_98, "83919c", var0_98.name, var0_98.score)
		end

		local var1_98 = getProxy(PlayerProxy):isSelf(var0_98.player_id)

		if var1_98 then
			var0_97 = var0_98
			var1_97 = arg1_98 + 1
		end

		setActive(arg2_98:Find("1"), arg1_98 + 1 == 1)
		setActive(arg2_98:Find("2"), arg1_98 + 1 == 2)
		setActive(arg2_98:Find("3"), arg1_98 + 1 == 3)
		setActive(arg2_98:Find("rank/1"), arg1_98 + 1 == 1)
		setActive(arg2_98:Find("rank/2"), arg1_98 + 1 == 2)
		setActive(arg2_98:Find("rank/3"), arg1_98 + 1 == 3)
		setActive(arg2_98:Find("imgMe"), var1_98)
	end)
	arg0_97.rankPlayerList:align(#arg1_97)
	setText(arg0_97:findTF("nameText", arg0_97.rankMyself), getProxy(PlayerProxy).data:GetName())

	if var0_97 then
		setText(arg0_97:findTF("rank/count", arg0_97.rankMyself), var1_97)

		if var1_97 == 1 then
			arg0_97:SetRankColor(arg0_97.rankMyself, "ea69fd", var0_97.name, var0_97.score)
		elseif var1_97 == 2 then
			arg0_97:SetRankColor(arg0_97.rankMyself, "11bfff", var0_97.name, var0_97.score)
		elseif var1_97 == 3 then
			arg0_97:SetRankColor(arg0_97.rankMyself, "51edca", var0_97.name, var0_97.score)
		else
			arg0_97:SetRankColor(arg0_97.rankMyself, "83919c", var0_97.name, var0_97.score)
		end

		setActive(arg0_97:findTF("1", arg0_97.rankMyself), var1_97 == 1)
		setActive(arg0_97:findTF("2", arg0_97.rankMyself), var1_97 == 2)
		setActive(arg0_97:findTF("3", arg0_97.rankMyself), var1_97 == 3)
		setActive(arg0_97:findTF("rank/1", arg0_97.rankMyself), var1_97 == 1)
		setActive(arg0_97:findTF("rank/2", arg0_97.rankMyself), var1_97 == 2)
		setActive(arg0_97:findTF("rank/3", arg0_97.rankMyself), var1_97 == 3)
	end
end

function var0_0.SetRankColor(arg0_99, arg1_99, arg2_99, arg3_99, arg4_99)
	setText(arg1_99:Find("nameText"), "<color=#" .. arg2_99 .. ">" .. arg3_99 .. "</color>")
	setText(arg1_99:Find("score"), "<color=#" .. arg2_99 .. ">" .. arg4_99 .. "</color>")
end

function var0_0.ShowBuff(arg0_100)
	setActive(arg0_100.buffUI, true)

	local var0_100 = var1_0.GetBuffList(arg0_100:GetMGHubData())

	arg0_100.buffList:make(function(arg0_101, arg1_101, arg2_101)
		local var0_101 = var0_100[arg1_101 + 1]

		setText(arg2_101:Find("name"), var0_101[1])
		setText(arg2_101:Find("desc"), var0_101[2])
		setText(arg2_101:Find("lock/unlockTime"), var0_101[3])
		setText(arg2_101:Find("useToggle/onText"), i18n("tolovegame_buff_switch_1"))
		setText(arg2_101:Find("useToggle/using/offText"), i18n("tolovegame_buff_switch_2"))

		for iter0_101 = 1, 7 do
			setActive(arg2_101:Find("buffImg"):GetChild(iter0_101 - 1), arg1_101 + 1 == iter0_101)
		end

		onToggle(arg0_100, arg2_101:Find("useToggle"), function(arg0_102)
			if arg0_102 then
				PlayerPrefs.SetInt("ToLoveGameBuff", arg1_101 + 1)
				PlayerPrefs.Save()
				setActive(arg2_101:Find("buffImg/select"), true)
				setActive(arg2_101:Find("useToggle/using"), true)
			else
				PlayerPrefs.DeleteKey("ToLoveGameBuff")
				setActive(arg2_101:Find("buffImg/select"), false)
				setActive(arg2_101:Find("useToggle/using"), false)
			end
		end, SFX_PANEL)

		local var1_101 = PlayerPrefs.GetInt("ToLoveGameBuff", 0)

		if arg1_101 + 1 == var1_101 then
			triggerToggle(arg2_101:Find("useToggle"), true)
		end

		if var0_101[3] == "" then
			setActive(arg2_101:Find("name"), true)
			setActive(arg2_101:Find("desc"), true)
			setActive(arg2_101:Find("lock"), false)
			setActive(arg2_101:Find("useToggle"), true)
		else
			setActive(arg2_101:Find("name"), false)
			setActive(arg2_101:Find("desc"), false)
			setActive(arg2_101:Find("lock"), true)
			setActive(arg2_101:Find("useToggle"), false)
		end
	end)
	arg0_100.buffList:align(#var0_100)
	PlayerPrefs.SetInt("toLoveGameBuffCount", arg0_100.unlockBuffCount)
	setActive(arg0_100.menuBuffTip, arg0_100:ShouldShowBuffTip())
end

function var0_0.ShowTask(arg0_103)
	setActive(arg0_103.taskUI, true)
	arg0_103:GetTaskData()
	arg0_103.taskTasklist:make(function(arg0_104, arg1_104, arg2_104)
		if arg0_104 == UIItemList.EventUpdate then
			local var0_104 = arg0_103.taskVOs[arg1_104 + 1]
			local var1_104 = var0_104:getProgress()
			local var2_104 = var0_104:getConfig("target_num")
			local var3_104 = math.min(var1_104, var2_104)

			setText(arg2_104:Find("frame/progress"), var3_104 .. "/" .. var2_104)

			arg2_104:Find("frame/slider"):GetComponent(typeof(Slider)).value = var3_104 / var2_104

			setText(arg2_104:Find("frame/go_btn/Text"), i18n("tolovegame_proceed"))
			setText(arg2_104:Find("frame/get_btn/Text"), i18n("tolovegame_collect"))
			setText(arg2_104:Find("frame/got_btn/Text"), i18n("tolovegame_collected"))

			local var4_104 = arg2_104:Find("frame/awards")
			local var5_104 = var4_104:GetChild(0)

			arg0_103:updateAwards(var0_104:getConfig("award_display"), var4_104, var5_104)

			local var6_104 = arg2_104:Find("frame/go_btn")
			local var7_104 = arg2_104:Find("frame/get_btn")
			local var8_104 = arg2_104:Find("frame/got_btn")
			local var9_104 = arg2_104:Find("frame/leftBar")
			local var10_104 = arg2_104:Find("frame/leftBarGot")

			if var0_104:getTaskStatus() == 0 then
				setActive(var6_104, true)
				setActive(var7_104, false)
				setActive(var8_104, false)
				setActive(var9_104, true)
				setActive(var10_104, false)
				arg0_103:SetTaskColor(arg2_104, "4de3c2", var0_104:getConfig("desc"))
			elseif var0_104:getTaskStatus() == 1 then
				setActive(var6_104, false)
				setActive(var7_104, true)
				setActive(var8_104, false)
				setActive(var9_104, true)
				setActive(var10_104, false)
				arg0_103:SetTaskColor(arg2_104, "4de3c2", var0_104:getConfig("desc"))
			elseif var0_104:getTaskStatus() == 2 then
				setActive(var6_104, false)
				setActive(var7_104, false)
				setActive(var8_104, true)
				setActive(var9_104, false)
				setActive(var10_104, true)
				arg0_103:SetTaskColor(arg2_104, "616161", var0_104:getConfig("desc"))
			end

			onButton(arg0_103, var6_104, function()
				setActive(arg0_103.taskUI, false)
				arg0_103:ShowBuff()
				arg0_103:GetTaskData()
				setActive(arg0_103.menuTaskTip, arg0_103.canGetAward)
			end, SFX_PANEL)
			onButton(arg0_103, var7_104, function()
				local var0_106 = var0_104:getConfig("award_display")
				local var1_106 = getProxy(PlayerProxy):getRawData()
				local var2_106 = pg.gameset.urpt_chapter_max.description[1]
				local var3_106 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var2_106)
				local var4_106, var5_106 = Task.StaticJudgeOverflow(var1_106.gold, var1_106.oil, var3_106, true, true, var0_106)
				local var6_106 = {}

				if var4_106 then
					table.insert(var6_106, function(arg0_107)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							type = MSGBOX_TYPE_ITEM_BOX,
							content = i18n("award_max_warning"),
							items = var5_106,
							onYes = arg0_107
						})
					end)
				end

				seriesAsync(var6_106, function()
					pg.m02:sendNotification(GAME.SUBMIT_TASK, var0_104.id)
				end)
			end, SFX_PANEL)
		end
	end)
	arg0_103.taskTasklist:align(#arg0_103.taskVOs)
end

function var0_0.GetTaskData(arg0_109)
	arg0_109.taskVOs = {}
	arg0_109.taskIds = getProxy(ActivityProxy):getActivityById(ActivityConst.TOLOVE_MINIGAME_TASK_ID):getConfig("config_client").task_ids

	for iter0_109, iter1_109 in pairs(arg0_109.taskIds) do
		table.insert(arg0_109.taskVOs, getProxy(TaskProxy):getTaskVO(iter1_109))
	end

	local var0_109 = {}

	arg0_109.canGetAward = false

	for iter2_109, iter3_109 in pairs(arg0_109.taskVOs) do
		if iter3_109:getTaskStatus() == 1 then
			table.insert(var0_109, iter3_109)

			arg0_109.canGetAward = true
		end
	end

	for iter4_109, iter5_109 in pairs(arg0_109.taskVOs) do
		if iter5_109:getTaskStatus() == 0 then
			table.insert(var0_109, iter5_109)
		end
	end

	for iter6_109, iter7_109 in pairs(arg0_109.taskVOs) do
		if iter7_109:getTaskStatus() == 2 then
			table.insert(var0_109, iter7_109)
		end
	end

	arg0_109.taskVOs = var0_109
end

function var0_0.updateAwards(arg0_110, arg1_110, arg2_110, arg3_110)
	local var0_110 = _.slice(arg1_110, 1, 3)

	for iter0_110 = arg2_110.childCount, #var0_110 - 1 do
		cloneTplTo(arg3_110, arg2_110)
	end

	local var1_110 = arg2_110.childCount

	for iter1_110 = 1, var1_110 do
		local var2_110 = arg2_110:GetChild(iter1_110 - 1)
		local var3_110 = iter1_110 <= #var0_110

		setActive(var2_110, var3_110)

		if var3_110 then
			local var4_110 = var0_110[iter1_110]
			local var5_110 = {
				type = var4_110[1],
				id = var4_110[2],
				count = var4_110[3]
			}

			updateDrop(var2_110, var5_110)
			onButton(arg0_110, var2_110, function()
				arg0_110:emit(BaseUI.ON_DROP, var5_110)
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetTaskColor(arg0_112, arg1_112, arg2_112, arg3_112)
	setText(arg1_112:Find("frame/desc"), "<color=#" .. arg2_112 .. ">" .. arg3_112 .. "</color>")
end

function var0_0.pauseGame(arg0_113)
	arg0_113.gameStop = true

	arg0_113:timerStop()
end

function var0_0.resumeGame(arg0_114)
	arg0_114.gameStop = false

	arg0_114:timerStart()
end

function var0_0.UpdateTaskProgress(arg0_115)
	local var0_115 = getProxy(TaskProxy)

	for iter0_115 = 1, 7 do
		if var1_0.buffIndex == iter0_115 then
			if var0_115:getTaskById(arg0_115.taskIds[iter0_115]) then
				pg.m02:sendNotification(GAME.MINI_GAME_TASK_PROGRESS_UPDATE, {
					progressAdd = 1,
					taskId = arg0_115.taskIds[iter0_115]
				})
			end

			if var0_115:getTaskById(arg0_115.taskIds[iter0_115 + 7]) then
				arg0_115:UpdateTaskScore(arg0_115.taskIds[iter0_115 + 7])
			end

			break
		end
	end
end

function var0_0.UpdateTaskScore(arg0_116, arg1_116)
	local var0_116 = getProxy(TaskProxy):getTaskById(arg1_116).progress

	if var0_116 < var1_0.score then
		local var1_116 = 0

		if var1_0.score > 2000 then
			var1_116 = 2000 - var0_116
		else
			var1_116 = var1_0.score - var0_116
		end

		pg.m02:sendNotification(GAME.MINI_GAME_TASK_PROGRESS_UPDATE, {
			taskId = arg1_116,
			progressAdd = var1_116
		})
	end
end

function var0_0.changeBgm(arg0_117, arg1_117)
	local var0_117

	if arg1_117 == ToLoveGameConst.bgm_type_default then
		var0_117 = arg0_117:getBGM()

		if not var0_117 then
			if pg.CriMgr.GetInstance():IsDefaultBGM() then
				var0_117 = pg.voice_bgm.NewMainScene.default_bgm
			else
				var0_117 = pg.voice_bgm.NewMainScene.bgm
			end
		end
	elseif arg1_117 == ToLoveGameConst.bgm_type_menu then
		var0_117 = ToLoveGameConst.menu_bgm
	elseif arg1_117 == ToLoveGameConst.bgm_type_game then
		var0_117 = ToLoveGameConst.game_bgm
	end

	if arg0_117.bgm ~= var0_117 then
		arg0_117.bgm = var0_117

		pg.BgmMgr.GetInstance():Push(arg0_117.__cname, var0_117)
	end
end

function var0_0.OnApplicationPaused(arg0_118)
	if not arg0_118.gameStartFlag then
		return
	end

	if arg0_118.readyStartFlag then
		return
	end

	if arg0_118.settlementFlag then
		return
	end

	arg0_118:pauseGame()
end

function var0_0.initEvent(arg0_119)
	if not arg0_119.handle and IsUnityEditor then
		arg0_119.handle = UpdateBeat:CreateListener(arg0_119.Update, arg0_119)

		UpdateBeat:AddListener(arg0_119.handle)
	end
end

function var0_0.Update(arg0_120)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.W) then
			triggerButton(arg0_120.gamingUp)
		end

		if Input.GetKeyUp(KeyCode.S) then
			triggerButton(arg0_120.gamingDown)
		end

		if Input.GetKeyDown(KeyCode.A) then
			triggerButton(arg0_120.gamingLeft)
		end

		if Input.GetKeyUp(KeyCode.D) then
			triggerButton(arg0_120.gamingRight)
		end
	end
end

function var0_0.willExit(arg0_121)
	if arg0_121.timer and arg0_121.timer.running then
		arg0_121.timer:Stop()
	end

	arg0_121.timer = nil

	if arg0_121.handle then
		UpdateBeat:RemoveListener(arg0_121.handle)
	end
end

function var0_0.onBackPressed(arg0_122)
	if arg0_122.readyStartFlag then
		return
	end

	if not arg0_122.gameStartFlag then
		return
	else
		if arg0_122.settlementFlag then
			return
		end

		if isActive(arg0_122.pauseUI) then
			arg0_122:resumeGame()
			setActive(arg0_122.pauseUI, false)
		elseif isActive(arg0_122.leaveUI) then
			arg0_122:resumeGame()
			setActive(arg0_122.leaveUI, false)
		elseif not isActive(arg0_122.pauseUI) and not isActive(arg0_122.pauseUI) then
			if not var1_0.startSettlement then
				arg0_122:pauseGame()
				setActive(arg0_122.pauseUI, true)
			end
		else
			arg0_122:resumeGame()
		end
	end
end

return var0_0
