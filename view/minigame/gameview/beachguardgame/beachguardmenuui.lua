local var0 = class("BeachGuardMenuUI")
local var1 = "beach_guard_chaijun"
local var2 = "beach_guard_jianye"
local var3 = "beach_guard_lituoliao"
local var4 = "beach_guard_bominghan"
local var5 = "beach_guard_nengdai"
local var6 = "beach_guard_m_craft"
local var7 = "beach_guard_m_atk"
local var8 = "beach_guard_m_guard"
local var9 = "beach_guard_m_craft_name"
local var10 = "beach_guard_m_atk_name"
local var11 = "beach_guard_m_guard_name"
local var12 = "beach_guard_e1"
local var13 = "beach_guard_e2"
local var14 = "beach_guard_e3"
local var15 = "beach_guard_e4"
local var16 = "beach_guard_e5"
local var17 = "beach_guard_e6"
local var18 = "beach_guard_e7"
local var19 = "beach_guard_e1_desc"
local var20 = "beach_guard_e2_desc"
local var21 = "beach_guard_e3_desc"
local var22 = "beach_guard_e4_desc"
local var23 = "beach_guard_e5_desc"
local var24 = "beach_guard_e6_desc"
local var25 = "beach_guard_e7_desc"
local var26 = {
	{
		{
			id = 900913,
			icon = "char_1_icon",
			img = "char_1",
			img_desc = "char_1_desc",
			desc = var1
		},
		{
			id = 319011,
			icon = "char_2_icon",
			img = "char_2",
			img_desc = "char_2_desc",
			desc = var2
		},
		{
			id = 605021,
			icon = "char_3_icon",
			img = "char_3",
			img_desc = "char_3_desc",
			desc = var3
		},
		{
			id = 102231,
			icon = "char_4_icon",
			img = "char_4",
			img_desc = "char_4_desc",
			desc = var4
		},
		{
			id = 302211,
			icon = "char_5_icon",
			img = "char_5",
			img_desc = "char_5_desc",
			desc = var5
		},
		{
			img = "m_craft",
			icon = "m_craft_icon",
			name = var9,
			desc = var6
		},
		{
			img = "m_atk",
			icon = "m_atk_icon",
			name = var10,
			desc = var7
		},
		{
			img = "m_guard",
			icon = "m_guard_icon",
			name = var11,
			desc = var8
		}
	},
	{
		{
			img = "e1",
			icon = "e1_icon",
			name = var12,
			desc = var19
		},
		{
			img = "e2",
			icon = "e2_icon",
			name = var13,
			desc = var20
		},
		{
			img = "e3",
			icon = "e3_icon",
			name = var14,
			desc = var21
		},
		{
			img = "e4",
			icon = "e4_icon",
			name = var15,
			desc = var22
		},
		{
			img = "e5",
			icon = "e5_icon",
			name = var16,
			desc = var23
		},
		{
			img = "e6",
			icon = "e6_icon",
			name = var17,
			desc = var24
		},
		{
			img = "e7",
			icon = "e7_icon",
			name = var18,
			desc = var25
		}
	},
	{}
}

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1
	arg0._event = arg3
	arg0._gameData = arg2
	arg0.menuUI = findTF(arg0._tf, "ui/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "ad/battList"), typeof(ScrollRect))
	arg0.totalTimes = arg0._gameData.total_times
	arg0.battleItems = {}
	arg0.dropItems = {}

	GetComponent(findTF(arg0.menuUI, "desc"), typeof(Image)):SetNativeSize()
	onButton(arg0._event, findTF(arg0.menuUI, "ad/rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "ad/rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "ad/btnBack"), function()
		arg0._event:emit(BeachGuardGameView.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "btnRule"), function()
		arg0._event:emit(BeachGuardGameView.SHOW_RULE)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "btnStart"), function()
		arg0._event:emit(BeachGuardGameView.READY_START)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "ad/btnGameBook"), function()
		if isActive(arg0.bookUI) then
			setActive(arg0.bookUI, false)
		else
			setActive(arg0.bookUI, true)
		end
	end, SFX_CANCEL)

	local var0 = findTF(arg0.menuUI, "tplBattleItem")
	local var1 = arg0._gameData.drop

	for iter0 = 1, 7 do
		local var2 = tf(instantiate(var0))

		var2.name = "battleItem_" .. iter0

		setParent(var2, findTF(arg0.menuUI, "ad/battList/Viewport/Content"))

		local var3 = iter0

		GetSpriteFromAtlasAsync(arg0._gameData.path, "battleDesc" .. var3, function(arg0)
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

	arg0.bookUI = findTF(arg0.menuUI, "bookUI")

	setActive(arg0.bookUI, false)
	onButton(arg0._event, findTF(arg0.bookUI, "bottom"), function()
		if isActive(arg0.bookUI) then
			setActive(arg0.bookUI, false)
		end
	end, SFX_PANEL)

	arg0.selectTagIndex = nil
	arg0.selectGridIndex = nil
	arg0.bookUITags = {}
	arg0.grids = {}
	arg0.iconImage = findTF(arg0.bookUI, "bg/icon/img")
	arg0.iconDesc = findTF(arg0.bookUI, "bg/icon/img_desc")
	arg0.descBoundTxt = findTF(arg0.bookUI, "bg/descBound/desc")
	arg0.descBoundTitle = findTF(arg0.bookUI, "bg/descBound/title")

	local var6 = 8

	for iter1 = 1, 3 do
		local var7 = iter1
		local var8 = findTF(arg0.bookUI, "bg/tag" .. iter1)

		if iter1 == 3 then
			setActive(var8, false)
		end

		onButton(arg0._event, var8, function()
			arg0:selectBookTag(var7)
		end, SFX_PANEL)
		table.insert(arg0.bookUITags, var8)
	end

	local var9 = findTF(arg0.bookUI, "bg/gridTpl")

	for iter2 = 1, var6 do
		local var10 = iter2
		local var11 = tf(instantiate(var9))

		setActive(var11, true)
		setParent(var11, findTF(arg0.bookUI, "container/Viewport/Content"))
		onButton(arg0._event, var11, function()
			arg0:selectGrid(var10)
		end, SFX_PANEL)
		table.insert(arg0.grids, var11)
	end

	arg0:selectBookTag(1)
end

function var0.selectBookTag(arg0, arg1)
	if arg0.selectTagIndex ~= arg1 then
		arg0.selectTagIndex = arg1
		arg0.bookDatas = var26[arg1]

		for iter0 = 1, #arg0.bookUITags do
			if arg1 == iter0 then
				setActive(findTF(arg0.bookUITags[iter0], "select"), true)
			else
				setActive(findTF(arg0.bookUITags[iter0], "select"), false)
			end
		end

		for iter1 = 1, #arg0.grids do
			local var0 = arg0.grids[iter1]

			if iter1 <= #arg0.bookDatas then
				local var1 = arg0.bookDatas[iter1]
				local var2 = GetSpriteFromAtlas(arg0._gameData.path, var1.icon)
				local var3

				if var1.id then
					var3 = pg.ship_data_statistics[var1.id].name
				else
					var3 = i18n(var1.name)
				end

				setText(findTF(var0, "name"), var3)
				setImageSprite(findTF(var0, "icon"), var2, true)
				setActive(var0, true)
			else
				setActive(var0, false)
			end
		end

		arg0.selectGridIndex = nil

		arg0:selectGrid(1)
	end
end

function var0.selectGrid(arg0, arg1)
	if arg0.selectGridIndex ~= arg1 then
		arg0.selectGridIndex = arg1

		local var0 = arg0.bookDatas[arg1]

		for iter0 = 1, #arg0.grids do
			local var1 = arg0.grids[iter0]

			if iter0 == arg1 then
				setActive(findTF(var1, "select"), true)
			else
				setActive(findTF(var1, "select"), false)
			end
		end

		if var0.img then
			local var2 = GetSpriteFromAtlas(arg0._gameData.path, var0.img)

			setImageSprite(arg0.iconImage, var2, true)
			setActive(arg0.iconImage, true)
		else
			setActive(arg0.iconImage, false)
		end

		if var0.img_desc then
			local var3 = GetSpriteFromAtlas(arg0._gameData.path, var0.img_desc)

			setImageSprite(arg0.iconDesc, var3, true)
			setActive(arg0.iconDesc, true)
		else
			setActive(arg0.iconDesc, false)
		end

		local var4 = i18n(var0.desc)

		setText(arg0.descBoundTxt, var4)
	end
end

function var0.updateBookUI(arg0)
	return
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
		if arg0._gameData.total_times > arg0:getGameUsedTimes(arg1) then
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
