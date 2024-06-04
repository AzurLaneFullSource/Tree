local var0 = class("LevelFleetView", import("..base.BaseSubView"))
local var1 = {
	vanguard = 1,
	submarine = 3,
	main = 2
}

var0.TabIndex = {
	Duty = 3,
	Commander = 2,
	Formation = 1,
	Adjustment = 4
}

local var2 = {
	SELECT = 1,
	EDIT = 2
}
local var3 = {
	NORMAL = 1,
	ADDITION_SUPPORT = 2
}

function var0.getUIName(arg0)
	return "LevelFleetSelectView"
end

function var0.OnInit(arg0)
	arg0:InitUI()
	arg0:bind(LevelUIConst.CONTINUOUS_OPERATION, function(arg0, arg1)
		local var0 = arg1.battleTimes

		getProxy(ChapterProxy):InitContinuousTime(SYSTEM_SCENARIO, var0)
		LoadContextCommand.RemoveLayerByMediator(LevelContinuousOperationWindowMediator)

		local var1 = "chapter_autofight_flag_" .. arg0.chapter.id

		PlayerPrefs.SetInt(var1, 1)
		triggerButton(arg0.btnGo)
	end)
	arg0:bind(LevelMediator2.ON_SPITEM_CHANGED, function(arg0, arg1)
		setActive(arg0.spCheckMark, not arg1)
		triggerButton(arg0.btnSp)
	end)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

function var0.Show(arg0)
	local var0 = arg0.chapter:getConfig("special_operation_list")
	local var1 = arg0.chapter:GetDailyBonusQuota()

	arg0:initSPOPView()

	if type(var0) == "table" and #var0 > 0 and not var1 then
		setActive(arg0.btnSp, true)
	else
		setActive(arg0.btnSp, false)
	end

	setActive(arg0._tf, true)

	local var2 = {
		arg0.formationToggle,
		arg0.commanderToggle,
		arg0.dutyToggle,
		arg0.adjustmentToggle
	}
	local var3 = var2[arg0.contextData.tabIndex or var0.TabIndex.Formation]

	if not isActive(var3) then
		var3 = var2[var0.TabIndex.Formation]
	end

	for iter0, iter1 in ipairs(var2) do
		if isActive(iter1) then
			triggerToggle(iter1, iter1 == var3)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:TryPlaySupportGuide()
	arg0:CheckGuideElement()
end

function var0.CheckGuideElement(arg0)
	if not IsUnityEditor then
		return
	end

	local var0 = {
		"panel/Fixed/start_button",
		"panel/ShipList/support/1/support"
	}

	_.each(var0, function(arg0)
		local var0 = arg0._tf:Find(arg0)

		assert(var0, "Missing Guide Need GameObject Path: " .. arg0)
	end)
end

function var0.TryPlaySupportGuide(arg0)
	if arg0:getLimitNums(FleetType.Support) == 0 then
		return
	end

	if not pg.NewStoryMgr.GetInstance():IsPlayed("NG0041") then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0041")
	end
end

function var0.Hide(arg0)
	setActive(arg0.dropDown, false)
	setActive(arg0.btnSp, false)
	setActive(arg0._tf, false)

	arg0.spItemID = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.setOpenCommanderTag(arg0, arg1)
	arg0.openedCommanerSystem = arg1
end

function var0.SetDutyTabEnabled(arg0, arg1)
	arg0.dutyTabEnabled = arg1
end

function var0.onConfirm(arg0)
	local var0 = arg0.chapter
	local var1 = arg0:getSelectIds()
	local var2 = var0:getNpcShipByType(2)

	if #var2 > 0 then
		local var3 = {
			[TeamType.Vanguard] = #arg0:getFleetById(var1[1]):getTeamByName(TeamType.Vanguard),
			[TeamType.Main] = #arg0:getFleetById(var1[1]):getTeamByName(TeamType.Main)
		}
		local var4 = {
			[TeamType.Vanguard] = 0,
			[TeamType.Main] = 0
		}
		local var5

		for iter0, iter1 in ipairs(var2) do
			var5 = iter1

			local var6 = iter1:getTeamType()

			var4[var6] = var4[var6] + 1

			if var3[var6] + var4[var6] > 3 then
				break
			end
		end

		for iter2, iter3 in pairs(var3) do
			if iter3 + var4[iter2] > 3 then
				arg0:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
					modal = true,
					hideNo = true,
					content = i18n("chapter_tip_with_npc", var5.name)
				})

				return
			end
		end
	end

	local var7 = "chapter_autofight_flag_" .. var0.id
	local var8
	local var9

	seriesAsync({
		function(arg0)
			local var0 = PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1

			if not (PlayerPrefs.GetInt(var7, 1) == 1) or var0 or not arg0:getSPItem() then
				return arg0()
			end

			PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
			PlayerPrefs.Save()

			local function var1()
				arg0:clearSPBuff()
			end

			arg0:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
				hideNo = true,
				content = i18n("autofight_special_operation_tip"),
				onYes = var1,
				onNo = var1
			})
		end,
		function(arg0)
			var9 = var0:GetActiveSPItemID()
			var8 = var0:isLoop() and arg0:GetOrderedDuties() or nil

			arg0:onCancel()
			arg0()
		end,
		function(arg0)
			getProxy(ChapterProxy):SetLastFleetIndex(var1)

			local var0 = PlayerPrefs.GetInt(var7, 1) == 1
			local var1 = LevelMediator2.ON_TRACKING
			local var2 = packEx(var0.id, var0.loopFlag, var9, var8, var0)

			if pg.m02:retrieveMediator(LevelMediator2.__cname) then
				pg.m02:sendNotification(var1, var2)

				return
			end

			local var3 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var3 then
				var3:extendData({
					ToTrackingData = {
						var1,
						var2
					}
				})
			end
		end
	})
end

function var0.onCancel(arg0)
	arg0:clear()
	arg0:emit(LevelUIConst.HIDE_FLEET_SELECT)
end

function var0.InitUI(arg0)
	arg0.tfShipTpl = arg0:findTF("panel/Fixed/shiptpl")
	arg0.tfEmptyTpl = arg0:findTF("panel/Fixed/emptytpl")
	arg0.tfFleets = {
		[FleetType.Normal] = {
			arg0:findTF("panel/ShipList/fleet/1"),
			arg0:findTF("panel/ShipList/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0:findTF("panel/ShipList/sub/1")
		},
		[FleetType.Support] = {
			arg0:findTF("panel/ShipList/support/1")
		}
	}

	local var0 = arg0:findTF("panel/Fixed/RightTabs")
	local var1 = PLATFORM_CODE == PLATFORM_US and arg0:findTF("panel/Fixed/RightTabs/hTplBtn") or arg0:findTF("panel/Fixed/RightTabs/vTplBtn")
	local var2 = {
		"formation_btn",
		"commander_btn",
		"duty_btn",
		"adjustment_btn"
	}

	for iter0 = 1, #var2 do
		local var3 = Instantiate(var1)

		var3.name = var2[iter0]

		SetParent(tf(var3), var0)
		setActive(var3, false)
	end

	arg0.tfLimit = arg0:findTF("panel/Fixed/limit_list/limit")
	arg0.tfLimitTips = arg0:findTF("panel/Fixed/limit_list/limit_tip")
	arg0.tfLimitElite = arg0:findTF("panel/Fixed/limit_list/limit_elite")
	arg0.tfLimitSubTip = arg0:findTF("panel/Fixed/limit_list/limit_sub_tip")
	arg0.tfLimitContainer = arg0:findTF("panel/Fixed/limit_list/limit_elite/limit_list")
	arg0.rtCostLimit = arg0._tf:Find("panel/Fixed/limit_list/cost_limit")
	arg0.btnBack = arg0:findTF("panel/Fixed/btnBack")
	arg0.btnGo = arg0:findTF("panel/Fixed/start_button")
	arg0.btnMultiple = arg0:findTF("panel/Fixed/multiple")
	arg0.formationToggle = arg0:findTF("panel/Fixed/RightTabs/formation_btn")
	arg0.commanderToggle = arg0:findTF("panel/Fixed/RightTabs/commander_btn")
	arg0.dutyToggle = arg0:findTF("panel/Fixed/RightTabs/duty_btn")
	arg0.adjustmentToggle = arg0:findTF("panel/Fixed/RightTabs/adjustment_btn")
	arg0.toggleMask = arg0:findTF("mask")
	arg0.toggleList = arg0:findTF("mask/list")
	arg0.toggles = {}

	setText(findTF(arg0.tfLimit, "text"), i18n("level_fleet_ship_desc"))
	setText(findTF(arg0.tfLimit, "text_sub"), i18n("level_fleet_sub_desc"))

	for iter1 = 0, arg0.toggleList.childCount - 1 do
		table.insert(arg0.toggles, arg0.toggleList:Find("item" .. iter1 + 1))
	end

	arg0.btnSp = arg0:findTF("panel/Fixed/sp")
	arg0.spMask = arg0:findTF("mask_sp")
	arg0.dutyItems = {}

	for iter2 = 1, 2 do
		local var4 = arg0._tf:Find(string.format("panel/ShipList/fleet/%d/DutySelect", iter2))

		arg0.dutyItems[iter2] = {}

		for iter3 = 1, 4 do
			local var5 = var4:Find("Item" .. iter3)

			arg0.dutyItems[iter2][iter3] = var5

			setText(var5:Find("Text"), i18n("autofight_function" .. iter3))
		end
	end

	local var6 = arg0._tf:Find("panel/ShipList/sub/1/DutySelect")

	arg0.dutyItems[3] = {}

	for iter4 = 1, 2 do
		local var7 = var6:Find("Item" .. iter4)

		arg0.dutyItems[3][iter4] = var7

		setText(var7:Find("Text"), i18n("autofight_function" .. 6 - iter4))
	end

	setActive(arg0.tfShipTpl, false)
	setActive(arg0.tfEmptyTpl, false)
	setActive(arg0.toggleMask, false)
	setActive(arg0.btnSp, false)
	setActive(arg0.spMask, false)
	setText(arg0:findTF("panel/Fixed/RightTabs/formation_btn/text"), i18n("autofight_formation"))
	setText(arg0:findTF("panel/Fixed/RightTabs/commander_btn/text"), i18n("autofight_cat"))
	setText(arg0:findTF("panel/Fixed/RightTabs/duty_btn/text"), i18n("autofight_function"))
	setText(arg0.adjustmentToggle:Find("text"), i18n("word_adjustFleet"))

	arg0.dropDown = arg0._tf:Find("panel/FixedTop/Dropdown")

	setActive(arg0.dropDown, false)

	arg0.dropDownSide = arg0._tf:Find("panel/Fixed/title/DropSide")

	onButton(arg0, arg0.dropDownSide:Find("Click"), function()
		local var0 = isActive(arg0.dropDown)

		setActive(arg0.dropDown, not var0)
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.dropDown, function()
		local var0 = isActive(arg0.dropDown)

		setActive(arg0.dropDown, not var0)
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.dropDownSide:Find("Layout/Item3"), function()
		arg0:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	assert(OPEN_AIR_DOMINANCE, "Not Prepare for BANNED OPEN_AIR_DOMINANCE")

	arg0.btnASHelp = arg0.dropDownSide:Find("help")

	setText(arg0.dropDownSide:Find("Layout/Item1/Text"), i18n("word_investigate"))
	setText(arg0.dropDownSide:Find("Layout/Item2/Text"), i18n("word_attr_ac"))
	setText(arg0.dropDownSide:Find("Layout/Item3/Text"), i18n("fleet_antisub_range"))
	setText(arg0.dropDown:Find("Investigation/Text"), i18n("level_scene_title_word_1"))
	setText(arg0.dropDown:Find("Airsupport/Text"), i18n("level_scene_title_word_3"))

	arg0.supportFleetHelp = arg0._tf:Find("panel/Fixed/title/Image/Help")

	onButton(arg0, arg0.supportFleetHelp, function()
		arg0:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_supportfleet.tip
		})
	end, SFX_PANEL)

	for iter5 = 1, 2 do
		for iter6 = 1, 4 do
			local var8 = arg0.dutyItems[iter5][iter6]

			onButton(arg0, var8, function()
				arg0:SetDuty(iter5, iter6)
			end)
		end
	end

	for iter7 = 1, 2 do
		local var9 = arg0.dutyItems[3][iter7]

		onButton(arg0, var9, function()
			arg0:SetAutoSub(iter7 == 1)
		end)
	end
end

function var0.onCancelSupport(arg0, arg1)
	if arg1 then
		arg0:emit(LevelMediator2.ON_UPDATE_CUSTOM_FLEET, arg0.chapter)
	end
end

function var0.set(arg0, arg1, arg2, arg3)
	arg0.chapter = arg1
	arg0.mode = var2.SELECT
	arg0.selects = arg3
	arg0.chapterASValue = arg0.chapter:getConfig("air_dominance")
	arg0.suggestionValue = arg0.chapter:getConfig("best_air_dominance")

	arg0:SetDutyTabEnabled(arg1:isLoop())

	arg0.supportFleet = arg0.chapter:getSupportFleet()

	local var0 = arg0:getLimitNums(FleetType.Support) > 0

	setActive(arg0.supportFleetHelp, var0)

	arg0.displayMode = var0 and var3.ADDITION_SUPPORT or var3.NORMAL

	arg0:SwitchDisplayMode()

	arg0.fleets = _(_.values(arg2)):chain():filter(function(arg0)
		return arg0:isRegularFleet()
	end):sort(function(arg0, arg1)
		return arg0.id < arg1.id
	end):value()
	arg0.selectIds = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0, iter1 in ipairs(arg3 or {}) do
		local var1 = arg0:getFleetById(iter1)

		if var1 then
			local var2 = var1:getFleetType()
			local var3 = arg0.selectIds[var2]

			if #var3 < arg0:getLimitNums(var2) then
				table.insert(var3, iter1)
			end
		end
	end

	arg0.duties = {}

	local var4 = PlayerPrefs.GetInt("lastFleetDuty_" .. (arg0.chapter.id or 0), 0)

	if var4 > 0 then
		local var5 = bit.band(var4, 255)
		local var6 = bit.rshift(var4, 8)
		local var7 = bit.band(var6, 255)

		if var5 > 0 and var7 > 0 then
			arg0.duties[var5] = var7
		end
	end

	setActive(arg0.tfLimitElite, false)
	setActive(arg0.tfLimitSubTip, false)
	setActive(arg0.tfLimitTips, false)
	setActive(arg0.tfLimit, true)

	local var8 = arg0.chapter:isLoop() and arg0.chapter:getConfig("use_oil_limit") or {}

	setActive(arg0.rtCostLimit, #var8 > 0)
	setText(arg0.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip"))

	if #var8 > 0 then
		setActive(arg0.rtCostLimit:Find("cost_noraml"), var8[1] > 0)
		setText(arg0.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_enemy"), var8[1]))
		setActive(arg0.rtCostLimit:Find("cost_boss"), var8[2] > 0)
		setText(arg0.rtCostLimit:Find("cost_boss/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_flagship"), var8[2]))
		setActive(arg0.rtCostLimit:Find("cost_sub"), var8[3] > 0)
		setText(arg0.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var8[3]))
	end

	onButton(arg0, arg0.btnGo, function()
		local function var0()
			arg0:onConfirm()
		end

		local var1 = arg0:getSPItem()

		if var1 and var1 ~= 0 then
			if PlayerPrefs.GetInt("SPOPItemReminder") ~= 1 then
				local var2 = Item.getConfigData(var1).name
				local var3 = pg.benefit_buff_template[Chapter.GetSPBuffByItem(var1)].desc
				local var4 = i18n("levelScene_select_SP_OP_reminder", var2, var3)

				local function var5()
					PlayerPrefs.SetInt("SPOPItemReminder", 1)
					PlayerPrefs.Save()
					var0()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = {
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var1
					},
					intro = var4,
					onYes = var5,
					weight = LayerWeightConst.TOP_LAYER
				})
			else
				var0()
			end
		else
			var0()
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	setActive(arg0.btnMultiple, AutoBotCommand.autoBotSatisfied() and arg0.chapter:isLoop())
	onButton(arg0, arg0.btnMultiple, function()
		local var0 = arg0:getSelectIds()
		local var1 = arg0:getSPItem()
		local var2 = arg0:GetOrderedDuties()

		arg0:emit(LevelUIConst.OPEN_NORMAL_CONTINUOUS_WINDOW, arg0.chapter, var0, var1, var2)
	end, SFX_PANEL)
	onButton(arg0, arg0.btnASHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.btnBack, function()
		arg0:onCancel()
		arg0:onCancelSupport(true)
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:onCancel()
		arg0:onCancelSupport(true)
	end, SFX_CANCEL)
	onButton(arg0, arg0.toggleMask, function()
		arg0:hideToggleMask()
	end, SFX_CANCEL)
	onToggle(arg0, arg0.formationToggle, function(arg0)
		if arg0 then
			arg0.contextData.tabIndex = var0.TabIndex.Formation

			arg0:updateFleets()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.commanderToggle, function(arg0)
		if arg0 then
			arg0.contextData.tabIndex = var0.TabIndex.Commander

			arg0:updateFleets()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.dutyToggle, function(arg0)
		if arg0 then
			arg0.contextData.tabIndex = var0.TabIndex.Duty

			arg0:updateFleets()
		end
	end, SFX_PANEL)
	setActive(arg0.formationToggle, true)
	setActive(arg0.commanderToggle, arg0.openedCommanerSystem)
	setActive(arg0.dutyToggle, arg0.dutyTabEnabled)
	setActive(arg0.adjustmentToggle, false)
	arg0:clearFleets()
	arg0:updateFleets()
	arg0:updateLimit()
	arg0:updateASValue()
	arg0:UpdateSonarRange()
	arg0:UpdateInvestigation()
end

function var0.getFleetById(arg0, arg1)
	return _.detect(arg0.fleets, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.getLimitNums(arg0, arg1)
	local var0 = 0

	if arg1 == FleetType.Normal then
		var0 = arg0.chapter:getConfig("group_num")
	elseif arg1 == FleetType.Submarine then
		var0 = arg0.chapter:getConfig("submarine_num")
	elseif arg1 == FleetType.Support then
		var0 = arg0.chapter:getConfig("support_group_num")
	end

	return var0
end

function var0.getSelectIds(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs({
		FleetType.Normal,
		FleetType.Submarine
	}) do
		local var1 = arg0.selectIds[iter1]

		for iter2, iter3 in ipairs(var1) do
			if iter3 > 0 then
				table.insert(var0, iter3)
			end
		end
	end

	return var0
end

function var0.updateFleets(arg0)
	for iter0, iter1 in pairs(arg0.tfFleets) do
		for iter2 = 1, #iter1 do
			if iter0 ~= FleetType.Support then
				arg0:updateFleet(iter0, iter2)
			else
				arg0:UpdateEliteFleet(iter0, iter2)
			end
		end
	end

	arg0:RefreshDutyBar()
end

function var0.updateLimit(arg0)
	local var0 = #_.filter(arg0.selectIds[FleetType.Normal], function(arg0)
		return arg0 > 0
	end)
	local var1 = #_.filter(arg0.selectIds[FleetType.Submarine], function(arg0)
		return arg0 > 0
	end)
	local var2 = arg0:getLimitNums(FleetType.Normal)

	setText(arg0.tfLimit:Find("number"), string.format("%d/%d", var0, var2))

	local var3 = arg0:getLimitNums(FleetType.Submarine)

	setText(arg0.tfLimit:Find("number_sub"), string.format("%d/%d", var1, var3))
end

function var0.selectFleet(arg0, arg1, arg2, arg3)
	local var0 = arg0.selectIds[arg1]

	if arg3 > 0 and table.contains(var0, arg3) then
		return
	end

	if arg1 == FleetType.Normal and arg0:getLimitNums(arg1) > 0 and arg3 == 0 and #_.filter(var0, function(arg0)
		return arg0 > 0
	end) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_lease_one_ship"))

		return
	end

	local var1 = arg0:getFleetById(arg3)

	if var1 then
		if not var1:isUnlock() then
			return
		end

		if var1:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_not_enough"))

			return
		end
	end

	local var2 = {
		not arg0:IsListOfFleetEmpty(1) or nil,
		not arg0:IsListOfFleetEmpty(2) or nil
	}
	local var3 = var0[arg2]

	var0[arg2] = arg3

	arg0:updateFleet(arg1, arg2)
	arg0:updateLimit()
	arg0:updateASValue()
	arg0:UpdateSonarRange()
	arg0:RefreshDutyBar()

	local var4 = {
		not arg0:IsListOfFleetEmpty(1) or nil,
		not arg0:IsListOfFleetEmpty(2) or nil
	}

	if arg0.dutyTabEnabled and table.getCount(var2) == 2 and table.getCount(var4) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_change_tip"))
	end

	arg0:UpdateInvestigation()
end

function var0.updateFleet(arg0, arg1, arg2)
	local var0 = arg0.contextData.tabIndex == var0.TabIndex.Formation
	local var1 = arg0.contextData.tabIndex == var0.TabIndex.Commander
	local var2 = arg0.contextData.tabIndex == var0.TabIndex.Duty
	local var3 = arg0.contextData.tabIndex == var0.TabIndex.Adjustment
	local var4 = arg0.selectIds[arg1][arg2]
	local var5 = arg0:getFleetById(var4)
	local var6 = arg2 <= arg0:getLimitNums(arg1)
	local var7 = arg0.tfFleets[arg1][arg2]
	local var8 = findTF(var7, "bg/name")
	local var9 = arg0:findTF("btn_select", var7)
	local var10 = arg0:findTF("btn_recom", var7)
	local var11 = arg0:findTF("btn_clear", var7)
	local var12 = arg0:findTF("blank", var7)
	local var13 = arg0:findTF("selected", var7)
	local var14 = arg0:findTF("commander", var7)
	local var15 = var7:Find("adjustment_flag")

	setActive(var10, false)
	setActive(var13, false)
	setText(var8, "")

	local var16 = arg0:findTF(TeamType.Main, var7)
	local var17 = arg0:findTF(TeamType.Vanguard, var7)
	local var18 = arg0:findTF(TeamType.Submarine, var7)

	if not var6 then
		setActive(var11, false)
		setActive(var9, false)
		setActive(var14, false)
		setActive(var15, false)
		setActive(var12, true)

		if arg1 == FleetType.Submarine then
			setActive(var18, false)
		else
			setActive(var16, false)
			setActive(var17, false)
		end

		return
	end

	setActive(var11, var0)
	setActive(var9, var0)
	setActive(var14, var1 and var5)
	setActive(var15, var3)
	setActive(var12, var2 or var3 or var1 and not var5)
	setText(var8, var5 and var5:GetName() or "")

	if arg1 == FleetType.Submarine then
		setActive(var18, var5)
	else
		setActive(var16, var5)
		setActive(var17, var5)
	end

	if var5 then
		if arg1 == FleetType.Submarine then
			arg0:updateShips(var18, var5.subShips)
		else
			arg0:updateShips(var16, var5.mainShips)
			arg0:updateShips(var17, var5.vanguardShips)
		end

		arg0:updateCommanders(var14, var5)
	end

	onButton(arg0, var9, function()
		arg0.toggleList.position = (var9.position + var11.position) / 2
		arg0.toggleList.anchoredPosition = arg0.toggleList.anchoredPosition + Vector2(-arg0.toggleList.rect.width / 2, -var9.rect.height / 2)

		arg0:showToggleMask(arg1, function(arg0)
			arg0:hideToggleMask()
			arg0:selectFleet(arg1, arg2, arg0)
		end)
	end, SFX_UI_CLICK)
	onButton(arg0, var11, function()
		arg0:selectFleet(arg1, arg2, 0)
	end, SFX_UI_CLICK)
end

function var0.updateCommanders(arg0, arg1, arg2)
	for iter0 = 1, 2 do
		local var0 = arg2:getCommanderByPos(iter0)
		local var1 = arg1:Find("pos" .. iter0)
		local var2 = var1:Find("add")
		local var3 = var1:Find("info")

		setActive(var2, not var0)
		setActive(var3, var0)

		if var0 then
			local var4 = Commander.rarity2Frame(var0:getRarity())

			setImageSprite(var3:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var4))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var0:getPainting(), "", var3:Find("mask/icon"))
		end

		onButton(arg0, var2, function()
			arg0:emit(LevelUIConst.OPEN_COMMANDER_PANEL, arg2, arg0.chapter)
		end, SFX_PANEL)
		onButton(arg0, var3, function()
			arg0:emit(LevelUIConst.OPEN_COMMANDER_PANEL, arg2, arg0.chapter)
		end, SFX_PANEL)
	end
end

function var0.updateShips(arg0, arg1, arg2)
	local var0 = UIItemList.New(arg1, arg0.tfShipTpl)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = getProxy(BayProxy):getShipById(arg2[arg1 + 1])

			updateShip(arg2, var0)
			setActive(findTF(arg2, "ship_type"), false)

			local var1 = arg2:Find("icon_bg/energy")
			local var2 = var0:getEnergeConfig()

			if var2 and var2.id <= 2 then
				setActive(var1, true)
				GetImageSpriteFromAtlasAsync("energy", var2.icon, var1)
			else
				setActive(var1, false)
			end
		end
	end)
	var0:align(#arg2)

	for iter0, iter1 in ipairs(arg2) do
		local var1 = arg1:GetChild(iter0 - 1)
		local var2 = GetOrAddComponent(var1, "UILongPressTrigger").onLongPressed

		pg.DelegateInfo.Add(arg0, var2)
		var2:RemoveAllListeners()
		var2:AddListener(function()
			arg0:emit(LevelMediator2.ON_SHIP_DETAIL, {
				id = iter1,
				chapter = arg0.chapter
			})
		end)
	end
end

function var0.showToggleMask(arg0, arg1, arg2)
	setActive(arg0.toggleMask, true)

	local var0 = _.filter(arg0.fleets, function(arg0)
		return arg0:getFleetType() == arg1
	end)

	for iter0, iter1 in ipairs(arg0.toggles) do
		local var1 = var0[iter0]

		setActive(iter1, var1)

		if var1 then
			local var2 = iter1:GetComponent(typeof(Toggle))
			local var3 = iter1:Find("lock")
			local var4, var5 = var1:isUnlock()

			setToggleEnabled(iter1, var4)
			setActive(var3, not var4)

			local var6 = table.contains(arg0.selectIds[arg1], var1.id)

			setActive(iter1:Find("on"), var6)
			setActive(iter1:Find("off"), not var6)

			if var4 then
				var2.isOn = false

				onToggle(arg0, iter1, function(arg0)
					if arg0 then
						setActive(arg0.toggleMask, false)
						arg2(var1.id)
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0, var3, function()
					pg.TipsMgr.GetInstance():ShowTips(var5)
				end, SFX_UI_CLICK)
			end
		end
	end
end

function var0.hideToggleMask(arg0)
	setActive(arg0.toggleMask, false)
end

function var0.clearFleets(arg0)
	for iter0, iter1 in pairs(arg0.tfFleets) do
		_.each(iter1, function(arg0)
			arg0:clearFleet(arg0)
		end)
	end
end

function var0.UpdateInvestigation(arg0)
	if not arg0.chapter:existAmbush() then
		arg0:UpdateLoopInvestigation()

		return
	end

	local var0 = 0

	for iter0 = 1, 2 do
		local var1 = arg0.selectIds[FleetType.Normal][iter0] or 0
		local var2 = arg0:getFleetById(var1)
		local var3 = var2 and math.floor(var2:getInvestSums(true)) or 0

		var0 = math.max(var0, var3)
	end

	local var4 = arg0.chapter:getConfig("avoid_require")

	arg0:UpdateInvestigationComparision(var0, var4)
end

function var0.UpdateEliteInvestigation(arg0)
	if not arg0.chapter:existAmbush() then
		arg0:UpdateLoopInvestigation()

		return
	end

	local var0 = 0

	for iter0 = 1, 2 do
		local var1 = arg0.eliteFleetList[iter0]
		local var2 = {}

		for iter1, iter2 in pairs(arg0.eliteCommanderList[iter0]) do
			table.insert(var2, {
				pos = iter1,
				id = iter2
			})
		end

		local var3 = TypedFleet.New({
			ship_list = var1,
			commanders = var2,
			fleetType = FleetType.Normal
		})
		local var4 = var3 and math.floor(var3:getInvestSums()) or 0

		var0 = math.max(var0, var4)
	end

	local var5 = arg0.chapter:getConfig("avoid_require")

	arg0:UpdateInvestigationComparision(var0, var5)
end

function var0.UpdateLoopInvestigation(arg0)
	local var0 = arg0.dropDown:Find("Investigation")

	setText(var0:Find("Value1"), "-")
	setText(var0:Find("Value2"), "-")
	triggerToggle(arg0.dropDownSide:Find("Layout/Item1/Dot"), true)
end

function var0.UpdateInvestigationComparision(arg0, arg1, arg2)
	arg1 = math.floor(arg1)

	local var0 = arg0.dropDown:Find("Investigation")
	local var1 = arg2 <= arg1

	setText(var0:Find("Value1"), setColorStr(arg1, var1 and "#51FF55" or COLOR_WHITE))
	setText(var0:Find("Value2"), arg2)
	triggerToggle(arg0.dropDownSide:Find("Layout/Item1/Dot"), var1)
end

function var0.updateASValue(arg0)
	if arg0.chapterASValue <= 0 then
		arg0:UpdateBannedAS()

		return
	end

	local var0 = 0

	for iter0 = 1, 2 do
		local var1 = arg0.selectIds[FleetType.Normal][iter0] or 0
		local var2 = arg0:getFleetById(var1)

		var0 = var0 + (var2 and var2:getFleetAirDominanceValue() or 0)
	end

	for iter1 = 1, 1 do
		local var3 = arg0.selectIds[FleetType.Submarine][iter1] or 0
		local var4 = arg0:getFleetById(var3)

		var0 = var0 + (var4 and var4:getFleetAirDominanceValue() or 0)
	end

	arg0:UpdateASComparision(var0, arg0.suggestionValue)
end

function var0.updateEliteASValue(arg0)
	if arg0.chapterASValue <= 0 then
		arg0:UpdateBannedAS()

		return
	end

	local var0 = getProxy(BayProxy)
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.eliteFleetList) do
		local var2 = {}

		for iter2, iter3 in pairs(arg0.eliteCommanderList[iter0]) do
			var2[iter2] = getProxy(CommanderProxy):RawGetCommanderById(iter3)
		end

		for iter4, iter5 in ipairs(iter1) do
			var1 = var1 + calcAirDominanceValue(var0:RawGetShipById(iter5), var2)
		end
	end

	arg0:UpdateASComparision(var1, arg0.suggestionValue)
end

function var0.UpdateBannedAS(arg0)
	local var0 = arg0.dropDown:Find("Airsupport")

	setText(var0:Find("Value1"), "-")
	setText(var0:Find("Value2"), "-")
	triggerToggle(arg0.dropDownSide:Find("Layout/Item2/Dot"), true)
end

function var0.UpdateASComparision(arg0, arg1, arg2)
	arg1 = math.floor(arg1)

	local var0 = arg0.dropDown:Find("Airsupport")

	setText(var0:Find("Text"), i18n("level_scene_title_word_3"))

	local var1 = arg2 < arg1

	setText(var0:Find("Value1"), setColorStr(arg1, var1 and "#51FF55" or COLOR_WHITE))
	setText(var0:Find("Value2"), arg2)
	triggerToggle(arg0.dropDownSide:Find("Layout/Item2/Dot"), var1)
end

function var0.UpdateSonarRange(arg0)
	for iter0 = 1, 2 do
		local var0 = arg0.selectIds[FleetType.Normal][iter0] or 0
		local var1 = arg0:getFleetById(var0)
		local var2 = var1 and math.floor(var1:GetFleetSonarRange()) or 0

		arg0:UpdateSonarRangeValues(iter0, var2)
	end
end

function var0.UpdateEliteSonarRange(arg0)
	for iter0 = 1, 2 do
		local var0 = arg0.eliteFleetList[iter0]
		local var1 = {}

		for iter1, iter2 in pairs(arg0.eliteCommanderList[iter0]) do
			table.insert(var1, {
				pos = iter1,
				id = iter2
			})
		end

		local var2 = TypedFleet.New({
			ship_list = var0,
			commanders = var1,
			fleetType = FleetType.Normal
		})
		local var3 = var2 and math.floor(var2:GetFleetSonarRange()) or 0

		arg0:UpdateSonarRangeValues(iter0, var3)
	end
end

function var0.UpdateSonarRangeValues(arg0, arg1, arg2)
	local var0 = arg0.dropDownSide:Find("Layout/Item3/Values")

	setText(var0:GetChild(arg1 - 1), arg2)
end

function var0.clearFleet(arg0, arg1)
	local var0 = arg0:findTF(TeamType.Main, arg1)
	local var1 = arg0:findTF(TeamType.Vanguard, arg1)
	local var2 = arg0:findTF(TeamType.Submarine, arg1)

	if var0 then
		removeAllChildren(var0)
	end

	if var1 then
		removeAllChildren(var1)
	end

	if var2 then
		removeAllChildren(var2)
	end
end

function var0.clear(arg0)
	arg0.contextData.tabIndex = nil
	arg0.duties = nil
end

function var0.onCancelHard(arg0, arg1)
	if arg1 then
		arg0:emit(LevelMediator2.ON_UPDATE_CUSTOM_FLEET, arg0.chapter)
	end

	arg0:emit(LevelUIConst.HIDE_FLEET_EDIT)
end

function var0.setHardShipVOs(arg0, arg1)
	arg0.shipVOs = arg1
end

function var0.setOnHard(arg0, arg1)
	arg0.chapter = arg1
	arg0.mode = var2.EDIT
	arg0.propetyLimitation = arg0.chapter:getConfig("property_limitation")
	arg0.eliteFleetList = arg0.chapter:getEliteFleetList()
	arg0.chapterASValue = arg0.chapter:getConfig("air_dominance")
	arg0.suggestionValue = arg0.chapter:getConfig("best_air_dominance")
	arg0.eliteCommanderList = arg0.chapter:getEliteFleetCommanders()
	arg0.typeLimitations = arg0.chapter:getConfig("limitation")

	arg0:SetDutyTabEnabled(arg1:isLoop())

	local var0 = arg0:getLimitNums(FleetType.Support) > 0

	setActive(arg0.supportFleetHelp, var0)

	arg0.displayMode = var0 and var3.ADDITION_SUPPORT or var3.NORMAL

	arg0:SwitchDisplayMode()

	arg0.duties = {}

	local var1 = PlayerPrefs.GetInt("lastFleetDuty_" .. (arg0.chapter.id or 0), 0)

	if var1 > 0 then
		local var2 = bit.band(var1, 255)
		local var3 = bit.rshift(var1, 8)
		local var4 = bit.band(var3, 255)

		if var2 > 0 and var4 > 0 then
			arg0.duties[var2] = var4
		end
	end

	onButton(arg0, arg0.btnGo, function()
		local var0 = "chapter_autofight_flag_" .. arg0.chapter.id
		local var1 = arg0.chapter
		local var2
		local var3

		seriesAsync({
			function(arg0)
				local var0 = PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1

				if not (PlayerPrefs.GetInt(var0, 1) == 1) or not arg0:getSPItem() or var0 then
					return arg0()
				end

				PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
				PlayerPrefs.Save()

				local function var1()
					arg0:clearSPBuff()
				end

				arg0:emit(LevelUIConst.HANDLE_SHOW_MSG_BOX, {
					hideNo = true,
					content = i18n("autofight_special_operation_tip"),
					onYes = var1,
					onNo = var1
				})
			end,
			function(arg0)
				var2 = arg0.chapter:GetActiveSPItemID()
				var3 = arg0.chapter:isLoop() and arg0:GetOrderedDuties() or nil

				arg0:clear()
				arg0:onCancelHard()
				arg0()
			end,
			function(arg0)
				local var0 = PlayerPrefs.GetInt(var0, 1) == 1
				local var1 = LevelMediator2.ON_ELITE_TRACKING
				local var2 = packEx(var1.id, var1.loopFlag, var2, var3, var0)

				if pg.m02:retrieveMediator(LevelMediator2.__cname) then
					pg.m02:sendNotification(var1, var2)

					return
				end

				local var3 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

				if var3 then
					var3:extendData({
						ToTrackingData = {
							var1,
							var2
						}
					})
				end
			end
		})
	end, SFX_UI_WEIGHANCHOR_GO)
	setActive(arg0.btnMultiple, AutoBotCommand.autoBotSatisfied() and arg0.chapter:isLoop())
	onButton(arg0, arg0.btnMultiple, function()
		local var0 = arg0:getSPItem()
		local var1 = arg0:GetOrderedDuties()

		arg0:emit(LevelUIConst.OPEN_ELITE_CONTINUOUS_WINDOW, arg0.chapter, var0, var1)
	end, SFX_PANEL)
	onButton(arg0, arg0.btnASHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.btnBack, function()
		arg0:clear()
		arg0:onCancelHard(true)
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:clear()
		arg0:onCancelHard(true)
	end, SFX_CANCEL)
	onToggle(arg0, arg0.commanderToggle, function(arg0)
		if arg0 then
			arg0.contextData.tabIndex = var0.TabIndex.Commander

			arg0:flush()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.formationToggle, function(arg0)
		if arg0 then
			arg0.contextData.tabIndex = var0.TabIndex.Formation

			arg0:flush()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.dutyToggle, function(arg0)
		if arg0 then
			arg0.contextData.tabIndex = var0.TabIndex.Duty

			arg0:flush()
		end
	end, SFX_UI_TAG)
	onToggle(arg0, arg0.adjustmentToggle, function(arg0)
		if arg0 then
			arg0.contextData.tabIndex = var0.TabIndex.Adjustment

			arg0:flush()
		end
	end, SFX_PANEL)
	setActive(arg0.formationToggle, true)
	setActive(arg0.commanderToggle, arg0.openedCommanerSystem)
	setActive(arg0.dutyToggle, arg0.dutyTabEnabled)
	setActive(arg0.adjustmentToggle, true)
	arg0:flush()
end

function var0.flush(arg0)
	arg0:updateEliteLimit()
	arg0:updateEliteASValue()

	arg0.lastFleetVaildStatus = arg0.lastFleetVaildStatus or {}

	local var0 = {
		not arg0:IsListOfFleetEmpty(1) or nil,
		not arg0:IsListOfFleetEmpty(2) or nil
	}

	if arg0.dutyTabEnabled and table.getCount(arg0.lastFleetVaildStatus) == 2 and table.getCount(var0) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_change_tip"))
	end

	arg0.lastFleetVaildStatus = var0

	arg0:updateEliteFleets()
	arg0:UpdateEliteSonarRange()
	arg0:UpdateEliteInvestigation()
end

function var0.updateEliteLimit(arg0)
	setActive(arg0.toggleMask, false)
	setActive(arg0.tfLimit, false)
	setActive(arg0.tfLimitTips, #arg0.propetyLimitation == 0)
	setActive(arg0.tfLimitElite, #arg0.propetyLimitation > 0)
	setActive(arg0.tfLimitSubTip, #arg0.propetyLimitation > 0)

	if #arg0.propetyLimitation > 0 then
		local var0, var1 = arg0.chapter:IsPropertyLimitationSatisfy()
		local var2 = UIItemList.New(arg0.tfLimitContainer, arg0.tfLimitContainer:GetChild(0))

		var2:make(function(arg0, arg1, arg2)
			arg1 = arg1 + 1

			if arg0 == UIItemList.EventUpdate then
				local var0 = arg0.propetyLimitation[arg1]
				local var1, var2, var3, var4 = unpack(var0)

				if var0[arg1] == 1 then
					arg0:findTF("Text", arg2):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
				else
					arg0:findTF("Text", arg2):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
				end

				setActive(arg2, true)

				local var5 = (AttributeType.EliteCondition2Name(var1, var4) .. AttributeType.eliteConditionCompareTip(var2) .. var3) .. "（" .. var1[var1] .. "）"

				setText(arg0:findTF("Text", arg2), var5)
			end
		end)
		var2:align(#arg0.propetyLimitation)
		setActive(arg0.tfLimitSubTip, arg0.chapter:getConfig("submarine_num") > 0)
	end

	local var3 = arg0.chapter:isLoop() and arg0.chapter:getConfig("use_oil_limit") or {}

	setActive(arg0.rtCostLimit, #var3 > 0)
	setText(arg0.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip"))

	if #var3 > 0 then
		setActive(arg0.rtCostLimit:Find("cost_noraml"), var3[1] > 0)
		setText(arg0.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_enemy"), var3[1]))
		setActive(arg0.rtCostLimit:Find("cost_boss"), var3[2] > 0)
		setText(arg0.rtCostLimit:Find("cost_boss/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_flagship"), var3[2]))
		setActive(arg0.rtCostLimit:Find("cost_sub"), var3[3] > 0)
		setText(arg0.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var3[3]))
	end
end

function var0.initAddButton(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.eliteFleetList[arg4]
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[arg0.shipVOs[iter1]] = true

		if arg2 == arg0.shipVOs[iter1]:getTeamType() then
			table.insert(var2, iter1)
		end
	end

	local var3 = findTF(arg1, arg2)

	removeAllChildren(var3)

	local var4 = 0
	local var5 = false
	local var6 = 0

	arg3 = var0.sortTeamLimitation(arg3)

	local var7 = var3:GetComponent("ContentSizeFitter")
	local var8 = var3:GetComponent("HorizontalLayoutGroup")

	var7.enabled = true
	var8.enabled = true
	arg0.isDraging = false

	for iter2 = 1, 3 do
		local var9
		local var10
		local var11
		local var12 = var2[iter2] and arg0.shipVOs[var2[iter2]] or nil

		if var12 then
			for iter3, iter4 in ipairs(arg3) do
				if ShipType.ContainInLimitBundle(iter4, var12:getShipType()) then
					var10 = var12
					var11 = iter4

					table.remove(arg3, iter3)

					var5 = var5 or iter4 ~= 0

					break
				end
			end
		else
			var11 = arg3[1]

			table.remove(arg3, 1)
		end

		if var11 == 0 then
			var6 = var6 + 1
		end

		local var13 = var10 and cloneTplTo(arg0.tfShipTpl, var3) or cloneTplTo(arg0.tfEmptyTpl, var3)

		setActive(var13, true)

		if var10 then
			updateShip(var13, var10)
			setActive(arg0:findTF("event_block", var13), var10:getFlag("inEvent"))

			var1[var10] = true
		else
			var4 = var4 + 1
		end

		setActive(arg0:findTF("ship_type", var13), var11 and var11 ~= 0)

		if var11 and var11 ~= 0 then
			if type(var11) == "number" then
				local var14 = GetSpriteFromAtlas("shiptype", ShipType.Type2CNLabel(var11))

				setImageSprite(arg0:findTF("ship_type", var13), var14, true)
			elseif type(var11) == "string" then
				local var15 = GetSpriteFromAtlas("shiptype", ShipType.BundleType2CNLabel(var11))

				setImageSprite(arg0:findTF("ship_type", var13), var15, true)
			end
		end

		local var16 = _.map(var0, function(arg0)
			return arg0.shipVOs[arg0]
		end)

		table.sort(var16, function(arg0, arg1)
			return var1[arg0:getTeamType()] < var1[arg1:getTeamType()] or var1[arg0:getTeamType()] == var1[arg1:getTeamType()] and table.indexof(var0, arg0.id) < table.indexof(var0, arg1.id)
		end)

		local var17 = GetOrAddComponent(var13, typeof(UILongPressTrigger))

		var17.onLongPressed:RemoveAllListeners()

		if var10 and arg0.contextData.tabIndex ~= var0.TabIndex.Adjustment then
			var17.onLongPressed:AddListener(function()
				arg0:onCancelHard(true)
				arg0:emit(LevelMediator2.ON_FLEET_SHIPINFO, {
					shipId = var10.id,
					shipVOs = var16,
					chapter = arg0.chapter
				})
			end)
		end

		local var18 = GetOrAddComponent(var13, "EventTriggerListener")

		var18:RemovePointClickFunc()
		var18:AddPointClickFunc(function(arg0, arg1)
			if arg0 ~= var13.gameObject then
				return
			end

			if arg0.isDraging then
				return
			end

			arg0:onCancelHard()
			arg0:emit(LevelMediator2.ON_ELITE_OEPN_DECK, {
				shipType = var11,
				fleet = var1,
				chapter = arg0.chapter,
				shipVO = var10,
				fleetIndex = arg4,
				teamType = arg2
			})
		end)
		var18:RemoveBeginDragFunc()
		var18:RemoveDragFunc()
		var18:RemoveDragEndFunc()

		if var10 and arg0.contextData.tabIndex == var0.TabIndex.Adjustment then
			local var19 = var13.rect.width * 0.5
			local var20 = {}
			local var21 = {}

			var18:AddBeginDragFunc(function(arg0, arg1)
				if arg0 ~= var13.gameObject then
					return
				end

				if arg0.isDraging then
					return
				end

				arg0.isDraging = true
				var7.enabled = false
				var8.enabled = false

				for iter0 = 1, 3 do
					local var0 = var3:GetChild(iter0 - 1)

					if var13 == var0 then
						arg0.dragIndex = iter0
					end

					var20[iter0] = var0.anchoredPosition
					var21[iter0] = var0
				end
			end)
			var18:AddDragFunc(function(arg0, arg1)
				if arg0 ~= var13.gameObject then
					return
				end

				if not arg0.isDraging then
					return
				end

				local var0 = var13.localPosition

				var0.x = arg0:change2ScrPos(var13.parent, arg1.position).x
				var0.x = math.clamp(var0.x, var20[1].x, var20[3].x)
				var13.localPosition = var0

				local var1 = 1

				for iter0 = 1, 3 do
					if var13 ~= var21[iter0] and var13.localPosition.x > var21[iter0].localPosition.x + (var1 < arg0.dragIndex and 1.1 or -1.1) * var19 then
						var1 = var1 + 1
					end
				end

				if arg0.dragIndex ~= var1 then
					local var2 = var1 < arg0.dragIndex and -1 or 1

					while arg0.dragIndex ~= var1 do
						local var3 = arg0.dragIndex
						local var4 = arg0.dragIndex + var2

						var2[var3], var2[var4] = var2[var4], var2[var3]
						var21[var3], var21[var4] = var21[var4], var21[var3]
						arg0.dragIndex = arg0.dragIndex + var2
					end

					for iter1 = 1, 3 do
						if var13 ~= var21[iter1] then
							var21[iter1].anchoredPosition = var20[iter1]
						end
					end
				end
			end)
			var18:AddDragEndFunc(function(arg0, arg1)
				if arg0 ~= var13.gameObject then
					return
				end

				if not arg0.isDraging then
					return
				end

				arg0.isDraging = false

				for iter0 = 1, 3 do
					if not var2[iter0] then
						for iter1 = iter0 + 1, 3 do
							if var2[iter1] then
								var2[iter0], var2[iter1] = var2[iter1], var2[iter0]
								var21[iter0], var21[iter1] = var21[iter1], var21[iter0]
							end
						end
					end

					if var2[iter0] then
						table.removebyvalue(var0, var2[iter0])
						table.insert(var0, var2[iter0])
					else
						break
					end
				end

				for iter2 = 1, 3 do
					var21[iter2]:SetSiblingIndex(iter2 - 1)
				end

				var7.enabled = true
				var8.enabled = true
				arg0.dragIndex = nil

				arg0:emit(LevelMediator2.ON_ELITE_ADJUSTMENT, arg0.chapter)
			end)
		end
	end

	if (var5 == true or var6 == 3) and var4 ~= 3 then
		return true
	else
		return false
	end
end

function var0.change2ScrPos(arg0, arg1, arg2)
	local var0 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1, arg2, var0))
end

function var0.updateEliteFleets(arg0)
	for iter0, iter1 in pairs(arg0.tfFleets) do
		for iter2 = 1, #iter1 do
			arg0:UpdateEliteFleet(iter0, iter2)
		end
	end

	arg0:RefreshDutyBar()
end

function var0.UpdateEliteFleet(arg0, arg1, arg2)
	local var0 = arg0.contextData.tabIndex == var0.TabIndex.Formation
	local var1 = arg0.contextData.tabIndex == var0.TabIndex.Commander
	local var2 = arg0.contextData.tabIndex == var0.TabIndex.Duty
	local var3 = arg0.contextData.tabIndex == var0.TabIndex.Adjustment
	local var4 = arg2 <= arg0:getLimitNums(arg1)
	local var5 = arg0.tfFleets[arg1][arg2]
	local var6 = findTF(var5, "bg/name")
	local var7 = arg0:findTF("btn_select", var5)
	local var8 = arg0:findTF("btn_recom", var5)
	local var9 = arg0:findTF("btn_clear", var5)
	local var10 = arg0:findTF("blank", var5)
	local var11 = arg0:findTF("selected", var5)
	local var12 = arg0:findTF("commander", var5)
	local var13 = var5:Find("adjustment_flag")

	setActive(var7, false)

	local var14 = arg0:findTF(TeamType.Main, var5)
	local var15 = arg0:findTF(TeamType.Vanguard, var5)
	local var16 = arg0:findTF(TeamType.Submarine, var5)
	local var17 = arg0:findTF(TeamType.Support, var5)

	if not var4 then
		setActive(var9, false)
		setActive(var8, false)
		setActive(var12, false)
		setActive(var13, false)
		setActive(var10, true)
		setActive(var11, false)
		setText(var6, "")

		if arg1 == FleetType.Normal then
			setActive(var14, false)
			setActive(var15, false)
		elseif arg1 == FleetType.Submarine then
			setActive(var16, false)
		elseif arg1 == FleetType.Support then
			setActive(var17, false)
		end

		return
	end

	local var18 = arg1 == FleetType.Support

	setActive(var9, var0)
	setActive(var8, var0)
	setActive(var12, var1 and not var18)
	setActive(var13, var3)
	setActive(var10, var2 or var3 or var1 and var18)

	local var19 = arg2

	if arg1 == FleetType.Normal then
		setText(var6, Fleet.DEFAULT_NAME[arg2])
		setActive(var14, true)
		setActive(var15, true)
	elseif arg1 == FleetType.Submarine then
		var19 = 3

		setText(var6, Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID + arg2 - 1])
		setActive(var16, true)
	elseif arg1 == FleetType.Support then
		var19 = 4

		setText(var6, "")
		setActive(var17, true)
	end

	local var20 = 6

	if arg1 == FleetType.Normal then
		local var21 = arg0.typeLimitations[arg2]
		local var22 = var21[1]
		local var23 = var21[2]
		local var24 = arg0:initAddButton(var5, TeamType.Main, var22, var19)
		local var25 = arg0:initAddButton(var5, TeamType.Vanguard, var23, var19)

		setActive(var11, var24 and var25)
	elseif arg1 == FleetType.Submarine then
		var20 = 3

		local var26 = arg0:initAddButton(var5, TeamType.Submarine, {
			0,
			0,
			0
		}, var19)

		setActive(var11, var26)
	elseif arg1 == FleetType.Support then
		var20 = 3

		local var27 = arg0:initSupportAddButton(var5, TeamType.Support, {
			"hang",
			"hang",
			"hang"
		})

		setActive(var11, arg0.mode == var2.EDIT and var27)
	end

	if not var18 then
		arg0:initCommander(var19, var12, arg0.chapter)
	end

	onButton(arg0, var9, function()
		if #(not var18 and arg0.eliteFleetList[var19] or arg0.supportFleet) == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("battle_preCombatLayer_clear_confirm"),
			onYes = function()
				if not var18 then
					arg0:emit(LevelMediator2.ON_ELITE_CLEAR, {
						index = var19,
						chapterVO = arg0.chapter
					})
				else
					arg0:emit(LevelMediator2.ON_SUPPORT_CLEAR, {
						index = var19,
						chapterVO = arg0.chapter
					})
				end
			end
		})
	end)
	onButton(arg0, var8, function()
		local var0 = #(not var18 and arg0.eliteFleetList[var19] or arg0.supportFleet)

		if var0 == var20 then
			return
		end

		seriesAsync({
			function(arg0)
				if var0 == 0 then
					return arg0()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("battle_preCombatLayer_auto_confirm"),
					onYes = arg0
				})
			end,
			function()
				if not var18 then
					arg0:emit(LevelMediator2.ON_ELITE_RECOMMEND, {
						index = var19,
						chapterVO = arg0.chapter
					})
				else
					arg0:emit(LevelMediator2.ON_SUPPORT_RECOMMEND, {
						index = var19,
						chapterVO = arg0.chapter
					})
				end
			end
		})
	end)
end

function var0.initCommander(arg0, arg1, arg2, arg3)
	local var0 = arg3:getEliteFleetCommanders()[arg1]

	for iter0 = 1, 2 do
		local var1 = var0[iter0]
		local var2

		if var1 then
			var2 = getProxy(CommanderProxy):getCommanderById(var1)
		end

		local var3 = arg2:Find("pos" .. iter0)
		local var4 = var3:Find("add")
		local var5 = var3:Find("info")

		setActive(var4, not var2)
		setActive(var5, var2)

		if var2 then
			local var6 = Commander.rarity2Frame(var2:getRarity())

			setImageSprite(var5:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2:getPainting(), "", var5:Find("mask/icon"))
		end

		local var7 = arg3:wrapEliteFleet(arg1)

		onButton(arg0, var4, function()
			arg0:emit(LevelUIConst.OPEN_COMMANDER_PANEL, var7, arg3, arg1)
		end, SFX_PANEL)
		onButton(arg0, var5, function()
			arg0:emit(LevelUIConst.OPEN_COMMANDER_PANEL, var7, arg3, arg1)
		end, SFX_PANEL)
	end
end

function var0.initSupportAddButton(arg0, arg1, arg2, arg3)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.supportFleet) do
		var0[arg0.shipVOs[iter1]] = true

		table.insert(var1, iter1)
	end

	local var2 = findTF(arg1, arg2)

	removeAllChildren(var2)

	local var3 = 0
	local var4 = false
	local var5 = 0

	arg3 = var0.sortTeamLimitation(arg3)

	for iter2 = 1, 3 do
		local var6
		local var7
		local var8 = var1[iter2] and arg0.shipVOs[var1[iter2]] or nil

		if var8 then
			for iter3, iter4 in ipairs(arg3) do
				if ShipType.ContainInLimitBundle(iter4, var8:getShipType()) then
					var6 = var8
					var7 = iter4

					table.remove(arg3, iter3)

					var4 = var4 or iter4 ~= 0

					break
				end
			end
		else
			var7 = arg3[1]

			table.remove(arg3, 1)
		end

		if var7 == 0 then
			var5 = var5 + 1
		end

		local var9 = var6 and cloneTplTo(arg0.tfShipTpl, var2) or cloneTplTo(arg0.tfEmptyTpl, var2)

		setActive(var9, true)

		if var6 then
			updateShip(var9, var6)
			setActive(arg0:findTF("event_block", var9), var6:getFlag("inEvent"))

			var0[var6] = true
		else
			var3 = var3 + 1
		end

		setActive(arg0:findTF("ship_type", var9), var7 and var7 ~= 0)

		if var7 and var7 ~= 0 then
			if type(var7) == "number" then
				local var10 = GetSpriteFromAtlas("shiptype", ShipType.Type2CNLabel(var7))

				setImageSprite(arg0:findTF("ship_type", var9), var10, true)
			elseif type(var7) == "string" then
				local var11 = GetSpriteFromAtlas("shiptype", ShipType.BundleType2CNLabel(var7))

				setImageSprite(arg0:findTF("ship_type", var9), var11, true)
			end
		end

		local var12 = _.map(arg0.supportFleet, function(arg0)
			return arg0.shipVOs[arg0]
		end)
		local var13 = GetOrAddComponent(var9, typeof(UILongPressTrigger))

		var13.onLongPressed:RemoveAllListeners()

		if var6 and arg0.contextData.tabIndex ~= var0.TabIndex.Adjustment then
			var13.onLongPressed:AddListener(function()
				arg0:onCancelSupport(true)
				arg0:emit(LevelMediator2.ON_SUPPORT_SHIPINFO, {
					shipId = var6.id,
					shipVOs = var12,
					chapter = arg0.chapter
				})
			end)
		end

		local var14 = GetOrAddComponent(var9, "EventTriggerListener")

		var14:RemovePointClickFunc()
		var14:AddPointClickFunc(function(arg0, arg1)
			if arg0 ~= var9.gameObject then
				return
			end

			if arg0.isDraging then
				return
			end

			arg0:onCancelSupport()
			arg0:emit(LevelMediator2.ON_SUPPORT_OPEN_DECK, {
				shipType = var7,
				fleet = var0,
				chapter = arg0.chapter,
				shipVO = var6
			})
		end)
		var14:RemoveBeginDragFunc()
		var14:RemoveDragFunc()
		var14:RemoveDragEndFunc()
	end

	if (var4 == true or var5 == 3) and var3 ~= 3 then
		return true
	else
		return false
	end
end

function var0.updateSpecialOperationTickets(arg0, arg1)
	arg0.spOPTicketItems = arg1 or {}
end

function var0.getLegalSPBuffList(arg0)
	local var0 = arg0.chapter:GetSpItems()

	return _.map(var0, function(arg0)
		return Chapter.GetSPBuffByItem(arg0:GetConfigID())
	end)
end

function var0.initSPOPView(arg0)
	arg0.spPanel = arg0.btnSp:Find("sp_panel")
	arg0.spItem = arg0.btnSp:Find("item")
	arg0.spDesc = arg0.btnSp:Find("desc")
	arg0.spCheckBox = arg0.btnSp:Find("checkbox")
	arg0.spCheckMark = arg0.spCheckBox:Find("mark")
	arg0.spTpl = arg0.spPanel:Find("sp_tpl")
	arg0.spContainer = arg0.spPanel:Find("sp_container")
	arg0.spItemEmptyBlock = arg0.btnSp:Find("empty_block")

	setText(arg0.spItemEmptyBlock, i18n("levelScene_select_noitem"))
	removeAllChildren(arg0.spContainer)

	local var0 = arg0:getLegalSPBuffList()
	local var1 = arg0.chapter:GetActiveSPItemID()

	arg0:setSPBtnFormByBuffCount()

	if #var0 == 0 then
		arg0:clearSPBuff()
	elseif #var0 == 1 then
		local var2 = var0[1]
		local var3 = pg.benefit_buff_template[var2]

		arg0:setTicketInfo(arg0.btnSp, var3.benefit_condition)
		setText(arg0.spDesc, var3.desc)
		onButton(arg0, arg0.btnSp:Find("item"), function()
			arg0:emit(BaseUI.ON_ITEM, tonumber(var3.benefit_condition))
		end)
		onButton(arg0, arg0.btnSp, function()
			local var0 = Chapter.GetSPOperationItemCacheKey(arg0.chapter.id)

			if arg0.spCheckMark.gameObject.activeSelf then
				PlayerPrefs.SetInt(var0, 0)
				arg0:clearSPBuff()
			else
				arg0.spItemID = tonumber(var3.benefit_condition)

				PlayerPrefs.SetInt(var0, arg0.spItemID)
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_select_sp"))
				setActive(arg0.spCheckMark, true)
			end
		end)
		setActive(arg0.spCheckMark, var1 == 0)
		triggerButton(arg0.btnSp)
	elseif #var0 > 1 then
		setText(arg0.spDesc, i18n("levelScene_select_SP_OP"))

		for iter0, iter1 in ipairs(var0) do
			local var4 = cloneTplTo(arg0.spTpl, arg0.spContainer)

			setText(var4:Find("desc"), iter1.desc)
			arg0:setTicketInfo(var4, iter1.benefit_condition)
			setActive(var4:Find("block"), false)
			onButton(arg0, var4, function()
				arg0:setSPBuffSelected(iter1.id)
				setActive(arg0.spPanel, false)
			end)
		end

		onButton(arg0, arg0.btnSp, function()
			if arg0.spPanel.gameObject.activeSelf then
				arg0:clearSPBuff()

				local var0 = Chapter.GetSPOperationItemCacheKey(arg0.chapter.id)

				PlayerPrefs.SetInt(var0, 0)
				setActive(arg0.spPanel, false)
			else
				setActive(arg0.spPanel, true)
				setActive(arg0.btnSp:Find("item"), false)
				setText(arg0.spDesc, i18n("levelScene_unselect_SP_OP"))
			end
		end)

		if var1 ~= 0 then
			local var5

			for iter2, iter3 in ipairs(var0) do
				if iter3.id == Chapter.GetSPBuffByItem(var1) then
					var5 = true

					break
				end
			end

			if var5 then
				local var6 = Chapter.GetSPBuffByItem(var1)

				arg0:setSPBuffSelected(var6)
			else
				arg0:clearSPBuff()
			end
		else
			arg0:clearSPBuff()
		end
	end

	setActive(arg0.spPanel, false)
end

function var0.setSPBuffSelected(arg0, arg1)
	local var0 = pg.benefit_buff_template[arg1]

	arg0.spItemID = tonumber(var0.benefit_condition)

	arg0:setTicketInfo(arg0.btnSp, arg0.spItemID)
	setText(arg0.spDesc, var0.desc)

	local var1 = Chapter.GetSPOperationItemCacheKey(arg0.chapter.id)

	PlayerPrefs.SetInt(var1, arg0.spItemID)
end

function var0.clearSPBuff(arg0)
	local var0 = arg0:getLegalSPBuffList()

	arg0.spItemID = nil

	arg0:setSPBtnFormByBuffCount()

	if #var0 == 0 then
		setActive(arg0.btnSp:Find("item"), false)
	elseif #var0 == 1 then
		setActive(arg0.btnSp:Find("item"), true)
		setActive(arg0.spCheckMark, false)
	elseif #var0 > 1 then
		setActive(arg0.btnSp:Find("item"), false)
		setText(arg0.spDesc, i18n("levelScene_select_SP_OP"))
	end
end

function var0.setSPBtnFormByBuffCount(arg0)
	local var0 = arg0:getLegalSPBuffList()

	if #var0 == 0 then
		setActive(arg0.spItemEmptyBlock, true)
		setActive(arg0.spDesc, false)
		setActive(arg0.spCheckBox, false)
		setActive(arg0.btnSp:Find("add"), false)
	elseif #var0 == 1 then
		setActive(arg0.spItemEmptyBlock, false)
		setActive(arg0.spDesc, true)
		setActive(arg0.spCheckBox, true)
		setActive(arg0.btnSp:Find("add"), false)
	elseif #var0 > 1 then
		setActive(arg0.spItemEmptyBlock, false)
		setActive(arg0.spDesc, true)
		setActive(arg0.spCheckBox, false)
		setActive(arg0.btnSp:Find("add"), true)
	end
end

function var0.setTicketInfo(arg0, arg1, arg2)
	local var0

	arg2 = tonumber(arg2)

	for iter0, iter1 in ipairs(arg0.spOPTicketItems) do
		if arg2 == iter1.configId then
			var0 = iter1

			break
		end
	end

	if var0 then
		setText(arg1:Find("item/count"), var0.count)
		GetImageSpriteFromAtlasAsync(var0:getConfig("icon"), "", arg1:Find("item/icon"))
	else
		setText(arg1:Find("item/count"), 0)
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg2
		}):getIcon(), "", arg1:Find("item/icon"))
	end

	setActive(arg1:Find("item"), true)
end

function var0.getSPItem(arg0)
	return arg0.spItemID
end

function var0.SetDuty(arg0, arg1, arg2)
	if not arg2 or not arg0.duties then
		return
	end

	if arg0.duties[arg1] == arg2 then
		return
	end

	arg0.duties[arg1] = arg2
	arg0.duties[3 - arg1] = nil

	arg0:RefreshDutyBar()
end

function var0.UpdateDuties(arg0)
	if not arg0.dutyTabEnabled then
		return
	end

	local var0 = 0
	local var1 = 0

	for iter0 = 1, 2 do
		if not arg0:IsListOfFleetEmpty(iter0) then
			var0 = var0 + 1
			var1 = iter0
		end
	end

	if var0 == 0 then
		table.clear(arg0.duties)
	elseif var0 == 1 then
		arg0.duties[var1] = ChapterFleet.DUTY_KILLALL
		arg0.duties[3 - var1] = nil
	elseif var0 == 2 then
		if arg0.duties[1] then
			local var2 = arg0.duties[1]
			local var3 = var2 < 3 and 3 - var2 or 7 - var2

			arg0.duties[2] = var3
		elseif arg0.duties[2] then
			local var4 = arg0.duties[2]
			local var5 = var4 < 3 and 3 - var4 or 7 - var4

			arg0.duties[1] = var5
		else
			arg0.duties[1] = ChapterFleet.DUTY_CLEANPATH
			arg0.duties[2] = ChapterFleet.DUTY_KILLBOSS
		end
	end

	if var1 ~= 0 then
		local var6 = "lastFleetDuty_" .. (arg0.chapter.id or 0)
		local var7 = 0
		local var8 = 8

		for iter1, iter2 in ipairs({
			var1,
			arg0.duties[var1]
		}) do
			var7 = var7 + bit.lshift(iter2, var8 * (iter1 - 1))
		end

		PlayerPrefs.SetInt(var6, var7)
		PlayerPrefs.Save()
	end
end

function var0.RefreshDutyBar(arg0)
	arg0:UpdateDuties()
	arg0:UpdateDutyBar()
end

function var0.UpdateDutyBar(arg0)
	local var0 = arg0.contextData.tabIndex == var0.TabIndex.Duty

	for iter0 = 1, 2 do
		local var1 = arg0._tf:Find(string.format("panel/ShipList/fleet/%d/DutySelect", iter0))

		setActive(var1, var0 and arg0.duties[iter0] ~= nil)
	end

	local var2 = arg0._tf:Find("panel/ShipList/sub/1/DutySelect")

	setActive(var2, var0 and not arg0:IsListOfFleetEmpty(3))

	if not var0 then
		return
	end

	for iter1, iter2 in pairs(arg0.duties) do
		for iter3 = 1, 4 do
			setActive(arg0.dutyItems[iter1][iter3]:Find("Checkmark"), iter3 == iter2)
		end
	end

	local var3 = ys.Battle.BattleState.IsAutoSubActive()

	for iter4 = 1, 2 do
		local var4 = arg0.dutyItems[3][iter4]

		setActive(var4:Find("Checkmark"), iter4 == 1 == var3)
	end
end

function var0.GetOrderedDuties(arg0)
	if not arg0.duties then
		return
	end

	arg0:UpdateDuties()

	local var0 = {}
	local var1 = 1

	for iter0 = 1, 2 do
		if arg0.duties[iter0] then
			var0[var1] = arg0.duties[iter0]
			var1 = var1 + 1
		end
	end

	return var0
end

function var0.SetAutoSub(arg0, arg1)
	arg1 = tobool(arg1)

	if arg1 == ys.Battle.BattleState.IsAutoSubActive() then
		return
	end

	if not AutoBotCommand.autoBotSatisfied() then
		return
	end

	pg.m02:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = not arg1
	})
	arg0:UpdateDutyBar()
end

function var0.GetValidFleets(arg0, arg1)
	if arg0.mode == var2.SELECT then
		local var0 = {}
		local var1 = arg1 and {
			arg1
		} or {
			FleetType.Normal,
			FleetType.Submarine
		}

		for iter0, iter1 in ipairs(var1) do
			local var2 = arg0.selectIds[iter1]

			for iter2, iter3 in ipairs(var2) do
				if iter3 > 0 then
					table.insert(var0, arg0.fleets[iter3])
				end
			end
		end

		return var0
	elseif arg0.mode == var2.EDIT then
		local var3 = {}
		local var4
		local var5

		if arg1 == FleetType.Normal then
			var4 = 1
			var5 = 2
		elseif arg1 == FleetType.Submarine then
			var4 = 3
			var5 = 3
		elseif not arg1 then
			var4 = 1
			var5 = 3
		end

		for iter4 = var4, var5 do
			local var6 = arg0.eliteFleetList[iter4]

			if #var6 > 0 then
				local var7 = {}

				for iter5, iter6 in pairs(arg0.eliteCommanderList[iter4]) do
					table.insert(var7, {
						pos = iter5,
						id = iter6
					})
				end

				local var8 = TypedFleet.New({
					ship_list = var6,
					commanders = var7,
					fleetType = FleetType.Normal
				})

				table.insert(var3, var8)
			end
		end

		return var3
	end
end

function var0.IsListOfFleetEmpty(arg0, arg1)
	if arg1 > 0 and arg1 < 3 and arg1 > arg0:getLimitNums(FleetType.Normal) then
		return true
	elseif arg1 == 3 and arg1 - 2 > arg0:getLimitNums(FleetType.Submarine) then
		return true
	end

	if arg0.mode == var2.SELECT then
		local var0

		if arg1 > 0 and arg1 < 3 then
			var0 = arg0.selectIds[FleetType.Normal][arg1] or 0
		elseif arg1 == 3 then
			var0 = arg0.selectIds[FleetType.Submarine][arg1 - 2] or 0
		end

		return var0 == 0
	elseif arg0.mode == var2.EDIT then
		return #arg0.eliteFleetList[arg1] == 0
	end
end

function var0.GetListFleets(arg0)
	local var0 = {}
	local var1 = arg0:getLimitNums(FleetType.Normal)
	local var2 = arg0:getLimitNums(FleetType.Submarine)

	if arg0.mode == var2.SELECT then
		local var3 = arg0.selectIds[FleetType.Normal]

		for iter0 = 1, var1 do
			local var4 = var3[iter0] or 0

			var0[iter0] = var4 > 0 and arg0.fleets[var4] or nil
		end

		local var5 = arg0.selectIds[FleetType.Submarine]

		for iter1 = 1, var2 do
			local var6 = var5[iter1] or 0

			var0[iter1 + var1] = var6 > 0 and arg0.fleets[var6] or nil
		end
	elseif arg0.mode == var2.EDIT then
		local var7 = {}

		for iter2 = 1, var1 do
			table.insert(var7, iter2)
		end

		for iter3 = 1, var2 do
			table.insert(var7, iter3 + 2)
		end

		for iter4 = 1, #var7 do
			local var8 = var7[iter4]
			local var9
			local var10 = arg0.eliteFleetList[var8]

			if #var10 > 0 then
				local var11 = var8 > 2 and FleetType.Submarine or FleetType.Normal
				local var12 = {}

				for iter5, iter6 in pairs(arg0.eliteCommanderList[var8]) do
					table.insert(var12, {
						pos = iter5,
						id = iter6
					})
				end

				var9 = TypedFleet.New({
					ship_list = var10,
					commanders = var12,
					fleetType = var11
				})
			end

			var0[iter4] = var9
		end
	end

	return var0
end

function var0.IsSelectMode(arg0)
	return arg0.mode == var2.SELECT
end

function var0.SwitchDisplayMode(arg0)
	local var0 = arg0.displayMode == var3.ADDITION_SUPPORT

	setActive(arg0:findTF("panel/ShipList/Line"), not var0)
	setActive(arg0:findTF("panel/ShipList/support"), var0)

	local var1 = arg0:findTF("panel/ShipList"):GetComponent(typeof(VerticalLayoutGroup))
	local var2 = var1.padding

	var2.top = var0 and 9 or 20
	var2.bottom = var0 and 14 or 25
	var1.padding = var2
	var1.spacing = var0 and 13 or 20
end

function var0.sortTeamLimitation(arg0)
	arg0 = Clone(arg0)

	table.sort(arg0, function(arg0, arg1)
		local var0 = type(arg0)
		local var1 = type(arg1)

		if var0 == var1 then
			return var1 < var0
		elseif arg1 == 0 or var1 == "string" and arg0 ~= 0 then
			return true
		else
			return false
		end
	end)

	return arg0
end

return var0
