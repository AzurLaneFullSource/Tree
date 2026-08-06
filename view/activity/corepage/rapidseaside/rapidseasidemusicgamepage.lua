local var0_0 = class("RapidSeasideMusicGamePage", import("view.activity.CorePage.CoreActivityPage"))
local var1_0 = 88
local var2_0 = "temp"

function var0_0.OnInit(arg0_1)
	arg0_1.mgHubData = getProxy(MiniGameProxy):GetHubByGameId(var1_0)
	arg0_1.drops = pg.mini_game[var1_0].simple_config_data.drop_ids
	arg0_1.totalTimes = #arg0_1.drops
	arg0_1.useTimes = arg0_1.mgHubData.usedtime
	arg0_1.gameTimes = arg0_1.mgHubData.count
	arg0_1.highestScore = arg0_1._tf:Find("ad/record/img/Text")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.btnStart = findTF(arg0_2._tf, "ad/list/start")
	arg0_2.btnRule = findTF(arg0_2._tf, "ad/list/rule")
	arg0_2.btnRank = findTF(arg0_2._tf, "ad/list/rank")

	setText(findTF(arg0_2.btnStart, "Text"), i18n("beat_game_go"))
	setText(findTF(arg0_2.btnRule, "Text"), i18n("beat_game_rule"))
	setText(findTF(arg0_2.btnRank, "Text"), i18n("beat_game_rank"))
	GetComponent(findTF(arg0_2._tf, "ad/desc"), typeof(Image)):SetNativeSize()

	arg0_2.awardsTf = findTF(arg0_2._tf, "ad/awards")
	arg0_2.awardContent = findTF(arg0_2._tf, "ad/awards/content")
	arg0_2.awardsRect = GetComponent(arg0_2.awardsTf, typeof(ScrollRect))
	arg0_2.itemTpl = findTF(arg0_2._tf, "ad/awards/content/itemTpl")

	setActive(arg0_2.itemTpl, false)

	for iter0_2 = 1, #arg0_2.drops do
		local var0_2 = tf(Instantiate(arg0_2.itemTpl))

		setParent(var0_2, arg0_2.awardContent)
		setActive(var0_2, true)

		local var1_2 = arg0_2.drops[iter0_2]
		local var2_2 = {
			type = var1_2[1],
			id = var1_2[2],
			count = var1_2[3]
		}
		local var3_2 = findTF(var0_2, "ad/IconTpl")

		updateDrop(var3_2, var2_2)
		onButton(arg0_2, var0_2, function()
			arg0_2:emit(BaseUI.ON_DROP, var2_2)
		end, SFX_PANEL)
		setText(findTF(var0_2, "ad/day"), "DAY" .. iter0_2)
		setActive(findTF(var0_2, "ad/lock"), iter0_2 > arg0_2.useTimes + arg0_2.gameTimes)
		setActive(findTF(var0_2, "ad/got"), iter0_2 <= arg0_2.useTimes)
	end

	onButton(arg0_2, arg0_2.btnStart, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var1_0)
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.btnRule, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.musicbeat_minigame_help.tip
		})
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.btnRank, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, {
			rank = true,
			id = var1_0
		})
	end, SFX_CONFIRM)

	local var4_2 = 0

	if arg0_2.mgHubData.highScores[var1_0] and arg0_2.mgHubData.highScores[var1_0][1] then
		var4_2 = arg0_2.mgHubData.highScores[var1_0][1]
	end

	setText(arg0_2.highestScore, var4_2)

	local var5_2 = arg0_2.totalTimes - 7 < 0 and 0 or arg0_2.totalTimes - 7

	scrollTo(arg0_2.awardsRect, 1 - var5_2 / (arg0_2.totalTimes - 7), 0)
end

function var0_0.willExit(arg0_7)
	return
end

return var0_0
