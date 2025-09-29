local var0_0 = class("IslandTicketUsePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandTicketUseUI"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("window/time_panel")

	setText(var0_2:Find("left/Text"), i18n("island_ticket_remain_time"))

	arg0_2.remainTimeTF = var0_2:Find("left/time")
	arg0_2.progressSliderTF = var0_2:Find("right/progress")
	arg0_2.progressUpSliderTF = var0_2:Find("right/progress_up")
	arg0_2.reduceTimeTF = var0_2:Find("right/Text")
	arg0_2.formulaNumTF = arg0_2._tf:Find("window/Text")
	arg0_2.viewBtn = arg0_2._tf:Find("window/view")

	setText(arg0_2.viewBtn:Find("Text"), i18n("island_ticket_view"))

	arg0_2.autoBtn = arg0_2._tf:Find("window/auto")

	setText(arg0_2.autoBtn:Find("Text"), i18n("island_ticket_auto_select"))

	arg0_2.useBtn = arg0_2._tf:Find("window/use")

	setText(arg0_2.useBtn:Find("Text"), i18n("island_ticket_use"))

	arg0_2.scrollRect = arg0_2._tf:Find("window/scrollrect"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("window/close"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("mask"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.viewBtn, function()
		arg0_5:OpenPage(IslandTicketStoragePage)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.viewBtn, function()
		arg0_5:OpenPage(IslandTicketStoragePage)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.autoBtn, function()
		arg0_5:AutoSelect()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.useBtn, function()
		arg0_5:UseTickets()
	end, SFX_PANEL)

	arg0_5.cards = {}
	arg0_5.displayGroups = underscore.keys(pg.island_speedup_ticket.get_id_list_by_speedup_time)

	table.sort(arg0_5.displayGroups)
end

function var0_0.OnInitItem(arg0_12, arg1_12)
	local var0_12 = IslandTicketGroupCard.New(arg1_12)

	arg0_12.cards[arg1_12] = var0_12

	onButton(arg0_12, var0_12.shopBtn, function()
		if not IslandMainBtnTipHelper.IsUnlock("shop") then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_shop_lock_tip"))

			return
		end

		local var0_13 = pg.island_set.island_ticket_shopid.key_value_varchar

		arg0_12:OpenPage(IslandShopPage, unpack(var0_13))
	end, SFX_PANEL)
end

function var0_0.OnUpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.cards[arg2_14]

	if not var0_14 then
		arg0_14:OnInitItem(arg2_14)

		var0_14 = arg0_14.cards[arg2_14]
	end

	local function var1_14(arg0_15, arg1_15)
		arg0_14.selCounts[arg0_15] = arg1_15

		var0_14:UpdateSelCnt(arg0_14.selCounts[arg0_15])
		arg0_14:UpdataSelected()
		arg0_14:SetOverflowFlag()
	end

	local var2_14 = arg1_14 + 1

	onButton(arg0_14, var0_14._go, function()
		if arg0_14.overflowFlag then
			return
		end

		local var0_16 = arg0_14.selCounts[var2_14] + 1

		if var0_16 > arg0_14.allCounts[var2_14] then
			return
		end

		var1_14(var2_14, var0_16)
	end, SFX_PANEL)
	onButton(arg0_14, var0_14.reduceBtn, function()
		local var0_17 = arg0_14.selCounts[var2_14] - 1

		if var0_17 < 0 then
			return
		end

		var1_14(var2_14, var0_17)
	end, SFX_PANEL)
	onInputEndEdit(arg0_14, var0_14.countInput, function(arg0_18)
		local var0_18 = 0

		if not arg0_18 or arg0_18 == "" or not tonumber(arg0_18) then
			local var1_18 = 0
		end

		local var2_18 = tonumber(arg0_18)
		local var3_18 = math.max(0, var2_18)
		local var4_18 = math.min(var3_18, arg0_14.allCounts[var2_14])

		if var4_18 > arg0_14.selCounts[var2_14] and arg0_14.overflowFlag then
			return
		end

		var1_14(var2_14, var4_18)
	end)

	local var3_14 = arg0_14.displayGroups[var2_14]
	local var4_14 = arg0_14.displayDic[var3_14]

	if var4_14 then
		var0_14:Update(var3_14, var4_14, arg0_14.allCounts[var2_14], arg0_14.selCounts[var2_14])
	end
end

function var0_0.SetOverflowFlag(arg0_19)
	arg0_19.overflowFlag = arg0_19.endTime - arg0_19.timeMgr:GetServerTime() - arg0_19.reduceTime <= 0
end

function var0_0.AddListeners(arg0_20)
	arg0_20:AddListener(GAME.ISLAND_REMOVE_EXPIRED_TICKET_DONE, arg0_20.Flush)
	arg0_20:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_20.Flush)
	arg0_20:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_20.Flush)
end

function var0_0.RemoveListeners(arg0_21)
	arg0_21:RemoveListener(GAME.ISLAND_REMOVE_EXPIRED_TICKET_DONE, arg0_21.Flush)
	arg0_21:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_21.Flush)
	arg0_21:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_21.Flush)
end

function var0_0.OnShow(arg0_22, arg1_22, arg2_22)
	arg0_22:BlurPanel()

	arg0_22.type = arg1_22
	arg0_22.id = arg2_22
	arg0_22.timeMgr = pg.TimeMgr.GetInstance()

	arg0_22:Flush()
end

function var0_0.Flush(arg0_23)
	arg0_23:SetSystemData()
	arg0_23:SetTicketsData()
	arg0_23.scrollRect:SetTotalCount(#arg0_23.displayGroups, -1)
	arg0_23:UpdataSelected()
	arg0_23:StopTimer()
	arg0_23:StartTimer()

	arg0_23.overflowFlag = false
end

function var0_0.SetSystemData(arg0_24)
	arg0_24.allTime = 0
	arg0_24.endTime = 0

	switch(arg0_24.type, {
		[IslandUseTicketCommand.TYPES.ORDER_CD] = function()
			local var0_25 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg0_24.id)

			if not var0_25 then
				return
			end

			arg0_24.endTime = var0_25:GetCanSubmitTime()
			arg0_24.allTime = var0_25:GetTotalTime()
		end,
		[IslandUseTicketCommand.TYPES.SHIP_ORDER] = function()
			local var0_26 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipOrderSlot(arg0_24.id)

			if not var0_26 then
				return
			end

			arg0_24.endTime = var0_26:GetEndTime()
			arg0_24.allTime = var0_26:GetNeedTime()
		end,
		[IslandUseTicketCommand.TYPES.MANAGE] = function()
			local var0_27 = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg0_24.id)

			if not var0_27 then
				return
			end

			arg0_24.endTime = var0_27:GetEndTime()
			arg0_24.allTime = var0_27:getConfig("opening_time")
		end,
		[IslandUseTicketCommand.TYPES.APPOINT] = function()
			local var0_28 = pg.island_production_slot[arg0_24.id].place
			local var1_28 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var0_28):GetDelegationSlotData(arg0_24.id)

			arg0_24.appointRoleData = var1_28:GetSlotRoleData()

			if not arg0_24.appointRoleData then
				return
			end

			arg0_24.endTime = arg0_24.appointRoleData:GetFinishTime()
			arg0_24.allTime = arg0_24.appointRoleData:GetAllTime()
		end
	}, function()
		assert(false, "no ticket use type: " .. arg0_24.type)
	end)
end

function var0_0.SetTicketsData(arg0_30)
	arg0_30.ticketAgency = getProxy(IslandProxy):GetIsland():GetTicketAgency()
	arg0_30.displayDic = {}

	local var0_30 = arg0_30.ticketAgency:GetTicketData()

	for iter0_30, iter1_30 in pairs(var0_30) do
		local var1_30 = underscore.values(iter1_30)

		if #var1_30 > 0 then
			local var2_30 = var1_30[1]:GetTime()

			if not arg0_30.displayDic[var2_30] then
				arg0_30.displayDic[var2_30] = {}
			end

			arg0_30.displayDic[var2_30] = table.mergeArray(arg0_30.displayDic[var2_30], var1_30)
		end
	end

	for iter2_30, iter3_30 in pairs(arg0_30.displayDic) do
		table.sort(iter3_30, CompareFuncs({
			function(arg0_31)
				return arg0_31:IsForever() and 1 or 0
			end,
			function(arg0_32)
				return arg0_32:GetEndTime()
			end,
			function(arg0_33)
				return arg0_33.id
			end
		}))
	end

	arg0_30.allCounts = {}
	arg0_30.selCounts = {}

	for iter4_30, iter5_30 in ipairs(arg0_30.displayGroups) do
		if not arg0_30.displayDic[iter5_30] then
			arg0_30.displayDic[iter5_30] = {}
		end

		local var3_30 = underscore.reduce(arg0_30.displayDic[iter5_30], 0, function(arg0_34, arg1_34)
			return arg0_34 + arg1_34:GetCount()
		end)

		table.insert(arg0_30.allCounts, var3_30)
		table.insert(arg0_30.selCounts, 0)
	end

	arg0_30.reduceTime = 0
end

function var0_0.UpdateSliderUI(arg0_35)
	local var0_35 = arg0_35.timeMgr:GetServerTime()
	local var1_35 = arg0_35.endTime - var0_35
	local var2_35 = var1_35 - arg0_35.reduceTime

	if var2_35 > 0 then
		setText(arg0_35.remainTimeTF, arg0_35.timeMgr:DescCDTime(var2_35))
	else
		setText(arg0_35.remainTimeTF, i18n("island_ticket_finished"))
	end

	setText(arg0_35.reduceTimeTF, "-" .. arg0_35.timeMgr:DescCDTime(arg0_35.reduceTime))
	setSlider(arg0_35.progressSliderTF, 0, 1, 1 - var1_35 / arg0_35.allTime)
	setSlider(arg0_35.progressUpSliderTF, 0, 1, 1 - (var1_35 - arg0_35.reduceTime) / arg0_35.allTime)

	local var3_35 = arg0_35.type == IslandUseTicketCommand.TYPES.APPOINT

	setActive(arg0_35.formulaNumTF, var3_35)

	if var3_35 and arg0_35.appointRoleData then
		local var4_35 = arg0_35.appointRoleData:GetCountByTimestamp(var0_35 + arg0_35.reduceTime)

		setText(arg0_35.formulaNumTF, i18n("island_ticket_completed_quantity", var4_35))
	end
end

function var0_0.UpdateReduceTime(arg0_36)
	arg0_36.reduceTime = 0

	for iter0_36, iter1_36 in ipairs(arg0_36.selCounts) do
		arg0_36.reduceTime = arg0_36.reduceTime + arg0_36.displayGroups[iter0_36] * iter1_36
	end
end

function var0_0.UpdataSelected(arg0_37)
	arg0_37:UpdateReduceTime()
	arg0_37:UpdateSliderUI()

	local var0_37 = underscore.any(arg0_37.selCounts, function(arg0_38)
		return arg0_38 > 0
	end)

	setGray(arg0_37.useBtn, not var0_37, true)
	setButtonEnabled(arg0_37.useBtn, var0_37)
end

function var0_0._SelectTickets(arg0_39)
	local var0_39 = arg0_39.endTime - arg0_39.timeMgr:GetServerTime()
	local var1_39 = 0

	arg0_39.selCounts = {}

	for iter0_39, iter1_39 in ipairs(arg0_39.displayGroups) do
		table.insert(arg0_39.selCounts, 0)
	end

	for iter2_39, iter3_39 in ipairs(arg0_39.displayGroups) do
		local var2_39 = arg0_39.displayDic[iter3_39]

		for iter4_39, iter5_39 in ipairs(var2_39) do
			for iter6_39 = 1, iter5_39:GetCount() do
				var1_39 = var1_39 + iter5_39:GetTime()

				if var0_39 <= var1_39 then
					return
				end

				arg0_39.selCounts[iter2_39] = arg0_39.selCounts[iter2_39] + 1
			end
		end
	end
end

function var0_0.AutoSelect(arg0_40)
	arg0_40:_SelectTickets()
	arg0_40:UpdataSelected()
	arg0_40.scrollRect:SetTotalCount(#arg0_40.displayGroups, -1)
end

function var0_0.GetSelectedTickets(arg0_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(arg0_41.selCounts) do
		local var1_41 = arg0_41.displayGroups[iter0_41]
		local var2_41 = arg0_41.displayDic[var1_41]
		local var3_41 = 0

		for iter2_41, iter3_41 in ipairs(var2_41) do
			local var4_41 = iter1_41 - var3_41

			if var4_41 <= iter3_41:GetCount() then
				table.insert(var0_41, IslandTicket.New(iter3_41.id, iter3_41.endTime, var4_41))

				break
			else
				table.insert(var0_41, IslandTicket.New(iter3_41.id, iter3_41.endTime, iter3_41:GetCount()))

				var3_41 = var3_41 + iter3_41:GetCount()
			end
		end
	end

	return (underscore.select(var0_41, function(arg0_42)
		return arg0_42:GetCount() > 0
	end))
end

function var0_0.UseTickets(arg0_43)
	seriesAsync({
		function(arg0_44)
			if arg0_43.endTime - arg0_43.timeMgr:GetServerTime() <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_ticket_finished"))
			else
				arg0_44()
			end
		end,
		function(arg0_45)
			if arg0_43.endTime - arg0_43.timeMgr:GetServerTime() < arg0_43.reduceTime then
				arg0_43:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_sure_ticket_overflow"),
					onYes = arg0_45
				})
			else
				arg0_45()
			end
		end
	}, function()
		local var0_46 = arg0_43:GetSelectedTickets()

		arg0_43:emit(IslandMediator.USE_TICKETS, arg0_43.type, arg0_43.id, var0_46)
	end)
end

function var0_0.StartTimer(arg0_47)
	arg0_47.timer = Timer.New(function()
		arg0_47:UpdateTimer()
	end, 1, -1)

	arg0_47.timer:Start()
	arg0_47:UpdateTimer()
end

function var0_0.UpdateTimer(arg0_49)
	arg0_49:UpdateSliderUI()
end

function var0_0.StopTimer(arg0_50)
	if arg0_50.timer then
		arg0_50.timer:Stop()

		arg0_50.timer = nil
	end
end

function var0_0.OnHide(arg0_51)
	arg0_51:UnBlurPanel()
	arg0_51:StopTimer()
end

function var0_0.OnDisable(arg0_52)
	arg0_52:OnHide()
end

function var0_0.OnDestroy(arg0_53)
	ClearLScrollrect(arg0_53.scrollRect)

	for iter0_53, iter1_53 in pairs(arg0_53.cards) do
		iter1_53:Dispose()
	end

	arg0_53.cards = {}
end

return var0_0
