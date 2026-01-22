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
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3:InitUI()
end

function var0_0.InitUI(arg0_4)
	local var0_4 = arg0_4._tf:Find("Panel")

	arg0_4.tfFleets = {
		[FleetType.Normal] = arg0_4._tf:Find("Panel/Fleet/Normal"),
		[FleetType.Submarine] = arg0_4._tf:Find("Panel/Fleet/Submarine")
	}
	arg0_4.btnRecommend = var0_4:Find("Fleet/BtnRecommend")
	arg0_4.btnClear = var0_4:Find("Fleet/BtnClear")
	arg0_4.rtCostLimit = var0_4:Find("Fleet/CostLimit")
	arg0_4.commanderList = var0_4:Find("Fleet/Commander")
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
	setText(arg0_4._tf:Find("Panel/Fleet/Normal/main/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
	setText(arg0_4._tf:Find("Panel/Fleet/Normal/vanguard/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
	setText(arg0_4._tf:Find("Panel/Fleet/Submarine/main/Item/Ship/EnergyWarn/Text"), i18n("series_enemy_mood"))
end

function var0_0.didEnter(arg0_5)
	local var0_5 = arg0_5.contextData.seriesData

	onButton(arg0_5, arg0_5.btnGo, function()
		for iter0_6 = 1, #arg0_5.contextData.fleets - 1 do
			if arg0_5.contextData.fleets[iter0_6]:isLegalToFight() ~= true then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_team_notenough"))

				return
			end
		end

		if _.any(arg0_5.contextData.fleets, function(arg0_7)
			local var0_7, var1_7 = arg0_7:HaveShipsInEvent()

			if var0_7 then
				pg.TipsMgr.GetInstance():ShowTips(var1_7)

				return true
			end
		end) then
			return
		end

		arg0_5:emit(BossRushFleetSelectMediator.ON_PRECOMBAT)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_5, arg0_5.sonarRangeContainer, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.btnBack, function()
		arg0_5:onCancelHard()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5._tf:Find("BG"), function()
		arg0_5:onCancelHard()
	end, SFX_CANCEL)

	local var1_5 = var0_5:IsSingleFight()

	setActive(arg0_5.modeToggles[1].parent, var1_5)

	if var1_5 then
		table.Foreach(arg0_5.modeToggles, function(arg0_11, arg1_11)
			triggerToggle(arg1_11, arg0_11 == arg0_5.contextData.mode)
		end)
		table.Foreach(arg0_5.modeToggles, function(arg0_12, arg1_12)
			onToggle(arg0_5, arg1_12, function(arg0_13)
				if not arg0_13 then
					return
				end

				arg0_5:emit(BossRushFleetSelectMediator.ON_SWITCH_MODE, arg0_12)
				arg0_5:updateToggles()
				triggerToggle(arg0_5.fleetIndexToggles[arg0_5.contextData.fleetIndex], true)
			end, SFX_PANEL)
		end)
	end

	local var2_5 = arg0_5._tf:Find("Panel/Fleet/Indexes")
	local var3_5 = var2_5.childCount

	UIItemList.StaticAlign(var2_5, var2_5:GetChild(0), var3_5, function(arg0_14, arg1_14, arg2_14)
		arg1_14 = arg1_14 + 1

		if arg0_14 == UIItemList.EventUpdate then
			if arg1_14 < var3_5 then
				setText(arg2_14:Find("Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg1_14)))
			else
				setText(arg2_14:Find("Text"), i18n("formationScene_use_oil_limit_submarine"))
			end

			onToggle(arg0_5, arg2_14, function(arg0_15)
				setActive(arg2_14:Find("Selected"), arg0_15)

				local var0_15, var1_15 = arg0_5:GetTextColor()

				setTextColor(arg2_14:Find("Text"), arg0_15 and var0_15 or var1_15)

				if arg0_15 then
					local var2_15 = arg0_5.contextData.fleets

					arg0_5.contextData.fleetIndex = var2_15[arg1_14] and arg1_14 or #var2_15

					arg0_5:updateEliteFleets()
				end
			end, SFX_PANEL)
		end
	end)
	setText(arg0_5._tf:Find("Panel/Info/Title/Text"), var0_5:GetName())
	setText(arg0_5._tf:Find("Panel/Info/Title/Text/EN"), var0_5:GetSeriesCode())
	setText(arg0_5._tf:Find("Panel/Info/Description/Text"), var0_5:GetDescription())

	local var4_5 = var0_5:GetExpeditionIds()
	local var5_5 = var0_5:GetBossIcons()
	local var6_5 = arg0_5._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var6_5, var6_5:GetChild(0), #var4_5, function(arg0_16, arg1_16, arg2_16)
		if arg0_16 ~= UIItemList.EventUpdate then
			return
		end

		local var0_16 = var4_5[arg1_16 + 1]
		local var1_16 = var5_5[arg1_16 + 1][1]
		local var2_16 = pg.expedition_data_template[var0_16].level
		local var3_16 = arg2_16:Find("shiptpl")
		local var4_16 = findTF(var3_16, "icon_bg")
		local var5_16 = findTF(var3_16, "icon_bg/frame")

		SetCompomentEnabled(var4_16, "Image", false)
		SetCompomentEnabled(var5_16, "Image", false)
		setActive(arg2_16:Find("shiptpl/icon_bg/lv"), false)

		local var6_16 = arg2_16:Find("shiptpl/icon_bg/icon")

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_16, "", var6_16)

		local var7_16 = findTF(var3_16, "ship_type")

		if var7_16 then
			setActive(var7_16, true)
			setImageSprite(var7_16, GetSpriteFromAtlas("shiptype", shipType2print(var5_5[arg1_16 + 1][2])))
		end
	end)

	local function var7_5(arg0_17)
		if type(arg0_17) ~= "table" then
			return {}
		end

		return arg0_17
	end

	local var8_5 = var0_5:GetType() == BossRushSeriesData.TYPE.EXTRA

	setActive(arg0_5._tf:Find("Panel/Reward/Normal"), not var8_5)
	setActive(arg0_5._tf:Find("Panel/Reward/EX"), var8_5)

	if not var8_5 then
		local var9_5 = arg0_5._tf:Find("Panel/Reward/Normal/Base/Items")
		local var10_5 = var7_5(var0_5:GetPassAwards())

		UIItemList.StaticAlign(var9_5, var9_5:GetChild(0), #var10_5, function(arg0_18, arg1_18, arg2_18)
			if arg0_18 ~= UIItemList.EventUpdate then
				return
			end

			local var0_18 = var10_5[arg1_18 + 1]
			local var1_18 = Drop.Create(var0_18)

			updateDrop(arg2_18, var1_18)
			onButton(arg0_5, arg2_18, function()
				arg0_5:ShowDropDetail(var1_18)
			end, SFX_PANEL)
		end)

		local var11_5 = arg0_5.extraAwardTF:Find("Items")
		local var12_5 = var7_5(var0_5:GetAdditionalAwards())

		UIItemList.StaticAlign(var11_5, var11_5:GetChild(0), #var12_5, function(arg0_20, arg1_20, arg2_20)
			if arg0_20 ~= UIItemList.EventUpdate then
				return
			end

			local var0_20 = var12_5[arg1_20 + 1]
			local var1_20 = Drop.Create(var0_20)

			updateDrop(arg2_20, var1_20)
			onButton(arg0_5, arg2_20, function()
				arg0_5:ShowDropDetail(var1_20)
			end, SFX_PANEL)
		end)
	else
		local var13_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK):GetScore()
		local var14_5 = arg0_5._tf:Find("Panel/Reward/EX/Title/Text")

		setText(var14_5, math.floor(var13_5))
	end

	arg0_5:updateToggles()
	triggerToggle(arg0_5.fleetIndexToggles[arg0_5.contextData.fleetIndex], true)
end

local var1_0 = {
	[99] = true
}

function var0_0.ShowDropDetail(arg0_22, arg1_22)
	local var0_22 = Item.getConfigData(arg1_22.id)

	if var0_22 and var1_0[var0_22.type] then
		local var1_22 = var0_22.display_icon
		local var2_22 = {}

		for iter0_22, iter1_22 in ipairs(var1_22) do
			local var3_22 = iter1_22[1]
			local var4_22 = iter1_22[2]

			var2_22[#var2_22 + 1] = {
				hideName = true,
				type = var3_22,
				id = var4_22
			}
		end

		arg0_22:emit(var0_0.ON_DROP_LIST, {
			item2Row = true,
			itemList = var2_22,
			content = var0_22.display
		})
	else
		arg0_22:emit(var0_0.ON_DROP, arg1_22)
	end
end

function var0_0.willExit(arg0_23)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23._tf)
end

function var0_0.onCancelHard(arg0_24)
	arg0_24:emit(BossRushFleetSelectMediator.ON_UPDATE_CUSTOM_FLEET)
	arg0_24:closeView()
end

function var0_0.onBackPressed(arg0_25)
	arg0_25:onCancelHard()
	var0_0.super.onBackPressed(arg0_25)
end

function var0_0.setHardShipVOs(arg0_26, arg1_26)
	arg0_26.shipVOs = arg1_26
end

function var0_0.initAddButton(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = arg0_27.contextData.fleets[arg3_27]:getShipIds()
	local var1_27 = {}
	local var2_27 = {}

	for iter0_27, iter1_27 in ipairs(var0_27) do
		var1_27[arg0_27.shipVOs[iter1_27]] = true

		if arg2_27 == arg0_27.shipVOs[iter1_27]:getTeamType() then
			table.insert(var2_27, iter1_27)
		end
	end

	local var3_27 = _.map(var0_27, function(arg0_28)
		return arg0_27.shipVOs[arg0_28]
	end)

	table.sort(var3_27, function(arg0_29, arg1_29)
		return var0_0.fleetNames[arg0_29:getTeamType()] < var0_0.fleetNames[arg1_29:getTeamType()] or var0_0.fleetNames[arg0_29:getTeamType()] == var0_0.fleetNames[arg1_29:getTeamType()] and table.indexof(var0_27, arg0_29.id) < table.indexof(var0_27, arg1_29.id)
	end)

	local var4_27 = arg1_27:GetComponent("ContentSizeFitter")
	local var5_27 = arg1_27:GetComponent("HorizontalLayoutGroup")

	var4_27.enabled = true
	var5_27.enabled = true
	arg0_27.isDraging = false

	UIItemList.StaticAlign(arg1_27, arg1_27:GetChild(0), 3, function(arg0_30, arg1_30, arg2_30)
		if arg0_30 ~= UIItemList.EventUpdate then
			return
		end

		arg1_30 = arg1_30 + 1

		local var0_30 = var2_27[arg1_30] and arg0_27.shipVOs[var2_27[arg1_30]] or nil

		setActive(arg2_30:Find("Ship"), var0_30)
		setActive(arg2_30:Find("Empty"), not var0_30)

		local var1_30 = var0_30 and arg2_30:Find("Ship") or arg2_30:Find("Empty")

		if var0_30 then
			updateShip(var1_30, var0_30)
			setActive(var1_30:Find("EnergyWarn"), arg0_27.contextData.mode == BossRushSeriesData.MODE.SINGLE and var0_30:getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value)
			setActive(var1_30:Find("event_block"), var0_30:getFlag("inEvent"))
		end

		setActive(var1_30:Find("ship_type"), false)

		local var2_30 = GetOrAddComponent(var1_30, typeof(UILongPressTrigger))

		var2_30.onLongPressed:RemoveAllListeners()

		if var0_30 then
			var2_30.onLongPressed:AddListener(function()
				arg0_27:emit(BossRushFleetSelectMediator.ON_FLEET_SHIPINFO, {
					shipId = var0_30.id,
					shipVOs = var3_27
				})
			end)
		end

		local var3_30 = GetOrAddComponent(var1_30, "EventTriggerListener")

		var3_30:RemovePointClickFunc()
		var3_30:AddPointClickFunc(function(arg0_32, arg1_32)
			if arg0_27.isDraging then
				return
			end

			arg0_27:emit(BossRushFleetSelectMediator.ON_OPEN_DECK, {
				fleet = var1_27,
				chapter = arg0_27.chapter,
				shipVO = var0_30,
				fleetIndex = arg3_27,
				teamType = arg2_27
			})
		end)
		var3_30:RemoveBeginDragFunc()
		var3_30:RemoveDragFunc()
		var3_30:RemoveDragEndFunc()
	end)
end

function var0_0.updateToggles(arg0_33)
	local var0_33 = #arg0_33.contextData.fleets
	local var1_33 = arg0_33._tf:Find("Panel/Fleet/Indexes")
	local var2_33 = var1_33.childCount

	arg0_33.fleetIndexToggles = {}

	eachChild(var1_33, function(arg0_34, arg1_34)
		arg1_34 = arg1_34 + 1

		setActive(arg0_34, arg1_34 == var2_33 or arg1_34 < var0_33)

		if arg1_34 == var2_33 then
			arg0_33.fleetIndexToggles[var0_33] = arg0_34
		elseif arg1_34 < var0_33 then
			arg0_33.fleetIndexToggles[arg1_34] = arg0_34
		end
	end)
end

function var0_0.updateEliteFleets(arg0_35)
	local var0_35 = arg0_35.contextData.seriesData
	local var1_35 = arg0_35.contextData.fleetIndex
	local var2_35 = arg0_35.contextData.fleets[var1_35]
	local var3_35 = var1_35 == #arg0_35.contextData.fleets

	setActive(arg0_35._tf:Find("Panel/Fleet/Normal"), not var3_35)
	setActive(arg0_35._tf:Find("Panel/Fleet/Submarine"), var3_35)

	local var4_35 = arg0_35.btnClear
	local var5_35 = arg0_35.btnRecommend
	local var6_35 = arg0_35.commanderList

	if not var3_35 then
		local var7_35 = arg0_35.tfFleets[FleetType.Normal]

		setText(var7_35:Find("bg/name"), Fleet.DEFAULT_NAME[var1_35])
		arg0_35:initAddButton(var7_35:Find(TeamType.Main), TeamType.Main, var1_35)
		arg0_35:initAddButton(var7_35:Find(TeamType.Vanguard), TeamType.Vanguard, var1_35)
	else
		local var8_35 = arg0_35.tfFleets[FleetType.Submarine]
		local var9_35 = #arg0_35.contextData.fleets

		setText(var8_35:Find("bg/name"), Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID])
		arg0_35:initAddButton(var8_35:Find(TeamType.Main), TeamType.Submarine, var9_35)
	end

	arg0_35:initCommander(var2_35, var6_35)
	setText(arg0_35.sonarRangeTexts[1], math.floor(var2_35:GetFleetSonarRange()))

	local var10_35 = #var2_35:GetRawShipIds()
	local var11_35 = var10_35 == (var3_35 and 3 or 6)

	onButton(arg0_35, var4_35, function()
		if var10_35 == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("battle_preCombatLayer_clear_confirm"),
			onYes = function()
				arg0_35:emit(BossRushFleetSelectMediator.ON_ELITE_CLEAR, {
					index = var1_35
				})
			end
		})
	end)
	onButton(arg0_35, var5_35, function()
		if var11_35 then
			return
		end

		seriesAsync({
			function(arg0_39)
				if var10_35 == 0 then
					return arg0_39()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("battle_preCombatLayer_auto_confirm"),
					onYes = arg0_39
				})
			end,
			function(arg0_40)
				arg0_35:emit(BossRushFleetSelectMediator.ON_ELITE_RECOMMEND, {
					index = var1_35
				})
			end
		})
	end)

	local var12_35 = var0_35:GetOilLimit()

	setActive(arg0_35.rtCostLimit, _.any(var12_35, function(arg0_41)
		return arg0_41 > 0
	end))

	if #var12_35 > 0 then
		local var13_35 = var3_35 and "formationScene_use_oil_limit_submarine" or "formationScene_use_oil_limit_surface"
		local var14_35 = var3_35 and var12_35[2] or var12_35[1]

		setText(arg0_35.rtCostLimit:Find("Text"), string.format("%s(%d)", i18n(var13_35), var14_35))
	end

	local var15_35 = (function(arg0_42)
		if type(arg0_42) ~= "table" then
			return {}
		end

		return arg0_42
	end)(var0_35:GetAdditionalAwards())

	setActive(arg0_35.extraAwardTF, arg0_35.contextData.mode == BossRushSeriesData.MODE.MULTIPLE and #var15_35 > 0)

	local var16_35 = var0_35:GetExpeditionIds()
	local var17_35 = arg0_35._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var17_35, var17_35:GetChild(0), #var16_35, function(arg0_43, arg1_43, arg2_43)
		if arg0_43 ~= UIItemList.EventUpdate then
			return
		end

		local var0_43 = arg1_43 + 1 == var1_35 or var1_35 > #var16_35 or arg0_35.contextData.mode == BossRushSeriesData.MODE.SINGLE

		setActive(arg2_43:Find("Select"), var0_43)
		setActive(arg2_43:Find("Image"), var0_43)
	end)
end

function var0_0.initCommander(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg1_44:GetRawCommanderIds()

	for iter0_44 = 1, 2 do
		local var1_44 = var0_44[iter0_44]
		local var2_44

		if var1_44 then
			var2_44 = getProxy(CommanderProxy):getCommanderById(var1_44)
		end

		local var3_44 = arg2_44:Find(iter0_44)
		local var4_44 = var3_44:Find("add")
		local var5_44 = var3_44:Find("info")

		setActive(var4_44, not var2_44)
		setActive(var5_44, var2_44)

		if var2_44 then
			local var6_44 = Commander.rarity2Frame(var2_44:getRarity())

			setImageSprite(var5_44:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_44))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_44:getPainting(), "", var5_44:Find("mask/icon"))
		end

		onButton(arg0_44, var4_44, function()
			arg0_44:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1_44)
		end, SFX_PANEL)
		onButton(arg0_44, var5_44, function()
			arg0_44:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1_44)
		end, SFX_PANEL)
	end
end

return var0_0
