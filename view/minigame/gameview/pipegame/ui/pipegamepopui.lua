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
	arg0_12:getRankData()
end

function var0_0.getRankData(arg0_15)
	pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
		id = var1_0.game_id,
		callback = function(arg0_16)
			local var0_16 = {}

			for iter0_16 = 1, #arg0_16 do
				local var1_16 = {}

				for iter1_16, iter2_16 in pairs(arg0_16[iter0_16]) do
					var1_16[iter1_16] = iter2_16
				end

				table.insert(var0_16, var1_16)
			end

			table.sort(var0_16, function(arg0_17, arg1_17)
				if arg0_17.score ~= arg1_17.score then
					return arg0_17.score > arg1_17.score
				elseif arg0_17.time_data ~= arg1_17.time_data then
					return arg0_17.time_data > arg1_17.time_data
				else
					return arg0_17.player_id < arg1_17.player_id
				end
			end)
			arg0_15:updateRankData(var0_16)
		end
	})
end

function var0_0.updateRankData(arg0_18, arg1_18)
	for iter0_18 = 1, #arg1_18 do
		local var0_18

		if iter0_18 > #arg0_18._rankItems then
			local var1_18 = tf(instantiate(arg0_18._rankItemTpl))

			setActive(var1_18, false)
			setParent(var1_18, arg0_18._rankContent)
			table.insert(arg0_18._rankItems, var1_18)
		end

		local var2_18 = arg0_18._rankItems[iter0_18]

		arg0_18:setRankItemData(var2_18, arg1_18[iter0_18], iter0_18)
		setActive(var2_18, true)
	end

	for iter1_18 = #arg1_18 + 1, #arg0_18._rankItems do
		setActive(arg0_18._rankItems, false)
	end

	setActive(arg0_18._rankEmpty, #arg1_18 == 0)
	setActive(arg0_18._rankImg, #arg1_18 > 0)
end

function var0_0.setRankItemData(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg2_19.name
	local var1_19 = arg2_19.player_id
	local var2_19 = arg2_19.position
	local var3_19 = arg2_19.score
	local var4_19 = arg2_19.time_data
	local var5_19 = getProxy(PlayerProxy):isSelf(var1_19)

	setText(findTF(arg1_19, "nameText"), var0_19)
	arg0_19:setChildVisible(findTF(arg1_19, "bg"), false)
	arg0_19:setChildVisible(findTF(arg1_19, "rank"), false)

	if arg3_19 <= 3 then
		setActive(findTF(arg1_19, "bg/" .. arg3_19), true)
		setActive(findTF(arg1_19, "rank/" .. arg3_19), true)
	elseif var5_19 then
		setActive(findTF(arg1_19, "bg/me"), true)
		setActive(findTF(arg1_19, "rank/count"), true)
	else
		setActive(findTF(arg1_19, "bg/other"), true)
		setActive(findTF(arg1_19, "rank/count"), true)
	end

	setText(findTF(arg1_19, "rank/count"), tostring(arg3_19))
	setText(findTF(arg1_19, "score"), tostring(var3_19))
	setText(findTF(arg1_19, "time"), tostring(var4_19))
	setActive(findTF(arg1_19, "imgMy"), var5_19)
end

function var0_0.setChildVisible(arg0_20, arg1_20, arg2_20)
	for iter0_20 = 1, arg1_20.childCount do
		local var0_20 = arg1_20:GetChild(iter0_20 - 1)

		setActive(var0_20, arg2_20)
	end
end

function var0_0.showRank(arg0_21, arg1_21)
	if arg1_21 then
		arg0_21:getRankData()
	end

	setActive(arg0_21.rankUI, arg1_21)
end

function var0_0.updateSettlementUI(arg0_22)
	GetComponent(findTF(arg0_22.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_22 = var1_0.scoreNum
	local var1_22 = math.floor(var1_0.gameDragTime)
	local var2_22 = getProxy(MiniGameProxy):GetHighScore(var1_0.game_id)
	local var3_22 = var2_22 and #var2_22 > 0 and var2_22[1] or 0
	local var4_22 = var2_22 and #var2_22 > 1 and var2_22[2] or 0

	setActive(findTF(arg0_22.settlementUI, "ad/new"), var3_22 < var0_22)

	if var0_22 > 0 and var3_22 < var0_22 then
		arg0_22._event:emit(PipeGameEvent.STORE_SERVER, {
			var0_22,
			var1_22
		})
	elseif var0_22 > 0 and var0_22 == var3_22 and var4_22 < var1_22 then
		arg0_22._event:emit(PipeGameEvent.STORE_SERVER, {
			var0_22,
			var1_22
		})
	end

	local var5_22 = findTF(arg0_22.settlementUI, "ad/highText")
	local var6_22 = findTF(arg0_22.settlementUI, "ad/currentText")

	setText(var6_22, var0_22)
	setText(var5_22, var1_22)
	arg0_22._event:emit(PipeGameEvent.SUBMIT_GAME_SUCCESS)
end

function var0_0.backPressed(arg0_23)
	if isActive(arg0_23.pauseUI) then
		arg0_23:resumeGame()
		arg0_23._event:emit(PipeGameEvent.PAUSE_GAME, false)
	elseif isActive(arg0_23.leaveUI) then
		arg0_23:resumeGame()
		arg0_23._event:emit(PipeGameEvent.LEVEL_GAME, false)
	elseif not isActive(arg0_23.pauseUI) and not isActive(arg0_23.pauseUI) then
		if not var1_0.startSettlement then
			arg0_23:popPauseUI()
			arg0_23._event:emit(PipeGameEvent.PAUSE_GAME, true)
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
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_COUNT_DOWN)
end

function var0_0.popCountUI(arg0_29, arg1_29)
	setActive(arg0_29.countUI, arg1_29)
end

function var0_0.popSettlementUI(arg0_30, arg1_30)
	setActive(arg0_30.settlementUI, arg1_30)
end

function var0_0.clearUI(arg0_31)
	setActive(arg0_31.settlementUI, false)
	setActive(arg0_31.countUI, false)
end

return var0_0
