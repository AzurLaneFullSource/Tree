local var0_0 = class("BossRushFleetSelectView", import("view.base.BaseUI"))
local var1_0 = {
	vanguard = 1,
	submarine = 3,
	main = 2
}

function var0_0.getUIName(arg0_1)
	return "BossRushFleetSelectUI"
end

function var0_0.init(arg0_2)
	arg0_2:InitUI()
end

function var0_0.InitUI(arg0_3)
	local var0_3 = arg0_3._tf:Find("Panel")

	arg0_3.tfFleets = {
		[FleetType.Normal] = arg0_3:findTF("Panel/Fleet/Normal"),
		[FleetType.Submarine] = arg0_3:findTF("Panel/Fleet/Submarine")
	}
	arg0_3.btnRecommend = var0_3:Find("Fleet/BtnRecommend")
	arg0_3.btnClear = var0_3:Find("Fleet/BtnClear")
	arg0_3.rtCostLimit = var0_3:Find("Fleet/CostLimit")
	arg0_3.commanderList = var0_3:Find("Fleet/Commander")
	arg0_3.fleetIndexToggles = _.map(_.range(var0_3:Find("Fleet/Indexes").childCount), function(arg0_4)
		return var0_3:Find("Fleet/Indexes"):GetChild(arg0_4 - 1)
	end)
	arg0_3.modeToggles = {
		var0_3:Find("Info/Modes/Single"),
		var0_3:Find("Info/Modes/Multiple")
	}
	arg0_3.extraAwardTF = arg0_3._tf:Find("Panel/Reward/Normal/Mode")
	arg0_3.sonarRangeContainer = arg0_3._tf:Find("Panel/Fleet/SonarRange")
	arg0_3.sonarRangeTexts = {
		arg0_3._tf:Find("Panel/Fleet/SonarRange/Values"):GetChild(0),
		arg0_3._tf:Find("Panel/Fleet/SonarRange/Values"):GetChild(1)
	}

	setText(arg0_3.sonarRangeTexts[2], "")

	arg0_3.btnBack = var0_3:Find("Info/Title/BtnClose")
	arg0_3.btnGo = var0_3:Find("Info/Start")

	setText(arg0_3._tf:Find("Panel/Fleet/SonarRange/Text"), i18n("fleet_antisub_range") .. ":")
	setText(arg0_3._tf:Find("Panel/Fleet/CostLimit/Title"), i18n("formationScene_use_oil_limit_tip_worldboss"))
	setText(arg0_3._tf:Find("Panel/Reward/Normal/Base/Text"), i18n("series_enemy_reward_tip1"))
	setText(arg0_3._tf:Find("Panel/Reward/Normal/Mode/Text"), i18n("series_enemy_reward_tip2"))
	setText(arg0_3._tf:Find("Panel/Reward/EX/Title"), i18n("series_enemy_reward_tip4"))
	setText(arg0_3._tf:Find("Panel/Reward/Tip"), i18n("limit_team_character_tips"))
	setText(arg0_3._tf:Find("Panel/Info/Modes/Single/On/Text"), i18n("series_enemy_mode_1"))
	setText(arg0_3._tf:Find("Panel/Info/Modes/Single/Off/Text"), i18n("series_enemy_mode_1"))
	setText(arg0_3._tf:Find("Panel/Info/Modes/Multiple/On/Text"), i18n("series_enemy_mode_2"))
	setText(arg0_3._tf:Find("Panel/Info/Modes/Multiple/Off/Text"), i18n("series_enemy_mode_2"))
	table.Foreach(arg0_3.fleetIndexToggles, function(arg0_5, arg1_5)
		if arg0_5 >= #arg0_3.fleetIndexToggles then
			setText(arg1_5:Find("Text"), i18n("formationScene_use_oil_limit_submarine"))
		else
			setText(arg1_5:Find("Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg0_5)))
		end
	end)
	setText(arg0_3._tf:Find("Panel/Fleet/Normal/main/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
	setText(arg0_3._tf:Find("Panel/Fleet/Normal/vanguard/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
	setText(arg0_3._tf:Find("Panel/Fleet/Submarine/submarine/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
end

function var0_0.didEnter(arg0_6)
	local var0_6 = arg0_6.contextData.seriesData

	onButton(arg0_6, arg0_6.btnGo, function()
		for iter0_7 = 1, #arg0_6.contextData.fleets - 1 do
			if arg0_6.contextData.fleets[iter0_7]:isLegalToFight() ~= true then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_team_notenough"))

				return
			end
		end

		if _.any(arg0_6.contextData.fleets, function(arg0_8)
			local var0_8, var1_8 = arg0_8:HaveShipsInEvent()

			if var0_8 then
				pg.TipsMgr.GetInstance():ShowTips(var1_8)

				return true
			end
		end) then
			return
		end

		arg0_6:emit(BossRushFleetSelectMediator.ON_PRECOMBAT)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_6, arg0_6.sonarRangeContainer, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnBack, function()
		arg0_6:onCancelHard()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6._tf:Find("BG"), function()
		arg0_6:onCancelHard()
	end, SFX_CANCEL)

	local var1_6 = var0_6:IsSingleFight()

	setActive(arg0_6.modeToggles[1].parent, var1_6)

	if var1_6 then
		table.Foreach(arg0_6.modeToggles, function(arg0_12, arg1_12)
			triggerToggle(arg1_12, arg0_12 == arg0_6.contextData.mode)
		end)
		table.Foreach(arg0_6.modeToggles, function(arg0_13, arg1_13)
			onToggle(arg0_6, arg1_13, function(arg0_14)
				if not arg0_14 then
					return
				end

				arg0_6:emit(BossRushFleetSelectMediator.ON_SWITCH_MODE, arg0_13)
				table.Foreach(arg0_6.fleetIndexToggles, function(arg0_15, arg1_15)
					triggerToggle(arg1_15, arg0_15 == arg0_6.contextData.fleetIndex)
				end)
			end, SFX_PANEL)
		end)
	end

	local var2_6 = #arg0_6.contextData.fullFleets

	table.Foreach(arg0_6.fleetIndexToggles, function(arg0_16, arg1_16)
		setActive(arg1_16, arg0_16 <= var2_6 - 1 or arg0_16 == #arg0_6.fleetIndexToggles)
	end)

	for iter0_6 = #arg0_6.fleetIndexToggles - 1, var2_6, -1 do
		table.remove(arg0_6.fleetIndexToggles, iter0_6)
	end

	local var3_6 = Color.white
	local var4_6 = Color.New(1, 1, 1, 0.5)

	local function var5_6(arg0_17, arg1_17)
		setActive(arg0_17:Find("Selected"), arg1_17)
		setTextColor(arg0_17:Find("Text"), arg1_17 and var3_6 or var4_6)
	end

	table.Foreach(arg0_6.fleetIndexToggles, function(arg0_18, arg1_18)
		onToggle(arg0_6, arg1_18, function(arg0_19)
			var5_6(arg1_18, arg0_19)
		end)
	end)
	table.Foreach(arg0_6.fleetIndexToggles, function(arg0_20, arg1_20)
		triggerToggle(arg1_20, arg0_20 == arg0_6.contextData.fleetIndex)
	end)
	table.Foreach(arg0_6.fleetIndexToggles, function(arg0_21, arg1_21)
		onToggle(arg0_6, arg1_21, function(arg0_22)
			var5_6(arg1_21, arg0_22)

			if not arg0_22 then
				return
			end

			if arg0_21 == #arg0_6.fleetIndexToggles then
				arg0_6.contextData.fleetIndex = #arg0_6.contextData.fleets
			else
				arg0_6.contextData.fleetIndex = arg0_21
			end

			arg0_6:updateEliteFleets()
		end, SFX_PANEL)
	end)
	setText(arg0_6._tf:Find("Panel/Info/Title/Text"), var0_6:GetName())
	setText(arg0_6._tf:Find("Panel/Info/Title/Text/EN"), var0_6:GetSeriesCode())
	setText(arg0_6._tf:Find("Panel/Info/Description/Text"), var0_6:GetDescription())

	local var6_6 = var0_6:GetExpeditionIds()
	local var7_6 = var0_6:GetBossIcons()
	local var8_6 = arg0_6._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var8_6, var8_6:GetChild(0), #var6_6, function(arg0_23, arg1_23, arg2_23)
		if arg0_23 ~= UIItemList.EventUpdate then
			return
		end

		local var0_23 = var6_6[arg1_23 + 1]
		local var1_23 = var7_6[arg1_23 + 1][1]
		local var2_23 = pg.expedition_data_template[var0_23].level
		local var3_23 = arg2_23:Find("shiptpl")
		local var4_23 = findTF(var3_23, "icon_bg")
		local var5_23 = findTF(var3_23, "icon_bg/frame")

		SetCompomentEnabled(var4_23, "Image", false)
		SetCompomentEnabled(var5_23, "Image", false)
		setActive(arg2_23:Find("shiptpl/icon_bg/lv"), false)

		local var6_23 = arg2_23:Find("shiptpl/icon_bg/icon")

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_23, "", var6_23)

		local var7_23 = findTF(var3_23, "ship_type")

		if var7_23 then
			setActive(var7_23, true)
			setImageSprite(var7_23, GetSpriteFromAtlas("shiptype", shipType2print(var7_6[arg1_23 + 1][2])))
		end
	end)

	local function var9_6(arg0_24)
		if type(arg0_24) ~= "table" then
			return {}
		end

		return arg0_24
	end

	local var10_6 = var0_6:GetType() == BossRushSeriesData.TYPE.EXTRA

	setActive(arg0_6._tf:Find("Panel/Reward/Normal"), not var10_6)
	setActive(arg0_6._tf:Find("Panel/Reward/EX"), var10_6)

	if not var10_6 then
		local var11_6 = arg0_6._tf:Find("Panel/Reward/Normal/Base/Items")
		local var12_6 = var9_6(var0_6:GetPassAwards())

		UIItemList.StaticAlign(var11_6, var11_6:GetChild(0), #var12_6, function(arg0_25, arg1_25, arg2_25)
			if arg0_25 ~= UIItemList.EventUpdate then
				return
			end

			local var0_25 = var12_6[arg1_25 + 1]
			local var1_25 = {
				type = var0_25[1],
				id = var0_25[2]
			}

			updateDrop(arg2_25, var1_25)
			onButton(arg0_6, arg2_25, function()
				arg0_6:ShowDropDetail(var1_25)
			end, SFX_PANEL)
		end)

		local var13_6 = arg0_6.extraAwardTF:Find("Items")
		local var14_6 = var9_6(var0_6:GetAdditionalAwards())

		UIItemList.StaticAlign(var13_6, var13_6:GetChild(0), #var14_6, function(arg0_27, arg1_27, arg2_27)
			if arg0_27 ~= UIItemList.EventUpdate then
				return
			end

			local var0_27 = var14_6[arg1_27 + 1]
			local var1_27 = {
				type = var0_27[1],
				id = var0_27[2]
			}

			updateDrop(arg2_27, var1_27)
			onButton(arg0_6, arg2_27, function()
				arg0_6:ShowDropDetail(var1_27)
			end, SFX_PANEL)
		end)
	else
		local var15_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK):GetScore()
		local var16_6 = arg0_6._tf:Find("Panel/Reward/EX/Title/Text")

		setText(var16_6, math.floor(var15_6))
	end

	arg0_6:updateEliteFleets()
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf, nil, {})
end

local var2_0 = {
	[99] = true
}

function var0_0.ShowDropDetail(arg0_29, arg1_29)
	local var0_29 = Item.getConfigData(arg1_29.id)

	if var0_29 and var2_0[var0_29.type] then
		local var1_29 = var0_29.display_icon
		local var2_29 = {}

		for iter0_29, iter1_29 in ipairs(var1_29) do
			local var3_29 = iter1_29[1]
			local var4_29 = iter1_29[2]

			var2_29[#var2_29 + 1] = {
				hideName = true,
				type = var3_29,
				id = var4_29
			}
		end

		arg0_29:emit(var0_0.ON_DROP_LIST, {
			item2Row = true,
			itemList = var2_29,
			content = var0_29.display
		})
	else
		arg0_29:emit(var0_0.ON_DROP, arg1_29)
	end
end

function var0_0.willExit(arg0_30)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_30._tf)
end

function var0_0.onCancelHard(arg0_31)
	arg0_31:emit(BossRushFleetSelectMediator.ON_UPDATE_CUSTOM_FLEET)
	arg0_31:closeView()
end

function var0_0.onBackPressed(arg0_32)
	arg0_32:onCancelHard()
	var0_0.super.onBackPressed(arg0_32)
end

function var0_0.setHardShipVOs(arg0_33, arg1_33)
	arg0_33.shipVOs = arg1_33
end

function var0_0.initAddButton(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = arg0_34.contextData.fleets[arg3_34]:getShipIds()
	local var1_34 = {}
	local var2_34 = {}

	for iter0_34, iter1_34 in ipairs(var0_34) do
		var1_34[arg0_34.shipVOs[iter1_34]] = true

		if arg2_34 == arg0_34.shipVOs[iter1_34]:getTeamType() then
			table.insert(var2_34, iter1_34)
		end
	end

	local var3_34 = _.map(var0_34, function(arg0_35)
		return arg0_34.shipVOs[arg0_35]
	end)

	table.sort(var3_34, function(arg0_36, arg1_36)
		return var1_0[arg0_36:getTeamType()] < var1_0[arg1_36:getTeamType()] or var1_0[arg0_36:getTeamType()] == var1_0[arg1_36:getTeamType()] and table.indexof(var0_34, arg0_36.id) < table.indexof(var0_34, arg1_36.id)
	end)

	local var4_34 = findTF(arg1_34, arg2_34)
	local var5_34 = var4_34:GetComponent("ContentSizeFitter")
	local var6_34 = var4_34:GetComponent("HorizontalLayoutGroup")

	var5_34.enabled = true
	var6_34.enabled = true
	arg0_34.isDraging = false

	UIItemList.StaticAlign(var4_34, var4_34:GetChild(0), 3, function(arg0_37, arg1_37, arg2_37)
		if arg0_37 ~= UIItemList.EventUpdate then
			return
		end

		arg1_37 = arg1_37 + 1

		local var0_37 = var2_34[arg1_37] and arg0_34.shipVOs[var2_34[arg1_37]] or nil

		setActive(arg2_37:Find("Ship"), var0_37)
		setActive(arg2_37:Find("Empty"), not var0_37)

		local var1_37 = var0_37 and arg2_37:Find("Ship") or arg2_37:Find("Empty")

		if var0_37 then
			updateShip(var1_37, var0_37)
			setActive(var1_37:Find("EnergyWarn"), arg0_34.contextData.mode == BossRushSeriesData.MODE.SINGLE and var0_37:getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value)
			setActive(var1_37:Find("event_block"), var0_37:getFlag("inEvent"))
		end

		setActive(var1_37:Find("ship_type"), false)

		local var2_37 = GetOrAddComponent(var1_37, typeof(UILongPressTrigger))

		var2_37.onLongPressed:RemoveAllListeners()

		if var0_37 then
			var2_37.onLongPressed:AddListener(function()
				arg0_34:emit(BossRushFleetSelectMediator.ON_FLEET_SHIPINFO, {
					shipId = var0_37.id,
					shipVOs = var3_34
				})
			end)
		end

		local var3_37 = GetOrAddComponent(var1_37, "EventTriggerListener")

		var3_37:RemovePointClickFunc()
		var3_37:AddPointClickFunc(function(arg0_39, arg1_39)
			if arg0_34.isDraging then
				return
			end

			arg0_34:emit(BossRushFleetSelectMediator.ON_OPEN_DECK, {
				fleet = var1_34,
				chapter = arg0_34.chapter,
				shipVO = var0_37,
				fleetIndex = arg3_34,
				teamType = arg2_34
			})
		end)
		var3_37:RemoveBeginDragFunc()
		var3_37:RemoveDragFunc()
		var3_37:RemoveDragEndFunc()
	end)
end

function var0_0.updateEliteFleets(arg0_40)
	local var0_40 = arg0_40.contextData.seriesData
	local var1_40 = arg0_40.contextData.fleetIndex
	local var2_40 = arg0_40.contextData.fleets[var1_40]
	local var3_40 = var1_40 == #arg0_40.contextData.fleets

	setActive(arg0_40._tf:Find("Panel/Fleet/Normal"), not var3_40)
	setActive(arg0_40._tf:Find("Panel/Fleet/Submarine"), var3_40)

	local var4_40 = #arg0_40.contextData.fleets

	table.Foreach(arg0_40.fleetIndexToggles, function(arg0_41, arg1_41)
		setActive(arg1_41, arg0_41 <= var4_40 - 1 or arg0_41 == #arg0_40.fleetIndexToggles)
	end)

	local var5_40 = arg0_40.btnClear
	local var6_40 = arg0_40.btnRecommend
	local var7_40 = arg0_40.commanderList

	if not var3_40 then
		local var8_40 = arg0_40.tfFleets[FleetType.Normal]

		setText(arg0_40:findTF("bg/name", var8_40), Fleet.DEFAULT_NAME[var1_40])
		arg0_40:initAddButton(var8_40, TeamType.Main, var1_40)
		arg0_40:initAddButton(var8_40, TeamType.Vanguard, var1_40)
	else
		local var9_40 = arg0_40.tfFleets[FleetType.Submarine]
		local var10_40 = #arg0_40.contextData.fleets

		setText(arg0_40:findTF("bg/name", var9_40), Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID])
		arg0_40:initAddButton(var9_40, TeamType.Submarine, var10_40)
	end

	arg0_40:initCommander(var2_40, var7_40)
	setText(arg0_40.sonarRangeTexts[1], math.floor(var2_40:GetFleetSonarRange()))

	local var11_40 = #var2_40:GetRawShipIds()
	local var12_40 = var11_40 == (var3_40 and 3 or 6)

	onButton(arg0_40, var5_40, function()
		if var11_40 == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("battle_preCombatLayer_clear_confirm"),
			onYes = function()
				arg0_40:emit(BossRushFleetSelectMediator.ON_ELITE_CLEAR, {
					index = var1_40
				})
			end
		})
	end)
	onButton(arg0_40, var6_40, function()
		if var12_40 then
			return
		end

		seriesAsync({
			function(arg0_45)
				if var11_40 == 0 then
					return arg0_45()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("battle_preCombatLayer_auto_confirm"),
					onYes = arg0_45
				})
			end,
			function(arg0_46)
				arg0_40:emit(BossRushFleetSelectMediator.ON_ELITE_RECOMMEND, {
					index = var1_40
				})
			end
		})
	end)

	local var13_40 = var0_40:GetOilLimit()

	setActive(arg0_40.rtCostLimit, _.any(var13_40, function(arg0_47)
		return arg0_47 > 0
	end))

	if #var13_40 > 0 then
		local var14_40 = var3_40 and "formationScene_use_oil_limit_submarine" or "formationScene_use_oil_limit_surface"
		local var15_40 = var3_40 and var13_40[2] or var13_40[1]

		setText(arg0_40.rtCostLimit:Find("Text"), string.format("%s(%d)", i18n(var14_40), var15_40))
	end

	local var16_40 = (function(arg0_48)
		if type(arg0_48) ~= "table" then
			return {}
		end

		return arg0_48
	end)(var0_40:GetAdditionalAwards())

	setActive(arg0_40.extraAwardTF, arg0_40.contextData.mode == BossRushSeriesData.MODE.MULTIPLE and #var16_40 > 0)

	local var17_40 = var0_40:GetExpeditionIds()
	local var18_40 = arg0_40._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var18_40, var18_40:GetChild(0), #var17_40, function(arg0_49, arg1_49, arg2_49)
		if arg0_49 ~= UIItemList.EventUpdate then
			return
		end

		local var0_49 = arg1_49 + 1 == var1_40 or var1_40 > #var17_40 or arg0_40.contextData.mode == BossRushSeriesData.MODE.SINGLE

		setActive(arg2_49:Find("Select"), var0_49)
		setActive(arg2_49:Find("Image"), var0_49)
	end)
end

function var0_0.initCommander(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg1_50:GetRawCommanderIds()

	for iter0_50 = 1, 2 do
		local var1_50 = var0_50[iter0_50]
		local var2_50

		if var1_50 then
			var2_50 = getProxy(CommanderProxy):getCommanderById(var1_50)
		end

		local var3_50 = arg2_50:Find(iter0_50)
		local var4_50 = var3_50:Find("add")
		local var5_50 = var3_50:Find("info")

		setActive(var4_50, not var2_50)
		setActive(var5_50, var2_50)

		if var2_50 then
			local var6_50 = Commander.rarity2Frame(var2_50:getRarity())

			setImageSprite(var5_50:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_50))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_50:getPainting(), "", var5_50:Find("mask/icon"))
		end

		onButton(arg0_50, var4_50, function()
			arg0_50:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1_50)
		end, SFX_PANEL)
		onButton(arg0_50, var5_50, function()
			arg0_50:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1_50)
		end, SFX_PANEL)
	end
end

return var0_0
