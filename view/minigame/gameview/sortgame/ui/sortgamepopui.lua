local var0_0 = class("SortGamePopUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1

	arg0_1:initCountUI()
	arg0_1:initLeavelUI()
	arg0_1:initPauseUI()
	arg0_1:initSettlementUI()
	arg0_1:initRankUI()
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

function var0_0.initRankUI(arg0_12)
	arg0_12.rankUI = findTF(arg0_12._tf, "pop/RankUI")

	arg0_12:PopRankUI(false)

	arg0_12._rankImg = findTF(arg0_12.rankUI, "ad/img")
	arg0_12._rankBtnClose = findTF(arg0_12.rankUI, "ad/btnClose")
	arg0_12._rankContent = findTF(arg0_12.rankUI, "ad/list/content")
	arg0_12._rankItemTpl = findTF(arg0_12.rankUI, "ad/list/content/itemTpl")
	arg0_12._rankEmpty = findTF(arg0_12.rankUI, "ad/empty")
	arg0_12._rankDesc = findTF(arg0_12.rankUI, "ad/desc")
	arg0_12._rankItems = {}

	setActive(arg0_12._rankItemTpl, false)
	onButton(arg0_12._event, findTF(arg0_12.rankUI, "ad/close"), function()
		arg0_12:PopRankUI(false)
	end, SFX_CANCEL)
	onButton(arg0_12._event, arg0_12._rankBtnClose, function()
		arg0_12:PopRankUI(false)
	end, SFX_CANCEL)
end

function var0_0.setChildVisible(arg0_15, arg1_15, arg2_15)
	for iter0_15 = 1, arg1_15.childCount do
		local var0_15 = arg1_15:GetChild(iter0_15 - 1)

		setActive(var0_15, arg2_15)
	end
end

function var0_0.PopPauseUI(arg0_16)
	if isActive(arg0_16.leaveUI) then
		setActive(arg0_16.leaveUI, false)
	end

	setActive(arg0_16.pauseUI, true)
end

function var0_0.PopCountUI(arg0_17, arg1_17)
	setActive(arg0_17.countUI, arg1_17)
end

function var0_0.PopSettlementUI(arg0_18, arg1_18)
	setActive(arg0_18.settlementUI, arg1_18)
end

function var0_0.PopRankUI(arg0_19, arg1_19)
	setActive(arg0_19.rankUI, arg1_19)
end

function var0_0.PopLeaveUI(arg0_20)
	if isActive(arg0_20.pauseUI) then
		setActive(arg0_20.pauseUI, false)
	end

	setActive(arg0_20.leaveUI, true)
end

function var0_0.UpdateRankData(arg0_21, arg1_21)
	for iter0_21 = 1, #arg1_21 do
		local var0_21

		if iter0_21 > #arg0_21._rankItems then
			local var1_21 = tf(instantiate(arg0_21._rankItemTpl))

			setActive(var1_21, false)
			setParent(var1_21, arg0_21._rankContent)
			table.insert(arg0_21._rankItems, var1_21)
		end

		local var2_21 = arg0_21._rankItems[iter0_21]

		arg0_21:SetRankItemData(var2_21, arg1_21[iter0_21], iter0_21)
		setActive(var2_21, true)
	end

	for iter1_21 = #arg1_21 + 1, #arg0_21._rankItems do
		setActive(arg0_21._rankItems, false)
	end

	setActive(arg0_21._rankEmpty, #arg1_21 == 0)
	setActive(arg0_21._rankImg, #arg1_21 > 0)
end

function var0_0.SetRankItemData(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg2_22.name
	local var1_22 = arg2_22.player_id
	local var2_22 = arg2_22.position
	local var3_22 = arg2_22.score
	local var4_22 = arg2_22.time_data
	local var5_22 = getProxy(PlayerProxy):isSelf(var1_22)

	setText(findTF(arg1_22, "nameText"), var0_22)
	arg0_22:setChildVisible(findTF(arg1_22, "bg"), false)
	arg0_22:setChildVisible(findTF(arg1_22, "rank"), false)

	if arg3_22 <= 3 then
		setActive(findTF(arg1_22, "bg/" .. arg3_22), true)
		setActive(findTF(arg1_22, "rank/" .. arg3_22), true)
	elseif var5_22 then
		setActive(findTF(arg1_22, "bg/me"), true)
		setActive(findTF(arg1_22, "rank/count"), true)
	else
		setActive(findTF(arg1_22, "bg/other"), true)
		setActive(findTF(arg1_22, "rank/count"), true)
	end

	setText(findTF(arg1_22, "rank/count"), tostring(arg3_22))
	setText(findTF(arg1_22, "score"), tostring(var3_22))
	setActive(findTF(arg1_22, "imgMy"), var5_22)
end

function var0_0.UpdateSettlementUI(arg0_23)
	GetComponent(findTF(arg0_23.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_23 = arg0_23._gameVo:GetScore()
	local var1_23

	if arg0_23._gameVo:GetConfig("game_room") > 0 then
		var1_23 = getProxy(GameRoomProxy):getRoomScore(arg0_23._gameVo:GetConfig("game_room"))
	else
		local var2_23 = getProxy(MiniGameProxy):GetHighScore(arg0_23._gameVo:GetGameId())

		var1_23 = var2_23 and #var2_23 > 0 and var2_23[1] or 0
	end

	setActive(findTF(arg0_23.settlementUI, "ad/new"), var1_23 < var0_23)
	arg0_23._event:emit(SimpleMGEvent.STORE_SERVER, {
		var0_23,
		1
	})

	local var3_23 = findTF(arg0_23.settlementUI, "ad/highText")
	local var4_23 = findTF(arg0_23.settlementUI, "ad/currentText")
	local var5_23 = findTF(arg0_23.settlementUI, "ad/currentText_1")

	setText(var4_23, var0_23)
	setText(var5_23, var0_23)
	setText(var3_23, var1_23)
	arg0_23._event:emit(SimpleMGEvent.SUBMIT_GAME_SUCCESS, var0_23)
end

function var0_0.BackPressed(arg0_24)
	if isActive(arg0_24.pauseUI) then
		arg0_24:ResumeGame()
		arg0_24._event:emit(SimpleMGEvent.PAUSE_GAME, false)
	elseif isActive(arg0_24.leaveUI) then
		arg0_24:ResumeGame()
		arg0_24._event:emit(SimpleMGEvent.LEVEL_GAME, false)
	elseif not isActive(arg0_24.pauseUI) and not isActive(arg0_24.pauseUI) then
		if not arg0_24._gameVo:IsSettlement() then
			arg0_24:PopPauseUI()
			arg0_24._event:emit(SimpleMGEvent.PAUSE_GAME, true)
		end
	else
		arg0_24:ResumeGame()
	end
end

function var0_0.ResumeGame(arg0_25)
	setActive(arg0_25.leaveUI, false)
	setActive(arg0_25.pauseUI, false)
end

function var0_0.UpdateGameUI(arg0_26, arg1_26)
	setText(arg0_26.scoreTf, arg1_26.scoreNum)
	setText(arg0_26.gameTimeS, math.ceil(arg1_26.gameTime))
end

function var0_0.ReadyStart(arg0_27)
	arg0_27:PopCountUI(true)
	arg0_27.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SortGameConst.SFX_COUNT_DOWN)
end

function var0_0.ClearUI(arg0_28)
	setActive(arg0_28.settlementUI, false)
	setActive(arg0_28.countUI, false)
end

return var0_0
