local var0_0 = class("SailBoatGameMenuUI")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	var1_0 = SailBoatGameVo
	arg0_1._event = arg2_1
	arg0_1.menuUI = findTF(arg0_1._tf, "ui/menuUI")
	arg0_1.battleScrollRect = GetComponent(findTF(arg0_1.menuUI, "battList"), typeof(ScrollRect))
	arg0_1.totalTimes = var1_0.total_times
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
		arg0_1._event:emit(SailBoatGameView.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnRule"), function()
		arg0_1._event:emit(SailBoatGameView.SHOW_RULE)
	end, SFX_CANCEL)

	arg0_1.btnStart = findTF(arg0_1.menuUI, "btnStart")

	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnStart"), function()
		arg0_1._event:emit(SailBoatGameView.OPEN_EQUIP_UI)
	end, SFX_CANCEL)

	local var0_1 = findTF(arg0_1.menuUI, "tplBattleItem")
	local var1_1 = var1_0.drop

	arg0_1._chapters = {}

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
		local var9_1 = findTF(arg0_1.menuUI, "chapter/" .. iter0_1 .. "/icon_bg/icon")
		local var10_1 = {
			type = var1_1[iter0_1][1],
			id = var1_1[iter0_1][2],
			amount = var1_1[iter0_1][3]
		}

		updateDrop(var9_1, var10_1)
		onButton(arg0_1._event, var9_1, function()
			arg0_1._event:emit(BaseUI.ON_DROP, var10_1)
		end, SFX_PANEL)

		local var11_1 = findTF(arg0_1.menuUI, "chapter/" .. iter0_1)

		onButton(arg0_1._event, var11_1, function()
			if var7_1 == 7 and var8_1 == 0 then
				var1_0.selectRound = var4_1

				arg0_1:update(arg0_1.mgHubData)
			end
		end, SFX_CONFIRM)
		table.insert(arg0_1._chapters, var11_1)
	end
end

function var0_0.show(arg0_10, arg1_10)
	setActive(arg0_10.menuUI, arg1_10)
end

function var0_0.update(arg0_11, arg1_11)
	arg0_11.mgHubData = arg1_11

	local var0_11 = arg0_11:getGameUsedTimes(arg1_11)
	local var1_11 = arg0_11:getGameTimes(arg1_11)

	for iter0_11 = 1, 7 do
		setActive(findTF(arg0_11.battleItems[iter0_11], "state_open"), false)
		setActive(findTF(arg0_11.battleItems[iter0_11], "state_closed"), false)
		setActive(findTF(arg0_11.battleItems[iter0_11], "state_clear"), false)
		setActive(findTF(arg0_11.battleItems[iter0_11], "state_current"), false)

		if iter0_11 <= var0_11 then
			SetParent(arg0_11.dropItems[iter0_11], findTF(arg0_11.battleItems[iter0_11], "state_clear/icon"))
			setActive(arg0_11.dropItems[iter0_11], true)
			setActive(findTF(arg0_11.battleItems[iter0_11], "state_clear"), true)
		elseif iter0_11 == var0_11 + 1 and var1_11 >= 1 then
			setActive(findTF(arg0_11.battleItems[iter0_11], "state_current"), true)
			SetParent(arg0_11.dropItems[iter0_11], findTF(arg0_11.battleItems[iter0_11], "state_current/icon"))
			setActive(arg0_11.dropItems[iter0_11], true)
		elseif var0_11 < iter0_11 and iter0_11 <= var0_11 + var1_11 then
			setActive(findTF(arg0_11.battleItems[iter0_11], "state_open"), true)
			SetParent(arg0_11.dropItems[iter0_11], findTF(arg0_11.battleItems[iter0_11], "state_open/icon"))
			setActive(arg0_11.dropItems[iter0_11], true)
		else
			setActive(findTF(arg0_11.battleItems[iter0_11], "state_closed"), true)
			SetParent(arg0_11.dropItems[iter0_11], findTF(arg0_11.battleItems[iter0_11], "state_closed/icon"))
			setActive(arg0_11.dropItems[iter0_11], true)
		end

		setActive(findTF(arg0_11._chapters[iter0_11], "close"), false)
		setActive(findTF(arg0_11._chapters[iter0_11], "got"), false)
		setActive(findTF(arg0_11._chapters[iter0_11], "active"), false)
		setActive(findTF(arg0_11._chapters[iter0_11], "icon_bg"), false)

		if iter0_11 <= var0_11 then
			setActive(findTF(arg0_11._chapters[iter0_11], "got"), true)
		elseif iter0_11 == var0_11 + 1 and var1_11 >= 1 then
			setActive(findTF(arg0_11._chapters[iter0_11], "active"), true)
			setActive(findTF(arg0_11._chapters[iter0_11], "icon_bg"), true)
		elseif var0_11 < iter0_11 and iter0_11 <= var0_11 + var1_11 then
			-- block empty
		else
			setActive(findTF(arg0_11._chapters[iter0_11], "close"), true)
		end

		if var1_0.selectRound == iter0_11 then
			setActive(findTF(arg0_11._chapters[iter0_11], "active"), true)
		end
	end

	local var2_11 = 1 - (var0_11 - 3 < 0 and 0 or var0_11 - 3) / (arg0_11.totalTimes - 4)

	if var2_11 > 1 then
		var2_11 = 1
	end

	scrollTo(arg0_11.battleScrollRect, 0, var2_11)
end

function var0_0.CheckGet(arg0_12)
	local var0_12 = arg0_12.mgHubData

	setActive(findTF(arg0_12.menuUI, "got"), false)

	local var1_12 = arg0_12:getUltimate(var0_12)

	if var1_12 and var1_12 ~= 0 then
		setActive(findTF(arg0_12.menuUI, "got"), true)
	end

	if var1_12 == 0 then
		if var1_0.total_times > arg0_12:getGameUsedTimes(var0_12) then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_12.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_12.menuUI, "got"), true)
	end
end

function var0_0.getGameTimes(arg0_13, arg1_13)
	return arg1_13.count
end

function var0_0.getGameUsedTimes(arg0_14, arg1_14)
	return arg1_14.usedtime
end

function var0_0.getUltimate(arg0_15, arg1_15)
	return arg1_15.ultimate
end

return var0_0
