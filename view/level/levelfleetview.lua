local var0_0 = class("LevelFleetView", import("..base.BaseSubView"))
local var1_0 = {
	vanguard = 1,
	submarine = 3,
	main = 2
}

var0_0.TabIndex = {
	Duty = 3,
	Commander = 2,
	Formation = 1,
	Adjustment = 4
}

local var2_0 = {
	SELECT = 1,
	EDIT = 2
}
local var3_0 = {
	NORMAL = 1,
	ADDITION_SUPPORT = 2
}

function var0_0.getUIName(arg0_1)
	return "LevelFleetSelectView"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"energy",
		"shiptype",
		"ui/iconcolorful"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.downloadLevelFleetViewResList(arg0_3, arg1_3)
	SplitPackConst.DownloadByLuaArr(ResList.LevelFleetView.GetResource(arg0_3), function()
		if arg0_3._state == var0_0.STATES.DESTROY then
			return
		end

		arg1_3()
	end)
end

function var0_0.OnInit(arg0_5)
	arg0_5:InitUI()
	arg0_5:bind(LevelUIConst.CONTINUOUS_OPERATION, function(arg0_6, arg1_6)
		local var0_6 = arg1_6.battleTimes

		getProxy(ChapterProxy):InitContinuousTime(SYSTEM_SCENARIO, var0_6)
		LoadContextCommand.RemoveLayerByMediator(LevelContinuousOperationWindowMediator)

		local var1_6 = "chapter_autofight_flag_" .. arg0_5.chapter.id

		PlayerPrefs.SetInt(var1_6, 1)
		triggerButton(arg0_5.btnGo)
	end)
	arg0_5:bind(LevelMediator2.ON_SPITEM_CHANGED, function(arg0_7, arg1_7)
		setActive(arg0_5.spCheckMark, not arg1_7)
		triggerButton(arg0_5.btnSp)
	end)
end

function var0_0.OnDestroy(arg0_8)
	if arg0_8:isShowing() then
		arg0_8:Hide()
	end
end

function var0_0.Show(arg0_9)
	local var0_9 = noEmptyStr(arg0_9.chapter:getConfig("special_operation_list"))
	local var1_9 = arg0_9.chapter:GetDailyBonusQuota()

	arg0_9:initSPOPView()

	if var0_9 and #var0_9 > 0 and not var1_9 then
		setActive(arg0_9.btnSp, true)
	else
		setActive(arg0_9.btnSp, false)
	end

	setActive(arg0_9._tf, true)

	local var2_9 = {
		arg0_9.formationToggle,
		arg0_9.commanderToggle,
		arg0_9.dutyToggle,
		arg0_9.adjustmentToggle
	}
	local var3_9 = var2_9[arg0_9.contextData.tabIndex or var0_0.TabIndex.Formation]

	if not isActive(var3_9) then
		var3_9 = var2_9[var0_0.TabIndex.Formation]
	end

	for iter0_9, iter1_9 in ipairs(var2_9) do
		if isActive(iter1_9) then
			triggerToggle(iter1_9, iter1_9 == var3_9)
		end
	end

	arg0_9:BlurPanel(arg0_9._tf)
	arg0_9:TryPlaySupportGuide()
	arg0_9:CheckGuideElement()
end

function var0_0.CheckGuideElement(arg0_10)
	if not IsUnityEditor then
		return
	end

	local var0_10 = {
		"panel/Fixed/start_button",
		"panel/ShipList/support/1/main"
	}

	_.each(var0_10, function(arg0_11)
		local var0_11 = arg0_10._tf:Find(arg0_11)

		assert(var0_11, "Missing Guide Need GameObject Path: " .. arg0_11)
	end)
end

function var0_0.TryPlaySupportGuide(arg0_12)
	if arg0_12:getLimitNums(FleetType.Support) == 0 then
		return
	end

	if not pg.NewStoryMgr.GetInstance():IsPlayed("NG0041") then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0041")
	end
end

function var0_0.Hide(arg0_13)
	setActive(arg0_13.dropDown, false)
	setActive(arg0_13.btnSp, false)
	setActive(arg0_13._tf, false)

	arg0_13.spItemID = nil

	arg0_13:UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)
end

function var0_0.setOpenCommanderTag(arg0_14, arg1_14)
	arg0_14.openedCommanerSystem = arg1_14
end

function var0_0.SetDutyTabEnabled(arg0_15, arg1_15)
	arg0_15.dutyTabEnabled = arg1_15
end

function var0_0.onConfirm(arg0_16)
	local var0_16 = arg0_16.chapter
	local var1_16 = arg0_16:getSelectIds()
	local var2_16 = var0_16:getNpcShipByType(2)

	if #var2_16 > 0 then
		local var3_16 = {
			[TeamType.Vanguard] = #arg0_16:getFleetById(var1_16[1]):getTeamByName(TeamType.Vanguard),
			[TeamType.Main] = #arg0_16:getFleetById(var1_16[1]):getTeamByName(TeamType.Main)
		}
		local var4_16 = {
			[TeamType.Vanguard] = 0,
			[TeamType.Main] = 0
		}
		local var5_16

		for iter0_16, iter1_16 in ipairs(var2_16) do
			var5_16 = iter1_16

			local var6_16 = iter1_16:getTeamType()

			var4_16[var6_16] = var4_16[var6_16] + 1

			if var3_16[var6_16] + var4_16[var6_16] > 3 then
				break
			end
		end

		for iter2_16, iter3_16 in pairs(var3_16) do
			if iter3_16 + var4_16[iter2_16] > 3 then
				arg0_16:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
					modal = true,
					hideNo = true,
					content = i18n("chapter_tip_with_npc", var5_16.name)
				})

				return
			end
		end
	end

	local var7_16 = "chapter_autofight_flag_" .. var0_16.id
	local var8_16
	local var9_16

	seriesAsync({
		function(arg0_17)
			local var0_17 = PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1

			if not (PlayerPrefs.GetInt(var7_16, 1) == 1) or var0_17 or not arg0_16:getSPItem() then
				return arg0_17()
			end

			PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
			PlayerPrefs.Save()

			local function var1_17()
				arg0_16:clearSPBuff()
			end

			arg0_16:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
				hideNo = true,
				content = i18n("autofight_special_operation_tip"),
				onYes = var1_17,
				onNo = var1_17
			})
		end,
		function(arg0_19)
			var9_16 = var0_16:GetActiveSPItemID()
			var8_16 = var0_16:isLoop() and arg0_16:GetOrderedDuties() or nil

			arg0_16:onCancel()
			arg0_19()
		end,
		function(arg0_20)
			getProxy(ChapterProxy):SetLastFleetIndex(var1_16)

			local var0_20 = PlayerPrefs.GetInt(var7_16, 1) == 1
			local var1_20 = LevelMediator2.ON_TRACKING
			local var2_20 = packEx(var0_16.id, var0_16.loopFlag, var9_16, var8_16, var0_20)

			if pg.m02:retrieveMediator(LevelMediator2.__cname) then
				pg.m02:sendNotification(var1_20, var2_20)

				return
			end

			local var3_20 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var3_20 then
				var3_20:extendData({
					ToTrackingData = {
						var1_20,
						var2_20
					}
				})
			end
		end
	})
end

function var0_0.onCancel(arg0_21)
	arg0_21:clear()
	arg0_21:emit(LevelUIConst.HIDE_FLEET_SELECT)
end

function var0_0.InitUI(arg0_22)
	arg0_22.tfShipTpl = arg0_22._tf:Find("panel/Fixed/shiptpl")
	arg0_22.tfEmptyTpl = arg0_22._tf:Find("panel/Fixed/emptytpl")
	arg0_22.tfFleets = {
		[FleetType.Normal] = {
			arg0_22._tf:Find("panel/ShipList/fleet/1"),
			arg0_22._tf:Find("panel/ShipList/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0_22._tf:Find("panel/ShipList/sub/1")
		},
		[FleetType.Support] = {
			arg0_22._tf:Find("panel/ShipList/support/1")
		}
	}

	local var0_22 = arg0_22._tf:Find("panel/Fixed/RightTabs")
	local var1_22 = PLATFORM_CODE == PLATFORM_US and arg0_22._tf:Find("panel/Fixed/RightTabs/hTplBtn") or arg0_22._tf:Find("panel/Fixed/RightTabs/vTplBtn")
	local var2_22 = {
		"formation_btn",
		"commander_btn",
		"duty_btn",
		"adjustment_btn"
	}

	for iter0_22 = 1, #var2_22 do
		local var3_22 = Instantiate(var1_22)

		var3_22.name = var2_22[iter0_22]

		SetParent(tf(var3_22), var0_22)
		setActive(var3_22, false)
	end

	arg0_22.tfLimit = arg0_22._tf:Find("panel/Fixed/limit_list/limit")
	arg0_22.tfLimitTips = arg0_22._tf:Find("panel/Fixed/limit_list/limit_tip")
	arg0_22.tfLimitElite = arg0_22._tf:Find("panel/Fixed/limit_list/limit_elite")
	arg0_22.tfLimitSubTip = arg0_22._tf:Find("panel/Fixed/limit_list/limit_sub_tip")
	arg0_22.tfLimitContainer = arg0_22._tf:Find("panel/Fixed/limit_list/limit_elite/limit_list")
	arg0_22.rtCostLimit = arg0_22._tf:Find("panel/Fixed/limit_list/cost_limit")
	arg0_22.btnBack = arg0_22._tf:Find("panel/Fixed/btnBack")
	arg0_22.btnGo = arg0_22._tf:Find("panel/Fixed/start_button")
	arg0_22.btnMultiple = arg0_22._tf:Find("panel/Fixed/multiple")
	arg0_22.formationToggle = arg0_22._tf:Find("panel/Fixed/RightTabs/formation_btn")
	arg0_22.commanderToggle = arg0_22._tf:Find("panel/Fixed/RightTabs/commander_btn")
	arg0_22.dutyToggle = arg0_22._tf:Find("panel/Fixed/RightTabs/duty_btn")
	arg0_22.adjustmentToggle = arg0_22._tf:Find("panel/Fixed/RightTabs/adjustment_btn")
	arg0_22.toggleMask = arg0_22._tf:Find("mask")
	arg0_22.toggleList = arg0_22._tf:Find("mask/list")
	arg0_22.toggles = {}

	setText(findTF(arg0_22.tfLimit, "text"), i18n("level_fleet_ship_desc"))
	setText(findTF(arg0_22.tfLimit, "text_sub"), i18n("level_fleet_sub_desc"))

	for iter1_22 = 0, arg0_22.toggleList.childCount - 1 do
		table.insert(arg0_22.toggles, arg0_22.toggleList:Find("item" .. iter1_22 + 1))
	end

	arg0_22.btnSp = arg0_22._tf:Find("panel/Fixed/sp")
	arg0_22.spMask = arg0_22._tf:Find("mask_sp")
	arg0_22.dutyItems = {}

	for iter2_22 = 1, 2 do
		local var4_22 = arg0_22._tf:Find(string.format("panel/ShipList/fleet/%d/DutySelect", iter2_22))

		arg0_22.dutyItems[iter2_22] = {}

		for iter3_22 = 1, 4 do
			local var5_22 = var4_22:Find("Item" .. iter3_22)

			arg0_22.dutyItems[iter2_22][iter3_22] = var5_22

			setText(var5_22:Find("Text"), i18n("autofight_function" .. iter3_22))
		end
	end

	local var6_22 = arg0_22._tf:Find("panel/ShipList/sub/1/DutySelect")

	arg0_22.dutyItems[3] = {}

	for iter4_22 = 1, 2 do
		local var7_22 = var6_22:Find("Item" .. iter4_22)

		arg0_22.dutyItems[3][iter4_22] = var7_22

		setText(var7_22:Find("Text"), i18n("autofight_function" .. 6 - iter4_22))
	end

	setActive(arg0_22.tfShipTpl, false)
	setActive(arg0_22.tfEmptyTpl, false)
	setActive(arg0_22.toggleMask, false)
	setActive(arg0_22.btnSp, false)
	setActive(arg0_22.spMask, false)
	setText(arg0_22._tf:Find("panel/Fixed/RightTabs/formation_btn/text"), i18n("autofight_formation"))
	setText(arg0_22._tf:Find("panel/Fixed/RightTabs/commander_btn/text"), i18n("autofight_cat"))
	setText(arg0_22._tf:Find("panel/Fixed/RightTabs/duty_btn/text"), i18n("autofight_function"))
	setText(arg0_22.adjustmentToggle:Find("text"), i18n("word_adjustFleet"))

	arg0_22.dropDown = arg0_22._tf:Find("panel/FixedTop/Dropdown")

	setActive(arg0_22.dropDown, false)

	arg0_22.dropDownSide = arg0_22._tf:Find("panel/Fixed/title/DropSide")

	onButton(arg0_22, arg0_22.dropDownSide:Find("Click"), function()
		local var0_23 = isActive(arg0_22.dropDown)

		setActive(arg0_22.dropDown, not var0_23)
	end, SFX_UI_CLICK)
	onButton(arg0_22, arg0_22.dropDown, function()
		local var0_24 = isActive(arg0_22.dropDown)

		setActive(arg0_22.dropDown, not var0_24)
	end, SFX_UI_CLICK)
	onButton(arg0_22, arg0_22.dropDownSide:Find("Layout/Item3"), function()
		arg0_22:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	assert(OPEN_AIR_DOMINANCE, "Not Prepare for BANNED OPEN_AIR_DOMINANCE")

	arg0_22.btnASHelp = arg0_22.dropDownSide:Find("help")

	setText(arg0_22.dropDownSide:Find("Layout/Item1/Text"), i18n("word_investigate"))
	setText(arg0_22.dropDownSide:Find("Layout/Item2/Text"), i18n("word_attr_ac"))
	setText(arg0_22.dropDownSide:Find("Layout/Item3/Text"), i18n("fleet_antisub_range"))
	setText(arg0_22.dropDown:Find("Investigation/Text"), i18n("level_scene_title_word_1"))
	setText(arg0_22.dropDown:Find("Airsupport/Text"), i18n("level_scene_title_word_3"))

	arg0_22.supportFleetHelp = arg0_22._tf:Find("panel/Fixed/title/Image/Help")

	onButton(arg0_22, arg0_22.supportFleetHelp, function()
		local var0_26 = arg0_22.chapter:IsSupportSubmarineStage() and "help_supportfleet_16_submarine" or arg0_22.chapter:IsFogStage() and "help_supportfleet_16" or "help_supportfleet"

		arg0_22:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
			type = MSGBOX_TYPE_HELP,
			helps = i18n(var0_26)
		})
	end, SFX_PANEL)

	for iter5_22 = 1, 2 do
		for iter6_22 = 1, 4 do
			local var8_22 = arg0_22.dutyItems[iter5_22][iter6_22]

			onButton(arg0_22, var8_22, function()
				arg0_22:SetDuty(iter5_22, iter6_22)
			end)
		end
	end

	for iter7_22 = 1, 2 do
		local var9_22 = arg0_22.dutyItems[3][iter7_22]

		onButton(arg0_22, var9_22, function()
			arg0_22:SetAutoSub(iter7_22 == 1)
		end)
	end
end

function var0_0.onCancelSupport(arg0_29, arg1_29)
	if arg1_29 then
		arg0_29:emit(LevelMediator2.ON_UPDATE_CUSTOM_FLEET, arg0_29.chapter)
	end
end

function var0_0.set(arg0_30, arg1_30, arg2_30, arg3_30)
	arg0_30.chapter = arg1_30
	arg0_30.mode = var2_0.SELECT
	arg0_30.selects = arg3_30
	arg0_30.chapterASValue = arg0_30.chapter:getConfig("air_dominance")
	arg0_30.suggestionValue = arg0_30.chapter:getConfig("best_air_dominance")

	arg0_30:SetDutyTabEnabled(arg1_30:isLoop())

	arg0_30.supportFleet = arg0_30.chapter:getSupportFleet()

	local var0_30 = arg0_30:getLimitNums(FleetType.Support) > 0

	setActive(arg0_30.supportFleetHelp, var0_30)

	arg0_30.displayMode = var0_30 and var3_0.ADDITION_SUPPORT or var3_0.NORMAL

	arg0_30:SwitchDisplayMode()

	arg0_30.fleets = underscore(arg2_30):chain():values():filter(function(arg0_31)
		return arg0_31:isRegularFleet()
	end):sort(CompareFuncs({
		function(arg0_32)
			return arg0_32.id
		end
	})):value()
	arg0_30.selectIds = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0_30, iter1_30 in ipairs(arg3_30 or {}) do
		local var1_30 = arg0_30:getFleetById(iter1_30)

		if var1_30 then
			local var2_30 = var1_30:getFleetType()
			local var3_30 = arg0_30.selectIds[var2_30]

			if #var3_30 < arg0_30:getLimitNums(var2_30) then
				table.insert(var3_30, iter1_30)
			end
		end
	end

	arg0_30.duties = {}

	local var4_30 = PlayerPrefs.GetInt("lastFleetDuty_" .. (arg0_30.chapter.id or 0), 0)

	if var4_30 > 0 then
		local var5_30 = bit.band(var4_30, 255)
		local var6_30 = bit.rshift(var4_30, 8)
		local var7_30 = bit.band(var6_30, 255)

		if var5_30 > 0 and var7_30 > 0 then
			arg0_30.duties[var5_30] = var7_30
		end
	end

	setActive(arg0_30.tfLimitElite, false)
	setActive(arg0_30.tfLimitSubTip, false)
	setActive(arg0_30.tfLimitTips, false)
	setActive(arg0_30.tfLimit, true)

	local var8_30 = arg0_30.chapter:isLoop() and arg0_30.chapter:getConfig("use_oil_limit") or {}

	setActive(arg0_30.rtCostLimit, #var8_30 > 0)
	setText(arg0_30.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip"))

	if #var8_30 > 0 then
		setActive(arg0_30.rtCostLimit:Find("cost_noraml"), var8_30[1] > 0)
		setText(arg0_30.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_enemy"), var8_30[1]))
		setActive(arg0_30.rtCostLimit:Find("cost_boss"), var8_30[2] > 0)
		setText(arg0_30.rtCostLimit:Find("cost_boss/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_flagship"), var8_30[2]))
		setActive(arg0_30.rtCostLimit:Find("cost_sub"), var8_30[3] > 0)
		setText(arg0_30.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var8_30[3]))
	end

	onButton(arg0_30, arg0_30.btnGo, function()
		local function var0_33()
			arg0_30:onConfirm()
		end

		local var1_33 = arg0_30:getSPItem()

		if var1_33 and var1_33 ~= 0 then
			if PlayerPrefs.GetInt("SPOPItemReminder") ~= 1 then
				local var2_33 = Item.getConfigData(var1_33).name
				local var3_33 = pg.benefit_buff_template[Chapter.GetSPBuffByItem(var1_33)].desc
				local var4_33 = i18n("levelScene_select_SP_OP_reminder", var2_33, var3_33)

				local function var5_33()
					PlayerPrefs.SetInt("SPOPItemReminder", 1)
					PlayerPrefs.Save()
					var0_33()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = {
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var1_33
					},
					intro = var4_33,
					onYes = var5_33
				})
			else
				var0_33()
			end
		else
			var0_33()
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	setActive(arg0_30.btnMultiple, AutoBotCommand.autoBotSatisfied() and arg0_30.chapter:isLoop())
	onButton(arg0_30, arg0_30.btnMultiple, function()
		local var0_36 = arg0_30:getSelectIds()
		local var1_36 = arg0_30:getSPItem()
		local var2_36 = arg0_30:GetOrderedDuties()

		arg0_30:emit(LevelUIConst.OPEN_NORMAL_CONTINUOUS_WINDOW, arg0_30.chapter, var0_36, var1_36, var2_36)
	end, SFX_PANEL)
	onButton(arg0_30, arg0_30.btnASHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0_30, arg0_30.btnBack, function()
		arg0_30:onCancel()
		arg0_30:onCancelSupport(true)
	end, SFX_CANCEL)
	onButton(arg0_30, arg0_30._tf:Find("bg"), function()
		arg0_30:onCancel()
		arg0_30:onCancelSupport(true)
	end, SFX_CANCEL)
	onButton(arg0_30, arg0_30.toggleMask, function()
		arg0_30:hideToggleMask()
	end, SFX_CANCEL)
	onToggle(arg0_30, arg0_30.formationToggle, function(arg0_41)
		if arg0_41 then
			arg0_30.contextData.tabIndex = var0_0.TabIndex.Formation

			arg0_30:updateFleets()
		end
	end, SFX_PANEL)
	onToggle(arg0_30, arg0_30.commanderToggle, function(arg0_42)
		if arg0_42 then
			arg0_30.contextData.tabIndex = var0_0.TabIndex.Commander

			arg0_30:updateFleets()
		end
	end, SFX_PANEL)
	onToggle(arg0_30, arg0_30.dutyToggle, function(arg0_43)
		if arg0_43 then
			arg0_30.contextData.tabIndex = var0_0.TabIndex.Duty

			arg0_30:updateFleets()
		end
	end, SFX_PANEL)
	setActive(arg0_30.formationToggle, true)
	setActive(arg0_30.commanderToggle, arg0_30.openedCommanerSystem)
	setActive(arg0_30.dutyToggle, arg0_30.dutyTabEnabled)
	setActive(arg0_30.adjustmentToggle, false)
	arg0_30:downloadLevelFleetViewResList(function()
		arg0_30:clearFleets()
		arg0_30:updateFleets()
		arg0_30:updateLimit()
		arg0_30:updateASValue()
		arg0_30:UpdateSonarRange()
		arg0_30:UpdateInvestigation()
	end)
end

function var0_0.getFleetById(arg0_45, arg1_45)
	return _.detect(arg0_45.fleets, function(arg0_46)
		return arg0_46.id == arg1_45
	end)
end

function var0_0.getLimitNums(arg0_47, arg1_47)
	local var0_47 = 0

	if arg1_47 == FleetType.Normal then
		var0_47 = arg0_47.chapter:getConfig("group_num")
	elseif arg1_47 == FleetType.Submarine then
		var0_47 = arg0_47.chapter:getConfig("submarine_num")
	elseif arg1_47 == FleetType.Support then
		var0_47 = arg0_47.chapter:getConfig("support_group_num")
	end

	return var0_47
end

function var0_0.getSelectIds(arg0_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in ipairs({
		FleetType.Normal,
		FleetType.Submarine
	}) do
		local var1_48 = arg0_48.selectIds[iter1_48]

		for iter2_48, iter3_48 in ipairs(var1_48) do
			if iter3_48 > 0 then
				table.insert(var0_48, iter3_48)
			end
		end
	end

	return var0_48
end

function var0_0.updateFleets(arg0_49)
	for iter0_49, iter1_49 in pairs(arg0_49.tfFleets) do
		for iter2_49 = 1, #iter1_49 do
			if iter0_49 == FleetType.Support then
				arg0_49:UpdateEliteFleet(iter0_49, iter2_49)
			else
				arg0_49:updateFleet(iter0_49, iter2_49)
			end
		end
	end

	arg0_49:RefreshDutyBar()
end

function var0_0.updateLimit(arg0_50)
	local var0_50 = #_.filter(arg0_50.selectIds[FleetType.Normal], function(arg0_51)
		return arg0_51 > 0
	end)
	local var1_50 = #_.filter(arg0_50.selectIds[FleetType.Submarine], function(arg0_52)
		return arg0_52 > 0
	end)
	local var2_50 = arg0_50:getLimitNums(FleetType.Normal)

	setText(arg0_50.tfLimit:Find("number"), string.format("%d/%d", var0_50, var2_50))

	local var3_50 = arg0_50:getLimitNums(FleetType.Submarine)

	setText(arg0_50.tfLimit:Find("number_sub"), string.format("%d/%d", var1_50, var3_50))
end

function var0_0.selectFleet(arg0_53, arg1_53, arg2_53, arg3_53)
	local var0_53 = arg0_53.selectIds[arg1_53]

	if arg3_53 > 0 and table.contains(var0_53, arg3_53) then
		return
	end

	if arg1_53 == FleetType.Normal and arg0_53:getLimitNums(arg1_53) > 0 and arg3_53 == 0 and #_.filter(var0_53, function(arg0_54)
		return arg0_54 > 0
	end) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_lease_one_ship"))

		return
	end

	local var1_53 = arg0_53:getFleetById(arg3_53)

	if var1_53 then
		if not var1_53:isUnlock() then
			return
		end

		if var1_53:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_not_enough"))

			return
		end
	end

	local var2_53 = {
		not arg0_53:IsListOfFleetEmpty(1) or nil,
		not arg0_53:IsListOfFleetEmpty(2) or nil
	}
	local var3_53 = var0_53[arg2_53]

	var0_53[arg2_53] = arg3_53

	arg0_53:updateFleet(arg1_53, arg2_53)
	arg0_53:updateLimit()
	arg0_53:updateASValue()
	arg0_53:UpdateSonarRange()
	arg0_53:RefreshDutyBar()

	local var4_53 = {
		not arg0_53:IsListOfFleetEmpty(1) or nil,
		not arg0_53:IsListOfFleetEmpty(2) or nil
	}

	if arg0_53.dutyTabEnabled and table.getCount(var2_53) == 2 and table.getCount(var4_53) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_change_tip"))
	end

	arg0_53:UpdateInvestigation()
end

function var0_0.updateFleet(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg0_55.contextData.tabIndex == var0_0.TabIndex.Formation
	local var1_55 = arg0_55.contextData.tabIndex == var0_0.TabIndex.Commander
	local var2_55 = arg0_55.contextData.tabIndex == var0_0.TabIndex.Duty
	local var3_55 = arg0_55.contextData.tabIndex == var0_0.TabIndex.Adjustment
	local var4_55 = arg0_55.selectIds[arg1_55][arg2_55]
	local var5_55 = arg0_55:getFleetById(var4_55)
	local var6_55 = arg2_55 <= arg0_55:getLimitNums(arg1_55)
	local var7_55 = arg0_55.tfFleets[arg1_55][arg2_55]
	local var8_55 = findTF(var7_55, "bg/name")
	local var9_55 = var7_55:Find("btn_select")
	local var10_55 = var7_55:Find("btn_recom")
	local var11_55 = var7_55:Find("btn_clear")
	local var12_55 = var7_55:Find("blank")
	local var13_55 = var7_55:Find("selected")
	local var14_55 = var7_55:Find("commander")
	local var15_55 = var7_55:Find("adjustment_flag")

	setActive(var10_55, false)
	setActive(var13_55, false)
	setText(var8_55, "")

	local var16_55 = var7_55:Find(TeamType.Main)
	local var17_55 = var7_55:Find(TeamType.Vanguard)

	if not var6_55 then
		setActive(var11_55, false)
		setActive(var9_55, false)
		setActive(var14_55, false)
		setActive(var15_55, false)
		setActive(var12_55, true)
		setActive(var16_55, false)

		if arg1_55 == FleetType.Normal then
			setActive(var17_55, false)
		end

		return
	end

	setActive(var11_55, var0_55)
	setActive(var9_55, var0_55)
	setActive(var14_55, var1_55 and var5_55)
	setActive(var15_55, var3_55)
	setActive(var12_55, var2_55 or var3_55 or var1_55 and not var5_55)
	setText(var8_55, var5_55 and var5_55:GetName() or "")
	setActive(var16_55, var5_55)

	if arg1_55 == FleetType.Normal then
		setActive(var17_55, var5_55)
	end

	if var5_55 then
		if arg1_55 == FleetType.Submarine then
			arg0_55:updateShips(var16_55, var5_55.subShips)
		else
			arg0_55:updateShips(var16_55, var5_55.mainShips)
			arg0_55:updateShips(var17_55, var5_55.vanguardShips)
		end

		arg0_55:updateCommanders(var14_55, var5_55)
	end

	onButton(arg0_55, var9_55, function()
		arg0_55.toggleList.position = (var9_55.position + var11_55.position) / 2
		arg0_55.toggleList.anchoredPosition = arg0_55.toggleList.anchoredPosition + Vector2(-arg0_55.toggleList.rect.width / 2, -var9_55.rect.height / 2)

		arg0_55:showToggleMask(arg1_55, function(arg0_57)
			arg0_55:hideToggleMask()
			arg0_55:selectFleet(arg1_55, arg2_55, arg0_57)
		end)
	end, SFX_UI_CLICK)
	onButton(arg0_55, var11_55, function()
		arg0_55:selectFleet(arg1_55, arg2_55, 0)
	end, SFX_UI_CLICK)
end

function var0_0.updateCommanders(arg0_59, arg1_59, arg2_59)
	for iter0_59 = 1, 2 do
		local var0_59 = arg2_59:getCommanderByPos(iter0_59)
		local var1_59 = arg1_59:Find("pos" .. iter0_59)
		local var2_59 = var1_59:Find("add")
		local var3_59 = var1_59:Find("info")

		setActive(var2_59, not var0_59)
		setActive(var3_59, var0_59)

		if var0_59 then
			local var4_59 = Commander.rarity2Frame(var0_59:getRarity())

			setImageSprite(var3_59:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var4_59))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var0_59:getPainting(), "", var3_59:Find("mask/icon"))
		end

		onButton(arg0_59, var2_59, function()
			arg0_59:emit(LevelUIConst.OPEN_COMMANDER_PANEL, arg2_59, arg0_59.chapter)
		end, SFX_PANEL)
		onButton(arg0_59, var3_59, function()
			arg0_59:emit(LevelUIConst.OPEN_COMMANDER_PANEL, arg2_59, arg0_59.chapter)
		end, SFX_PANEL)
	end
end

function var0_0.updateShips(arg0_62, arg1_62, arg2_62)
	local var0_62 = UIItemList.New(arg1_62, arg0_62.tfShipTpl)

	var0_62:make(function(arg0_63, arg1_63, arg2_63)
		if arg0_63 == UIItemList.EventUpdate then
			local var0_63 = getProxy(BayProxy):getShipById(arg2_62[arg1_63 + 1])

			updateShip(arg2_63, var0_63)
			setActive(findTF(arg2_63, "ship_type"), false)

			local var1_63 = arg2_63:Find("icon_bg/energy")
			local var2_63 = var0_63:getEnergeConfig()

			if var2_63 and var2_63.id <= 2 then
				setActive(var1_63, true)
				GetImageSpriteFromAtlasAsync("energy", var2_63.icon, var1_63)
			else
				setActive(var1_63, false)
			end
		end
	end)
	var0_62:align(#arg2_62)

	for iter0_62, iter1_62 in ipairs(arg2_62) do
		local var1_62 = arg1_62:GetChild(iter0_62 - 1)
		local var2_62 = GetOrAddComponent(var1_62, "UILongPressTrigger").onLongPressed

		pg.DelegateInfo.Add(arg0_62, var2_62)
		var2_62:RemoveAllListeners()
		var2_62:AddListener(function()
			arg0_62:emit(LevelMediator2.ON_SHIP_DETAIL, {
				id = iter1_62,
				chapter = arg0_62.chapter
			})
		end)
	end
end

function var0_0.showToggleMask(arg0_65, arg1_65, arg2_65)
	setActive(arg0_65.toggleMask, true)

	local var0_65 = _.filter(arg0_65.fleets, function(arg0_66)
		return arg0_66:getFleetType() == arg1_65
	end)

	for iter0_65, iter1_65 in ipairs(arg0_65.toggles) do
		local var1_65 = var0_65[iter0_65]

		setActive(iter1_65, var1_65)

		if var1_65 then
			local var2_65 = iter1_65:GetComponent(typeof(Toggle))
			local var3_65 = iter1_65:Find("lock")
			local var4_65, var5_65 = var1_65:isUnlock()

			setToggleEnabled(iter1_65, var4_65)
			setActive(var3_65, not var4_65)

			local var6_65 = table.contains(arg0_65.selectIds[arg1_65], var1_65.id)

			setActive(iter1_65:Find("on"), var6_65)
			setActive(iter1_65:Find("off"), not var6_65)

			if var4_65 then
				var2_65.isOn = false

				onToggle(arg0_65, iter1_65, function(arg0_67)
					if arg0_67 then
						setActive(arg0_65.toggleMask, false)
						arg2_65(var1_65.id)
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0_65, var3_65, function()
					pg.TipsMgr.GetInstance():ShowTips(var5_65)
				end, SFX_UI_CLICK)
			end
		end
	end
end

function var0_0.hideToggleMask(arg0_69)
	setActive(arg0_69.toggleMask, false)
end

function var0_0.clearFleets(arg0_70)
	for iter0_70, iter1_70 in pairs(arg0_70.tfFleets) do
		_.each(iter1_70, function(arg0_71)
			arg0_70:clearFleet(arg0_71)
		end)
	end
end

function var0_0.UpdateInvestigation(arg0_72)
	if not arg0_72.chapter:existAmbush() then
		arg0_72:UpdateLoopInvestigation()

		return
	end

	local var0_72 = 0

	for iter0_72 = 1, 2 do
		local var1_72 = arg0_72.selectIds[FleetType.Normal][iter0_72] or 0
		local var2_72 = arg0_72:getFleetById(var1_72)
		local var3_72 = var2_72 and math.floor(var2_72:getInvestSums(true)) or 0

		var0_72 = math.max(var0_72, var3_72)
	end

	local var4_72 = arg0_72.chapter:getConfig("avoid_require")

	arg0_72:UpdateInvestigationComparision(var0_72, var4_72)
end

function var0_0.UpdateEliteInvestigation(arg0_73)
	if not arg0_73.chapter:existAmbush() then
		arg0_73:UpdateLoopInvestigation()

		return
	end

	local var0_73 = 0

	for iter0_73 = 1, 2 do
		local var1_73 = 0

		if iter0_73 <= arg0_73.chapter:GetNomralFleetMaxCount() then
			local var2_73 = arg0_73.eliteFleetList[iter0_73]
			local var3_73 = {}

			for iter1_73, iter2_73 in pairs(arg0_73.eliteCommanderList[iter0_73]) do
				table.insert(var3_73, {
					pos = iter1_73,
					id = iter2_73
				})
			end

			local var4_73 = TypedFleet.New({
				ship_list = var2_73,
				commanders = var3_73,
				fleetType = FleetType.Normal
			})

			var1_73 = math.floor(var4_73:getInvestSums())
		end

		var0_73 = math.max(var0_73, var1_73)
	end

	local var5_73 = arg0_73.chapter:getConfig("avoid_require")

	arg0_73:UpdateInvestigationComparision(var0_73, var5_73)
end

function var0_0.UpdateLoopInvestigation(arg0_74)
	local var0_74 = arg0_74.dropDown:Find("Investigation")

	setText(var0_74:Find("Value1"), "-")
	setText(var0_74:Find("Value2"), "-")
	triggerToggle(arg0_74.dropDownSide:Find("Layout/Item1/Dot"), true)
end

function var0_0.UpdateInvestigationComparision(arg0_75, arg1_75, arg2_75)
	arg1_75 = math.floor(arg1_75)

	local var0_75 = arg0_75.dropDown:Find("Investigation")
	local var1_75 = arg2_75 <= arg1_75

	setText(var0_75:Find("Value1"), setColorStr(arg1_75, var1_75 and "#51FF55" or COLOR_WHITE))
	setText(var0_75:Find("Value2"), arg2_75)
	triggerToggle(arg0_75.dropDownSide:Find("Layout/Item1/Dot"), var1_75)
end

function var0_0.updateASValue(arg0_76)
	if arg0_76.chapterASValue <= 0 then
		arg0_76:UpdateBannedAS()

		return
	end

	local var0_76 = 0

	for iter0_76 = 1, 2 do
		local var1_76 = arg0_76.selectIds[FleetType.Normal][iter0_76] or 0
		local var2_76 = arg0_76:getFleetById(var1_76)

		var0_76 = var0_76 + (var2_76 and var2_76:getFleetAirDominanceValue() or 0)
	end

	for iter1_76 = 1, 1 do
		local var3_76 = arg0_76.selectIds[FleetType.Submarine][iter1_76] or 0
		local var4_76 = arg0_76:getFleetById(var3_76)

		var0_76 = var0_76 + (var4_76 and var4_76:getFleetAirDominanceValue() or 0)
	end

	arg0_76:UpdateASComparision(var0_76, arg0_76.suggestionValue)
end

function var0_0.updateEliteASValue(arg0_77)
	if arg0_77.chapterASValue <= 0 then
		arg0_77:UpdateBannedAS()

		return
	end

	local var0_77 = getProxy(BayProxy)
	local var1_77 = 0

	for iter0_77, iter1_77 in ipairs(arg0_77.eliteFleetList) do
		local var2_77 = {}

		for iter2_77, iter3_77 in pairs(arg0_77.eliteCommanderList[iter0_77]) do
			var2_77[iter2_77] = getProxy(CommanderProxy):RawGetCommanderById(iter3_77)
		end

		for iter4_77, iter5_77 in ipairs(iter1_77) do
			var1_77 = var1_77 + calcAirDominanceValue(var0_77:RawGetShipById(iter5_77), var2_77)
		end
	end

	arg0_77:UpdateASComparision(var1_77, arg0_77.suggestionValue)
end

function var0_0.UpdateBannedAS(arg0_78)
	local var0_78 = arg0_78.dropDown:Find("Airsupport")

	setText(var0_78:Find("Value1"), "-")
	setText(var0_78:Find("Value2"), "-")
	triggerToggle(arg0_78.dropDownSide:Find("Layout/Item2/Dot"), true)
end

function var0_0.UpdateASComparision(arg0_79, arg1_79, arg2_79)
	arg1_79 = math.floor(arg1_79)

	local var0_79 = arg0_79.dropDown:Find("Airsupport")

	setText(var0_79:Find("Text"), i18n("level_scene_title_word_3"))

	local var1_79 = arg2_79 < arg1_79

	setText(var0_79:Find("Value1"), setColorStr(arg1_79, var1_79 and "#51FF55" or COLOR_WHITE))
	setText(var0_79:Find("Value2"), arg2_79)
	triggerToggle(arg0_79.dropDownSide:Find("Layout/Item2/Dot"), var1_79)
end

function var0_0.UpdateSonarRange(arg0_80)
	for iter0_80 = 1, 2 do
		local var0_80 = arg0_80.selectIds[FleetType.Normal][iter0_80] or 0
		local var1_80 = arg0_80:getFleetById(var0_80)
		local var2_80 = var1_80 and math.floor(var1_80:GetFleetSonarRange()) or 0

		arg0_80:UpdateSonarRangeValues(iter0_80, var2_80)
	end
end

function var0_0.UpdateEliteSonarRange(arg0_81)
	for iter0_81 = 1, 2 do
		if not arg0_81.eliteFleetList[iter0_81] then
			arg0_81:UpdateSonarRangeValues(iter0_81, 0)
		else
			local var0_81 = arg0_81.eliteFleetList[iter0_81]
			local var1_81 = {}

			for iter1_81, iter2_81 in pairs(arg0_81.eliteCommanderList[iter0_81]) do
				table.insert(var1_81, {
					pos = iter1_81,
					id = iter2_81
				})
			end

			local var2_81 = TypedFleet.New({
				ship_list = var0_81,
				commanders = var1_81,
				fleetType = FleetType.Normal
			})
			local var3_81 = var2_81 and math.floor(var2_81:GetFleetSonarRange()) or 0

			arg0_81:UpdateSonarRangeValues(iter0_81, var3_81)
		end
	end
end

function var0_0.UpdateSonarRangeValues(arg0_82, arg1_82, arg2_82)
	local var0_82 = arg0_82.dropDownSide:Find("Layout/Item3/Values")

	setText(var0_82:GetChild(arg1_82 - 1), arg2_82)
end

function var0_0.clearFleet(arg0_83, arg1_83)
	local var0_83 = arg1_83:Find(TeamType.Main)
	local var1_83 = arg1_83:Find(TeamType.Vanguard)

	if var0_83 then
		removeAllChildren(var0_83)
	end

	if var1_83 then
		removeAllChildren(var1_83)
	end
end

function var0_0.clear(arg0_84)
	arg0_84.contextData.tabIndex = nil
	arg0_84.duties = nil
end

function var0_0.onCancelHard(arg0_85, arg1_85)
	if arg1_85 then
		arg0_85:emit(LevelMediator2.ON_UPDATE_CUSTOM_FLEET, arg0_85.chapter)
	end

	arg0_85:emit(LevelUIConst.HIDE_FLEET_EDIT)
end

function var0_0.setHardShipVOs(arg0_86, arg1_86)
	arg0_86.shipVOs = arg1_86
end

function var0_0.setOnHard(arg0_87, arg1_87)
	arg0_87.chapter = arg1_87
	arg0_87.mode = var2_0.EDIT
	arg0_87.eliteFleetList = arg0_87.chapter:getEliteFleetList()
	arg0_87.eliteCommanderList = arg0_87.chapter:getEliteFleetCommanders()
	arg0_87.propetyLimitation = arg0_87.chapter:getConfig("property_limitation")
	arg0_87.chapterASValue = arg0_87.chapter:getConfig("air_dominance")
	arg0_87.suggestionValue = arg0_87.chapter:getConfig("best_air_dominance")
	arg0_87.typeLimitations = arg0_87.chapter:getConfig("limitation")

	arg0_87:SetDutyTabEnabled(arg1_87:isLoop())

	local var0_87 = arg0_87:getLimitNums(FleetType.Support) > 0

	setActive(arg0_87.supportFleetHelp, var0_87)

	arg0_87.displayMode = var0_87 and var3_0.ADDITION_SUPPORT or var3_0.NORMAL

	arg0_87:SwitchDisplayMode()

	arg0_87.duties = {}

	local var1_87 = PlayerPrefs.GetInt("lastFleetDuty_" .. (arg0_87.chapter.id or 0), 0)

	if var1_87 > 0 then
		local var2_87 = bit.band(var1_87, 255)
		local var3_87 = bit.rshift(var1_87, 8)
		local var4_87 = bit.band(var3_87, 255)

		if var2_87 > 0 and var4_87 > 0 then
			arg0_87.duties[var2_87] = var4_87
		end
	end

	onButton(arg0_87, arg0_87.btnGo, function()
		local var0_88 = "chapter_autofight_flag_" .. arg0_87.chapter.id
		local var1_88 = arg0_87.chapter
		local var2_88
		local var3_88

		seriesAsync({
			function(arg0_89)
				local var0_89 = PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1

				if not (PlayerPrefs.GetInt(var0_88, 1) == 1) or not arg0_87:getSPItem() or var0_89 then
					return arg0_89()
				end

				PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
				PlayerPrefs.Save()

				local function var1_89()
					arg0_87:clearSPBuff()
				end

				arg0_87:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
					hideNo = true,
					content = i18n("autofight_special_operation_tip"),
					onYes = var1_89,
					onNo = var1_89
				})
			end,
			function(arg0_91)
				var2_88 = arg0_87.chapter:GetActiveSPItemID()
				var3_88 = arg0_87.chapter:isLoop() and arg0_87:GetOrderedDuties() or nil

				arg0_87:clear()
				arg0_87:onCancelHard()
				arg0_91()
			end,
			function(arg0_92)
				local var0_92 = PlayerPrefs.GetInt(var0_88, 1) == 1
				local var1_92 = LevelMediator2.ON_ELITE_TRACKING
				local var2_92 = packEx(var1_88.id, var1_88.loopFlag, var2_88, var3_88, var0_92)

				if pg.m02:retrieveMediator(LevelMediator2.__cname) then
					pg.m02:sendNotification(var1_92, var2_92)

					return
				end

				local var3_92 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

				if var3_92 then
					var3_92:extendData({
						ToTrackingData = {
							var1_92,
							var2_92
						}
					})
				end
			end
		})
	end, SFX_UI_WEIGHANCHOR_GO)
	setActive(arg0_87.btnMultiple, AutoBotCommand.autoBotSatisfied() and arg0_87.chapter:isLoop())
	onButton(arg0_87, arg0_87.btnMultiple, function()
		local var0_93 = arg0_87:getSPItem()
		local var1_93 = arg0_87:GetOrderedDuties()

		arg0_87:emit(LevelUIConst.OPEN_ELITE_CONTINUOUS_WINDOW, arg0_87.chapter, var0_93, var1_93)
	end, SFX_PANEL)
	onButton(arg0_87, arg0_87.btnASHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0_87, arg0_87.btnBack, function()
		arg0_87:clear()
		arg0_87:onCancelHard(true)
	end, SFX_CANCEL)
	onButton(arg0_87, arg0_87._tf:Find("bg"), function()
		arg0_87:clear()
		arg0_87:onCancelHard(true)
	end, SFX_CANCEL)
	onToggle(arg0_87, arg0_87.commanderToggle, function(arg0_97)
		if arg0_97 then
			arg0_87.contextData.tabIndex = var0_0.TabIndex.Commander

			arg0_87:flush()
		end
	end, SFX_PANEL)
	onToggle(arg0_87, arg0_87.formationToggle, function(arg0_98)
		if arg0_98 then
			arg0_87.contextData.tabIndex = var0_0.TabIndex.Formation

			arg0_87:flush()
		end
	end, SFX_PANEL)
	onToggle(arg0_87, arg0_87.dutyToggle, function(arg0_99)
		if arg0_99 then
			arg0_87.contextData.tabIndex = var0_0.TabIndex.Duty

			arg0_87:flush()
		end
	end, SFX_UI_TAG)
	onToggle(arg0_87, arg0_87.adjustmentToggle, function(arg0_100)
		if arg0_100 then
			arg0_87.contextData.tabIndex = var0_0.TabIndex.Adjustment

			arg0_87:flush()
		end
	end, SFX_PANEL)
	setActive(arg0_87.formationToggle, true)
	setActive(arg0_87.commanderToggle, arg0_87.openedCommanerSystem)
	setActive(arg0_87.dutyToggle, arg0_87.dutyTabEnabled)
	setActive(arg0_87.adjustmentToggle, true)
	arg0_87:downloadLevelFleetViewResList(function()
		arg0_87:flush()
	end)
end

function var0_0.flush(arg0_102)
	arg0_102:updateEliteLimit()
	arg0_102:updateEliteASValue()

	arg0_102.lastFleetValidStatus = arg0_102.lastFleetValidStatus or {}

	local var0_102 = {
		not arg0_102:IsListOfFleetEmpty(1) or nil,
		not arg0_102:IsListOfFleetEmpty(2) or nil
	}

	if arg0_102.dutyTabEnabled and table.getCount(arg0_102.lastFleetValidStatus) == 2 and table.getCount(var0_102) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_change_tip"))
	end

	arg0_102.lastFleetValidStatus = var0_102

	arg0_102:updateEliteFleets()
	arg0_102:UpdateEliteSonarRange()
	arg0_102:UpdateEliteInvestigation()
end

function var0_0.updateEliteLimit(arg0_103)
	setActive(arg0_103.toggleMask, false)
	setActive(arg0_103.tfLimit, false)
	setActive(arg0_103.tfLimitTips, #arg0_103.propetyLimitation == 0)
	setActive(arg0_103.tfLimitElite, #arg0_103.propetyLimitation > 0)
	setActive(arg0_103.tfLimitSubTip, #arg0_103.propetyLimitation > 0)

	if #arg0_103.propetyLimitation > 0 then
		local var0_103, var1_103 = arg0_103.chapter:IsPropertyLimitationSatisfy()
		local var2_103 = UIItemList.New(arg0_103.tfLimitContainer, arg0_103.tfLimitContainer:GetChild(0))

		var2_103:make(function(arg0_104, arg1_104, arg2_104)
			arg1_104 = arg1_104 + 1

			if arg0_104 == UIItemList.EventUpdate then
				local var0_104 = arg0_103.propetyLimitation[arg1_104]
				local var1_104, var2_104, var3_104, var4_104 = unpack(var0_104)

				if var0_103[arg1_104] == 1 then
					arg2_104:Find("Text"):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
				else
					arg2_104:Find("Text"):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
				end

				setActive(arg2_104, true)

				local var5_104 = (AttributeType.EliteCondition2Name(var1_104, var4_104) .. AttributeType.eliteConditionCompareTip(var2_104) .. var3_104) .. "（" .. var1_103[var1_104] .. "）"

				setText(arg2_104:Find("Text"), var5_104)
			end
		end)
		var2_103:align(#arg0_103.propetyLimitation)
		setActive(arg0_103.tfLimitSubTip, arg0_103.chapter:getConfig("submarine_num") > 0)
	end

	local var3_103 = arg0_103.chapter:isLoop() and arg0_103.chapter:getConfig("use_oil_limit") or {}

	setActive(arg0_103.rtCostLimit, #var3_103 > 0)
	setText(arg0_103.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip"))

	if #var3_103 > 0 then
		setActive(arg0_103.rtCostLimit:Find("cost_noraml"), var3_103[1] > 0)
		setText(arg0_103.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_enemy"), var3_103[1]))
		setActive(arg0_103.rtCostLimit:Find("cost_boss"), var3_103[2] > 0)
		setText(arg0_103.rtCostLimit:Find("cost_boss/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_flagship"), var3_103[2]))
		setActive(arg0_103.rtCostLimit:Find("cost_sub"), var3_103[3] > 0)
		setText(arg0_103.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var3_103[3]))
	end
end

function var0_0.initAddButton(arg0_105, arg1_105, arg2_105, arg3_105, arg4_105)
	local var0_105 = arg0_105.eliteFleetList[arg4_105]
	local var1_105 = {}
	local var2_105 = {}

	for iter0_105, iter1_105 in ipairs(var0_105) do
		var1_105[arg0_105.shipVOs[iter1_105]] = true

		if not arg2_105 or arg2_105 == arg0_105.shipVOs[iter1_105]:getTeamType() then
			table.insert(var2_105, iter1_105)
		end
	end

	removeAllChildren(arg1_105)

	local var3_105 = 0
	local var4_105 = false
	local var5_105 = 0

	arg3_105 = var0_0.sortTeamLimitation(arg3_105)

	local var6_105 = arg1_105:GetComponent("ContentSizeFitter")
	local var7_105 = arg1_105:GetComponent("HorizontalLayoutGroup")

	var6_105.enabled = true
	var7_105.enabled = true
	arg0_105.isDraging = false

	for iter2_105 = 1, 3 do
		local var8_105
		local var9_105
		local var10_105
		local var11_105 = var2_105[iter2_105] and arg0_105.shipVOs[var2_105[iter2_105]] or nil

		if var11_105 then
			for iter3_105, iter4_105 in ipairs(arg3_105) do
				if ShipType.ContainInLimitBundle(iter4_105, var11_105:getShipType()) then
					var9_105 = var11_105
					var10_105 = iter4_105

					table.remove(arg3_105, iter3_105)

					var4_105 = var4_105 or iter4_105 ~= 0

					break
				end
			end
		else
			var10_105 = arg3_105[1]

			table.remove(arg3_105, 1)
		end

		if var10_105 == 0 then
			var5_105 = var5_105 + 1
		end

		local var12_105 = var9_105 and cloneTplTo(arg0_105.tfShipTpl, arg1_105) or cloneTplTo(arg0_105.tfEmptyTpl, arg1_105)

		setActive(var12_105, true)

		if var9_105 then
			updateShip(var12_105, var9_105)
			setActive(var12_105:Find("event_block"), var9_105:getFlag("inEvent"))

			var1_105[var9_105] = true
		else
			var3_105 = var3_105 + 1
		end

		setActive(var12_105:Find("ship_type"), var10_105 and var10_105 ~= 0)

		if var10_105 and var10_105 ~= 0 then
			if type(var10_105) == "number" then
				local var13_105 = GetSpriteFromAtlas("shiptype", ShipType.Type2CNLabel(var10_105))

				setImageSprite(var12_105:Find("ship_type"), var13_105, true)
			elseif type(var10_105) == "string" then
				local var14_105 = GetSpriteFromAtlas("shiptype", ShipType.BundleType2CNLabel(var10_105))

				setImageSprite(var12_105:Find("ship_type"), var14_105, true)
			end
		end

		local var15_105 = _.map(var0_105, function(arg0_106)
			return arg0_105.shipVOs[arg0_106]
		end)

		table.sort(var15_105, function(arg0_107, arg1_107)
			return var1_0[arg0_107:getTeamType()] < var1_0[arg1_107:getTeamType()] or var1_0[arg0_107:getTeamType()] == var1_0[arg1_107:getTeamType()] and table.indexof(var0_105, arg0_107.id) < table.indexof(var0_105, arg1_107.id)
		end)

		local var16_105 = GetOrAddComponent(var12_105, typeof(UILongPressTrigger))

		var16_105.onLongPressed:RemoveAllListeners()

		if var9_105 and arg0_105.contextData.tabIndex ~= var0_0.TabIndex.Adjustment then
			var16_105.onLongPressed:AddListener(function()
				arg0_105:onCancelHard(true)
				arg0_105:emit(LevelMediator2.ON_FLEET_SHIPINFO, {
					shipId = var9_105.id,
					shipVOs = var15_105,
					chapter = arg0_105.chapter
				})
			end)
		end

		local var17_105 = GetOrAddComponent(var12_105, "EventTriggerListener")

		var17_105:RemovePointClickFunc()
		var17_105:AddPointClickFunc(function(arg0_109, arg1_109)
			if arg0_109 ~= var12_105.gameObject then
				return
			end

			if arg0_105.isDraging then
				return
			end

			arg0_105:onCancelHard()
			arg0_105:emit(LevelMediator2.ON_ELITE_OEPN_DECK, {
				shipType = var10_105,
				fleet = var1_105,
				chapter = arg0_105.chapter,
				shipVO = var9_105,
				fleetIndex = arg4_105,
				teamType = arg2_105
			})
		end)
		var17_105:RemoveBeginDragFunc()
		var17_105:RemoveDragFunc()
		var17_105:RemoveDragEndFunc()

		if var9_105 and arg0_105.contextData.tabIndex == var0_0.TabIndex.Adjustment then
			local var18_105 = var12_105.rect.width * 0.5
			local var19_105 = {}
			local var20_105 = {}

			var17_105:AddBeginDragFunc(function(arg0_110, arg1_110)
				if arg0_110 ~= var12_105.gameObject then
					return
				end

				if arg0_105.isDraging then
					return
				end

				arg0_105.isDraging = true
				var6_105.enabled = false
				var7_105.enabled = false

				for iter0_110 = 1, 3 do
					local var0_110 = arg1_105:GetChild(iter0_110 - 1)

					if var12_105 == var0_110 then
						arg0_105.dragIndex = iter0_110
					end

					var19_105[iter0_110] = var0_110.anchoredPosition
					var20_105[iter0_110] = var0_110
				end
			end)
			var17_105:AddDragFunc(function(arg0_111, arg1_111)
				if arg0_111 ~= var12_105.gameObject then
					return
				end

				if not arg0_105.isDraging then
					return
				end

				local var0_111 = var12_105.localPosition

				var0_111.x = arg0_105:change2ScrPos(var12_105.parent, arg1_111.position).x
				var0_111.x = math.clamp(var0_111.x, var19_105[1].x, var19_105[3].x)
				var12_105.localPosition = var0_111

				local var1_111 = 1

				for iter0_111 = 1, 3 do
					if var12_105 ~= var20_105[iter0_111] and var12_105.localPosition.x > var20_105[iter0_111].localPosition.x + (var1_111 < arg0_105.dragIndex and 1.1 or -1.1) * var18_105 then
						var1_111 = var1_111 + 1
					end
				end

				if arg0_105.dragIndex ~= var1_111 then
					local var2_111 = var1_111 < arg0_105.dragIndex and -1 or 1

					while arg0_105.dragIndex ~= var1_111 do
						local var3_111 = arg0_105.dragIndex
						local var4_111 = arg0_105.dragIndex + var2_111

						var2_105[var3_111], var2_105[var4_111] = var2_105[var4_111], var2_105[var3_111]
						var20_105[var3_111], var20_105[var4_111] = var20_105[var4_111], var20_105[var3_111]
						arg0_105.dragIndex = arg0_105.dragIndex + var2_111
					end

					for iter1_111 = 1, 3 do
						if var12_105 ~= var20_105[iter1_111] then
							var20_105[iter1_111].anchoredPosition = var19_105[iter1_111]
						end
					end
				end
			end)
			var17_105:AddDragEndFunc(function(arg0_112, arg1_112)
				if arg0_112 ~= var12_105.gameObject then
					return
				end

				if not arg0_105.isDraging then
					return
				end

				arg0_105.isDraging = false

				for iter0_112 = 1, 3 do
					if not var2_105[iter0_112] then
						for iter1_112 = iter0_112 + 1, 3 do
							if var2_105[iter1_112] then
								var2_105[iter0_112], var2_105[iter1_112] = var2_105[iter1_112], var2_105[iter0_112]
								var20_105[iter0_112], var20_105[iter1_112] = var20_105[iter1_112], var20_105[iter0_112]
							end
						end
					end

					if var2_105[iter0_112] then
						table.removebyvalue(var0_105, var2_105[iter0_112])
						table.insert(var0_105, var2_105[iter0_112])
					else
						break
					end
				end

				for iter2_112 = 1, 3 do
					var20_105[iter2_112]:SetSiblingIndex(iter2_112 - 1)
				end

				var6_105.enabled = true
				var7_105.enabled = true
				arg0_105.dragIndex = nil

				arg0_105.chapter:setEliteFleetByIndex(arg4_105, {
					{
						TeamType.FormShips,
						underscore.to_array(var0_105)
					}
				})
				arg0_105:emit(LevelMediator2.ON_ELITE_ADJUSTMENT, arg0_105.chapter)
			end)
		end
	end

	if (var4_105 == true or var5_105 == 3) and var3_105 ~= 3 then
		return true
	else
		return false
	end
end

function var0_0.change2ScrPos(arg0_113, arg1_113, arg2_113)
	local var0_113 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1_113, arg2_113, var0_113))
end

function var0_0.updateEliteFleets(arg0_114)
	for iter0_114, iter1_114 in pairs(arg0_114.tfFleets) do
		for iter2_114 = 1, #iter1_114 do
			arg0_114:UpdateEliteFleet(iter0_114, iter2_114)
		end
	end

	arg0_114:RefreshDutyBar()
end

function var0_0.UpdateEliteFleet(arg0_115, arg1_115, arg2_115)
	local var0_115 = arg0_115.contextData.tabIndex == var0_0.TabIndex.Formation
	local var1_115 = arg0_115.contextData.tabIndex == var0_0.TabIndex.Commander
	local var2_115 = arg0_115.contextData.tabIndex == var0_0.TabIndex.Duty
	local var3_115 = arg0_115.contextData.tabIndex == var0_0.TabIndex.Adjustment
	local var4_115 = arg2_115 <= arg0_115:getLimitNums(arg1_115)
	local var5_115 = arg0_115.tfFleets[arg1_115][arg2_115]
	local var6_115 = findTF(var5_115, "bg/name")
	local var7_115 = var5_115:Find("btn_select")
	local var8_115 = var5_115:Find("btn_recom")
	local var9_115 = var5_115:Find("btn_clear")
	local var10_115 = var5_115:Find("blank")
	local var11_115 = var5_115:Find("selected")
	local var12_115 = var5_115:Find("commander")
	local var13_115 = var5_115:Find("adjustment_flag")

	setActive(var7_115, false)

	local var14_115 = var5_115:Find(TeamType.Main)
	local var15_115 = var5_115:Find(TeamType.Vanguard)

	if not var4_115 then
		setActive(var9_115, false)
		setActive(var8_115, false)
		setActive(var12_115, false)
		setActive(var13_115, false)
		setActive(var10_115, true)
		setActive(var11_115, false)
		setText(var6_115, "")
		setActive(var14_115, false)

		if arg1_115 == FleetType.Normal then
			setActive(var15_115, false)
		end

		return
	end

	local var16_115 = arg1_115 == FleetType.Support

	setActive(var9_115, var0_115)
	setActive(var8_115, var0_115)
	setActive(var12_115, var1_115 and not var16_115)
	setActive(var13_115, var3_115)
	setActive(var10_115, var2_115 or var3_115 or var1_115 and var16_115)

	local var17_115 = arg2_115

	if arg1_115 == FleetType.Normal then
		setText(var6_115, Fleet.DEFAULT_NAME[arg2_115])
		setActive(var14_115, true)
		setActive(var15_115, true)
	elseif arg1_115 == FleetType.Submarine then
		var17_115 = 3

		setText(var6_115, Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID + arg2_115 - 1])
		setActive(var14_115, true)
	elseif arg1_115 == FleetType.Support then
		var17_115 = 4

		setText(var6_115, i18n("ship_formationUI_fleetName13"))
		setActive(var14_115, true)
	end

	local var18_115 = 6

	if arg1_115 == FleetType.Normal then
		local var19_115 = arg0_115.typeLimitations[arg2_115]
		local var20_115 = var19_115[1]
		local var21_115 = var19_115[2]
		local var22_115 = arg0_115:initAddButton(var5_115:Find(TeamType.Main), TeamType.Main, var20_115, var17_115)
		local var23_115 = arg0_115:initAddButton(var5_115:Find(TeamType.Vanguard), TeamType.Vanguard, var21_115, var17_115)

		setActive(var11_115, var22_115 and var23_115)
	elseif arg1_115 == FleetType.Submarine then
		var18_115 = 3

		local var24_115 = arg0_115:initAddButton(var5_115:Find(TeamType.Main), TeamType.Submarine, {
			0,
			0,
			0
		}, var17_115)

		setActive(var11_115, var24_115)
	elseif arg1_115 == FleetType.Support then
		var18_115 = 3

		local var25_115 = arg0_115.chapter:getConfigMiscArg("submarine_support") and {
			"qian",
			"qian",
			"qian"
		} or {
			"hang",
			"hang",
			"hang"
		}
		local var26_115 = arg0_115:initSupportAddButton(var5_115:Find(TeamType.Main), nil, var25_115, var17_115)

		setActive(var11_115, arg0_115.mode == var2_0.EDIT and var26_115)
	end

	if not var16_115 then
		arg0_115:initCommander(var17_115, var12_115, arg0_115.chapter)
	end

	onButton(arg0_115, var9_115, function()
		if #(not var16_115 and arg0_115.eliteFleetList[var17_115] or arg0_115.supportFleet) == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("battle_preCombatLayer_clear_confirm"),
			onYes = function()
				arg0_115:emit(LevelMediator2.ON_ELITE_CLEAR, {
					index = var17_115,
					chapterVO = arg0_115.chapter
				})
			end
		})
	end)
	onButton(arg0_115, var8_115, function()
		local var0_118 = #(not var16_115 and arg0_115.eliteFleetList[var17_115] or arg0_115.supportFleet)

		if var0_118 == var18_115 then
			return
		end

		seriesAsync({
			function(arg0_119)
				if var0_118 == 0 then
					return arg0_119()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("battle_preCombatLayer_auto_confirm"),
					onYes = arg0_119
				})
			end,
			function()
				arg0_115:emit(LevelMediator2.ON_ELITE_RECOMMEND, {
					index = var17_115,
					chapterVO = arg0_115.chapter
				})
			end
		})
	end)
end

function var0_0.initCommander(arg0_121, arg1_121, arg2_121, arg3_121)
	local var0_121 = arg3_121:getEliteFleetCommanders()[arg1_121]

	for iter0_121 = 1, 2 do
		local var1_121 = var0_121[iter0_121]
		local var2_121 = var1_121 and getProxy(CommanderProxy):getCommanderById(var1_121)
		local var3_121 = arg2_121:Find("pos" .. iter0_121)
		local var4_121 = var3_121:Find("add")
		local var5_121 = var3_121:Find("info")

		setActive(var4_121, not var2_121)
		setActive(var5_121, var2_121)

		if var2_121 then
			local var6_121 = Commander.rarity2Frame(var2_121:getRarity())

			setImageSprite(var5_121:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_121))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_121:getPainting(), "", var5_121:Find("mask/icon"))
		end

		local var7_121 = arg3_121:wrapEliteFleet(arg1_121)

		onButton(arg0_121, var4_121, function()
			arg0_121:emit(LevelUIConst.OPEN_COMMANDER_PANEL, var7_121, arg3_121, arg1_121)
		end, SFX_PANEL)
		onButton(arg0_121, var5_121, function()
			arg0_121:emit(LevelUIConst.OPEN_COMMANDER_PANEL, var7_121, arg3_121, arg1_121)
		end, SFX_PANEL)
	end
end

function var0_0.initSupportAddButton(arg0_124, arg1_124, arg2_124, arg3_124, arg4_124)
	local var0_124 = {}
	local var1_124 = {}

	for iter0_124, iter1_124 in ipairs(arg0_124.supportFleet) do
		var0_124[arg0_124.shipVOs[iter1_124]] = true

		if not arg2_124 or arg2_124 == arg0_124.shipVOs[iter1_124]:getTeamType() then
			table.insert(var1_124, iter1_124)
		end
	end

	removeAllChildren(arg1_124)

	local var2_124 = 0
	local var3_124 = false
	local var4_124 = 0

	arg3_124 = var0_0.sortTeamLimitation(arg3_124)

	for iter2_124 = 1, 3 do
		local var5_124
		local var6_124
		local var7_124 = var1_124[iter2_124] and arg0_124.shipVOs[var1_124[iter2_124]] or nil

		if var7_124 then
			for iter3_124, iter4_124 in ipairs(arg3_124) do
				if ShipType.ContainInLimitBundle(iter4_124, var7_124:getShipType()) then
					var5_124 = var7_124
					var6_124 = iter4_124

					table.remove(arg3_124, iter3_124)

					var3_124 = var3_124 or iter4_124 ~= 0

					break
				end
			end
		else
			var6_124 = arg3_124[1]

			table.remove(arg3_124, 1)
		end

		if var6_124 == 0 then
			var4_124 = var4_124 + 1
		end

		local var8_124 = var5_124 and cloneTplTo(arg0_124.tfShipTpl, arg1_124) or cloneTplTo(arg0_124.tfEmptyTpl, arg1_124)

		setActive(var8_124, true)

		if var5_124 then
			updateShip(var8_124, var5_124)
			setActive(var8_124:Find("event_block"), var5_124:getFlag("inEvent"))

			var0_124[var5_124] = true
		else
			var2_124 = var2_124 + 1
		end

		setActive(var8_124:Find("ship_type"), var6_124 and var6_124 ~= 0)

		if var6_124 and var6_124 ~= 0 then
			if type(var6_124) == "number" then
				local var9_124 = GetSpriteFromAtlas("shiptype", ShipType.Type2CNLabel(var6_124))

				setImageSprite(var8_124:Find("ship_type"), var9_124, true)
			elseif type(var6_124) == "string" then
				local var10_124 = GetSpriteFromAtlas("shiptype", ShipType.BundleType2CNLabel(var6_124))

				setImageSprite(var8_124:Find("ship_type"), var10_124, true)
			end
		end

		local var11_124 = _.map(arg0_124.supportFleet, function(arg0_125)
			return arg0_124.shipVOs[arg0_125]
		end)
		local var12_124 = GetOrAddComponent(var8_124, typeof(UILongPressTrigger))

		var12_124.onLongPressed:RemoveAllListeners()

		if var5_124 and arg0_124.contextData.tabIndex ~= var0_0.TabIndex.Adjustment then
			var12_124.onLongPressed:AddListener(function()
				arg0_124:onCancelSupport(true)
				arg0_124:emit(LevelMediator2.ON_SUPPORT_SHIPINFO, {
					shipId = var5_124.id,
					shipVOs = var11_124,
					chapter = arg0_124.chapter
				})
			end)
		end

		local var13_124 = GetOrAddComponent(var8_124, "EventTriggerListener")

		var13_124:RemovePointClickFunc()
		var13_124:AddPointClickFunc(function(arg0_127, arg1_127)
			if arg0_127 ~= var8_124.gameObject then
				return
			end

			if arg0_124.isDraging then
				return
			end

			arg0_124:onCancelSupport()
			arg0_124:emit(LevelMediator2.ON_SUPPORT_OPEN_DECK, {
				shipType = var6_124,
				fleet = var0_124,
				chapter = arg0_124.chapter,
				shipVO = var5_124
			})
		end)
		var13_124:RemoveBeginDragFunc()
		var13_124:RemoveDragFunc()
		var13_124:RemoveDragEndFunc()
	end

	if (var3_124 == true or var4_124 == 3) and var2_124 ~= 3 then
		return true
	else
		return false
	end
end

function var0_0.updateSpecialOperationTickets(arg0_128, arg1_128)
	arg0_128.spOPTicketItems = arg1_128 or {}
end

function var0_0.getLegalSPBuffList(arg0_129)
	local var0_129 = arg0_129.chapter:GetSpItems()

	return _.map(var0_129, function(arg0_130)
		return Chapter.GetSPBuffByItem(arg0_130:GetConfigID())
	end)
end

function var0_0.initSPOPView(arg0_131)
	arg0_131.spPanel = arg0_131.btnSp:Find("sp_panel")
	arg0_131.spItem = arg0_131.btnSp:Find("item")
	arg0_131.spDesc = arg0_131.btnSp:Find("desc")
	arg0_131.spCheckBox = arg0_131.btnSp:Find("checkbox")
	arg0_131.spCheckMark = arg0_131.spCheckBox:Find("mark")
	arg0_131.spTpl = arg0_131.spPanel:Find("sp_tpl")
	arg0_131.spContainer = arg0_131.spPanel:Find("sp_container")
	arg0_131.spItemEmptyBlock = arg0_131.btnSp:Find("empty_block")

	setText(arg0_131.spItemEmptyBlock, i18n("levelScene_select_noitem"))
	removeAllChildren(arg0_131.spContainer)

	local var0_131 = arg0_131:getLegalSPBuffList()
	local var1_131 = arg0_131.chapter:GetActiveSPItemID()

	arg0_131:setSPBtnFormByBuffCount()

	if #var0_131 == 0 then
		arg0_131:clearSPBuff()
	elseif #var0_131 == 1 then
		local var2_131 = var0_131[1]
		local var3_131 = pg.benefit_buff_template[var2_131]
		local var4_131 = ActivityBuff.GetBenefitCondition(var3_131.benefit_condition)

		assert(var4_131[1] == "item")

		local var5_131 = var4_131[2]

		arg0_131:setTicketInfo(arg0_131.btnSp, var5_131)
		setText(arg0_131.spDesc, var3_131.desc)
		onButton(arg0_131, arg0_131.btnSp:Find("item"), function()
			arg0_131:emit(BaseUI.ON_ITEM, var5_131)
		end)
		onButton(arg0_131, arg0_131.btnSp, function()
			local var0_133 = Chapter.GetSPOperationItemCacheKey(arg0_131.chapter.id)

			if arg0_131.spCheckMark.gameObject.activeSelf then
				PlayerPrefs.SetInt(var0_133, 0)
				arg0_131:clearSPBuff()
			else
				arg0_131.spItemID = var5_131

				PlayerPrefs.SetInt(var0_133, arg0_131.spItemID)
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_select_sp"))
				setActive(arg0_131.spCheckMark, true)
			end
		end)
		setActive(arg0_131.spCheckMark, var1_131 == 0)
		triggerButton(arg0_131.btnSp)
	elseif #var0_131 > 1 then
		setText(arg0_131.spDesc, i18n("levelScene_select_SP_OP"))

		for iter0_131, iter1_131 in ipairs(var0_131) do
			local var6_131 = ActivityBuff.GetBenefitCondition(iter1_131.benefit_condition)

			assert(var6_131[1] == "item")

			local var7_131 = var6_131[2]
			local var8_131 = cloneTplTo(arg0_131.spTpl, arg0_131.spContainer)

			setText(var8_131:Find("desc"), iter1_131.desc)
			arg0_131:setTicketInfo(var8_131, var7_131)
			setActive(var8_131:Find("block"), false)
			onButton(arg0_131, var8_131, function()
				arg0_131:setSPBuffSelected(iter1_131.id)
				setActive(arg0_131.spPanel, false)
			end)
		end

		onButton(arg0_131, arg0_131.btnSp, function()
			if arg0_131.spPanel.gameObject.activeSelf then
				arg0_131:clearSPBuff()

				local var0_135 = Chapter.GetSPOperationItemCacheKey(arg0_131.chapter.id)

				PlayerPrefs.SetInt(var0_135, 0)
				setActive(arg0_131.spPanel, false)
			else
				setActive(arg0_131.spPanel, true)
				setActive(arg0_131.btnSp:Find("item"), false)
				setText(arg0_131.spDesc, i18n("levelScene_unselect_SP_OP"))
			end
		end)

		if var1_131 ~= 0 then
			local var9_131

			for iter2_131, iter3_131 in ipairs(var0_131) do
				if iter3_131.id == Chapter.GetSPBuffByItem(var1_131) then
					var9_131 = true

					break
				end
			end

			if var9_131 then
				local var10_131 = Chapter.GetSPBuffByItem(var1_131)

				arg0_131:setSPBuffSelected(var10_131)
			else
				arg0_131:clearSPBuff()
			end
		else
			arg0_131:clearSPBuff()
		end
	end

	setActive(arg0_131.spPanel, false)
end

function var0_0.setSPBuffSelected(arg0_136, arg1_136)
	local var0_136 = pg.benefit_buff_template[arg1_136]
	local var1_136 = ActivityBuff.GetBenefitCondition(var0_136.benefit_condition)

	assert(var1_136[1] == "item")

	arg0_136.spItemID = var1_136[2]

	arg0_136:setTicketInfo(arg0_136.btnSp, arg0_136.spItemID)
	setText(arg0_136.spDesc, var0_136.desc)

	local var2_136 = Chapter.GetSPOperationItemCacheKey(arg0_136.chapter.id)

	PlayerPrefs.SetInt(var2_136, arg0_136.spItemID)
end

function var0_0.clearSPBuff(arg0_137)
	local var0_137 = arg0_137:getLegalSPBuffList()

	arg0_137.spItemID = nil

	arg0_137:setSPBtnFormByBuffCount()

	if #var0_137 == 0 then
		setActive(arg0_137.btnSp:Find("item"), false)
	elseif #var0_137 == 1 then
		setActive(arg0_137.btnSp:Find("item"), true)
		setActive(arg0_137.spCheckMark, false)
	elseif #var0_137 > 1 then
		setActive(arg0_137.btnSp:Find("item"), false)
		setText(arg0_137.spDesc, i18n("levelScene_select_SP_OP"))
	end
end

function var0_0.setSPBtnFormByBuffCount(arg0_138)
	local var0_138 = arg0_138:getLegalSPBuffList()

	if #var0_138 == 0 then
		setActive(arg0_138.spItemEmptyBlock, true)
		setActive(arg0_138.spDesc, false)
		setActive(arg0_138.spCheckBox, false)
		setActive(arg0_138.btnSp:Find("add"), false)
	elseif #var0_138 == 1 then
		setActive(arg0_138.spItemEmptyBlock, false)
		setActive(arg0_138.spDesc, true)
		setActive(arg0_138.spCheckBox, true)
		setActive(arg0_138.btnSp:Find("add"), false)
	elseif #var0_138 > 1 then
		setActive(arg0_138.spItemEmptyBlock, false)
		setActive(arg0_138.spDesc, true)
		setActive(arg0_138.spCheckBox, false)
		setActive(arg0_138.btnSp:Find("add"), true)
	end
end

function var0_0.setTicketInfo(arg0_139, arg1_139, arg2_139)
	local var0_139

	arg2_139 = tonumber(arg2_139)

	for iter0_139, iter1_139 in ipairs(arg0_139.spOPTicketItems) do
		if arg2_139 == iter1_139.configId then
			var0_139 = iter1_139

			break
		end
	end

	if var0_139 then
		setText(arg1_139:Find("item/count"), var0_139.count)
		GetImageSpriteFromAtlasAsync(var0_139:getConfig("icon"), "", arg1_139:Find("item/icon"))
	else
		setText(arg1_139:Find("item/count"), 0)
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg2_139
		}):getIcon(), "", arg1_139:Find("item/icon"))
	end

	setActive(arg1_139:Find("item"), true)
end

function var0_0.getSPItem(arg0_140)
	return arg0_140.spItemID
end

function var0_0.SetDuty(arg0_141, arg1_141, arg2_141)
	if not arg2_141 or not arg0_141.duties then
		return
	end

	if arg0_141.duties[arg1_141] == arg2_141 then
		return
	end

	arg0_141.duties[arg1_141] = arg2_141
	arg0_141.duties[3 - arg1_141] = nil

	arg0_141:RefreshDutyBar()
end

function var0_0.UpdateDuties(arg0_142)
	if not arg0_142.dutyTabEnabled then
		return
	end

	local var0_142 = 0
	local var1_142 = 0

	for iter0_142 = 1, 2 do
		if not arg0_142:IsListOfFleetEmpty(iter0_142) then
			var0_142 = var0_142 + 1
			var1_142 = iter0_142
		end
	end

	if var0_142 == 0 then
		table.clear(arg0_142.duties)
	elseif var0_142 == 1 then
		arg0_142.duties[var1_142] = ChapterFleet.DUTY_KILLALL
		arg0_142.duties[3 - var1_142] = nil
	elseif var0_142 == 2 then
		if arg0_142.duties[1] then
			local var2_142 = arg0_142.duties[1]
			local var3_142 = var2_142 < 3 and 3 - var2_142 or 7 - var2_142

			arg0_142.duties[2] = var3_142
		elseif arg0_142.duties[2] then
			local var4_142 = arg0_142.duties[2]
			local var5_142 = var4_142 < 3 and 3 - var4_142 or 7 - var4_142

			arg0_142.duties[1] = var5_142
		else
			arg0_142.duties[1] = ChapterFleet.DUTY_CLEANPATH
			arg0_142.duties[2] = ChapterFleet.DUTY_KILLBOSS
		end
	end

	if var1_142 ~= 0 then
		local var6_142 = "lastFleetDuty_" .. (arg0_142.chapter.id or 0)
		local var7_142 = 0
		local var8_142 = 8

		for iter1_142, iter2_142 in ipairs({
			var1_142,
			arg0_142.duties[var1_142]
		}) do
			var7_142 = var7_142 + bit.lshift(iter2_142, var8_142 * (iter1_142 - 1))
		end

		PlayerPrefs.SetInt(var6_142, var7_142)
		PlayerPrefs.Save()
	end
end

function var0_0.RefreshDutyBar(arg0_143)
	arg0_143:UpdateDuties()
	arg0_143:UpdateDutyBar()
end

function var0_0.UpdateDutyBar(arg0_144)
	local var0_144 = arg0_144.contextData.tabIndex == var0_0.TabIndex.Duty

	for iter0_144 = 1, 2 do
		local var1_144 = arg0_144._tf:Find(string.format("panel/ShipList/fleet/%d/DutySelect", iter0_144))

		setActive(var1_144, var0_144 and arg0_144.duties[iter0_144] ~= nil)
	end

	local var2_144 = arg0_144._tf:Find("panel/ShipList/sub/1/DutySelect")

	setActive(var2_144, var0_144 and not arg0_144:IsListOfFleetEmpty(3))

	if not var0_144 then
		return
	end

	for iter1_144, iter2_144 in pairs(arg0_144.duties) do
		for iter3_144 = 1, 4 do
			setActive(arg0_144.dutyItems[iter1_144][iter3_144]:Find("Checkmark"), iter3_144 == iter2_144)
		end
	end

	local var3_144 = ys.Battle.BattleState.IsAutoSubActive()

	for iter4_144 = 1, 2 do
		local var4_144 = arg0_144.dutyItems[3][iter4_144]

		setActive(var4_144:Find("Checkmark"), iter4_144 == 1 == var3_144)
	end
end

function var0_0.GetOrderedDuties(arg0_145)
	if not arg0_145.duties then
		return
	end

	arg0_145:UpdateDuties()

	local var0_145 = {}
	local var1_145 = 1

	for iter0_145 = 1, 2 do
		if arg0_145.duties[iter0_145] then
			var0_145[var1_145] = arg0_145.duties[iter0_145]
			var1_145 = var1_145 + 1
		end
	end

	return var0_145
end

function var0_0.SetAutoSub(arg0_146, arg1_146)
	arg1_146 = tobool(arg1_146)

	if arg1_146 == ys.Battle.BattleState.IsAutoSubActive() then
		return
	end

	if not AutoBotCommand.autoBotSatisfied() then
		return
	end

	pg.m02:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = not arg1_146
	})
	arg0_146:UpdateDutyBar()
end

function var0_0.GetValidFleets(arg0_147, arg1_147)
	if arg0_147.mode == var2_0.SELECT then
		local var0_147 = {}
		local var1_147 = arg1_147 and {
			arg1_147
		} or {
			FleetType.Normal,
			FleetType.Submarine
		}

		for iter0_147, iter1_147 in ipairs(var1_147) do
			local var2_147 = arg0_147.selectIds[iter1_147]

			for iter2_147, iter3_147 in ipairs(var2_147) do
				if iter3_147 > 0 then
					table.insert(var0_147, arg0_147.fleets[iter3_147])
				end
			end
		end

		return var0_147
	elseif arg0_147.mode == var2_0.EDIT then
		local var3_147 = {}
		local var4_147
		local var5_147

		if arg1_147 == FleetType.Normal then
			var4_147 = 1
			var5_147 = 2
		elseif arg1_147 == FleetType.Submarine then
			var4_147 = 3
			var5_147 = 3
		elseif not arg1_147 then
			var4_147 = 1
			var5_147 = 3
		end

		for iter4_147 = var4_147, var5_147 do
			local var6_147 = arg0_147.eliteFleetList[iter4_147]

			if #var6_147 > 0 then
				local var7_147 = {}

				for iter5_147, iter6_147 in pairs(arg0_147.eliteCommanderList[iter4_147]) do
					table.insert(var7_147, {
						pos = iter5_147,
						id = iter6_147
					})
				end

				local var8_147 = TypedFleet.New({
					ship_list = var6_147,
					commanders = var7_147,
					fleetType = FleetType.Normal
				})

				table.insert(var3_147, var8_147)
			end
		end

		return var3_147
	end
end

function var0_0.IsListOfFleetEmpty(arg0_148, arg1_148)
	if arg1_148 > 0 and arg1_148 < 3 and arg1_148 > arg0_148:getLimitNums(FleetType.Normal) then
		return true
	elseif arg1_148 == 3 and arg1_148 - 2 > arg0_148:getLimitNums(FleetType.Submarine) then
		return true
	end

	if arg0_148.mode == var2_0.SELECT then
		local var0_148

		if arg1_148 > 0 and arg1_148 < 3 then
			var0_148 = arg0_148.selectIds[FleetType.Normal][arg1_148] or 0
		elseif arg1_148 == 3 then
			var0_148 = arg0_148.selectIds[FleetType.Submarine][arg1_148 - 2] or 0
		end

		return var0_148 == 0
	elseif arg0_148.mode == var2_0.EDIT then
		return #arg0_148.eliteFleetList[arg1_148] == 0
	end
end

function var0_0.GetListFleets(arg0_149)
	local var0_149 = {}
	local var1_149 = arg0_149:getLimitNums(FleetType.Normal)
	local var2_149 = arg0_149:getLimitNums(FleetType.Submarine)

	if arg0_149.mode == var2_0.SELECT then
		local var3_149 = arg0_149.selectIds[FleetType.Normal]

		for iter0_149 = 1, var1_149 do
			local var4_149 = var3_149[iter0_149] or 0

			var0_149[iter0_149] = var4_149 > 0 and arg0_149.fleets[var4_149] or nil
		end

		local var5_149 = arg0_149.selectIds[FleetType.Submarine]

		for iter1_149 = 1, var2_149 do
			local var6_149 = var5_149[iter1_149] or 0

			var0_149[iter1_149 + var1_149] = var6_149 > 0 and arg0_149.fleets[var6_149] or nil
		end
	elseif arg0_149.mode == var2_0.EDIT then
		local var7_149 = {}

		for iter2_149 = 1, var1_149 do
			table.insert(var7_149, iter2_149)
		end

		for iter3_149 = 1, var2_149 do
			table.insert(var7_149, iter3_149 + 2)
		end

		for iter4_149 = 1, #var7_149 do
			local var8_149 = var7_149[iter4_149]
			local var9_149
			local var10_149 = arg0_149.eliteFleetList[var8_149]

			if #var10_149 > 0 then
				local var11_149 = var8_149 > 2 and FleetType.Submarine or FleetType.Normal
				local var12_149 = {}

				for iter5_149, iter6_149 in pairs(arg0_149.eliteCommanderList[var8_149]) do
					table.insert(var12_149, {
						pos = iter5_149,
						id = iter6_149
					})
				end

				var9_149 = TypedFleet.New({
					ship_list = var10_149,
					commanders = var12_149,
					fleetType = var11_149
				})
			end

			var0_149[iter4_149] = var9_149
		end
	end

	return var0_149
end

function var0_0.IsSelectMode(arg0_150)
	return arg0_150.mode == var2_0.SELECT
end

function var0_0.SwitchDisplayMode(arg0_151)
	local var0_151 = arg0_151.displayMode == var3_0.ADDITION_SUPPORT

	setActive(arg0_151._tf:Find("panel/ShipList/Line"), not var0_151)
	setActive(arg0_151._tf:Find("panel/ShipList/support"), var0_151)

	local var1_151 = arg0_151._tf:Find("panel/ShipList"):GetComponent(typeof(VerticalLayoutGroup))
	local var2_151 = var1_151.padding

	var2_151.top = var0_151 and 9 or 20
	var2_151.bottom = var0_151 and 14 or 25
	var1_151.padding = var2_151
	var1_151.spacing = var0_151 and 13 or 20
end

function var0_0.sortTeamLimitation(arg0_152)
	arg0_152 = Clone(arg0_152)

	table.sort(arg0_152, function(arg0_153, arg1_153)
		local var0_153 = type(arg0_153)
		local var1_153 = type(arg1_153)

		if var0_153 == var1_153 then
			return var1_153 < var0_153
		elseif arg1_153 == 0 or var1_153 == "string" and arg0_153 ~= 0 then
			return true
		else
			return false
		end
	end)

	return arg0_152
end

return var0_0
