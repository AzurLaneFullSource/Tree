local var0 = class("NenjuuMiniGameView", import("view.miniGame.BaseMiniGameView"))

function var0.getUIName(arg0)
	return "NenjuuMiniGameUI"
end

function var0.openUI(arg0, arg1)
	if arg0.status then
		setActive(arg0.rtTitlePage:Find(arg0.status), false)
	end

	if arg1 then
		setActive(arg0.rtTitlePage:Find(arg1), true)
	end

	arg0.status = arg1

	switch(arg1, {
		main = function()
			arg0:updateMainUI()
		end,
		pause = function()
			arg0.gameController:PauseGame()
		end,
		exit = function()
			arg0.gameController:PauseGame()
		end,
		result = function()
			local var0 = NenjuuGameConfig.ParsingElements(arg0:GetMGData():GetRuntimeData("elements") or {})
			local var1 = arg0.gameController.point
			local var2 = var0.high
			local var3 = arg0.rtTitlePage:Find("result")

			setActive(var3:Find("window/now/new"), var2 < var1)

			if var2 <= var1 then
				var2 = var1
				var0.high = var1
			end

			var0.count = var0.count + var1

			arg0:SaveDataChange(var0)
			setText(var3:Find("window/high/Text"), var2)
			setText(var3:Find("window/now/Text"), var1)

			local var4 = arg0:GetMGHubData()

			if arg0.stageIndex == var4.usedtime + 1 and var4.count > 0 then
				arg0:SendSuccess(0)
			end
		end
	})
end

function var0.updateMainUI(arg0)
	local var0 = arg0:GetMGHubData()
	local var1 = var0:getConfig("reward_need")
	local var2 = var0.usedtime
	local var3 = var2 + var0.count
	local var4 = math.min(var0.usedtime + 1, var3)
	local var5 = arg0.itemList.container
	local var6 = var5.childCount

	for iter0 = 1, var6 do
		local var7 = {}

		if iter0 <= var2 then
			var7.finish = true
		elseif iter0 <= var3 then
			-- block empty
		else
			var7.lock = true
		end

		local var8 = var5:GetChild(iter0 - 1)

		setActive(var8:Find("finish"), var7.finish)
		setActive(var8:Find("lock"), var7.lock)
		setToggleEnabled(var8, iter0 <= var4)
		triggerToggle(var8, iter0 == var4)
	end

	local var9 = var5:GetChild(0).anchoredPosition.y - var5:GetChild(var4 - 1).anchoredPosition.y
	local var10 = var5.rect.height
	local var11 = var5:GetComponent(typeof(ScrollRect)).viewport.rect.height
	local var12 = math.clamp(var9, 0, var10 - var11) / (var10 - var11)

	scrollTo(var5, nil, 1 - var12)
	arg0:checkGet()
end

function var0.checkGet(arg0)
	local var0 = arg0:GetMGHubData()

	if var0.ultimate == 0 then
		if var0.usedtime < var0:getConfig("reward_need") then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0.initPageUI(arg0)
	arg0.rtTitlePage = arg0._tf:Find("TitlePage")

	local var0 = arg0.rtTitlePage:Find("main")

	onButton(arg0, var0:Find("btn_back"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, var0:Find("btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["2023spring_minigame_help"].tip
		})
	end, SFX_PANEL)
	onButton(arg0, var0:Find("btn_opreation"), function()
		setActive(arg0.rtLevel:Find("Opreation"), true)
		arg0:UpdateOpreationPage(1)
	end, SFX_PANEL)

	local var1 = arg0:GetMGData():GetSimpleValue("story")

	onButton(arg0, var0:Find("btn_start"), function()
		local var0 = {}
		local var1 = checkExist(var1, {
			arg0.stageIndex
		}, {
			1
		})

		if var1 then
			table.insert(var0, function(arg0)
				pg.NewStoryMgr.GetInstance():Play(var1, arg0)
			end)
		end

		seriesAsync(var0, function()
			arg0:openReadyPage()
		end)
	end, SFX_PANEL)

	arg0.stageIndex = 0

	local var2 = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop
	local var3 = var0:Find("side_panel/award/content")

	arg0.itemList = UIItemList.New(var3, var3:GetChild(0))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2:Find("IconTpl")
			local var1 = {}

			var1.type, var1.id, var1.count = unpack(var2[arg1])

			updateDrop(var0, var1)
			onButton(arg0, var0, function()
				arg0:emit(var0.ON_DROP, var1)
			end, SFX_PANEL)
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.stageIndex = arg1
				end
			end)
		end
	end)
	arg0.itemList:align(#var2)
	arg0.rtTitlePage:Find("countdown"):Find("bg/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:openUI()
		arg0.gameController:StartGame()
	end)

	local var4 = arg0.rtTitlePage:Find("pause")

	onButton(arg0, var4:Find("window/btn_confirm"), function()
		arg0:openUI()
		arg0.gameController:ResumeGame()
	end, SFX_CONFIRM)

	local var5 = arg0.rtTitlePage:Find("exit")

	onButton(arg0, var5:Find("window/btn_cancel"), function()
		arg0:openUI()
		arg0.gameController:ResumeGame()
	end, SFX_CANCEL)
	onButton(arg0, var5:Find("window/btn_confirm"), function()
		arg0:openUI()
		arg0.gameController:EndGame()
	end, SFX_CONFIRM)

	local var6 = arg0.rtTitlePage:Find("result")

	onButton(arg0, var6:Find("window/btn_finish"), function()
		arg0:openUI("main")
	end, SFX_CONFIRM)
end

function var0.initLeveUI(arg0)
	arg0.rtLevel = arg0._tf:Find("LevelPage")

	local var0 = arg0.rtLevel:Find("Opreation")

	onButton(arg0, var0:Find("btn_back"), function()
		setActive(var0, false)
	end, SFX_CANCEL)
end

local var1 = {
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

function var0.UpdateOpreationPage(arg0, arg1)
	local var0 = arg0.rtLevel:Find("Opreation")
	local var1 = NenjuuGameConfig.ParsingElements(arg0:GetMGData():GetRuntimeData("elements") or {})

	setText(var0:Find("point/Text"), var1.count)

	local var2 = {
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
	local var3
	local var4 = var0:Find("main/view/content")
	local var5 = UIItemList.New(var4, var4:Find("tpl"))

	var5:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var3[arg1]

			setActive(arg2:Find("empty"), not var0)
			setActive(arg2:Find("info"), var0)

			if var0 then
				local var1 = arg2:Find("info")

				eachChild(var1:Find("icon"), function(arg0)
					setActive(arg0, arg0.name == var0)
				end)

				local var2 = string.split(i18n(var1[var0][1]), "|")

				setText(var1:Find("name/Text"), var2[1])
				setText(var1:Find("desc"), var2[2])
				setActive(var1:Find("level"), var1[var0][2])

				if var1[var0][2] then
					local var3 = string.split(i18n(var1[var0][2]), "|")

					for iter0 = 1, 3 do
						local var4 = var1:Find("level/" .. iter0)

						setActive(var4, var3[iter0])

						if var3[iter0] then
							setTextColor(var4:Find("Text"), Color.NewHex(iter0 > var1.level[var0] and "8D90AFFF" or "535885FF"))
							changeToScrollText(var4:Find("info"), setColorStr(var3[iter0], iter0 > var1.level[var0] and "#8D90AFFF" or "#535885FF"))
						end
					end
				end

				eachChild(var1:Find("status"), function(arg0)
					setActive(arg0, false)
				end)
				onButton(arg0, var1:Find("status/btn_equip"), function()
					var1.item = var0

					arg0:SaveDataChange(var1)
					arg0:UpdateOpreationPage(arg1)
				end, SFX_CONFIRM)
				onButton(arg0, var1:Find("status/btn_unlock"), function()
					var1.count = var1.count - NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0].cost[var1.level[var0] + 1]
					var1.level[var0] = var1.level[var0] + 1

					if var1.level[var0] > 1 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("2023spring_minigame_tip7", var2[1]))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("2023spring_minigame_tip6", var2[1]))
					end

					arg0:SaveDataChange(var1)
					arg0:UpdateOpreationPage(arg1)
				end, SFX_CONFIRM)

				if var1.level[var0] < #NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0].cost then
					local var5 = NenjuuGameConfig.SKILL_LEVEL_CONFIG[var0].cost[var1.level[var0] + 1]

					if var5 > var1.count then
						setText(var1:Find("status/btn_lock/point"), var5)
						setText(var1:Find("status/btn_lock/Text"), i18n("2023spring_minigame_tip3"))
						setActive(var1:Find("status/btn_lock"), true)
					else
						setText(var1:Find("status/btn_unlock/point"), var5)
						setText(var1:Find("status/btn_unlock/Text"), i18n("2023spring_minigame_tip3"))
						setActive(var1:Find("status/btn_unlock"), true)
					end
				elseif var0 == "bomb" or var0 == "lantern" then
					setText(var1:Find("status/btn_equip/Text"), i18n("2023spring_minigame_tip1"))
					setActive(var1:Find("status/btn_equip"), var1.item ~= var0)
					setText(var1:Find("status/btn_in/Text"), i18n("2023spring_minigame_tip2"))
					setActive(var1:Find("status/btn_in"), var1.item == var0)
				else
					setActive(var1:Find("status/unlock"), true)
				end
			end
		end
	end)

	for iter0, iter1 in ipairs(var2) do
		onToggle(arg0, var0:Find("toggles/" .. iter0), function(arg0)
			arg1 = iter0
			var3 = iter1

			var5:align(4)
			setActive(var0:Find("main/tip"), iter0 == 1)
		end, SFX_PANEL)
	end

	triggerToggle(var0:Find("toggles/" .. arg1), true)
end

local function var2(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(NenjuuGameConfig.ABILITY_LIST) do
		if arg0[iter1] then
			arg1 = arg1 + arg2[iter1]
		end
	end

	return arg1
end

function var0.openReadyPage(arg0)
	local var0 = NenjuuGameConfig.ParsingElements(arg0:GetMGData():GetRuntimeData("elements") or {})
	local var1 = NenjuuGameConfig.GetStageConfig("Spring23Level_" .. arg0.stageIndex)

	if not arg0.abilityCache[arg0.stageIndex] then
		arg0.abilityCache[arg0.stageIndex] = setmetatable({}, {
			__index = var1.ability_config
		})
	end

	setActive(arg0.rtLevel:Find("Ready"), true)
	onButton(arg0, arg0.rtLevel:Find("Ready/bg"), function()
		setActive(arg0.rtLevel:Find("Ready"), false)
	end, SFX_CANCEL)

	local var2 = arg0.rtLevel:Find("Ready/main")

	eachChild(var2:Find("title"), function(arg0)
		setActive(arg0, arg0.name == tostring(arg0.stageIndex))
	end)
	setText(var2:Find("rate/Image/Text"), var2(arg0.abilityCache[arg0.stageIndex], var1.base_rate, var1.ability_rate))
	setText(var2:Find("high/Image/Text"), var0["stage_" .. arg0.stageIndex])
	setText(var2:Find("ability_text/Text"), i18n("2023spring_minigame_tip5"))

	local var3 = underscore.filter(NenjuuGameConfig.ABILITY_LIST, function(arg0)
		return arg0.abilityCache[arg0.stageIndex][arg0]
	end)
	local var4 = UIItemList.New(var2:Find("abilitys"), var2:Find("abilitys/tpl"))

	var4:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("empty"), not var3[arg1])
			setActive(arg2:Find("enable"), var3[arg1])

			if var3[arg1] then
				eachChild(arg2:Find("enable"), function(arg0)
					setActive(arg0, arg0.name == var3[arg1])
				end)
			end
		end
	end)
	var4:align(#NenjuuGameConfig.ABILITY_LIST)
	onButton(arg0, var2:Find("btn_rate"), function()
		setActive(arg0.rtLevel:Find("Ready"), false)
		arg0:openRatePage()
	end, SFX_PANEL)
	onButton(arg0, var2:Find("btn_continue"), function()
		setActive(arg0.rtLevel:Find("Ready"), false)
		arg0.gameController:ResetGame()
		arg0.gameController:ReadyGame({
			index = arg0.stageIndex,
			FuShun = NenjuuGameConfig.ParsingElements(arg0:GetMGData():GetRuntimeData("elements") or {}),
			Nenjuu = arg0.abilityCache[arg0.stageIndex],
			rate = var2(arg0.abilityCache[arg0.stageIndex], var1.base_rate, var1.ability_rate)
		})
		arg0:openUI("countdown")
	end, SFX_CONFIRM)
end

function var0.openRatePage(arg0)
	local var0 = NenjuuGameConfig.ParsingElements(arg0:GetMGData():GetRuntimeData("elements") or {})
	local var1 = NenjuuGameConfig.GetStageConfig("Spring23Level_" .. arg0.stageIndex)

	if not arg0.abilityCache[arg0.stageIndex] then
		arg0.abilityCache[arg0.stageIndex] = setmetatable({}, {
			__index = var1.ability_config
		})
	end

	setActive(arg0.rtLevel:Find("Rate"), true)
	onButton(arg0, arg0.rtLevel:Find("Rate/bg"), function()
		setActive(arg0.rtLevel:Find("Rate"), false)
		arg0:openReadyPage()
	end, SFX_CANCEL)

	local var2 = arg0.rtLevel:Find("Rate/main/panel")
	local var3 = var2(arg0.abilityCache[arg0.stageIndex], var1.base_rate, var1.ability_rate)

	setText(var2:Find("info/rate/Text"), var3)

	local var4 = underscore.filter(NenjuuGameConfig.ABILITY_LIST, function(arg0)
		return arg0.abilityCache[arg0.stageIndex][arg0] ~= nil
	end)
	local var5 = var2:Find("view/content")
	local var6 = UIItemList.New(var5, var5:Find("tpl"))

	var6:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var4[arg1]

			setActive(arg2:Find("empty"), not var0)
			setActive(arg2:Find("enable"), var0)

			if var0 then
				local var1 = arg2:Find("enable")

				eachChild(var1:Find("icon"), function(arg0)
					setActive(arg0, arg0.name == var0)
				end)

				local var2 = string.split(i18n("2023spring_minigame_nenjuu_skill" .. table.indexof(NenjuuGameConfig.ABILITY_LIST, var0)), "|")

				setText(var1:Find("name/Text"), var2[1])
				setText(var1:Find("desc"), var2[2])
				onToggle(arg0, var1:Find("toggle"), function(arg0)
					arg0.abilityCache[arg0.stageIndex][var0] = arg0

					local var0 = var2(arg0.abilityCache[arg0.stageIndex], var1.base_rate, var1.ability_rate) - var3

					setText(var2:Find("info/delta"), (var0 < 0 and "" or "+") .. var0)
				end)
				triggerToggle(var1:Find("toggle"), arg0.abilityCache[arg0.stageIndex][var0])
			end
		end
	end)
	var6:align(math.min(#var4 + 1, #NenjuuGameConfig.ABILITY_LIST))
end

function var0.initControllerUI(arg0)
	local var0 = arg0._tf:Find("Controller/top")

	onButton(arg0, var0:Find("btn_back"), function()
		arg0:openUI("exit")
	end, SFX_PANEL)
	onButton(arg0, var0:Find("btn_pause"), function()
		arg0:openUI("pause")
	end)
end

function var0.SaveDataChange(arg0, arg1)
	local var0 = {}

	table.insert(var0, arg1.high)
	table.insert(var0, arg1.count)
	table.insert(var0, arg1.item and table.indexof(NenjuuGameConfig.ITEM_LIST, arg1.item) or 0)

	for iter0 = 1, 7 do
		table.insert(var0, arg1["stage_" .. iter0])
	end

	for iter1, iter2 in ipairs({
		"bomb",
		"lantern",
		"ice",
		"flash",
		"rush",
		"blessing",
		"decoy"
	}) do
		table.insert(var0, arg1.level[iter2])
	end

	arg0:StoreDataToServer(var0)
end

function var0.didEnter(arg0)
	arg0:initPageUI()
	arg0:initLeveUI()
	arg0:initControllerUI()

	arg0.abilityCache = {}
	arg0.gameController = NenjuuGameController.New(arg0, arg0._tf)

	arg0:openUI("main")
end

function var0.onBackPressed(arg0)
	switch(arg0.status, {
		main = function()
			if isActive(arg0.rtLevel:Find("Opreation")) then
				triggerButton(arg0.rtLevel:Find("Opreation/btn_back"))

				return
			end

			if isActive(arg0.rtLevel:Find("Ready")) then
				triggerButton(arg0.rtLevel:Find("Ready/bg"))

				return
			end

			if isActive(arg0.rtLevel:Find("Rate")) then
				triggerButton(arg0.rtLevel:Find("Rate/bg"))

				return
			end

			var0.super.onBackPressed(arg0)
		end,
		countdown = function()
			return
		end,
		pause = function()
			arg0:openUI()
			arg0.gameController:ResumeGame()
		end,
		exit = function()
			arg0:openUI()
			arg0.gameController:ResumeGame()
		end,
		result = function()
			return
		end
	}, function()
		assert(arg0.gameController.isStart)
		arg0:openUI("pause")
	end)
end

function var0.willExit(arg0)
	return
end

return var0
