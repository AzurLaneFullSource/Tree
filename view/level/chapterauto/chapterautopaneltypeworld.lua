local var0_0 = class("ChapterAutoPanelTypeWorld", import("view.base.BaseSubView"))

var0_0.Listeners = {
	onUpdateStamina = "OnUpdateStamina"
}

function var0_0.getUIName(arg0_1)
	return "ChapterAutoPanelTypeWorld"
end

function var0_0.OnLoaded(arg0_2)
	for iter0_2, iter1_2 in pairs(var0_0.Listeners) do
		arg0_2[iter0_2] = function(...)
			var0_0[iter1_2](arg0_2, ...)
		end
	end

	setText(arg0_2.uiStartBtn:Find("Text"), i18n("auto_battle_confirm_button"))
	setText(arg0_2.uiUtilTime:Find("header"), i18n("auto_battle_time_left"))
	setText(arg0_2.uiUtilCost:Find("header"), i18n("auto_battle_cost_extra"))
	setText(arg0_2.uiUtilTime:Find("header"), i18n("auto_battle_time_left"))
	setText(arg0_2.uiUtilCost:Find("header"), i18n("auto_battle_cost_extra"))
	setText(arg0_2.uiLeftProficiencyHeaderText, i18n("auto_battle_class_exp_head"))
	setText(arg0_2.uiUtilLevel:Find("title_bg/Text"), i18n("world_auto_plan_level"))
	setText(arg0_2.uiUtilCount:Find("title_bg/Text"), i18n("world_auto_plan_quantity"))
	setText(arg0_2.uiProficiency:Find("title_bg/Text"), i18n("auto_battle_base_loot"))
	setText(arg0_2.uiDrops:Find("title_bg/Text"), i18n("world_auto_plan_award"))
	setText(arg0_2.uiUtilLevel:Find("toggles/until_3/Text"), i18n("world_auto_level_less_3"))
	setText(arg0_2.uiUtilLevel:Find("toggles/4/Text"), "4")
	setText(arg0_2.uiUtilLevel:Find("toggles/5/Text"), "5")
	setText(arg0_2.uiUtilLevel:Find("toggles/all/Text"), i18n("world_auto_level_all"))

	arg0_2.ticketUIList = UIItemList.New(arg0_2.uiTicketTF, arg0_2.uiTicketTF:Find("tpl"))
	arg0_2.awardUIList = UIItemList.New(arg0_2.uiRightAwardContentTF, arg0_2.uiRightAwardContentTF:Find("item"))
end

function var0_0.InitData(arg0_4)
	arg0_4.mapDic = nowWorld():GetDelegateMapDic()
	arg0_4.countMax = getGameset("world_auto_battle_map_limit")[1]
	arg0_4.needTicket = false

	setActive(arg0_4.uiUtilCost:Find("Image_1"), arg0_4.needTicket)
end

function var0_0.CheckHazardInFilter(arg0_5, arg1_5)
	for iter0_5, iter1_5 in pairs(arg0_5.toggleDic) do
		if iter1_5 and switch(iter0_5, {
			until_3 = function()
				return arg1_5 < 4
			end,
			["4"] = function()
				return arg1_5 == 4
			end,
			["5"] = function()
				return arg1_5 == 5
			end,
			["6"] = function()
				return arg1_5 == 6
			end,
			all = function()
				return true
			end
		}) then
			return true
		end
	end

	return false
end

function var0_0.CheckToggles(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.toggleDic) do
		if iter1_11 then
			table.insert(var0_11, iter0_11)
		end
	end

	if #var0_11 == 0 or #var0_11 >= arg0_11.uiUtilLevel:Find("toggles").childCount - 1 then
		arg0_11.toggleDic = {
			all = true
		}
	else
		arg0_11.toggleDic = {}

		for iter2_11, iter3_11 in ipairs(var0_11) do
			arg0_11.toggleDic[iter3_11] = true
		end
	end

	eachChild(arg0_11.uiUtilLevel:Find("toggles"), function(arg0_12, arg1_12)
		triggerToggle(arg0_12, tobool(arg0_11.toggleDic[arg0_12.name]))
	end)

	arg0_11.filterMaps = {}

	for iter4_11, iter5_11 in pairs(arg0_11.mapDic) do
		if arg0_11:CheckHazardInFilter(iter4_11) then
			table.insertto(arg0_11.filterMaps, iter5_11)
		end
	end

	table.sort(arg0_11.filterMaps, CompareFuncs({
		function(arg0_13)
			return arg0_13:GetDanger()
		end,
		function(arg0_14)
			return arg0_14.id
		end
	}))

	local var1_11 = math.min(arg0_11.countMax, #arg0_11.filterMaps)
	local var2_11 = math.min(var1_11, arg0_11.countMaps or 0)

	arg0_11.countMaps = nil

	arg0_11:SetSlider(var2_11)
	setSlider(arg0_11.uiUtilCount:Find("Slider"), 0, var1_11, var2_11)
end

function var0_0.SetSlider(arg0_15, arg1_15)
	arg1_15 = calcFloor(arg1_15)

	if arg0_15.countMaps == arg1_15 then
		return
	end

	arg0_15.countMaps = arg1_15

	setText(arg0_15.uiUtilCount:Find("Slider/Text"), string.format("%d/%d", arg0_15.countMaps, math.min(arg0_15.countMax, #arg0_15.filterMaps)))

	arg0_15.staminaCount, arg0_15.bookCount, arg0_15.timeCount, arg0_15.expCount = 0, 0, 0, 0
	arg0_15.awards = {}

	for iter0_15 = 1, arg0_15.countMaps do
		local var0_15 = arg0_15.filterMaps[iter0_15]
		local var1_15 = pg.world_auto_statistics[var0_15.id]

		arg0_15.staminaCount = arg0_15.staminaCount + var1_15.oil_limit
		arg0_15.bookCount = arg0_15.bookCount + 1
		arg0_15.timeCount = arg0_15.timeCount + var1_15.time_correction
		arg0_15.expCount = arg0_15.expCount + var1_15.drop_expbook

		table.insertto(arg0_15.awards, var1_15.award_display)
	end

	local var2_15 = arg0_15.staminaMgr:GetTotalStamina()

	setText(arg0_15.uiUtilCost:Find("value"), string.format("<icon name=stamina h=0.8 w=0.8 /><color=%s>%s×%d</color>", var2_15 < arg0_15.staminaCount and COLOR_RED or COLOR_GREEN, i18n("world_ap"), arg0_15.staminaCount))

	local var3_15 = ChapterAutoTicket.GetDrop(ChapterAutoTicket.TYPE.WORLD)

	var3_15.count = arg0_15.bookCount

	local var4_15 = arg0_15.needTicket and string.format("<icon name=ticket h=0.8 w=0.8 /><color=%s>%s×%d</color>", var3_15.count > arg0_15.ownTicketCnt and COLOR_RED or COLOR_GREEN, var3_15:getName(), var3_15.count) or ""

	setText(arg0_15.uiUtilCost:Find("value_1"), var4_15)
	setText(arg0_15.uiUtilTime:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(arg0_15.timeCount))
	setText(arg0_15.uiLeftProficiencyText, arg0_15.expCount)

	local var5_15 = {}
	local var6_15 = {}

	for iter1_15, iter2_15 in ipairs(arg0_15.awards) do
		local var7_15 = Drop.New({
			count = 0,
			type = iter2_15[1],
			id = iter2_15[2]
		})

		if var5_15[var7_15.type .. "_" .. var7_15.id] then
			-- block empty
		else
			var5_15[var7_15.type .. "_" .. var7_15.id] = var7_15

			table.insert(var6_15, var7_15)
		end
	end

	arg0_15.awards = var6_15

	arg0_15.awardUIList:align(#arg0_15.awards)
end

function var0_0.OnInit(arg0_16)
	arg0_16.toggleDic = {}

	eachChild(arg0_16.uiUtilLevel:Find("toggles"), function(arg0_17, arg1_17)
		local var0_17 = arg0_17.name

		onToggle(arg0_16, arg0_17, function(arg0_18)
			if tobool(arg0_16.toggleDic[var0_17]) == arg0_18 then
				return
			end

			if var0_17 == "all" then
				arg0_16.toggleDic = {
					all = true
				}
			else
				arg0_16.toggleDic[var0_17] = arg0_18
				arg0_16.toggleDic.all = false
			end

			arg0_16:CheckToggles()
		end, SFX_PANEL)
	end)
	onSlider(arg0_16, arg0_16.uiUtilCount:Find("Slider"), function(arg0_19)
		arg0_16:SetSlider(arg0_19)

		local var0_19 = math.min(arg0_16.countMax, #arg0_16.filterMaps)

		setSlider(arg0_16.uiUtilCount:Find("Slider"), 0, var0_19, calcFloor(arg0_19))
	end)
	arg0_16.ticketUIList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = arg0_16.ticketList[arg1_20 + 1]

			setText(arg2_20:Find("Text"), var0_20:GetCount())

			local var1_20 = var0_20:IsForever()

			setActive(arg2_20:Find("time"), not var1_20)

			if not var1_20 then
				local var2_20 = var0_20:GetRemainTime()
				local var3_20 = var2_20 > 86400
				local var4_20 = var3_20 and "auto_battle_book_day" or "auto_battle_book_hour"
				local var5_20 = math.floor(var2_20 / (var3_20 and 86400 or 3600))

				setText(arg2_20:Find("time/Text"), i18n(var4_20, var5_20))
			end
		end
	end)
	arg0_16.awardUIList:make(function(arg0_21, arg1_21, arg2_21)
		arg1_21 = arg1_21 + 1

		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = arg0_16.awards[arg1_21]

			updateDrop(arg2_21, var0_21)
			onButton(arg0_16, arg2_21, function()
				arg0_16:emit(BaseUI.ON_DROP, var0_21)
			end, SFX_PANEL)
		end
	end)
	onButton(arg0_16, arg0_16.uiStartBtn, function()
		if arg0_16.countMaps < 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_times_zero"))

			return
		end

		if arg0_16.needTicket and arg0_16.bookCount > arg0_16.ownTicketCnt then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_not_enough_resource"))

			return
		end

		if arg0_16.staminaCount > arg0_16.staminaMgr:GetTotalStamina() then
			arg0_16.staminaMgr:Show()

			return
		end

		arg0_16:OnStart()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16._tf:Find("bg"), function()
		arg0_16:Hide()
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16.uiCloseBtn, function()
		arg0_16:Hide()
	end, SFX_CANCEL)
end

function var0_0.Show(arg0_26, ...)
	arg0_26:BlurPanel(arg0_26._tf)
	arg0_26:RegisterStaminaMgr()
	arg0_26:Enter(...)
	var0_0.super.Show(arg0_26)
end

function var0_0.Hide(arg0_27)
	arg0_27:UnOverlayPanel(arg0_27._tf, arg0_27.viewComponent.rtPanelList)
	arg0_27:RemoveStaminaMgr()
	var0_0.super.Hide(arg0_27)
end

function var0_0.OnDestroy(arg0_28)
	if arg0_28:isShowing() then
		arg0_28:Hide()
	end
end

function var0_0.RegisterStaminaMgr(arg0_29)
	arg0_29:RemoveStaminaMgr()

	arg0_29.staminaMgr = nowWorld().staminaMgr

	arg0_29.staminaMgr:AddListener(WorldStaminaManager.EventUpdateStamina, arg0_29.onUpdateStamina)
end

function var0_0.RemoveStaminaMgr(arg0_30)
	if not arg0_30.staminaMgr then
		return
	end

	arg0_30.staminaMgr:RemoveListener(WorldStaminaManager.EventUpdateStamina, arg0_30.onUpdateStamina)

	arg0_30.staminaMgr = nil
end

function var0_0.OnUpdateStamina(arg0_31)
	arg0_31:RefreshView()
end

function var0_0.Enter(arg0_32)
	arg0_32:InitData()

	arg0_32.ticketCnt = 0

	arg0_32:RefreshTickets()

	arg0_32.toggleDic = {
		all = true
	}

	arg0_32:CheckToggles()
end

function var0_0.RefreshView(arg0_33)
	arg0_33:Enter()
end

function var0_0.RefreshTickets(arg0_34)
	local var0_34 = getProxy(ChapterAutoProxy)

	arg0_34.ticketList = var0_34:GetTicketListByType(ChapterAutoTicket.TYPE.WORLD)

	table.sort(arg0_34.ticketList, CompareFuncs({
		function(arg0_35)
			return arg0_35.id
		end
	}))
	arg0_34.ticketUIList:align(#arg0_34.ticketList)

	arg0_34.ownTicketCnt = var0_34:GetValidTicketCntByType(ChapterAutoTicket.TYPE.WORLD)
end

function var0_0.OnStart(arg0_36, arg1_36)
	pg.m02:sendNotification(GAME.START_WORLD_CHAPTER_AUTO, {
		type = ChapterAutoProxy.TYPE.WORLD,
		list = underscore(arg0_36.filterMaps):chain():first(arg0_36.countMaps):map(function(arg0_37)
			return arg0_37.id
		end):value(),
		needTicket = arg0_36.needTicket
	})
end

return var0_0
