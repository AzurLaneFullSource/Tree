local var0_0 = class("BossRushFleetSelectView", import("view.base.BaseUI"))

var0_0.fleetNames = {
	vanguard = 1,
	submarine = 3,
	main = 2
}

function var0_0.GetTextColor(arg0_1)
	return Color.white, Color.New(1, 1, 1, 0.5)
end

function var0_0.getUIName(arg0_2)
	return "BossRushFleetSelectUI"
end

function var0_0.init(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, nil, {})
	arg0_3:InitUI()
end

function var0_0.InitUI(arg0_4)
	local var0_4 = arg0_4._tf:Find("Panel")

	arg0_4.tfFleets = {
		[FleetType.Normal] = arg0_4:findTF("Panel/Fleet/Normal"),
		[FleetType.Submarine] = arg0_4:findTF("Panel/Fleet/Submarine")
	}
	arg0_4.btnRecommend = var0_4:Find("Fleet/BtnRecommend")
	arg0_4.btnClear = var0_4:Find("Fleet/BtnClear")
	arg0_4.rtCostLimit = var0_4:Find("Fleet/CostLimit")
	arg0_4.commanderList = var0_4:Find("Fleet/Commander")
	arg0_4.fleetIndexToggles = _.map(_.range(var0_4:Find("Fleet/Indexes").childCount), function(arg0_5)
		return var0_4:Find("Fleet/Indexes"):GetChild(arg0_5 - 1)
	end)
	arg0_4.modeToggles = {
		var0_4:Find("Info/Modes/Single"),
		var0_4:Find("Info/Modes/Multiple")
	}
	arg0_4.extraAwardTF = arg0_4._tf:Find("Panel/Reward/Normal/Mode")
	arg0_4.sonarRangeContainer = arg0_4._tf:Find("Panel/Fleet/SonarRange")
	arg0_4.sonarRangeTexts = {
		arg0_4._tf:Find("Panel/Fleet/SonarRange/Values"):GetChild(0),
		arg0_4._tf:Find("Panel/Fleet/SonarRange/Values"):GetChild(1)
	}

	setText(arg0_4.sonarRangeTexts[2], "")

	arg0_4.btnBack = var0_4:Find("Info/Title/BtnClose")
	arg0_4.btnGo = var0_4:Find("Info/Start")

	setText(arg0_4._tf:Find("Panel/Fleet/SonarRange/Text"), i18n("fleet_antisub_range") .. ":")
	setText(arg0_4._tf:Find("Panel/Fleet/CostLimit/Title"), i18n("formationScene_use_oil_limit_tip_worldboss"))
	setText(arg0_4._tf:Find("Panel/Reward/Normal/Base/Text"), i18n("series_enemy_reward_tip1"))
	setText(arg0_4._tf:Find("Panel/Reward/Normal/Mode/Text"), i18n("series_enemy_reward_tip2"))
	setText(arg0_4._tf:Find("Panel/Reward/EX/Title"), i18n("series_enemy_reward_tip4"))
	setText(arg0_4._tf:Find("Panel/Reward/Tip"), i18n("limit_team_character_tips"))
	setText(arg0_4._tf:Find("Panel/Info/Modes/Single/On/Text"), i18n("series_enemy_mode_1"))
	setText(arg0_4._tf:Find("Panel/Info/Modes/Single/Off/Text"), i18n("series_enemy_mode_1"))
	setText(arg0_4._tf:Find("Panel/Info/Modes/Multiple/On/Text"), i18n("series_enemy_mode_2"))
	setText(arg0_4._tf:Find("Panel/Info/Modes/Multiple/Off/Text"), i18n("series_enemy_mode_2"))
	table.Foreach(arg0_4.fleetIndexToggles, function(arg0_6, arg1_6)
		if arg0_6 >= #arg0_4.fleetIndexToggles then
			setText(arg1_6:Find("Text"), i18n("formationScene_use_oil_limit_submarine"))
		else
			setText(arg1_6:Find("Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg0_6)))
		end
	end)
	setText(arg0_4._tf:Find("Panel/Fleet/Normal/main/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
	setText(arg0_4._tf:Find("Panel/Fleet/Normal/vanguard/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
	setText(arg0_4._tf:Find("Panel/Fleet/Submarine/submarine/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
end

function var0_0.didEnter(arg0_7)
	local var0_7 = arg0_7.contextData.seriesData

	onButton(arg0_7, arg0_7.btnGo, function()
		for iter0_8 = 1, #arg0_7.contextData.fleets - 1 do
			if arg0_7.contextData.fleets[iter0_8]:isLegalToFight() ~= true then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_team_notenough"))

				return
			end
		end

		if _.any(arg0_7.contextData.fleets, function(arg0_9)
			local var0_9, var1_9 = arg0_9:HaveShipsInEvent()

			if var0_9 then
				pg.TipsMgr.GetInstance():ShowTips(var1_9)

				return true
			end
		end) then
			return
		end

		arg0_7:emit(BossRushFleetSelectMediator.ON_PRECOMBAT)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_7, arg0_7.sonarRangeContainer, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.btnBack, function()
		arg0_7:onCancelHard()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7._tf:Find("BG"), function()
		arg0_7:onCancelHard()
	end, SFX_CANCEL)

	local var1_7 = var0_7:IsSingleFight()

	setActive(arg0_7.modeToggles[1].parent, var1_7)

	if var1_7 then
		table.Foreach(arg0_7.modeToggles, function(arg0_13, arg1_13)
			triggerToggle(arg1_13, arg0_13 == arg0_7.contextData.mode)
		end)
		table.Foreach(arg0_7.modeToggles, function(arg0_14, arg1_14)
			onToggle(arg0_7, arg1_14, function(arg0_15)
				if not arg0_15 then
					return
				end

				arg0_7:emit(BossRushFleetSelectMediator.ON_SWITCH_MODE, arg0_14)
				table.Foreach(arg0_7.fleetIndexToggles, function(arg0_16, arg1_16)
					triggerToggle(arg1_16, arg0_16 == arg0_7.contextData.fleetIndex)
				end)
			end, SFX_PANEL)
		end)
	end

	local var2_7 = #arg0_7.contextData.fullFleets

	table.Foreach(arg0_7.fleetIndexToggles, function(arg0_17, arg1_17)
		setActive(arg1_17, arg0_17 <= var2_7 - 1 or arg0_17 == #arg0_7.fleetIndexToggles)
	end)

	for iter0_7 = #arg0_7.fleetIndexToggles - 1, var2_7, -1 do
		table.remove(arg0_7.fleetIndexToggles, iter0_7)
	end

	local function var3_7(arg0_18, arg1_18)
		setActive(arg0_18:Find("Selected"), arg1_18)

		local var0_18, var1_18 = arg0_7:GetTextColor()

		setTextColor(arg0_18:Find("Text"), arg1_18 and var0_18 or var1_18)
	end

	table.Foreach(arg0_7.fleetIndexToggles, function(arg0_19, arg1_19)
		onToggle(arg0_7, arg1_19, function(arg0_20)
			var3_7(arg1_19, arg0_20)
		end)
	end)
	table.Foreach(arg0_7.fleetIndexToggles, function(arg0_21, arg1_21)
		triggerToggle(arg1_21, arg0_21 == arg0_7.contextData.fleetIndex)
	end)
	table.Foreach(arg0_7.fleetIndexToggles, function(arg0_22, arg1_22)
		onToggle(arg0_7, arg1_22, function(arg0_23)
			var3_7(arg1_22, arg0_23)

			if not arg0_23 then
				return
			end

			if arg0_22 == #arg0_7.fleetIndexToggles then
				arg0_7.contextData.fleetIndex = #arg0_7.contextData.fleets
			else
				arg0_7.contextData.fleetIndex = arg0_22
			end

			arg0_7:updateEliteFleets()
		end, SFX_PANEL)
	end)
	setText(arg0_7._tf:Find("Panel/Info/Title/Text"), var0_7:GetName())
	setText(arg0_7._tf:Find("Panel/Info/Title/Text/EN"), var0_7:GetSeriesCode())
	setText(arg0_7._tf:Find("Panel/Info/Description/Text"), var0_7:GetDescription())

	local var4_7 = var0_7:GetExpeditionIds()
	local var5_7 = var0_7:GetBossIcons()
	local var6_7 = arg0_7._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var6_7, var6_7:GetChild(0), #var4_7, function(arg0_24, arg1_24, arg2_24)
		if arg0_24 ~= UIItemList.EventUpdate then
			return
		end

		local var0_24 = var4_7[arg1_24 + 1]
		local var1_24 = var5_7[arg1_24 + 1][1]
		local var2_24 = pg.expedition_data_template[var0_24].level
		local var3_24 = arg2_24:Find("shiptpl")
		local var4_24 = findTF(var3_24, "icon_bg")
		local var5_24 = findTF(var3_24, "icon_bg/frame")

		SetCompomentEnabled(var4_24, "Image", false)
		SetCompomentEnabled(var5_24, "Image", false)
		setActive(arg2_24:Find("shiptpl/icon_bg/lv"), false)

		local var6_24 = arg2_24:Find("shiptpl/icon_bg/icon")

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_24, "", var6_24)

		local var7_24 = findTF(var3_24, "ship_type")

		if var7_24 then
			setActive(var7_24, true)
			setImageSprite(var7_24, GetSpriteFromAtlas("shiptype", shipType2print(var5_7[arg1_24 + 1][2])))
		end
	end)

	local function var7_7(arg0_25)
		if type(arg0_25) ~= "table" then
			return {}
		end

		return arg0_25
	end

	local var8_7 = var0_7:GetType() == BossRushSeriesData.TYPE.EXTRA

	setActive(arg0_7._tf:Find("Panel/Reward/Normal"), not var8_7)
	setActive(arg0_7._tf:Find("Panel/Reward/EX"), var8_7)

	if not var8_7 then
		local var9_7 = arg0_7._tf:Find("Panel/Reward/Normal/Base/Items")
		local var10_7 = var7_7(var0_7:GetPassAwards())

		UIItemList.StaticAlign(var9_7, var9_7:GetChild(0), #var10_7, function(arg0_26, arg1_26, arg2_26)
			if arg0_26 ~= UIItemList.EventUpdate then
				return
			end

			local var0_26 = var10_7[arg1_26 + 1]
			local var1_26 = {
				type = var0_26[1],
				id = var0_26[2]
			}

			updateDrop(arg2_26, var1_26)
			onButton(arg0_7, arg2_26, function()
				arg0_7:ShowDropDetail(var1_26)
			end, SFX_PANEL)
		end)

		local var11_7 = arg0_7.extraAwardTF:Find("Items")
		local var12_7 = var7_7(var0_7:GetAdditionalAwards())

		UIItemList.StaticAlign(var11_7, var11_7:GetChild(0), #var12_7, function(arg0_28, arg1_28, arg2_28)
			if arg0_28 ~= UIItemList.EventUpdate then
				return
			end

			local var0_28 = var12_7[arg1_28 + 1]
			local var1_28 = {
				type = var0_28[1],
				id = var0_28[2]
			}

			updateDrop(arg2_28, var1_28)
			onButton(arg0_7, arg2_28, function()
				arg0_7:ShowDropDetail(var1_28)
			end, SFX_PANEL)
		end)
	else
		local var13_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK):GetScore()
		local var14_7 = arg0_7._tf:Find("Panel/Reward/EX/Title/Text")

		setText(var14_7, math.floor(var13_7))
	end

	arg0_7:updateEliteFleets()
end

local var1_0 = {
	[99] = true
}

function var0_0.ShowDropDetail(arg0_30, arg1_30)
	local var0_30 = Item.getConfigData(arg1_30.id)

	if var0_30 and var1_0[var0_30.type] then
		local var1_30 = var0_30.display_icon
		local var2_30 = {}

		for iter0_30, iter1_30 in ipairs(var1_30) do
			local var3_30 = iter1_30[1]
			local var4_30 = iter1_30[2]

			var2_30[#var2_30 + 1] = {
				hideName = true,
				type = var3_30,
				id = var4_30
			}
		end

		arg0_30:emit(var0_0.ON_DROP_LIST, {
			item2Row = true,
			itemList = var2_30,
			content = var0_30.display
		})
	else
		arg0_30:emit(var0_0.ON_DROP, arg1_30)
	end
end

function var0_0.willExit(arg0_31)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_31._tf)
end

function var0_0.onCancelHard(arg0_32)
	arg0_32:emit(BossRushFleetSelectMediator.ON_UPDATE_CUSTOM_FLEET)
	arg0_32:closeView()
end

function var0_0.onBackPressed(arg0_33)
	arg0_33:onCancelHard()
	var0_0.super.onBackPressed(arg0_33)
end

function var0_0.setHardShipVOs(arg0_34, arg1_34)
	arg0_34.shipVOs = arg1_34
end

function var0_0.initAddButton(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = arg0_35.contextData.fleets[arg3_35]:getShipIds()
	local var1_35 = {}
	local var2_35 = {}

	for iter0_35, iter1_35 in ipairs(var0_35) do
		var1_35[arg0_35.shipVOs[iter1_35]] = true

		if arg2_35 == arg0_35.shipVOs[iter1_35]:getTeamType() then
			table.insert(var2_35, iter1_35)
		end
	end

	local var3_35 = _.map(var0_35, function(arg0_36)
		return arg0_35.shipVOs[arg0_36]
	end)

	table.sort(var3_35, function(arg0_37, arg1_37)
		return var0_0.fleetNames[arg0_37:getTeamType()] < var0_0.fleetNames[arg1_37:getTeamType()] or var0_0.fleetNames[arg0_37:getTeamType()] == var0_0.fleetNames[arg1_37:getTeamType()] and table.indexof(var0_35, arg0_37.id) < table.indexof(var0_35, arg1_37.id)
	end)

	local var4_35 = findTF(arg1_35, arg2_35)
	local var5_35 = var4_35:GetComponent("ContentSizeFitter")
	local var6_35 = var4_35:GetComponent("HorizontalLayoutGroup")

	var5_35.enabled = true
	var6_35.enabled = true
	arg0_35.isDraging = false

	UIItemList.StaticAlign(var4_35, var4_35:GetChild(0), 3, function(arg0_38, arg1_38, arg2_38)
		if arg0_38 ~= UIItemList.EventUpdate then
			return
		end

		arg1_38 = arg1_38 + 1

		local var0_38 = var2_35[arg1_38] and arg0_35.shipVOs[var2_35[arg1_38]] or nil

		setActive(arg2_38:Find("Ship"), var0_38)
		setActive(arg2_38:Find("Empty"), not var0_38)

		local var1_38 = var0_38 and arg2_38:Find("Ship") or arg2_38:Find("Empty")

		if var0_38 then
			updateShip(var1_38, var0_38)
			setActive(var1_38:Find("EnergyWarn"), arg0_35.contextData.mode == BossRushSeriesData.MODE.SINGLE and var0_38:getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value)
			setActive(var1_38:Find("event_block"), var0_38:getFlag("inEvent"))
		end

		setActive(var1_38:Find("ship_type"), false)

		local var2_38 = GetOrAddComponent(var1_38, typeof(UILongPressTrigger))

		var2_38.onLongPressed:RemoveAllListeners()

		if var0_38 then
			var2_38.onLongPressed:AddListener(function()
				arg0_35:emit(BossRushFleetSelectMediator.ON_FLEET_SHIPINFO, {
					shipId = var0_38.id,
					shipVOs = var3_35
				})
			end)
		end

		local var3_38 = GetOrAddComponent(var1_38, "EventTriggerListener")

		var3_38:RemovePointClickFunc()
		var3_38:AddPointClickFunc(function(arg0_40, arg1_40)
			if arg0_35.isDraging then
				return
			end

			arg0_35:emit(BossRushFleetSelectMediator.ON_OPEN_DECK, {
				fleet = var1_35,
				chapter = arg0_35.chapter,
				shipVO = var0_38,
				fleetIndex = arg3_35,
				teamType = arg2_35
			})
		end)
		var3_38:RemoveBeginDragFunc()
		var3_38:RemoveDragFunc()
		var3_38:RemoveDragEndFunc()
	end)
end

function var0_0.updateEliteFleets(arg0_41)
	local var0_41 = arg0_41.contextData.seriesData
	local var1_41 = arg0_41.contextData.fleetIndex
	local var2_41 = arg0_41.contextData.fleets[var1_41]
	local var3_41 = var1_41 == #arg0_41.contextData.fleets

	setActive(arg0_41._tf:Find("Panel/Fleet/Normal"), not var3_41)
	setActive(arg0_41._tf:Find("Panel/Fleet/Submarine"), var3_41)

	local var4_41 = #arg0_41.contextData.fleets

	table.Foreach(arg0_41.fleetIndexToggles, function(arg0_42, arg1_42)
		setActive(arg1_42, arg0_42 <= var4_41 - 1 or arg0_42 == #arg0_41.fleetIndexToggles)
	end)

	local var5_41 = arg0_41.btnClear
	local var6_41 = arg0_41.btnRecommend
	local var7_41 = arg0_41.commanderList

	if not var3_41 then
		local var8_41 = arg0_41.tfFleets[FleetType.Normal]

		setText(arg0_41:findTF("bg/name", var8_41), Fleet.DEFAULT_NAME[var1_41])
		arg0_41:initAddButton(var8_41, TeamType.Main, var1_41)
		arg0_41:initAddButton(var8_41, TeamType.Vanguard, var1_41)
	else
		local var9_41 = arg0_41.tfFleets[FleetType.Submarine]
		local var10_41 = #arg0_41.contextData.fleets

		setText(arg0_41:findTF("bg/name", var9_41), Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID])
		arg0_41:initAddButton(var9_41, TeamType.Submarine, var10_41)
	end

	arg0_41:initCommander(var2_41, var7_41)
	setText(arg0_41.sonarRangeTexts[1], math.floor(var2_41:GetFleetSonarRange()))

	local var11_41 = #var2_41:GetRawShipIds()
	local var12_41 = var11_41 == (var3_41 and 3 or 6)

	onButton(arg0_41, var5_41, function()
		if var11_41 == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("battle_preCombatLayer_clear_confirm"),
			onYes = function()
				arg0_41:emit(BossRushFleetSelectMediator.ON_ELITE_CLEAR, {
					index = var1_41
				})
			end
		})
	end)
	onButton(arg0_41, var6_41, function()
		if var12_41 then
			return
		end

		seriesAsync({
			function(arg0_46)
				if var11_41 == 0 then
					return arg0_46()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("battle_preCombatLayer_auto_confirm"),
					onYes = arg0_46
				})
			end,
			function(arg0_47)
				arg0_41:emit(BossRushFleetSelectMediator.ON_ELITE_RECOMMEND, {
					index = var1_41
				})
			end
		})
	end)

	local var13_41 = var0_41:GetOilLimit()

	setActive(arg0_41.rtCostLimit, _.any(var13_41, function(arg0_48)
		return arg0_48 > 0
	end))

	if #var13_41 > 0 then
		local var14_41 = var3_41 and "formationScene_use_oil_limit_submarine" or "formationScene_use_oil_limit_surface"
		local var15_41 = var3_41 and var13_41[2] or var13_41[1]

		setText(arg0_41.rtCostLimit:Find("Text"), string.format("%s(%d)", i18n(var14_41), var15_41))
	end

	local var16_41 = (function(arg0_49)
		if type(arg0_49) ~= "table" then
			return {}
		end

		return arg0_49
	end)(var0_41:GetAdditionalAwards())

	setActive(arg0_41.extraAwardTF, arg0_41.contextData.mode == BossRushSeriesData.MODE.MULTIPLE and #var16_41 > 0)

	local var17_41 = var0_41:GetExpeditionIds()
	local var18_41 = arg0_41._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var18_41, var18_41:GetChild(0), #var17_41, function(arg0_50, arg1_50, arg2_50)
		if arg0_50 ~= UIItemList.EventUpdate then
			return
		end

		local var0_50 = arg1_50 + 1 == var1_41 or var1_41 > #var17_41 or arg0_41.contextData.mode == BossRushSeriesData.MODE.SINGLE

		setActive(arg2_50:Find("Select"), var0_50)
		setActive(arg2_50:Find("Image"), var0_50)
	end)
end

function var0_0.initCommander(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg1_51:GetRawCommanderIds()

	for iter0_51 = 1, 2 do
		local var1_51 = var0_51[iter0_51]
		local var2_51

		if var1_51 then
			var2_51 = getProxy(CommanderProxy):getCommanderById(var1_51)
		end

		local var3_51 = arg2_51:Find(iter0_51)
		local var4_51 = var3_51:Find("add")
		local var5_51 = var3_51:Find("info")

		setActive(var4_51, not var2_51)
		setActive(var5_51, var2_51)

		if var2_51 then
			local var6_51 = Commander.rarity2Frame(var2_51:getRarity())

			setImageSprite(var5_51:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_51))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_51:getPainting(), "", var5_51:Find("mask/icon"))
		end

		onButton(arg0_51, var4_51, function()
			arg0_51:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1_51)
		end, SFX_PANEL)
		onButton(arg0_51, var5_51, function()
			arg0_51:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1_51)
		end, SFX_PANEL)
	end
end

return var0_0
