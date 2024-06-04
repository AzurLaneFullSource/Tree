local var0 = class("CastleGameMenuUI")

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	arg0.menuUI = findTF(arg0._tf, "ui/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = CastleGameVo.total_times
	arg0.battleItems = {}
	arg0.dropItems = {}

	onButton(arg0._event, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "btnBack"), function()
		arg0._event:emit(BeachGuardGameView.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "btnRule"), function()
		arg0._event:emit(BeachGuardGameView.SHOW_RULE)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "btnStart"), function()
		arg0._event:emit(BeachGuardGameView.READY_START)
	end, SFX_CANCEL)

	local var0 = findTF(arg0.menuUI, "tplBattleItem")
	local var1 = CastleGameVo.drop

	for iter0 = 1, 7 do
		local var2 = tf(instantiate(var0))

		var2.name = "battleItem_" .. iter0

		setParent(var2, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var3 = iter0

		GetSpriteFromAtlasAsync(CastleGameVo.ui_atlas, "battleDesc" .. var3, function(arg0)
			if arg0 then
				setImageSprite(findTF(var2, "state_open/desc"), arg0, true)
				setImageSprite(findTF(var2, "state_clear/desc"), arg0, true)
				setImageSprite(findTF(var2, "state_current/desc"), arg0, true)
				setImageSprite(findTF(var2, "state_closed/desc"), arg0, true)
			end
		end)

		local var4 = findTF(var2, "icon")
		local var5 = {
			type = var1[iter0][1],
			id = var1[iter0][2],
			amount = var1[iter0][3]
		}

		updateDrop(var4, var5)
		onButton(arg0._event, var4, function()
			arg0._event:emit(BaseUI.ON_DROP, var5)
		end, SFX_PANEL)
		table.insert(arg0.dropItems, var4)
		setActive(var2, true)
		table.insert(arg0.battleItems, var2)
	end
end

function var0.show(arg0, arg1)
	setActive(arg0.menuUI, arg1)
end

function var0.update(arg0, arg1)
	local var0 = arg0:getGameUsedTimes(arg1)
	local var1 = arg0:getGameTimes(arg1)

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_clear/icon"))
			setActive(arg0.dropItems[iter0], true)
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_current/icon"))
			setActive(arg0.dropItems[iter0], true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_open/icon"))
			setActive(arg0.dropItems[iter0], true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_closed/icon"))
			setActive(arg0.dropItems[iter0], true)
		end
	end

	local var2 = 1 - (var0 - 3 < 0 and 0 or var0 - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
	arg0:CheckGet(arg1)
end

function var0.CheckGet(arg0, arg1)
	setActive(findTF(arg0.menuUI, "got"), false)

	local var0 = arg0:getUltimate(arg1)

	if var0 and var0 ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if var0 == 0 then
		if CastleGameVo.total_times > arg0:getGameUsedTimes(arg1) then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg1.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.getGameTimes(arg0, arg1)
	return arg1.count
end

function var0.getGameUsedTimes(arg0, arg1)
	return arg1.usedtime
end

function var0.getUltimate(arg0, arg1)
	return arg1.ultimate
end

return var0
