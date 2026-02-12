local var0_0 = class("PacGameMenuUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1.totalTimes = arg0_1._gameVo:GetTotalTimes()
	arg0_1.battleItems = {}

	arg0_1:initUI()
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

	setText(findTF(arg0_2.btnRule, "text"), i18n("pac_game_rule_btn"))
	onButton(arg0_2._event, arg0_2.btnRule, function()
		arg0_2._event:emit(SimpleMGEvent.SHOW_RULE, true)
	end, SFX_CANCEL)

	arg0_2.btnStart = findTF(arg0_2.menuUI, "btnStart")

	setText(findTF(arg0_2.btnStart, "text"), i18n("pac_game_start_btn"))
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

		local var3_2 = iter0_2

		setText(findTF(var2_2, "ad/desc"), i18n("which_day_2", var3_2))

		local var4_2 = findTF(var2_2, "ad/iconMask/icon")
		local var5_2 = {
			type = var0_2[iter0_2][1],
			id = var0_2[iter0_2][2],
			count = var0_2[iter0_2][3]
		}

		updateDrop(var4_2, var5_2)
		onButton(arg0_2._event, var4_2, function()
			arg0_2._event:emit(BaseUI.ON_DROP, var5_2)
		end, SFX_PANEL)
		setActive(var2_2, true)
		table.insert(arg0_2.battleItems, var2_2)
	end

	setActive(findTF(arg0_2.menuUI, "editor"), PacGameConst.editor_mode and true or false)

	if PacGameConst.editor_mode then
		onButton(arg0_2._event, findTF(arg0_2.menuUI, "editor"), function()
			arg0_2._event:emit(SimpleMGEvent.READY_START, {
				editor = true
			})
		end)
	end
end

function var0_0.Show(arg0_12, arg1_12)
	setActive(arg0_12.menuUI, arg1_12)
end

function var0_0.SetGameRoomUI(arg0_13, arg1_13)
	if arg1_13 then
		setActive(findTF(arg0_13.menuUI, "lastTimes"), false)
		setActive(findTF(arg0_13.menuUI, "btnRank"), false)
	end
end

function var0_0.Update(arg0_14)
	local var0_14 = arg0_14._gameVo:GetGameUseTimes()
	local var1_14 = arg0_14._gameVo:GetGameTimes()

	for iter0_14 = 1, 7 do
		local var2_14 = findTF(arg0_14.battleItems[iter0_14], "ad/lock")
		local var3_14 = findTF(arg0_14.battleItems[iter0_14], "ad/got")

		setActive(var2_14, false)
		setActive(var3_14, false)

		if iter0_14 <= var0_14 then
			setActive(var3_14, true)
		elseif iter0_14 == var0_14 + 1 and var1_14 >= 1 then
			-- block empty
		elseif var0_14 < iter0_14 and iter0_14 <= var0_14 + var1_14 then
			-- block empty
		else
			setActive(var2_14, true)
		end
	end

	local var4_14 = 1 - (var0_14 - 3 < 0 and 0 or var0_14 - 3) / (arg0_14.totalTimes - 4)

	if var4_14 > 1 then
		var4_14 = 1
	end

	scrollTo(arg0_14.battleScrollRect, 0, var4_14)

	local var5_14 = getProxy(MiniGameProxy):GetHighScore(arg0_14._gameVo:GetGameId())
	local var6_14 = var5_14 and #var5_14 > 0 and var5_14[1] or 0

	setText(arg0_14.highScore, i18n("pac_game_high_score_tip", var6_14))
end

function var0_0.CheckGet(arg0_15)
	setActive(findTF(arg0_15.menuUI, "got"), false)

	local var0_15 = arg0_15._gameVo:GetUltimate()

	if var0_15 and var0_15 ~= 0 then
		setActive(findTF(arg0_15.menuUI, "got"), true)
	end

	if var0_15 == 0 then
		if arg0_15._gameVo:GetTotalTimes() > arg0_15:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_15._gameVo:GetHubId(),
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_15.menuUI, "got"), true)
	end
end

return var0_0
