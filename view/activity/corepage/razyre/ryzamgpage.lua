local var0_0 = class("RyzaMGPage", import("view.activity.CorePage.CoreActivityPage"))
local var1_0 = 43
local var2_0 = "temp"

function var0_0.OnInit(arg0_1)
	arg0_1.mgHubData = getProxy(MiniGameProxy):GetHubByGameId(var1_0)
	arg0_1.drops = pg.mini_game[var1_0].simple_config_data.drop_ids
	arg0_1.totalTimes = #arg0_1.drops
	arg0_1.useTimes = arg0_1.mgHubData.usedtime
	arg0_1.gameTimes = arg0_1.mgHubData.count
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.btnStart = findTF(arg0_2._tf, "ad/start")
	arg0_2.btnRule = findTF(arg0_2._tf, "ad/rule")
	arg0_2.moveLeft = findTF(arg0_2._tf, "ad/moveLeft")
	arg0_2.moveRight = findTF(arg0_2._tf, "ad/moveRight")
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
		GetSpriteFromAtlasAsync("ui/ryzamgpage_atlas", "day_" .. iter0_2, function(arg0_4)
			setImageSprite(findTF(var0_2, "ad/complete"), arg0_4, true)
		end)
		GetSpriteFromAtlasAsync("ui/ryzamgpage_atlas", "day_c_" .. iter0_2, function(arg0_5)
			setImageSprite(findTF(var0_2, "ad/open"), arg0_5, true)
		end)
		setActive(findTF(var0_2, "ad/open"), iter0_2 > arg0_2.useTimes)
		setActive(findTF(var0_2, "ad/complete"), iter0_2 <= arg0_2.useTimes)
		setActive(findTF(var0_2, "ad/got"), iter0_2 <= arg0_2.useTimes)
	end

	onButton(arg0_2, arg0_2.btnStart, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var1_0)
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.btnRule, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ryza_mini_game.tip
		})
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.moveRight, function()
		local var0_8 = arg0_2.awardsRect.normalizedPosition.x + 1 / (arg0_2.totalTimes - 4)

		if var0_8 <= 0 then
			var0_8 = 0
		end

		scrollTo(arg0_2.awardsRect, var0_8, 0)
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.moveLeft, function()
		local var0_9 = arg0_2.awardsRect.normalizedPosition.x - 1 / (arg0_2.totalTimes - 4)

		if var0_9 > 1 then
			var0_9 = 1
		end

		scrollTo(arg0_2.awardsRect, var0_9, 0)
	end, SFX_CONFIRM)

	local var4_2 = arg0_2.totalTimes - 4 < 0 and 0 or arg0_2.totalTimes - 4

	scrollTo(arg0_2.awardsRect, 1 - var4_2 / (arg0_2.totalTimes - 4), 0)
end

function var0_0.willExit(arg0_10)
	return
end

return var0_0
