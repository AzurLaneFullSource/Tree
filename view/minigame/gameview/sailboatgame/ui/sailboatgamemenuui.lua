local var0 = class("SailBoatGameMenuUI")
local var1

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	var1 = SailBoatGameVo
	arg0._event = arg2
	arg0.menuUI = findTF(arg0._tf, "ui/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = var1.total_times
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
		arg0._event:emit(SailBoatGameView.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "btnRule"), function()
		arg0._event:emit(SailBoatGameView.SHOW_RULE)
	end, SFX_CANCEL)

	arg0.btnStart = findTF(arg0.menuUI, "btnStart")

	onButton(arg0._event, findTF(arg0.menuUI, "btnStart"), function()
		arg0._event:emit(SailBoatGameView.OPEN_EQUIP_UI)
	end, SFX_CANCEL)

	local var0 = findTF(arg0.menuUI, "tplBattleItem")
	local var1 = var1.drop

	arg0._chapters = {}

	for iter0 = 1, 7 do
		local var2 = iter0
		local var3 = tf(instantiate(var0))

		var3.name = "battleItem_" .. iter0

		setParent(var3, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var4 = iter0
		local var5 = findTF(var3, "icon")
		local var6 = {
			type = var1[iter0][1],
			id = var1[iter0][2],
			amount = var1[iter0][3]
		}

		updateDrop(var5, var6)
		onButton(arg0._event, var5, function()
			arg0._event:emit(BaseUI.ON_DROP, var6)
		end, SFX_PANEL)
		table.insert(arg0.dropItems, var5)
		setActive(var3, true)
		table.insert(arg0.battleItems, var3)

		local var7 = var1.GetGameUseTimes()
		local var8 = var1.GetGameTimes()
		local var9 = findTF(arg0.menuUI, "chapter/" .. iter0 .. "/icon_bg/icon")
		local var10 = {
			type = var1[iter0][1],
			id = var1[iter0][2],
			amount = var1[iter0][3]
		}

		updateDrop(var9, var10)
		onButton(arg0._event, var9, function()
			arg0._event:emit(BaseUI.ON_DROP, var10)
		end, SFX_PANEL)

		local var11 = findTF(arg0.menuUI, "chapter/" .. iter0)

		onButton(arg0._event, var11, function()
			if var7 == 7 and var8 == 0 then
				var1.selectRound = var4

				arg0:update(arg0.mgHubData)
			end
		end, SFX_CONFIRM)
		table.insert(arg0._chapters, var11)
	end
end

function var0.show(arg0, arg1)
	setActive(arg0.menuUI, arg1)
end

function var0.update(arg0, arg1)
	arg0.mgHubData = arg1

	local var0 = arg0:getGameUsedTimes(arg1)
	local var1 = arg0:getGameTimes(arg1)

	for iter0 = 1, 7 do
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

		setActive(findTF(arg0._chapters[iter0], "close"), false)
		setActive(findTF(arg0._chapters[iter0], "got"), false)
		setActive(findTF(arg0._chapters[iter0], "active"), false)
		setActive(findTF(arg0._chapters[iter0], "icon_bg"), false)

		if iter0 <= var0 then
			setActive(findTF(arg0._chapters[iter0], "got"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0._chapters[iter0], "active"), true)
			setActive(findTF(arg0._chapters[iter0], "icon_bg"), true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			-- block empty
		else
			setActive(findTF(arg0._chapters[iter0], "close"), true)
		end

		if var1.selectRound == iter0 then
			setActive(findTF(arg0._chapters[iter0], "active"), true)
		end
	end

	local var2 = 1 - (var0 - 3 < 0 and 0 or var0 - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
end

function var0.CheckGet(arg0)
	local var0 = arg0.mgHubData

	setActive(findTF(arg0.menuUI, "got"), false)

	local var1 = arg0:getUltimate(var0)

	if var1 and var1 ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if var1 == 0 then
		if var1.total_times > arg0:getGameUsedTimes(var0) then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
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
