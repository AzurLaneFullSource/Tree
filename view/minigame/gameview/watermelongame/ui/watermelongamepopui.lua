local var0_0 = class("WatermelonGamePopUI")

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
		arg0_2._event:emit(WatermelonGameEvent.COUNT_DOWN)
	end)
end

function var0_0.initLeavelUI(arg0_5)
	arg0_5.leaveUI = findTF(arg0_5._tf, "pop/LeaveUI")

	GetComponent(findTF(arg0_5.leaveUI, "ad/desc"), typeof(Image)):SetNativeSize()
	setActive(arg0_5.leaveUI, false)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnOk"), function()
		arg0_5:resumeGame()
		arg0_5._event:emit(WatermelonGameEvent.LEVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnCancel"), function()
		arg0_5:resumeGame()
		arg0_5._event:emit(WatermelonGameEvent.LEVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initPauseUI(arg0_8)
	arg0_8.pauseUI = findTF(arg0_8._tf, "pop/pauseUI")

	setActive(arg0_8.pauseUI, false)
	GetComponent(findTF(arg0_8.pauseUI, "ad/desc"), typeof(Image)):SetNativeSize()
	onButton(arg0_8._event, findTF(arg0_8.pauseUI, "ad/btnOk"), function()
		arg0_8:resumeGame()
		arg0_8._event:emit(WatermelonGameEvent.PAUSE_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initSettlementUI(arg0_10)
	arg0_10.settlementUI = findTF(arg0_10._tf, "pop/SettleMentUI")

	GetComponent(findTF(arg0_10.settlementUI, "ad/HighImg"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_10.settlementUI, "ad/CurImg"), typeof(Image)):SetNativeSize()
	setActive(arg0_10.settlementUI, false)
	onButton(arg0_10._event, findTF(arg0_10.settlementUI, "ad/btnOver"), function()
		arg0_10:clearUI()
		arg0_10._event:emit(WatermelonGameEvent.BACK_MENU)
	end, SFX_CANCEL)
end

function var0_0.initRankUI(arg0_12)
	arg0_12.rankUI = findTF(arg0_12._tf, "pop/RankUI")

	arg0_12:popRankUI(false)
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
		arg0_12:popRankUI(false)
	end, SFX_CANCEL)
	onButton(arg0_12._event, arg0_12._rankBtnClose, function()
		arg0_12:popRankUI(false)
	end, SFX_CANCEL)
	setText(arg0_12._rankDesc, i18n(WatermelonGameConst.rank_tip))
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
	setActive(findTF(arg1_16, "imgMy"), var5_16)
end

function var0_0.setChildVisible(arg0_17, arg1_17, arg2_17)
	for iter0_17 = 1, arg1_17.childCount do
		local var0_17 = arg1_17:GetChild(iter0_17 - 1)

		setActive(var0_17, arg2_17)
	end
end

function var0_0.initRankUI(arg0_18)
	arg0_18.rankUI = findTF(arg0_18._tf, "pop/RankUI")

	arg0_18:showRank(false)
	GetComponent(findTF(arg0_18.rankUI, "ad/img/score"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_18.rankUI, "ad/img/time"), typeof(Image)):SetNativeSize()

	arg0_18._rankImg = findTF(arg0_18.rankUI, "ad/img")
	arg0_18._rankBtnClose = findTF(arg0_18.rankUI, "ad/btnClose")
	arg0_18._rankContent = findTF(arg0_18.rankUI, "ad/list/content")
	arg0_18._rankItemTpl = findTF(arg0_18.rankUI, "ad/list/content/itemTpl")
	arg0_18._rankEmpty = findTF(arg0_18.rankUI, "ad/empty")
	arg0_18._rankDesc = findTF(arg0_18.rankUI, "ad/desc")
	arg0_18._rankItems = {}

	setActive(arg0_18._rankItemTpl, false)
	onButton(arg0_18._event, findTF(arg0_18.rankUI, "ad/close"), function()
		arg0_18:showRank(false)
	end, SFX_CANCEL)
	onButton(arg0_18._event, arg0_18._rankBtnClose, function()
		arg0_18:showRank(false)
	end, SFX_CANCEL)
	setText(arg0_18._rankDesc, i18n(WatermelonGameConst.rank_tip))
end

function var0_0.showRank(arg0_21, arg1_21)
	setActive(arg0_21.rankUI, arg1_21)
end

function var0_0.updateSettlementUI(arg0_22)
	GetComponent(findTF(arg0_22.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_22 = arg0_22._gameVo.scoreNum
	local var1_22 = getProxy(MiniGameProxy):GetHighScore(arg0_22._gameVo.gameId)
	local var2_22 = var1_22 and #var1_22 > 0 and var1_22[1] or 0

	setActive(findTF(arg0_22.settlementUI, "ad/new"), var2_22 < var0_22)

	if var0_22 > 0 and var2_22 < var0_22 then
		arg0_22._event:emit(WatermelonGameEvent.STORE_SERVER, {
			var0_22,
			1
		})
	end

	local var3_22 = findTF(arg0_22.settlementUI, "ad/highText")
	local var4_22 = findTF(arg0_22.settlementUI, "ad/currentText")

	setText(var4_22, var0_22)
	setText(var3_22, var2_22)
	arg0_22._event:emit(WatermelonGameEvent.SUBMIT_GAME_SUCCESS)
end

function var0_0.backPressed(arg0_23)
	if isActive(arg0_23.pauseUI) then
		arg0_23:resumeGame()
		arg0_23._event:emit(WatermelonGameEvent.PAUSE_GAME, false)
	elseif isActive(arg0_23.leaveUI) then
		arg0_23:resumeGame()
		arg0_23._event:emit(WatermelonGameEvent.LEVEL_GAME, false)
	elseif not isActive(arg0_23.pauseUI) and not isActive(arg0_23.pauseUI) then
		if not arg0_23._gameVo.startSettlement then
			arg0_23:popPauseUI()
			arg0_23._event:emit(WatermelonGameEvent.PAUSE_GAME, true)
		end
	else
		arg0_23:resumeGame()
	end
end

function var0_0.resumeGame(arg0_24)
	setActive(arg0_24.leaveUI, false)
	setActive(arg0_24.pauseUI, false)
end

function var0_0.popLeaveUI(arg0_25)
	if isActive(arg0_25.pauseUI) then
		setActive(arg0_25.pauseUI, false)
	end

	setActive(arg0_25.leaveUI, true)
end

function var0_0.popPauseUI(arg0_26)
	if isActive(arg0_26.leaveUI) then
		setActive(arg0_26.leaveUI, false)
	end

	setActive(arg0_26.pauseUI, true)
end

function var0_0.updateGameUI(arg0_27, arg1_27)
	setText(arg0_27.scoreTf, arg1_27.scoreNum)
	setText(arg0_27.gameTimeS, math.ceil(arg1_27.gameTime))
end

function var0_0.readyStart(arg0_28)
	arg0_28:popCountUI(true)
	arg0_28.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(WatermelonGameConst.SFX_COUNT_DOWN)
end

function var0_0.popCountUI(arg0_29, arg1_29)
	setActive(arg0_29.countUI, arg1_29)
end

function var0_0.popSettlementUI(arg0_30, arg1_30)
	setActive(arg0_30.settlementUI, arg1_30)
end

function var0_0.popRankUI(arg0_31, arg1_31)
	setActive(arg0_31.rankUI, arg1_31)
end

function var0_0.clearUI(arg0_32)
	setActive(arg0_32.settlementUI, false)
	setActive(arg0_32.countUI, false)
end

return var0_0
