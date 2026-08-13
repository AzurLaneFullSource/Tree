local var0_0 = class("CrossRoadPopUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1

	arg0_1:initCountUI()
	arg0_1:initLeavelUI()
	arg0_1:initSettlementUI()
end

function var0_0.initCountUI(arg0_2)
	arg0_2.countUI = findTF(arg0_2._tf, "pop/CountUI")
	arg0_2.countAnimator = GetComponent(arg0_2.countUI, typeof(Animator))
	arg0_2.countDft = GetOrAddComponent(arg0_2.countUI, typeof(DftAniEvent))

	arg0_2.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_2.countDft:SetEndEvent(function()
		arg0_2._event:emit(SimpleMGEvent.COUNT_DOWN)
	end)
end

function var0_0.initLeavelUI(arg0_5)
	arg0_5.leaveUI = findTF(arg0_5._tf, "pop/LeaveUI")

	setText(findTF(arg0_5.leaveUI, "ad/desc"), i18n("mini_game_leave"))
	setActive(arg0_5.leaveUI, false)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnConfirm"), function()
		arg0_5:ResumeGame()
		arg0_5._event:emit(CrossRoadGameView.LEAVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnCancel"), function()
		arg0_5:ResumeGame()
		arg0_5._event:emit(CrossRoadGameView.LEAVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initSettlementUI(arg0_8)
	arg0_8.settlementUI = findTF(arg0_8._tf, "pop/SettleMentUI")
	arg0_8.curRoleText = findTF(arg0_8.settlementUI, "ad/1/layout2/curRoleText")
	arg0_8.curRoleTextCnt = findTF(arg0_8.settlementUI, "ad/1/layout2/curRoleText_Cnt")
	arg0_8.curScoreText = findTF(arg0_8.settlementUI, "ad/1/layout1/currentText")
	arg0_8.curScoreTextCnt = findTF(arg0_8.settlementUI, "ad/1/layout1/currentText_Cnt")

	setActive(arg0_8.settlementUI, false)
	onButton(arg0_8._event, findTF(arg0_8.settlementUI, "ad/btnOver"), function()
		arg0_8:ClearUI()
		arg0_8._event:emit(SimpleMGEvent.BACK_MENU)
	end, SFX_CANCEL)
	onButton(arg0_8._event, findTF(arg0_8.settlementUI, "ad/btnAgain"), function()
		arg0_8:ClearUI()
		arg0_8._event:emit(CrossRoadGameView.AGAIN)
	end, SFX_CANCEL)
end

function var0_0.setChildVisible(arg0_11, arg1_11, arg2_11)
	for iter0_11 = 1, arg1_11.childCount do
		local var0_11 = arg1_11:GetChild(iter0_11 - 1)

		setActive(var0_11, arg2_11)
	end
end

function var0_0.PopPauseUI(arg0_12)
	if isActive(arg0_12.leaveUI) then
		setActive(arg0_12.leaveUI, false)
	end
end

function var0_0.PopCountUI(arg0_13, arg1_13)
	setActive(arg0_13.countUI, arg1_13)
end

function var0_0.PopSettlementUI(arg0_14, arg1_14)
	setActive(arg0_14.settlementUI, arg1_14)
end

function var0_0.PopLeaveUI(arg0_15)
	setActive(arg0_15.leaveUI, true)
end

function var0_0.UpdateSettlementUI(arg0_16)
	GetComponent(findTF(arg0_16.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_16 = arg0_16._gameVo:GetScore()
	local var1_16 = arg0_16._gameVo:GetRoleCnt()

	setText(arg0_16.curScoreText, i18n("mini_game_crossroad_score"))
	setText(arg0_16.curScoreTextCnt, var0_16)
	setText(arg0_16.curRoleText, i18n("mini_game_crossroad_cnt"))
	setText(arg0_16.curRoleTextCnt, var1_16)
	arg0_16._event:emit(SimpleMGEvent.SUBMIT_GAME_SUCCESS, {
		num = var0_16,
		cnt = var1_16
	})
end

function var0_0.BackPressed(arg0_17)
	if isActive(arg0_17.leaveUI) then
		arg0_17:ResumeGame()
		arg0_17._event:emit(CrossRoadGameView.LEAVEL_GAME, false)
	else
		setActive(arg0_17.leaveUI, true)
		arg0_17._event:emit(SimpleMGEvent.PAUSE_GAME, true)
	end
end

function var0_0.ResumeGame(arg0_18)
	setActive(arg0_18.leaveUI, false)
end

function var0_0.UpdateGameUI(arg0_19, arg1_19)
	setText(arg0_19.scoreTf, arg1_19.scoreNum)
	setText(arg0_19.gameTimeS, math.ceil(arg1_19.gameTime))
end

function var0_0.ReadyStart(arg0_20)
	arg0_20:PopCountUI(true)
	arg0_20.countAnimator:Play("cross_count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(WatermelonGameConst.SFX_COUNT_DOWN)
end

function var0_0.ClearUI(arg0_21)
	setActive(arg0_21.settlementUI, false)
	setActive(arg0_21.countUI, false)
end

return var0_0
