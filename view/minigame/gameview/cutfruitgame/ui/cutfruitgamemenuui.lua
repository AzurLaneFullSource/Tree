local var0_0 = class("CutFruitGameMenuUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1.totalTimes = arg0_1._gameVo:GetTotalTimes()
	arg0_1.battleItems = {}

	arg0_1:initUI()
	setText(findTF(arg0_1.btnStart, "text"), i18n("pac_game_start_btn"))
	setText(findTF(arg0_1.btnRule, "text"), i18n("pac_game_rule_btn"))
end

function var0_0.initUI(arg0_2)
	arg0_2.menuUI = findTF(arg0_2._tf, "ui/menuUI")
	arg0_2.highScore = findTF(arg0_2.menuUI, "highScore/text")
	arg0_2.battleScrollRect = GetComponent(findTF(arg0_2.menuUI, "battList"), typeof(ScrollRect))

	onButton(arg0_2._event, findTF(arg0_2.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_3 = arg0_2.battleScrollRect.normalizedPosition.y + 1 / (arg0_2.totalTimes - 4)

		if var0_3 > 1 then
			var0_3 = 1
		end

		scrollTo(arg0_2.battleScrollRect, 0, var0_3)
	end, SFX_CANCEL)
	onButton(arg0_2._event, findTF(arg0_2.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_4 = arg0_2.battleScrollRect.normalizedPosition.y - 1 / (arg0_2.totalTimes - 4)

		if var0_4 < 0 then
			var0_4 = 0
		end

		scrollTo(arg0_2.battleScrollRect, 0, var0_4)
	end, SFX_CANCEL)
	onButton(arg0_2._event, findTF(arg0_2.menuUI, "btnBack"), function()
		arg0_2._event:emit(SimpleMGEvent.CLOSE_GAME)
	end, SFX_CANCEL)

	arg0_2.btnRule = findTF(arg0_2.menuUI, "btnRule")

	onButton(arg0_2._event, arg0_2.btnRule, function()
		arg0_2._event:emit(SimpleMGEvent.SHOW_RULE, true)
	end, SFX_CANCEL)

	arg0_2.btnStart = findTF(arg0_2.menuUI, "btnStart")

	onButton(arg0_2._event, arg0_2.btnStart, function()
		arg0_2._event:emit(SimpleMGEvent.READY_START)
	end, SFX_CANCEL)

	arg0_2.btnRank = findTF(arg0_2.menuUI, "btnRank")

	onButton(arg0_2._event, arg0_2.btnRank, function()
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_2._gameVo:GetHubId(),
			cmd = MiniGameOPCommand.CMD_SPECIAL_TRACK,
			args1 = {
				arg0_2._gameVo:GetGameId(),
				103
			}
		})
		arg0_2._event:emit(SimpleMGEvent.SHOW_RANK)
	end, SFX_CANCEL)

	arg0_2.btnHome = findTF(arg0_2.menuUI, "btnHome")

	onButton(arg0_2._event, arg0_2.btnHome, function()
		arg0_2._event:emit(SimpleMGEvent.ON_HOME)
	end, SFX_CANCEL)

	arg0_2._tplBattleItem = findTF(arg0_2.menuUI, "battList/Viewport/Content/tplBattleItem")

	setActive(arg0_2._tplBattleItem, false)

	local var0_2 = arg0_2._gameVo:GetDrop()

	for iter0_2 = 1, 7 do
		local var1_2 = iter0_2
		local var2_2 = tf(instantiate(arg0_2._tplBattleItem))

		var2_2.name = "battleItem_" .. iter0_2

		setParent(var2_2, findTF(arg0_2.menuUI, "battList/Viewport/Content"))
		setText(findTF(var2_2, "ad/desc"), i18n("which_day_2", var1_2))

		local var3_2 = findTF(var2_2, "ad/iconMask/icon")
		local var4_2 = {
			type = var0_2[iter0_2][1],
			id = var0_2[iter0_2][2],
			count = var0_2[iter0_2][3]
		}

		updateDrop(var3_2, var4_2)
		onButton(arg0_2._event, var3_2, function()
			arg0_2._event:emit(BaseUI.ON_DROP, var4_2)
		end, SFX_PANEL)
		setActive(var2_2, true)
		table.insert(arg0_2.battleItems, var2_2)
	end
end

function var0_0.Show(arg0_11, arg1_11)
	setActive(arg0_11.menuUI, arg1_11)
end

function var0_0.SetGameRoomUI(arg0_12, arg1_12)
	if arg1_12 then
		setActive(findTF(arg0_12.menuUI, "lastTimes"), false)
		setActive(findTF(arg0_12.menuUI, "btnRank"), false)
	end
end

function var0_0.Update(arg0_13)
	local var0_13 = arg0_13._gameVo:GetGameUseTimes()
	local var1_13 = arg0_13._gameVo:GetGameTimes()

	for iter0_13 = 1, 7 do
		local var2_13 = findTF(arg0_13.battleItems[iter0_13], "ad/lock")
		local var3_13 = findTF(arg0_13.battleItems[iter0_13], "ad/got")

		setActive(var2_13, false)
		setActive(var3_13, false)

		if iter0_13 <= var0_13 then
			setActive(var3_13, true)
		elseif iter0_13 == var0_13 + 1 and var1_13 >= 1 then
			-- block empty
		elseif var0_13 < iter0_13 and iter0_13 <= var0_13 + var1_13 then
			-- block empty
		else
			setActive(var2_13, true)
		end
	end

	local var4_13 = 1 - (var0_13 - 3 < 0 and 0 or var0_13 - 3) / (arg0_13.totalTimes - 4)

	if var4_13 > 1 then
		var4_13 = 1
	end

	scrollTo(arg0_13.battleScrollRect, 0, var4_13)

	local var5_13 = getProxy(MiniGameProxy):GetHighScore(arg0_13._gameVo:GetGameId())
	local var6_13 = var5_13 and #var5_13 > 0 and var5_13[1] or 0

	setText(arg0_13.highScore, i18n("pac_game_high_score_tip", var6_13))
end

function var0_0.CheckGet(arg0_14)
	setActive(findTF(arg0_14.menuUI, "got"), false)

	local var0_14 = arg0_14._gameVo:GetUltimate()

	if var0_14 and var0_14 ~= 0 then
		setActive(findTF(arg0_14.menuUI, "got"), true)
	end

	if var0_14 == 0 then
		if arg0_14._gameVo:GetTotalTimes() > arg0_14:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_14._gameVo:GetHubId(),
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_14.menuUI, "got"), true)
	end
end

return var0_0
