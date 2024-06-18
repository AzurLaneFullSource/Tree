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

function var0_0.OnInit(arg0_2)
	arg0_2:InitUI()
	arg0_2:bind(LevelUIConst.CONTINUOUS_OPERATION, function(arg0_3, arg1_3)
		local var0_3 = arg1_3.battleTimes

		getProxy(ChapterProxy):InitContinuousTime(SYSTEM_SCENARIO, var0_3)
		LoadContextCommand.RemoveLayerByMediator(LevelContinuousOperationWindowMediator)

		local var1_3 = "chapter_autofight_flag_" .. arg0_2.chapter.id

		PlayerPrefs.SetInt(var1_3, 1)
		triggerButton(arg0_2.btnGo)
	end)
	arg0_2:bind(LevelMediator2.ON_SPITEM_CHANGED, function(arg0_4, arg1_4)
		setActive(arg0_2.spCheckMark, not arg1_4)
		triggerButton(arg0_2.btnSp)
	end)
end

function var0_0.OnDestroy(arg0_5)
	if arg0_5:isShowing() then
		arg0_5:Hide()
	end
end

function var0_0.Show(arg0_6)
	local var0_6 = arg0_6.chapter:getConfig("special_operation_list")
	local var1_6 = arg0_6.chapter:GetDailyBonusQuota()

	arg0_6:initSPOPView()

	if type(var0_6) == "table" and #var0_6 > 0 and not var1_6 then
		setActive(arg0_6.btnSp, true)
	else
		setActive(arg0_6.btnSp, false)
	end

	setActive(arg0_6._tf, true)

	local var2_6 = {
		arg0_6.formationToggle,
		arg0_6.commanderToggle,
		arg0_6.dutyToggle,
		arg0_6.adjustmentToggle
	}
	local var3_6 = var2_6[arg0_6.contextData.tabIndex or var0_0.TabIndex.Formation]

	if not isActive(var3_6) then
		var3_6 = var2_6[var0_0.TabIndex.Formation]
	end

	for iter0_6, iter1_6 in ipairs(var2_6) do
		if isActive(iter1_6) then
			triggerToggle(iter1_6, iter1_6 == var3_6)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
	arg0_6:TryPlaySupportGuide()
	arg0_6:CheckGuideElement()
end

function var0_0.CheckGuideElement(arg0_7)
	if not IsUnityEditor then
		return
	end

	local var0_7 = {
		"panel/Fixed/start_button",
		"panel/ShipList/support/1/support"
	}

	_.each(var0_7, function(arg0_8)
		local var0_8 = arg0_7._tf:Find(arg0_8)

		assert(var0_8, "Missing Guide Need GameObject Path: " .. arg0_8)
	end)
end

function var0_0.TryPlaySupportGuide(arg0_9)
	if arg0_9:getLimitNums(FleetType.Support) == 0 then
		return
	end

	if not pg.NewStoryMgr.GetInstance():IsPlayed("NG0041") then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0041")
	end
end

function var0_0.Hide(arg0_10)
	setActive(arg0_10.dropDown, false)
	setActive(arg0_10.btnSp, false)
	setActive(arg0_10._tf, false)

	arg0_10.spItemID = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
end

function var0_0.setOpenCommanderTag(arg0_11, arg1_11)
	arg0_11.openedCommanerSystem = arg1_11
end

function var0_0.SetDutyTabEnabled(arg0_12, arg1_12)
	arg0_12.dutyTabEnabled = arg1_12
end

function var0_0.onConfirm(arg0_13)
	local var0_13 = arg0_13.chapter
	local var1_13 = arg0_13:getSelectIds()
	local var2_13 = var0_13:getNpcShipByType(2)

	if #var2_13 > 0 then
		local var3_13 = {
			[TeamType.Vanguard] = #arg0_13:getFleetById(var1_13[1]):getTeamByName(TeamType.Vanguard),
			[TeamType.Main] = #arg0_13:getFleetById(var1_13[1]):getTeamByName(TeamType.Main)
		}
		local var4_13 = {
			[TeamType.Vanguard] = 0,
			[TeamType.Main] = 0
		}
		local var5_13

		for iter0_13, iter1_13 in ipairs(var2_13) do
			var5_13 = iter1_13

			local var6_13 = iter1_13:getTeamType()

			var4_13[var6_13] = var4_13[var6_13] + 1

			if var3_13[var6_13] + var4_13[var6_13] > 3 then
				break
			end
		end

		for iter2_13, iter3_13 in pairs(var3_13) do
			if iter3_13 + var4_13[iter2_13] > 3 then
				arg0_13:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
					modal = true,
					hideNo = true,
					content = i18n("chapter_tip_with_npc", var5_13.name)
				})

				return
			end
		end
	end

	local var7_13 = "chapter_autofight_flag_" .. var0_13.id
	local var8_13
	local var9_13

	seriesAsync({
		function(arg0_14)
			local var0_14 = PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1

			if not (PlayerPrefs.GetInt(var7_13, 1) == 1) or var0_14 or not arg0_13:getSPItem() then
				return arg0_14()
			end

			PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
			PlayerPrefs.Save()

			local function var1_14()
				arg0_13:clearSPBuff()
			end

			arg0_13:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
				hideNo = true,
				content = i18n("autofight_special_operation_tip"),
				onYes = var1_14,
				onNo = var1_14
			})
		end,
		function(arg0_16)
			var9_13 = var0_13:GetActiveSPItemID()
			var8_13 = var0_13:isLoop() and arg0_13:GetOrderedDuties() or nil

			arg0_13:onCancel()
			arg0_16()
		end,
		function(arg0_17)
			getProxy(ChapterProxy):SetLastFleetIndex(var1_13)

			local var0_17 = PlayerPrefs.GetInt(var7_13, 1) == 1
			local var1_17 = LevelMediator2.ON_TRACKING
			local var2_17 = packEx(var0_13.id, var0_13.loopFlag, var9_13, var8_13, var0_17)

			if pg.m02:retrieveMediator(LevelMediator2.__cname) then
				pg.m02:sendNotification(var1_17, var2_17)

				return
			end

			local var3_17 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var3_17 then
				var3_17:extendData({
					ToTrackingData = {
						var1_17,
						var2_17
					}
				})
			end
		end
	})
end

function var0_0.onCancel(arg0_18)
	arg0_18:clear()
	arg0_18:emit(LevelUIConst.HIDE_FLEET_SELECT)
end

function var0_0.InitUI(arg0_19)
	arg0_19.tfShipTpl = arg0_19:findTF("panel/Fixed/shiptpl")
	arg0_19.tfEmptyTpl = arg0_19:findTF("panel/Fixed/emptytpl")
	arg0_19.tfFleets = {
		[FleetType.Normal] = {
			arg0_19:findTF("panel/ShipList/fleet/1"),
			arg0_19:findTF("panel/ShipList/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0_19:findTF("panel/ShipList/sub/1")
		},
		[FleetType.Support] = {
			arg0_19:findTF("panel/ShipList/support/1")
		}
	}

	local var0_19 = arg0_19:findTF("panel/Fixed/RightTabs")
	local var1_19 = PLATFORM_CODE == PLATFORM_US and arg0_19:findTF("panel/Fixed/RightTabs/hTplBtn") or arg0_19:findTF("panel/Fixed/RightTabs/vTplBtn")
	local var2_19 = {
		"formation_btn",
		"commander_btn",
		"duty_btn",
		"adjustment_btn"
	}

	for iter0_19 = 1, #var2_19 do
		local var3_19 = Instantiate(var1_19)

		var3_19.name = var2_19[iter0_19]

		SetParent(tf(var3_19), var0_19)
		setActive(var3_19, false)
	end

	arg0_19.tfLimit = arg0_19:findTF("panel/Fixed/limit_list/limit")
	arg0_19.tfLimitTips = arg0_19:findTF("panel/Fixed/limit_list/limit_tip")
	arg0_19.tfLimitElite = arg0_19:findTF("panel/Fixed/limit_list/limit_elite")
	arg0_19.tfLimitSubTip = arg0_19:findTF("panel/Fixed/limit_list/limit_sub_tip")
	arg0_19.tfLimitContainer = arg0_19:findTF("panel/Fixed/limit_list/limit_elite/limit_list")
	arg0_19.rtCostLimit = arg0_19._tf:Find("panel/Fixed/limit_list/cost_limit")
	arg0_19.btnBack = arg0_19:findTF("panel/Fixed/btnBack")
	arg0_19.btnGo = arg0_19:findTF("panel/Fixed/start_button")
	arg0_19.btnMultiple = arg0_19:findTF("panel/Fixed/multiple")
	arg0_19.formationToggle = arg0_19:findTF("panel/Fixed/RightTabs/formation_btn")
	arg0_19.commanderToggle = arg0_19:findTF("panel/Fixed/RightTabs/commander_btn")
	arg0_19.dutyToggle = arg0_19:findTF("panel/Fixed/RightTabs/duty_btn")
	arg0_19.adjustmentToggle = arg0_19:findTF("panel/Fixed/RightTabs/adjustment_btn")
	arg0_19.toggleMask = arg0_19:findTF("mask")
	arg0_19.toggleList = arg0_19:findTF("mask/list")
	arg0_19.toggles = {}

	setText(findTF(arg0_19.tfLimit, "text"), i18n("level_fleet_ship_desc"))
	setText(findTF(arg0_19.tfLimit, "text_sub"), i18n("level_fleet_sub_desc"))

	for iter1_19 = 0, arg0_19.toggleList.childCount - 1 do
		table.insert(arg0_19.toggles, arg0_19.toggleList:Find("item" .. iter1_19 + 1))
	end

	arg0_19.btnSp = arg0_19:findTF("panel/Fixed/sp")
	arg0_19.spMask = arg0_19:findTF("mask_sp")
	arg0_19.dutyItems = {}

	for iter2_19 = 1, 2 do
		local var4_19 = arg0_19._tf:Find(string.format("panel/ShipList/fleet/%d/DutySelect", iter2_19))

		arg0_19.dutyItems[iter2_19] = {}

		for iter3_19 = 1, 4 do
			local var5_19 = var4_19:Find("Item" .. iter3_19)

			arg0_19.dutyItems[iter2_19][iter3_19] = var5_19

			setText(var5_19:Find("Text"), i18n("autofight_function" .. iter3_19))
		end
	end

	local var6_19 = arg0_19._tf:Find("panel/ShipList/sub/1/DutySelect")

	arg0_19.dutyItems[3] = {}

	for iter4_19 = 1, 2 do
		local var7_19 = var6_19:Find("Item" .. iter4_19)

		arg0_19.dutyItems[3][iter4_19] = var7_19

		setText(var7_19:Find("Text"), i18n("autofight_function" .. 6 - iter4_19))
	end

	setActive(arg0_19.tfShipTpl, false)
	setActive(arg0_19.tfEmptyTpl, false)
	setActive(arg0_19.toggleMask, false)
	setActive(arg0_19.btnSp, false)
	setActive(arg0_19.spMask, false)
	setText(arg0_19:findTF("panel/Fixed/RightTabs/formation_btn/text"), i18n("autofight_formation"))
	setText(arg0_19:findTF("panel/Fixed/RightTabs/commander_btn/text"), i18n("autofight_cat"))
	setText(arg0_19:findTF("panel/Fixed/RightTabs/duty_btn/text"), i18n("autofight_function"))
	setText(arg0_19.adjustmentToggle:Find("text"), i18n("word_adjustFleet"))

	arg0_19.dropDown = arg0_19._tf:Find("panel/FixedTop/Dropdown")

	setActive(arg0_19.dropDown, false)

	arg0_19.dropDownSide = arg0_19._tf:Find("panel/Fixed/title/DropSide")

	onButton(arg0_19, arg0_19.dropDownSide:Find("Click"), function()
		local var0_20 = isActive(arg0_19.dropDown)

		setActive(arg0_19.dropDown, not var0_20)
	end, SFX_UI_CLICK)
	onButton(arg0_19, arg0_19.dropDown, function()
		local var0_21 = isActive(arg0_19.dropDown)

		setActive(arg0_19.dropDown, not var0_21)
	end, SFX_UI_CLICK)
	onButton(arg0_19, arg0_19.dropDownSide:Find("Layout/Item3"), function()
		arg0_19:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	assert(OPEN_AIR_DOMINANCE, "Not Prepare for BANNED OPEN_AIR_DOMINANCE")

	arg0_19.btnASHelp = arg0_19.dropDownSide:Find("help")

	setText(arg0_19.dropDownSide:Find("Layout/Item1/Text"), i18n("word_investigate"))
	setText(arg0_19.dropDownSide:Find("Layout/Item2/Text"), i18n("word_attr_ac"))
	setText(arg0_19.dropDownSide:Find("Layout/Item3/Text"), i18n("fleet_antisub_range"))
	setText(arg0_19.dropDown:Find("Investigation/Text"), i18n("level_scene_title_word_1"))
	setText(arg0_19.dropDown:Find("Airsupport/Text"), i18n("level_scene_title_word_3"))

	arg0_19.supportFleetHelp = arg0_19._tf:Find("panel/Fixed/title/Image/Help")

	onButton(arg0_19, arg0_19.supportFleetHelp, function()
		arg0_19:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_supportfleet.tip
		})
	end, SFX_PANEL)

	for iter5_19 = 1, 2 do
		for iter6_19 = 1, 4 do
			local var8_19 = arg0_19.dutyItems[iter5_19][iter6_19]

			onButton(arg0_19, var8_19, function()
				arg0_19:SetDuty(iter5_19, iter6_19)
			end)
		end
	end

	for iter7_19 = 1, 2 do
		local var9_19 = arg0_19.dutyItems[3][iter7_19]

		onButton(arg0_19, var9_19, function()
			arg0_19:SetAutoSub(iter7_19 == 1)
		end)
	end
end

function var0_0.onCancelSupport(arg0_26, arg1_26)
	if arg1_26 then
		arg0_26:emit(LevelMediator2.ON_UPDATE_CUSTOM_FLEET, arg0_26.chapter)
	end
end

function var0_0.set(arg0_27, arg1_27, arg2_27, arg3_27)
	arg0_27.chapter = arg1_27
	arg0_27.mode = var2_0.SELECT
	arg0_27.selects = arg3_27
	arg0_27.chapterASValue = arg0_27.chapter:getConfig("air_dominance")
	arg0_27.suggestionValue = arg0_27.chapter:getConfig("best_air_dominance")

	arg0_27:SetDutyTabEnabled(arg1_27:isLoop())

	arg0_27.supportFleet = arg0_27.chapter:getSupportFleet()

	local var0_27 = arg0_27:getLimitNums(FleetType.Support) > 0

	setActive(arg0_27.supportFleetHelp, var0_27)

	arg0_27.displayMode = var0_27 and var3_0.ADDITION_SUPPORT or var3_0.NORMAL

	arg0_27:SwitchDisplayMode()

	arg0_27.fleets = _(_.values(arg2_27)):chain():filter(function(arg0_28)
		return arg0_28:isRegularFleet()
	end):sort(function(arg0_29, arg1_29)
		return arg0_29.id < arg1_29.id
	end):value()
	arg0_27.selectIds = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0_27, iter1_27 in ipairs(arg3_27 or {}) do
		local var1_27 = arg0_27:getFleetById(iter1_27)

		if var1_27 then
			local var2_27 = var1_27:getFleetType()
			local var3_27 = arg0_27.selectIds[var2_27]

			if #var3_27 < arg0_27:getLimitNums(var2_27) then
				table.insert(var3_27, iter1_27)
			end
		end
	end

	arg0_27.duties = {}

	local var4_27 = PlayerPrefs.GetInt("lastFleetDuty_" .. (arg0_27.chapter.id or 0), 0)

	if var4_27 > 0 then
		local var5_27 = bit.band(var4_27, 255)
		local var6_27 = bit.rshift(var4_27, 8)
		local var7_27 = bit.band(var6_27, 255)

		if var5_27 > 0 and var7_27 > 0 then
			arg0_27.duties[var5_27] = var7_27
		end
	end

	setActive(arg0_27.tfLimitElite, false)
	setActive(arg0_27.tfLimitSubTip, false)
	setActive(arg0_27.tfLimitTips, false)
	setActive(arg0_27.tfLimit, true)

	local var8_27 = arg0_27.chapter:isLoop() and arg0_27.chapter:getConfig("use_oil_limit") or {}

	setActive(arg0_27.rtCostLimit, #var8_27 > 0)
	setText(arg0_27.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip"))

	if #var8_27 > 0 then
		setActive(arg0_27.rtCostLimit:Find("cost_noraml"), var8_27[1] > 0)
		setText(arg0_27.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_enemy"), var8_27[1]))
		setActive(arg0_27.rtCostLimit:Find("cost_boss"), var8_27[2] > 0)
		setText(arg0_27.rtCostLimit:Find("cost_boss/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_flagship"), var8_27[2]))
		setActive(arg0_27.rtCostLimit:Find("cost_sub"), var8_27[3] > 0)
		setText(arg0_27.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var8_27[3]))
	end

	onButton(arg0_27, arg0_27.btnGo, function()
		local function var0_30()
			arg0_27:onConfirm()
		end

		local var1_30 = arg0_27:getSPItem()

		if var1_30 and var1_30 ~= 0 then
			if PlayerPrefs.GetInt("SPOPItemReminder") ~= 1 then
				local var2_30 = Item.getConfigData(var1_30).name
				local var3_30 = pg.benefit_buff_template[Chapter.GetSPBuffByItem(var1_30)].desc
				local var4_30 = i18n("levelScene_select_SP_OP_reminder", var2_30, var3_30)

				local function var5_30()
					PlayerPrefs.SetInt("SPOPItemReminder", 1)
					PlayerPrefs.Save()
					var0_30()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = {
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var1_30
					},
					intro = var4_30,
					onYes = var5_30,
					weight = LayerWeightConst.TOP_LAYER
				})
			else
				var0_30()
			end
		else
			var0_30()
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	setActive(arg0_27.btnMultiple, AutoBotCommand.autoBotSatisfied() and arg0_27.chapter:isLoop())
	onButton(arg0_27, arg0_27.btnMultiple, function()
		local var0_33 = arg0_27:getSelectIds()
		local var1_33 = arg0_27:getSPItem()
		local var2_33 = arg0_27:GetOrderedDuties()

		arg0_27:emit(LevelUIConst.OPEN_NORMAL_CONTINUOUS_WINDOW, arg0_27.chapter, var0_33, var1_33, var2_33)
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.btnASHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0_27, arg0_27.btnBack, function()
		arg0_27:onCancel()
		arg0_27:onCancelSupport(true)
	end, SFX_CANCEL)
	onButton(arg0_27, arg0_27._tf:Find("bg"), function()
		arg0_27:onCancel()
		arg0_27:onCancelSupport(true)
	end, SFX_CANCEL)
	onButton(arg0_27, arg0_27.toggleMask, function()
		arg0_27:hideToggleMask()
	end, SFX_CANCEL)
	onToggle(arg0_27, arg0_27.formationToggle, function(arg0_38)
		if arg0_38 then
			arg0_27.contextData.tabIndex = var0_0.TabIndex.Formation

			arg0_27:updateFleets()
		end
	end, SFX_PANEL)
	onToggle(arg0_27, arg0_27.commanderToggle, function(arg0_39)
		if arg0_39 then
			arg0_27.contextData.tabIndex = var0_0.TabIndex.Commander

			arg0_27:updateFleets()
		end
	end, SFX_PANEL)
	onToggle(arg0_27, arg0_27.dutyToggle, function(arg0_40)
		if arg0_40 then
			arg0_27.contextData.tabIndex = var0_0.TabIndex.Duty

			arg0_27:updateFleets()
		end
	end, SFX_PANEL)
	setActive(arg0_27.formationToggle, true)
	setActive(arg0_27.commanderToggle, arg0_27.openedCommanerSystem)
	setActive(arg0_27.dutyToggle, arg0_27.dutyTabEnabled)
	setActive(arg0_27.adjustmentToggle, false)
	arg0_27:clearFleets()
	arg0_27:updateFleets()
	arg0_27:updateLimit()
	arg0_27:updateASValue()
	arg0_27:UpdateSonarRange()
	arg0_27:UpdateInvestigation()
end

function var0_0.getFleetById(arg0_41, arg1_41)
	return _.detect(arg0_41.fleets, function(arg0_42)
		return arg0_42.id == arg1_41
	end)
end

function var0_0.getLimitNums(arg0_43, arg1_43)
	local var0_43 = 0

	if arg1_43 == FleetType.Normal then
		var0_43 = arg0_43.chapter:getConfig("group_num")
	elseif arg1_43 == FleetType.Submarine then
		var0_43 = arg0_43.chapter:getConfig("submarine_num")
	elseif arg1_43 == FleetType.Support then
		var0_43 = arg0_43.chapter:getConfig("support_group_num")
	end

	return var0_43
end

function var0_0.getSelectIds(arg0_44)
	local var0_44 = {}

	for iter0_44, iter1_44 in ipairs({
		FleetType.Normal,
		FleetType.Submarine
	}) do
		local var1_44 = arg0_44.selectIds[iter1_44]

		for iter2_44, iter3_44 in ipairs(var1_44) do
			if iter3_44 > 0 then
				table.insert(var0_44, iter3_44)
			end
		end
	end

	return var0_44
end

function var0_0.updateFleets(arg0_45)
	for iter0_45, iter1_45 in pairs(arg0_45.tfFleets) do
		for iter2_45 = 1, #iter1_45 do
			if iter0_45 ~= FleetType.Support then
				arg0_45:updateFleet(iter0_45, iter2_45)
			else
				arg0_45:UpdateEliteFleet(iter0_45, iter2_45)
			end
		end
	end

	arg0_45:RefreshDutyBar()
end

function var0_0.updateLimit(arg0_46)
	local var0_46 = #_.filter(arg0_46.selectIds[FleetType.Normal], function(arg0_47)
		return arg0_47 > 0
	end)
	local var1_46 = #_.filter(arg0_46.selectIds[FleetType.Submarine], function(arg0_48)
		return arg0_48 > 0
	end)
	local var2_46 = arg0_46:getLimitNums(FleetType.Normal)

	setText(arg0_46.tfLimit:Find("number"), string.format("%d/%d", var0_46, var2_46))

	local var3_46 = arg0_46:getLimitNums(FleetType.Submarine)

	setText(arg0_46.tfLimit:Find("number_sub"), string.format("%d/%d", var1_46, var3_46))
end

function var0_0.selectFleet(arg0_49, arg1_49, arg2_49, arg3_49)
	local var0_49 = arg0_49.selectIds[arg1_49]

	if arg3_49 > 0 and table.contains(var0_49, arg3_49) then
		return
	end

	if arg1_49 == FleetType.Normal and arg0_49:getLimitNums(arg1_49) > 0 and arg3_49 == 0 and #_.filter(var0_49, function(arg0_50)
		return arg0_50 > 0
	end) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_lease_one_ship"))

		return
	end

	local var1_49 = arg0_49:getFleetById(arg3_49)

	if var1_49 then
		if not var1_49:isUnlock() then
			return
		end

		if var1_49:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_not_enough"))

			return
		end
	end

	local var2_49 = {
		not arg0_49:IsListOfFleetEmpty(1) or nil,
		not arg0_49:IsListOfFleetEmpty(2) or nil
	}
	local var3_49 = var0_49[arg2_49]

	var0_49[arg2_49] = arg3_49

	arg0_49:updateFleet(arg1_49, arg2_49)
	arg0_49:updateLimit()
	arg0_49:updateASValue()
	arg0_49:UpdateSonarRange()
	arg0_49:RefreshDutyBar()

	local var4_49 = {
		not arg0_49:IsListOfFleetEmpty(1) or nil,
		not arg0_49:IsListOfFleetEmpty(2) or nil
	}

	if arg0_49.dutyTabEnabled and table.getCount(var2_49) == 2 and table.getCount(var4_49) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_change_tip"))
	end

	arg0_49:UpdateInvestigation()
end

function var0_0.updateFleet(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg0_51.contextData.tabIndex == var0_0.TabIndex.Formation
	local var1_51 = arg0_51.contextData.tabIndex == var0_0.TabIndex.Commander
	local var2_51 = arg0_51.contextData.tabIndex == var0_0.TabIndex.Duty
	local var3_51 = arg0_51.contextData.tabIndex == var0_0.TabIndex.Adjustment
	local var4_51 = arg0_51.selectIds[arg1_51][arg2_51]
	local var5_51 = arg0_51:getFleetById(var4_51)
	local var6_51 = arg2_51 <= arg0_51:getLimitNums(arg1_51)
	local var7_51 = arg0_51.tfFleets[arg1_51][arg2_51]
	local var8_51 = findTF(var7_51, "bg/name")
	local var9_51 = arg0_51:findTF("btn_select", var7_51)
	local var10_51 = arg0_51:findTF("btn_recom", var7_51)
	local var11_51 = arg0_51:findTF("btn_clear", var7_51)
	local var12_51 = arg0_51:findTF("blank", var7_51)
	local var13_51 = arg0_51:findTF("selected", var7_51)
	local var14_51 = arg0_51:findTF("commander", var7_51)
	local var15_51 = var7_51:Find("adjustment_flag")

	setActive(var10_51, false)
	setActive(var13_51, false)
	setText(var8_51, "")

	local var16_51 = arg0_51:findTF(TeamType.Main, var7_51)
	local var17_51 = arg0_51:findTF(TeamType.Vanguard, var7_51)
	local var18_51 = arg0_51:findTF(TeamType.Submarine, var7_51)

	if not var6_51 then
		setActive(var11_51, false)
		setActive(var9_51, false)
		setActive(var14_51, false)
		setActive(var15_51, false)
		setActive(var12_51, true)

		if arg1_51 == FleetType.Submarine then
			setActive(var18_51, false)
		else
			setActive(var16_51, false)
			setActive(var17_51, false)
		end

		return
	end

	setActive(var11_51, var0_51)
	setActive(var9_51, var0_51)
	setActive(var14_51, var1_51 and var5_51)
	setActive(var15_51, var3_51)
	setActive(var12_51, var2_51 or var3_51 or var1_51 and not var5_51)
	setText(var8_51, var5_51 and var5_51:GetName() or "")

	if arg1_51 == FleetType.Submarine then
		setActive(var18_51, var5_51)
	else
		setActive(var16_51, var5_51)
		setActive(var17_51, var5_51)
	end

	if var5_51 then
		if arg1_51 == FleetType.Submarine then
			arg0_51:updateShips(var18_51, var5_51.subShips)
		else
			arg0_51:updateShips(var16_51, var5_51.mainShips)
			arg0_51:updateShips(var17_51, var5_51.vanguardShips)
		end

		arg0_51:updateCommanders(var14_51, var5_51)
	end

	onButton(arg0_51, var9_51, function()
		arg0_51.toggleList.position = (var9_51.position + var11_51.position) / 2
		arg0_51.toggleList.anchoredPosition = arg0_51.toggleList.anchoredPosition + Vector2(-arg0_51.toggleList.rect.width / 2, -var9_51.rect.height / 2)

		arg0_51:showToggleMask(arg1_51, function(arg0_53)
			arg0_51:hideToggleMask()
			arg0_51:selectFleet(arg1_51, arg2_51, arg0_53)
		end)
	end, SFX_UI_CLICK)
	onButton(arg0_51, var11_51, function()
		arg0_51:selectFleet(arg1_51, arg2_51, 0)
	end, SFX_UI_CLICK)
end

function var0_0.updateCommanders(arg0_55, arg1_55, arg2_55)
	for iter0_55 = 1, 2 do
		local var0_55 = arg2_55:getCommanderByPos(iter0_55)
		local var1_55 = arg1_55:Find("pos" .. iter0_55)
		local var2_55 = var1_55:Find("add")
		local var3_55 = var1_55:Find("info")

		setActive(var2_55, not var0_55)
		setActive(var3_55, var0_55)

		if var0_55 then
			local var4_55 = Commander.rarity2Frame(var0_55:getRarity())

			setImageSprite(var3_55:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var4_55))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var0_55:getPainting(), "", var3_55:Find("mask/icon"))
		end

		onButton(arg0_55, var2_55, function()
			arg0_55:emit(LevelUIConst.OPEN_COMMANDER_PANEL, arg2_55, arg0_55.chapter)
		end, SFX_PANEL)
		onButton(arg0_55, var3_55, function()
			arg0_55:emit(LevelUIConst.OPEN_COMMANDER_PANEL, arg2_55, arg0_55.chapter)
		end, SFX_PANEL)
	end
end

function var0_0.updateShips(arg0_58, arg1_58, arg2_58)
	local var0_58 = UIItemList.New(arg1_58, arg0_58.tfShipTpl)

	var0_58:make(function(arg0_59, arg1_59, arg2_59)
		if arg0_59 == UIItemList.EventUpdate then
			local var0_59 = getProxy(BayProxy):getShipById(arg2_58[arg1_59 + 1])

			updateShip(arg2_59, var0_59)
			setActive(findTF(arg2_59, "ship_type"), false)

			local var1_59 = arg2_59:Find("icon_bg/energy")
			local var2_59 = var0_59:getEnergeConfig()

			if var2_59 and var2_59.id <= 2 then
				setActive(var1_59, true)
				GetImageSpriteFromAtlasAsync("energy", var2_59.icon, var1_59)
			else
				setActive(var1_59, false)
			end
		end
	end)
	var0_58:align(#arg2_58)

	for iter0_58, iter1_58 in ipairs(arg2_58) do
		local var1_58 = arg1_58:GetChild(iter0_58 - 1)
		local var2_58 = GetOrAddComponent(var1_58, "UILongPressTrigger").onLongPressed

		pg.DelegateInfo.Add(arg0_58, var2_58)
		var2_58:RemoveAllListeners()
		var2_58:AddListener(function()
			arg0_58:emit(LevelMediator2.ON_SHIP_DETAIL, {
				id = iter1_58,
				chapter = arg0_58.chapter
			})
		end)
	end
end

function var0_0.showToggleMask(arg0_61, arg1_61, arg2_61)
	setActive(arg0_61.toggleMask, true)

	local var0_61 = _.filter(arg0_61.fleets, function(arg0_62)
		return arg0_62:getFleetType() == arg1_61
	end)

	for iter0_61, iter1_61 in ipairs(arg0_61.toggles) do
		local var1_61 = var0_61[iter0_61]

		setActive(iter1_61, var1_61)

		if var1_61 then
			local var2_61 = iter1_61:GetComponent(typeof(Toggle))
			local var3_61 = iter1_61:Find("lock")
			local var4_61, var5_61 = var1_61:isUnlock()

			setToggleEnabled(iter1_61, var4_61)
			setActive(var3_61, not var4_61)

			local var6_61 = table.contains(arg0_61.selectIds[arg1_61], var1_61.id)

			setActive(iter1_61:Find("on"), var6_61)
			setActive(iter1_61:Find("off"), not var6_61)

			if var4_61 then
				var2_61.isOn = false

				onToggle(arg0_61, iter1_61, function(arg0_63)
					if arg0_63 then
						setActive(arg0_61.toggleMask, false)
						arg2_61(var1_61.id)
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0_61, var3_61, function()
					pg.TipsMgr.GetInstance():ShowTips(var5_61)
				end, SFX_UI_CLICK)
			end
		end
	end
end

function var0_0.hideToggleMask(arg0_65)
	setActive(arg0_65.toggleMask, false)
end

function var0_0.clearFleets(arg0_66)
	for iter0_66, iter1_66 in pairs(arg0_66.tfFleets) do
		_.each(iter1_66, function(arg0_67)
			arg0_66:clearFleet(arg0_67)
		end)
	end
end

function var0_0.UpdateInvestigation(arg0_68)
	if not arg0_68.chapter:existAmbush() then
		arg0_68:UpdateLoopInvestigation()

		return
	end

	local var0_68 = 0

	for iter0_68 = 1, 2 do
		local var1_68 = arg0_68.selectIds[FleetType.Normal][iter0_68] or 0
		local var2_68 = arg0_68:getFleetById(var1_68)
		local var3_68 = var2_68 and math.floor(var2_68:getInvestSums(true)) or 0

		var0_68 = math.max(var0_68, var3_68)
	end

	local var4_68 = arg0_68.chapter:getConfig("avoid_require")

	arg0_68:UpdateInvestigationComparision(var0_68, var4_68)
end

function var0_0.UpdateEliteInvestigation(arg0_69)
	if not arg0_69.chapter:existAmbush() then
		arg0_69:UpdateLoopInvestigation()

		return
	end

	local var0_69 = 0

	for iter0_69 = 1, 2 do
		local var1_69 = arg0_69.eliteFleetList[iter0_69]
		local var2_69 = {}

		for iter1_69, iter2_69 in pairs(arg0_69.eliteCommanderList[iter0_69]) do
			table.insert(var2_69, {
				pos = iter1_69,
				id = iter2_69
			})
		end

		local var3_69 = TypedFleet.New({
			ship_list = var1_69,
			commanders = var2_69,
			fleetType = FleetType.Normal
		})
		local var4_69 = var3_69 and math.floor(var3_69:getInvestSums()) or 0

		var0_69 = math.max(var0_69, var4_69)
	end

	local var5_69 = arg0_69.chapter:getConfig("avoid_require")

	arg0_69:UpdateInvestigationComparision(var0_69, var5_69)
end

function var0_0.UpdateLoopInvestigation(arg0_70)
	local var0_70 = arg0_70.dropDown:Find("Investigation")

	setText(var0_70:Find("Value1"), "-")
	setText(var0_70:Find("Value2"), "-")
	triggerToggle(arg0_70.dropDownSide:Find("Layout/Item1/Dot"), true)
end

function var0_0.UpdateInvestigationComparision(arg0_71, arg1_71, arg2_71)
	arg1_71 = math.floor(arg1_71)

	local var0_71 = arg0_71.dropDown:Find("Investigation")
	local var1_71 = arg2_71 <= arg1_71

	setText(var0_71:Find("Value1"), setColorStr(arg1_71, var1_71 and "#51FF55" or COLOR_WHITE))
	setText(var0_71:Find("Value2"), arg2_71)
	triggerToggle(arg0_71.dropDownSide:Find("Layout/Item1/Dot"), var1_71)
end

function var0_0.updateASValue(arg0_72)
	if arg0_72.chapterASValue <= 0 then
		arg0_72:UpdateBannedAS()

		return
	end

	local var0_72 = 0

	for iter0_72 = 1, 2 do
		local var1_72 = arg0_72.selectIds[FleetType.Normal][iter0_72] or 0
		local var2_72 = arg0_72:getFleetById(var1_72)

		var0_72 = var0_72 + (var2_72 and var2_72:getFleetAirDominanceValue() or 0)
	end

	for iter1_72 = 1, 1 do
		local var3_72 = arg0_72.selectIds[FleetType.Submarine][iter1_72] or 0
		local var4_72 = arg0_72:getFleetById(var3_72)

		var0_72 = var0_72 + (var4_72 and var4_72:getFleetAirDominanceValue() or 0)
	end

	arg0_72:UpdateASComparision(var0_72, arg0_72.suggestionValue)
end

function var0_0.updateEliteASValue(arg0_73)
	if arg0_73.chapterASValue <= 0 then
		arg0_73:UpdateBannedAS()

		return
	end

	local var0_73 = getProxy(BayProxy)
	local var1_73 = 0

	for iter0_73, iter1_73 in ipairs(arg0_73.eliteFleetList) do
		local var2_73 = {}

		for iter2_73, iter3_73 in pairs(arg0_73.eliteCommanderList[iter0_73]) do
			var2_73[iter2_73] = getProxy(CommanderProxy):RawGetCommanderById(iter3_73)
		end

		for iter4_73, iter5_73 in ipairs(iter1_73) do
			var1_73 = var1_73 + calcAirDominanceValue(var0_73:RawGetShipById(iter5_73), var2_73)
		end
	end

	arg0_73:UpdateASComparision(var1_73, arg0_73.suggestionValue)
end

function var0_0.UpdateBannedAS(arg0_74)
	local var0_74 = arg0_74.dropDown:Find("Airsupport")

	setText(var0_74:Find("Value1"), "-")
	setText(var0_74:Find("Value2"), "-")
	triggerToggle(arg0_74.dropDownSide:Find("Layout/Item2/Dot"), true)
end

function var0_0.UpdateASComparision(arg0_75, arg1_75, arg2_75)
	arg1_75 = math.floor(arg1_75)

	local var0_75 = arg0_75.dropDown:Find("Airsupport")

	setText(var0_75:Find("Text"), i18n("level_scene_title_word_3"))

	local var1_75 = arg2_75 < arg1_75

	setText(var0_75:Find("Value1"), setColorStr(arg1_75, var1_75 and "#51FF55" or COLOR_WHITE))
	setText(var0_75:Find("Value2"), arg2_75)
	triggerToggle(arg0_75.dropDownSide:Find("Layout/Item2/Dot"), var1_75)
end

function var0_0.UpdateSonarRange(arg0_76)
	for iter0_76 = 1, 2 do
		local var0_76 = arg0_76.selectIds[FleetType.Normal][iter0_76] or 0
		local var1_76 = arg0_76:getFleetById(var0_76)
		local var2_76 = var1_76 and math.floor(var1_76:GetFleetSonarRange()) or 0

		arg0_76:UpdateSonarRangeValues(iter0_76, var2_76)
	end
end

function var0_0.UpdateEliteSonarRange(arg0_77)
	for iter0_77 = 1, 2 do
		local var0_77 = arg0_77.eliteFleetList[iter0_77]
		local var1_77 = {}

		for iter1_77, iter2_77 in pairs(arg0_77.eliteCommanderList[iter0_77]) do
			table.insert(var1_77, {
				pos = iter1_77,
				id = iter2_77
			})
		end

		local var2_77 = TypedFleet.New({
			ship_list = var0_77,
			commanders = var1_77,
			fleetType = FleetType.Normal
		})
		local var3_77 = var2_77 and math.floor(var2_77:GetFleetSonarRange()) or 0

		arg0_77:UpdateSonarRangeValues(iter0_77, var3_77)
	end
end

function var0_0.UpdateSonarRangeValues(arg0_78, arg1_78, arg2_78)
	local var0_78 = arg0_78.dropDownSide:Find("Layout/Item3/Values")

	setText(var0_78:GetChild(arg1_78 - 1), arg2_78)
end

function var0_0.clearFleet(arg0_79, arg1_79)
	local var0_79 = arg0_79:findTF(TeamType.Main, arg1_79)
	local var1_79 = arg0_79:findTF(TeamType.Vanguard, arg1_79)
	local var2_79 = arg0_79:findTF(TeamType.Submarine, arg1_79)

	if var0_79 then
		removeAllChildren(var0_79)
	end

	if var1_79 then
		removeAllChildren(var1_79)
	end

	if var2_79 then
		removeAllChildren(var2_79)
	end
end

function var0_0.clear(arg0_80)
	arg0_80.contextData.tabIndex = nil
	arg0_80.duties = nil
end

function var0_0.onCancelHard(arg0_81, arg1_81)
	if arg1_81 then
		arg0_81:emit(LevelMediator2.ON_UPDATE_CUSTOM_FLEET, arg0_81.chapter)
	end

	arg0_81:emit(LevelUIConst.HIDE_FLEET_EDIT)
end

function var0_0.setHardShipVOs(arg0_82, arg1_82)
	arg0_82.shipVOs = arg1_82
end

function var0_0.setOnHard(arg0_83, arg1_83)
	arg0_83.chapter = arg1_83
	arg0_83.mode = var2_0.EDIT
	arg0_83.propetyLimitation = arg0_83.chapter:getConfig("property_limitation")
	arg0_83.eliteFleetList = arg0_83.chapter:getEliteFleetList()
	arg0_83.chapterASValue = arg0_83.chapter:getConfig("air_dominance")
	arg0_83.suggestionValue = arg0_83.chapter:getConfig("best_air_dominance")
	arg0_83.eliteCommanderList = arg0_83.chapter:getEliteFleetCommanders()
	arg0_83.typeLimitations = arg0_83.chapter:getConfig("limitation")

	arg0_83:SetDutyTabEnabled(arg1_83:isLoop())

	local var0_83 = arg0_83:getLimitNums(FleetType.Support) > 0

	setActive(arg0_83.supportFleetHelp, var0_83)

	arg0_83.displayMode = var0_83 and var3_0.ADDITION_SUPPORT or var3_0.NORMAL

	arg0_83:SwitchDisplayMode()

	arg0_83.duties = {}

	local var1_83 = PlayerPrefs.GetInt("lastFleetDuty_" .. (arg0_83.chapter.id or 0), 0)

	if var1_83 > 0 then
		local var2_83 = bit.band(var1_83, 255)
		local var3_83 = bit.rshift(var1_83, 8)
		local var4_83 = bit.band(var3_83, 255)

		if var2_83 > 0 and var4_83 > 0 then
			arg0_83.duties[var2_83] = var4_83
		end
	end

	onButton(arg0_83, arg0_83.btnGo, function()
		local var0_84 = "chapter_autofight_flag_" .. arg0_83.chapter.id
		local var1_84 = arg0_83.chapter
		local var2_84
		local var3_84

		seriesAsync({
			function(arg0_85)
				local var0_85 = PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1

				if not (PlayerPrefs.GetInt(var0_84, 1) == 1) or not arg0_83:getSPItem() or var0_85 then
					return arg0_85()
				end

				PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
				PlayerPrefs.Save()

				local function var1_85()
					arg0_83:clearSPBuff()
				end

				arg0_83:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
					hideNo = true,
					content = i18n("autofight_special_operation_tip"),
					onYes = var1_85,
					onNo = var1_85
				})
			end,
			function(arg0_87)
				var2_84 = arg0_83.chapter:GetActiveSPItemID()
				var3_84 = arg0_83.chapter:isLoop() and arg0_83:GetOrderedDuties() or nil

				arg0_83:clear()
				arg0_83:onCancelHard()
				arg0_87()
			end,
			function(arg0_88)
				local var0_88 = PlayerPrefs.GetInt(var0_84, 1) == 1
				local var1_88 = LevelMediator2.ON_ELITE_TRACKING
				local var2_88 = packEx(var1_84.id, var1_84.loopFlag, var2_84, var3_84, var0_88)

				if pg.m02:retrieveMediator(LevelMediator2.__cname) then
					pg.m02:sendNotification(var1_88, var2_88)

					return
				end

				local var3_88 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

				if var3_88 then
					var3_88:extendData({
						ToTrackingData = {
							var1_88,
							var2_88
						}
					})
				end
			end
		})
	end, SFX_UI_WEIGHANCHOR_GO)
	setActive(arg0_83.btnMultiple, AutoBotCommand.autoBotSatisfied() and arg0_83.chapter:isLoop())
	onButton(arg0_83, arg0_83.btnMultiple, function()
		local var0_89 = arg0_83:getSPItem()
		local var1_89 = arg0_83:GetOrderedDuties()

		arg0_83:emit(LevelUIConst.OPEN_ELITE_CONTINUOUS_WINDOW, arg0_83.chapter, var0_89, var1_89)
	end, SFX_PANEL)
	onButton(arg0_83, arg0_83.btnASHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0_83, arg0_83.btnBack, function()
		arg0_83:clear()
		arg0_83:onCancelHard(true)
	end, SFX_CANCEL)
	onButton(arg0_83, arg0_83._tf:Find("bg"), function()
		arg0_83:clear()
		arg0_83:onCancelHard(true)
	end, SFX_CANCEL)
	onToggle(arg0_83, arg0_83.commanderToggle, function(arg0_93)
		if arg0_93 then
			arg0_83.contextData.tabIndex = var0_0.TabIndex.Commander

			arg0_83:flush()
		end
	end, SFX_PANEL)
	onToggle(arg0_83, arg0_83.formationToggle, function(arg0_94)
		if arg0_94 then
			arg0_83.contextData.tabIndex = var0_0.TabIndex.Formation

			arg0_83:flush()
		end
	end, SFX_PANEL)
	onToggle(arg0_83, arg0_83.dutyToggle, function(arg0_95)
		if arg0_95 then
			arg0_83.contextData.tabIndex = var0_0.TabIndex.Duty

			arg0_83:flush()
		end
	end, SFX_UI_TAG)
	onToggle(arg0_83, arg0_83.adjustmentToggle, function(arg0_96)
		if arg0_96 then
			arg0_83.contextData.tabIndex = var0_0.TabIndex.Adjustment

			arg0_83:flush()
		end
	end, SFX_PANEL)
	setActive(arg0_83.formationToggle, true)
	setActive(arg0_83.commanderToggle, arg0_83.openedCommanerSystem)
	setActive(arg0_83.dutyToggle, arg0_83.dutyTabEnabled)
	setActive(arg0_83.adjustmentToggle, true)
	arg0_83:flush()
end

function var0_0.flush(arg0_97)
	arg0_97:updateEliteLimit()
	arg0_97:updateEliteASValue()

	arg0_97.lastFleetVaildStatus = arg0_97.lastFleetVaildStatus or {}

	local var0_97 = {
		not arg0_97:IsListOfFleetEmpty(1) or nil,
		not arg0_97:IsListOfFleetEmpty(2) or nil
	}

	if arg0_97.dutyTabEnabled and table.getCount(arg0_97.lastFleetVaildStatus) == 2 and table.getCount(var0_97) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_change_tip"))
	end

	arg0_97.lastFleetVaildStatus = var0_97

	arg0_97:updateEliteFleets()
	arg0_97:UpdateEliteSonarRange()
	arg0_97:UpdateEliteInvestigation()
end

function var0_0.updateEliteLimit(arg0_98)
	setActive(arg0_98.toggleMask, false)
	setActive(arg0_98.tfLimit, false)
	setActive(arg0_98.tfLimitTips, #arg0_98.propetyLimitation == 0)
	setActive(arg0_98.tfLimitElite, #arg0_98.propetyLimitation > 0)
	setActive(arg0_98.tfLimitSubTip, #arg0_98.propetyLimitation > 0)

	if #arg0_98.propetyLimitation > 0 then
		local var0_98, var1_98 = arg0_98.chapter:IsPropertyLimitationSatisfy()
		local var2_98 = UIItemList.New(arg0_98.tfLimitContainer, arg0_98.tfLimitContainer:GetChild(0))

		var2_98:make(function(arg0_99, arg1_99, arg2_99)
			arg1_99 = arg1_99 + 1

			if arg0_99 == UIItemList.EventUpdate then
				local var0_99 = arg0_98.propetyLimitation[arg1_99]
				local var1_99, var2_99, var3_99, var4_99 = unpack(var0_99)

				if var0_98[arg1_99] == 1 then
					arg0_98:findTF("Text", arg2_99):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
				else
					arg0_98:findTF("Text", arg2_99):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
				end

				setActive(arg2_99, true)

				local var5_99 = (AttributeType.EliteCondition2Name(var1_99, var4_99) .. AttributeType.eliteConditionCompareTip(var2_99) .. var3_99) .. "（" .. var1_98[var1_99] .. "）"

				setText(arg0_98:findTF("Text", arg2_99), var5_99)
			end
		end)
		var2_98:align(#arg0_98.propetyLimitation)
		setActive(arg0_98.tfLimitSubTip, arg0_98.chapter:getConfig("submarine_num") > 0)
	end

	local var3_98 = arg0_98.chapter:isLoop() and arg0_98.chapter:getConfig("use_oil_limit") or {}

	setActive(arg0_98.rtCostLimit, #var3_98 > 0)
	setText(arg0_98.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip"))

	if #var3_98 > 0 then
		setActive(arg0_98.rtCostLimit:Find("cost_noraml"), var3_98[1] > 0)
		setText(arg0_98.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_enemy"), var3_98[1]))
		setActive(arg0_98.rtCostLimit:Find("cost_boss"), var3_98[2] > 0)
		setText(arg0_98.rtCostLimit:Find("cost_boss/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_flagship"), var3_98[2]))
		setActive(arg0_98.rtCostLimit:Find("cost_sub"), var3_98[3] > 0)
		setText(arg0_98.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var3_98[3]))
	end
end

function var0_0.initAddButton(arg0_100, arg1_100, arg2_100, arg3_100, arg4_100)
	local var0_100 = arg0_100.eliteFleetList[arg4_100]
	local var1_100 = {}
	local var2_100 = {}

	for iter0_100, iter1_100 in ipairs(var0_100) do
		var1_100[arg0_100.shipVOs[iter1_100]] = true

		if arg2_100 == arg0_100.shipVOs[iter1_100]:getTeamType() then
			table.insert(var2_100, iter1_100)
		end
	end

	local var3_100 = findTF(arg1_100, arg2_100)

	removeAllChildren(var3_100)

	local var4_100 = 0
	local var5_100 = false
	local var6_100 = 0

	arg3_100 = var0_0.sortTeamLimitation(arg3_100)

	local var7_100 = var3_100:GetComponent("ContentSizeFitter")
	local var8_100 = var3_100:GetComponent("HorizontalLayoutGroup")

	var7_100.enabled = true
	var8_100.enabled = true
	arg0_100.isDraging = false

	for iter2_100 = 1, 3 do
		local var9_100
		local var10_100
		local var11_100
		local var12_100 = var2_100[iter2_100] and arg0_100.shipVOs[var2_100[iter2_100]] or nil

		if var12_100 then
			for iter3_100, iter4_100 in ipairs(arg3_100) do
				if ShipType.ContainInLimitBundle(iter4_100, var12_100:getShipType()) then
					var10_100 = var12_100
					var11_100 = iter4_100

					table.remove(arg3_100, iter3_100)

					var5_100 = var5_100 or iter4_100 ~= 0

					break
				end
			end
		else
			var11_100 = arg3_100[1]

			table.remove(arg3_100, 1)
		end

		if var11_100 == 0 then
			var6_100 = var6_100 + 1
		end

		local var13_100 = var10_100 and cloneTplTo(arg0_100.tfShipTpl, var3_100) or cloneTplTo(arg0_100.tfEmptyTpl, var3_100)

		setActive(var13_100, true)

		if var10_100 then
			updateShip(var13_100, var10_100)
			setActive(arg0_100:findTF("event_block", var13_100), var10_100:getFlag("inEvent"))

			var1_100[var10_100] = true
		else
			var4_100 = var4_100 + 1
		end

		setActive(arg0_100:findTF("ship_type", var13_100), var11_100 and var11_100 ~= 0)

		if var11_100 and var11_100 ~= 0 then
			if type(var11_100) == "number" then
				local var14_100 = GetSpriteFromAtlas("shiptype", ShipType.Type2CNLabel(var11_100))

				setImageSprite(arg0_100:findTF("ship_type", var13_100), var14_100, true)
			elseif type(var11_100) == "string" then
				local var15_100 = GetSpriteFromAtlas("shiptype", ShipType.BundleType2CNLabel(var11_100))

				setImageSprite(arg0_100:findTF("ship_type", var13_100), var15_100, true)
			end
		end

		local var16_100 = _.map(var0_100, function(arg0_101)
			return arg0_100.shipVOs[arg0_101]
		end)

		table.sort(var16_100, function(arg0_102, arg1_102)
			return var1_0[arg0_102:getTeamType()] < var1_0[arg1_102:getTeamType()] or var1_0[arg0_102:getTeamType()] == var1_0[arg1_102:getTeamType()] and table.indexof(var0_100, arg0_102.id) < table.indexof(var0_100, arg1_102.id)
		end)

		local var17_100 = GetOrAddComponent(var13_100, typeof(UILongPressTrigger))

		var17_100.onLongPressed:RemoveAllListeners()

		if var10_100 and arg0_100.contextData.tabIndex ~= var0_0.TabIndex.Adjustment then
			var17_100.onLongPressed:AddListener(function()
				arg0_100:onCancelHard(true)
				arg0_100:emit(LevelMediator2.ON_FLEET_SHIPINFO, {
					shipId = var10_100.id,
					shipVOs = var16_100,
					chapter = arg0_100.chapter
				})
			end)
		end

		local var18_100 = GetOrAddComponent(var13_100, "EventTriggerListener")

		var18_100:RemovePointClickFunc()
		var18_100:AddPointClickFunc(function(arg0_104, arg1_104)
			if arg0_104 ~= var13_100.gameObject then
				return
			end

			if arg0_100.isDraging then
				return
			end

			arg0_100:onCancelHard()
			arg0_100:emit(LevelMediator2.ON_ELITE_OEPN_DECK, {
				shipType = var11_100,
				fleet = var1_100,
				chapter = arg0_100.chapter,
				shipVO = var10_100,
				fleetIndex = arg4_100,
				teamType = arg2_100
			})
		end)
		var18_100:RemoveBeginDragFunc()
		var18_100:RemoveDragFunc()
		var18_100:RemoveDragEndFunc()

		if var10_100 and arg0_100.contextData.tabIndex == var0_0.TabIndex.Adjustment then
			local var19_100 = var13_100.rect.width * 0.5
			local var20_100 = {}
			local var21_100 = {}

			var18_100:AddBeginDragFunc(function(arg0_105, arg1_105)
				if arg0_105 ~= var13_100.gameObject then
					return
				end

				if arg0_100.isDraging then
					return
				end

				arg0_100.isDraging = true
				var7_100.enabled = false
				var8_100.enabled = false

				for iter0_105 = 1, 3 do
					local var0_105 = var3_100:GetChild(iter0_105 - 1)

					if var13_100 == var0_105 then
						arg0_100.dragIndex = iter0_105
					end

					var20_100[iter0_105] = var0_105.anchoredPosition
					var21_100[iter0_105] = var0_105
				end
			end)
			var18_100:AddDragFunc(function(arg0_106, arg1_106)
				if arg0_106 ~= var13_100.gameObject then
					return
				end

				if not arg0_100.isDraging then
					return
				end

				local var0_106 = var13_100.localPosition

				var0_106.x = arg0_100:change2ScrPos(var13_100.parent, arg1_106.position).x
				var0_106.x = math.clamp(var0_106.x, var20_100[1].x, var20_100[3].x)
				var13_100.localPosition = var0_106

				local var1_106 = 1

				for iter0_106 = 1, 3 do
					if var13_100 ~= var21_100[iter0_106] and var13_100.localPosition.x > var21_100[iter0_106].localPosition.x + (var1_106 < arg0_100.dragIndex and 1.1 or -1.1) * var19_100 then
						var1_106 = var1_106 + 1
					end
				end

				if arg0_100.dragIndex ~= var1_106 then
					local var2_106 = var1_106 < arg0_100.dragIndex and -1 or 1

					while arg0_100.dragIndex ~= var1_106 do
						local var3_106 = arg0_100.dragIndex
						local var4_106 = arg0_100.dragIndex + var2_106

						var2_100[var3_106], var2_100[var4_106] = var2_100[var4_106], var2_100[var3_106]
						var21_100[var3_106], var21_100[var4_106] = var21_100[var4_106], var21_100[var3_106]
						arg0_100.dragIndex = arg0_100.dragIndex + var2_106
					end

					for iter1_106 = 1, 3 do
						if var13_100 ~= var21_100[iter1_106] then
							var21_100[iter1_106].anchoredPosition = var20_100[iter1_106]
						end
					end
				end
			end)
			var18_100:AddDragEndFunc(function(arg0_107, arg1_107)
				if arg0_107 ~= var13_100.gameObject then
					return
				end

				if not arg0_100.isDraging then
					return
				end

				arg0_100.isDraging = false

				for iter0_107 = 1, 3 do
					if not var2_100[iter0_107] then
						for iter1_107 = iter0_107 + 1, 3 do
							if var2_100[iter1_107] then
								var2_100[iter0_107], var2_100[iter1_107] = var2_100[iter1_107], var2_100[iter0_107]
								var21_100[iter0_107], var21_100[iter1_107] = var21_100[iter1_107], var21_100[iter0_107]
							end
						end
					end

					if var2_100[iter0_107] then
						table.removebyvalue(var0_100, var2_100[iter0_107])
						table.insert(var0_100, var2_100[iter0_107])
					else
						break
					end
				end

				for iter2_107 = 1, 3 do
					var21_100[iter2_107]:SetSiblingIndex(iter2_107 - 1)
				end

				var7_100.enabled = true
				var8_100.enabled = true
				arg0_100.dragIndex = nil

				arg0_100:emit(LevelMediator2.ON_ELITE_ADJUSTMENT, arg0_100.chapter)
			end)
		end
	end

	if (var5_100 == true or var6_100 == 3) and var4_100 ~= 3 then
		return true
	else
		return false
	end
end

function var0_0.change2ScrPos(arg0_108, arg1_108, arg2_108)
	local var0_108 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1_108, arg2_108, var0_108))
end

function var0_0.updateEliteFleets(arg0_109)
	for iter0_109, iter1_109 in pairs(arg0_109.tfFleets) do
		for iter2_109 = 1, #iter1_109 do
			arg0_109:UpdateEliteFleet(iter0_109, iter2_109)
		end
	end

	arg0_109:RefreshDutyBar()
end

function var0_0.UpdateEliteFleet(arg0_110, arg1_110, arg2_110)
	local var0_110 = arg0_110.contextData.tabIndex == var0_0.TabIndex.Formation
	local var1_110 = arg0_110.contextData.tabIndex == var0_0.TabIndex.Commander
	local var2_110 = arg0_110.contextData.tabIndex == var0_0.TabIndex.Duty
	local var3_110 = arg0_110.contextData.tabIndex == var0_0.TabIndex.Adjustment
	local var4_110 = arg2_110 <= arg0_110:getLimitNums(arg1_110)
	local var5_110 = arg0_110.tfFleets[arg1_110][arg2_110]
	local var6_110 = findTF(var5_110, "bg/name")
	local var7_110 = arg0_110:findTF("btn_select", var5_110)
	local var8_110 = arg0_110:findTF("btn_recom", var5_110)
	local var9_110 = arg0_110:findTF("btn_clear", var5_110)
	local var10_110 = arg0_110:findTF("blank", var5_110)
	local var11_110 = arg0_110:findTF("selected", var5_110)
	local var12_110 = arg0_110:findTF("commander", var5_110)
	local var13_110 = var5_110:Find("adjustment_flag")

	setActive(var7_110, false)

	local var14_110 = arg0_110:findTF(TeamType.Main, var5_110)
	local var15_110 = arg0_110:findTF(TeamType.Vanguard, var5_110)
	local var16_110 = arg0_110:findTF(TeamType.Submarine, var5_110)
	local var17_110 = arg0_110:findTF(TeamType.Support, var5_110)

	if not var4_110 then
		setActive(var9_110, false)
		setActive(var8_110, false)
		setActive(var12_110, false)
		setActive(var13_110, false)
		setActive(var10_110, true)
		setActive(var11_110, false)
		setText(var6_110, "")

		if arg1_110 == FleetType.Normal then
			setActive(var14_110, false)
			setActive(var15_110, false)
		elseif arg1_110 == FleetType.Submarine then
			setActive(var16_110, false)
		elseif arg1_110 == FleetType.Support then
			setActive(var17_110, false)
		end

		return
	end

	local var18_110 = arg1_110 == FleetType.Support

	setActive(var9_110, var0_110)
	setActive(var8_110, var0_110)
	setActive(var12_110, var1_110 and not var18_110)
	setActive(var13_110, var3_110)
	setActive(var10_110, var2_110 or var3_110 or var1_110 and var18_110)

	local var19_110 = arg2_110

	if arg1_110 == FleetType.Normal then
		setText(var6_110, Fleet.DEFAULT_NAME[arg2_110])
		setActive(var14_110, true)
		setActive(var15_110, true)
	elseif arg1_110 == FleetType.Submarine then
		var19_110 = 3

		setText(var6_110, Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID + arg2_110 - 1])
		setActive(var16_110, true)
	elseif arg1_110 == FleetType.Support then
		var19_110 = 4

		setText(var6_110, "")
		setActive(var17_110, true)
	end

	local var20_110 = 6

	if arg1_110 == FleetType.Normal then
		local var21_110 = arg0_110.typeLimitations[arg2_110]
		local var22_110 = var21_110[1]
		local var23_110 = var21_110[2]
		local var24_110 = arg0_110:initAddButton(var5_110, TeamType.Main, var22_110, var19_110)
		local var25_110 = arg0_110:initAddButton(var5_110, TeamType.Vanguard, var23_110, var19_110)

		setActive(var11_110, var24_110 and var25_110)
	elseif arg1_110 == FleetType.Submarine then
		var20_110 = 3

		local var26_110 = arg0_110:initAddButton(var5_110, TeamType.Submarine, {
			0,
			0,
			0
		}, var19_110)

		setActive(var11_110, var26_110)
	elseif arg1_110 == FleetType.Support then
		var20_110 = 3

		local var27_110 = arg0_110:initSupportAddButton(var5_110, TeamType.Support, {
			"hang",
			"hang",
			"hang"
		})

		setActive(var11_110, arg0_110.mode == var2_0.EDIT and var27_110)
	end

	if not var18_110 then
		arg0_110:initCommander(var19_110, var12_110, arg0_110.chapter)
	end

	onButton(arg0_110, var9_110, function()
		if #(not var18_110 and arg0_110.eliteFleetList[var19_110] or arg0_110.supportFleet) == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("battle_preCombatLayer_clear_confirm"),
			onYes = function()
				if not var18_110 then
					arg0_110:emit(LevelMediator2.ON_ELITE_CLEAR, {
						index = var19_110,
						chapterVO = arg0_110.chapter
					})
				else
					arg0_110:emit(LevelMediator2.ON_SUPPORT_CLEAR, {
						index = var19_110,
						chapterVO = arg0_110.chapter
					})
				end
			end
		})
	end)
	onButton(arg0_110, var8_110, function()
		local var0_113 = #(not var18_110 and arg0_110.eliteFleetList[var19_110] or arg0_110.supportFleet)

		if var0_113 == var20_110 then
			return
		end

		seriesAsync({
			function(arg0_114)
				if var0_113 == 0 then
					return arg0_114()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("battle_preCombatLayer_auto_confirm"),
					onYes = arg0_114
				})
			end,
			function()
				if not var18_110 then
					arg0_110:emit(LevelMediator2.ON_ELITE_RECOMMEND, {
						index = var19_110,
						chapterVO = arg0_110.chapter
					})
				else
					arg0_110:emit(LevelMediator2.ON_SUPPORT_RECOMMEND, {
						index = var19_110,
						chapterVO = arg0_110.chapter
					})
				end
			end
		})
	end)
end

function var0_0.initCommander(arg0_116, arg1_116, arg2_116, arg3_116)
	local var0_116 = arg3_116:getEliteFleetCommanders()[arg1_116]

	for iter0_116 = 1, 2 do
		local var1_116 = var0_116[iter0_116]
		local var2_116

		if var1_116 then
			var2_116 = getProxy(CommanderProxy):getCommanderById(var1_116)
		end

		local var3_116 = arg2_116:Find("pos" .. iter0_116)
		local var4_116 = var3_116:Find("add")
		local var5_116 = var3_116:Find("info")

		setActive(var4_116, not var2_116)
		setActive(var5_116, var2_116)

		if var2_116 then
			local var6_116 = Commander.rarity2Frame(var2_116:getRarity())

			setImageSprite(var5_116:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_116))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_116:getPainting(), "", var5_116:Find("mask/icon"))
		end

		local var7_116 = arg3_116:wrapEliteFleet(arg1_116)

		onButton(arg0_116, var4_116, function()
			arg0_116:emit(LevelUIConst.OPEN_COMMANDER_PANEL, var7_116, arg3_116, arg1_116)
		end, SFX_PANEL)
		onButton(arg0_116, var5_116, function()
			arg0_116:emit(LevelUIConst.OPEN_COMMANDER_PANEL, var7_116, arg3_116, arg1_116)
		end, SFX_PANEL)
	end
end

function var0_0.initSupportAddButton(arg0_119, arg1_119, arg2_119, arg3_119)
	local var0_119 = {}
	local var1_119 = {}

	for iter0_119, iter1_119 in ipairs(arg0_119.supportFleet) do
		var0_119[arg0_119.shipVOs[iter1_119]] = true

		table.insert(var1_119, iter1_119)
	end

	local var2_119 = findTF(arg1_119, arg2_119)

	removeAllChildren(var2_119)

	local var3_119 = 0
	local var4_119 = false
	local var5_119 = 0

	arg3_119 = var0_0.sortTeamLimitation(arg3_119)

	for iter2_119 = 1, 3 do
		local var6_119
		local var7_119
		local var8_119 = var1_119[iter2_119] and arg0_119.shipVOs[var1_119[iter2_119]] or nil

		if var8_119 then
			for iter3_119, iter4_119 in ipairs(arg3_119) do
				if ShipType.ContainInLimitBundle(iter4_119, var8_119:getShipType()) then
					var6_119 = var8_119
					var7_119 = iter4_119

					table.remove(arg3_119, iter3_119)

					var4_119 = var4_119 or iter4_119 ~= 0

					break
				end
			end
		else
			var7_119 = arg3_119[1]

			table.remove(arg3_119, 1)
		end

		if var7_119 == 0 then
			var5_119 = var5_119 + 1
		end

		local var9_119 = var6_119 and cloneTplTo(arg0_119.tfShipTpl, var2_119) or cloneTplTo(arg0_119.tfEmptyTpl, var2_119)

		setActive(var9_119, true)

		if var6_119 then
			updateShip(var9_119, var6_119)
			setActive(arg0_119:findTF("event_block", var9_119), var6_119:getFlag("inEvent"))

			var0_119[var6_119] = true
		else
			var3_119 = var3_119 + 1
		end

		setActive(arg0_119:findTF("ship_type", var9_119), var7_119 and var7_119 ~= 0)

		if var7_119 and var7_119 ~= 0 then
			if type(var7_119) == "number" then
				local var10_119 = GetSpriteFromAtlas("shiptype", ShipType.Type2CNLabel(var7_119))

				setImageSprite(arg0_119:findTF("ship_type", var9_119), var10_119, true)
			elseif type(var7_119) == "string" then
				local var11_119 = GetSpriteFromAtlas("shiptype", ShipType.BundleType2CNLabel(var7_119))

				setImageSprite(arg0_119:findTF("ship_type", var9_119), var11_119, true)
			end
		end

		local var12_119 = _.map(arg0_119.supportFleet, function(arg0_120)
			return arg0_119.shipVOs[arg0_120]
		end)
		local var13_119 = GetOrAddComponent(var9_119, typeof(UILongPressTrigger))

		var13_119.onLongPressed:RemoveAllListeners()

		if var6_119 and arg0_119.contextData.tabIndex ~= var0_0.TabIndex.Adjustment then
			var13_119.onLongPressed:AddListener(function()
				arg0_119:onCancelSupport(true)
				arg0_119:emit(LevelMediator2.ON_SUPPORT_SHIPINFO, {
					shipId = var6_119.id,
					shipVOs = var12_119,
					chapter = arg0_119.chapter
				})
			end)
		end

		local var14_119 = GetOrAddComponent(var9_119, "EventTriggerListener")

		var14_119:RemovePointClickFunc()
		var14_119:AddPointClickFunc(function(arg0_122, arg1_122)
			if arg0_122 ~= var9_119.gameObject then
				return
			end

			if arg0_119.isDraging then
				return
			end

			arg0_119:onCancelSupport()
			arg0_119:emit(LevelMediator2.ON_SUPPORT_OPEN_DECK, {
				shipType = var7_119,
				fleet = var0_119,
				chapter = arg0_119.chapter,
				shipVO = var6_119
			})
		end)
		var14_119:RemoveBeginDragFunc()
		var14_119:RemoveDragFunc()
		var14_119:RemoveDragEndFunc()
	end

	if (var4_119 == true or var5_119 == 3) and var3_119 ~= 3 then
		return true
	else
		return false
	end
end

function var0_0.updateSpecialOperationTickets(arg0_123, arg1_123)
	arg0_123.spOPTicketItems = arg1_123 or {}
end

function var0_0.getLegalSPBuffList(arg0_124)
	local var0_124 = arg0_124.chapter:GetSpItems()

	return _.map(var0_124, function(arg0_125)
		return Chapter.GetSPBuffByItem(arg0_125:GetConfigID())
	end)
end

function var0_0.initSPOPView(arg0_126)
	arg0_126.spPanel = arg0_126.btnSp:Find("sp_panel")
	arg0_126.spItem = arg0_126.btnSp:Find("item")
	arg0_126.spDesc = arg0_126.btnSp:Find("desc")
	arg0_126.spCheckBox = arg0_126.btnSp:Find("checkbox")
	arg0_126.spCheckMark = arg0_126.spCheckBox:Find("mark")
	arg0_126.spTpl = arg0_126.spPanel:Find("sp_tpl")
	arg0_126.spContainer = arg0_126.spPanel:Find("sp_container")
	arg0_126.spItemEmptyBlock = arg0_126.btnSp:Find("empty_block")

	setText(arg0_126.spItemEmptyBlock, i18n("levelScene_select_noitem"))
	removeAllChildren(arg0_126.spContainer)

	local var0_126 = arg0_126:getLegalSPBuffList()
	local var1_126 = arg0_126.chapter:GetActiveSPItemID()

	arg0_126:setSPBtnFormByBuffCount()

	if #var0_126 == 0 then
		arg0_126:clearSPBuff()
	elseif #var0_126 == 1 then
		local var2_126 = var0_126[1]
		local var3_126 = pg.benefit_buff_template[var2_126]

		arg0_126:setTicketInfo(arg0_126.btnSp, var3_126.benefit_condition)
		setText(arg0_126.spDesc, var3_126.desc)
		onButton(arg0_126, arg0_126.btnSp:Find("item"), function()
			arg0_126:emit(BaseUI.ON_ITEM, tonumber(var3_126.benefit_condition))
		end)
		onButton(arg0_126, arg0_126.btnSp, function()
			local var0_128 = Chapter.GetSPOperationItemCacheKey(arg0_126.chapter.id)

			if arg0_126.spCheckMark.gameObject.activeSelf then
				PlayerPrefs.SetInt(var0_128, 0)
				arg0_126:clearSPBuff()
			else
				arg0_126.spItemID = tonumber(var3_126.benefit_condition)

				PlayerPrefs.SetInt(var0_128, arg0_126.spItemID)
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_select_sp"))
				setActive(arg0_126.spCheckMark, true)
			end
		end)
		setActive(arg0_126.spCheckMark, var1_126 == 0)
		triggerButton(arg0_126.btnSp)
	elseif #var0_126 > 1 then
		setText(arg0_126.spDesc, i18n("levelScene_select_SP_OP"))

		for iter0_126, iter1_126 in ipairs(var0_126) do
			local var4_126 = cloneTplTo(arg0_126.spTpl, arg0_126.spContainer)

			setText(var4_126:Find("desc"), iter1_126.desc)
			arg0_126:setTicketInfo(var4_126, iter1_126.benefit_condition)
			setActive(var4_126:Find("block"), false)
			onButton(arg0_126, var4_126, function()
				arg0_126:setSPBuffSelected(iter1_126.id)
				setActive(arg0_126.spPanel, false)
			end)
		end

		onButton(arg0_126, arg0_126.btnSp, function()
			if arg0_126.spPanel.gameObject.activeSelf then
				arg0_126:clearSPBuff()

				local var0_130 = Chapter.GetSPOperationItemCacheKey(arg0_126.chapter.id)

				PlayerPrefs.SetInt(var0_130, 0)
				setActive(arg0_126.spPanel, false)
			else
				setActive(arg0_126.spPanel, true)
				setActive(arg0_126.btnSp:Find("item"), false)
				setText(arg0_126.spDesc, i18n("levelScene_unselect_SP_OP"))
			end
		end)

		if var1_126 ~= 0 then
			local var5_126

			for iter2_126, iter3_126 in ipairs(var0_126) do
				if iter3_126.id == Chapter.GetSPBuffByItem(var1_126) then
					var5_126 = true

					break
				end
			end

			if var5_126 then
				local var6_126 = Chapter.GetSPBuffByItem(var1_126)

				arg0_126:setSPBuffSelected(var6_126)
			else
				arg0_126:clearSPBuff()
			end
		else
			arg0_126:clearSPBuff()
		end
	end

	setActive(arg0_126.spPanel, false)
end

function var0_0.setSPBuffSelected(arg0_131, arg1_131)
	local var0_131 = pg.benefit_buff_template[arg1_131]

	arg0_131.spItemID = tonumber(var0_131.benefit_condition)

	arg0_131:setTicketInfo(arg0_131.btnSp, arg0_131.spItemID)
	setText(arg0_131.spDesc, var0_131.desc)

	local var1_131 = Chapter.GetSPOperationItemCacheKey(arg0_131.chapter.id)

	PlayerPrefs.SetInt(var1_131, arg0_131.spItemID)
end

function var0_0.clearSPBuff(arg0_132)
	local var0_132 = arg0_132:getLegalSPBuffList()

	arg0_132.spItemID = nil

	arg0_132:setSPBtnFormByBuffCount()

	if #var0_132 == 0 then
		setActive(arg0_132.btnSp:Find("item"), false)
	elseif #var0_132 == 1 then
		setActive(arg0_132.btnSp:Find("item"), true)
		setActive(arg0_132.spCheckMark, false)
	elseif #var0_132 > 1 then
		setActive(arg0_132.btnSp:Find("item"), false)
		setText(arg0_132.spDesc, i18n("levelScene_select_SP_OP"))
	end
end

function var0_0.setSPBtnFormByBuffCount(arg0_133)
	local var0_133 = arg0_133:getLegalSPBuffList()

	if #var0_133 == 0 then
		setActive(arg0_133.spItemEmptyBlock, true)
		setActive(arg0_133.spDesc, false)
		setActive(arg0_133.spCheckBox, false)
		setActive(arg0_133.btnSp:Find("add"), false)
	elseif #var0_133 == 1 then
		setActive(arg0_133.spItemEmptyBlock, false)
		setActive(arg0_133.spDesc, true)
		setActive(arg0_133.spCheckBox, true)
		setActive(arg0_133.btnSp:Find("add"), false)
	elseif #var0_133 > 1 then
		setActive(arg0_133.spItemEmptyBlock, false)
		setActive(arg0_133.spDesc, true)
		setActive(arg0_133.spCheckBox, false)
		setActive(arg0_133.btnSp:Find("add"), true)
	end
end

function var0_0.setTicketInfo(arg0_134, arg1_134, arg2_134)
	local var0_134

	arg2_134 = tonumber(arg2_134)

	for iter0_134, iter1_134 in ipairs(arg0_134.spOPTicketItems) do
		if arg2_134 == iter1_134.configId then
			var0_134 = iter1_134

			break
		end
	end

	if var0_134 then
		setText(arg1_134:Find("item/count"), var0_134.count)
		GetImageSpriteFromAtlasAsync(var0_134:getConfig("icon"), "", arg1_134:Find("item/icon"))
	else
		setText(arg1_134:Find("item/count"), 0)
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg2_134
		}):getIcon(), "", arg1_134:Find("item/icon"))
	end

	setActive(arg1_134:Find("item"), true)
end

function var0_0.getSPItem(arg0_135)
	return arg0_135.spItemID
end

function var0_0.SetDuty(arg0_136, arg1_136, arg2_136)
	if not arg2_136 or not arg0_136.duties then
		return
	end

	if arg0_136.duties[arg1_136] == arg2_136 then
		return
	end

	arg0_136.duties[arg1_136] = arg2_136
	arg0_136.duties[3 - arg1_136] = nil

	arg0_136:RefreshDutyBar()
end

function var0_0.UpdateDuties(arg0_137)
	if not arg0_137.dutyTabEnabled then
		return
	end

	local var0_137 = 0
	local var1_137 = 0

	for iter0_137 = 1, 2 do
		if not arg0_137:IsListOfFleetEmpty(iter0_137) then
			var0_137 = var0_137 + 1
			var1_137 = iter0_137
		end
	end

	if var0_137 == 0 then
		table.clear(arg0_137.duties)
	elseif var0_137 == 1 then
		arg0_137.duties[var1_137] = ChapterFleet.DUTY_KILLALL
		arg0_137.duties[3 - var1_137] = nil
	elseif var0_137 == 2 then
		if arg0_137.duties[1] then
			local var2_137 = arg0_137.duties[1]
			local var3_137 = var2_137 < 3 and 3 - var2_137 or 7 - var2_137

			arg0_137.duties[2] = var3_137
		elseif arg0_137.duties[2] then
			local var4_137 = arg0_137.duties[2]
			local var5_137 = var4_137 < 3 and 3 - var4_137 or 7 - var4_137

			arg0_137.duties[1] = var5_137
		else
			arg0_137.duties[1] = ChapterFleet.DUTY_CLEANPATH
			arg0_137.duties[2] = ChapterFleet.DUTY_KILLBOSS
		end
	end

	if var1_137 ~= 0 then
		local var6_137 = "lastFleetDuty_" .. (arg0_137.chapter.id or 0)
		local var7_137 = 0
		local var8_137 = 8

		for iter1_137, iter2_137 in ipairs({
			var1_137,
			arg0_137.duties[var1_137]
		}) do
			var7_137 = var7_137 + bit.lshift(iter2_137, var8_137 * (iter1_137 - 1))
		end

		PlayerPrefs.SetInt(var6_137, var7_137)
		PlayerPrefs.Save()
	end
end

function var0_0.RefreshDutyBar(arg0_138)
	arg0_138:UpdateDuties()
	arg0_138:UpdateDutyBar()
end

function var0_0.UpdateDutyBar(arg0_139)
	local var0_139 = arg0_139.contextData.tabIndex == var0_0.TabIndex.Duty

	for iter0_139 = 1, 2 do
		local var1_139 = arg0_139._tf:Find(string.format("panel/ShipList/fleet/%d/DutySelect", iter0_139))

		setActive(var1_139, var0_139 and arg0_139.duties[iter0_139] ~= nil)
	end

	local var2_139 = arg0_139._tf:Find("panel/ShipList/sub/1/DutySelect")

	setActive(var2_139, var0_139 and not arg0_139:IsListOfFleetEmpty(3))

	if not var0_139 then
		return
	end

	for iter1_139, iter2_139 in pairs(arg0_139.duties) do
		for iter3_139 = 1, 4 do
			setActive(arg0_139.dutyItems[iter1_139][iter3_139]:Find("Checkmark"), iter3_139 == iter2_139)
		end
	end

	local var3_139 = ys.Battle.BattleState.IsAutoSubActive()

	for iter4_139 = 1, 2 do
		local var4_139 = arg0_139.dutyItems[3][iter4_139]

		setActive(var4_139:Find("Checkmark"), iter4_139 == 1 == var3_139)
	end
end

function var0_0.GetOrderedDuties(arg0_140)
	if not arg0_140.duties then
		return
	end

	arg0_140:UpdateDuties()

	local var0_140 = {}
	local var1_140 = 1

	for iter0_140 = 1, 2 do
		if arg0_140.duties[iter0_140] then
			var0_140[var1_140] = arg0_140.duties[iter0_140]
			var1_140 = var1_140 + 1
		end
	end

	return var0_140
end

function var0_0.SetAutoSub(arg0_141, arg1_141)
	arg1_141 = tobool(arg1_141)

	if arg1_141 == ys.Battle.BattleState.IsAutoSubActive() then
		return
	end

	if not AutoBotCommand.autoBotSatisfied() then
		return
	end

	pg.m02:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = not arg1_141
	})
	arg0_141:UpdateDutyBar()
end

function var0_0.GetValidFleets(arg0_142, arg1_142)
	if arg0_142.mode == var2_0.SELECT then
		local var0_142 = {}
		local var1_142 = arg1_142 and {
			arg1_142
		} or {
			FleetType.Normal,
			FleetType.Submarine
		}

		for iter0_142, iter1_142 in ipairs(var1_142) do
			local var2_142 = arg0_142.selectIds[iter1_142]

			for iter2_142, iter3_142 in ipairs(var2_142) do
				if iter3_142 > 0 then
					table.insert(var0_142, arg0_142.fleets[iter3_142])
				end
			end
		end

		return var0_142
	elseif arg0_142.mode == var2_0.EDIT then
		local var3_142 = {}
		local var4_142
		local var5_142

		if arg1_142 == FleetType.Normal then
			var4_142 = 1
			var5_142 = 2
		elseif arg1_142 == FleetType.Submarine then
			var4_142 = 3
			var5_142 = 3
		elseif not arg1_142 then
			var4_142 = 1
			var5_142 = 3
		end

		for iter4_142 = var4_142, var5_142 do
			local var6_142 = arg0_142.eliteFleetList[iter4_142]

			if #var6_142 > 0 then
				local var7_142 = {}

				for iter5_142, iter6_142 in pairs(arg0_142.eliteCommanderList[iter4_142]) do
					table.insert(var7_142, {
						pos = iter5_142,
						id = iter6_142
					})
				end

				local var8_142 = TypedFleet.New({
					ship_list = var6_142,
					commanders = var7_142,
					fleetType = FleetType.Normal
				})

				table.insert(var3_142, var8_142)
			end
		end

		return var3_142
	end
end

function var0_0.IsListOfFleetEmpty(arg0_143, arg1_143)
	if arg1_143 > 0 and arg1_143 < 3 and arg1_143 > arg0_143:getLimitNums(FleetType.Normal) then
		return true
	elseif arg1_143 == 3 and arg1_143 - 2 > arg0_143:getLimitNums(FleetType.Submarine) then
		return true
	end

	if arg0_143.mode == var2_0.SELECT then
		local var0_143

		if arg1_143 > 0 and arg1_143 < 3 then
			var0_143 = arg0_143.selectIds[FleetType.Normal][arg1_143] or 0
		elseif arg1_143 == 3 then
			var0_143 = arg0_143.selectIds[FleetType.Submarine][arg1_143 - 2] or 0
		end

		return var0_143 == 0
	elseif arg0_143.mode == var2_0.EDIT then
		return #arg0_143.eliteFleetList[arg1_143] == 0
	end
end

function var0_0.GetListFleets(arg0_144)
	local var0_144 = {}
	local var1_144 = arg0_144:getLimitNums(FleetType.Normal)
	local var2_144 = arg0_144:getLimitNums(FleetType.Submarine)

	if arg0_144.mode == var2_0.SELECT then
		local var3_144 = arg0_144.selectIds[FleetType.Normal]

		for iter0_144 = 1, var1_144 do
			local var4_144 = var3_144[iter0_144] or 0

			var0_144[iter0_144] = var4_144 > 0 and arg0_144.fleets[var4_144] or nil
		end

		local var5_144 = arg0_144.selectIds[FleetType.Submarine]

		for iter1_144 = 1, var2_144 do
			local var6_144 = var5_144[iter1_144] or 0

			var0_144[iter1_144 + var1_144] = var6_144 > 0 and arg0_144.fleets[var6_144] or nil
		end
	elseif arg0_144.mode == var2_0.EDIT then
		local var7_144 = {}

		for iter2_144 = 1, var1_144 do
			table.insert(var7_144, iter2_144)
		end

		for iter3_144 = 1, var2_144 do
			table.insert(var7_144, iter3_144 + 2)
		end

		for iter4_144 = 1, #var7_144 do
			local var8_144 = var7_144[iter4_144]
			local var9_144
			local var10_144 = arg0_144.eliteFleetList[var8_144]

			if #var10_144 > 0 then
				local var11_144 = var8_144 > 2 and FleetType.Submarine or FleetType.Normal
				local var12_144 = {}

				for iter5_144, iter6_144 in pairs(arg0_144.eliteCommanderList[var8_144]) do
					table.insert(var12_144, {
						pos = iter5_144,
						id = iter6_144
					})
				end

				var9_144 = TypedFleet.New({
					ship_list = var10_144,
					commanders = var12_144,
					fleetType = var11_144
				})
			end

			var0_144[iter4_144] = var9_144
		end
	end

	return var0_144
end

function var0_0.IsSelectMode(arg0_145)
	return arg0_145.mode == var2_0.SELECT
end

function var0_0.SwitchDisplayMode(arg0_146)
	local var0_146 = arg0_146.displayMode == var3_0.ADDITION_SUPPORT

	setActive(arg0_146:findTF("panel/ShipList/Line"), not var0_146)
	setActive(arg0_146:findTF("panel/ShipList/support"), var0_146)

	local var1_146 = arg0_146:findTF("panel/ShipList"):GetComponent(typeof(VerticalLayoutGroup))
	local var2_146 = var1_146.padding

	var2_146.top = var0_146 and 9 or 20
	var2_146.bottom = var0_146 and 14 or 25
	var1_146.padding = var2_146
	var1_146.spacing = var0_146 and 13 or 20
end

function var0_0.sortTeamLimitation(arg0_147)
	arg0_147 = Clone(arg0_147)

	table.sort(arg0_147, function(arg0_148, arg1_148)
		local var0_148 = type(arg0_148)
		local var1_148 = type(arg1_148)

		if var0_148 == var1_148 then
			return var1_148 < var0_148
		elseif arg1_148 == 0 or var1_148 == "string" and arg0_148 ~= 0 then
			return true
		else
			return false
		end
	end)

	return arg0_147
end

return var0_0
