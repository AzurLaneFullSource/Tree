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
	onButton(arg0_5, arg0_5._tf:Find("window/help"), function()
		arg0_5:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_helpbtn_speedup")
		})
	end, SFX_PANEL)
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

function var0_0.OnInitItem(arg0_13, arg1_13)
	local var0_13 = IslandTicketGroupCard.New(arg1_13)

	arg0_13.cards[arg1_13] = var0_13

	onButton(arg0_13, var0_13.shopBtn, function()
		if not IslandMainBtnTipHelper.IsUnlock("shop") then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_shop_lock_tip"))

			return
		end

		local var0_14 = pg.island_set.island_ticket_shopid.key_value_varchar

		arg0_13:OpenPage(IslandShopPage, unpack(var0_14))
	end, SFX_PANEL)
end

function var0_0.OnUpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.cards[arg2_15]

	if not var0_15 then
		arg0_15:OnInitItem(arg2_15)

		var0_15 = arg0_15.cards[arg2_15]
	end

	local function var1_15(arg0_16, arg1_16)
		arg0_15.selCounts[arg0_16] = arg1_16

		var0_15:UpdateSelCnt(arg0_15.selCounts[arg0_16])
		arg0_15:UpdataSelected()
		arg0_15:SetOverflowFlag()
	end

	local var2_15 = arg1_15 + 1

	onButton(arg0_15, var0_15._go, function()
		if arg0_15.overflowFlag then
			return
		end

		local var0_17 = arg0_15.selCounts[var2_15] + 1

		if var0_17 > arg0_15.allCounts[var2_15] then
			return
		end

		var1_15(var2_15, var0_17)
	end, SFX_PANEL)
	onButton(arg0_15, var0_15.reduceBtn, function()
		local var0_18 = arg0_15.selCounts[var2_15] - 1

		if var0_18 < 0 then
			return
		end

		var1_15(var2_15, var0_18)
	end, SFX_PANEL)
	onInputEndEdit(arg0_15, var0_15.countInput, function(arg0_19)
		local var0_19 = 0

		if not arg0_19 or arg0_19 == "" or not tonumber(arg0_19) then
			local var1_19 = 0
		end

		local var2_19 = tonumber(arg0_19)
		local var3_19 = math.max(0, var2_19)
		local var4_19 = math.min(var3_19, arg0_15.allCounts[var2_15])

		if var4_19 > arg0_15.selCounts[var2_15] and arg0_15.overflowFlag then
			return
		end

		var1_15(var2_15, var4_19)
	end)

	local var3_15 = arg0_15.displayGroups[var2_15]
	local var4_15 = arg0_15.displayDic[var3_15]

	if var4_15 then
		var0_15:Update(var3_15, var4_15, arg0_15.allCounts[var2_15], arg0_15.selCounts[var2_15])
	end
end

function var0_0.SetOverflowFlag(arg0_20)
	arg0_20.overflowFlag = arg0_20.endTime - arg0_20.timeMgr:GetServerTime() - arg0_20.reduceTime <= 0
end

function var0_0.AddListeners(arg0_21)
	arg0_21:AddListener(GAME.ISLAND_REMOVE_EXPIRED_TICKET_DONE, arg0_21.Flush)
	arg0_21:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_21.Flush)
	arg0_21:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_21.Flush)
end

function var0_0.RemoveListeners(arg0_22)
	arg0_22:RemoveListener(GAME.ISLAND_REMOVE_EXPIRED_TICKET_DONE, arg0_22.Flush)
	arg0_22:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_22.Flush)
	arg0_22:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_22.Flush)
end

function var0_0.OnShow(arg0_23, arg1_23, arg2_23)
	arg0_23:BlurPanel()

	arg0_23.type = arg1_23
	arg0_23.id = arg2_23
	arg0_23.timeMgr = pg.TimeMgr.GetInstance()

	arg0_23:Flush()
end

function var0_0.Flush(arg0_24)
	arg0_24:SetSystemData()
	arg0_24:SetTicketsData()
	arg0_24.scrollRect:SetTotalCount(#arg0_24.displayGroups, -1)
	arg0_24:UpdataSelected()
	arg0_24:StopTimer()
	arg0_24:StartTimer()

	arg0_24.overflowFlag = false
end

function var0_0.SetSystemData(arg0_25)
	arg0_25.allTime = 0
	arg0_25.endTime = 0

	switch(arg0_25.type, {
		[IslandUseTicketCommand.TYPES.ORDER_CD] = function()
			local var0_26 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg0_25.id)

			if not var0_26 then
				return
			end

			arg0_25.endTime = var0_26:GetCanSubmitTime()
			arg0_25.allTime = var0_26:GetTotalTime()
		end,
		[IslandUseTicketCommand.TYPES.SHIP_ORDER] = function()
			local var0_27 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipOrderSlot(arg0_25.id)

			if not var0_27 then
				return
			end

			arg0_25.endTime = var0_27:GetEndTime()
			arg0_25.allTime = var0_27:GetNeedTime()
		end,
		[IslandUseTicketCommand.TYPES.MANAGE] = function()
			local var0_28 = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg0_25.id)

			if not var0_28 then
				return
			end

			arg0_25.endTime = var0_28:GetEndTime()
			arg0_25.allTime = var0_28:getConfig("opening_time")
		end,
		[IslandUseTicketCommand.TYPES.APPOINT] = function()
			local var0_29 = pg.island_production_slot[arg0_25.id].place
			local var1_29 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var0_29):GetDelegationSlotData(arg0_25.id)

			arg0_25.appointRoleData = var1_29:GetSlotRoleData()

			if not arg0_25.appointRoleData then
				return
			end

			arg0_25.endTime = arg0_25.appointRoleData:GetFinishTime()
			arg0_25.allTime = arg0_25.appointRoleData:GetAllTime()
		end,
		[IslandUseTicketCommand.TYPES.SHIP_ORDER_RELOAD] = function()
			local var0_30 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipOrderSlot(arg0_25.id)

			if not var0_30 then
				return
			end

			arg0_25.endTime = var0_30:GetReloadingEndTime()
			arg0_25.allTime = pg.island_set.island_shiporder_refresh_cd.key_value_int
		end
	}, function()
		assert(false, "no ticket use type: " .. arg0_25.type)
	end)
end

function var0_0.SetTicketsData(arg0_32)
	arg0_32.ticketAgency = getProxy(IslandProxy):GetIsland():GetTicketAgency()
	arg0_32.displayDic = {}

	local var0_32 = arg0_32.ticketAgency:GetTicketData()

	for iter0_32, iter1_32 in pairs(var0_32) do
		local var1_32 = underscore.values(iter1_32)

		if #var1_32 > 0 then
			local var2_32 = var1_32[1]:GetTime()

			if not arg0_32.displayDic[var2_32] then
				arg0_32.displayDic[var2_32] = {}
			end

			arg0_32.displayDic[var2_32] = table.mergeArray(arg0_32.displayDic[var2_32], var1_32)
		end
	end

	for iter2_32, iter3_32 in pairs(arg0_32.displayDic) do
		table.sort(iter3_32, CompareFuncs({
			function(arg0_33)
				return arg0_33:IsForever() and 1 or 0
			end,
			function(arg0_34)
				return arg0_34:GetEndTime()
			end,
			function(arg0_35)
				return arg0_35.id
			end
		}))
	end

	arg0_32.allCounts = {}
	arg0_32.selCounts = {}

	for iter4_32, iter5_32 in ipairs(arg0_32.displayGroups) do
		if not arg0_32.displayDic[iter5_32] then
			arg0_32.displayDic[iter5_32] = {}
		end

		local var3_32 = underscore.reduce(arg0_32.displayDic[iter5_32], 0, function(arg0_36, arg1_36)
			return arg0_36 + arg1_36:GetCount()
		end)

		table.insert(arg0_32.allCounts, var3_32)
		table.insert(arg0_32.selCounts, 0)
	end

	arg0_32.reduceTime = 0
end

function var0_0.UpdateSliderUI(arg0_37)
	local var0_37 = arg0_37.timeMgr:GetServerTime()
	local var1_37 = arg0_37.endTime - var0_37
	local var2_37 = var1_37 - arg0_37.reduceTime

	if var2_37 > 0 then
		setText(arg0_37.remainTimeTF, arg0_37.timeMgr:DescCDTime(var2_37))
	else
		setText(arg0_37.remainTimeTF, i18n("island_ticket_finished"))
	end

	setText(arg0_37.reduceTimeTF, "-" .. arg0_37.timeMgr:DescCDTime(arg0_37.reduceTime))
	setSlider(arg0_37.progressSliderTF, 0, 1, 1 - var1_37 / arg0_37.allTime)
	setSlider(arg0_37.progressUpSliderTF, 0, 1, 1 - (var1_37 - arg0_37.reduceTime) / arg0_37.allTime)

	local var3_37 = arg0_37.type == IslandUseTicketCommand.TYPES.APPOINT

	setActive(arg0_37.formulaNumTF, var3_37)

	if var3_37 and arg0_37.appointRoleData then
		local var4_37 = arg0_37.appointRoleData:GetCountByTimestamp(var0_37 + arg0_37.reduceTime)

		setText(arg0_37.formulaNumTF, i18n("island_ticket_completed_quantity", var4_37))
	end
end

function var0_0.UpdateReduceTime(arg0_38)
	arg0_38.reduceTime = 0

	for iter0_38, iter1_38 in ipairs(arg0_38.selCounts) do
		arg0_38.reduceTime = arg0_38.reduceTime + arg0_38.displayGroups[iter0_38] * iter1_38
	end
end

function var0_0.UpdataSelected(arg0_39)
	arg0_39:UpdateReduceTime()
	arg0_39:UpdateSliderUI()

	local var0_39 = underscore.any(arg0_39.selCounts, function(arg0_40)
		return arg0_40 > 0
	end)

	setGray(arg0_39.useBtn, not var0_39, true)
	setButtonEnabled(arg0_39.useBtn, var0_39)
end

function var0_0._SelectTickets(arg0_41)
	local var0_41 = arg0_41.endTime - arg0_41.timeMgr:GetServerTime()
	local var1_41 = 0

	arg0_41.selCounts = {}

	for iter0_41, iter1_41 in ipairs(arg0_41.displayGroups) do
		table.insert(arg0_41.selCounts, 0)
	end

	for iter2_41, iter3_41 in ipairs(arg0_41.displayGroups) do
		local var2_41 = arg0_41.displayDic[iter3_41]

		for iter4_41, iter5_41 in ipairs(var2_41) do
			for iter6_41 = 1, iter5_41:GetCount() do
				var1_41 = var1_41 + iter5_41:GetTime()

				if var0_41 <= var1_41 then
					return
				end

				arg0_41.selCounts[iter2_41] = arg0_41.selCounts[iter2_41] + 1
			end
		end
	end
end

function var0_0.AutoSelect(arg0_42)
	arg0_42:_SelectTickets()
	arg0_42:UpdataSelected()
	arg0_42.scrollRect:SetTotalCount(#arg0_42.displayGroups, -1)
end

function var0_0.GetSelectedTickets(arg0_43)
	local var0_43 = {}

	for iter0_43, iter1_43 in ipairs(arg0_43.selCounts) do
		local var1_43 = arg0_43.displayGroups[iter0_43]
		local var2_43 = arg0_43.displayDic[var1_43]
		local var3_43 = 0

		for iter2_43, iter3_43 in ipairs(var2_43) do
			local var4_43 = iter1_43 - var3_43

			if var4_43 <= iter3_43:GetCount() then
				table.insert(var0_43, IslandTicket.New(iter3_43.id, iter3_43.endTime, var4_43))

				break
			else
				table.insert(var0_43, IslandTicket.New(iter3_43.id, iter3_43.endTime, iter3_43:GetCount()))

				var3_43 = var3_43 + iter3_43:GetCount()
			end
		end
	end

	return (underscore.select(var0_43, function(arg0_44)
		return arg0_44:GetCount() > 0
	end))
end

function var0_0.UseTickets(arg0_45)
	seriesAsync({
		function(arg0_46)
			if arg0_45.endTime - arg0_45.timeMgr:GetServerTime() <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_ticket_finished"))
			else
				arg0_46()
			end
		end,
		function(arg0_47)
			if arg0_45.endTime - arg0_45.timeMgr:GetServerTime() < arg0_45.reduceTime then
				arg0_45:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_sure_ticket_overflow"),
					onYes = arg0_47
				})
			else
				arg0_47()
			end
		end
	}, function()
		local var0_48 = arg0_45:GetSelectedTickets()

		arg0_45:emit(IslandMediator.USE_TICKETS, arg0_45.type, arg0_45.id, var0_48)
	end)
end

function var0_0.StartTimer(arg0_49)
	arg0_49.timer = Timer.New(function()
		arg0_49:UpdateTimer()
	end, 1, -1)

	arg0_49.timer:Start()
	arg0_49:UpdateTimer()
end

function var0_0.UpdateTimer(arg0_51)
	arg0_51:UpdateSliderUI()
end

function var0_0.StopTimer(arg0_52)
	if arg0_52.timer then
		arg0_52.timer:Stop()

		arg0_52.timer = nil
	end
end

function var0_0.OnHide(arg0_53)
	arg0_53:UnBlurPanel()
	arg0_53:StopTimer()
end

function var0_0.OnDisable(arg0_54)
	arg0_54:OnHide()
end

function var0_0.OnDestroy(arg0_55)
	arg0_55:OnHide()
	ClearLScrollrect(arg0_55.scrollRect)

	for iter0_55, iter1_55 in pairs(arg0_55.cards) do
		iter1_55:Dispose()
	end

	arg0_55.cards = {}
end

return var0_0
