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
	onButton(arg0_9, var0_9:Find("btn_home"), function()
		arg0_9:emit(BaseUI.ON_HOME)
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
		local var0_14 = {}
		local var1_14 = checkExist(var1_9, {
			arg0_9.stageIndex
		}, {
			1
		})

		if var1_14 then
			table.insert(var0_14, function(arg0_15)
				pg.NewStoryMgr.GetInstance():Play(var1_14, arg0_15)
			end)
		end

		seriesAsync(var0_14, function()
			arg0_9:openReadyPage()
		end)
	end, SFX_PANEL)

	arg0_9.stageIndex = 0

	local var2_9 = pg.mini_game[arg0_9:GetMGData().id].simple_config_data.drop
	local var3_9 = var0_9:Find("side_panel/award/content")

	arg0_9.itemList = UIItemList.New(var3_9, var3_9:GetChild(0))

	arg0_9.itemList:make(function(arg0_17, arg1_17, arg2_17)
		arg1_17 = arg1_17 + 1

		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg2_17:Find("IconTpl")
			local var1_17 = {}

			var1_17.type, var1_17.id, var1_17.count = unpack(var2_9[arg1_17])

			updateDrop(var0_17, var1_17)
			onButton(arg0_9, var0_17, function()
				arg0_9:emit(var0_0.ON_DROP, var1_17)
			end, SFX_PANEL)
			onToggle(arg0_9, arg2_17, function(arg0_19)
				if arg0_19 then
					arg0_9.stageIndex = arg1_17
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

function var0_0.initLeveUI(arg0_25)
	arg0_25.rtLevel = arg0_25._tf:Find("LevelPage")

	local var0_25 = arg0_25.rtLevel:Find("Opreation")

	onButton(arg0_25, var0_25:Find("btn_back"), function()
		setActive(var0_25, false)
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

function var0_0.UpdateOpreationPage(arg0_27, arg1_27)
	local var0_27 = arg0_27.rtLevel:Find("Opreation")
	local var1_27 = NenjuuGameConfig.ParsingElements(arg0_27:GetMGData():GetRuntimeData("elements") or {})

	setText(var0_27:Find("point/Text"), var1_27.count)

	local var2_27 = {
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
	local var3_27
	local var4_27 = var0_27:Find("main/view/content")
	local var5_27 = UIItemList.New(var4_27, var4_27:Find("tpl"))

	var5_27:make(function(arg0_28, arg1_28, arg2_28)
		arg1_28 = arg1_28 + 1

		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = var3_27[arg1_28]

			setActive(arg2_28:Find("empty"), not var0_28)
			setActive(arg2_28:Find("info"), var0_28)

			if var0_28 then
				local var1_28 = arg2_28:Find("info")

				eachChild(var1_28:Find("icon"), function(arg0_29)
					setActive(arg0_29, arg0_29.name == var0_28)
				end)

				local var2_28 = string.split(i18n(var1_0[var0_28][1]), "|")

				setText(var1_28:Find("name/Text"), var2_28[1])
				setText(var1_28:Find("desc"), var2_28[2])
				setActive(var1_28:Find("level"), var1_0[var0_28][2])

				if var1_0[var0_28][2] then
					local var3_28 = string.split(i18n(var1_0[var0_28][2]), "|")

					for iter0_28 = 1, 3 do
						local var4_28 = var1_28:Find("level/" .. iter0_28)

						setActive(var4_28, var3_28[iter0_28])

						if var3_28[iter0_28] then
							setTextColor(var4_28:Find("Text"), Color.NewHex(iter0_28 > var1_27.level[var0_28] and "8D90AFFF" or "535885FF"))
							changeToScrollText(var4_28:Find("info"), setColorStr(var3_28[iter0_28], iter0_28 > var1_27.level[var0_28] and "#8D90AFFF" or "#535885FF"))
						end
					end
				end

				eachChild(var1_28:Find("status"), function(arg0_30)
					setActive(arg0_30, false)
				end)
				onButton(arg0_27, var1_28:Find("status/btn_equip"), function()
					var1_27.item = var0_28

					arg0_27:SaveDataChange(var1_27)
					arg0_27:UpdateOpreationPage(arg1_27)
				end, SFX_CONFIRM)
				onButton(arg0_27, var1_28:Find("status/btn_unlock"), function()
					var1_27.count = var1_27.count - NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0_28].cost[var1_27.level[var0_28] + 1]
					var1_27.level[var0_28] = var1_27.level[var0_28] + 1

					if var1_27.level[var0_28] > 1 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("2023spring_minigame_tip7", var2_28[1]))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("2023spring_minigame_tip6", var2_28[1]))
					end

					arg0_27:SaveDataChange(var1_27)
					arg0_27:UpdateOpreationPage(arg1_27)
				end, SFX_CONFIRM)

				if var1_27.level[var0_28] < #NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0_28].cost then
					local var5_28 = NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0_28].cost[var1_27.level[var0_28] + 1]

					if var5_28 > var1_27.count then
						setText(var1_28:Find("status/btn_lock/point"), var5_28)
						setText(var1_28:Find("status/btn_lock/Text"), i18n("2023spring_minigame_tip3"))
						setActive(var1_28:Find("status/btn_lock"), true)
					else
						setText(var1_28:Find("status/btn_unlock/point"), var5_28)
						setText(var1_28:Find("status/btn_unlock/Text"), i18n("2023spring_minigame_tip3"))
						setActive(var1_28:Find("status/btn_unlock"), true)
					end
				elseif var0_28 == "bomb" or var0_28 == "lantern" then
					setText(var1_28:Find("status/btn_equip/Text"), i18n("2023spring_minigame_tip1"))
					setActive(var1_28:Find("status/btn_equip"), var1_27.item ~= var0_28)
					setText(var1_28:Find("status/btn_in/Text"), i18n("2023spring_minigame_tip2"))
					setActive(var1_28:Find("status/btn_in"), var1_27.item == var0_28)
				else
					setActive(var1_28:Find("status/unlock"), true)
				end
			end
		end
	end)

	for iter0_27, iter1_27 in ipairs(var2_27) do
		onToggle(arg0_27, var0_27:Find("toggles/" .. iter0_27), function(arg0_33)
			arg1_27 = iter0_27
			var3_27 = iter1_27

			var5_27:align(4)
			setActive(var0_27:Find("main/tip"), iter0_27 == 1)
		end, SFX_PANEL)
	end

	triggerToggle(var0_27:Find("toggles/" .. arg1_27), true)
end

local function var2_0(arg0_34, arg1_34, arg2_34)
	for iter0_34, iter1_34 in ipairs(NenjuuGameConfig.ABILITY_LIST) do
		if arg0_34[iter1_34] then
			arg1_34 = arg1_34 + arg2_34[iter1_34]
		end
	end

	return arg1_34
end

function var0_0.openReadyPage(arg0_35)
	local var0_35 = NenjuuGameConfig.ParsingElements(arg0_35:GetMGData():GetRuntimeData("elements") or {})
	local var1_35 = NenjuuGameConfig.GetStageConfig("Spring23Level_" .. arg0_35.stageIndex)

	if not arg0_35.abilityCache[arg0_35.stageIndex] then
		arg0_35.abilityCache[arg0_35.stageIndex] = setmetatable({}, {
			__index = var1_35.ability_config
		})
	end

	setActive(arg0_35.rtLevel:Find("Ready"), true)
	onButton(arg0_35, arg0_35.rtLevel:Find("Ready/bg"), function()
		setActive(arg0_35.rtLevel:Find("Ready"), false)
	end, SFX_CANCEL)

	local var2_35 = arg0_35.rtLevel:Find("Ready/main")

	eachChild(var2_35:Find("title"), function(arg0_37)
		setActive(arg0_37, arg0_37.name == tostring(arg0_35.stageIndex))
	end)
	setText(var2_35:Find("rate/Image/Text"), var2_0(arg0_35.abilityCache[arg0_35.stageIndex], var1_35.base_rate, var1_35.ability_rate))
	setText(var2_35:Find("high/Image/Text"), var0_35["stage_" .. arg0_35.stageIndex])
	setText(var2_35:Find("ability_text/Text"), i18n("2023spring_minigame_tip5"))

	local var3_35 = underscore.filter(NenjuuGameConfig.ABILITY_LIST, function(arg0_38)
		return arg0_35.abilityCache[arg0_35.stageIndex][arg0_38]
	end)
	local var4_35 = UIItemList.New(var2_35:Find("abilitys"), var2_35:Find("abilitys/tpl"))

	var4_35:make(function(arg0_39, arg1_39, arg2_39)
		arg1_39 = arg1_39 + 1

		if arg0_39 == UIItemList.EventUpdate then
			setActive(arg2_39:Find("empty"), not var3_35[arg1_39])
			setActive(arg2_39:Find("enable"), var3_35[arg1_39])

			if var3_35[arg1_39] then
				eachChild(arg2_39:Find("enable"), function(arg0_40)
					setActive(arg0_40, arg0_40.name == var3_35[arg1_39])
				end)
			end
		end
	end)
	var4_35:align(#NenjuuGameConfig.ABILITY_LIST)
	onButton(arg0_35, var2_35:Find("btn_rate"), function()
		setActive(arg0_35.rtLevel:Find("Ready"), false)
		arg0_35:openRatePage()
	end, SFX_PANEL)
	onButton(arg0_35, var2_35:Find("btn_continue"), function()
		setActive(arg0_35.rtLevel:Find("Ready"), false)
		arg0_35.gameController:ResetGame()
		arg0_35.gameController:ReadyGame({
			index = arg0_35.stageIndex,
			FuShun = NenjuuGameConfig.ParsingElements(arg0_35:GetMGData():GetRuntimeData("elements") or {}),
			Nenjuu = arg0_35.abilityCache[arg0_35.stageIndex],
			rate = var2_0(arg0_35.abilityCache[arg0_35.stageIndex], var1_35.base_rate, var1_35.ability_rate)
		})
		arg0_35:openUI("countdown")
	end, SFX_CONFIRM)
end

function var0_0.openRatePage(arg0_43)
	local var0_43 = NenjuuGameConfig.ParsingElements(arg0_43:GetMGData():GetRuntimeData("elements") or {})
	local var1_43 = NenjuuGameConfig.GetStageConfig("Spring23Level_" .. arg0_43.stageIndex)

	if not arg0_43.abilityCache[arg0_43.stageIndex] then
		arg0_43.abilityCache[arg0_43.stageIndex] = setmetatable({}, {
			__index = var1_43.ability_config
		})
	end

	setActive(arg0_43.rtLevel:Find("Rate"), true)
	onButton(arg0_43, arg0_43.rtLevel:Find("Rate/bg"), function()
		setActive(arg0_43.rtLevel:Find("Rate"), false)
		arg0_43:openReadyPage()
	end, SFX_CANCEL)

	local var2_43 = arg0_43.rtLevel:Find("Rate/main/panel")
	local var3_43 = var2_0(arg0_43.abilityCache[arg0_43.stageIndex], var1_43.base_rate, var1_43.ability_rate)

	setText(var2_43:Find("info/rate/Text"), var3_43)

	local var4_43 = underscore.filter(NenjuuGameConfig.ABILITY_LIST, function(arg0_45)
		return arg0_43.abilityCache[arg0_43.stageIndex][arg0_45] ~= nil
	end)
	local var5_43 = var2_43:Find("view/content")
	local var6_43 = UIItemList.New(var5_43, var5_43:Find("tpl"))

	var6_43:make(function(arg0_46, arg1_46, arg2_46)
		arg1_46 = arg1_46 + 1

		if arg0_46 == UIItemList.EventUpdate then
			local var0_46 = var4_43[arg1_46]

			setActive(arg2_46:Find("empty"), not var0_46)
			setActive(arg2_46:Find("enable"), var0_46)

			if var0_46 then
				local var1_46 = arg2_46:Find("enable")

				eachChild(var1_46:Find("icon"), function(arg0_47)
					setActive(arg0_47, arg0_47.name == var0_46)
				end)

				local var2_46 = string.split(i18n("2023spring_minigame_nenjuu_skill" .. table.indexof(NenjuuGameConfig.ABILITY_LIST, var0_46)), "|")

				setText(var1_46:Find("name/Text"), var2_46[1])
				setText(var1_46:Find("desc"), var2_46[2])
				onToggle(arg0_43, var1_46:Find("toggle"), function(arg0_48)
					arg0_43.abilityCache[arg0_43.stageIndex][var0_46] = arg0_48

					local var0_48 = var2_0(arg0_43.abilityCache[arg0_43.stageIndex], var1_43.base_rate, var1_43.ability_rate) - var3_43

					setText(var2_43:Find("info/delta"), (var0_48 < 0 and "" or "+") .. var0_48)
				end)
				triggerToggle(var1_46:Find("toggle"), arg0_43.abilityCache[arg0_43.stageIndex][var0_46])
			end
		end
	end)
	var6_43:align(math.min(#var4_43 + 1, #NenjuuGameConfig.ABILITY_LIST))
end

function var0_0.initControllerUI(arg0_49)
	local var0_49 = arg0_49._tf:Find("Controller/top")

	onButton(arg0_49, var0_49:Find("btn_back"), function()
		arg0_49:openUI("exit")
	end, SFX_PANEL)
	onButton(arg0_49, var0_49:Find("btn_pause"), function()
		arg0_49:openUI("pause")
	end)
end

function var0_0.SaveDataChange(arg0_52, arg1_52)
	local var0_52 = {}

	table.insert(var0_52, arg1_52.high)
	table.insert(var0_52, arg1_52.count)
	table.insert(var0_52, arg1_52.item and table.indexof(NenjuuGameConfig.ITEM_LIST, arg1_52.item) or 0)

	for iter0_52 = 1, 7 do
		table.insert(var0_52, arg1_52["stage_" .. iter0_52])
	end

	for iter1_52, iter2_52 in ipairs({
		"bomb",
		"lantern",
		"ice",
		"flash",
		"rush",
		"blessing",
		"decoy"
	}) do
		table.insert(var0_52, arg1_52.level[iter2_52])
	end

	arg0_52:StoreDataToServer(var0_52)
end

function var0_0.didEnter(arg0_53)
	arg0_53:initPageUI()
	arg0_53:initLeveUI()
	arg0_53:initControllerUI()

	arg0_53.abilityCache = {}
	arg0_53.gameController = NenjuuGameController.New(arg0_53, arg0_53._tf)

	arg0_53:openUI("main")
end

function var0_0.onBackPressed(arg0_54)
	switch(arg0_54.status, {
		main = function()
			if isActive(arg0_54.rtLevel:Find("Opreation")) then
				triggerButton(arg0_54.rtLevel:Find("Opreation/btn_back"))

				return
			end

			if isActive(arg0_54.rtLevel:Find("Ready")) then
				triggerButton(arg0_54.rtLevel:Find("Ready/bg"))

				return
			end

			if isActive(arg0_54.rtLevel:Find("Rate")) then
				triggerButton(arg0_54.rtLevel:Find("Rate/bg"))

				return
			end

			var0_0.super.onBackPressed(arg0_54)
		end,
		countdown = function()
			return
		end,
		pause = function()
			arg0_54:openUI()
			arg0_54.gameController:ResumeGame()
		end,
		exit = function()
			arg0_54:openUI()
			arg0_54.gameController:ResumeGame()
		end,
		result = function()
			return
		end
	}, function()
		assert(arg0_54.gameController.isStart)
		arg0_54:openUI("pause")
	end)
end

function var0_0.willExit(arg0_61)
	return
end

return var0_0
