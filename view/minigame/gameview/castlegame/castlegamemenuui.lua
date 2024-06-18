local var0_0 = class("CastleGameMenuUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.menuUI = findTF(arg0_1._tf, "ui/menuUI")
	arg0_1.battleScrollRect = GetComponent(findTF(arg0_1.menuUI, "battList"), typeof(ScrollRect))
	arg0_1.totalTimes = CastleGameVo.total_times
	arg0_1.battleItems = {}
	arg0_1.dropItems = {}

	onButton(arg0_1._event, findTF(arg0_1.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_2 = arg0_1.battleScrollRect.normalizedPosition.y + 1 / (arg0_1.totalTimes - 4)

		if var0_2 > 1 then
			var0_2 = 1
		end

		scrollTo(arg0_1.battleScrollRect, 0, var0_2)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_3 = arg0_1.battleScrollRect.normalizedPosition.y - 1 / (arg0_1.totalTimes - 4)

		if var0_3 < 0 then
			var0_3 = 0
		end

		scrollTo(arg0_1.battleScrollRect, 0, var0_3)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnBack"), function()
		arg0_1._event:emit(BeachGuardGameView.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnRule"), function()
		arg0_1._event:emit(BeachGuardGameView.SHOW_RULE)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnStart"), function()
		arg0_1._event:emit(BeachGuardGameView.READY_START)
	end, SFX_CANCEL)

	local var0_1 = findTF(arg0_1.menuUI, "tplBattleItem")
	local var1_1 = CastleGameVo.drop

	for iter0_1 = 1, 7 do
		local var2_1 = tf(instantiate(var0_1))

		var2_1.name = "battleItem_" .. iter0_1

		setParent(var2_1, findTF(arg0_1.menuUI, "battList/Viewport/Content"))

		local var3_1 = iter0_1

		GetSpriteFromAtlasAsync(CastleGameVo.ui_atlas, "battleDesc" .. var3_1, function(arg0_7)
			if arg0_7 then
				setImageSprite(findTF(var2_1, "state_open/desc"), arg0_7, true)
				setImageSprite(findTF(var2_1, "state_clear/desc"), arg0_7, true)
				setImageSprite(findTF(var2_1, "state_current/desc"), arg0_7, true)
				setImageSprite(findTF(var2_1, "state_closed/desc"), arg0_7, true)
			end
		end)

		local var4_1 = findTF(var2_1, "icon")
		local var5_1 = {
			type = var1_1[iter0_1][1],
			id = var1_1[iter0_1][2],
			amount = var1_1[iter0_1][3]
		}

		updateDrop(var4_1, var5_1)
		onButton(arg0_1._event, var4_1, function()
			arg0_1._event:emit(BaseUI.ON_DROP, var5_1)
		end, SFX_PANEL)
		table.insert(arg0_1.dropItems, var4_1)
		setActive(var2_1, true)
		table.insert(arg0_1.battleItems, var2_1)
	end
end

function var0_0.show(arg0_9, arg1_9)
	setActive(arg0_9.menuUI, arg1_9)
end

function var0_0.update(arg0_10, arg1_10)
	local var0_10 = arg0_10:getGameUsedTimes(arg1_10)
	local var1_10 = arg0_10:getGameTimes(arg1_10)

	for iter0_10 = 1, #arg0_10.battleItems do
		setActive(findTF(arg0_10.battleItems[iter0_10], "state_open"), false)
		setActive(findTF(arg0_10.battleItems[iter0_10], "state_closed"), false)
		setActive(findTF(arg0_10.battleItems[iter0_10], "state_clear"), false)
		setActive(findTF(arg0_10.battleItems[iter0_10], "state_current"), false)

		if iter0_10 <= var0_10 then
			SetParent(arg0_10.dropItems[iter0_10], findTF(arg0_10.battleItems[iter0_10], "state_clear/icon"))
			setActive(arg0_10.dropItems[iter0_10], true)
			setActive(findTF(arg0_10.battleItems[iter0_10], "state_clear"), true)
		elseif iter0_10 == var0_10 + 1 and var1_10 >= 1 then
			setActive(findTF(arg0_10.battleItems[iter0_10], "state_current"), true)
			SetParent(arg0_10.dropItems[iter0_10], findTF(arg0_10.battleItems[iter0_10], "state_current/icon"))
			setActive(arg0_10.dropItems[iter0_10], true)
		elseif var0_10 < iter0_10 and iter0_10 <= var0_10 + var1_10 then
			setActive(findTF(arg0_10.battleItems[iter0_10], "state_open"), true)
			SetParent(arg0_10.dropItems[iter0_10], findTF(arg0_10.battleItems[iter0_10], "state_open/icon"))
			setActive(arg0_10.dropItems[iter0_10], true)
		else
			setActive(findTF(arg0_10.battleItems[iter0_10], "state_closed"), true)
			SetParent(arg0_10.dropItems[iter0_10], findTF(arg0_10.battleItems[iter0_10], "state_closed/icon"))
			setActive(arg0_10.dropItems[iter0_10], true)
		end
	end

	local var2_10 = 1 - (var0_10 - 3 < 0 and 0 or var0_10 - 3) / (arg0_10.totalTimes - 4)

	if var2_10 > 1 then
		var2_10 = 1
	end

	scrollTo(arg0_10.battleScrollRect, 0, var2_10)
	setActive(findTF(arg0_10.menuUI, "btnStart/tip"), var1_10 > 0)
	arg0_10:CheckGet(arg1_10)
end

function var0_0.CheckGet(arg0_11, arg1_11)
	setActive(findTF(arg0_11.menuUI, "got"), false)

	local var0_11 = arg0_11:getUltimate(arg1_11)

	if var0_11 and var0_11 ~= 0 then
		setActive(findTF(arg0_11.menuUI, "got"), true)
	end

	if var0_11 == 0 then
		if CastleGameVo.total_times > arg0_11:getGameUsedTimes(arg1_11) then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg1_11.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_11.menuUI, "got"), true)
	end
end

function var0_0.getGameTimes(arg0_12, arg1_12)
	return arg1_12.count
end

function var0_0.getGameUsedTimes(arg0_13, arg1_13)
	return arg1_13.usedtime
end

function var0_0.getUltimate(arg0_14, arg1_14)
	return arg1_14.ultimate
end

return var0_0
