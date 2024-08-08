local var0_0 = class("PipeGamePopUI")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	var1_0 = PipeGameVo

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
		arg0_2._event:emit(PipeGameEvent.COUNT_DOWN)
	end)
end

function var0_0.initLeavelUI(arg0_5)
	arg0_5.leaveUI = findTF(arg0_5._tf, "pop/LeaveUI")

	GetComponent(findTF(arg0_5.leaveUI, "ad/desc"), typeof(Image)):SetNativeSize()
	setActive(arg0_5.leaveUI, false)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnOk"), function()
		arg0_5:resumeGame()
		arg0_5._event:emit(PipeGameEvent.LEVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnCancel"), function()
		arg0_5:resumeGame()
		arg0_5._event:emit(PipeGameEvent.LEVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initPauseUI(arg0_8)
	arg0_8.pauseUI = findTF(arg0_8._tf, "pop/pauseUI")

	setActive(arg0_8.pauseUI, false)
	GetComponent(findTF(arg0_8.pauseUI, "ad/desc"), typeof(Image)):SetNativeSize()
	onButton(arg0_8._event, findTF(arg0_8.pauseUI, "ad/btnOk"), function()
		arg0_8:resumeGame()
		arg0_8._event:emit(PipeGameEvent.PAUSE_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initSettlementUI(arg0_10)
	arg0_10.settlementUI = findTF(arg0_10._tf, "pop/SettleMentUI")

	GetComponent(findTF(arg0_10.settlementUI, "ad/HighImg"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_10.settlementUI, "ad/CurImg"), typeof(Image)):SetNativeSize()
	setActive(arg0_10.settlementUI, false)
	onButton(arg0_10._event, findTF(arg0_10.settlementUI, "ad/btnOver"), function()
		arg0_10:clearUI()
		arg0_10._event:emit(PipeGameEvent.BACK_MENU)
	end, SFX_CANCEL)
end

function var0_0.initRankUI(arg0_12)
	arg0_12.rankUI = findTF(arg0_12._tf, "pop/RankUI")

	arg0_12:showRank(false)
	GetComponent(findTF(arg0_12.rankUI, "ad/img/score"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_12.rankUI, "ad/img/time"), typeof(Image)):SetNativeSize()

	arg0_12._rankImg = findTF(arg0_12.rankUI, "ad/img")
	arg0_12._rankBtnClose = findTF(arg0_12.rankUI, "ad/btnClose")
	arg0_12._rankContent = findTF(arg0_12.rankUI, "ad/list/content")
	arg0_12._rankItemTpl = findTF(arg0_12.rankUI, "ad/list/content/itemTpl")
	arg0_12._rankEmpty = findTF(arg0_12.rankUI, "ad/empty")
	arg0_12._rankDesc = findTF(arg0_12.rankUI, "ad/desc")
	arg0_12._rankItems = {}

	setActive(arg0_12._rankItemTpl, false)
	onButton(arg0_12._event, findTF(arg0_12.rankUI, "ad/close"), function()
		arg0_12:showRank(false)
	end, SFX_CANCEL)
	onButton(arg0_12._event, arg0_12._rankBtnClose, function()
		arg0_12:showRank(false)
	end, SFX_CANCEL)
	setText(arg0_12._rankDesc, i18n(var1_0.rank_tip))
end

function var0_0.updateRankData(arg0_15, arg1_15)
	for iter0_15 = 1, #arg1_15 do
		local var0_15

		if iter0_15 > #arg0_15._rankItems then
			local var1_15 = tf(instantiate(arg0_15._rankItemTpl))

			setActive(var1_15, false)
			setParent(var1_15, arg0_15._rankContent)
			table.insert(arg0_15._rankItems, var1_15)
		end

		local var2_15 = arg0_15._rankItems[iter0_15]

		arg0_15:setRankItemData(var2_15, arg1_15[iter0_15], iter0_15)
		setActive(var2_15, true)
	end

	for iter1_15 = #arg1_15 + 1, #arg0_15._rankItems do
		setActive(arg0_15._rankItems, false)
	end

	setActive(arg0_15._rankEmpty, #arg1_15 == 0)
	setActive(arg0_15._rankImg, #arg1_15 > 0)
end

function var0_0.setRankItemData(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg2_16.name
	local var1_16 = arg2_16.player_id
	local var2_16 = arg2_16.position
	local var3_16 = arg2_16.score
	local var4_16 = arg2_16.time_data
	local var5_16 = getProxy(PlayerProxy):isSelf(var1_16)

	setText(findTF(arg1_16, "nameText"), var0_16)
	arg0_16:setChildVisible(findTF(arg1_16, "bg"), false)
	arg0_16:setChildVisible(findTF(arg1_16, "rank"), false)

	if arg3_16 <= 3 then
		setActive(findTF(arg1_16, "bg/" .. arg3_16), true)
		setActive(findTF(arg1_16, "rank/" .. arg3_16), true)
	elseif var5_16 then
		setActive(findTF(arg1_16, "bg/me"), true)
		setActive(findTF(arg1_16, "rank/count"), true)
	else
		setActive(findTF(arg1_16, "bg/other"), true)
		setActive(findTF(arg1_16, "rank/count"), true)
	end

	setText(findTF(arg1_16, "rank/count"), tostring(arg3_16))
	setText(findTF(arg1_16, "score"), tostring(var3_16))
	setText(findTF(arg1_16, "time"), tostring(var4_16))
	setActive(findTF(arg1_16, "imgMy"), var5_16)
end

function var0_0.setChildVisible(arg0_17, arg1_17, arg2_17)
	for iter0_17 = 1, arg1_17.childCount do
		local var0_17 = arg1_17:GetChild(iter0_17 - 1)

		setActive(var0_17, arg2_17)
	end
end

function var0_0.showRank(arg0_18, arg1_18)
	setActive(arg0_18.rankUI, arg1_18)
end

function var0_0.updateSettlementUI(arg0_19)
	GetComponent(findTF(arg0_19.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_19 = var1_0.scoreNum
	local var1_19 = math.floor(var1_0.gameDragTime)
	local var2_19 = getProxy(MiniGameProxy):GetHighScore(var1_0.game_id)
	local var3_19 = var2_19 and #var2_19 > 0 and var2_19[1] or 0
	local var4_19 = var2_19 and #var2_19 > 1 and var2_19[2] or 0

	setActive(findTF(arg0_19.settlementUI, "ad/new"), var3_19 < var0_19)

	if var0_19 > 0 and var3_19 < var0_19 then
		arg0_19._event:emit(PipeGameEvent.STORE_SERVER, {
			var0_19,
			var1_19
		})
	elseif var0_19 > 0 and var0_19 == var3_19 and var4_19 < var1_19 then
		arg0_19._event:emit(PipeGameEvent.STORE_SERVER, {
			var0_19,
			var1_19
		})
	end

	local var5_19 = findTF(arg0_19.settlementUI, "ad/highText")
	local var6_19 = findTF(arg0_19.settlementUI, "ad/currentText")

	setText(var6_19, var0_19)
	setText(var5_19, var1_19)
	arg0_19._event:emit(PipeGameEvent.SUBMIT_GAME_SUCCESS)
end

function var0_0.backPressed(arg0_20)
	if isActive(arg0_20.pauseUI) then
		arg0_20:resumeGame()
		arg0_20._event:emit(PipeGameEvent.PAUSE_GAME, false)
	elseif isActive(arg0_20.leaveUI) then
		arg0_20:resumeGame()
		arg0_20._event:emit(PipeGameEvent.LEVEL_GAME, false)
	elseif not isActive(arg0_20.pauseUI) and not isActive(arg0_20.pauseUI) then
		if not var1_0.startSettlement then
			arg0_20:popPauseUI()
			arg0_20._event:emit(PipeGameEvent.PAUSE_GAME, true)
		end
	else
		arg0_20:resumeGame()
	end
end

function var0_0.resumeGame(arg0_21)
	setActive(arg0_21.leaveUI, false)
	setActive(arg0_21.pauseUI, false)
end

function var0_0.popLeaveUI(arg0_22)
	if isActive(arg0_22.pauseUI) then
		setActive(arg0_22.pauseUI, false)
	end

	setActive(arg0_22.leaveUI, true)
end

function var0_0.popPauseUI(arg0_23)
	if isActive(arg0_23.leaveUI) then
		setActive(arg0_23.leaveUI, false)
	end

	setActive(arg0_23.pauseUI, true)
end

function var0_0.updateGameUI(arg0_24, arg1_24)
	setText(arg0_24.scoreTf, arg1_24.scoreNum)
	setText(arg0_24.gameTimeS, math.ceil(arg1_24.gameTime))
end

function var0_0.readyStart(arg0_25)
	arg0_25:popCountUI(true)
	arg0_25.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_COUNT_DOWN)
end

function var0_0.popCountUI(arg0_26, arg1_26)
	setActive(arg0_26.countUI, arg1_26)
end

function var0_0.popSettlementUI(arg0_27, arg1_27)
	setActive(arg0_27.settlementUI, arg1_27)
end

function var0_0.clearUI(arg0_28)
	setActive(arg0_28.settlementUI, false)
	setActive(arg0_28.countUI, false)
end

return var0_0
