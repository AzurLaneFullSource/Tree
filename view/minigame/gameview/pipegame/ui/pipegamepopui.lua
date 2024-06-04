local var0 = class("PipeGamePopUI")
local var1

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	var1 = PipeGameVo

	arg0:initCountUI()
	arg0:initLeavelUI()
	arg0:initPauseUI()
	arg0:initSettlementUI()
	arg0:initRankUI()
end

function var0.initCountUI(arg0)
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetOrAddComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		arg0._event:emit(PipeGameEvent.COUNT_DOWN)
	end)
end

function var0.initLeavelUI(arg0)
	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	GetComponent(findTF(arg0.leaveUI, "ad/desc"), typeof(Image)):SetNativeSize()
	setActive(arg0.leaveUI, false)
	onButton(arg0._event, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0._event:emit(PipeGameEvent.LEVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
		arg0._event:emit(PipeGameEvent.LEVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0.initPauseUI(arg0)
	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	setActive(arg0.pauseUI, false)
	GetComponent(findTF(arg0.pauseUI, "ad/desc"), typeof(Image)):SetNativeSize()
	onButton(arg0._event, findTF(arg0.pauseUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0._event:emit(PipeGameEvent.PAUSE_GAME, false)
	end, SFX_CANCEL)
end

function var0.initSettlementUI(arg0)
	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	GetComponent(findTF(arg0.settlementUI, "ad/HighImg"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0.settlementUI, "ad/CurImg"), typeof(Image)):SetNativeSize()
	setActive(arg0.settlementUI, false)
	onButton(arg0._event, findTF(arg0.settlementUI, "ad/btnOver"), function()
		arg0:clearUI()
		arg0._event:emit(PipeGameEvent.BACK_MENU)
	end, SFX_CANCEL)
end

function var0.initRankUI(arg0)
	arg0.rankUI = findTF(arg0._tf, "pop/RankUI")

	arg0:showRank(false)
	GetComponent(findTF(arg0.rankUI, "ad/img/score"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0.rankUI, "ad/img/time"), typeof(Image)):SetNativeSize()

	arg0._rankImg = findTF(arg0.rankUI, "ad/img")
	arg0._rankBtnClose = findTF(arg0.rankUI, "ad/btnClose")
	arg0._rankContent = findTF(arg0.rankUI, "ad/list/content")
	arg0._rankItemTpl = findTF(arg0.rankUI, "ad/list/content/itemTpl")
	arg0._rankEmpty = findTF(arg0.rankUI, "ad/empty")
	arg0._rankDesc = findTF(arg0.rankUI, "ad/desc")
	arg0._rankItems = {}

	setActive(arg0._rankItemTpl, false)
	onButton(arg0._event, findTF(arg0.rankUI, "ad/close"), function()
		arg0:showRank(false)
	end, SFX_CANCEL)
	onButton(arg0._event, arg0._rankBtnClose, function()
		arg0:showRank(false)
	end, SFX_CANCEL)
	setText(arg0._rankDesc, i18n(var1.rank_tip))
	arg0:getRankData()
end

function var0.getRankData(arg0)
	pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
		id = var1.game_id,
		callback = function(arg0)
			local var0 = {}

			for iter0 = 1, #arg0 do
				local var1 = {}

				for iter1, iter2 in pairs(arg0[iter0]) do
					var1[iter1] = iter2
				end

				table.insert(var0, var1)
			end

			table.sort(var0, function(arg0, arg1)
				if arg0.score ~= arg1.score then
					return arg0.score > arg1.score
				elseif arg0.time_data ~= arg1.time_data then
					return arg0.time_data > arg1.time_data
				else
					return arg0.player_id < arg1.player_id
				end
			end)
			arg0:updateRankData(var0)
		end
	})
end

function var0.updateRankData(arg0, arg1)
	for iter0 = 1, #arg1 do
		local var0

		if iter0 > #arg0._rankItems then
			local var1 = tf(instantiate(arg0._rankItemTpl))

			setActive(var1, false)
			setParent(var1, arg0._rankContent)
			table.insert(arg0._rankItems, var1)
		end

		local var2 = arg0._rankItems[iter0]

		arg0:setRankItemData(var2, arg1[iter0], iter0)
		setActive(var2, true)
	end

	for iter1 = #arg1 + 1, #arg0._rankItems do
		setActive(arg0._rankItems, false)
	end

	setActive(arg0._rankEmpty, #arg1 == 0)
	setActive(arg0._rankImg, #arg1 > 0)
end

function var0.setRankItemData(arg0, arg1, arg2, arg3)
	local var0 = arg2.name
	local var1 = arg2.player_id
	local var2 = arg2.position
	local var3 = arg2.score
	local var4 = arg2.time_data
	local var5 = getProxy(PlayerProxy):isSelf(var1)

	setText(findTF(arg1, "nameText"), var0)
	arg0:setChildVisible(findTF(arg1, "bg"), false)
	arg0:setChildVisible(findTF(arg1, "rank"), false)

	if arg3 <= 3 then
		setActive(findTF(arg1, "bg/" .. arg3), true)
		setActive(findTF(arg1, "rank/" .. arg3), true)
	elseif var5 then
		setActive(findTF(arg1, "bg/me"), true)
		setActive(findTF(arg1, "rank/count"), true)
	else
		setActive(findTF(arg1, "bg/other"), true)
		setActive(findTF(arg1, "rank/count"), true)
	end

	setText(findTF(arg1, "rank/count"), tostring(arg3))
	setText(findTF(arg1, "score"), tostring(var3))
	setText(findTF(arg1, "time"), tostring(var4))
	setActive(findTF(arg1, "imgMy"), var5)
end

function var0.setChildVisible(arg0, arg1, arg2)
	for iter0 = 1, arg1.childCount do
		local var0 = arg1:GetChild(iter0 - 1)

		setActive(var0, arg2)
	end
end

function var0.showRank(arg0, arg1)
	if arg1 then
		arg0:getRankData()
	end

	setActive(arg0.rankUI, arg1)
end

function var0.updateSettlementUI(arg0)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = var1.scoreNum
	local var1 = math.floor(var1.gameDragTime)
	local var2 = getProxy(MiniGameProxy):GetHighScore(var1.game_id)
	local var3 = var2 and #var2 > 0 and var2[1] or 0
	local var4 = var2 and #var2 > 1 and var2[2] or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var3 < var0)

	if var0 > 0 and var3 < var0 then
		arg0._event:emit(PipeGameEvent.STORE_SERVER, {
			var0,
			var1
		})
	elseif var0 > 0 and var0 == var3 and var4 < var1 then
		arg0._event:emit(PipeGameEvent.STORE_SERVER, {
			var0,
			var1
		})
	end

	local var5 = findTF(arg0.settlementUI, "ad/highText")
	local var6 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var6, var0)
	setText(var5, var1)
	arg0._event:emit(PipeGameEvent.SUBMIT_GAME_SUCCESS)
end

function var0.backPressed(arg0)
	if isActive(arg0.pauseUI) then
		arg0:resumeGame()
		arg0._event:emit(PipeGameEvent.PAUSE_GAME, false)
	elseif isActive(arg0.leaveUI) then
		arg0:resumeGame()
		arg0._event:emit(PipeGameEvent.LEVEL_GAME, false)
	elseif not isActive(arg0.pauseUI) and not isActive(arg0.pauseUI) then
		if not var1.startSettlement then
			arg0:popPauseUI()
			arg0._event:emit(PipeGameEvent.PAUSE_GAME, true)
		end
	else
		arg0:resumeGame()
	end
end

function var0.resumeGame(arg0)
	setActive(arg0.leaveUI, false)
	setActive(arg0.pauseUI, false)
end

function var0.popLeaveUI(arg0)
	if isActive(arg0.pauseUI) then
		setActive(arg0.pauseUI, false)
	end

	setActive(arg0.leaveUI, true)
end

function var0.popPauseUI(arg0)
	if isActive(arg0.leaveUI) then
		setActive(arg0.leaveUI, false)
	end

	setActive(arg0.pauseUI, true)
end

function var0.updateGameUI(arg0, arg1)
	setText(arg0.scoreTf, arg1.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg1.gameTime))
end

function var0.readyStart(arg0)
	arg0:popCountUI(true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1.SFX_COUNT_DOWN)
end

function var0.popCountUI(arg0, arg1)
	setActive(arg0.countUI, arg1)
end

function var0.popSettlementUI(arg0, arg1)
	setActive(arg0.settlementUI, arg1)
end

function var0.clearUI(arg0)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
end

return var0
