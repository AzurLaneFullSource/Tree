local var0_0 = class("NenjuuMiniGameView", import("view.miniGame.BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "NenjuuMiniGameUI"
end

function var0_0.openUI(arg0_2, arg1_2)
	if arg0_2.status then
		setActive(arg0_2.rtTitlePage:Find(arg0_2.status), false)
	end

	if arg1_2 then
		setActive(arg0_2.rtTitlePage:Find(arg1_2), true)
	end

	arg0_2.status = arg1_2

	switch(arg1_2, {
		main = function()
			arg0_2:updateMainUI()
		end,
		pause = function()
			arg0_2.gameController:PauseGame()
		end,
		exit = function()
			arg0_2.gameController:PauseGame()
		end,
		result = function()
			local var0_6 = NenjuuGameConfig.ParsingElements(arg0_2:GetMGData():GetRuntimeData("elements") or {})
			local var1_6 = arg0_2.gameController.point
			local var2_6 = var0_6.high
			local var3_6 = arg0_2.rtTitlePage:Find("result")

			setActive(var3_6:Find("window/now/new"), var2_6 < var1_6)

			if var2_6 <= var1_6 then
				var2_6 = var1_6
				var0_6.high = var1_6
			end

			var0_6.count = var0_6.count + var1_6

			arg0_2:SaveDataChange(var0_6)
			setText(var3_6:Find("window/high/Text"), var2_6)
			setText(var3_6:Find("window/now/Text"), var1_6)

			local var4_6 = arg0_2:GetMGHubData()

			if arg0_2.stageIndex == var4_6.usedtime + 1 and var4_6.count > 0 then
				arg0_2:SendSuccess(0)
			end
		end
	})
end

function var0_0.updateMainUI(arg0_7)
	local var0_7 = arg0_7:GetMGHubData()
	local var1_7 = var0_7:getConfig("reward_need")
	local var2_7 = var0_7.usedtime
	local var3_7 = var2_7 + var0_7.count
	local var4_7 = math.min(var0_7.usedtime + 1, var3_7)
	local var5_7 = arg0_7.itemList.container
	local var6_7 = var5_7.childCount

	for iter0_7 = 1, var6_7 do
		local var7_7 = {}

		if iter0_7 <= var2_7 then
			var7_7.finish = true
		elseif iter0_7 <= var3_7 then
			-- block empty
		else
			var7_7.lock = true
		end

		local var8_7 = var5_7:GetChild(iter0_7 - 1)

		setActive(var8_7:Find("finish"), var7_7.finish)
		setActive(var8_7:Find("lock"), var7_7.lock)
		setToggleEnabled(var8_7, iter0_7 <= var4_7)
		triggerToggle(var8_7, iter0_7 == var4_7)
	end

	local var9_7 = var5_7:GetChild(0).anchoredPosition.y - var5_7:GetChild(var4_7 - 1).anchoredPosition.y
	local var10_7 = var5_7.rect.height
	local var11_7 = var5_7:GetComponent(typeof(ScrollRect)).viewport.rect.height
	local var12_7 = math.clamp(var9_7, 0, var10_7 - var11_7) / (var10_7 - var11_7)

	scrollTo(var5_7, nil, 1 - var12_7)
	arg0_7:checkGet()
end

function var0_0.checkGet(arg0_8)
	local var0_8 = arg0_8:GetMGHubData()

	if var0_8.ultimate == 0 then
		if var0_8.usedtime < var0_8:getConfig("reward_need") then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_8.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.initPageUI(arg0_9)
	arg0_9.rtTitlePage = arg0_9._tf:Find("TitlePage")

	local var0_9 = arg0_9.rtTitlePage:Find("main")

	onButton(arg0_9, var0_9:Find("btn_back"), function()
		arg0_9:closeView()
	end, SFX_CANCEL)
	onButton(arg0_9, var0_9:Find("btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["2023spring_minigame_help"].tip
		})
	end, SFX_PANEL)
	onButton(arg0_9, var0_9:Find("btn_opreation"), function()
		setActive(arg0_9.rtLevel:Find("Opreation"), true)
		arg0_9:UpdateOpreationPage(1)
	end, SFX_PANEL)

	local var1_9 = arg0_9:GetMGData():GetSimpleValue("story")

	onButton(arg0_9, var0_9:Find("btn_start"), function()
		local var0_13 = {}
		local var1_13 = checkExist(var1_9, {
			arg0_9.stageIndex
		}, {
			1
		})

		if var1_13 then
			table.insert(var0_13, function(arg0_14)
				pg.NewStoryMgr.GetInstance():Play(var1_13, arg0_14)
			end)
		end

		seriesAsync(var0_13, function()
			arg0_9:openReadyPage()
		end)
	end, SFX_PANEL)

	arg0_9.stageIndex = 0

	local var2_9 = pg.mini_game[arg0_9:GetMGData().id].simple_config_data.drop
	local var3_9 = var0_9:Find("side_panel/award/content")

	arg0_9.itemList = UIItemList.New(var3_9, var3_9:GetChild(0))

	arg0_9.itemList:make(function(arg0_16, arg1_16, arg2_16)
		arg1_16 = arg1_16 + 1

		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = arg2_16:Find("IconTpl")
			local var1_16 = {}

			var1_16.type, var1_16.id, var1_16.count = unpack(var2_9[arg1_16])

			updateDrop(var0_16, var1_16)
			onButton(arg0_9, var0_16, function()
				arg0_9:emit(var0_0.ON_DROP, var1_16)
			end, SFX_PANEL)
			onToggle(arg0_9, arg2_16, function(arg0_18)
				if arg0_18 then
					arg0_9.stageIndex = arg1_16
				end
			end)
		end
	end)
	arg0_9.itemList:align(#var2_9)
	arg0_9.rtTitlePage:Find("countdown"):Find("bg/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_9:openUI()
		arg0_9.gameController:StartGame()
	end)

	local var4_9 = arg0_9.rtTitlePage:Find("pause")

	onButton(arg0_9, var4_9:Find("window/btn_confirm"), function()
		arg0_9:openUI()
		arg0_9.gameController:ResumeGame()
	end, SFX_CONFIRM)

	local var5_9 = arg0_9.rtTitlePage:Find("exit")

	onButton(arg0_9, var5_9:Find("window/btn_cancel"), function()
		arg0_9:openUI()
		arg0_9.gameController:ResumeGame()
	end, SFX_CANCEL)
	onButton(arg0_9, var5_9:Find("window/btn_confirm"), function()
		arg0_9:openUI()
		arg0_9.gameController:EndGame()
	end, SFX_CONFIRM)

	local var6_9 = arg0_9.rtTitlePage:Find("result")

	onButton(arg0_9, var6_9:Find("window/btn_finish"), function()
		arg0_9:openUI("main")
	end, SFX_CONFIRM)
end

function var0_0.initLeveUI(arg0_24)
	arg0_24.rtLevel = arg0_24._tf:Find("LevelPage")

	local var0_24 = arg0_24.rtLevel:Find("Opreation")

	onButton(arg0_24, var0_24:Find("btn_back"), function()
		setActive(var0_24, false)
	end, SFX_CANCEL)
end

local var1_0 = {
	bomb = {
		"2023spring_minigame_item_firecracker"
	},
	lantern = {
		"2023spring_minigame_item_lantern"
	},
	ice = {
		"2023spring_minigame_skill_icewall",
		"2023spring_minigame_skill_icewall_up"
	},
	flash = {
		"2023spring_minigame_skill_flash",
		"2023spring_minigame_skill_flash_up"
	},
	rush = {
		"2023spring_minigame_skill_sprint",
		"2023spring_minigame_skill_sprint_up"
	},
	blessing = {
		"2023spring_minigame_bless_speed",
		"2023spring_minigame_bless_speed_up"
	},
	decoy = {
		"2023spring_minigame_bless_substitute",
		"2023spring_minigame_bless_substitute_up"
	}
}

function var0_0.UpdateOpreationPage(arg0_26, arg1_26)
	local var0_26 = arg0_26.rtLevel:Find("Opreation")
	local var1_26 = NenjuuGameConfig.ParsingElements(arg0_26:GetMGData():GetRuntimeData("elements") or {})

	setText(var0_26:Find("point/Text"), var1_26.count)

	local var2_26 = {
		{
			"bomb",
			"lantern"
		},
		{
			"ice",
			"flash",
			"rush"
		},
		{
			"blessing",
			"decoy"
		}
	}
	local var3_26
	local var4_26 = var0_26:Find("main/view/content")
	local var5_26 = UIItemList.New(var4_26, var4_26:Find("tpl"))

	var5_26:make(function(arg0_27, arg1_27, arg2_27)
		arg1_27 = arg1_27 + 1

		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = var3_26[arg1_27]

			setActive(arg2_27:Find("empty"), not var0_27)
			setActive(arg2_27:Find("info"), var0_27)

			if var0_27 then
				local var1_27 = arg2_27:Find("info")

				eachChild(var1_27:Find("icon"), function(arg0_28)
					setActive(arg0_28, arg0_28.name == var0_27)
				end)

				local var2_27 = string.split(i18n(var1_0[var0_27][1]), "|")

				setText(var1_27:Find("name/Text"), var2_27[1])
				setText(var1_27:Find("desc"), var2_27[2])
				setActive(var1_27:Find("level"), var1_0[var0_27][2])

				if var1_0[var0_27][2] then
					local var3_27 = string.split(i18n(var1_0[var0_27][2]), "|")

					for iter0_27 = 1, 3 do
						local var4_27 = var1_27:Find("level/" .. iter0_27)

						setActive(var4_27, var3_27[iter0_27])

						if var3_27[iter0_27] then
							setTextColor(var4_27:Find("Text"), Color.NewHex(iter0_27 > var1_26.level[var0_27] and "8D90AFFF" or "535885FF"))
							changeToScrollText(var4_27:Find("info"), setColorStr(var3_27[iter0_27], iter0_27 > var1_26.level[var0_27] and "#8D90AFFF" or "#535885FF"))
						end
					end
				end

				eachChild(var1_27:Find("status"), function(arg0_29)
					setActive(arg0_29, false)
				end)
				onButton(arg0_26, var1_27:Find("status/btn_equip"), function()
					var1_26.item = var0_27

					arg0_26:SaveDataChange(var1_26)
					arg0_26:UpdateOpreationPage(arg1_26)
				end, SFX_CONFIRM)
				onButton(arg0_26, var1_27:Find("status/btn_unlock"), function()
					var1_26.count = var1_26.count - NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0_27].cost[var1_26.level[var0_27] + 1]
					var1_26.level[var0_27] = var1_26.level[var0_27] + 1

					if var1_26.level[var0_27] > 1 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("2023spring_minigame_tip7", var2_27[1]))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("2023spring_minigame_tip6", var2_27[1]))
					end

					arg0_26:SaveDataChange(var1_26)
					arg0_26:UpdateOpreationPage(arg1_26)
				end, SFX_CONFIRM)

				if var1_26.level[var0_27] < #NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0_27].cost then
					local var5_27 = NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0_27].cost[var1_26.level[var0_27] + 1]

					if var5_27 > var1_26.count then
						setText(var1_27:Find("status/btn_lock/point"), var5_27)
						setText(var1_27:Find("status/btn_lock/Text"), i18n("2023spring_minigame_tip3"))
						setActive(var1_27:Find("status/btn_lock"), true)
					else
						setText(var1_27:Find("status/btn_unlock/point"), var5_27)
						setText(var1_27:Find("status/btn_unlock/Text"), i18n("2023spring_minigame_tip3"))
						setActive(var1_27:Find("status/btn_unlock"), true)
					end
				elseif var0_27 == "bomb" or var0_27 == "lantern" then
					setText(var1_27:Find("status/btn_equip/Text"), i18n("2023spring_minigame_tip1"))
					setActive(var1_27:Find("status/btn_equip"), var1_26.item ~= var0_27)
					setText(var1_27:Find("status/btn_in/Text"), i18n("2023spring_minigame_tip2"))
					setActive(var1_27:Find("status/btn_in"), var1_26.item == var0_27)
				else
					setActive(var1_27:Find("status/unlock"), true)
				end
			end
		end
	end)

	for iter0_26, iter1_26 in ipairs(var2_26) do
		onToggle(arg0_26, var0_26:Find("toggles/" .. iter0_26), function(arg0_32)
			arg1_26 = iter0_26
			var3_26 = iter1_26

			var5_26:align(4)
			setActive(var0_26:Find("main/tip"), iter0_26 == 1)
		end, SFX_PANEL)
	end

	triggerToggle(var0_26:Find("toggles/" .. arg1_26), true)
end

local function var2_0(arg0_33, arg1_33, arg2_33)
	for iter0_33, iter1_33 in ipairs(NenjuuGameConfig.ABILITY_LIST) do
		if arg0_33[iter1_33] then
			arg1_33 = arg1_33 + arg2_33[iter1_33]
		end
	end

	return arg1_33
end

function var0_0.openReadyPage(arg0_34)
	local var0_34 = NenjuuGameConfig.ParsingElements(arg0_34:GetMGData():GetRuntimeData("elements") or {})
	local var1_34 = NenjuuGameConfig.GetStageConfig("Spring23Level_" .. arg0_34.stageIndex)

	if not arg0_34.abilityCache[arg0_34.stageIndex] then
		arg0_34.abilityCache[arg0_34.stageIndex] = setmetatable({}, {
			__index = var1_34.ability_config
		})
	end

	setActive(arg0_34.rtLevel:Find("Ready"), true)
	onButton(arg0_34, arg0_34.rtLevel:Find("Ready/bg"), function()
		setActive(arg0_34.rtLevel:Find("Ready"), false)
	end, SFX_CANCEL)

	local var2_34 = arg0_34.rtLevel:Find("Ready/main")

	eachChild(var2_34:Find("title"), function(arg0_36)
		setActive(arg0_36, arg0_36.name == tostring(arg0_34.stageIndex))
	end)
	setText(var2_34:Find("rate/Image/Text"), var2_0(arg0_34.abilityCache[arg0_34.stageIndex], var1_34.base_rate, var1_34.ability_rate))
	setText(var2_34:Find("high/Image/Text"), var0_34["stage_" .. arg0_34.stageIndex])
	setText(var2_34:Find("ability_text/Text"), i18n("2023spring_minigame_tip5"))

	local var3_34 = underscore.filter(NenjuuGameConfig.ABILITY_LIST, function(arg0_37)
		return arg0_34.abilityCache[arg0_34.stageIndex][arg0_37]
	end)
	local var4_34 = UIItemList.New(var2_34:Find("abilitys"), var2_34:Find("abilitys/tpl"))

	var4_34:make(function(arg0_38, arg1_38, arg2_38)
		arg1_38 = arg1_38 + 1

		if arg0_38 == UIItemList.EventUpdate then
			setActive(arg2_38:Find("empty"), not var3_34[arg1_38])
			setActive(arg2_38:Find("enable"), var3_34[arg1_38])

			if var3_34[arg1_38] then
				eachChild(arg2_38:Find("enable"), function(arg0_39)
					setActive(arg0_39, arg0_39.name == var3_34[arg1_38])
				end)
			end
		end
	end)
	var4_34:align(#NenjuuGameConfig.ABILITY_LIST)
	onButton(arg0_34, var2_34:Find("btn_rate"), function()
		setActive(arg0_34.rtLevel:Find("Ready"), false)
		arg0_34:openRatePage()
	end, SFX_PANEL)
	onButton(arg0_34, var2_34:Find("btn_continue"), function()
		setActive(arg0_34.rtLevel:Find("Ready"), false)
		arg0_34.gameController:ResetGame()
		arg0_34.gameController:ReadyGame({
			index = arg0_34.stageIndex,
			FuShun = NenjuuGameConfig.ParsingElements(arg0_34:GetMGData():GetRuntimeData("elements") or {}),
			Nenjuu = arg0_34.abilityCache[arg0_34.stageIndex],
			rate = var2_0(arg0_34.abilityCache[arg0_34.stageIndex], var1_34.base_rate, var1_34.ability_rate)
		})
		arg0_34:openUI("countdown")
	end, SFX_CONFIRM)
end

function var0_0.openRatePage(arg0_42)
	local var0_42 = NenjuuGameConfig.ParsingElements(arg0_42:GetMGData():GetRuntimeData("elements") or {})
	local var1_42 = NenjuuGameConfig.GetStageConfig("Spring23Level_" .. arg0_42.stageIndex)

	if not arg0_42.abilityCache[arg0_42.stageIndex] then
		arg0_42.abilityCache[arg0_42.stageIndex] = setmetatable({}, {
			__index = var1_42.ability_config
		})
	end

	setActive(arg0_42.rtLevel:Find("Rate"), true)
	onButton(arg0_42, arg0_42.rtLevel:Find("Rate/bg"), function()
		setActive(arg0_42.rtLevel:Find("Rate"), false)
		arg0_42:openReadyPage()
	end, SFX_CANCEL)

	local var2_42 = arg0_42.rtLevel:Find("Rate/main/panel")
	local var3_42 = var2_0(arg0_42.abilityCache[arg0_42.stageIndex], var1_42.base_rate, var1_42.ability_rate)

	setText(var2_42:Find("info/rate/Text"), var3_42)

	local var4_42 = underscore.filter(NenjuuGameConfig.ABILITY_LIST, function(arg0_44)
		return arg0_42.abilityCache[arg0_42.stageIndex][arg0_44] ~= nil
	end)
	local var5_42 = var2_42:Find("view/content")
	local var6_42 = UIItemList.New(var5_42, var5_42:Find("tpl"))

	var6_42:make(function(arg0_45, arg1_45, arg2_45)
		arg1_45 = arg1_45 + 1

		if arg0_45 == UIItemList.EventUpdate then
			local var0_45 = var4_42[arg1_45]

			setActive(arg2_45:Find("empty"), not var0_45)
			setActive(arg2_45:Find("enable"), var0_45)

			if var0_45 then
				local var1_45 = arg2_45:Find("enable")

				eachChild(var1_45:Find("icon"), function(arg0_46)
					setActive(arg0_46, arg0_46.name == var0_45)
				end)

				local var2_45 = string.split(i18n("2023spring_minigame_nenjuu_skill" .. table.indexof(NenjuuGameConfig.ABILITY_LIST, var0_45)), "|")

				setText(var1_45:Find("name/Text"), var2_45[1])
				setText(var1_45:Find("desc"), var2_45[2])
				onToggle(arg0_42, var1_45:Find("toggle"), function(arg0_47)
					arg0_42.abilityCache[arg0_42.stageIndex][var0_45] = arg0_47

					local var0_47 = var2_0(arg0_42.abilityCache[arg0_42.stageIndex], var1_42.base_rate, var1_42.ability_rate) - var3_42

					setText(var2_42:Find("info/delta"), (var0_47 < 0 and "" or "+") .. var0_47)
				end)
				triggerToggle(var1_45:Find("toggle"), arg0_42.abilityCache[arg0_42.stageIndex][var0_45])
			end
		end
	end)
	var6_42:align(math.min(#var4_42 + 1, #NenjuuGameConfig.ABILITY_LIST))
end

function var0_0.initControllerUI(arg0_48)
	local var0_48 = arg0_48._tf:Find("Controller/top")

	onButton(arg0_48, var0_48:Find("btn_back"), function()
		arg0_48:openUI("exit")
	end, SFX_PANEL)
	onButton(arg0_48, var0_48:Find("btn_pause"), function()
		arg0_48:openUI("pause")
	end)
end

function var0_0.SaveDataChange(arg0_51, arg1_51)
	local var0_51 = {}

	table.insert(var0_51, arg1_51.high)
	table.insert(var0_51, arg1_51.count)
	table.insert(var0_51, arg1_51.item and table.indexof(NenjuuGameConfig.ITEM_LIST, arg1_51.item) or 0)

	for iter0_51 = 1, 7 do
		table.insert(var0_51, arg1_51["stage_" .. iter0_51])
	end

	for iter1_51, iter2_51 in ipairs({
		"bomb",
		"lantern",
		"ice",
		"flash",
		"rush",
		"blessing",
		"decoy"
	}) do
		table.insert(var0_51, arg1_51.level[iter2_51])
	end

	arg0_51:StoreDataToServer(var0_51)
end

function var0_0.didEnter(arg0_52)
	arg0_52:initPageUI()
	arg0_52:initLeveUI()
	arg0_52:initControllerUI()

	arg0_52.abilityCache = {}
	arg0_52.gameController = NenjuuGameController.New(arg0_52, arg0_52._tf)

	arg0_52:openUI("main")
end

function var0_0.onBackPressed(arg0_53)
	switch(arg0_53.status, {
		main = function()
			if isActive(arg0_53.rtLevel:Find("Opreation")) then
				triggerButton(arg0_53.rtLevel:Find("Opreation/btn_back"))

				return
			end

			if isActive(arg0_53.rtLevel:Find("Ready")) then
				triggerButton(arg0_53.rtLevel:Find("Ready/bg"))

				return
			end

			if isActive(arg0_53.rtLevel:Find("Rate")) then
				triggerButton(arg0_53.rtLevel:Find("Rate/bg"))

				return
			end

			var0_0.super.onBackPressed(arg0_53)
		end,
		countdown = function()
			return
		end,
		pause = function()
			arg0_53:openUI()
			arg0_53.gameController:ResumeGame()
		end,
		exit = function()
			arg0_53:openUI()
			arg0_53.gameController:ResumeGame()
		end,
		result = function()
			return
		end
	}, function()
		assert(arg0_53.gameController.isStart)
		arg0_53:openUI("pause")
	end)
end

function var0_0.willExit(arg0_60)
	return
end

return var0_0
