local var0_0 = class("WatermelonGamePopUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1

	arg0_1:initCountUI()
	arg0_1:initLeavelUI()
	arg0_1:initPauseUI()
	arg0_1:initSettlementUI()
end

function var0_0.initCountUI(arg0_2)
	arg0_2.countUI = findTF(arg0_2._tf, "pop/CountUI")
	arg0_2.countAnimator = GetComponent(findTF(arg0_2.countUI, "count"), typeof(Animator))
	arg0_2.countDft = GetOrAddComponent(findTF(arg0_2.countUI, "count"), typeof(DftAniEvent))

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
	setText(findTF(arg0_5.leaveUI, "ad/btnConfirmDesc"), i18n("ryza_task_confirm"))
	setText(findTF(arg0_5.leaveUI, "ad/btnCancelDesc"), i18n("ryza_task_cancel"))
	setActive(arg0_5.leaveUI, false)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnConfirm"), function()
		arg0_5:ResumeGame()
		arg0_5._event:emit(SimpleMGEvent.LEVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnCancel"), function()
		arg0_5:ResumeGame()
		arg0_5._event:emit(SimpleMGEvent.LEVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initPauseUI(arg0_8)
	arg0_8.pauseUI = findTF(arg0_8._tf, "pop/pauseUI")

	setActive(arg0_8.pauseUI, false)
	setText(findTF(arg0_8.pauseUI, "ad/desc"), i18n("mini_game_pause"))
	setText(findTF(arg0_8.pauseUI, "ad/btnDesc"), i18n("mini_game_continue"))
	onButton(arg0_8._event, findTF(arg0_8.pauseUI, "ad/btnOk"), function()
		arg0_8:ResumeGame()
		arg0_8._event:emit(SimpleMGEvent.PAUSE_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initSettlementUI(arg0_10)
	arg0_10.settlementUI = findTF(arg0_10._tf, "pop/SettleMentUI")

	setText(findTF(arg0_10.settlementUI, "ad/btnOver/text"), i18n("mini_game_over_game"))
	setText(findTF(arg0_10.settlementUI, "ad/HighDesc"), i18n("mini_game_high_score"))
	setText(findTF(arg0_10.settlementUI, "ad/CurDesc"), i18n("mini_game_cur_score"))
	setActive(arg0_10.settlementUI, false)
	onButton(arg0_10._event, findTF(arg0_10.settlementUI, "ad/btnOver"), function()
		arg0_10:ClearUI()
		arg0_10._event:emit(SimpleMGEvent.BACK_MENU)
	end, SFX_CANCEL)
end

function var0_0.setChildVisible(arg0_12, arg1_12, arg2_12)
	for iter0_12 = 1, arg1_12.childCount do
		local var0_12 = arg1_12:GetChild(iter0_12 - 1)

		setActive(var0_12, arg2_12)
	end
end

function var0_0.PopPauseUI(arg0_13)
	if isActive(arg0_13.leaveUI) then
		setActive(arg0_13.leaveUI, false)
	end

	setActive(arg0_13.pauseUI, true)
end

function var0_0.PopCountUI(arg0_14, arg1_14)
	setActive(arg0_14.countUI, arg1_14)
end

function var0_0.PopSettlementUI(arg0_15, arg1_15)
	setActive(arg0_15.settlementUI, arg1_15)
end

function var0_0.PopLeaveUI(arg0_16)
	if isActive(arg0_16.pauseUI) then
		setActive(arg0_16.pauseUI, false)
	end

	setActive(arg0_16.leaveUI, true)
end

function var0_0.UpdateSettlementUI(arg0_17)
	GetComponent(findTF(arg0_17.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_17 = arg0_17._gameVo:GetScore()
	local var1_17

	if arg0_17._gameVo:GetConfig("game_room") > 0 then
		var1_17 = getProxy(GameRoomProxy):getRoomScore(arg0_17._gameVo:GetConfig("game_room"))
	else
		local var2_17 = getProxy(MiniGameProxy):GetHighScore(arg0_17._gameVo:GetGameId())

		var1_17 = var2_17 and #var2_17 > 0 and var2_17[1] or 0
	end

	setActive(findTF(arg0_17.settlementUI, "ad/new"), var1_17 < var0_17)

	if var0_17 > 0 and var1_17 < var0_17 then
		arg0_17._event:emit(SimpleMGEvent.STORE_SERVER, {
			var0_17,
			1
		})
	end

	local var3_17 = findTF(arg0_17.settlementUI, "ad/highText")
	local var4_17 = findTF(arg0_17.settlementUI, "ad/currentText")

	setText(var4_17, var0_17)
	setText(var3_17, var1_17)
	arg0_17._event:emit(SimpleMGEvent.SUBMIT_GAME_SUCCESS, var0_17)
end

function var0_0.BackPressed(arg0_18)
	if isActive(arg0_18.pauseUI) then
		arg0_18:ResumeGame()
		arg0_18._event:emit(SimpleMGEvent.PAUSE_GAME, false)
	elseif isActive(arg0_18.leaveUI) then
		arg0_18:ResumeGame()
		arg0_18._event:emit(SimpleMGEvent.LEVEL_GAME, false)
	elseif not isActive(arg0_18.pauseUI) and not isActive(arg0_18.pauseUI) then
		if not arg0_18._gameVo:IsSettlement() then
			arg0_18:PopPauseUI()
			arg0_18._event:emit(SimpleMGEvent.PAUSE_GAME, true)
		end
	else
		arg0_18:ResumeGame()
	end
end

function var0_0.ResumeGame(arg0_19)
	setActive(arg0_19.leaveUI, false)
	setActive(arg0_19.pauseUI, false)
end

function var0_0.UpdateGameUI(arg0_20, arg1_20)
	setText(arg0_20.scoreTf, arg1_20.scoreNum)
	setText(arg0_20.gameTimeS, math.ceil(arg1_20.gameTime))
end

function var0_0.ReadyStart(arg0_21)
	arg0_21:PopCountUI(true)
	arg0_21.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(WatermelonGameConst.SFX_COUNT_DOWN)
end

function var0_0.ClearUI(arg0_22)
	setActive(arg0_22.settlementUI, false)
	setActive(arg0_22.countUI, false)
end

return var0_0
