local var0 = class("BossRushFleetSelectView", import("view.base.BaseUI"))
local var1 = {
	vanguard = 1,
	submarine = 3,
	main = 2
}

function var0.getUIName(arg0)
	return "BossRushFleetSelectUI"
end

function var0.init(arg0)
	arg0:InitUI()
end

function var0.InitUI(arg0)
	local var0 = arg0._tf:Find("Panel")

	arg0.tfFleets = {
		[FleetType.Normal] = arg0:findTF("Panel/Fleet/Normal"),
		[FleetType.Submarine] = arg0:findTF("Panel/Fleet/Submarine")
	}
	arg0.btnRecommend = var0:Find("Fleet/BtnRecommend")
	arg0.btnClear = var0:Find("Fleet/BtnClear")
	arg0.rtCostLimit = var0:Find("Fleet/CostLimit")
	arg0.commanderList = var0:Find("Fleet/Commander")
	arg0.fleetIndexToggles = _.map(_.range(var0:Find("Fleet/Indexes").childCount), function(arg0)
		return var0:Find("Fleet/Indexes"):GetChild(arg0 - 1)
	end)
	arg0.modeToggles = {
		var0:Find("Info/Modes/Single"),
		var0:Find("Info/Modes/Multiple")
	}
	arg0.extraAwardTF = arg0._tf:Find("Panel/Reward/Normal/Mode")
	arg0.sonarRangeContainer = arg0._tf:Find("Panel/Fleet/SonarRange")
	arg0.sonarRangeTexts = {
		arg0._tf:Find("Panel/Fleet/SonarRange/Values"):GetChild(0),
		arg0._tf:Find("Panel/Fleet/SonarRange/Values"):GetChild(1)
	}

	setText(arg0.sonarRangeTexts[2], "")

	arg0.btnBack = var0:Find("Info/Title/BtnClose")
	arg0.btnGo = var0:Find("Info/Start")

	setText(arg0._tf:Find("Panel/Fleet/SonarRange/Text"), i18n("fleet_antisub_range") .. ":")
	setText(arg0._tf:Find("Panel/Fleet/CostLimit/Title"), i18n("formationScene_use_oil_limit_tip_worldboss"))
	setText(arg0._tf:Find("Panel/Reward/Normal/Base/Text"), i18n("series_enemy_reward_tip1"))
	setText(arg0._tf:Find("Panel/Reward/Normal/Mode/Text"), i18n("series_enemy_reward_tip2"))
	setText(arg0._tf:Find("Panel/Reward/EX/Title"), i18n("series_enemy_reward_tip4"))
	setText(arg0._tf:Find("Panel/Reward/Tip"), i18n("limit_team_character_tips"))
	setText(arg0._tf:Find("Panel/Info/Modes/Single/On/Text"), i18n("series_enemy_mode_1"))
	setText(arg0._tf:Find("Panel/Info/Modes/Single/Off/Text"), i18n("series_enemy_mode_1"))
	setText(arg0._tf:Find("Panel/Info/Modes/Multiple/On/Text"), i18n("series_enemy_mode_2"))
	setText(arg0._tf:Find("Panel/Info/Modes/Multiple/Off/Text"), i18n("series_enemy_mode_2"))
	table.Foreach(arg0.fleetIndexToggles, function(arg0, arg1)
		if arg0 >= #arg0.fleetIndexToggles then
			setText(arg1:Find("Text"), i18n("formationScene_use_oil_limit_submarine"))
		else
			setText(arg1:Find("Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg0)))
		end
	end)
	setText(arg0._tf:Find("Panel/Fleet/Normal/main/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
	setText(arg0._tf:Find("Panel/Fleet/Normal/vanguard/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
	setText(arg0._tf:Find("Panel/Fleet/Submarine/submarine/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
end

function var0.didEnter(arg0)
	local var0 = arg0.contextData.seriesData

	onButton(arg0, arg0.btnGo, function()
		for iter0 = 1, #arg0.contextData.fleets - 1 do
			if arg0.contextData.fleets[iter0]:isLegalToFight() ~= true then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_team_notenough"))

				return
			end
		end

		if _.any(arg0.contextData.fleets, function(arg0)
			local var0, var1 = arg0:HaveShipsInEvent()

			if var0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)

				return true
			end
		end) then
			return
		end

		arg0:emit(BossRushFleetSelectMediator.ON_PRECOMBAT)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0, arg0.sonarRangeContainer, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.btnBack, function()
		arg0:onCancelHard()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:onCancelHard()
	end, SFX_CANCEL)

	local var1 = var0:IsSingleFight()

	setActive(arg0.modeToggles[1].parent, var1)

	if var1 then
		table.Foreach(arg0.modeToggles, function(arg0, arg1)
			triggerToggle(arg1, arg0 == arg0.contextData.mode)
		end)
		table.Foreach(arg0.modeToggles, function(arg0, arg1)
			onToggle(arg0, arg1, function(arg0)
				if not arg0 then
					return
				end

				arg0:emit(BossRushFleetSelectMediator.ON_SWITCH_MODE, arg0)
				table.Foreach(arg0.fleetIndexToggles, function(arg0, arg1)
					triggerToggle(arg1, arg0 == arg0.contextData.fleetIndex)
				end)
			end, SFX_PANEL)
		end)
	end

	local var2 = #arg0.contextData.fullFleets

	table.Foreach(arg0.fleetIndexToggles, function(arg0, arg1)
		setActive(arg1, arg0 <= var2 - 1 or arg0 == #arg0.fleetIndexToggles)
	end)

	for iter0 = #arg0.fleetIndexToggles - 1, var2, -1 do
		table.remove(arg0.fleetIndexToggles, iter0)
	end

	local var3 = Color.white
	local var4 = Color.New(1, 1, 1, 0.5)

	local function var5(arg0, arg1)
		setActive(arg0:Find("Selected"), arg1)
		setTextColor(arg0:Find("Text"), arg1 and var3 or var4)
	end

	table.Foreach(arg0.fleetIndexToggles, function(arg0, arg1)
		onToggle(arg0, arg1, function(arg0)
			var5(arg1, arg0)
		end)
	end)
	table.Foreach(arg0.fleetIndexToggles, function(arg0, arg1)
		triggerToggle(arg1, arg0 == arg0.contextData.fleetIndex)
	end)
	table.Foreach(arg0.fleetIndexToggles, function(arg0, arg1)
		onToggle(arg0, arg1, function(arg0)
			var5(arg1, arg0)

			if not arg0 then
				return
			end

			if arg0 == #arg0.fleetIndexToggles then
				arg0.contextData.fleetIndex = #arg0.contextData.fleets
			else
				arg0.contextData.fleetIndex = arg0
			end

			arg0:updateEliteFleets()
		end, SFX_PANEL)
	end)
	setText(arg0._tf:Find("Panel/Info/Title/Text"), var0:GetName())
	setText(arg0._tf:Find("Panel/Info/Title/Text/EN"), var0:GetSeriesCode())
	setText(arg0._tf:Find("Panel/Info/Description/Text"), var0:GetDescription())

	local var6 = var0:GetExpeditionIds()
	local var7 = var0:GetBossIcons()
	local var8 = arg0._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var8, var8:GetChild(0), #var6, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var6[arg1 + 1]
		local var1 = var7[arg1 + 1][1]
		local var2 = pg.expedition_data_template[var0].level
		local var3 = arg2:Find("shiptpl")
		local var4 = findTF(var3, "icon_bg")
		local var5 = findTF(var3, "icon_bg/frame")

		SetCompomentEnabled(var4, "Image", false)
		SetCompomentEnabled(var5, "Image", false)
		setActive(arg2:Find("shiptpl/icon_bg/lv"), false)

		local var6 = arg2:Find("shiptpl/icon_bg/icon")

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1, "", var6)

		local var7 = findTF(var3, "ship_type")

		if var7 then
			setActive(var7, true)
			setImageSprite(var7, GetSpriteFromAtlas("shiptype", shipType2print(var7[arg1 + 1][2])))
		end
	end)

	local function var9(arg0)
		if type(arg0) ~= "table" then
			return {}
		end

		return arg0
	end

	local var10 = var0:GetType() == BossRushSeriesData.TYPE.EXTRA

	setActive(arg0._tf:Find("Panel/Reward/Normal"), not var10)
	setActive(arg0._tf:Find("Panel/Reward/EX"), var10)

	if not var10 then
		local var11 = arg0._tf:Find("Panel/Reward/Normal/Base/Items")
		local var12 = var9(var0:GetPassAwards())

		UIItemList.StaticAlign(var11, var11:GetChild(0), #var12, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var12[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:ShowDropDetail(var1)
			end, SFX_PANEL)
		end)

		local var13 = arg0.extraAwardTF:Find("Items")
		local var14 = var9(var0:GetAdditionalAwards())

		UIItemList.StaticAlign(var13, var13:GetChild(0), #var14, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var14[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:ShowDropDetail(var1)
			end, SFX_PANEL)
		end)
	else
		local var15 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK):GetScore()
		local var16 = arg0._tf:Find("Panel/Reward/EX/Title/Text")

		setText(var16, math.floor(var15))
	end

	arg0:updateEliteFleets()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {})
end

local var2 = {
	[99] = true
}

function var0.ShowDropDetail(arg0, arg1)
	local var0 = Item.getConfigData(arg1.id)

	if var0 and var2[var0.type] then
		local var1 = var0.display_icon
		local var2 = {}

		for iter0, iter1 in ipairs(var1) do
			local var3 = iter1[1]
			local var4 = iter1[2]

			var2[#var2 + 1] = {
				hideName = true,
				type = var3,
				id = var4
			}
		end

		arg0:emit(var0.ON_DROP_LIST, {
			item2Row = true,
			itemList = var2,
			content = var0.display
		})
	else
		arg0:emit(var0.ON_DROP, arg1)
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.onCancelHard(arg0)
	arg0:emit(BossRushFleetSelectMediator.ON_UPDATE_CUSTOM_FLEET)
	arg0:closeView()
end

function var0.onBackPressed(arg0)
	arg0:onCancelHard()
	var0.super.onBackPressed(arg0)
end

function var0.setHardShipVOs(arg0, arg1)
	arg0.shipVOs = arg1
end

function var0.initAddButton(arg0, arg1, arg2, arg3)
	local var0 = arg0.contextData.fleets[arg3]:getShipIds()
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[arg0.shipVOs[iter1]] = true

		if arg2 == arg0.shipVOs[iter1]:getTeamType() then
			table.insert(var2, iter1)
		end
	end

	local var3 = _.map(var0, function(arg0)
		return arg0.shipVOs[arg0]
	end)

	table.sort(var3, function(arg0, arg1)
		return var1[arg0:getTeamType()] < var1[arg1:getTeamType()] or var1[arg0:getTeamType()] == var1[arg1:getTeamType()] and table.indexof(var0, arg0.id) < table.indexof(var0, arg1.id)
	end)

	local var4 = findTF(arg1, arg2)
	local var5 = var4:GetComponent("ContentSizeFitter")
	local var6 = var4:GetComponent("HorizontalLayoutGroup")

	var5.enabled = true
	var6.enabled = true
	arg0.isDraging = false

	UIItemList.StaticAlign(var4, var4:GetChild(0), 3, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var2[arg1] and arg0.shipVOs[var2[arg1]] or nil

		setActive(arg2:Find("Ship"), var0)
		setActive(arg2:Find("Empty"), not var0)

		local var1 = var0 and arg2:Find("Ship") or arg2:Find("Empty")

		if var0 then
			updateShip(var1, var0)
			setActive(var1:Find("EnergyWarn"), arg0.contextData.mode == BossRushSeriesData.MODE.SINGLE and var0:getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value)
			setActive(var1:Find("event_block"), var0:getFlag("inEvent"))
		end

		setActive(var1:Find("ship_type"), false)

		local var2 = GetOrAddComponent(var1, typeof(UILongPressTrigger))

		var2.onLongPressed:RemoveAllListeners()

		if var0 then
			var2.onLongPressed:AddListener(function()
				arg0:emit(BossRushFleetSelectMediator.ON_FLEET_SHIPINFO, {
					shipId = var0.id,
					shipVOs = var3
				})
			end)
		end

		local var3 = GetOrAddComponent(var1, "EventTriggerListener")

		var3:RemovePointClickFunc()
		var3:AddPointClickFunc(function(arg0, arg1)
			if arg0.isDraging then
				return
			end

			arg0:emit(BossRushFleetSelectMediator.ON_OPEN_DECK, {
				fleet = var1,
				chapter = arg0.chapter,
				shipVO = var0,
				fleetIndex = arg3,
				teamType = arg2
			})
		end)
		var3:RemoveBeginDragFunc()
		var3:RemoveDragFunc()
		var3:RemoveDragEndFunc()
	end)
end

function var0.updateEliteFleets(arg0)
	local var0 = arg0.contextData.seriesData
	local var1 = arg0.contextData.fleetIndex
	local var2 = arg0.contextData.fleets[var1]
	local var3 = var1 == #arg0.contextData.fleets

	setActive(arg0._tf:Find("Panel/Fleet/Normal"), not var3)
	setActive(arg0._tf:Find("Panel/Fleet/Submarine"), var3)

	local var4 = #arg0.contextData.fleets

	table.Foreach(arg0.fleetIndexToggles, function(arg0, arg1)
		setActive(arg1, arg0 <= var4 - 1 or arg0 == #arg0.fleetIndexToggles)
	end)

	local var5 = arg0.btnClear
	local var6 = arg0.btnRecommend
	local var7 = arg0.commanderList

	if not var3 then
		local var8 = arg0.tfFleets[FleetType.Normal]

		setText(arg0:findTF("bg/name", var8), Fleet.DEFAULT_NAME[var1])
		arg0:initAddButton(var8, TeamType.Main, var1)
		arg0:initAddButton(var8, TeamType.Vanguard, var1)
	else
		local var9 = arg0.tfFleets[FleetType.Submarine]
		local var10 = #arg0.contextData.fleets

		setText(arg0:findTF("bg/name", var9), Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID])
		arg0:initAddButton(var9, TeamType.Submarine, var10)
	end

	arg0:initCommander(var2, var7)
	setText(arg0.sonarRangeTexts[1], math.floor(var2:GetFleetSonarRange()))

	local var11 = #var2:GetRawShipIds()
	local var12 = var11 == (var3 and 3 or 6)

	onButton(arg0, var5, function()
		if var11 == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("battle_preCombatLayer_clear_confirm"),
			onYes = function()
				arg0:emit(BossRushFleetSelectMediator.ON_ELITE_CLEAR, {
					index = var1
				})
			end
		})
	end)
	onButton(arg0, var6, function()
		if var12 then
			return
		end

		seriesAsync({
			function(arg0)
				if var11 == 0 then
					return arg0()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("battle_preCombatLayer_auto_confirm"),
					onYes = arg0
				})
			end,
			function(arg0)
				arg0:emit(BossRushFleetSelectMediator.ON_ELITE_RECOMMEND, {
					index = var1
				})
			end
		})
	end)

	local var13 = var0:GetOilLimit()

	setActive(arg0.rtCostLimit, _.any(var13, function(arg0)
		return arg0 > 0
	end))

	if #var13 > 0 then
		local var14 = var3 and "formationScene_use_oil_limit_submarine" or "formationScene_use_oil_limit_surface"
		local var15 = var3 and var13[2] or var13[1]

		setText(arg0.rtCostLimit:Find("Text"), string.format("%s(%d)", i18n(var14), var15))
	end

	local var16 = (function(arg0)
		if type(arg0) ~= "table" then
			return {}
		end

		return arg0
	end)(var0:GetAdditionalAwards())

	setActive(arg0.extraAwardTF, arg0.contextData.mode == BossRushSeriesData.MODE.MULTIPLE and #var16 > 0)

	local var17 = var0:GetExpeditionIds()
	local var18 = arg0._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var18, var18:GetChild(0), #var17, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = arg1 + 1 == var1 or var1 > #var17 or arg0.contextData.mode == BossRushSeriesData.MODE.SINGLE

		setActive(arg2:Find("Select"), var0)
		setActive(arg2:Find("Image"), var0)
	end)
end

function var0.initCommander(arg0, arg1, arg2)
	local var0 = arg1:GetRawCommanderIds()

	for iter0 = 1, 2 do
		local var1 = var0[iter0]
		local var2

		if var1 then
			var2 = getProxy(CommanderProxy):getCommanderById(var1)
		end

		local var3 = arg2:Find(iter0)
		local var4 = var3:Find("add")
		local var5 = var3:Find("info")

		setActive(var4, not var2)
		setActive(var5, var2)

		if var2 then
			local var6 = Commander.rarity2Frame(var2:getRarity())

			setImageSprite(var5:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2:getPainting(), "", var5:Find("mask/icon"))
		end

		onButton(arg0, var4, function()
			arg0:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1)
		end, SFX_PANEL)
		onButton(arg0, var5, function()
			arg0:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1)
		end, SFX_PANEL)
	end
end

return var0
