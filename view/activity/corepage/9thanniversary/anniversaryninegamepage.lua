local var0_0 = class("AnniversaryNineGamePage", import("view.activity.CorePage.CoreActivityPage"))
local var1_0 = 84

function var0_0.OnInit(arg0_1)
	arg0_1.mgHubData = getProxy(MiniGameProxy):GetHubByGameId(var1_0)
	arg0_1.drops = pg.mini_game[var1_0].simple_config_data.drop_ids
	arg0_1.totalTimes = #arg0_1.drops
	arg0_1.useTimes = arg0_1.mgHubData.usedtime
	arg0_1.gameTimes = arg0_1.mgHubData.count
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.highScoreText = findTF(arg0_2._tf, "ad/high/text")
	arg0_2.btnRule = findTF(arg0_2._tf, "ad/rule")
	arg0_2.btnRank = findTF(arg0_2._tf, "ad/rank")

	onButton(arg0_2, arg0_2.btnRank, function()
		arg0_2:getRankData(var1_0, function(arg0_4)
			arg0_2:UpdateRankData(arg0_4)
		end)
		arg0_2:PopRankUI(true)
	end, SFX_CANCEL)
	arg0_2:initRankUI()
	setText(findTF(arg0_2.btnRule, "text"), i18n("pac_game_rule_btn"))
	onButton(arg0_2, arg0_2.btnRule, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.sort_minigame_help.tip
		})
	end, SFX_CANCEL)

	arg0_2.btnStart = findTF(arg0_2._tf, "ad/start")

	onButton(arg0_2, arg0_2.btnStart, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var1_0)
	end, SFX_CANCEL)

	arg0_2.battleItems = {}
	arg0_2._tplBattleItem = findTF(arg0_2._tf, "ad/awards/Viewport/Content/item_tpl")

	setActive(arg0_2._tplBattleItem, false)

	local var0_2 = arg0_2.drops

	for iter0_2 = 1, 7 do
		local var1_2 = iter0_2
		local var2_2 = tf(instantiate(arg0_2._tplBattleItem))

		var2_2.name = "award_" .. iter0_2

		setParent(var2_2, findTF(arg0_2._tf, "ad/awards/Viewport/Content"))

		local var3_2 = iter0_2

		setText(findTF(var2_2, "ad/desc"), "DAY" .. var3_2)

		local var4_2 = findTF(var2_2, "ad/iconMask/icon")
		local var5_2 = {
			type = var0_2[iter0_2][1],
			id = var0_2[iter0_2][2],
			count = var0_2[iter0_2][3]
		}

		updateDrop(var4_2, var5_2)
		onButton(arg0_2, var4_2, function()
			arg0_2:emit(BaseUI.ON_DROP, var5_2)
		end, SFX_PANEL)
		setActive(var2_2, true)
		table.insert(arg0_2.battleItems, var2_2)
	end
end

function var0_0.OnUpdateFlush(arg0_8)
	for iter0_8 = 1, 7 do
		local var0_8 = findTF(arg0_8.battleItems[iter0_8], "ad/lock")
		local var1_8 = findTF(arg0_8.battleItems[iter0_8], "ad/got")

		setActive(var0_8, false)
		setActive(var1_8, false)

		if iter0_8 <= arg0_8.useTimes then
			setActive(var1_8, true)
		elseif iter0_8 == arg0_8.useTimes + 1 and arg0_8.gameTimes >= 1 then
			-- block empty
		elseif iter0_8 > arg0_8.useTimes and iter0_8 <= arg0_8.useTimes + arg0_8.gameTimes then
			-- block empty
		else
			setActive(var0_8, true)
		end
	end

	local var2_8 = getProxy(MiniGameProxy):GetHighScore(var1_0)
	local var3_8 = var2_8 and #var2_8 > 0 and var2_8[1] or 0

	setText(arg0_8.highScoreText, tostring(var3_8))

	local var4_8 = arg0_8.coreActivityUI:GetActivityIdByPageClass("AnniversaryNineInvitationPage")
	local var5_8 = var4_8 and getProxy(ActivityProxy):getActivityById(var4_8)

	if var5_8 and not var5_8:isEnd() then
		updateActivityTaskStatus(var5_8)
	end
end

function var0_0.initRankUI(arg0_9)
	arg0_9.rankUI = findTF(arg0_9._tf, "pop/RankUI")

	arg0_9:PopRankUI(false)

	arg0_9._rankImg = findTF(arg0_9.rankUI, "ad/img")
	arg0_9._rankBtnClose = findTF(arg0_9.rankUI, "ad/btnClose")
	arg0_9._rankContent = findTF(arg0_9.rankUI, "ad/list/content")
	arg0_9._rankItemTpl = findTF(arg0_9.rankUI, "ad/list/content/itemTpl")
	arg0_9._rankEmpty = findTF(arg0_9.rankUI, "ad/empty")
	arg0_9._rankDesc = findTF(arg0_9.rankUI, "ad/desc")
	arg0_9._rankItems = {}

	setActive(arg0_9._rankItemTpl, false)
	onButton(arg0_9._event, findTF(arg0_9.rankUI, "ad/close"), function()
		arg0_9:PopRankUI(false)
	end, SFX_CANCEL)
	onButton(arg0_9._event, arg0_9._rankBtnClose, function()
		arg0_9:PopRankUI(false)
	end, SFX_CANCEL)
	setText(arg0_9._rankDesc, i18n("pipe_minigame_rank"))
	setText(findTF(arg0_9.rankUI, "ad/bg/bg_high/text"), i18n("series_enemy_reward_tip4"))
end

function var0_0.UpdateRankData(arg0_12, arg1_12)
	for iter0_12 = 1, #arg1_12 do
		local var0_12

		if iter0_12 > #arg0_12._rankItems then
			local var1_12 = tf(instantiate(arg0_12._rankItemTpl))

			setActive(var1_12, false)
			setParent(var1_12, arg0_12._rankContent)
			table.insert(arg0_12._rankItems, var1_12)
		end

		local var2_12 = arg0_12._rankItems[iter0_12]

		arg0_12:SetRankItemData(var2_12, arg1_12[iter0_12], iter0_12)
		setActive(var2_12, true)
	end

	for iter1_12 = #arg1_12 + 1, #arg0_12._rankItems do
		setActive(arg0_12._rankItems, false)
	end

	setActive(arg0_12._rankEmpty, #arg1_12 == 0)
	setActive(arg0_12._rankImg, #arg1_12 > 0)
end

function var0_0.SetRankItemData(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg2_13.name
	local var1_13 = arg2_13.player_id
	local var2_13 = arg2_13.position
	local var3_13 = arg2_13.score
	local var4_13 = arg2_13.time_data
	local var5_13 = getProxy(PlayerProxy):isSelf(var1_13)

	setText(findTF(arg1_13, "nameText"), var0_13)
	arg0_13:setChildVisible(findTF(arg1_13, "bg"), false)
	arg0_13:setChildVisible(findTF(arg1_13, "rank"), false)

	if arg3_13 <= 3 then
		setActive(findTF(arg1_13, "bg/" .. arg3_13), true)
		setActive(findTF(arg1_13, "rank/" .. arg3_13), true)
	elseif var5_13 then
		setActive(findTF(arg1_13, "bg/me"), true)
		setActive(findTF(arg1_13, "rank/count"), true)
	else
		setActive(findTF(arg1_13, "bg/other"), true)
		setActive(findTF(arg1_13, "rank/count"), true)
	end

	setText(findTF(arg1_13, "rank/count"), tostring(arg3_13))
	setText(findTF(arg1_13, "score"), tostring(var3_13))
	setActive(findTF(arg1_13, "imgMy"), var5_13)
end

function var0_0.PopRankUI(arg0_14, arg1_14)
	setActive(arg0_14.rankUI, arg1_14)
end

function var0_0.getRankData(arg0_15, arg1_15, arg2_15)
	pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
		id = arg1_15,
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

			if arg2_15 then
				arg2_15(var0_16)
			end
		end
	})
end

function var0_0.setChildVisible(arg0_18, arg1_18, arg2_18)
	for iter0_18 = 1, arg1_18.childCount do
		local var0_18 = arg1_18:GetChild(iter0_18 - 1)

		setActive(var0_18, arg2_18)
	end
end

function var0_0.willExit(arg0_19)
	return
end

return var0_0
