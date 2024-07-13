local var0_0 = class("BeachGuardMenuUI")
local var1_0 = "beach_guard_chaijun"
local var2_0 = "beach_guard_jianye"
local var3_0 = "beach_guard_lituoliao"
local var4_0 = "beach_guard_bominghan"
local var5_0 = "beach_guard_nengdai"
local var6_0 = "beach_guard_m_craft"
local var7_0 = "beach_guard_m_atk"
local var8_0 = "beach_guard_m_guard"
local var9_0 = "beach_guard_m_craft_name"
local var10_0 = "beach_guard_m_atk_name"
local var11_0 = "beach_guard_m_guard_name"
local var12_0 = "beach_guard_e1"
local var13_0 = "beach_guard_e2"
local var14_0 = "beach_guard_e3"
local var15_0 = "beach_guard_e4"
local var16_0 = "beach_guard_e5"
local var17_0 = "beach_guard_e6"
local var18_0 = "beach_guard_e7"
local var19_0 = "beach_guard_e1_desc"
local var20_0 = "beach_guard_e2_desc"
local var21_0 = "beach_guard_e3_desc"
local var22_0 = "beach_guard_e4_desc"
local var23_0 = "beach_guard_e5_desc"
local var24_0 = "beach_guard_e6_desc"
local var25_0 = "beach_guard_e7_desc"
local var26_0 = {
	{
		{
			id = 900913,
			icon = "char_1_icon",
			img = "char_1",
			img_desc = "char_1_desc",
			desc = var1_0
		},
		{
			id = 319011,
			icon = "char_2_icon",
			img = "char_2",
			img_desc = "char_2_desc",
			desc = var2_0
		},
		{
			id = 605021,
			icon = "char_3_icon",
			img = "char_3",
			img_desc = "char_3_desc",
			desc = var3_0
		},
		{
			id = 102231,
			icon = "char_4_icon",
			img = "char_4",
			img_desc = "char_4_desc",
			desc = var4_0
		},
		{
			id = 302211,
			icon = "char_5_icon",
			img = "char_5",
			img_desc = "char_5_desc",
			desc = var5_0
		},
		{
			img = "m_craft",
			icon = "m_craft_icon",
			name = var9_0,
			desc = var6_0
		},
		{
			img = "m_atk",
			icon = "m_atk_icon",
			name = var10_0,
			desc = var7_0
		},
		{
			img = "m_guard",
			icon = "m_guard_icon",
			name = var11_0,
			desc = var8_0
		}
	},
	{
		{
			img = "e1",
			icon = "e1_icon",
			name = var12_0,
			desc = var19_0
		},
		{
			img = "e2",
			icon = "e2_icon",
			name = var13_0,
			desc = var20_0
		},
		{
			img = "e3",
			icon = "e3_icon",
			name = var14_0,
			desc = var21_0
		},
		{
			img = "e4",
			icon = "e4_icon",
			name = var15_0,
			desc = var22_0
		},
		{
			img = "e5",
			icon = "e5_icon",
			name = var16_0,
			desc = var23_0
		},
		{
			img = "e6",
			icon = "e6_icon",
			name = var17_0,
			desc = var24_0
		},
		{
			img = "e7",
			icon = "e7_icon",
			name = var18_0,
			desc = var25_0
		}
	},
	{}
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg3_1
	arg0_1._gameData = arg2_1
	arg0_1.menuUI = findTF(arg0_1._tf, "ui/menuUI")
	arg0_1.battleScrollRect = GetComponent(findTF(arg0_1.menuUI, "ad/battList"), typeof(ScrollRect))
	arg0_1.totalTimes = arg0_1._gameData.total_times
	arg0_1.battleItems = {}
	arg0_1.dropItems = {}

	GetComponent(findTF(arg0_1.menuUI, "desc"), typeof(Image)):SetNativeSize()
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "ad/rightPanelBg/arrowUp"), function()
		local var0_2 = arg0_1.battleScrollRect.normalizedPosition.y + 1 / (arg0_1.totalTimes - 4)

		if var0_2 > 1 then
			var0_2 = 1
		end

		scrollTo(arg0_1.battleScrollRect, 0, var0_2)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "ad/rightPanelBg/arrowDown"), function()
		local var0_3 = arg0_1.battleScrollRect.normalizedPosition.y - 1 / (arg0_1.totalTimes - 4)

		if var0_3 < 0 then
			var0_3 = 0
		end

		scrollTo(arg0_1.battleScrollRect, 0, var0_3)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "ad/btnBack"), function()
		arg0_1._event:emit(BeachGuardGameView.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnRule"), function()
		arg0_1._event:emit(BeachGuardGameView.SHOW_RULE)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnStart"), function()
		arg0_1._event:emit(BeachGuardGameView.READY_START)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "ad/btnGameBook"), function()
		if isActive(arg0_1.bookUI) then
			setActive(arg0_1.bookUI, false)
		else
			setActive(arg0_1.bookUI, true)
		end
	end, SFX_CANCEL)

	local var0_1 = findTF(arg0_1.menuUI, "tplBattleItem")
	local var1_1 = arg0_1._gameData.drop

	for iter0_1 = 1, 7 do
		local var2_1 = tf(instantiate(var0_1))

		var2_1.name = "battleItem_" .. iter0_1

		setParent(var2_1, findTF(arg0_1.menuUI, "ad/battList/Viewport/Content"))

		local var3_1 = iter0_1

		GetSpriteFromAtlasAsync(arg0_1._gameData.path, "battleDesc" .. var3_1, function(arg0_8)
			if arg0_8 then
				setImageSprite(findTF(var2_1, "state_open/desc"), arg0_8, true)
				setImageSprite(findTF(var2_1, "state_clear/desc"), arg0_8, true)
				setImageSprite(findTF(var2_1, "state_current/desc"), arg0_8, true)
				setImageSprite(findTF(var2_1, "state_closed/desc"), arg0_8, true)
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

	arg0_1.bookUI = findTF(arg0_1.menuUI, "bookUI")

	setActive(arg0_1.bookUI, false)
	onButton(arg0_1._event, findTF(arg0_1.bookUI, "bottom"), function()
		if isActive(arg0_1.bookUI) then
			setActive(arg0_1.bookUI, false)
		end
	end, SFX_PANEL)

	arg0_1.selectTagIndex = nil
	arg0_1.selectGridIndex = nil
	arg0_1.bookUITags = {}
	arg0_1.grids = {}
	arg0_1.iconImage = findTF(arg0_1.bookUI, "bg/icon/img")
	arg0_1.iconDesc = findTF(arg0_1.bookUI, "bg/icon/img_desc")
	arg0_1.descBoundTxt = findTF(arg0_1.bookUI, "bg/descBound/desc")
	arg0_1.descBoundTitle = findTF(arg0_1.bookUI, "bg/descBound/title")

	local var6_1 = 8

	for iter1_1 = 1, 3 do
		local var7_1 = iter1_1
		local var8_1 = findTF(arg0_1.bookUI, "bg/tag" .. iter1_1)

		if iter1_1 == 3 then
			setActive(var8_1, false)
		end

		onButton(arg0_1._event, var8_1, function()
			arg0_1:selectBookTag(var7_1)
		end, SFX_PANEL)
		table.insert(arg0_1.bookUITags, var8_1)
	end

	local var9_1 = findTF(arg0_1.bookUI, "bg/gridTpl")

	for iter2_1 = 1, var6_1 do
		local var10_1 = iter2_1
		local var11_1 = tf(instantiate(var9_1))

		setActive(var11_1, true)
		setParent(var11_1, findTF(arg0_1.bookUI, "container/Viewport/Content"))
		onButton(arg0_1._event, var11_1, function()
			arg0_1:selectGrid(var10_1)
		end, SFX_PANEL)
		table.insert(arg0_1.grids, var11_1)
	end

	arg0_1:selectBookTag(1)
end

function var0_0.selectBookTag(arg0_13, arg1_13)
	if arg0_13.selectTagIndex ~= arg1_13 then
		arg0_13.selectTagIndex = arg1_13
		arg0_13.bookDatas = var26_0[arg1_13]

		for iter0_13 = 1, #arg0_13.bookUITags do
			if arg1_13 == iter0_13 then
				setActive(findTF(arg0_13.bookUITags[iter0_13], "select"), true)
			else
				setActive(findTF(arg0_13.bookUITags[iter0_13], "select"), false)
			end
		end

		for iter1_13 = 1, #arg0_13.grids do
			local var0_13 = arg0_13.grids[iter1_13]

			if iter1_13 <= #arg0_13.bookDatas then
				local var1_13 = arg0_13.bookDatas[iter1_13]
				local var2_13 = GetSpriteFromAtlas(arg0_13._gameData.path, var1_13.icon)
				local var3_13

				if var1_13.id then
					var3_13 = pg.ship_data_statistics[var1_13.id].name
				else
					var3_13 = i18n(var1_13.name)
				end

				setText(findTF(var0_13, "name"), var3_13)
				setImageSprite(findTF(var0_13, "icon"), var2_13, true)
				setActive(var0_13, true)
			else
				setActive(var0_13, false)
			end
		end

		arg0_13.selectGridIndex = nil

		arg0_13:selectGrid(1)
	end
end

function var0_0.selectGrid(arg0_14, arg1_14)
	if arg0_14.selectGridIndex ~= arg1_14 then
		arg0_14.selectGridIndex = arg1_14

		local var0_14 = arg0_14.bookDatas[arg1_14]

		for iter0_14 = 1, #arg0_14.grids do
			local var1_14 = arg0_14.grids[iter0_14]

			if iter0_14 == arg1_14 then
				setActive(findTF(var1_14, "select"), true)
			else
				setActive(findTF(var1_14, "select"), false)
			end
		end

		if var0_14.img then
			local var2_14 = GetSpriteFromAtlas(arg0_14._gameData.path, var0_14.img)

			setImageSprite(arg0_14.iconImage, var2_14, true)
			setActive(arg0_14.iconImage, true)
		else
			setActive(arg0_14.iconImage, false)
		end

		if var0_14.img_desc then
			local var3_14 = GetSpriteFromAtlas(arg0_14._gameData.path, var0_14.img_desc)

			setImageSprite(arg0_14.iconDesc, var3_14, true)
			setActive(arg0_14.iconDesc, true)
		else
			setActive(arg0_14.iconDesc, false)
		end

		local var4_14 = i18n(var0_14.desc)

		setText(arg0_14.descBoundTxt, var4_14)
	end
end

function var0_0.updateBookUI(arg0_15)
	return
end

function var0_0.show(arg0_16, arg1_16)
	setActive(arg0_16.menuUI, arg1_16)
end

function var0_0.update(arg0_17, arg1_17)
	local var0_17 = arg0_17:getGameUsedTimes(arg1_17)
	local var1_17 = arg0_17:getGameTimes(arg1_17)

	for iter0_17 = 1, #arg0_17.battleItems do
		setActive(findTF(arg0_17.battleItems[iter0_17], "state_open"), false)
		setActive(findTF(arg0_17.battleItems[iter0_17], "state_closed"), false)
		setActive(findTF(arg0_17.battleItems[iter0_17], "state_clear"), false)
		setActive(findTF(arg0_17.battleItems[iter0_17], "state_current"), false)

		if iter0_17 <= var0_17 then
			SetParent(arg0_17.dropItems[iter0_17], findTF(arg0_17.battleItems[iter0_17], "state_clear/icon"))
			setActive(arg0_17.dropItems[iter0_17], true)
			setActive(findTF(arg0_17.battleItems[iter0_17], "state_clear"), true)
		elseif iter0_17 == var0_17 + 1 and var1_17 >= 1 then
			setActive(findTF(arg0_17.battleItems[iter0_17], "state_current"), true)
			SetParent(arg0_17.dropItems[iter0_17], findTF(arg0_17.battleItems[iter0_17], "state_current/icon"))
			setActive(arg0_17.dropItems[iter0_17], true)
		elseif var0_17 < iter0_17 and iter0_17 <= var0_17 + var1_17 then
			setActive(findTF(arg0_17.battleItems[iter0_17], "state_open"), true)
			SetParent(arg0_17.dropItems[iter0_17], findTF(arg0_17.battleItems[iter0_17], "state_open/icon"))
			setActive(arg0_17.dropItems[iter0_17], true)
		else
			setActive(findTF(arg0_17.battleItems[iter0_17], "state_closed"), true)
			SetParent(arg0_17.dropItems[iter0_17], findTF(arg0_17.battleItems[iter0_17], "state_closed/icon"))
			setActive(arg0_17.dropItems[iter0_17], true)
		end
	end

	local var2_17 = 1 - (var0_17 - 3 < 0 and 0 or var0_17 - 3) / (arg0_17.totalTimes - 4)

	if var2_17 > 1 then
		var2_17 = 1
	end

	scrollTo(arg0_17.battleScrollRect, 0, var2_17)
	setActive(findTF(arg0_17.menuUI, "btnStart/tip"), var1_17 > 0)
	arg0_17:CheckGet(arg1_17)
end

function var0_0.CheckGet(arg0_18, arg1_18)
	setActive(findTF(arg0_18.menuUI, "got"), false)

	local var0_18 = arg0_18:getUltimate(arg1_18)

	if var0_18 and var0_18 ~= 0 then
		setActive(findTF(arg0_18.menuUI, "got"), true)
	end

	if var0_18 == 0 then
		if arg0_18._gameData.total_times > arg0_18:getGameUsedTimes(arg1_18) then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg1_18.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_18.menuUI, "got"), true)
	end
end

function var0_0.getGameTimes(arg0_19, arg1_19)
	return arg1_19.count
end

function var0_0.getGameUsedTimes(arg0_20, arg1_20)
	return arg1_20.usedtime
end

function var0_0.getUltimate(arg0_21, arg1_21)
	return arg1_21.ultimate
end

return var0_0
