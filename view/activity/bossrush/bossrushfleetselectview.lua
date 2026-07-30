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

		local var0_6 = var0_5:GetType() == BossRushSeriesData.TYPE.SP
		local var1_6 = true

		if var0_6 then
			local var2_6 = getProxy(ActivityProxy):getActivityById(var0_5.actId)
			local var3_6 = var2_6:GetActiveSeriesIds()
			local var4_6 = table.getIndex(var3_6, function(arg0_8)
				return arg0_8 == var0_5.id
			end)
			local var5_6 = var2_6:GetUsedBonus()[var4_6] or 0

			if not (var0_5:GetMaxBonusCount() - var5_6 > 0) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end
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
		table.Foreach(arg0_5.modeToggles, function(arg0_12, arg1_12)
			triggerToggle(arg1_12, arg0_12 == arg0_5.contextData.mode)
		end)
		table.Foreach(arg0_5.modeToggles, function(arg0_13, arg1_13)
			onToggle(arg0_5, arg1_13, function(arg0_14)
				if not arg0_14 then
					return
				end

				arg0_5:emit(BossRushFleetSelectMediator.ON_SWITCH_MODE, arg0_13)
				arg0_5:updateToggles()
				triggerToggle(arg0_5.fleetIndexToggles[arg0_5.contextData.fleetIndex], true)
			end, SFX_PANEL)
		end)
	end

	local var2_5 = arg0_5._tf:Find("Panel/Fleet/Indexes")
	local var3_5 = var2_5.childCount

	UIItemList.StaticAlign(var2_5, var2_5:GetChild(0), var3_5, function(arg0_15, arg1_15, arg2_15)
		arg1_15 = arg1_15 + 1

		if arg0_15 == UIItemList.EventUpdate then
			if arg1_15 < var3_5 then
				setText(arg2_15:Find("Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg1_15)))
			else
				setText(arg2_15:Find("Text"), i18n("formationScene_use_oil_limit_submarine"))
			end

			onToggle(arg0_5, arg2_15, function(arg0_16)
				setActive(arg2_15:Find("Selected"), arg0_16)

				local var0_16, var1_16 = arg0_5:GetTextColor()

				setTextColor(arg2_15:Find("Text"), arg0_16 and var0_16 or var1_16)

				if arg0_16 then
					local var2_16 = arg0_5.contextData.fleets

					arg0_5.contextData.fleetIndex = var2_16[arg1_15] and arg1_15 or #var2_16

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

	UIItemList.StaticAlign(var6_5, var6_5:GetChild(0), #var4_5, function(arg0_17, arg1_17, arg2_17)
		if arg0_17 ~= UIItemList.EventUpdate then
			return
		end

		local var0_17 = var4_5[arg1_17 + 1]
		local var1_17 = var5_5[arg1_17 + 1][1]
		local var2_17 = pg.expedition_data_template[var0_17].level
		local var3_17 = arg2_17:Find("shiptpl")
		local var4_17 = findTF(var3_17, "icon_bg")
		local var5_17 = findTF(var3_17, "icon_bg/frame")

		SetCompomentEnabled(var4_17, "Image", false)
		SetCompomentEnabled(var5_17, "Image", false)
		setActive(arg2_17:Find("shiptpl/icon_bg/lv"), false)

		local var6_17 = arg2_17:Find("shiptpl/icon_bg/icon")

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_17, "", var6_17)

		local var7_17 = findTF(var3_17, "ship_type")

		if var7_17 then
			setActive(var7_17, true)
			setImageSprite(var7_17, GetSpriteFromAtlas("shiptype", shipType2print(var5_5[arg1_17 + 1][2])))
		end
	end)

	local function var7_5(arg0_18)
		if type(arg0_18) ~= "table" then
			return {}
		end

		return arg0_18
	end

	local var8_5 = var0_5:GetType() == BossRushSeriesData.TYPE.EXTRA

	setActive(arg0_5._tf:Find("Panel/Reward/Normal"), not var8_5)
	setActive(arg0_5._tf:Find("Panel/Reward/EX"), var8_5)

	if not var8_5 then
		local var9_5 = arg0_5._tf:Find("Panel/Reward/Normal/Base/Items")
		local var10_5 = var7_5(var0_5:GetPassAwards())

		UIItemList.StaticAlign(var9_5, var9_5:GetChild(0), #var10_5, function(arg0_19, arg1_19, arg2_19)
			if arg0_19 ~= UIItemList.EventUpdate then
				return
			end

			local var0_19 = var10_5[arg1_19 + 1]
			local var1_19 = Drop.Create(var0_19)

			updateDrop(arg2_19, var1_19)
			onButton(arg0_5, arg2_19, function()
				arg0_5:ShowDropDetail(var1_19)
			end, SFX_PANEL)
		end)

		local var11_5 = arg0_5.extraAwardTF:Find("Items")
		local var12_5 = var7_5(var0_5:GetAdditionalAwards())

		UIItemList.StaticAlign(var11_5, var11_5:GetChild(0), #var12_5, function(arg0_21, arg1_21, arg2_21)
			if arg0_21 ~= UIItemList.EventUpdate then
				return
			end

			local var0_21 = var12_5[arg1_21 + 1]
			local var1_21 = Drop.Create(var0_21)

			updateDrop(arg2_21, var1_21)
			onButton(arg0_5, arg2_21, function()
				arg0_5:ShowDropDetail(var1_21)
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

function var0_0.ShowDropDetail(arg0_23, arg1_23)
	local var0_23 = Item.getConfigData(arg1_23.id)

	if var0_23 and var1_0[var0_23.type] then
		local var1_23 = var0_23.display_icon
		local var2_23 = {}

		for iter0_23, iter1_23 in ipairs(var1_23) do
			local var3_23 = iter1_23[1]
			local var4_23 = iter1_23[2]

			var2_23[#var2_23 + 1] = {
				hideName = true,
				type = var3_23,
				id = var4_23
			}
		end

		arg0_23:emit(var0_0.ON_DROP_LIST, {
			item2Row = true,
			itemList = var2_23,
			content = var0_23.display
		})
	else
		arg0_23:emit(var0_0.ON_DROP, arg1_23)
	end
end

function var0_0.willExit(arg0_24)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_24._tf)
end

function var0_0.onCancelHard(arg0_25)
	arg0_25:emit(BossRushFleetSelectMediator.ON_UPDATE_CUSTOM_FLEET)
	arg0_25:closeView()
end

function var0_0.onBackPressed(arg0_26)
	arg0_26:onCancelHard()
	var0_0.super.onBackPressed(arg0_26)
end

function var0_0.setHardShipVOs(arg0_27, arg1_27)
	arg0_27.shipVOs = arg1_27
end

function var0_0.initAddButton(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = arg0_28.contextData.fleets[arg3_28]:getShipIds()
	local var1_28 = {}
	local var2_28 = {}

	for iter0_28, iter1_28 in ipairs(var0_28) do
		var1_28[arg0_28.shipVOs[iter1_28]] = true

		if arg2_28 == arg0_28.shipVOs[iter1_28]:getTeamType() then
			table.insert(var2_28, iter1_28)
		end
	end

	local var3_28 = _.map(var0_28, function(arg0_29)
		return arg0_28.shipVOs[arg0_29]
	end)

	table.sort(var3_28, function(arg0_30, arg1_30)
		return var0_0.fleetNames[arg0_30:getTeamType()] < var0_0.fleetNames[arg1_30:getTeamType()] or var0_0.fleetNames[arg0_30:getTeamType()] == var0_0.fleetNames[arg1_30:getTeamType()] and table.indexof(var0_28, arg0_30.id) < table.indexof(var0_28, arg1_30.id)
	end)

	local var4_28 = arg1_28:GetComponent("ContentSizeFitter")
	local var5_28 = arg1_28:GetComponent("HorizontalLayoutGroup")

	var4_28.enabled = true
	var5_28.enabled = true
	arg0_28.isDraging = false

	UIItemList.StaticAlign(arg1_28, arg1_28:GetChild(0), 3, function(arg0_31, arg1_31, arg2_31)
		if arg0_31 ~= UIItemList.EventUpdate then
			return
		end

		arg1_31 = arg1_31 + 1

		local var0_31 = var2_28[arg1_31] and arg0_28.shipVOs[var2_28[arg1_31]] or nil

		setActive(arg2_31:Find("Ship"), var0_31)
		setActive(arg2_31:Find("Empty"), not var0_31)

		local var1_31 = var0_31 and arg2_31:Find("Ship") or arg2_31:Find("Empty")

		if var0_31 then
			updateShip(var1_31, var0_31)
			setActive(var1_31:Find("EnergyWarn"), arg0_28.contextData.mode == BossRushSeriesData.MODE.SINGLE and var0_31:getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value)
			setActive(var1_31:Find("event_block"), var0_31:getFlag("inEvent"))
		end

		setActive(var1_31:Find("ship_type"), false)

		local var2_31 = GetOrAddComponent(var1_31, typeof(UILongPressTrigger))

		var2_31.onLongPressed:RemoveAllListeners()

		if var0_31 then
			var2_31.onLongPressed:AddListener(function()
				arg0_28:emit(BossRushFleetSelectMediator.ON_FLEET_SHIPINFO, {
					shipId = var0_31.id,
					shipVOs = var3_28
				})
			end)
		end

		local var3_31 = GetOrAddComponent(var1_31, "EventTriggerListener")

		var3_31:RemovePointClickFunc()
		var3_31:AddPointClickFunc(function(arg0_33, arg1_33)
			if arg0_28.isDraging then
				return
			end

			arg0_28:emit(BossRushFleetSelectMediator.ON_OPEN_DECK, {
				fleet = var1_28,
				chapter = arg0_28.chapter,
				shipVO = var0_31,
				fleetIndex = arg3_28,
				teamType = arg2_28
			})
		end)
		var3_31:RemoveBeginDragFunc()
		var3_31:RemoveDragFunc()
		var3_31:RemoveDragEndFunc()
	end)
end

function var0_0.updateToggles(arg0_34)
	local var0_34 = #arg0_34.contextData.fleets
	local var1_34 = arg0_34._tf:Find("Panel/Fleet/Indexes")
	local var2_34 = var1_34.childCount

	arg0_34.fleetIndexToggles = {}

	eachChild(var1_34, function(arg0_35, arg1_35)
		arg1_35 = arg1_35 + 1

		setActive(arg0_35, arg1_35 == var2_34 or arg1_35 < var0_34)

		if arg1_35 == var2_34 then
			arg0_34.fleetIndexToggles[var0_34] = arg0_35
		elseif arg1_35 < var0_34 then
			arg0_34.fleetIndexToggles[arg1_35] = arg0_35
		end
	end)
end

function var0_0.updateEliteFleets(arg0_36)
	local var0_36 = arg0_36.contextData.seriesData
	local var1_36 = arg0_36.contextData.fleetIndex
	local var2_36 = arg0_36.contextData.fleets[var1_36]
	local var3_36 = var1_36 == #arg0_36.contextData.fleets

	setActive(arg0_36._tf:Find("Panel/Fleet/Normal"), not var3_36)
	setActive(arg0_36._tf:Find("Panel/Fleet/Submarine"), var3_36)

	local var4_36 = arg0_36.btnClear
	local var5_36 = arg0_36.btnRecommend
	local var6_36 = arg0_36.commanderList

	if not var3_36 then
		local var7_36 = arg0_36.tfFleets[FleetType.Normal]

		setText(var7_36:Find("bg/name"), Fleet.DEFAULT_NAME[var1_36])
		arg0_36:initAddButton(var7_36:Find(TeamType.Main), TeamType.Main, var1_36)
		arg0_36:initAddButton(var7_36:Find(TeamType.Vanguard), TeamType.Vanguard, var1_36)
	else
		local var8_36 = arg0_36.tfFleets[FleetType.Submarine]
		local var9_36 = #arg0_36.contextData.fleets

		setText(var8_36:Find("bg/name"), Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID])
		arg0_36:initAddButton(var8_36:Find(TeamType.Main), TeamType.Submarine, var9_36)
	end

	arg0_36:initCommander(var2_36, var6_36)
	setText(arg0_36.sonarRangeTexts[1], math.floor(var2_36:GetFleetSonarRange()))

	local var10_36 = #var2_36:GetRawShipIds()
	local var11_36 = var10_36 == (var3_36 and 3 or 6)

	onButton(arg0_36, var4_36, function()
		if var10_36 == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("battle_preCombatLayer_clear_confirm"),
			onYes = function()
				arg0_36:emit(BossRushFleetSelectMediator.ON_ELITE_CLEAR, {
					index = var1_36
				})
			end
		})
	end)
	onButton(arg0_36, var5_36, function()
		if var11_36 then
			return
		end

		seriesAsync({
			function(arg0_40)
				if var10_36 == 0 then
					return arg0_40()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("battle_preCombatLayer_auto_confirm"),
					onYes = arg0_40
				})
			end,
			function(arg0_41)
				arg0_36:emit(BossRushFleetSelectMediator.ON_ELITE_RECOMMEND, {
					index = var1_36
				})
			end
		})
	end)

	local var12_36 = var0_36:GetOilLimit()

	setActive(arg0_36.rtCostLimit, _.any(var12_36, function(arg0_42)
		return arg0_42 > 0
	end))

	if #var12_36 > 0 then
		local var13_36 = var3_36 and "formationScene_use_oil_limit_submarine" or "formationScene_use_oil_limit_surface"
		local var14_36 = var3_36 and var12_36[2] or var12_36[1]

		setText(arg0_36.rtCostLimit:Find("Text"), string.format("%s(%d)", i18n(var13_36), var14_36))
	end

	local var15_36 = (function(arg0_43)
		if type(arg0_43) ~= "table" then
			return {}
		end

		return arg0_43
	end)(var0_36:GetAdditionalAwards())

	setActive(arg0_36.extraAwardTF, arg0_36.contextData.mode == BossRushSeriesData.MODE.MULTIPLE and #var15_36 > 0)

	local var16_36 = var0_36:GetExpeditionIds()
	local var17_36 = arg0_36._tf:Find("Panel/Info/Boss")

	UIItemList.StaticAlign(var17_36, var17_36:GetChild(0), #var16_36, function(arg0_44, arg1_44, arg2_44)
		if arg0_44 ~= UIItemList.EventUpdate then
			return
		end

		local var0_44 = arg1_44 + 1 == var1_36 or var1_36 > #var16_36 or arg0_36.contextData.mode == BossRushSeriesData.MODE.SINGLE

		setActive(arg2_44:Find("Select"), var0_44)
		setActive(arg2_44:Find("Image"), var0_44)
	end)
end

function var0_0.initCommander(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg1_45:GetRawCommanderIds()

	for iter0_45 = 1, 2 do
		local var1_45 = var0_45[iter0_45]
		local var2_45

		if var1_45 then
			var2_45 = getProxy(CommanderProxy):getCommanderById(var1_45)
		end

		local var3_45 = arg2_45:Find(iter0_45)
		local var4_45 = var3_45:Find("add")
		local var5_45 = var3_45:Find("info")

		setActive(var4_45, not var2_45)
		setActive(var5_45, var2_45)

		if var2_45 then
			local var6_45 = Commander.rarity2Frame(var2_45:getRarity())

			setImageSprite(var5_45:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_45))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_45:getPainting(), "", var5_45:Find("mask/icon"))
		end

		onButton(arg0_45, var4_45, function()
			arg0_45:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1_45)
		end, SFX_PANEL)
		onButton(arg0_45, var5_45, function()
			arg0_45:emit(BossRushFleetSelectMediator.OPEN_COMMANDER_PANEL, arg1_45)
		end, SFX_PANEL)
	end
end

return var0_0
