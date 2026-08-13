local var0_0 = class("RapidSeasideGamePage", import("view.activity.CorePage.CoreActivityPage"))
local var1_0 = 89

function var0_0.OnInit(arg0_1)
	arg0_1.mgHubData = getProxy(MiniGameProxy):GetHubByGameId(var1_0)
	arg0_1.drops = pg.mini_game[var1_0].simple_config_data.drop_ids
	arg0_1.totalTimes = #arg0_1.drops
	arg0_1.useTimes = arg0_1.mgHubData.usedtime
	arg0_1.gameTimes = arg0_1.mgHubData.count
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.btnRule = findTF(arg0_2._tf, "ad/rule")

	onButton(arg0_2, arg0_2.btnRule, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.crossroad_minigame_help.tip
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

function var0_0.OnUpdateFlush(arg0_6)
	for iter0_6 = 1, 7 do
		local var0_6 = findTF(arg0_6.battleItems[iter0_6], "ad/lock")
		local var1_6 = findTF(arg0_6.battleItems[iter0_6], "ad/got")

		setActive(var0_6, false)
		setActive(var1_6, false)

		if iter0_6 <= arg0_6.useTimes then
			setActive(var1_6, true)
		elseif iter0_6 == arg0_6.useTimes + 1 and arg0_6.gameTimes >= 1 then
			-- block empty
		elseif iter0_6 > arg0_6.useTimes and iter0_6 <= arg0_6.useTimes + arg0_6.gameTimes then
			-- block empty
		else
			setActive(var0_6, true)
		end
	end
end

function var0_0.setChildVisible(arg0_7, arg1_7, arg2_7)
	for iter0_7 = 1, arg1_7.childCount do
		local var0_7 = arg1_7:GetChild(iter0_7 - 1)

		setActive(var0_7, arg2_7)
	end
end

function var0_0.willExit(arg0_8)
	return
end

return var0_0
