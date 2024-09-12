local var0_0 = class("TouchCakeMenuUI")
local var1_0
local var2_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	var1_0 = TouchCakeGameVo
	var2_0 = TouchCakeGameEvent
	arg0_1._event = arg2_1
	arg0_1.menuUI = findTF(arg0_1._tf, "ui/menuUI")
	arg0_1.battleScrollRect = GetComponent(findTF(arg0_1.menuUI, "battList"), typeof(ScrollRect))
	arg0_1.totalTimes = var1_0.total_times
	arg0_1.battleItems = {}
	arg0_1.dropItems = {}
	arg0_1.textLastTimes = findTF(arg0_1.menuUI, "lastTimes/desc")

	GetComponent(findTF(arg0_1.menuUI, "lastTimes/img"), typeof(Image)):SetNativeSize()

	arg0_1.btnRank = findTF(arg0_1.menuUI, "btnRank")
	arg0_1.btnHome = findTF(arg0_1.menuUI, "btnHome")
	arg0_1.imgHelp = findTF(arg0_1.menuUI, "imgHelp")

	setActive(arg0_1.imgHelp, false)
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
		arg0_1._event:emit(var2_0.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnRule"), function()
		arg0_1._event:emit(var2_0.SHOW_RULE, true)
	end, SFX_CANCEL)
	onButton(arg0_1._event, arg0_1.imgHelp, function()
		arg0_1._event:emit(var2_0.SHOW_RULE, false)
	end, SFX_CANCEL)

	arg0_1.btnStart = findTF(arg0_1.menuUI, "btnStart")

	onButton(arg0_1._event, arg0_1.btnStart, function()
		arg0_1._event:emit(var2_0.READY_START)
	end, SFX_CANCEL)
	onButton(arg0_1._event, arg0_1.btnRank, function()
		arg0_1._event:emit(var2_0.SHOW_RANK)
	end, SFX_CANCEL)
	onButton(arg0_1._event, arg0_1.btnHome, function()
		arg0_1._event:emit(var2_0.ON_HOME)
	end, SFX_CANCEL)

	local var0_1 = findTF(arg0_1.menuUI, "tplBattleItem")
	local var1_1 = var1_0.drop

	for iter0_1 = 1, 7 do
		local var2_1 = iter0_1
		local var3_1 = tf(instantiate(var0_1))

		var3_1.name = "battleItem_" .. iter0_1

		setParent(var3_1, findTF(arg0_1.menuUI, "battList/Viewport/Content"))

		local var4_1 = iter0_1
		local var5_1 = findTF(var3_1, "icon")
		local var6_1 = {
			type = var1_1[iter0_1][1],
			id = var1_1[iter0_1][2],
			amount = var1_1[iter0_1][3]
		}

		updateDrop(var5_1, var6_1)
		onButton(arg0_1._event, var5_1, function()
			arg0_1._event:emit(BaseUI.ON_DROP, var6_1)
		end, SFX_PANEL)
		table.insert(arg0_1.dropItems, var5_1)
		setActive(var3_1, true)
		table.insert(arg0_1.battleItems, var3_1)

		local var7_1 = var1_0.GetGameUseTimes()
		local var8_1 = var1_0.GetGameTimes()
	end
end

function var0_0.show(arg0_11, arg1_11)
	setActive(arg0_11.menuUI, arg1_11)
end

function var0_0.setGameRoomUI(arg0_12, arg1_12)
	if arg1_12 then
		setActive(findTF(arg0_12.menuUI, "lastTimes"), false)
		setActive(findTF(arg0_12.menuUI, "btnRank"), false)
	end
end

function var0_0.update(arg0_13, arg1_13)
	arg0_13.mgHubData = arg1_13

	local var0_13 = arg0_13:getGameUsedTimes(arg1_13)
	local var1_13 = arg0_13:getGameTimes(arg1_13)

	setActive(findTF(arg0_13.btnStart, "tip"), var1_13 > 0)
	setText(arg0_13.textLastTimes, var1_13)

	for iter0_13 = 1, 7 do
		setActive(findTF(arg0_13.battleItems[iter0_13], "state_open"), false)
		setActive(findTF(arg0_13.battleItems[iter0_13], "state_closed"), false)
		setActive(findTF(arg0_13.battleItems[iter0_13], "state_clear"), false)
		setActive(findTF(arg0_13.battleItems[iter0_13], "state_current"), false)

		if iter0_13 <= var0_13 then
			SetParent(arg0_13.dropItems[iter0_13], findTF(arg0_13.battleItems[iter0_13], "state_clear/icon"))
			setActive(arg0_13.dropItems[iter0_13], true)
			setActive(findTF(arg0_13.battleItems[iter0_13], "state_clear"), true)
		elseif iter0_13 == var0_13 + 1 and var1_13 >= 1 then
			setActive(findTF(arg0_13.battleItems[iter0_13], "state_current"), true)
			SetParent(arg0_13.dropItems[iter0_13], findTF(arg0_13.battleItems[iter0_13], "state_current/icon"))
			setActive(arg0_13.dropItems[iter0_13], true)
		elseif var0_13 < iter0_13 and iter0_13 <= var0_13 + var1_13 then
			setActive(findTF(arg0_13.battleItems[iter0_13], "state_open"), true)
			SetParent(arg0_13.dropItems[iter0_13], findTF(arg0_13.battleItems[iter0_13], "state_open/icon"))
			setActive(arg0_13.dropItems[iter0_13], true)
		else
			setActive(findTF(arg0_13.battleItems[iter0_13], "state_closed"), true)
			SetParent(arg0_13.dropItems[iter0_13], findTF(arg0_13.battleItems[iter0_13], "state_closed/icon"))
			setActive(arg0_13.dropItems[iter0_13], true)
		end
	end

	local var2_13 = 1 - (var0_13 - 3 < 0 and 0 or var0_13 - 3) / (arg0_13.totalTimes - 4)

	if var2_13 > 1 then
		var2_13 = 1
	end

	scrollTo(arg0_13.battleScrollRect, 0, var2_13)
end

function var0_0.CheckGet(arg0_14)
	local var0_14 = arg0_14.mgHubData

	setActive(findTF(arg0_14.menuUI, "got"), false)

	local var1_14 = arg0_14:getUltimate(var0_14)

	if var1_14 and var1_14 ~= 0 then
		setActive(findTF(arg0_14.menuUI, "got"), true)
	end

	if var1_14 == 0 then
		if var1_0.total_times > arg0_14:getGameUsedTimes(var0_14) then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_14.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_14.menuUI, "got"), true)
	end
end

function var0_0.getGameTimes(arg0_15, arg1_15)
	return arg1_15.count
end

function var0_0.getGameUsedTimes(arg0_16, arg1_16)
	return arg1_16.usedtime
end

function var0_0.getUltimate(arg0_17, arg1_17)
	return arg1_17.ultimate
end

return var0_0
